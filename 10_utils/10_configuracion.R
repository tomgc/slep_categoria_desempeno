# =============================================================================
# 10_configuracion.R - Punto de arranque comun de slep_categoria_desempeno
# -----------------------------------------------------------------------------
# Todo proceso de R del pipeline lo carga antes de su primera lectura o
# escritura: 00_run_all.R y cada script de 30_procesamiento/ que se corre
# suelto. Instala la guarda de locale UTF-8 (POLITICA 5.2bis) y declara el
# accesor ruta_insumos(): los insumos viven en el propio repositorio
# (./20_insumos, raiz unificada), asi que no hay raiz de datos externa.
# Insumos : 10_utils/10_locale.R (copia identica de la plantilla del kit).
# Salidas : ninguna; deja el proceso y su entorno en locale UTF-8, o aborta.
# =============================================================================

# Guarda de locale UTF-8: va ANTES que todo. Un proceso en locale C escribe
# texto acentuado escapado sin error visible (medido en slep_simce_adecuado,
# sesion 34: el JSON del motor salio con escapes en lugar de tildes).
source(here::here("10_utils", "10_locale.R"))
asegurar_locale_utf8("10_configuracion")

# Accesor de insumos (POLITICA 6.2, raiz unificada). El validador de
# portabilidad (10_validar_portabilidad.R) sondea este accesor y toma
# dirname() de su valor, es decir, la raiz del repositorio.
ruta_insumos <- function(...) here::here("20_insumos", ...)
