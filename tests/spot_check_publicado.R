# tests/spot_check_publicado.R
# ----------------------------------------------------------------------------
# Spot-check de extremo a extremo (protocolo 4.5, tercer componente).
#
# A diferencia de auditar_cifras.R (que compara cache vs recalculo a nivel de
# parquet), este script cierra el ultimo eslabon: verifica que una cifra
# puntual calculada desde el crudo coincida con la que viaja DENTRO del HTML
# publicado (docs/index.html), descomprimiendo el JSON embebido. Es la red de
# seguridad rapida: si el motor publicado mostrara una cifra distinta a la del
# parquet, aqui se detecta.
#
# Verifica una sola celda ancla (configurable) para mantenerlo barato. No
# reemplaza la auditoria completa; la complementa cerrando el tramo
# parquet -> JSON -> HTML que la auditoria de parquets no cubre.
#
# Uso:
#   source(here::here("tests", "spot_check_publicado.R"))
# ----------------------------------------------------------------------------

library(here)

# --- Celda ancla a verificar (constantes nombradas) -------------------------
SPOT_TIPO      <- "slep"
SPOT_NOM       <- "Costa Central"
SPOT_NIVEL     <- "basica"
SPOT_ANIO      <- 2019L
SPOT_CATEGORIA <- "MEDIO"     # cualquiera de las 4 reales


# ============================================================================
# Paso 1 — Cifra esperada desde el crudo (camino independiente)
# ============================================================================

message("[1] Calculando cifra esperada desde el crudo...")

dir_int <- here::here("40_salidas", "intermedios")
df_cat  <- arrow::read_parquet(file.path(dir_int, "categoria_rbd.parquet")) |>
  dplyr::mutate(rbd = as.character(rbd))
df_slep <- arrow::read_parquet(file.path(dir_int, "sleps_chile.parquet")) |>
  dplyr::mutate(rbd = as.character(rbd))

mapa_slep <- df_slep |>
  dplyr::distinct(rbd, cod_slep, nombre_slep)

celda <- df_cat |>
  dplyr::inner_join(mapa_slep, by = "rbd") |>
  dplyr::filter(
    .data$nombre_slep == SPOT_NOM,
    .data$nivel == SPOT_NIVEL,
    .data$anio == SPOT_ANIO,
    .data$categoria %in% c("ALTO", "MEDIO", "MEDIO-BAJO", "INSUFICIENTE")
  )

n_ee_esp <- celda |>
  dplyr::filter(.data$categoria == SPOT_CATEGORIA) |>
  dplyr::summarise(n = dplyr::n()) |>
  dplyr::pull(n)
n_ee_esp <- if (length(n_ee_esp) == 0) 0L else as.integer(n_ee_esp)
n_cat_esp <- nrow(celda)

message(sprintf("    Esperado (crudo): %s/%s/%d/%s -> n_ee = %d, n_categorizados = %d",
                SPOT_NOM, SPOT_NIVEL, SPOT_ANIO, SPOT_CATEGORIA,
                n_ee_esp, n_cat_esp))


# ============================================================================
# Paso 2 — Cifra publicada: extraer el JSON embebido en docs/index.html
# ============================================================================

message("[2] Extrayendo el JSON embebido del HTML publicado...")

ruta_html <- here::here("docs", "index.html")
if (!file.exists(ruta_html)) {
  stop("No existe docs/index.html. Corre run_all() (paso 33) antes del spot-check.")
}

html <- paste(readLines(ruta_html, encoding = "UTF-8", warn = FALSE), collapse = "\n")

# El payload viaja como atob("...") en el template (base64 del gzip del JSON).
m <- regmatches(html, regexpr('atob\\("[A-Za-z0-9+/=]+"\\)', html))
if (length(m) == 0) {
  stop("No se encontro el payload atob(...) en el HTML. ",
       "El template pudo cambiar de mecanismo de inyeccion.")
}
b64 <- sub('^atob\\("', "", m)
b64 <- sub('"\\)$', "", b64)

json_raw <- memDecompress(jsonlite::base64_dec(b64), type = "gzip")
json <- jsonlite::fromJSON(rawToChar(json_raw))

# El bloque territorial es columnar: vectores paralelos.
ter <- json$territorial
idx <- which(
  ter$tipo_entidad == SPOT_TIPO &
  ter$nivel == SPOT_NIVEL &
  ter$anio == SPOT_ANIO &
  ter$categoria == SPOT_CATEGORIA
)

# Resolver el cod_entidad del SLEP por su nombre (el territorial trae cod, no nombre).
cod_objetivo <- mapa_slep |>
  dplyr::filter(.data$nombre_slep == SPOT_NOM) |>
  dplyr::distinct(cod_slep) |>
  dplyr::pull(cod_slep) |>
  as.character()

idx <- idx[ter$cod_entidad[idx] %in% cod_objetivo]

if (length(idx) != 1) {
  stop(sprintf("Se esperaba 1 celda publicada, se hallaron %d.", length(idx)))
}

n_ee_pub  <- as.integer(ter$n_ee[idx])
n_cat_pub <- as.integer(ter$n_categorizados[idx])

message(sprintf("    Publicado (HTML): n_ee = %d, n_categorizados = %d",
                n_ee_pub, n_cat_pub))


# ============================================================================
# Paso 3 — Veredicto
# ============================================================================

ok_n_ee  <- n_ee_esp  == n_ee_pub
ok_n_cat <- n_cat_esp == n_cat_pub

message("")
if (ok_n_ee && ok_n_cat) {
  message(sprintf("=== SPOT-CHECK OK: la cifra publicada coincide con el crudo (%s/%s/%d/%s). ===",
                  SPOT_NOM, SPOT_NIVEL, SPOT_ANIO, SPOT_CATEGORIA))
} else {
  stop(sprintf(
    "SPOT-CHECK FALLA: crudo (n_ee=%d, n_cat=%d) != publicado (n_ee=%d, n_cat=%d).",
    n_ee_esp, n_cat_esp, n_ee_pub, n_cat_pub
  ))
}
