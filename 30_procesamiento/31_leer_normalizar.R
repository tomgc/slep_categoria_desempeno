# 31_leer_normalizar.R
# ----------------------------------------------------------------------------
# Lee los 7 xlsx de Categoria de Desempeno en 20_insumos/ (cdb 2016-2019,
# cdm 2017-2019), normaliza la categoria a 5 valores, cruza con el directorio
# oficial para recuperar territorio y dependencia, y emite el parquet unico:
#
#   40_salidas/intermedios/categoria_rbd.parquet
#
# Esquema final (9 columnas):
#   anio                  integer    2016-2019 (basica) / 2017-2019 (media)
#   nivel                 character  "basica" | "media"
#   rbd                   character
#   categoria             character  ALTO | MEDIO | MEDIO-BAJO | INSUFICIENTE | s/i
#   motivo_sin_categoria  character  "baja_matricula" | "falta_informacion" | NA
#   nom_rbd               character  nombre desde directorio (NA si sin match)
#   cod_com_rbd           character  comuna desde directorio (NA si sin match)
#   cod_reg_rbd           character  region desde directorio (NA si sin match)
#   cod_depe2             character  dependencia agrupada (NA si sin match)
#
# Llave del dato: rbd x nivel x anio (una fila por combinacion). Los niveles
# basica y media NUNCA se mezclan (invariante 0).
#
# Lectura por HEADER, jamas por posicion. Los 7 archivos tienen dos ordenes
# de columnas distintos (esquema A: 2016-2018; esquema B: 2019), pero todos
# con headers correctos. clean_names() + seleccion por nombre resuelve ambos.
#
# RBDs sin match en el directorio (EE cerrado en 2025, ausente del snapshot)
# NO se descartan: se marcan con sin_match_directorio implicito (territorio NA)
# y se reportan. El dato de categoria se conserva.
#
# Uso:
#   source(here::here("30_procesamiento", "31_leer_normalizar.R"))
#
# Convencion: paquetes prefijados. library() solo para here y fs.
# ----------------------------------------------------------------------------

library(here)
library(fs)


# ============================================================================
# Constantes y parametros
# ============================================================================

# Cobertura esperada por nivel (traspaso v01, seccion 9).
ANIOS_BASICA <- 2016:2019
ANIOS_MEDIA  <- 2017:2019

# Mapeo de categoria cruda -> categoria normalizada (5 valores).
# Decision 4: MEDIO-BAJO (NUEVO) colapsa en MEDIO-BAJO (antiguedad del EE, no
# un nivel de desempeno distinto).
# Decision 5: las dos SIN CATEGORIA se unifican en s/i; el motivo se preserva
# en columna auxiliar motivo_sin_categoria.
CAT_VALIDAS <- c("ALTO", "MEDIO", "MEDIO-BAJO", "INSUFICIENTE", "s/i")


# ============================================================================
# Bloque 0 — Mapa RBD -> territorio + dependencia (desde directorio)
# ============================================================================
# Fuente de verdad territorial: establecimientos_chile.parquet (snapshot 2025,
# construido en 30_construir_auxiliares.R). RBD es llave unica alli.

message("[0] Cargando mapa RBD -> territorio desde establecimientos_chile.parquet...")

ruta_estab <- here::here(
  "40_salidas", "intermedios", "establecimientos_chile.parquet"
)
if (!file.exists(ruta_estab)) {
  stop(
    "Falta establecimientos_chile.parquet. Corre antes 30_construir_auxiliares.R."
  )
}

df_estab <- arrow::read_parquet(ruta_estab) |>
  dplyr::mutate(rbd = as.character(rbd))

message(sprintf("    OK: %d establecimientos en el directorio.", nrow(df_estab)))


# ============================================================================
# Bloque 1 — Manifiesto de archivos esperados
# ============================================================================

message("[1] Construyendo manifiesto de xlsx...")

# Patron de nombre: cdb<anio>.xlsx (basica) | cdm<anio>.xlsx (media).
patron_archivo <- "^cd(b|m)_(\\d{4})\\.xlsx$"

paths <- fs::dir_ls(here::here("20_insumos"), glob = "*.xlsx")
nombres <- basename(paths)
m <- regmatches(nombres, regexec(patron_archivo, nombres))

manifiesto <- tibble::tibble(
  path    = as.character(paths),
  archivo = nombres,
  nivel   = vapply(m, function(x) if (length(x) >= 2) {
    if (x[2] == "b") "basica" else "media"
  } else NA_character_, character(1)),
  anio    = vapply(m, function(x) if (length(x) >= 3) as.integer(x[3]) else NA_integer_,
                   integer(1))
)

# Conservar solo los que parsean (ignora otros xlsx en la carpeta, p. ej.
# auxiliares mal ubicados).
manifiesto <- manifiesto[!is.na(manifiesto$nivel) & !is.na(manifiesto$anio), ]

# Validar cobertura esperada.
basica_presentes <- sort(manifiesto$anio[manifiesto$nivel == "basica"])
media_presentes  <- sort(manifiesto$anio[manifiesto$nivel == "media"])
faltan_basica <- setdiff(ANIOS_BASICA, basica_presentes)
faltan_media  <- setdiff(ANIOS_MEDIA,  media_presentes)
if (length(faltan_basica) > 0) {
  stop(sprintf("Basica: faltan anios %s", paste(faltan_basica, collapse = ", ")))
}
if (length(faltan_media) > 0) {
  stop(sprintf("Media: faltan anios %s", paste(faltan_media, collapse = ", ")))
}

message(sprintf(
  "    OK: %d archivos detectados (basica %s; media %s).",
  nrow(manifiesto),
  paste(basica_presentes, collapse = ","),
  paste(media_presentes, collapse = ",")
))


# ============================================================================
# Bloque 2 — Normalizacion de categoria
# ============================================================================

# Separa la categoria normalizada del motivo de "sin categoria".
# Devuelve un tibble de 2 columnas alineado fila a fila con x.
normalizar_categoria <- function(x) {
  x_chr <- trimws(as.character(x))

  categoria <- dplyr::case_when(
    x_chr == "MEDIO-BAJO (NUEVO)"                        ~ "MEDIO-BAJO",
    stringr::str_starts(x_chr, "SIN CATEGORIA")          ~ "s/i",
    TRUE                                                  ~ x_chr
  )

  motivo <- dplyr::case_when(
    stringr::str_detect(x_chr, "BAJA MATRICULA")         ~ "baja_matricula",
    stringr::str_detect(x_chr, "FALTA DE INFORMACI")     ~ "falta_informacion",
    TRUE                                                  ~ NA_character_
  )

  tibble::tibble(categoria = categoria, motivo_sin_categoria = motivo)
}


# ============================================================================
# Bloque 3 — Lectura y normalizacion de un xlsx
# ============================================================================

leer_un_cd <- function(path, nivel, anio, archivo) {

  crudo <- readxl::read_excel(path) |> janitor::clean_names()

  # Localizar la columna de categoria por prefijo (trae el anio embebido:
  # categoria_desempeno_2016, ..._2019). Lectura por NOMBRE, no por posicion.
  col_cat <- names(crudo)[stringr::str_detect(names(crudo), "^categoria_desempeno")]
  if (length(col_cat) != 1) {
    stop(sprintf(
      "%s: se esperaba exactamente 1 columna categoria_desempeno_*, hay %d (%s).",
      archivo, length(col_cat), paste(col_cat, collapse = ", ")
    ))
  }
  if (!"rbd" %in% names(crudo)) {
    stop(sprintf("%s: falta la columna rbd.", archivo))
  }

  cat_norm <- normalizar_categoria(crudo[[col_cat]])

  tibble::tibble(
    anio                 = as.integer(anio),
    nivel                = nivel,
    rbd                  = as.character(crudo$rbd),
    categoria            = cat_norm$categoria,
    motivo_sin_categoria = cat_norm$motivo_sin_categoria
  )
}


# ============================================================================
# Bloque 4 — Iterar sobre los 7 archivos
# ============================================================================

message("[2] Procesando 7 xlsx (lectura por header)...")

df_cat <- purrr::pmap_dfr(
  manifiesto[, c("path", "nivel", "anio", "archivo")],
  function(path, nivel, anio, archivo) {
    df <- leer_un_cd(path, nivel, anio, archivo)
    message(sprintf(
      "    %s (%s/%d) — %d EE.",
      archivo, nivel, anio, nrow(df)
    ))
    df
  }
)


# ============================================================================
# Bloque 5 — Cruce con directorio (territorio + dependencia)
# ============================================================================
# left_join por rbd. RBDs sin match (EE cerrado, ausente del snapshot 2025)
# conservan categoria pero quedan con territorio NA. NO se descartan.

message("[3] Cruzando con directorio (RBD -> territorio)...")

df_cat <- df_cat |>
  dplyr::left_join(
    dplyr::select(df_estab, rbd, nom_rbd, cod_com_rbd, cod_reg_rbd, cod_depe2),
    by = "rbd"
  )

# Orden de columnas final.
df_cat <- df_cat[, c(
  "anio", "nivel", "rbd", "categoria", "motivo_sin_categoria",
  "nom_rbd", "cod_com_rbd", "cod_reg_rbd", "cod_depe2"
)]


# ============================================================================
# Bloque 6 — Validaciones globales
# ============================================================================

message("[4] Validaciones globales...")

# 6.1 — categoria dentro del universo esperado.
cat_anomalas <- setdiff(unique(df_cat$categoria), CAT_VALIDAS)
if (length(cat_anomalas) > 0) {
  warning(sprintf(
    "categoria con valores inesperados: %s (esperados: %s).",
    paste(cat_anomalas, collapse = ", "),
    paste(CAT_VALIDAS, collapse = ", ")
  ))
} else {
  message("    OK: categoria in {ALTO, MEDIO, MEDIO-BAJO, INSUFICIENTE, s/i}.")
}

# 6.2 — Llave rbd x nivel x anio unica (una fila por combinacion).
dups <- df_cat |>
  dplyr::count(anio, nivel, rbd, name = "n") |>
  dplyr::filter(.data$n > 1)
if (nrow(dups) > 0) {
  warning(sprintf(
    "%d combinaciones (anio,nivel,rbd) con > 1 fila (esperado: 0). Muestra:",
    nrow(dups)
  ))
  print(utils::head(dups, 10))
} else {
  message("    OK: rbd x nivel x anio es llave unica.")
}

# 6.3 — motivo_sin_categoria solo presente cuando categoria == s/i, y siempre
# presente en ese caso.
incoherencia_motivo <- df_cat |>
  dplyr::filter(
    (categoria == "s/i" & is.na(motivo_sin_categoria)) |
      (categoria != "s/i" & !is.na(motivo_sin_categoria))
  )
if (nrow(incoherencia_motivo) > 0) {
  warning(sprintf(
    "%d filas con motivo_sin_categoria incoherente respecto a categoria.",
    nrow(incoherencia_motivo)
  ))
} else {
  message("    OK: motivo_sin_categoria coherente con categoria == s/i.")
}

# 6.4 — RBDs sin match en directorio (reporte, no error).
n_sin_match <- sum(is.na(df_cat$cod_com_rbd))
message(sprintf(
  "    RBDs sin match en directorio: %d filas (%.1f%%) — territorio NA, dato conservado.",
  n_sin_match, 100 * n_sin_match / nrow(df_cat)
))
if (n_sin_match > 0) {
  sin_match_rbds <- df_cat |>
    dplyr::filter(is.na(cod_com_rbd)) |>
    dplyr::distinct(rbd, nivel, anio)
  message(sprintf(
    "      %d RBDs distintos sin match. Muestra:",
    dplyr::n_distinct(sin_match_rbds$rbd)
  ))
  print(utils::head(sin_match_rbds, 10))
}

# 6.5 — NAs en columnas criticas del dato (no del territorio).
n_cat_na <- sum(is.na(df_cat$categoria))
n_rbd_na <- sum(is.na(df_cat$rbd))
message(sprintf("    NAs criticos: categoria %d, rbd %d.", n_cat_na, n_rbd_na))


# ============================================================================
# Bloque 7 — Escritura del parquet
# ============================================================================

message("[5] Escribiendo categoria_rbd.parquet...")

ruta_salida <- here::here("40_salidas", "intermedios", "categoria_rbd.parquet")
arrow::write_parquet(df_cat, ruta_salida)

message(sprintf(
  "    OK: %d filas escritas en %s.",
  nrow(df_cat),
  fs::path_rel(ruta_salida, here::here())
))


# ============================================================================
# Bloque 8 — Resumen final
# ============================================================================

message("")
message("=== Resumen: EE por (nivel x anio) ===")
resumen <- df_cat |>
  dplyr::count(nivel, anio, name = "n_ee") |>
  dplyr::arrange(nivel, anio)
print(resumen, n = Inf)

message("")
message("=== Distribucion de categoria (global) ===")
dist_cat <- df_cat |>
  dplyr::count(categoria, name = "n") |>
  dplyr::arrange(dplyr::desc(n))
print(dist_cat, n = Inf)

message("")
message(sprintf(
  "31_leer_normalizar.R: OK. Total %d filas en categoria_rbd.parquet (9 columnas).",
  nrow(df_cat)
))
