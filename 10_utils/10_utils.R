# 10_utils.R
# ----------------------------------------------------------------------------
# Funciones utilitarias transversales del proyecto slep_categoria_desempeno.
#
# Bootstrapping: este archivo se carga ANTES de cualquier library(). No debe
# depender de paquetes cargados; usa siempre paquete::funcion().
#
# Funciones expuestas:
#   - instalar_si_falta(paquetes): instala los paquetes ausentes.
#   - log_msg(msg, nivel, origen): logging con formato estandar.
#
# Nota: a diferencia del proyecto madre (slep_simce_adecuado), aqui NO existe
# agregacion ponderada por nalu ni segmentacion GSE. La unidad es el
# establecimiento y la agregacion territorial es un CONTEO de EE por categoria
# (decision metodologica documentada en 50_documentacion/activa/decisiones/).
# La logica de conteo vivira en 30_procesamiento/, no aqui, hasta que haya
# duplicacion real que justifique migrarla (POLITICA 1.4).
# ----------------------------------------------------------------------------


#' Instalar paquetes ausentes
#'
#' @param paquetes Vector character con nombres de paquetes.
#' @return Invisible NULL. Instala los que falten.
instalar_si_falta <- function(paquetes) {
  faltantes <- paquetes[
    !vapply(paquetes, requireNamespace, logical(1), quietly = TRUE)
  ]
  if (length(faltantes) > 0) {
    install.packages(faltantes)
  }
  invisible(NULL)
}


#' Logging con formato estandar
#'
#' Formato: [YYYY-MM-DD HH:MM:SS] [origen] [NIVEL] mensaje
#'
#' @param msg Mensaje a registrar.
#' @param nivel "INFO" (default), "WARN" o "ERROR".
#' @param origen Etiqueta de origen (default "general").
#' @return Invisible NULL. Emite via message().
log_msg <- function(msg, nivel = "INFO", origen = "general") {
  ts <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  message(sprintf("[%s] [%s] [%s] %s", ts, origen, nivel, msg))
  invisible(NULL)
}
