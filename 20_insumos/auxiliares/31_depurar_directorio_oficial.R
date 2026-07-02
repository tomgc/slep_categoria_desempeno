# ==============================================================================
# 31_depurar_directorio_oficial.R
# ------------------------------------------------------------------------------
# Proyecto  : slep_categoria_desempeno
# Proposito : Depurar el directorio oficial de establecimientos (Mineduc),
#             eliminando columnas con datos personales identificables (PII) antes
#             de versionar el insumo. El CSV crudo NO se versiona (queda cubierto
#             por .gitignore); este script produce la version publica, que SI se
#             versiona.
# Contexto  : incidente de gobernanza (deteccion 2026-07-01). El crudo, con MRUN y
#             RUT_SOSTENEDOR poblados en 16.768/16.768 filas, estaba versionado y
#             publicado en origin/main (commit 4751373, 2026-06-11). Saneamiento:
#             depurar el insumo, ignorar el crudo y reescribir el historial
#             (git-filter-repo). Patron adaptado de slep_idps
#             (30_procesamiento/31_depurar_directorio_oficial.R).
# Insumos   : 20_insumos/auxiliares/directorio_oficial_ee.csv (UTF-8 con BOM,
#             delimitador ";"). readr descarta el BOM UTF-8 al leer.
# Salidas   : 20_insumos/auxiliares/directorio_oficial_ee_publico.csv (UTF-8,
#             delimitador ";", sin columnas PII).
# Gobernanza: Ley 21.719 (datos personales). MRUN y RUT_SOSTENEDOR se eliminan en
#             origen. El resto de columnas (RBD, territorio, matricula, dependencia,
#             etc.) es informacion publica valida y se conserva INTACTA.
# Fecha     : 2026-07-01
# ==============================================================================

# ---- Auto-instalacion ----
.pkgs <- c("here", "readr", "dplyr")
.faltan <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
if (length(.faltan)) install.packages(.faltan)

# ---- Paquetes ----
library(here)
library(readr)
library(dplyr)

# ---- Rutas ----
ruta_origen  <- here::here("20_insumos", "auxiliares", "directorio_oficial_ee.csv")
ruta_destino <- here::here("20_insumos", "auxiliares", "directorio_oficial_ee_publico.csv")
ruta_tmp     <- paste0(ruta_destino, ".tmp")

# ---- Constantes ----
# Columnas con datos personales identificables: se eliminan en origen.
COLUMNAS_SENSIBLES <- c("MRUN", "RUT_SOSTENEDOR")

# ---- Flujo principal ----

# Lectura: origen UTF-8 con BOM, separador ";" (locale Mineduc). readr detecta y
# descarta el BOM UTF-8, dejando "AGNO" limpio como primera columna.
directorio_crudo <- readr::read_delim(
  ruta_origen,
  delim = ";",
  locale = readr::locale(encoding = "UTF-8"),
  show_col_types = FALSE
)

# Validacion PRE: las columnas sensibles deben existir en el crudo (si no, el
# esquema de origen cambio: se avisa, no hay nada que eliminar).
faltantes <- setdiff(COLUMNAS_SENSIBLES, names(directorio_crudo))
if (length(faltantes)) {
  warning(
    "Columnas sensibles esperadas y no encontradas (revisar esquema de origen): ",
    paste(faltantes, collapse = ", ")
  )
}

# Depuracion: eliminar columnas sensibles (any_of tolera ausencias).
directorio_publico <- dplyr::select(
  directorio_crudo,
  -dplyr::any_of(COLUMNAS_SENSIBLES)
)

# Validacion POST 1: ninguna columna sensible debe sobrevivir.
sobrevivientes <- intersect(COLUMNAS_SENSIBLES, names(directorio_publico))
if (length(sobrevivientes)) {
  stop(
    "FALLO DE GOBERNANZA: columnas sensibles aun presentes tras la depuracion: ",
    paste(sobrevivientes, collapse = ", ")
  )
}

# Validacion POST 2 (invariante): no se pierde ninguna fila; el conteo del
# depurado debe igualar exactamente al del crudo.
if (nrow(directorio_publico) != nrow(directorio_crudo)) {
  stop(
    "FALLO DE INVARIANTE: el depurado (", nrow(directorio_publico),
    " filas) no conserva el conteo del crudo (", nrow(directorio_crudo), " filas)."
  )
}

# Escritura atomica (write -> rename): UTF-8, separador ";" para conservar el
# formato de origen legible en Excel locale espanol.
readr::write_delim(directorio_publico, ruta_tmp, delim = ";")
file.rename(ruta_tmp, ruta_destino)

message(
  "Directorio depurado: ", ncol(directorio_crudo), " -> ",
  ncol(directorio_publico), " columnas; ", nrow(directorio_publico), " filas. ",
  "Eliminadas: ", paste(COLUMNAS_SENSIBLES, collapse = ", "), ". ",
  "Escrito en: ", ruta_destino
)
