# tests/auditar_cifras.R
# ----------------------------------------------------------------------------
# Orquestador de la auditoria de cifras publicadas (protocolo 4.5).
#
# Cada cifra que el motor publica se calcula por DOS caminos independientes y
# se comparan con tolerancias nombradas:
#   - Camino A: el parquet que efectivamente consume el motor
#     (40_salidas/intermedios/categoria_territorial.parquet y
#      categoria_sin_vigente.parquet). Es la "cache".
#   - Camino B: recalculo desde el crudo (categoria_rbd.parquet) por codigo
#     distinto al del paso 32 (ver auditar_cifras_helpers.R).
#
# Familias auditadas:
#   F1 — Distribucion territorial (n_ee, n_categorizados, pct).
#   F2 — Sin categoria vigente (n_ee por motivo).
#   F3 — Cierre por-EE: todo EE categorizado aparece exactamente una vez en su
#        celda nacional (el crudo no duplica ni pierde EE en la agregacion).
#   F4 — Invariante de referencia (Costa Central / basica), anclado en reporte.
#
# Una familia que falla NO aborta las demas (se captura y se reporta su estado).
#
# Salida: tests/reportes/auditoria_cifras.md (sello con timestamp + alias).
#
# Uso (desde la raiz del proyecto, en consola R de Positron):
#   source(here::here("tests", "auditar_cifras.R"))
#
# NO toca el pipeline ni escribe parquets. Solo lee y reporta.
# ----------------------------------------------------------------------------

library(here)

source(here::here("tests", "auditar_cifras_helpers.R"))


# ============================================================================
# Carga de insumos (camino A: caches; crudo + catalogos: base del camino B)
# ============================================================================

message("[0] Cargando insumos de auditoria...")

dir_int <- here::here("40_salidas", "intermedios")

ruta_crudo <- file.path(dir_int, "categoria_rbd.parquet")
ruta_terr  <- file.path(dir_int, "categoria_territorial.parquet")
ruta_sv    <- file.path(dir_int, "categoria_sin_vigente.parquet")
ruta_com   <- file.path(dir_int, "comunas_chile.parquet")
ruta_slep  <- file.path(dir_int, "sleps_chile.parquet")

for (r in c(ruta_crudo, ruta_terr, ruta_sv, ruta_com, ruta_slep)) {
  if (!file.exists(r)) {
    stop(sprintf("Falta %s. Corre el pipeline (run_all) antes de auditar.",
                 basename(r)))
  }
}

df_cat  <- arrow::read_parquet(ruta_crudo) |>
  dplyr::mutate(rbd = as.character(rbd))
df_terr_A <- arrow::read_parquet(ruta_terr)   # camino A (cache)
df_sv_A   <- arrow::read_parquet(ruta_sv)     # camino A (cache)
df_com  <- arrow::read_parquet(ruta_com)
df_slep <- arrow::read_parquet(ruta_slep) |>
  dplyr::mutate(rbd = as.character(rbd))

message(sprintf("    crudo (categoria_rbd): %d filas | territorial_A: %d | sin_vigente_A: %d",
                nrow(df_cat), nrow(df_terr_A), nrow(df_sv_A)))


# ============================================================================
# Ejecucion de familias (cada una en tryCatch: una que falla no aborta el resto)
# ============================================================================

resultados <- list()

aud_familia <- function(id, titulo, fn) {
  out <- tryCatch(
    {
      r <- fn()
      list(id = id, titulo = titulo, estado = r$estado,
           n_disc = r$n_disc, detalle = r$detalle, nota = r$nota)
    },
    error = function(e) {
      list(id = id, titulo = titulo, estado = "ERROR",
           n_disc = NA_integer_, detalle = NULL,
           nota = paste("Excepcion:", conditionMessage(e)))
    }
  )
  simbolo <- switch(out$estado, "OK" = "OK ", "FALLA" = "XX ", "ERROR" = "!! ", "?? ")
  message(sprintf("  [%s] %s%s%s", out$id, simbolo, out$titulo,
                  if (!is.na(out$n_disc)) sprintf(" (%d discrepancias)", out$n_disc) else ""))
  resultados[[id]] <<- out
  invisible(out)
}

message("[1] Auditando familias...")

# Camino B se construye una vez (lo usan F1, F3, F4).
df_terr_B <- aud_construir_territorial_B(df_cat, df_com, df_slep)


# --- F1 — Distribucion territorial -----------------------------------------
aud_familia("F1", "Distribucion territorial (n_ee, n_categorizados, pct)", function() {
  disc <- aud_comparar_distribucion(df_terr_A, df_terr_B)
  list(
    estado  = if (nrow(disc) == 0) "OK" else "FALLA",
    n_disc  = nrow(disc),
    detalle = if (nrow(disc) > 0) utils::head(disc, 20) else NULL,
    nota    = sprintf("Tol. conteo = %d (exacta); tol. pct = %g. Camino B sin contar_territorial().",
                      AUD_TOL_CONTEO, AUD_TOL_PCT)
  )
})


# --- F2 — Sin categoria vigente --------------------------------------------
aud_familia("F2", "Sin categoria vigente (n_ee por motivo)", function() {
  df_sv_B <- aud_construir_sin_vigente_B(df_cat, df_com, df_slep)
  disc <- aud_comparar_sin_vigente(df_sv_A, df_sv_B)
  list(
    estado  = if (nrow(disc) == 0) "OK" else "FALLA",
    n_disc  = nrow(disc),
    detalle = if (nrow(disc) > 0) utils::head(disc, 20) else NULL,
    nota    = "Conteo de EE con categoria s/i por entidad x nivel x anio x motivo."
  )
})


# --- F3 — Cierre por-EE: nacional reconstruido desde el crudo distinct ------
# El conteo nacional por categoria debe igualar el numero de EE distintos (rbd)
# con esa categoria real en ese nivel x anio. Verifica que la agregacion no
# duplique ni pierda EE (el crudo es llave rbd x nivel x anio, un EE por celda).
aud_familia("F3", "Cierre por-EE: nacional = EE distintos del crudo", function() {
  nac_A <- df_terr_A |>
    dplyr::filter(.data$tipo_entidad == "nacional",
                  .data$categoria %in% AUD_CAT_REALES) |>
    dplyr::transmute(nivel, anio = as.integer(anio), categoria,
                     n_ee_A = as.integer(n_ee))

  nac_C <- df_cat |>
    dplyr::filter(.data$categoria %in% AUD_CAT_REALES) |>
    dplyr::summarise(n_ee_C = dplyr::n_distinct(rbd),
                     .by = c(nivel, anio, categoria)) |>
    dplyr::mutate(anio = as.integer(anio))

  disc <- dplyr::full_join(nac_A, nac_C,
                           by = c("nivel", "anio", "categoria")) |>
    dplyr::mutate(
      n_ee_A = tidyr::replace_na(.data$n_ee_A, -1L),
      n_ee_C = tidyr::replace_na(.data$n_ee_C, -1L),
      dif = abs(.data$n_ee_A - .data$n_ee_C)
    ) |>
    dplyr::filter(.data$dif > AUD_TOL_CONTEO)

  list(
    estado  = if (nrow(disc) == 0) "OK" else "FALLA",
    n_disc  = nrow(disc),
    detalle = if (nrow(disc) > 0) utils::head(disc, 20) else NULL,
    nota    = "n_distinct(rbd) por nivel x anio x categoria == n_ee nacional del parquet."
  )
})


# --- F4 — Invariante de referencia (Costa Central / basica) ----------------
# No es una comparacion A/B: ancla el bloque conocido para detectar drift entre
# builds. Se reporta la distribucion completa por anio.
aud_familia("F4", sprintf("Invariante de referencia (%s / %s)",
                          AUD_REF_ENTIDAD, AUD_REF_NIVEL), function() {
  ref <- aud_spot_check_referencia(df_terr_B)
  list(
    estado  = if (nrow(ref) > 0) "OK" else "FALLA",
    n_disc  = 0L,
    detalle = ref,
    nota    = "Bloque ancla. Comparar contra el valor del build anterior (drift = 0)."
  )
})


# ============================================================================
# Reporte
# ============================================================================

message("[2] Escribiendo reporte...")

dir_rep <- here::here("tests", "reportes")
if (!dir.exists(dir_rep)) dir.create(dir_rep, recursive = TRUE)

sello <- format(Sys.time(), "%Y%m%d_%H%M%S")

fmt_tabla <- function(df) {
  if (is.null(df) || nrow(df) == 0) return("(sin filas)")
  con <- textConnection("buf", "w", local = TRUE)
  utils::write.table(df, con, sep = " | ", row.names = FALSE, quote = FALSE)
  close(con)
  paste(buf, collapse = "\n")
}

n_fallas <- sum(vapply(resultados, function(x) x$estado != "OK", logical(1)))
veredicto_global <- if (n_fallas == 0) "TODAS LAS FAMILIAS EN VERDE" else
  sprintf("%d FAMILIA(S) CON HALLAZGOS", n_fallas)

lineas <- c(
  "# Auditoria de cifras publicadas — slep_categoria_desempeno",
  "",
  sprintf("- **Fecha:** %s", format(Sys.time(), "%Y-%m-%d %H:%M:%S")),
  sprintf("- **Protocolo:** 4.5 (doble calculo: cache vs recalculo desde el crudo)."),
  sprintf("- **Veredicto global:** %s", veredicto_global),
  sprintf("- **Tolerancias:** conteo = %d (exacta); pct = %g.",
          AUD_TOL_CONTEO, AUD_TOL_PCT),
  "",
  "## Resumen por familia",
  "",
  "| Familia | Estado | Discrepancias |",
  "|---|---|---|"
)

for (r in resultados) {
  lineas <- c(lineas, sprintf("| %s — %s | %s | %s |",
    r$id, r$titulo, r$estado,
    if (is.na(r$n_disc)) "n/a" else as.character(r$n_disc)))
}

for (r in resultados) {
  lineas <- c(lineas, "",
    sprintf("## %s — %s", r$id, r$titulo),
    sprintf("- Estado: **%s**", r$estado),
    sprintf("- Nota: %s", r$nota))
  if (!is.null(r$detalle)) {
    lineas <- c(lineas, "",
      "```",
      fmt_tabla(r$detalle),
      "```")
  }
}

ruta_sello <- file.path(dir_rep, sprintf("%s_auditoria_cifras.md", sello))
ruta_alias <- file.path(dir_rep, "auditoria_cifras.md")
writeLines(lineas, ruta_sello, useBytes = TRUE)
writeLines(lineas, ruta_alias, useBytes = TRUE)

message(sprintf("    OK: %s", fs::path_rel(ruta_alias, here::here())))
message("")
message(sprintf("=== AUDITORIA: %s ===", veredicto_global))
for (r in resultados) {
  message(sprintf("  %s: %s%s", r$id, r$estado,
                  if (!is.na(r$n_disc) && r$n_disc > 0)
                    sprintf(" (%d)", r$n_disc) else ""))
}
message("")
message("auditar_cifras.R: OK.")
