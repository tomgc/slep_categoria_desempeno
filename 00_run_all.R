# 00_run_all.R
# ----------------------------------------------------------------------------
# Orquestador del pipeline slep_categoria_desempeno (punto de entrada unico).
#
# Ejecuta en orden los pasos de 30_procesamiento/:
#   1. 30_construir_auxiliares.R  catalogos territoriales desde el directorio
#   2. 31_leer_normalizar.R       lee 7 xlsx, normaliza categoria, cruza RBD
#   3. 32_agregar_territorial.R   conteo de EE por territorio x nivel x anio
#   4. 33_generar_html.R          motor HTML autocontenido (PENDIENTE sesion 3)
#
# Solo orquesta: cero logica de negocio, no modifica scripts de estacion,
# sin cache automatico por timestamp (saltar pasos es decision explicita).
#
# Uso:
#   source(here::here("00_run_all.R"))
#   run_all()                  # todos los pasos disponibles
#   run_all(skip = c(1, 2))    # omite auxiliares y normalizacion
#   run_all(from = 3)          # desde el paso 3 en adelante
#   run_all(only = 2)          # solo el paso 2
# ----------------------------------------------------------------------------

# ---- Anclaje de raiz (criterios .Rproj / .git / .here) ---------------------
raiz <- rprojroot::find_root(
  rprojroot::has_file(".here") |
    rprojroot::is_rstudio_project |
    rprojroot::is_git_root
)

# ---- Bootstrapping: utils antes de cualquier library() ---------------------
source(file.path(raiz, "10_utils", "10_utils.R"))

# ---- Precondiciones: paquetes del pipeline ---------------------------------
instalar_si_falta(c(
  "here", "fs", "readr", "readxl", "janitor",
  "dplyr", "tidyr", "purrr", "tibble", "stringr", "arrow"
))


# ============================================================================
# Definicion de pasos
# ============================================================================
# Cada paso: id (entero), etiqueta (descriptiva), ruta (relativa a la raiz).
# El paso 4 esta declarado pero su script aun no existe (sesion 3): se valida
# su presencia en tiempo de ejecucion, no al definir PASOS.

PASOS <- list(
  list(id = 1L, etiqueta = "Construir auxiliares (catalogos territoriales)",
       ruta = file.path("30_procesamiento", "30_construir_auxiliares.R")),
  list(id = 2L, etiqueta = "Leer y normalizar categoria (7 xlsx -> RBD)",
       ruta = file.path("30_procesamiento", "31_leer_normalizar.R")),
  list(id = 3L, etiqueta = "Agregar territorial (conteo de EE)",
       ruta = file.path("30_procesamiento", "32_agregar_territorial.R")),
  list(id = 4L, etiqueta = "Generar motor HTML autocontenido",
       ruta = file.path("30_procesamiento", "33_generar_html.R"))
)


# ============================================================================
# run_all()
# ============================================================================

#' Ejecutar el pipeline completo o un subconjunto de pasos.
#'
#' @param from Integer. Primer paso a ejecutar (default: el menor disponible).
#' @param to Integer. Ultimo paso a ejecutar (default: el mayor disponible).
#' @param only Integer vector. Ejecutar exactamente estos pasos (ignora from/to).
#' @param skip Integer vector. Pasos a omitir.
#' @return Invisible NULL. Emite log de progreso y resumen final.
run_all <- function(from = NULL, to = NULL, only = NULL, skip = NULL) {

  ids_def <- vapply(PASOS, function(p) p$id, integer(1))

  # ---- Resolver que pasos existen en disco --------------------------------
  ids_existentes <- ids_def[vapply(PASOS, function(p) {
    file.exists(file.path(raiz, p$ruta))
  }, logical(1))]

  ids_ausentes <- setdiff(ids_def, ids_existentes)
  if (length(ids_ausentes) > 0) {
    for (id in ids_ausentes) {
      p <- PASOS[[which(ids_def == id)]]
      log_msg(sprintf("Paso %d ausente (aun no construido): %s",
                      id, p$ruta), "WARN", "run_all")
    }
  }

  # ---- Seleccionar pasos a correr -----------------------------------------
  if (!is.null(only)) {
    seleccion <- intersect(ids_existentes, only)
  } else {
    lo <- if (is.null(from)) min(ids_existentes) else from
    hi <- if (is.null(to))   max(ids_existentes) else to
    seleccion <- ids_existentes[ids_existentes >= lo & ids_existentes <= hi]
  }
  if (!is.null(skip)) {
    seleccion <- setdiff(seleccion, skip)
  }
  seleccion <- sort(seleccion)

  if (length(seleccion) == 0) {
    log_msg("Ningun paso seleccionado para ejecutar.", "WARN", "run_all")
    return(invisible(NULL))
  }

  # ---- Ejecucion paso a paso ----------------------------------------------
  t0_total <- proc.time()
  ejecutados <- integer(0)
  duraciones <- numeric(0)

  for (id in seleccion) {
    p <- PASOS[[which(ids_def == id)]]
    ruta_abs <- file.path(raiz, p$ruta)

    message("")
    message(strrep("=", 70))
    log_msg(sprintf("PASO %d — %s", p$id, p$etiqueta), "INFO", "run_all")
    log_msg(sprintf("Ruta: %s", p$ruta), "INFO", "run_all")
    message(strrep("=", 70))

    t0 <- proc.time()
    ok <- tryCatch({
      source(ruta_abs, echo = FALSE, chdir = TRUE)
      TRUE
    }, error = function(e) {
      log_msg(sprintf("FALLO en paso %d: %s", p$id, conditionMessage(e)),
              "ERROR", "run_all")
      FALSE
    })
    dt <- round((proc.time() - t0)[["elapsed"]], 1)

    if (!ok) {
      stop(sprintf("Pipeline detenido en el paso %d (%s).", p$id, p$etiqueta),
           call. = FALSE)
    }

    log_msg(sprintf("Paso %d OK en %.1f s.", p$id, dt), "INFO", "run_all")
    ejecutados <- c(ejecutados, id)
    duraciones <- c(duraciones, dt)
  }

  # ---- Resumen ------------------------------------------------------------
  dt_total <- round((proc.time() - t0_total)[["elapsed"]], 1)
  saltados <- setdiff(ids_existentes, ejecutados)

  message("")
  message(strrep("=", 70))
  log_msg("RESUMEN", "INFO", "run_all")
  log_msg(sprintf("Ejecutados: %s", paste(ejecutados, collapse = ", ")),
          "INFO", "run_all")
  if (length(saltados) > 0) {
    log_msg(sprintf("Saltados (disponibles, no corridos): %s",
                    paste(saltados, collapse = ", ")), "INFO", "run_all")
  }
  if (length(ids_ausentes) > 0) {
    log_msg(sprintf("Ausentes (sin construir): %s",
                    paste(ids_ausentes, collapse = ", ")), "INFO", "run_all")
  }
  log_msg(sprintf("Duracion total: %.1f s.", dt_total), "INFO", "run_all")
  message(strrep("=", 70))

  invisible(NULL)
}


# ============================================================================
# Ejemplos de uso (comentados)
# ============================================================================
# run_all()                  # todos los pasos disponibles, en orden
# run_all(skip = c(1, 2))    # omite auxiliares y normalizacion (reusa parquets)
# run_all(from = 3)          # desde el paso 3 (solo agregacion + motor)
# run_all(only = 2)          # exactamente el paso 2
