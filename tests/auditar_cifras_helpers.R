# tests/auditar_cifras_helpers.R
# ----------------------------------------------------------------------------
# Helpers de auditoria de cifras publicadas (protocolo 4.5).
#
# Proposito: recalcular las cifras finales del motor por un CAMINO B
# independiente del pipeline (sin reusar contar_territorial() del paso 32) y
# compararlas contra el CAMINO A (el parquet que efectivamente consume el
# motor). Dos caminos independientes, comparados con tolerancias nombradas.
#
# Este archivo NO se ejecuta solo: lo carga auditar_cifras.R (orquestador).
# No escribe nada; solo define funciones puras.
#
# Reglas de inclusion replicadas del paso 32 (con codigo distinto, para que un
# error de logica en un camino no se replique en el otro):
#   - comuna:   EE con cod_com_rbd no NA.            Sin match -> solo nacional.
#   - region:   EE con cod_reg_rbd no NA.
#   - slep:     EE en algun SLEP (join con sleps_chile). Un RBD <= 1 SLEP.
#   - nacional: TODOS los EE (con y sin match territorial).
#   - Distribucion: SOLO las 4 categorias reales. s/i va aparte.
#   - Llaves siempre character.
#
# Convenciones del proyecto: dplyr:: prefijado, here::, pipe nativo, .by=.
# ----------------------------------------------------------------------------

# --- Constantes nombradas de la auditoria (jamas numeros magicos) -----------

# Las 4 categorias reales (mismo universo que CAT_REALES del paso 32).
AUD_CAT_REALES <- c("ALTO", "MEDIO", "MEDIO-BAJO", "INSUFICIENTE")

# Tolerancia para comparaciones de CONTEO (n_ee, n_categorizados): exacta.
# Un conteo de establecimientos es entero; cualquier diferencia es un error.
AUD_TOL_CONTEO <- 0L

# Tolerancia para comparaciones de PROPORCION (pct). El pct viaja al motor
# redondeado a PCT_DIGITS = 4 (paso 33), pero el camino B compara contra el
# pct sin redondear del parquet territorial (camino A interno), de modo que la
# tolerancia aqui cubre solo error de punto flotante, no el redondeo de salida.
AUD_TOL_PCT <- 1e-9

# Bloque invariante de referencia (analogo al "% Adecuado" del proyecto
# hermano): una celda conocida que debe mantenerse estable entre builds.
AUD_REF_ENTIDAD <- "Costa Central"
AUD_REF_NIVEL   <- "basica"


# --- Mapa de region (replica del paso 32; un EE conserva su region aunque no
#     este en el directorio). Se mantiene aqui para independencia del camino B. -
aud_nombres_region <- c(
  "1" = "Tarapaca", "2" = "Antofagasta", "3" = "Atacama", "4" = "Coquimbo",
  "5" = "Valparaiso", "6" = "O'Higgins", "7" = "Maule", "8" = "Biobio",
  "9" = "La Araucania", "10" = "Los Lagos", "11" = "Aysen", "12" = "Magallanes",
  "13" = "Metropolitana", "14" = "Los Rios", "15" = "Arica y Parinacota",
  "16" = "Nuble"
)


# ============================================================================
# Camino B — recalculo independiente de la distribucion territorial
# ============================================================================
# Recibe el crudo (categoria_rbd) ya etiquetado a nivel RBD con la columna
# cod_entidad del tipo en cuestion, y devuelve el conteo largo SIN usar
# contar_territorial(): aqui el denominador se calcula con un summarise directo
# por celda y el join de las 4 categorias se hace por tidyr::complete (no
# crossing + left_join). Codigo distinto, misma definicion.

aud_recalcular_distribucion <- function(df_etiquetado) {
  # Solo categorias reales.
  base <- df_etiquetado |>
    dplyr::filter(.data$categoria %in% AUD_CAT_REALES)

  # Conteo por celda x categoria. complete() rellena con 0 las categorias
  # ausentes en cada celda (camino distinto al crossing+left_join del paso 32).
  conteo <- base |>
    dplyr::summarise(
      n_ee = dplyr::n(),
      .by = c(tipo_entidad, cod_entidad, nom_entidad, nivel, anio, categoria)
    ) |>
    tidyr::complete(
      tidyr::nesting(tipo_entidad, cod_entidad, nom_entidad, nivel, anio),
      categoria = AUD_CAT_REALES,
      fill = list(n_ee = 0L)
    )

  # Denominador por celda y pct (sin redondear).
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
      ),
      n_ee            = as.integer(.data$n_ee),
      n_categorizados = as.integer(.data$n_categorizados)
    )
}


# Construye los cuatro df etiquetados desde el crudo, replicando las reglas de
# inclusion del paso 32 con joins propios. Devuelve el territorial recalculado
# (camino B) ya apilado, en el mismo esquema largo que el parquet del motor.
aud_construir_territorial_B <- function(df_cat, df_com, df_slep) {

  df_cat <- df_cat |> dplyr::mutate(rbd = as.character(.data$rbd))

  # -- comuna --
  b_comuna <- df_cat |>
    dplyr::filter(!is.na(.data$cod_com_rbd)) |>
    dplyr::left_join(
      dplyr::distinct(df_com, cod_com_rbd, nom_com_rbd),
      by = "cod_com_rbd"
    ) |>
    dplyr::transmute(
      tipo_entidad = "comuna",
      cod_entidad  = as.character(.data$cod_com_rbd),
      nom_entidad  = .data$nom_com_rbd,
      nivel = .data$nivel, anio = .data$anio, categoria = .data$categoria
    ) |>
    aud_recalcular_distribucion()

  # -- slep -- (inner join; un RBD <= 1 SLEP segun el paso 32)
  mapa_slep <- df_slep |>
    dplyr::mutate(rbd = as.character(.data$rbd)) |>
    dplyr::distinct(rbd, cod_slep, nombre_slep)

  b_slep <- df_cat |>
    dplyr::inner_join(mapa_slep, by = "rbd") |>
    dplyr::transmute(
      tipo_entidad = "slep",
      cod_entidad  = as.character(.data$cod_slep),
      nom_entidad  = .data$nombre_slep,
      nivel = .data$nivel, anio = .data$anio, categoria = .data$categoria
    ) |>
    aud_recalcular_distribucion()

  # -- region --
  b_region <- df_cat |>
    dplyr::filter(!is.na(.data$cod_reg_rbd)) |>
    dplyr::transmute(
      tipo_entidad = "region",
      cod_entidad  = as.character(.data$cod_reg_rbd),
      nom_entidad  = dplyr::recode(.data$cod_reg_rbd, !!!aud_nombres_region,
                                   .default = .data$cod_reg_rbd),
      nivel = .data$nivel, anio = .data$anio, categoria = .data$categoria
    ) |>
    aud_recalcular_distribucion()

  # -- nacional -- (todos los EE)
  b_nacional <- df_cat |>
    dplyr::transmute(
      tipo_entidad = "nacional",
      cod_entidad  = "0",
      nom_entidad  = "Chile",
      nivel = .data$nivel, anio = .data$anio, categoria = .data$categoria
    ) |>
    aud_recalcular_distribucion()

  dplyr::bind_rows(b_comuna, b_slep, b_region, b_nacional)
}


# ============================================================================
# Camino B — recalculo independiente de "sin categoria vigente"
# ============================================================================
# Conteo de EE con categoria s/i por entidad x nivel x anio x motivo, sin
# reusar contar_sin_vigente() del paso 32.

aud_construir_sin_vigente_B <- function(df_cat, df_com, df_slep) {

  df_cat <- df_cat |> dplyr::mutate(rbd = as.character(.data$rbd))
  mapa_slep <- df_slep |>
    dplyr::mutate(rbd = as.character(.data$rbd)) |>
    dplyr::distinct(rbd, cod_slep, nombre_slep)

  contar_sv <- function(df_etq) {
    df_etq |>
      dplyr::filter(.data$categoria == "s/i") |>
      dplyr::summarise(
        n_ee = dplyr::n(),
        .by = c(tipo_entidad, cod_entidad, nom_entidad, nivel, anio,
                motivo_sin_categoria)
      )
  }

  sv_comuna <- df_cat |>
    dplyr::filter(!is.na(.data$cod_com_rbd)) |>
    dplyr::left_join(dplyr::distinct(df_com, cod_com_rbd, nom_com_rbd),
                     by = "cod_com_rbd") |>
    dplyr::transmute(
      tipo_entidad = "comuna",
      cod_entidad  = as.character(.data$cod_com_rbd),
      nom_entidad  = .data$nom_com_rbd,
      nivel = .data$nivel, anio = .data$anio, categoria = .data$categoria,
      motivo_sin_categoria = .data$motivo_sin_categoria
    ) |>
    contar_sv()

  sv_slep <- df_cat |>
    dplyr::inner_join(mapa_slep, by = "rbd") |>
    dplyr::transmute(
      tipo_entidad = "slep",
      cod_entidad  = as.character(.data$cod_slep),
      nom_entidad  = .data$nombre_slep,
      nivel = .data$nivel, anio = .data$anio, categoria = .data$categoria,
      motivo_sin_categoria = .data$motivo_sin_categoria
    ) |>
    contar_sv()

  sv_region <- df_cat |>
    dplyr::filter(!is.na(.data$cod_reg_rbd)) |>
    dplyr::transmute(
      tipo_entidad = "region",
      cod_entidad  = as.character(.data$cod_reg_rbd),
      nom_entidad  = dplyr::recode(.data$cod_reg_rbd, !!!aud_nombres_region,
                                   .default = .data$cod_reg_rbd),
      nivel = .data$nivel, anio = .data$anio, categoria = .data$categoria,
      motivo_sin_categoria = .data$motivo_sin_categoria
    ) |>
    contar_sv()

  sv_nacional <- df_cat |>
    dplyr::transmute(
      tipo_entidad = "nacional",
      cod_entidad  = "0",
      nom_entidad  = "Chile",
      nivel = .data$nivel, anio = .data$anio, categoria = .data$categoria,
      motivo_sin_categoria = .data$motivo_sin_categoria
    ) |>
    contar_sv()

  dplyr::bind_rows(sv_comuna, sv_slep, sv_region, sv_nacional)
}


# ============================================================================
# Comparadores A vs B (devuelven un tibble de discrepancias, vacio = OK)
# ============================================================================

# Compara la distribucion territorial: A (parquet del motor) vs B (recalculo).
# Une por la llave entidad x nivel x anio x categoria y reporta toda fila con
# diferencia de conteo > AUD_TOL_CONTEO o de pct > AUD_TOL_PCT.
aud_comparar_distribucion <- function(df_A, df_B) {
  llave <- c("tipo_entidad", "cod_entidad", "nivel", "anio", "categoria")

  a <- df_A |>
    dplyr::transmute(
      tipo_entidad = as.character(.data$tipo_entidad),
      cod_entidad  = as.character(.data$cod_entidad),
      nivel = .data$nivel, anio = as.integer(.data$anio),
      categoria = as.character(.data$categoria),
      n_ee_A = as.integer(.data$n_ee),
      n_cat_A = as.integer(.data$n_categorizados),
      pct_A = .data$pct
    )

  b <- df_B |>
    dplyr::transmute(
      tipo_entidad = as.character(.data$tipo_entidad),
      cod_entidad  = as.character(.data$cod_entidad),
      nivel = .data$nivel, anio = as.integer(.data$anio),
      categoria = as.character(.data$categoria),
      n_ee_B = as.integer(.data$n_ee),
      n_cat_B = as.integer(.data$n_categorizados),
      pct_B = .data$pct
    )

  # full_join: detecta tambien celdas presentes en un camino y ausentes en el
  # otro (un EE mal incluido/excluido). Los NA de un lado se vuelven discrepancia.
  comp <- dplyr::full_join(a, b, by = llave) |>
    dplyr::mutate(
      n_ee_A  = tidyr::replace_na(.data$n_ee_A, -1L),
      n_ee_B  = tidyr::replace_na(.data$n_ee_B, -1L),
      n_cat_A = tidyr::replace_na(.data$n_cat_A, -1L),
      n_cat_B = tidyr::replace_na(.data$n_cat_B, -1L),
      dif_n_ee  = abs(.data$n_ee_A - .data$n_ee_B),
      dif_n_cat = abs(.data$n_cat_A - .data$n_cat_B),
      dif_pct   = dplyr::if_else(
        is.na(.data$pct_A) | is.na(.data$pct_B),
        dplyr::if_else(is.na(.data$pct_A) & is.na(.data$pct_B), 0, Inf),
        abs(.data$pct_A - .data$pct_B)
      )
    )

  comp |>
    dplyr::filter(
      .data$dif_n_ee  > AUD_TOL_CONTEO |
      .data$dif_n_cat > AUD_TOL_CONTEO |
      .data$dif_pct   > AUD_TOL_PCT
    )
}


# Compara "sin categoria vigente": A (parquet) vs B (recalculo).
aud_comparar_sin_vigente <- function(df_A, df_B) {
  llave <- c("tipo_entidad", "cod_entidad", "nivel", "anio", "motivo")

  a <- df_A |>
    dplyr::transmute(
      tipo_entidad = as.character(.data$tipo_entidad),
      cod_entidad  = as.character(.data$cod_entidad),
      nivel = .data$nivel, anio = as.integer(.data$anio),
      motivo = .data$motivo_sin_categoria,
      n_ee_A = as.integer(.data$n_ee)
    )

  b <- df_B |>
    dplyr::transmute(
      tipo_entidad = as.character(.data$tipo_entidad),
      cod_entidad  = as.character(.data$cod_entidad),
      nivel = .data$nivel, anio = as.integer(.data$anio),
      motivo = .data$motivo_sin_categoria,
      n_ee_B = as.integer(.data$n_ee)
    )

  dplyr::full_join(a, b, by = llave) |>
    dplyr::mutate(
      n_ee_A = tidyr::replace_na(.data$n_ee_A, -1L),
      n_ee_B = tidyr::replace_na(.data$n_ee_B, -1L),
      dif_n_ee = abs(.data$n_ee_A - .data$n_ee_B)
    ) |>
    dplyr::filter(.data$dif_n_ee > AUD_TOL_CONTEO)
}


# Spot-check del bloque invariante de referencia (Costa Central / basica).
# Devuelve la distribucion del bloque por anio desde el camino B, para fijarla
# como referencia estable entre builds. No compara: imprime para inspeccion y
# para anclar el invariante en el reporte.
aud_spot_check_referencia <- function(df_B) {
  df_B |>
    dplyr::filter(
      .data$nom_entidad == AUD_REF_ENTIDAD,
      .data$nivel == AUD_REF_NIVEL
    ) |>
    dplyr::select(anio, categoria, n_ee, n_categorizados, pct) |>
    dplyr::arrange(anio, categoria)
}
