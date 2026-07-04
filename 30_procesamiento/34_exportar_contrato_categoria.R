# 34_exportar_contrato_categoria.R
# Copyright (c) 2026 Tomás Ignacio González Cifuentes — Servicio Local de Educación Pública Costa Central
# Distribuido bajo la Licencia MIT. Ver el archivo LICENSE en la raíz del repositorio.
# La licencia cubre el código; NO cubre los datos (Agencia de Calidad). Ver LICENSE.
#
# ----------------------------------------------------------------------------
# Exporta el contrato público de Categoría de Desempeño por establecimiento,
# para consumo de otros proyectos (p. ej. slep_minuta_asistencia).
#
# Insumo:
#   - 40_salidas/intermedios/categoria_rbd.parquet (interno, producido por
#     31_leer_normalizar.R; grano rbd x nivel x anio, 9 columnas).
#
# Salida:
#   - 40_salidas/categoria_rbd_contrato.parquet (público, fuera de
#     intermedios/ para distinguir "interno" de "expuesto"). 5 columnas:
#     rbd, nivel, anio, categoria, motivo_sin_categoria. Se excluyen
#     nom_rbd, cod_com_rbd, cod_reg_rbd, cod_depe2: redundantes para un
#     consumidor que ya tiene su propio catálogo territorial (decisión de
#     alcance del contrato v1, ver 50_documentacion/activa/
#     contrato_categoria_desempeno_v1.md).
#
# Sin filtrado: el contrato expone las mismas filas del intermedio origen
# (una fila por rbd x nivel x anio, incluida la categoría "s/i"), solo con
# menos columnas. El conteo de filas debe coincidir exacto entre ambos.
#
# Fecha: 2026-07-04
# ----------------------------------------------------------------------------

library(here)


# ============================================================================
# Bloque 1 — Leer el intermedio
# ============================================================================

message("[1] Leyendo categoria_rbd.parquet (intermedio)...")

ruta_origen <- here::here("40_salidas", "intermedios", "categoria_rbd.parquet")
if (!file.exists(ruta_origen)) {
  stop("No existe el intermedio: ", ruta_origen,
       "\n  Corre antes 31_leer_normalizar.R (o run_all()).")
}

df_origen <- arrow::read_parquet(ruta_origen)
message(sprintf("    %d filas leídas del intermedio.", nrow(df_origen)))


# ============================================================================
# Bloque 2 — Seleccionar columnas del contrato (criterio, no todo el parquet)
# ============================================================================

message("[2] Seleccionando columnas del contrato...")

df_contrato <- df_origen |>
  dplyr::select(rbd, nivel, anio, categoria, motivo_sin_categoria)


# ============================================================================
# Bloque 3 — Validación del contrato
# ============================================================================

CAT_DOMINIO <- c("ALTO", "MEDIO", "MEDIO-BAJO", "INSUFICIENTE", "s/i")
ANIO_DOMINIO <- 2016:2019

stopifnot(
  "el contrato no tiene filas" = nrow(df_contrato) > 0,
  "categoria fuera del dominio esperado" =
    all(df_contrato$categoria %in% CAT_DOMINIO),
  "anio fuera del rango esperado (2016-2019)" =
    all(df_contrato$anio %in% ANIO_DOMINIO)
)

# Sin filtrado: el contrato debe tener exactamente las mismas filas del origen.
stopifnot(
  "el contrato no coincide en filas con el intermedio origen (no debe filtrar)" =
    nrow(df_contrato) == nrow(df_origen)
)

message("    Validación OK: filas > 0, categoria y anio en dominio, sin filtrado.")


# ============================================================================
# Bloque 4 — Escritura atómica
# ============================================================================

message("[3] Escribiendo contrato...")

ruta_salida <- here::here("40_salidas", "categoria_rbd_contrato.parquet")
ruta_tmp    <- paste0(ruta_salida, ".tmp")

arrow::write_parquet(df_contrato, ruta_tmp)
file.rename(ruta_tmp, ruta_salida)

message(sprintf("    OK: %s (%d filas, %d columnas).",
                fs::path_rel(ruta_salida, here::here()),
                nrow(df_contrato), ncol(df_contrato)))


# ============================================================================
# Bloque 5 — Resumen
# ============================================================================

message("")
message("=== Resumen ===")
message(sprintf("  Filas exportadas: %d", nrow(df_contrato)))
message(sprintf("  Columnas:         %s", paste(names(df_contrato), collapse = ", ")))
message(sprintf("  Categorías:       %s", paste(sort(unique(df_contrato$categoria)), collapse = ", ")))
message(sprintf("  Años:             %s", paste(sort(unique(df_contrato$anio)), collapse = ", ")))
message("")
message(sprintf("34_exportar_contrato_categoria.R: OK. Contrato en %s",
                fs::path_rel(ruta_salida, here::here())))
