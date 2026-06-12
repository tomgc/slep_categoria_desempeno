# 32_agregar_territorial.R
# ----------------------------------------------------------------------------
# Agrega categoria_rbd.parquet a nivel territorial mediante CONTEO de
# establecimientos (jamas ponderacion por matricula: invariante del proyecto).
# Produce el parquet que consume el motor HTML:
#
#   40_salidas/intermedios/categoria_territorial.parquet
#
# Cuatro tipos de entidad territorial, apilados con esquema comun:
#   - comuna    (cod_entidad = cod_com_rbd)
#   - slep      (cod_entidad = cod_slep)
#   - region    (cod_entidad = cod_reg_rbd)
#   - nacional  (cod_entidad = "0")
#
# Esquema final (formato LARGO, 9 columnas):
#   tipo_entidad   character  comuna | slep | region | nacional
#   cod_entidad    character  codigo de la entidad
#   nom_entidad    character  nombre de la entidad
#   nivel          character  basica | media
#   anio           integer
#   categoria      character  ALTO | MEDIO | MEDIO-BAJO | INSUFICIENTE (4 reales)
#   n_ee           integer    EE en esa categoria
#   n_categorizados integer   total EE categorizados en la celda (denominador)
#   pct            double     n_ee / n_categorizados (decimal, NO redondeado)
#
# Decision (sesion 2, opcion B): el conteo y los porcentajes consideran SOLO
# las 4 categorias reales. Los EE con categoria s/i se cuentan aparte en
# categoria_sin_vigente.parquet, con desglose por motivo, para la seccion
# "sin categoria vigente" del motor. Asi un territorio con muchos s/i no diluye
# las proporciones de las categorias reales.
#
# Invariantes:
#   - Niveles basica y media NUNCA se mezclan.
#   - Agregacion = CONTEO de EE. Sin matricula, sin GSE.
#   - Llaves siempre character.
#
# Uso:
#   source(here::here("30_procesamiento", "32_agregar_territorial.R"))
# ----------------------------------------------------------------------------

library(here)

CAT_REALES <- c("ALTO", "MEDIO", "MEDIO-BAJO", "INSUFICIENTE")


# ============================================================================
# Bloque 0 — Carga de insumos
# ============================================================================

message("[0] Cargando insumos...")

dir_int <- here::here("40_salidas", "intermedios")

ruta_cat   <- file.path(dir_int, "categoria_rbd.parquet")
ruta_com   <- file.path(dir_int, "comunas_chile.parquet")
ruta_slep  <- file.path(dir_int, "sleps_chile.parquet")

for (r in c(ruta_cat, ruta_com, ruta_slep)) {
  if (!file.exists(r)) {
    stop(sprintf("Falta %s. Corre antes 30 y 31.", basename(r)))
  }
}

df_cat   <- arrow::read_parquet(ruta_cat) |>
  dplyr::mutate(rbd = as.character(rbd))
df_com   <- arrow::read_parquet(ruta_com)
df_slep  <- arrow::read_parquet(ruta_slep) |>
  dplyr::mutate(rbd = as.character(rbd))

# Nombres de region (mismo mapa que 30_construir_auxiliares.R).
nombres_region <- c(
  "1" = "Tarapaca", "2" = "Antofagasta", "3" = "Atacama", "4" = "Coquimbo",
  "5" = "Valparaiso", "6" = "O'Higgins", "7" = "Maule", "8" = "Biobio",
  "9" = "La Araucania", "10" = "Los Lagos", "11" = "Aysen", "12" = "Magallanes",
  "13" = "Metropolitana", "14" = "Los Rios", "15" = "Arica y Parinacota",
  "16" = "Nuble"
)

message(sprintf(
  "    categoria_rbd: %d filas | comunas: %d | slep x rbd: %d",
  nrow(df_cat), nrow(df_com), nrow(df_slep)
))


# ============================================================================
# Bloque 1 — Funcion generica de conteo territorial
# ============================================================================
# Recibe un data frame ya etiquetado con (tipo_entidad, cod_entidad,
# nom_entidad, nivel, anio, categoria) a nivel RBD y devuelve el conteo largo
# sobre las 4 categorias reales, con denominador de categorizados y pct.
#
# El denominador n_categorizados se calcula por celda (entidad x nivel x anio)
# ANTES de filtrar categorias, contando solo EE con categoria real (no s/i).

contar_territorial <- function(df_rbd) {

  # Conteo por celda x categoria, solo categorias reales.
  conteo <- df_rbd |>
    dplyr::filter(.data$categoria %in% CAT_REALES) |>
    dplyr::count(
      tipo_entidad, cod_entidad, nom_entidad, nivel, anio, categoria,
      name = "n_ee"
    )

  # Completar el producto cartesiano: toda celda existente debe tener las 4
  # categorias (con 0 donde no haya EE), para que el motor no encuentre huecos.
  celdas <- dplyr::distinct(
    conteo, tipo_entidad, cod_entidad, nom_entidad, nivel, anio
  )
  grilla <- tidyr::crossing(celdas, categoria = CAT_REALES)

  conteo <- grilla |>
    dplyr::left_join(
      conteo,
      by = c("tipo_entidad", "cod_entidad", "nom_entidad",
             "nivel", "anio", "categoria")
    ) |>
    dplyr::mutate(n_ee = tidyr::replace_na(.data$n_ee, 0L))

  # Denominador: total categorizados por celda. pct sobre categorizados.
  conteo |>
    dplyr::mutate(
      n_categorizados = sum(.data$n_ee),
      .by = c(tipo_entidad, cod_entidad, nom_entidad, nivel, anio)
    ) |>
    dplyr::mutate(
      pct = dplyr::if_else(
        .data$n_categorizados > 0,
        .data$n_ee / .data$n_categorizados,
        NA_real_
      )
    ) |>
    dplyr::arrange(tipo_entidad, cod_entidad, nivel, anio, categoria)
}


# ============================================================================
# Bloque 2 — Nivel COMUNA
# ============================================================================
# Solo EE con match territorial (cod_com_rbd no NA). Los sin-match entran
# unicamente en nacional.

message("[1] Agregando por COMUNA...")

df_comuna <- df_cat |>
  dplyr::filter(!is.na(.data$cod_com_rbd)) |>
  dplyr::left_join(
    dplyr::distinct(df_com, cod_com_rbd, nom_com_rbd),
    by = "cod_com_rbd"
  ) |>
  dplyr::transmute(
    tipo_entidad = "comuna",
    cod_entidad  = cod_com_rbd,
    nom_entidad  = nom_com_rbd,
    nivel, anio, categoria
  ) |>
  contar_territorial()

message(sprintf(
  "    OK: %d comunas, %d filas.",
  dplyr::n_distinct(df_comuna$cod_entidad), nrow(df_comuna)
))


# ============================================================================
# Bloque 3 — Nivel SLEP
# ============================================================================
# Un RBD puede pertenecer a un SLEP (via sleps_chile.parquet). El join es
# inner: solo EE que son de algun SLEP. Un RBD pertenece a lo sumo a un SLEP.

message("[2] Agregando por SLEP...")

mapa_slep <- df_slep |>
  dplyr::distinct(rbd, cod_slep, nombre_slep)

# Verificar que ningun RBD este en mas de un SLEP (romperia el conteo).
rbd_multi_slep <- mapa_slep |>
  dplyr::count(rbd, name = "n") |>
  dplyr::filter(.data$n > 1)
if (nrow(rbd_multi_slep) > 0) {
  warning(sprintf(
    "%d RBDs asignados a >1 SLEP. Se contaran en cada uno. Muestra:",
    nrow(rbd_multi_slep)
  ))
  print(utils::head(rbd_multi_slep, 5))
}

df_slep_agg <- df_cat |>
  dplyr::inner_join(mapa_slep, by = "rbd") |>
  dplyr::transmute(
    tipo_entidad = "slep",
    cod_entidad  = as.character(cod_slep),
    nom_entidad  = nombre_slep,
    nivel, anio, categoria
  ) |>
  contar_territorial()

message(sprintf(
  "    OK: %d SLEPs, %d filas.",
  dplyr::n_distinct(df_slep_agg$cod_entidad), nrow(df_slep_agg)
))


# ============================================================================
# Bloque 4 — Nivel REGION
# ============================================================================

message("[3] Agregando por REGION...")

df_region <- df_cat |>
  dplyr::filter(!is.na(.data$cod_reg_rbd)) |>
  dplyr::transmute(
    tipo_entidad = "region",
    cod_entidad  = cod_reg_rbd,
    nom_entidad  = dplyr::recode(cod_reg_rbd, !!!nombres_region,
                                 .default = cod_reg_rbd),
    nivel, anio, categoria
  ) |>
  contar_territorial()

message(sprintf(
  "    OK: %d regiones, %d filas.",
  dplyr::n_distinct(df_region$cod_entidad), nrow(df_region)
))


# ============================================================================
# Bloque 5 — Nivel NACIONAL
# ============================================================================
# Incluye TODOS los EE con categoria real, con y sin match territorial: la
# categoria es valida aunque el EE no este en el directorio 2025.

message("[4] Agregando NACIONAL...")

df_nacional <- df_cat |>
  dplyr::transmute(
    tipo_entidad = "nacional",
    cod_entidad  = "0",
    nom_entidad  = "Chile",
    nivel, anio, categoria
  ) |>
  contar_territorial()

message(sprintf("    OK: %d filas.", nrow(df_nacional)))


# ============================================================================
# Bloque 6 — Apilar y validar
# ============================================================================

message("[5] Apilando y validando...")

df_territorial <- dplyr::bind_rows(
  df_comuna, df_slep_agg, df_region, df_nacional
)

# 6.1 — Cada celda (entidad x nivel x anio) suma exactamente 4 categorias.
celdas_mal <- df_territorial |>
  dplyr::count(tipo_entidad, cod_entidad, nivel, anio, name = "n_cat") |>
  dplyr::filter(.data$n_cat != 4)
if (nrow(celdas_mal) > 0) {
  warning(sprintf("%d celdas no tienen exactamente 4 categorias.", nrow(celdas_mal)))
  print(utils::head(celdas_mal, 10))
} else {
  message("    OK: toda celda tiene las 4 categorias.")
}

# 6.2 — pct por celda suma ~1 (o NA si celda vacia de categorizados).
suma_pct <- df_territorial |>
  dplyr::summarise(s = sum(pct), .by = c(tipo_entidad, cod_entidad, nivel, anio)) |>
  dplyr::filter(!is.na(.data$s) & abs(.data$s - 1) > 1e-9)
if (nrow(suma_pct) > 0) {
  warning(sprintf("%d celdas con suma de pct != 1.", nrow(suma_pct)))
} else {
  message("    OK: pct suma 1 por celda (categorizados > 0).")
}

# 6.3 — n_ee <= n_categorizados siempre.
if (any(df_territorial$n_ee > df_territorial$n_categorizados)) {
  warning("Hay n_ee > n_categorizados (imposible).")
} else {
  message("    OK: n_ee <= n_categorizados.")
}

# 6.4 — Cruce de control: nacional basica debe contar todos los EE
# categorizados del pais por anio. Comparar contra df_cat directo.
control_nac <- df_cat |>
  dplyr::filter(categoria %in% CAT_REALES) |>
  dplyr::count(nivel, anio, name = "n_control")
nac_check <- df_nacional |>
  dplyr::distinct(nivel, anio, n_categorizados) |>
  dplyr::left_join(control_nac, by = c("nivel", "anio")) |>
  dplyr::mutate(dif = .data$n_categorizados - .data$n_control)
if (any(nac_check$dif != 0)) {
  warning("Nacional no cuadra con el conteo directo de df_cat.")
  print(nac_check)
} else {
  message("    OK: nacional cuadra con conteo directo (dif = 0).")
}


# ============================================================================
# Bloque 7 — EE sin categoria vigente (seccion aparte del motor)
# ============================================================================
# Conteo de EE con categoria s/i por entidad x nivel x anio x motivo, para la
# seccion "sin categoria vigente". Mismo esquema de entidades, pero sin pct
# (no son parte de la distribucion de categorias).

message("[6] Construyendo categoria_sin_vigente.parquet...")

contar_sin_vigente <- function(df_rbd) {
  df_rbd |>
    dplyr::filter(.data$categoria == "s/i") |>
    dplyr::count(
      tipo_entidad, cod_entidad, nom_entidad, nivel, anio,
      motivo_sin_categoria,
      name = "n_ee"
    )
}

# Reusar las mismas etiquetas de entidad. Construyo los df etiquetados a nivel
# RBD (incluyendo s/i) una sola vez por tipo.
etiquetar <- function(df, tipo, cod, nom) {
  df |>
    dplyr::transmute(
      tipo_entidad = tipo,
      cod_entidad  = as.character(.data[[cod]]),
      nom_entidad  = .data[[nom]],
      nivel, anio, categoria, motivo_sin_categoria
    )
}

sv_comuna <- df_cat |>
  dplyr::filter(!is.na(cod_com_rbd)) |>
  dplyr::left_join(dplyr::distinct(df_com, cod_com_rbd, nom_com_rbd),
                   by = "cod_com_rbd") |>
  etiquetar("comuna", "cod_com_rbd", "nom_com_rbd") |>
  contar_sin_vigente()

sv_slep <- df_cat |>
  dplyr::inner_join(mapa_slep, by = "rbd") |>
  etiquetar("slep", "cod_slep", "nombre_slep") |>
  contar_sin_vigente()

sv_region <- df_cat |>
  dplyr::filter(!is.na(cod_reg_rbd)) |>
  dplyr::mutate(nom_reg = dplyr::recode(cod_reg_rbd, !!!nombres_region,
                                        .default = cod_reg_rbd)) |>
  etiquetar("region", "cod_reg_rbd", "nom_reg") |>
  contar_sin_vigente()

sv_nacional <- df_cat |>
  dplyr::mutate(cod_n = "0", nom_n = "Chile") |>
  etiquetar("nacional", "cod_n", "nom_n") |>
  contar_sin_vigente()

df_sin_vigente <- dplyr::bind_rows(sv_comuna, sv_slep, sv_region, sv_nacional) |>
  dplyr::arrange(tipo_entidad, cod_entidad, nivel, anio, motivo_sin_categoria)

message(sprintf(
  "    OK: %d filas de EE sin categoria (motivos: %s).",
  nrow(df_sin_vigente),
  paste(sort(unique(stats::na.omit(df_sin_vigente$motivo_sin_categoria))),
        collapse = ", ")
))


# ============================================================================
# Bloque 8 — Escritura
# ============================================================================

message("[7] Escribiendo parquets...")

ruta_terr <- file.path(dir_int, "categoria_territorial.parquet")
ruta_sv   <- file.path(dir_int, "categoria_sin_vigente.parquet")

arrow::write_parquet(df_territorial, ruta_terr)
arrow::write_parquet(df_sin_vigente, ruta_sv)

message(sprintf("    OK: categoria_territorial.parquet (%d filas).", nrow(df_territorial)))
message(sprintf("    OK: categoria_sin_vigente.parquet (%d filas).", nrow(df_sin_vigente)))


# ============================================================================
# Bloque 9 — Resumen y sanity check Costa Central
# ============================================================================

message("")
message("=== Filas por tipo de entidad ===")
df_territorial |>
  dplyr::count(tipo_entidad, name = "n_filas") |>
  print()

message("")
message("=== Costa Central, basica, distribucion por anio ===")
df_territorial |>
  dplyr::filter(nom_entidad == "Costa Central", nivel == "basica") |>
  dplyr::select(anio, categoria, n_ee, n_categorizados, pct) |>
  dplyr::mutate(pct = round(pct, 3)) |>
  dplyr::arrange(anio, categoria) |>
  print(n = Inf)

message("")
message("32_agregar_territorial.R: OK.")
