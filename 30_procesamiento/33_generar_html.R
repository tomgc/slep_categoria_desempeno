# 33_generar_html.R
# Copyright (c) 2026 Tomás Ignacio González Cifuentes — Servicio Local de Educación Pública Costa Central
# Distribuido bajo la Licencia MIT. Ver el archivo LICENSE en la raíz del repositorio.
# La licencia cubre el código; NO cubre los datos (Agencia de Calidad). Ver LICENSE.
#
# ----------------------------------------------------------------------------
# Construye el producto final: motor_categoria.html standalone.
#
# Insumos (40_salidas/intermedios/):
#   - categoria_territorial.parquet  (distribución larga por entidad×nivel×anio×categoria)
#   - categoria_sin_vigente.parquet  (s/i por motivo, agregado territorial)
#   - categoria_rbd.parquet          (categoría por establecimiento×nivel×anio: trayectoria)
#   - establecimientos_chile.parquet (catálogo de EE)
#   - comunas_chile.parquet          (catálogo de comunas con región)
#   - sleps_chile.parquet            (catálogo de SLEPs × RBD)
#
# Salidas:
#   - 40_salidas/motor_categoria.html  (producto canónico, fuente de verdad)
#   - docs/index.html                  (copia para publicación en GitHub Pages)
#
# Flujo:
#   1. Lee los 6 parquets.
#   2. Construye el JSON: meta + catálogos + tres bloques columnares
#      (territorial, sin_vigente, rbd).
#   3. Comprime gzip + base64; el template descomprime en cliente con pako.
#   4. Reemplaza placeholders __D3_INLINE__, __PAKO_INLINE__, __JSON_DATA__.
#   5. Escribe 40_salidas/motor_categoria.html (UTF-8) y lo copia a docs/index.html.
#
# Decisiones metodológicas (sesión 3):
#   - Sin ponderación por matrícula, sin GSE: agregación = conteo de EE.
#   - Distribución territorial sobre EE categorizados (s/i va aparte).
#   - Cobertura 2016-2019; año vigente = 2019. Trayectoria sin hueco de
#     pandemia (no ocurre en el rango). Ver decisiones/.
#
# Nota (sesión 17, desacople de grado): el motor dejó de consumir el desglose
#   por grado en la sesión 16 (c.79, retiro de código muerto). Este generador
#   ya no lee matricula_rbd_grado.parquet ni embebe matricula_grado/grado_labels
#   en el JSON: era dato inerte que inflaba el peso. El parquet permanece en
#   20_insumos/ (insumo externo de slep_analisis_matricula), simplemente no se
#   consume aquí. Si se reintroduce el desglose por grado en la ficha, restaurar
#   la carga, el bloque columnar, su validación y la clave en json_root.
#
# Uso:
#   source(here::here("30_procesamiento", "33_generar_html.R"))
# ----------------------------------------------------------------------------

library(here)


# ============================================================================
# Constantes y parámetros
# ============================================================================

# Orden semántico de categorías: Insuficiente -> Alto (gobierna columnas y paleta).
CAT_ORDEN <- c("INSUFICIENTE", "MEDIO-BAJO", "MEDIO", "ALTO")

# Paleta fija de categorías (decisión sesión 3, validada AA sobre cream).
# Reutiliza tokens del head del template (mark-red, coral, mark-blue, olive).
CAT_COLORS <- list(
  "INSUFICIENTE" = "#EE2D49",  # mark-red
  "MEDIO-BAJO"   = "#E88663",  # coral
  "MEDIO"        = "#2A8FD9",  # mark-blue (azul claro)
  "ALTO"         = "#0062A0"   # ocean (azul institucional)
)

CAT_LABELS <- list(
  "INSUFICIENTE" = "Insuficiente",
  "MEDIO-BAJO"   = "Medio-Bajo",
  "MEDIO"        = "Medio",
  "ALTO"         = "Alto"
)

MOTIVO_LABELS <- list(
  "baja_matricula"    = "Baja matr\u00edcula",
  "falta_informacion" = "Falta de informaci\u00f3n"
)

# Etiquetas de dependencia administrativa (cod_depe2, estándar MINEDUC).
DEPE_LABELS <- list(
  "1" = "Municipal",
  "2" = "Particular Subvencionado",
  "3" = "Particular Pagado",
  "4" = "Corporaci\u00f3n de Administraci\u00f3n Delegada",
  "5" = "Servicio Local (SLEP)"
)

# Etiquetas de tipo de ensenanza (cod_ense2, Anexo III MINEDUC). Gobiernan el
# render de matricula por tipo en la ficha del establecimiento.
ENSE2_LABELS <- list(
  "1" = "Parvularia",
  "2" = "B\u00e1sica",
  "3" = "B\u00e1sica adultos",
  "4" = "Educaci\u00f3n especial",
  "5" = "Media HC",
  "6" = "Media adultos",
  "7" = "Media TP",
  "8" = "Media TP adultos"
)

# Mapa cod_ense2 -> nivel del motor de categoria. Solo basica (2) y media (5,7)
# tienen categoria; el resto es matricula de contexto, sin categoria asociada.
# media = 5 + 7 sumados (la Agencia categoriza "media" como nivel unico, no
# separa HC de TP): ambos codigos mapean al mismo nivel "media".
ENSE2_A_NIVEL <- list(
  "2" = "basica",
  "5" = "media",
  "7" = "media"
)

# Redondeo de pct para el JSON (4 decimales: precisión suficiente para %).
PCT_DIGITS <- 4


# ============================================================================
# Bloque 1 — Cargar insumos
# ============================================================================

message("[1] Cargando insumos...")

ruta_int <- function(f) here::here("40_salidas", "intermedios", f)

df_ter   <- arrow::read_parquet(ruta_int("categoria_territorial.parquet"))
df_sv    <- arrow::read_parquet(ruta_int("categoria_sin_vigente.parquet"))
df_rbd   <- arrow::read_parquet(ruta_int("categoria_rbd.parquet"))
df_estab <- arrow::read_parquet(ruta_int("establecimientos_chile.parquet"))
df_com   <- arrow::read_parquet(ruta_int("comunas_chile.parquet"))
df_slep  <- arrow::read_parquet(ruta_int("sleps_chile.parquet"))

# Matricula por rbd x anio x cod_ense2 (insumo agregado externo, foto historica;
# grano distinto al de categoria, por eso no se fusiona: viaja como bloque propio).
ruta_matricula <- here::here("20_insumos", "matricula_rbd_ense.parquet")
if (!file.exists(ruta_matricula)) {
  stop("Falta 20_insumos/matricula_rbd_ense.parquet. ",
       "Generarlo en slep_analisis_matricula (03_generar_matricula_rbd_ense.R) y copiarlo aqui.")
}
df_mat <- arrow::read_parquet(ruta_matricula) |>
  dplyr::mutate(
    rbd       = as.character(rbd),
    cod_ense2 = as.character(cod_ense2)
  )

message(sprintf("    categoria_territorial: %d filas", nrow(df_ter)))
message(sprintf("    categoria_sin_vigente: %d filas", nrow(df_sv)))
message(sprintf("    categoria_rbd:         %d filas", nrow(df_rbd)))
message(sprintf("    establecimientos:      %d EE", nrow(df_estab)))
message(sprintf("    comunas:               %d", nrow(df_com)))
message(sprintf("    sleps:                 %d filas (%d SLEPs)",
                nrow(df_slep), dplyr::n_distinct(df_slep$cod_slep)))
message(sprintf("    matricula_rbd_ense:    %d filas (%d RBD, anios %s)",
                nrow(df_mat), dplyr::n_distinct(df_mat$rbd),
                paste(sort(unique(df_mat$anio)), collapse = ",")))


# ============================================================================
# Bloque 2 — Meta y catálogos
# ============================================================================

message("[2] Construyendo JSON...")

anios_disp <- sort(unique(as.integer(df_ter$anio)))

# Anio vigente de matricula (tamano), separado del de categoria. La categoria
# cubre 2016-2019 (anio_vigente); la matricula viaja 2016-2025 como contexto de
# tamano. Convivencia (D19, sesion 12): el tamano vigente es el ultimo anio con
# dato de matricula; dinamico para no tocar codigo al ampliar cobertura (A17).
anios_mat <- sort(unique(as.integer(df_mat$anio)))

# Strings no-ASCII con intToUtf8() / \uXXXX para evitar bug de locale C
# (literales no-ASCII quedan con Encoding desconocido y jsonlite los rompe).
meta <- list(
  fecha_generacion = format(Sys.Date()),
  anios            = anios_disp,
  anio_vigente     = max(anios_disp),
  anio_matricula_vigente = max(anios_mat),  # tamano vigente (convivencia D19)
  niveles = list(
    "basica" = "Educaci\u00f3n B\u00e1sica",
    "media"  = "Educaci\u00f3n Media"
  ),
  categorias = CAT_ORDEN,          # orden semántico Insuficiente -> Alto
  cat_labels = CAT_LABELS,
  cat_colors = CAT_COLORS,
  motivos    = MOTIVO_LABELS,
  depe_labels = DEPE_LABELS,
  ense2_labels = ENSE2_LABELS,
  ense2_a_nivel = ENSE2_A_NIVEL
)

# --- Catálogo de comunas ---
comunas_lst <- df_com |>
  dplyr::transmute(
    cod     = as.character(cod_com_rbd),
    nom     = nom_com_rbd,
    cod_reg = as.character(cod_reg_rbd),
    nom_reg = nom_reg_rbd
  ) |>
  dplyr::arrange(nom)

# --- Catálogo de regiones (distinct) ---
regiones_lst <- df_com |>
  dplyr::distinct(cod_reg_rbd, nom_reg_rbd) |>
  dplyr::transmute(cod = as.character(cod_reg_rbd), nom = nom_reg_rbd) |>
  dplyr::arrange(as.integer(cod))

# --- Catálogo de SLEPs (una fila por SLEP × RBD) ---
sleps_lst <- df_slep |>
  dplyr::transmute(
    cod_slep      = as.character(cod_slep),
    nombre_slep   = nombre_slep,
    anio_traspaso = as.integer(anio_traspaso),
    cod_com_rbd   = as.character(cod_com_rbd),
    nom_com_rbd   = nom_com_rbd,
    rbd           = as.character(rbd),
    nom_rbd       = nom_rbd
  )

# --- Catálogo de establecimientos ---
establecimientos_lst <- df_estab |>
  dplyr::transmute(
    rbd         = as.character(rbd),
    nom_rbd     = nom_rbd,
    cod_com_rbd = as.character(cod_com_rbd),
    nom_com_rbd = nom_com_rbd,
    cod_reg_rbd = as.character(cod_reg_rbd),
    cod_depe2   = as.character(cod_depe2)
  ) |>
  dplyr::arrange(cod_com_rbd, nom_rbd)


# ============================================================================
# Bloque 3 — Bloques columnares de datos
# ============================================================================

# --- Territorial (distribución larga, solo 4 categorías reales) ---
df_ter_ord <- df_ter |>
  dplyr::mutate(
    tipo_entidad = as.character(tipo_entidad),
    cod_entidad  = as.character(cod_entidad),
    categoria    = as.character(categoria)
  ) |>
  dplyr::arrange(tipo_entidad, cod_entidad, nivel, anio, categoria)

territorial_lst <- list(
  rows            = nrow(df_ter_ord),
  tipo_entidad    = df_ter_ord$tipo_entidad,
  cod_entidad     = df_ter_ord$cod_entidad,
  nivel           = df_ter_ord$nivel,
  anio            = as.integer(df_ter_ord$anio),
  categoria       = df_ter_ord$categoria,
  n_ee            = as.integer(df_ter_ord$n_ee),
  n_categorizados = as.integer(df_ter_ord$n_categorizados),
  pct             = round(df_ter_ord$pct, PCT_DIGITS)
)

# --- Sin categoría vigente (agregado territorial, por motivo) ---
df_sv_ord <- df_sv |>
  dplyr::mutate(
    tipo_entidad = as.character(tipo_entidad),
    cod_entidad  = as.character(cod_entidad)
  ) |>
  dplyr::arrange(tipo_entidad, cod_entidad, nivel, anio, motivo_sin_categoria)

sin_vigente_lst <- list(
  rows         = nrow(df_sv_ord),
  tipo_entidad = df_sv_ord$tipo_entidad,
  cod_entidad  = df_sv_ord$cod_entidad,
  nivel        = df_sv_ord$nivel,
  anio         = as.integer(df_sv_ord$anio),
  motivo       = df_sv_ord$motivo_sin_categoria,
  n_ee         = as.integer(df_sv_ord$n_ee)
)

# --- Categoría por establecimiento (trayectoria; incluye s/i) ---
# Es la fuente de las filas de EE y sus chips de trayectoria por año.
df_rbd_ord <- df_rbd |>
  dplyr::mutate(
    rbd         = as.character(rbd),
    cod_com_rbd = as.character(cod_com_rbd),
    cod_reg_rbd = as.character(cod_reg_rbd),
    cod_depe2   = as.character(cod_depe2)
  ) |>
  dplyr::arrange(rbd, nivel, anio)

rbd_lst <- list(
  rows        = nrow(df_rbd_ord),
  rbd         = df_rbd_ord$rbd,
  nivel       = df_rbd_ord$nivel,
  anio        = as.integer(df_rbd_ord$anio),
  categoria   = df_rbd_ord$categoria,
  nom_rbd     = df_rbd_ord$nom_rbd,
  cod_com_rbd = df_rbd_ord$cod_com_rbd,
  cod_reg_rbd = df_rbd_ord$cod_reg_rbd,
  cod_depe2   = df_rbd_ord$cod_depe2,
  motivo      = df_rbd_ord$motivo_sin_categoria  # solo poblado en filas s/i (NA -> null)
)

# --- Matrícula por establecimiento × año × tipo de enseñanza ---
# Grano distinto al de categoría (cod_ense2, no nivel). El cliente cruza este
# bloque con rbd_lst: cod_ense2 2 -> categoría básica; 5,7 -> categoría media
# (sumados); el resto es matrícula de contexto sin categoría. matricula_total_ee
# es el tamaño completo del EE (todos los cod_ense2), constante por rbd×anio.
df_mat_ord <- df_mat |>
  dplyr::mutate(
    rbd       = as.character(rbd),
    cod_ense2 = as.character(cod_ense2)
  ) |>
  dplyr::arrange(rbd, anio, cod_ense2)

matricula_lst <- list(
  rows               = nrow(df_mat_ord),
  rbd                = df_mat_ord$rbd,
  anio               = as.integer(df_mat_ord$anio),
  cod_ense2          = df_mat_ord$cod_ense2,
  matricula          = as.integer(df_mat_ord$matricula),
  matricula_total_ee = as.integer(df_mat_ord$matricula_total_ee)
)


# ============================================================================
# Bloque 4 — Validación de integridad del JSON (C.8)
# ============================================================================

stopifnot(
  "territorial sin filas"  = territorial_lst$rows > 0,
  "sin_vigente sin filas"  = sin_vigente_lst$rows > 0,
  "rbd sin filas"          = rbd_lst$rows > 0,
  "categorias inesperadas en territorial" =
    all(unique(territorial_lst$categoria) %in% CAT_ORDEN),
  "niveles inesperados" =
    all(unique(territorial_lst$nivel) %in% c("basica", "media")),
  "nacional ausente" = "nacional" %in% territorial_lst$tipo_entidad
)

# Control: el conteo de filas del JSON calza con los parquets de origen.
stopifnot(
  territorial_lst$rows == nrow(df_ter),
  sin_vigente_lst$rows == nrow(df_sv),
  rbd_lst$rows         == nrow(df_rbd)
)

# Control del bloque matrícula: filas calzan, cod_ense2 en el dominio esperado,
# total del EE constante dentro de rbd×anio (no debe mezclar niveles).
stopifnot(
  "matricula sin filas" = matricula_lst$rows > 0,
  "matricula: filas no calzan con el parquet" = matricula_lst$rows == nrow(df_mat),
  "cod_ense2 fuera del dominio 1..8" =
    all(unique(matricula_lst$cod_ense2) %in% as.character(1:8))
)
chk_total_ee <- df_mat_ord |>
  dplyr::summarise(n_tot = dplyr::n_distinct(matricula_total_ee), .by = c(rbd, anio)) |>
  dplyr::filter(n_tot > 1)
stopifnot("matricula_total_ee no es constante dentro de rbd×anio" = nrow(chk_total_ee) == 0)


# ============================================================================
# Bloque 5 — Serializar y comprimir
# ============================================================================

json_root <- list(
  meta             = meta,
  regiones         = regiones_lst,
  comunas          = comunas_lst,
  sleps            = sleps_lst,
  establecimientos = establecimientos_lst,
  territorial      = territorial_lst,
  sin_vigente      = sin_vigente_lst,
  rbd              = rbd_lst,
  matricula        = matricula_lst
)

json_str <- jsonlite::toJSON(
  json_root,
  auto_unbox = TRUE,
  na         = "null",
  dataframe  = "rows",
  digits     = NA
)
json_str <- enc2utf8(json_str)

bytes_plano <- nchar(json_str, type = "bytes")
message(sprintf("    JSON listo: %d caracteres (%.1f MB sin comprimir).",
                nchar(json_str), bytes_plano / 1e6))

# Compresión gzip + base64 (mismo patrón que el madre; pako en cliente).
json_gzip <- memCompress(charToRaw(json_str), type = "gzip")
json_b64  <- gsub("\n", "", jsonlite::base64_enc(json_gzip), fixed = TRUE)

bytes_b64 <- nchar(json_b64, type = "bytes")
message(sprintf("    JSON comprimido: %.2f MB (gzip+base64, %.1f%% del plano).",
                bytes_b64 / 1e6, 100 * bytes_b64 / bytes_plano))


# ============================================================================
# Bloque 6 — Plantilla, D3 y pako
# ============================================================================

message("[3] Leyendo plantilla, D3 y pako...")

plantilla_path <- here::here("30_procesamiento", "33_motor_template.html")
d3_path        <- here::here("10_utils", "d3.min.js")
pako_path      <- here::here("10_utils", "pako.min.js")

if (!file.exists(plantilla_path)) stop("No existe la plantilla: ", plantilla_path)
if (!file.exists(d3_path)) {
  stop("No existe d3.min.js: ", d3_path,
       "\n  Descargar: curl -fsSL https://d3js.org/d3.v7.min.js -o 10_utils/d3.min.js")
}
if (!file.exists(pako_path)) {
  stop("No existe pako.min.js: ", pako_path,
       "\n  Descargar: curl -fsSL ",
       "https://cdn.jsdelivr.net/npm/pako@2.1.0/dist/pako.min.js -o 10_utils/pako.min.js")
}

plantilla <- paste(readLines(plantilla_path, encoding = "UTF-8", warn = FALSE), collapse = "\n")
d3_code   <- paste(readLines(d3_path,        encoding = "UTF-8", warn = FALSE), collapse = "\n")
pako_code <- paste(readLines(pako_path,      encoding = "UTF-8", warn = FALSE), collapse = "\n")

message(sprintf("    Plantilla: %d caracteres", nchar(plantilla)))
message(sprintf("    D3:        %.0f KB", nchar(d3_code) / 1024))
message(sprintf("    pako:      %.0f KB", nchar(pako_code) / 1024))


# ============================================================================
# Bloque 7 — Reemplazar placeholders y escribir HTML
# ============================================================================

message("[4] Construyendo HTML final...")

for (ph in c("__D3_INLINE__", "__PAKO_INLINE__", "__JSON_DATA__")) {
  if (!grepl(ph, plantilla, fixed = TRUE)) {
    stop("La plantilla no contiene el placeholder ", ph, ".")
  }
}

# fixed=TRUE: evita interpretación regex (nombres con caracteres especiales).
html <- sub("__D3_INLINE__",   d3_code,   plantilla, fixed = TRUE)
html <- sub("__PAKO_INLINE__", pako_code, html,      fixed = TRUE)
html <- sub("__JSON_DATA__",   json_b64,  html,      fixed = TRUE)

ruta_salida <- here::here("40_salidas", "motor_categoria.html")
con <- file(ruta_salida, open = "wb", encoding = "UTF-8")
writeBin(charToRaw(enc2utf8(html)), con)
close(con)

tamano_kb <- file.info(ruta_salida)$size / 1024
message(sprintf("    OK: %s (%.0f KB)",
                fs::path_rel(ruta_salida, here::here()), tamano_kb))

# --- Publicación: copia a docs/index.html para GitHub Pages ---
# docs/ es la carpeta servida por Pages (modelo B). El producto canónico vive
# en 40_salidas/; docs/index.html es una copia derivada, regenerada en cada
# corrida. Mantener una sola fuente de verdad evita divergencias.
dir_docs <- here::here("docs")
if (!dir.exists(dir_docs)) dir.create(dir_docs, recursive = TRUE)
ruta_pages <- file.path(dir_docs, "index.html")
ok_copia <- file.copy(ruta_salida, ruta_pages, overwrite = TRUE)
if (!ok_copia) stop("No se pudo copiar el HTML a docs/index.html")
message(sprintf("    OK: %s (copia para GitHub Pages)",
                fs::path_rel(ruta_pages, here::here())))

# Liberar objetos grandes antes del GC (json_str/html pueden superar varios MB).
rm(json_str, json_gzip, json_b64, html, d3_code, pako_code, plantilla)
gc(verbose = FALSE)


# ============================================================================
# Bloque 8 — Resumen
# ============================================================================

message("")
message("=== Resumen ===")
message(sprintf("  Territorial:   %d filas", territorial_lst$rows))
message(sprintf("  Sin vigente:   %d filas", sin_vigente_lst$rows))
message(sprintf("  Por EE (rbd):  %d filas", rbd_lst$rows))
message(sprintf("  Matricula:     %d filas (%d RBD)",
                matricula_lst$rows, dplyr::n_distinct(matricula_lst$rbd)))
message(sprintf("  Comunas:       %d", nrow(comunas_lst)))
message(sprintf("  Regiones:      %d", nrow(regiones_lst)))
message(sprintf("  SLEPs:         %d (%d RBDs)",
                dplyr::n_distinct(sleps_lst$cod_slep), nrow(sleps_lst)))
message(sprintf("  Establec.:     %d RBDs", nrow(establecimientos_lst)))
message(sprintf("  A\u00f1os:          %s", paste(meta$anios, collapse = ", ")))
message(sprintf("  A\u00f1o vigente:   %d", meta$anio_vigente))
message(sprintf("  A\u00f1o matr\u00edcula: %d", meta$anio_matricula_vigente))
message(sprintf("  Peso HTML:     %.0f KB", tamano_kb))
message("")
message(sprintf("33_generar_html.R: OK. Producto en %s, copia en docs/index.html",
                fs::path_rel(ruta_salida, here::here())))
