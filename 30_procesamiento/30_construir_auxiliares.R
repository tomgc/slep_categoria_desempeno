# 30_construir_auxiliares.R
# ----------------------------------------------------------------------------
# Construye los parquets auxiliares (catalogos territoriales) del proyecto
# slep_categoria_desempeno a partir del directorio oficial de establecimientos
# y el listado SLEP. Salidas en 40_salidas/intermedios/:
#
#   1. comunas_chile.parquet
#        Desde directorio_oficial_ee_publico.csv (establecimientos operativos con
#        matricula). Catalogo comuna -> region.
#
#   2. sleps_chile.parquet
#        Desde 202602_Listado_SLEP_2026_vf.xlsx + directorio oficial.
#        Una fila por SLEP x RBD. Incluye rama prospectiva (traspaso ANIO+1).
#
#   3. establecimientos_chile.parquet
#        Desde directorio_oficial_ee_publico.csv. Catalogo completo RBD -> comuna,
#        region y dependencia agrupada. Es la fuente del cruce territorial
#        de 31_leer_normalizar.R y del popup "ver establecimientos" del motor.
#
# A diferencia del proyecto madre (slep_simce_adecuado), este pipeline NO
# construye slep_cc_establecimientos.parquet (caracterizacion + flag SIMCE):
# este proyecto no segmenta por SIMCE ni usa IVE. Ese bloque se omite.
#
# Uso:
#   source(here::here("30_procesamiento", "30_construir_auxiliares.R"))
#
# Convencion: paquetes prefijados (readxl::, readr::, dplyr::, arrow::).
# Solo library(here) por uso intensivo de rutas.
# ----------------------------------------------------------------------------

library(here)

# ----------------------------------------------------------------------------
# Constantes de configuracion
# ----------------------------------------------------------------------------
# El directorio oficial es snapshot con corte al 30 de abril del anio vigente.
# Los SLEP con AGNO_TRASPASO_EDUC <= ANIO_DATOS_VIGENTE figuran con COD_DEPE == 6
# (Servicio Local) en el directorio. Los SLEP con traspaso prospectivo
# (ANIO_DATOS_VIGENTE + 1) administran sus establecimientos desde ya, pero en el
# directorio aun aparecen como municipales (COD_DEPE 1/2): se incluyen via la
# rama prospectiva de la seccion 4.2 y se marcan en el motor.
#
# Nota: ANIO_DATOS_VIGENTE refiere al anio del DIRECTORIO (2025), no al ultimo
# anio con datos de categoria de desempeno (2019). La logica de traspaso SLEP
# depende del estado actual del directorio, no del anio del dato.
ANIO_DATOS_VIGENTE <- 2025L


# ============================================================================
# Bloque 1 — Carga del directorio oficial (CSV grande)
# ============================================================================

message("[1] Leyendo directorio_oficial_ee_publico.csv...")

# Version publica del directorio (sin MRUN ni RUT_SOSTENEDOR); el crudo esta en
# .gitignore y se depura con 20_insumos/auxiliares/31_depurar_directorio_oficial.R.
ruta_directorio <- here::here(
  "20_insumos", "auxiliares", "directorio_oficial_ee_publico.csv"
)

# Separador `;`, decimal `,`, encoding UTF-8 (readr maneja BOM auto).
df_dir_raw <- readr::read_delim(
  ruta_directorio,
  delim = ";",
  locale = readr::locale(encoding = "UTF-8", decimal_mark = ","),
  show_col_types = FALSE,
  progress = FALSE
)

# Los nombres del CSV son ASCII puros (sin tildes ni n) — no requieren
# normalizacion de encoding.

# Validacion de columnas requeridas para los parquets aguas abajo.
cols_csv_esperadas <- c(
  "AGNO", "RBD", "NOM_RBD",
  "COD_COM_RBD", "NOM_COM_RBD",
  "COD_REG_RBD", "NOM_REG_RBD_A",
  "COD_DEPE", "COD_DEPE2",
  "MATRICULA", "ESTADO_ESTAB"
)
faltan_csv <- setdiff(cols_csv_esperadas, names(df_dir_raw))
stopifnot(
  "Faltan columnas en directorio_oficial_ee_publico.csv" = length(faltan_csv) == 0
)

message(sprintf(
  "    OK: %d filas leidas. Anio(s) en AGNO: %s.",
  nrow(df_dir_raw),
  paste(sort(unique(df_dir_raw$AGNO)), collapse = ", ")
))


# ============================================================================
# Bloque 2 — comunas_chile.parquet
# ============================================================================

message("[2] Construyendo comunas_chile.parquet...")

# Tabla de nombres oficiales de region (fuente: abreviaturas del CSV MINEDUC).
nombres_region <- c(
  "1"  = "Tarapaca",
  "2"  = "Antofagasta",
  "3"  = "Atacama",
  "4"  = "Coquimbo",
  "5"  = "Valparaiso",
  "6"  = "O'Higgins",
  "7"  = "Maule",
  "8"  = "Biobio",
  "9"  = "La Araucania",
  "10" = "Los Lagos",
  "11" = "Aysen",
  "12" = "Magallanes",
  "13" = "Metropolitana",
  "14" = "Los Rios",
  "15" = "Arica y Parinacota",
  "16" = "Nuble"
)

df_comunas <- df_dir_raw |>
  dplyr::filter(.data$ESTADO_ESTAB == 1, .data$MATRICULA == 1) |>
  dplyr::transmute(
    cod_com_rbd = as.character(COD_COM_RBD),
    nom_com_rbd = NOM_COM_RBD,
    cod_reg_rbd = as.character(COD_REG_RBD),
    nom_reg_rbd = dplyr::recode(
      as.character(COD_REG_RBD),
      !!!nombres_region,
      .default = NOM_REG_RBD_A
    )
  ) |>
  dplyr::distinct()

ruta_comunas <- here::here(
  "40_salidas", "intermedios", "comunas_chile.parquet"
)
arrow::write_parquet(df_comunas, ruta_comunas)

message(sprintf(
  "    OK: %d comunas unicas.",
  nrow(df_comunas)
))


# ============================================================================
# Bloque 3 — sleps_chile.parquet
# ============================================================================
# Fuente: 202602_Listado_SLEP_2026_vf.xlsx (hoja "Listado SLEP"), provisto
# por el titular. Una fila por SLEP x comuna, con COD_COM_RBD disponible. Se
# joinea con el directorio oficial para obtener los RBDs de cada SLEP.
#
# Esquema del parquet resultante (7 columnas):
#   cod_slep      character   codigo numerico del SLEP (ej. "503")
#   nombre_slep   character   nombre formateado (ej. "Costa Central")
#   anio_traspaso integer     anio en que el SLEP tomo cargo de la educacion
#   cod_com_rbd   character   codigo de comuna
#   nom_com_rbd   character   nombre de la comuna
#   rbd           character   RBD del establecimiento
#   nom_rbd       character   nombre del establecimiento
#
# Solo RBDs con COD_DEPE == 6 en directorio (ya traspasados) o COD_DEPE 1/2
# en comunas con traspaso prospectivo. El join con los datos de categoria por
# RBD garantiza cobertura historica: los mismos establecimientos existian con
# COD_DEPE 1/2 antes del traspaso.

message("[3] Construyendo sleps_chile.parquet...")

# ---- 3.1 Leer hoja Listado SLEP ----
ruta_sleps <- here::here(
  "20_insumos", "auxiliares", "202602_Listado_SLEP_2026_vf.xlsx"
)

df_sleps_raw <- readxl::read_excel(
  ruta_sleps,
  sheet = "Listado SLEP",
  col_types = "text"
)

cols_slep_req <- c(
  "COD_SLEP", "NOMBRE_SLEP_FORMATO", "AGNO_TRASPASO_EDUC", "COD_COM_RBD"
)
faltan_slep <- setdiff(cols_slep_req, names(df_sleps_raw))
stopifnot(
  "Faltan columnas en 202602_Listado_SLEP_2026_vf.xlsx" =
    length(faltan_slep) == 0
)

df_slep_comunas <- df_sleps_raw |>
  dplyr::transmute(
    cod_slep      = as.character(COD_SLEP),
    nombre_slep   = NOMBRE_SLEP_FORMATO,
    anio_traspaso = suppressWarnings(as.integer(AGNO_TRASPASO_EDUC)),
    cod_com_rbd   = as.character(COD_COM_RBD)
  ) |>
  dplyr::distinct()

message(sprintf(
  "    Listado SLEP leido: %d SLEPs, %d combinaciones SLEP x comuna.",
  dplyr::n_distinct(df_slep_comunas$cod_slep),
  nrow(df_slep_comunas)
))

# ---- 3.2 Join con directorio para obtener RBDs ----
# Dos ramas segun el anio de traspaso de cada SLEP:
#
# (a) SLEP ya traspasados (anio_traspaso <= ANIO_DATOS_VIGENTE): sus
#     establecimientos figuran con COD_DEPE == 6 en el directorio.
#
# (b) SLEP con traspaso prospectivo (anio_traspaso == ANIO_DATOS_VIGENTE + 1):
#     administran desde ya, pero en el directorio aun aparecen como municipales
#     (COD_DEPE 1 = Corp. Municipal, 2 = DAEM). Se incluyen para que el SLEP
#     pueda hacer diagnostico sobre los establecimientos que ya administra.
#
# SLEP con anio_traspaso > ANIO_DATOS_VIGENTE + 1 NO se incluyen.

comunas_traspasadas <- df_slep_comunas |>
  dplyr::filter(.data$anio_traspaso <= ANIO_DATOS_VIGENTE) |>
  dplyr::pull(cod_com_rbd) |>
  unique()

comunas_prospectivas <- df_slep_comunas |>
  dplyr::filter(.data$anio_traspaso == ANIO_DATOS_VIGENTE + 1L) |>
  dplyr::pull(cod_com_rbd) |>
  unique()

# RBDs publicos: depe 6 en comunas ya traspasadas, o depe 1/2 (municipal) en
# comunas con traspaso prospectivo. Un mismo RBD se asigna por su comuna.
df_dir_slep <- df_dir_raw |>
  dplyr::filter(
    .data$ESTADO_ESTAB == 1,
    .data$MATRICULA == 1
  ) |>
  dplyr::mutate(cod_com_rbd = as.character(COD_COM_RBD)) |>
  dplyr::filter(
    (.data$COD_DEPE == 6 & .data$cod_com_rbd %in% comunas_traspasadas) |
      (.data$COD_DEPE %in% c(1, 2) & .data$cod_com_rbd %in% comunas_prospectivas)
  ) |>
  dplyr::transmute(
    cod_com_rbd = cod_com_rbd,
    rbd         = as.character(RBD),
    nom_rbd     = NOM_RBD
  )

# Expandir SLEP x comuna a SLEP x RBD mediante inner_join. El inner_join
# descarta automaticamente los SLEP con traspaso demasiado futuro, porque sus
# comunas no tienen RBDs en df_dir_slep.
df_sleps <- dplyr::inner_join(
  df_slep_comunas,
  df_dir_slep,
  by = "cod_com_rbd"
) |>
  dplyr::left_join(
    dplyr::select(df_comunas, cod_com_rbd, nom_com_rbd),
    by = "cod_com_rbd"
  ) |>
  dplyr::select(
    cod_slep, nombre_slep, anio_traspaso,
    cod_com_rbd, nom_com_rbd,
    rbd, nom_rbd
  ) |>
  dplyr::arrange(cod_slep, cod_com_rbd, rbd)

if (nrow(df_sleps) == 0) {
  stop("Join SLEP x directorio devolvio 0 filas. Verificar cod_com_rbd.")
}

n_prospectivos <- dplyr::n_distinct(
  df_sleps$cod_slep[df_sleps$anio_traspaso == ANIO_DATOS_VIGENTE + 1L]
)

message(sprintf(
  "    OK: %d SLEPs - %d comunas - %d establecimientos.",
  dplyr::n_distinct(df_sleps$cod_slep),
  dplyr::n_distinct(df_sleps$cod_com_rbd),
  dplyr::n_distinct(df_sleps$rbd)
))
message(sprintf(
  "    Incluye %d SLEP(s) con traspaso prospectivo %d (RBDs municipales).",
  n_prospectivos, ANIO_DATOS_VIGENTE + 1L
))

# Sanity check Costa Central.
cc_check <- df_sleps |>
  dplyr::filter(nombre_slep == "Costa Central") |>
  dplyr::distinct(nom_com_rbd)
message(sprintf(
  "    Costa Central: %d comunas (%s).",
  nrow(cc_check),
  paste(cc_check$nom_com_rbd, collapse = ", ")
))

# ---- 3.3 Escritura ----
ruta_sleps_out <- here::here(
  "40_salidas", "intermedios", "sleps_chile.parquet"
)
arrow::write_parquet(df_sleps, ruta_sleps_out)

message(sprintf(
  "    OK: %d filas escritas en %s.",
  nrow(df_sleps),
  fs::path_rel(ruta_sleps_out, here::here())
))


# ============================================================================
# Bloque 4 — establecimientos_chile.parquet
# ============================================================================
# Catalogo completo de establecimientos con nombre, comuna, region y
# dependencia. Fuente: directorio_oficial_ee_publico.csv (df_dir_raw, ya cargado).
# Incluye todos los establecimientos operativos con matricula, independiente
# de su dependencia. Es la fuente del cruce RBD -> territorio de
# 31_leer_normalizar.R y del popup "ver establecimientos" del motor.
#
# Esquema (6 columnas):
#   rbd           character   RBD del establecimiento
#   nom_rbd       character   nombre del establecimiento
#   cod_com_rbd   character   codigo de comuna
#   nom_com_rbd   character   nombre de la comuna
#   cod_reg_rbd   character   codigo de region
#   cod_depe2     character   dependencia agrupada (1-5)

message("[4] Construyendo establecimientos_chile.parquet...")

df_establecimientos <- df_dir_raw |>
  dplyr::filter(.data$ESTADO_ESTAB == 1, .data$MATRICULA == 1) |>
  dplyr::transmute(
    rbd         = as.character(RBD),
    nom_rbd     = NOM_RBD,
    cod_com_rbd = as.character(COD_COM_RBD),
    nom_com_rbd = NOM_COM_RBD,
    cod_reg_rbd = as.character(COD_REG_RBD),
    cod_depe2   = as.character(COD_DEPE2)
  ) |>
  dplyr::distinct() |>
  dplyr::arrange(cod_com_rbd, nom_rbd)

# Validacion: RBD debe ser llave unica en el catalogo (snapshot 2025).
rbd_dups <- df_establecimientos |>
  dplyr::count(rbd, name = "n") |>
  dplyr::filter(.data$n > 1)
if (nrow(rbd_dups) > 0) {
  warning(sprintf(
    "%d RBDs duplicados en establecimientos_chile (esperado: 0 en snapshot unico). Muestra:",
    nrow(rbd_dups)
  ))
  print(utils::head(rbd_dups, 10))
} else {
  message("    OK: RBD es llave unica (sin duplicados).")
}

ruta_estab_chile <- here::here(
  "40_salidas", "intermedios", "establecimientos_chile.parquet"
)
arrow::write_parquet(df_establecimientos, ruta_estab_chile)

message(sprintf(
  "    OK: %d establecimientos (%d comunas, %d dependencias distintas).",
  nrow(df_establecimientos),
  dplyr::n_distinct(df_establecimientos$cod_com_rbd),
  dplyr::n_distinct(df_establecimientos$cod_depe2)
))


# ============================================================================
# Resumen final
# ============================================================================

message("")
message("=== Resumen ===")
message(sprintf("  comunas_chile.parquet:          %d filas", nrow(df_comunas)))
message(sprintf("  sleps_chile.parquet:            %d filas", nrow(df_sleps)))
message(sprintf("  establecimientos_chile.parquet: %d filas", nrow(df_establecimientos)))
message("")
message("30_construir_auxiliares.R: OK.")
