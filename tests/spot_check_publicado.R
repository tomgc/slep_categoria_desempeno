# tests/spot_check_publicado.R
# ----------------------------------------------------------------------------
# Spot-check de extremo a extremo (protocolo 4.5, tercer componente).
#
# A diferencia de auditar_cifras.R (que compara cache vs recalculo a nivel de
# parquet), este script cierra el ultimo eslabon: verifica que cifras puntuales
# calculadas desde el crudo coincidan con las que viajan DENTRO del HTML
# publicado (docs/index.html), descomprimiendo el JSON embebido. Es la red de
# seguridad rapida: si el motor publicado mostrara una cifra distinta a la del
# parquet, aqui se detecta.
#
# Verifica un CONJUNTO de celdas ancla (DT-spot-check-cobertura). El JSON
# embebido se extrae y descomprime una sola vez; cada celda se evalua en
# memoria. No reemplaza la auditoria completa (F1-F4 a nivel parquet); la
# complementa cerrando el tramo parquet -> JSON -> HTML en varios puntos.
#
# Alcance: celdas de tipo "slep" (el cod_entidad se resuelve por nombre via el
# parquet de sleps). Otros tipos (nacional, comuna, region) requieren mapas que
# este script no carga; quedan como extension futura. La auditoria F1-F4 ya
# cubre TODAS las cifras a nivel parquet para todos los tipos; este spot-check
# solo cierra el ultimo tramo en un conjunto representativo.
#
# Uso:
#   source(here::here("tests", "spot_check_publicado.R"))
# ----------------------------------------------------------------------------

library(here)

# --- Celdas ancla a verificar (lista de constantes nombradas) ---------------
# Cobertura representativa: ambos niveles (basica/media), extremos del rango
# temporal (2016 y 2019) y varias categorias. Todas de tipo "slep".
SPOT_CELDAS <- list(
  list(tipo = "slep", nom = "Costa Central", nivel = "basica", anio = 2019L, categoria = "MEDIO"),
  list(tipo = "slep", nom = "Costa Central", nivel = "basica", anio = 2019L, categoria = "INSUFICIENTE"),
  list(tipo = "slep", nom = "Costa Central", nivel = "basica", anio = 2016L, categoria = "MEDIO"),
  list(tipo = "slep", nom = "Costa Central", nivel = "media",  anio = 2019L, categoria = "MEDIO"),
  list(tipo = "slep", nom = "Costa Central", nivel = "media",  anio = 2019L, categoria = "ALTO"),
  list(tipo = "slep", nom = "Costa Central", nivel = "media",  anio = 2019L, categoria = "INSUFICIENTE")
)

SPOT_CAT_REALES <- c("ALTO", "MEDIO", "MEDIO-BAJO", "INSUFICIENTE")


# ============================================================================
# Paso 0 — Cargar insumos una sola vez (crudo + JSON publicado)
# ============================================================================

message("[0] Cargando crudo y JSON publicado (una sola vez)...")

dir_int <- here::here("40_salidas", "intermedios")
df_cat  <- arrow::read_parquet(file.path(dir_int, "categoria_rbd.parquet")) |>
  dplyr::mutate(rbd = as.character(rbd))
df_slep <- arrow::read_parquet(file.path(dir_int, "sleps_chile.parquet")) |>
  dplyr::mutate(rbd = as.character(rbd))

mapa_slep <- df_slep |>
  dplyr::distinct(rbd, cod_slep, nombre_slep)

# Extraer el JSON embebido en docs/index.html (atob(base64(gzip(json)))).
ruta_html <- here::here("docs", "index.html")
if (!file.exists(ruta_html)) {
  stop("No existe docs/index.html. Corre run_all() (paso 33) antes del spot-check.")
}

html <- paste(readLines(ruta_html, encoding = "UTF-8", warn = FALSE), collapse = "\n")

m <- regmatches(html, regexpr('atob\\("[A-Za-z0-9+/=]+"\\)', html))
if (length(m) == 0) {
  stop("No se encontro el payload atob(...) en el HTML. ",
       "El template pudo cambiar de mecanismo de inyeccion.")
}
b64 <- sub('^atob\\("', "", m)
b64 <- sub('"\\)$', "", b64)

json_raw <- memDecompress(jsonlite::base64_dec(b64), type = "gzip")
json     <- jsonlite::fromJSON(rawToChar(json_raw))
ter      <- json$territorial   # bloque columnar: vectores paralelos


# ============================================================================
# Funciones de verificacion por celda (camino independiente)
# ============================================================================

# Cifra esperada desde el crudo para una celda de tipo "slep".
spot_esperado_slep <- function(celda) {
  base <- df_cat |>
    dplyr::inner_join(mapa_slep, by = "rbd") |>
    dplyr::filter(
      .data$nombre_slep == celda$nom,
      .data$nivel == celda$nivel,
      .data$anio == celda$anio,
      .data$categoria %in% SPOT_CAT_REALES
    )

  n_ee <- base |>
    dplyr::filter(.data$categoria == celda$categoria) |>
    dplyr::summarise(n = dplyr::n()) |>
    dplyr::pull(n)
  n_ee <- if (length(n_ee) == 0) 0L else as.integer(n_ee)

  list(n_ee = n_ee, n_cat = nrow(base))
}

# Cifra publicada desde el JSON embebido para una celda de tipo "slep".
spot_publicado_slep <- function(celda) {
  cod_objetivo <- mapa_slep |>
    dplyr::filter(.data$nombre_slep == celda$nom) |>
    dplyr::distinct(cod_slep) |>
    dplyr::pull(cod_slep) |>
    as.character()

  idx <- which(
    ter$tipo_entidad == celda$tipo &
    ter$nivel == celda$nivel &
    ter$anio == celda$anio &
    ter$categoria == celda$categoria
  )
  idx <- idx[ter$cod_entidad[idx] %in% cod_objetivo]

  if (length(idx) != 1) {
    stop(sprintf("Se esperaba 1 celda publicada, se hallaron %d (%s/%s/%d/%s).",
                 length(idx), celda$nom, celda$nivel, celda$anio, celda$categoria))
  }

  list(
    n_ee  = as.integer(ter$n_ee[idx]),
    n_cat = as.integer(ter$n_categorizados[idx])
  )
}


# ============================================================================
# Paso 1 — Recorrer las celdas ancla
# ============================================================================

message(sprintf("[1] Verificando %d celdas ancla (crudo vs publicado)...",
                length(SPOT_CELDAS)))

fallas <- character(0)

for (celda in SPOT_CELDAS) {
  etiqueta <- sprintf("%s/%s/%d/%s",
                      celda$nom, celda$nivel, celda$anio, celda$categoria)

  esp <- spot_esperado_slep(celda)
  pub <- spot_publicado_slep(celda)

  ok_n_ee  <- esp$n_ee  == pub$n_ee
  ok_n_cat <- esp$n_cat == pub$n_cat

  if (ok_n_ee && ok_n_cat) {
    message(sprintf("    OK    %-45s n_ee=%d  n_cat=%d",
                    etiqueta, pub$n_ee, pub$n_cat))
  } else {
    message(sprintf("    FALLA %-45s crudo(n_ee=%d,n_cat=%d) != pub(n_ee=%d,n_cat=%d)",
                    etiqueta, esp$n_ee, esp$n_cat, pub$n_ee, pub$n_cat))
    fallas <- c(fallas, etiqueta)
  }
}


# ============================================================================
# Paso 2 — Veredicto agregado
# ============================================================================

message("")
if (length(fallas) == 0) {
  message(sprintf("=== SPOT-CHECK OK: las %d celdas publicadas coinciden con el crudo. ===",
                  length(SPOT_CELDAS)))
} else {
  stop(sprintf("SPOT-CHECK FALLA: %d de %d celdas no coinciden -> %s",
               length(fallas), length(SPOT_CELDAS),
               paste(fallas, collapse = "; ")))
}
