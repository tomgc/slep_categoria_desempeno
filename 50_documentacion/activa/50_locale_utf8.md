# Constancia: guarda de locale UTF-8

- **Fecha:** 2026-09-26.
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_categoria_guarda_locale_a13.md` (a13).
- **LOG:** `50_documentacion/andamios/logs/20260926_guarda_locale_a13_log.md`.
- **Commit del código:** `2d6ea89` (`feat(entorno): instala la guarda de locale UTF-8 en el arranque (a13)`).

Esta constancia apaga el gatillo de SETTINGS §1.2.2, punto 4ter (POLITICA 5.2bis). Registra lo medido en el a13, copiado de su LOG.

## Decisión y motivo

El titular aprobó en la sesión 32 el punto de arranque **A′**, el esquema de `slep_simce_adecuado` y de `slep_reportes_modelo_resguardo_asistencia`. Tiene dos partes:
- `10_utils/10_configuracion.R` es el arranque común, y su primera línea ejecutable, después del `source()` de la guarda, es `asegurar_locale_utf8("10_configuracion")`;
- lo cargan el orquestador y cada script ejecutable de `30_procesamiento/`.

El motivo es un incidente medido en `slep_simce_adecuado` (sesión 34): una regeneración del motor con R en locale C escribió el JSON embebido con las tildes escapadas, sin error ni prueba que fallara. Este motor tiene la misma arquitectura.

`10_configuracion.R` declara además el accesor `ruta_insumos()`. Los insumos viven en el propio repositorio (raíz unificada), y el validador de portabilidad resuelve el data root por ese accesor.

## Piezas

| Pieza | Estado |
|---|---|
| `10_utils/10_locale.R` | copia idéntica de la plantilla del kit (`plantillas/10_locale.R`), md5 `dc900c1b0d2d252c9e5730875be5d632`; no se edita por proyecto |
| `10_utils/10_configuracion.R` | nuevo, solo ASCII, md5 `e426f50d6186e728706c80491841e3c6`; 3 expresiones: `source()` de la guarda, `asegurar_locale_utf8("10_configuracion")` y `ruta_insumos()` |
| Orquestador | `00_run_all.R` carga `10_configuracion.R` justo después del bloque `instalar_si_falta(...)` |
| Invocadores sueltos | `30_construir_auxiliares.R`, `31_leer_normalizar.R`, `32_agregar_territorial.R`, `33_generar_html.R` y `34_exportar_contrato_categoria.R`, cada uno en la línea siguiente a `library(here)` |

Ninguna invocación va envuelta en `try(..., silent = TRUE)` ni en `suppressWarnings()`.

## Verificador del kit

`Rscript plantillas/90_verificar_locale.R <repo> dc900c1b0d2d252c9e5730875be5d632`, desde la raíz del kit:

```
[ OK ] V1 archivo             identico a la plantilla
[ OK ] V2 arranque            primera linea ejecutable (expresion 2)
[ OK ] V3 proceso             LANG=C corregida a es_ES.UTF-8
[ OK ] V4 hijos               el nieto hereda es_ES.UTF-8

GUARDA INSTALADA: las cuatro verificaciones pasan.
```

## Prueba de rotura

Con la línea `asegurar_locale_utf8("10_configuracion")` comentada, el verificador falla donde debe:

```
[ OK ] V1 archivo             identico a la plantilla
[FALLO] V2 arranque            asegurar_locale_utf8() no se invoca
[FALLO] V3 proceso             arranco bajo LANG=C y quedo en C
[FALLO] V4 hijos               el nieto quedo en C: la guarda corrige pero no exporta

GUARDA NO INSTALADA: fallan V2, V3, V4.
```

Con `git restore 10_utils/10_configuracion.R`, `git diff --stat` queda vacío y el verificador vuelve a `GUARDA INSTALADA`.

## Corridas bajo locale C

En esta estación, `~/.Renviron` fija `LANG`. Por eso `env LC_ALL= LC_CTYPE= LANG=C Rscript ...` no arranca en C: R lee ese archivo y queda en `es_ES.UTF-8`. Para arrancar de verdad en C hay que agregar `--no-environ`, que es la pieza del `--vanilla` del arnés del kit que evita ese archivo; con `--no-environ`, renv y los paquetes siguen disponibles.

Con `env LC_ALL= LC_CTYPE= LANG=C Rscript --no-environ ...`, `run_all(only = 33)` y `Rscript 30_procesamiento/33_generar_html.R` salen con exit 0 y 0 warnings. El proceso arranca en `C`, y la guarda avisa una vez por corrida:

```
[ locale ] 10_configuracion: locale corregida en caliente a es_ES.UTF-8 (el proceso arranco con C)
  y exportada al entorno (LANG, LC_CTYPE) para los procesos hijos.
```

El motor queda byte a byte igual al de la línea base (md5 `018f63657c227036899ae3194bf9c68e`), con SHA del payload normalizado `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442` y 0 escapes.

En el entorno normal de la estación, `LC_CTYPE` no viene declarada, y la guarda imprime en cada proceso su aviso de rama 1: la locale ya era UTF-8 y exporta `LC_CTYPE` para los hijos. Es la conducta de la plantilla, no un error.

## Corrida completa

`run_all()` (pasos 30 a 33) y `34_exportar_contrato_categoria.R`, en el entorno normal, salen con exit 0 y 0 warnings. Los 9 archivos de `40_salidas/` tienen contenido igual a la línea base previa a la guarda:
- los 7 parquet, con `identical()` sobre `arrow::read_parquet()`;
- el motor, por SHA del payload y por md5;
- `.gitkeep`.

Los parquet difieren en md5 solo por 2 bytes del pie: la versión de arrow que los escribió (23.0.1 en la base de julio, 24.0.0 hoy). La auditoría de cifras (F1 a F4) y el spot-check del publicado salen en verde.

## Validador de portabilidad

`validar_portabilidad(detener_si_falla = FALSE)`: 15 archivos, 0 fallas críticas y 4 advertencias. Ya no aparece `configuracion_presente`.

| check de entorno | estado |
|---|---|
| `ancla_here` | OK |
| `locale_utf8` | OK |
| `renv_lock` | OK |
| `renviron_en_gitignore` | OK |
| `renviron_no_en_repo` | OK |
| `renviron_example` | OK |
| `data_root_resuelto` | OK (Resuelto por `ruta_insumos()`) |
| `salidas_escribibles` | OK |

Las advertencias son hallazgos estáticos anteriores a este cambio o de la plantilla:
- `separador_manual` en `00_escanear_proyecto.R` (2) y en `tests/auditar_cifras.R` (1);
- `system_shell` en un comentario de `10_utils/10_locale.R`.

## CI

`.github/workflows/validacion_seguridad.yml` no corre R: 0 apariciones de `Rscript`, `setup-r`, `r-lib` ni `LANG`. `LANG` no aplica.

## Lo que queda fuera

- `tests/` (`auditar_cifras.R`, `spot_check_publicado.R`) y la suite de documentación: se corren aparte y no cargan `10_configuracion.R`.
- `10_utils/10_validar_portabilidad.R` se corre bajo demanda. Carga `10_configuracion.R` en un entorno aparte, solo para sondear el accesor; no es un invocador del arranque.
