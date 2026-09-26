# LOG — guarda de locale UTF-8 (pendiente #5), verificada y documentada (a13)

- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_categoria_guarda_locale_a13.md`
- **Ejecutor:** Claude Code, modo autónomo, todo en un turno, sin subagentes, esfuerzo `xhigh`, sobre el filesystem local de la estación (macOS).
- **Modo de la sesión (declarado por el encabezado de contrato):** la sesión corre con el modelo Opus 5.5 (1M) y el esfuerzo `ultracode` (`xhigh` más orquestación dinámica de workflows). Manda el encargo: orquestador el modelo de la sesión, 0 subagentes, 0 workflows, cadena en serie.
- **Acto externo autorizado en el lanzamiento (D5 = a):** un único `git push origin main` en FASE L, solo con el simulacro del hook en exit 0 y sin `--no-verify` ni `--force`. Cualquier otro acto externo se consulta.
- **Fecha:** 2026-09-26.
- **Punto de retorno `<inicio>`:** se fija en M4.
- **Rama:** `main`.
- **Convención de rutas:** `<RAIZ>` es la raíz del repositorio y `<KIT>` es `$HERRAMIENTAS_DEV_PATH`. Ninguna ruta absoluta de la estación entra a este LOG.

## Índice

- FASE 0
- T1: verificar la guarda, verla fallar y commitear el código
- T2: el pipeline completo reproduce la base
- T3: marcador
- FASE R: auditoría propia y reparación
- FASE L: cierre del log
- J. Juicio

### FASE 0

Primer acto: LOG creado con encabezado, esqueleto y el slot vacío del bloque J, antes de cualquier comando git del turno. El primer script (`/tmp/cat_a13_m12.sh`) exporta `GIT_OPTIONAL_LOCKS=0` en su primera línea; su única llamada git anterior al `fetch` es `git rev-parse --show-toplevel`, que exige ENTORNO. El `fetch` corrió con `-c maintenance.auto=false`.

| # | Medición | esperado | obtenido |
|---|---|---|---|
| M1 | rama; porcelain; stash | `main`; las líneas de §2; vacío | `main`; ` M` de `00_run_all.R`, de los 5 scripts y del archivo de errores; `??` de `10_utils/10_configuracion.R`, `10_utils/10_locale.R`, el encargo y el LOG (11 líneas); stash con 0 líneas. PASA |
| M2 | `fetch`; `HEAD`; `origin/main`; deltas; basename y remoto; filas | exit 0; `4aac27c` = `origin/main`; 0 y 0; ENTORNO; 9 filas | fetch exit 0; `HEAD` = `origin/main` = `4aac27c8d3e659297f2b05f4d5c837f5069c5757`; 0 y 0; `slep_categoria_desempeno` y la URL de ENTORNO; 9 filas; solo `refs/heads/main` en el remoto; `50_locale_utf8.md` ausente. PASA |
| M3 | md5 de las 8 rutas; `cmp`; numstat; texto insertado; ASCII y parseo | = §1 | 8 de 8 md5 iguales a §1; `cmp` con `<KIT>/plantillas/10_locale.R` exit 0; numstat `3	0` (`00_run_all.R`) y `1	0` en los 5 scripts; en cada script el `source(here::here("10_utils", "10_configuracion.R"))  # guarda de locale UTF-8 (POLITICA 5.2bis)` está en la línea siguiente a `library(here)` (31→32, 37→38, 41→42, 50→51, 30→31), una vez por script; en `00_run_all.R`, tras el cierre de `instalar_si_falta(...)` en la línea 39, quedan la vacía 40, el comentario en la 41 y el `source(file.path(raiz, "10_utils", "10_configuracion.R"))` en la 42 (git alinea el bloque agregado en 41 a 43: comentario, `source` y vacía; mismo contenido); `10_configuracion.R` con 0 líneas no ASCII (`file`: ASCII text), 22 líneas, parsea en 3 expresiones: `source(here::here("10_utils", "10_locale.R"))`, `asegurar_locale_utf8("10_configuracion")` y `ruta_insumos <- function(...) here::here("20_insumos", ...)`; 0 `try(` o `suppressWarnings(` alrededor de la guarda. PASA |
| M4 | commit de FASE 0; `<inicio>`; porcelain | 2 archivos; las 8 rutas y el LOG | commit `aa74983aa64086c195f9cc074d13b7d49c984a56` con exactamente el encargo y el archivo de errores (privacidad previa: RUT 0 y `$HOME` 0); `<inicio>` = `aa74983`; porcelain = 6 ` M`, 2 `??` del código y el LOG. PASA |
| M5 | copia de `40_salidas/` a `/tmp/cat_a13_base/`, listado, md5 y bytes; SHA con calibración | copia completa; `d9895a78…0442` | 9 archivos copiados con `cp -Rp`, `diff -rq` con 0 diferencias. Listado: `categoria_rbd_contrato.parquet` 137091 `473f7645…`; `intermedios/.gitkeep` 0; `intermedios/categoria_rbd.parquet` 369802 `04636273…`; `categoria_sin_vigente.parquet` 13967 `86194118…`; `categoria_territorial.parquet` 41350 `9520793d…`; `comunas_chile.parquet` 7355 `cd5f23db…`; `establecimientos_chile.parquet` 266980 `99e825ca…`; `sleps_chile.parquet` 60096 `a4a4f033…`; `motor_categoria.html` 1888877 `018f6365…` (= `HEAD:docs/index.html`). SHA del motor `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`; fecha alterada igual; cifra plantada `162ff49e…`. Los parquet son del 2026-07-01 (intermedios) y del 2026-07-04 (contrato), minutos antes de los últimos commits de los scripts 30 y 34; los scripts 31 y 32 son de junio. PASA |
| M6 | kit; md5 de la plantilla; `Rscript`, renv y `arrow` | `dc900c1b…`; disponibles | `HERRAMIENTAS_DEV_PATH` resuelve (basename `herramientas_dev`); plantilla `dc900c1b0d2d252c9e5730875be5d632`; verificador presente; R 4.5.2; renv activo; `arrow` 24.0.0, `dplyr` y `here` disponibles; proceso en `es_ES.UTF-8`. PASA |

**Hallazgo de FASE 0: la variante literal no arranca en C en esta estación, y decisión de instrumento.** Antes de T1 medí cómo arranca R bajo la receta de la POSICIÓN:
- `env LC_ALL= LC_CTYPE= LANG=C Rscript -e ...`, en `/tmp` y en `<RAIZ>` con renv: `LC_CTYPE=es_ES.UTF-8`, `LANG=es_ES.UTF-8`. R lee el `~/.Renviron` de la estación, que fija `LANG` (no se abrió el archivo: se midió el efecto).
- Con `--no-environ`: `LC_CTYPE=C`, `LANG=C`. En `<RAIZ>`, con `--no-environ`, renv queda activo, `arrow` 24.0.0, `dplyr` y `here` cargan, y el proceso está en `C` con `UTF-8=FALSE`.

El arnés del kit (V3 de `90_verificar_locale.R`) combina `env = c("LC_ALL=", "LC_CTYPE=", "LANG=C")` con `Rscript --vanilla`, que incluye `--no-environ`; por eso el verificador sí prueba en C. Con la receta literal, el 🔒4 («la guarda emite su `message()` de corrección, nombrando la locale de partida») no podría ocurrir: es un esperado falso por construcción. Decisión, con el criterio del 🔒4 intacto: las corridas «bajo locale C» se hacen **en dos variantes**.
- **Literal** (`env LC_ALL= LC_CTYPE= LANG=C Rscript ...`), como registro.
- **Del arnés del kit** (lo mismo más `--no-environ`, la pieza del `--vanilla` del arnés que evita `~/.Renviron`). Es la que evalúa el 🔒4.

No se usa `--vanilla` completo porque saltaría el `.Rprofile` y R quedaría sin renv. Se registra como duda D7.

M1
esperado: `main`; exactamente las líneas de §2 y el LOG; stash vacío
obtenido: `main`; esas 11 líneas; stash con 0 líneas. PASA

M2
esperado: fetch exit 0; `4aac27c` = `origin/main`; 0 y 0; ENTORNO; 9 filas
obtenido: fetch exit 0; `4aac27c` = `origin/main`; 0 y 0; ENTORNO; 9 filas. PASA

M3
esperado: md5 de las 8 rutas, `cmp`, numstat y texto insertado = §1; `10_configuracion.R` ASCII y parsea
obtenido: 8 de 8; `cmp` exit 0; `3	0` y 5 veces `1	0`; texto y posición = §1; ASCII y 3 expresiones. PASA

M4
esperado: commit = 2 archivos; porcelain = las 8 rutas de §1 y el LOG
obtenido: `aa74983` con 2 archivos; porcelain = las 8 rutas y el LOG. PASA

M5
esperado: copia completa de `40_salidas/`; SHA `d9895a78…0442` con calibración
obtenido: 9 de 9 archivos, 0 diferencias; SHA `d9895a78…0442`, calibración correcta. PASA

M6
esperado: plantilla `dc900c1b…`; `Rscript`, renv y `arrow` disponibles
obtenido: `dc900c1b…`; R 4.5.2, renv activo, `arrow` 24.0.0. PASA

**Cierre de FASE 0:** ninguna regla de detención activa.

### T1: verificar la guarda, verla fallar y commitear el código

- **ALCANCE:** las 8 rutas de §1 (sin editar ninguna: el código lo escribió el asistente y se verifica tal cual).

**Paso 1, verificador del kit** (`cd <KIT> && Rscript plantillas/90_verificar_locale.R <RAIZ> dc900c1b0d2d252c9e5730875be5d632`; salida con la raíz reemplazada):

esperado: V1 a V4 OK y `GUARDA INSTALADA`
obtenido: exit 0. PASA

```
[ OK ] V1 archivo             identico a la plantilla
[ OK ] V2 arranque            primera linea ejecutable (expresion 2)
[ OK ] V3 proceso             LANG=C corregida a es_ES.UTF-8
[ OK ] V4 hijos               el nieto hereda es_ES.UTF-8

GUARDA INSTALADA: las cuatro verificaciones pasan.
```

Antes de esas líneas, el renv del kit imprime «None of the packages recorded in the lockfile are currently installed». Es el renv de la raíz del kit, desde donde se corre el verificador; no afecta, porque el verificador solo usa R base y su subproceso corre con `--vanilla`.

**Paso 2, `validar_portabilidad(detener_si_falla = FALSE)`** (`/tmp/cat_a13_portabilidad.R`, desde `<RAIZ>` con renv):

esperado: 🔒6: `locale_utf8` y `data_root_resuelto` PASA («Resuelto por ruta_insumos()»); `configuracion_presente` ya no aparece; el resto se anota
obtenido: exit 0; 15 archivos escaneados; 0 fallas críticas y 4 advertencias; `configuracion_presente` no aparece. PASA

| check de entorno | estado | detalle |
|---|---|---|
| `ancla_here` | OK | |
| `locale_utf8` | OK | |
| `renv_lock` | OK | |
| `renviron_en_gitignore` | OK | |
| `renviron_no_en_repo` | OK | |
| `renviron_example` | OK | |
| `data_root_resuelto` | OK | Resuelto por `ruta_insumos()` |
| `salidas_escribibles` | OK | |

Hallazgos estáticos (advertencias, preexistentes o de la plantilla): `separador_manual` en `00_escanear_proyecto.R` (líneas 95 y 178) y en `tests/auditar_cifras.R` (línea 192), y `system_shell` en `10_utils/10_locale.R` (línea 27, un comentario de la plantilla, que no se edita). El validador carga `10_configuracion.R`, y la guarda imprimió su aviso de «rama 1»: el proceso ya era UTF-8, pero el entorno no declaraba `LC_CTYPE` y lo exportó. Es la conducta esperada de la plantilla.

**Paso 3, bajo locale C** (`/tmp/cat_a13_locale_c.sh`; cada corrida seguida de PRUEBA c y de restore de `docs` si cambió):

esperado: 🔒4: `run_all(only = 33)` y `Rscript 30_procesamiento/33_generar_html.R` bajo `env LC_ALL= LC_CTYPE= LANG=C` con exit 0; la guarda emite su `message()` de corrección nombrando la locale de partida; SHA = `d9895a78…0442`
obtenido: variante del arnés (con `--no-environ`; evalúa el 🔒4): las dos corridas con exit 0 y 0 warnings. En `run_all(only = 33)`, el proceso arrancó en `LC_CTYPE=C UTF-8=FALSE` y quedó en `es_ES.UTF-8` tras cargar `00_run_all.R`. En cada corrida hubo 1 aviso: «`[ locale ] 10_configuracion: locale corregida en caliente a es_ES.UTF-8 (el proceso arranco con C)` / `y exportada al entorno (LANG, LC_CTYPE) para los procesos hijos.`», seguido del texto de síntoma y remedio de la plantilla. El motor quedó con md5 `018f63657c227036899ae3194bf9c68e` (1888877 bytes), el mismo de la base de M5 byte a byte. SHA `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`, con la calibración correcta (fecha igual; cifra `162ff49e…`). 0 escapes `<c3>`. `docs/index.html` no cambió, así que no hizo falta restore. PASA

Variante literal (sin `--no-environ`, como registro): las dos corridas con exit 0 y 0 warnings. El proceso arrancó en `es_ES.UTF-8` porque `~/.Renviron` fija `LANG`, y la guarda emitió el aviso de rama 1 («la locale del proceso era UTF-8 pero el entorno no la declaraba. Se exportaron LANG y LC_CTYPE…»). Motor `018f6365…` y SHA `d9895a78…0442`, iguales. Confirma el hallazgo de FASE 0.

**Paso 4, commit** `feat(entorno): instala la guarda de locale UTF-8 en el arranque (a13)` = `2d6ea894325caa5efe55a8ddf8dab9ff7374a42b`, con las 8 rutas explícitas (`A` de las 2 nuevas y `M` de las 6). Numstat: `3	0` `00_run_all.R`; `22	0` `10_configuracion.R`; `220	0` `10_locale.R`; `1	0` en los 5 scripts. RUT 0 y `$HOME` 0 en lo agregado; porcelain después: solo el LOG.

**Paso 5, prueba de rotura** (`/tmp/cat_a13_rotura.py` comenta la única línea `asegurar_locale_utf8("10_configuracion")`, la 17; `git diff --stat`: 1 archivo, `+1 -1`):

esperado: con la invocación comentada, FALLO en V2, V3 y V4
obtenido: exit 1. PASA

```
[ OK ] V1 archivo             identico a la plantilla
[FALLO] V2 arranque            asegurar_locale_utf8() no se invoca
[FALLO] V3 proceso             arranco bajo LANG=C y quedo en C
[FALLO] V4 hijos               el nieto quedo en C: la guarda corrige pero no exporta

GUARDA NO INSTALADA: fallan V2, V3, V4.
```

esperado: tras `git restore 10_utils/10_configuracion.R`, `git diff --stat` vacío y el verificador en `GUARDA INSTALADA`
obtenido: restore exit 0; `git diff --stat` vacío; md5 `e426f50d6186e728706c80491841e3c6`; verificador exit 0 con V1 a V4 OK y `GUARDA INSTALADA`; porcelain: solo el LOG. PASA

- **T1: completada.**

### T2: el pipeline completo reproduce la base

- **ALCANCE:** ninguna ruta versionada. Solo corre el pipeline, que escribe en `40_salidas/` (fuera de git), y el build regenera `docs/index.html`. Entorno normal del shell de la herramienta: `LANG=en_NZ.UTF-8`, con `LC_ALL` y `LC_CTYPE` vacías.

esperado: `run_all()` (pasos 30 a 33) con renv: exit 0 y 0 warnings
obtenido: exit 0; 0 warnings; renv activo; `Paso 30 OK`, `Paso 31 OK`, `Paso 32 OK`, `Paso 33 OK`; `Ejecutados: 30, 31, 32, 33`; 1 aviso de la guarda (rama 1: exportó `LC_CTYPE`). PASA

esperado: `Rscript 30_procesamiento/34_exportar_contrato_categoria.R`: exit 0
obtenido: exit 0, 0 warnings, `34_exportar_contrato_categoria.R: OK. Contrato en 40_salidas/categoria_rbd_contrato.parquet`. Porcelain tras las corridas: solo el LOG (ninguna ruta versionada cambió; `docs/index.html` quedó idéntico). PASA

esperado: 🔒5: el contenido de cada archivo de `40_salidas/` es igual a la base de M5 (parquet con `identical()` sobre `arrow::read_parquet()`; HTML por SHA del payload)
obtenido: con `/tmp/cat_a13_cmp_salidas.R`, 9 archivos en la base y 9 en la nueva, ninguno exclusivo de una. PASA

| archivo | contenido | md5 |
|---|---|---|
| `categoria_rbd_contrato.parquet` | `identical()` TRUE; 41244 filas, 5 columnas | distinto (binario) |
| `intermedios/.gitkeep` | igual | igual |
| `intermedios/categoria_rbd.parquet` | `identical()` TRUE; 41244 × 9 | distinto (binario) |
| `intermedios/categoria_sin_vigente.parquet` | `identical()` TRUE; 1985 × 7 | distinto (binario) |
| `intermedios/categoria_territorial.parquet` | `identical()` TRUE; 10780 × 9 | distinto (binario) |
| `intermedios/comunas_chile.parquet` | `identical()` TRUE; 345 × 4 | distinto (binario) |
| `intermedios/establecimientos_chile.parquet` | `identical()` TRUE; 10945 × 6 | distinto (binario) |
| `intermedios/sleps_chile.parquet` | `identical()` TRUE; 2337 × 7 | distinto (binario) |
| `motor_categoria.html` | SHA del payload `d9895a78…` = `d9895a78…` | igual (`018f6365…`) |

Los tamaños de los 7 parquet son iguales a los de la base. Causa medida de la diferencia binaria, sobre `categoria_rbd.parquet`: 2 bytes distintos de 369802, en el pie del archivo, dentro de la cadena de versión del escritor (`parquet-cpp-arrow version 23.0.1` en la base del 2026-07-01, `24.0.0` hoy). Es el paquete `arrow`, actualizado desde entonces, no el contenido. El encargo lo trata como diferencia binaria, no como FALLA.

esperado: PRUEBAS b y c
obtenido: `auditar_cifras.R` exit 0, F1 a F4 OK, 0 warnings; `spot_check_publicado.R` exit 0, 6 celdas y 1 ausencia OK; SHA de `docs` `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442` (fecha igual; cifra `162ff49e…`). PASA

esperado: `git restore docs/index.html` si cambió
obtenido: `docs/index.html` no cambió (md5 `018f6365…` = `HEAD`); no hizo falta restore; porcelain: solo el LOG. PASA

- Sin commit: T2 no toca rutas versionadas.
- **T2: completada.**

### T3: marcador

- **ALCANCE:** `50_documentacion/activa/50_locale_utf8.md` («Constancia: guarda de locale UTF-8», 109 líneas).
- Contenido, copiado de este LOG:
  - fecha, encargo, LOG y commit del código;
  - la decisión A′ y su motivo (el incidente de `slep_simce_adecuado`, sesión 34, parafraseado sin copiar texto ni rutas del modelo);
  - la tabla de piezas (`10_locale.R` = plantilla `dc900c1b…`; `10_configuracion.R` `e426f50d…`; el orquestador y los 5 scripts);
  - la salida del verificador y la de la prueba de rotura;
  - las corridas bajo locale C, con el hallazgo de `~/.Renviron` y `--no-environ`;
  - la corrida completa con contenido igual a la base (y la causa de la diferencia binaria de los parquet);
  - la tabla de `validar_portabilidad()`;
  - el CI;
  - lo que queda fuera.
- Dos afirmaciones se re-midieron antes de escribirlas:
  - CI: `.github/workflows/validacion_seguridad.yml` es el único workflow, con 0 apariciones de `Rscript`, `setup-r`, `r-lib` o `LANG`.
  - `tests/` y la suite tienen 0 menciones de `10_configuracion.R`; fuera de las 8 rutas solo la mencionan `.Renviron.example` y `10_validar_portabilidad.R`, que la carga en un entorno aparte para sondear el accesor.

esperado: marcador sin rutas absolutas, sin RUT ni `$HOME`
obtenido: RUT 0; `$HOME` 0; 0 apariciones de `/Users`. PASA

- **Commit** `docs(entorno): constancia de la guarda de locale UTF-8 (a13)` = `22f9e1d04bdd817080ddc975c26a2ba174658c4b`, solo con el marcador. Porcelain después: solo el LOG.
- **T3: completada.**

### FASE R: auditoría propia y reparación

**1. Inventario R-01…R-24**, derivado del LOG anterior a esta auditoría y anexado antes de auditar:

| id | afirmación (LOG) |
|---|---|
| R-01 | M1: `main`; porcelain de 11 líneas; stash vacío |
| R-02 | M2: fetch exit 0; `HEAD` = `origin/main` = `4aac27c`; 0 y 0; ENTORNO; 9 filas |
| R-03 | M3: 8 md5 = §1; `cmp` con la plantilla exit 0; numstat de las 6; texto y posición de las inserciones; `10_configuracion.R` ASCII y con 3 expresiones |
| R-04 | M4: commit `aa74983` con 2 archivos; porcelain = 8 rutas y LOG |
| R-05 | M5: base de 9 archivos con sus md5 y bytes; SHA `d9895a78…0442` |
| R-06 | M6: plantilla `dc900c1b…`; R 4.5.2, renv y `arrow` 24.0.0 |
| R-07 | FASE 0: bajo la receta literal R arranca en `es_ES.UTF-8` (por `~/.Renviron`); con `--no-environ`, en `C` y con renv |
| R-08 | T1: verificador `GUARDA INSTALADA` (V1 a V4 OK) |
| R-09 | T1: `validar_portabilidad()` con 0 críticas y 4 advertencias; `locale_utf8` y `data_root_resuelto` OK; sin `configuracion_presente` |
| R-10 | T1: bajo C (arnés), exit 0, aviso de corrección desde `C`, motor = base, SHA `d9895a78…0442`, 0 escapes |
| R-11 | T1: bajo C (literal), exit 0, aviso de rama 1, motor = base |
| R-12 | T1: commit `2d6ea89` con las 8 rutas; numstat `3	0`, `22	0`, `220	0` y cinco veces `1	0` |
| R-13 | T1: rotura con V2, V3 y V4 en FALLO; restore con diff vacío y `GUARDA INSTALADA` |
| R-14 | T2: `run_all()` y el paso 34 con exit 0 y 0 warnings; porcelain solo el LOG |
| R-15 | T2: 9 de 9 archivos con contenido igual a la base; 7 parquet con diferencia binaria |
| R-16 | T2: la diferencia binaria son 2 bytes de la versión de arrow en el pie |
| R-17 | T2: PRUEBAS b y c en verde; `docs` sin cambios |
| R-18 | T3: marcador sin rutas absolutas, RUT ni `$HOME`; commit `22f9e1d` |
| R-19 | T3: el CI no corre R; `tests/` y la suite no cargan `10_configuracion.R` |
| R-20 | 🔒1 a 🔒8 sobre el estado final |
| R-21 | Alcance y porcelain |
| R-22 | Regresión: PRUEBAS a, b y c |
| R-23 | Control positivo de la rotura (verificador) |
| R-24 | Control positivo del 🔒5 (parquet alterado) |

**2. Re-derivación con otro comando** (estado final, `HEAD` = `22f9e1d`):

| id | comando de re-derivación (distinto del original) | resultado |
|---|---|---|
| R-03, R-12 | `openssl dgst -md5` de las 8 rutas y de la plantilla; `git hash-object` del árbol contra `git rev-parse HEAD:<ruta>`; `git show --stat 2d6ea89` | los 8 md5 = §1 y `10_locale.R` = plantilla = `dc900c1b…`; árbol = `HEAD` en 8 de 8; `8 files changed, 250 insertions(+)` (3 + 22 + 220 + 5 × 1). Coincide |
| R-03, R-08 | `parse()` y `deparse()` propios (`/tmp/cat_a13_r_posicion.R`), además del V2 del kit | `10_configuracion.R`: 3 expresiones; la guarda es la 2; la anterior es solo un `source()` que carga `10_locale.R`; argumento `"10_configuracion"`. En los 5 scripts, la carga de la configuración es la expresión 2, justo después de `library(here)` (expresión 1), y va antes de la primera expresión que lee o escribe (15, 10, 10, 13 y 6). En `00_run_all.R` es la expresión 4, tras el anclaje de la raíz, los utils y `instalar_si_falta`, y no hay lectura ni escritura en el nivel superior. 1 carga por archivo. Coincide |
| R-07, R-10 | `l10n_info()` en un `Rscript` que carga `10_configuracion.R` bajo `env LC_ALL= LC_CTYPE= LANG=C Rscript --no-environ` (`/tmp/cat_a13_r_l10n.R`) | antes: `UTF-8=FALSE LC_CTYPE=C`, `LANG=[C] LC_CTYPE=[]`; aviso de corrección desde `C`; después: `UTF-8=TRUE LC_CTYPE=es_ES.UTF-8`, `LC_CTYPE=[es_ES.UTF-8]` exportada; un hijo `Rscript --vanilla` da `TRUE es_ES.UTF-8`. Control sin la guarda (copia de `10_configuracion.R` con la línea comentada, fuera del árbol): antes y después `UTF-8=FALSE LC_CTYPE=C`, hijo `FALSE C`. La corrección la hace la guarda. Coincide |
| R-15 | comparación por filas ordenadas (`all.equal` sobre los datos ordenados por todas las columnas) y `dplyr::anti_join` en los dos sentidos (`/tmp/cat_a13_r_filas.R`), en lugar de `identical()` | 7 de 7 parquet iguales: mismas filas, `all.equal` TRUE, `anti_join` 0 y 0 y mismos tipos. Coincide |
| R-05, R-10, R-17 | verificador Python del SHA (`zlib`, `json`, `hashlib`), en lugar de node | `git show HEAD:docs/index.html`, motor de `40_salidas` y motor de la base: los tres `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`. Coincide |
| R-02 | `git ls-remote --heads origin` | `main` = `4aac27c` en el remoto (el push va en FASE L). Coincide |

**3. Invariantes, con salida literal** (sobre el estado final, antes del commit del LOG):

| 🔒 | comando | salida | veredicto |
|---|---|---|---|
| 1 | md5 de las 8 rutas; `cmp` con la plantilla; `git diff --numstat aa74983..HEAD` | `md5 iguales a §1: 8 de 8`; `cmp con la plantilla exit=0`; `3	0 00_run_all.R`, `22	0 10_utils/10_configuracion.R`, `220	0 10_utils/10_locale.R` y `1	0` en los 5 scripts; las dos nuevas no existían en `<inicio>` y entran completas (22 y 220 líneas = `wc -l`) | PASA |
| 2 | `git diff --name-only aa74983..HEAD -- 30_procesamiento/33_app.jsx 30_procesamiento/33_motor_template.html docs tests 20_insumos renv.lock .github 10_utils/10_utils.R 10_utils/10_validar_portabilidad.R \| wc -l` | `0` | PASA |
| 3 | verificador del kit sobre el estado final; rotura y restauración de T1 | V1 a V4 `[ OK ]`, `GUARDA INSTALADA`; en rotura, V2, V3 y V4 `[FALLO]`; restaurado, `GUARDA INSTALADA` | PASA |
| 4 | `/tmp/cat_a13_locale_c.sh arnes R` | `run_all33: exit=0; warnings=0` y `script33: exit=0; warnings=0`; en cada una, `[ locale ] 10_configuracion: locale corregida en caliente a es_ES.UTF-8 (el proceso arranco con C)`; motor `018f6365…` = base; SHA `d9895a78…0442`; 0 escapes | PASA (variante del arnés; la literal no arranca en C, R-07) |
| 5 | PRUEBAS b y c; `/tmp/cat_a13_cmp_salidas.R /tmp/cat_a13_base 40_salidas` | F1 a F4 OK y `SPOT-CHECK OK`; SHA `d9895a78…0442` con calibración; `contenido igual: 9 de 9` | PASA |
| 6 | `validar_portabilidad(detener_si_falla = FALSE)` | `RESUMEN criticas=0 advertencias=4 ok=TRUE`; `configuracion_presente aparece: FALSE`; `CHECK locale_utf8 \| OK`; `CHECK data_root_resuelto \| OK \| Resuelto por ruta_insumos()` | PASA |
| 7 | `git diff --name-only aa74983..HEAD` (sin el LOG) | las 8 rutas de §1 y `50_documentacion/activa/50_locale_utf8.md` | PASA en lo medible (9 de 10 por diseño; forma completa en FASE L) |
| 8 | `git log aa74983..HEAD --format=%B \| grep -ci co-authored`; `git diff aa74983..HEAD \| grep '^+' \| grep -cE` RUT; `grep -cF "$HOME"` | `0`; `0`; `0` | PASA |

**4. Alcance y porcelain:** `git diff --name-only aa74983..HEAD` = las 8 rutas (ALCANCE de T1) y el marcador (ALCANCE de T3); T2 no dejó rutas versionadas modificadas. `git status --porcelain` = solo `?? ...a13_log.md`. PASA.

**5. Regresión:**

esperado: PRUEBAS a: `run_all(only = 33)` exit 0 y 0 warnings, restore de `docs` si cambió; PRUEBAS b en verde; PRUEBA c = `d9895a78…0442` con calibración
obtenido: exit 0; 0 warnings; renv activo; `Paso 33 OK`; motor y `docs` `018f6365…` (sin cambios, así que no hizo falta restore); F1 a F4 OK con 0 warnings; `SPOT-CHECK OK: 6 celdas de presencia + 1 de ausencia`; SHA `d9895a78…0442`, fecha igual y cifra `162ff49e…`. El contenido de `40_salidas` sigue igual a la base: 9 de 9. PASA

**6. Control positivo:**

esperado: la rotura de T1 la detecta el verificador (V2, V3 y V4 en FALLO)
obtenido: detectada en T1 (paso 5). Además, en la re-derivación de `l10n_info()`, la copia sin la guarda deja el proceso y el hijo en `C`. PASA

esperado: un parquet con una celda alterada, en una copia fuera del árbol, lo detecta la comparación del 🔒5
obtenido: en `/tmp/cat_a13_ctrl_salidas/` (copia de la base), la fila 1 de la columna `anio` de `intermedios/categoria_territorial.parquet` se cambió de 2016 a 2017. `/tmp/cat_a13_cmp_salidas.R` dio `DISTINTO ... identical()=FALSE` y `contenido igual: 8 de 9`; la comparación por filas ordenadas dio `DISTINTO ... anti_join 1 y 1` y 6 de 7. La reescritura también cambió el tipo de la columna (la suma dio un doble), pero `anti_join` 1 y 1 muestra que se detecta el valor. PASA

**7 a 10. Veredicto por hallazgo:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-07 | la receta literal pone a R en locale C | `Rscript` con y sin `--no-environ` bajo `env LC_ALL= LC_CTYPE= LANG=C`; `l10n_info()` | proceso en `C` | la literal arranca en `es_ES.UTF-8` porque `~/.Renviron` fija `LANG`; con `--no-environ`, en `C` | ADVIERTE | el 🔒4 se evalúa con la variante del arnés (`--no-environ`, la pieza del `--vanilla` del kit); la literal queda como registro; el criterio del 🔒4 no cambia; duda D7 | — | 🔒4 en T1 y en FASE R: corrección desde `C` |
| R-15, R-16 | contenido de `40_salidas` igual a la base | `identical()` y filas ordenadas | igual | igual en 9 de 9; 7 parquet con diferencia binaria (versión de arrow en el pie) | — (el encargo la trata como diferencia binaria) | se anota | — | 2 bytes, versión 23.0.1 → 24.0.0 |
| R-20 (🔒7) | alcance = 8 rutas, marcador y LOG | `git diff --name-only aa74983..HEAD` | 10 rutas | 9 antes de FASE L | ADVIERTE (por diseño) | se mide completo en FASE L, después del commit del LOG | — | FASE L |
| resto | R-01 a R-06, R-08 a R-14, R-17 a R-19 y R-21 a R-24 | pasos 2 a 6 | lo que dice cada fila | igual a lo esperado | — | ninguna | — | — |

No hay hallazgos **BLOQUEA**: ningún 🔒 falla, el contenido de `40_salidas` es igual a la base, las PRUEBAS b y c están en verde y el alcance se respeta. Tampoco hay **REPARA**, ni ciclo de reparación ni `git revert`.

**Veredicto de FASE R: APROBADO CON ADVERTENCIAS** (R-07, instrumental, y el 🔒7 pendiente de FASE L por diseño).

### FASE L: cierre del log

**1. Porcelain.**

esperado: `git status --porcelain` = solo el LOG
obtenido: `?? 50_documentacion/andamios/logs/20260926_guarda_locale_a13_log.md`, en `main`. PASA

**2. Resumen.** El a13 verificó, commiteó y documentó la guarda de locale UTF-8 (pendiente #5, esquema A′) que el asistente había dejado escrita.
- Las 8 rutas de §1 calzaron por md5, por `cmp` con la plantilla, por numstat y por posición. El verificador del kit da `GUARDA INSTALADA`, y la prueba de rotura hace fallar V2, V3 y V4 hasta restaurar el archivo.
- Bajo locale C (variante del arnés), el motor sale byte a byte igual a la base y la guarda avisa la corrección desde `C`. Hallazgo: en esta estación la receta literal no arranca en C, porque `~/.Renviron` fija `LANG`; hace falta `--no-environ`.
- La corrida completa del pipeline (30 a 33 y 34) reproduce el contenido de los 9 archivos de `40_salidas/`. Los parquet solo difieren en la versión de arrow del pie.
- `validar_portabilidad()` queda con 0 críticas, `locale_utf8` y `data_root_resuelto` OK, y sin `configuracion_presente`.
- La constancia `50_locale_utf8.md` apaga el gatillo 4ter.
- FASE R re-derivó cada afirmación con otro comando, y los controles positivos discriminan. Veredicto: **APROBADO CON ADVERTENCIAS**.

**3. Commits** (`git log --oneline aa74983^..HEAD`; el `docs(log)` va encima y su hash queda en el reporte final):

| commit | mensaje |
|---|---|
| `aa74983` | `chore(encargo): guarda de locale UTF-8 a13` (FASE 0, `<inicio>`) |
| `2d6ea89` | `feat(entorno): instala la guarda de locale UTF-8 en el arranque (a13)` (T1) |
| `22f9e1d` | `docs(entorno): constancia de la guarda de locale UTF-8 (a13)` (T3) |

**4. Tabla de FASE R:** en FASE R, pasos 1 a 10.

**5. 🔒 con evidencia** (salida literal en FASE R, paso 3): 🔒1 a 🔒6 y 🔒8 PASA; el 🔒4, con la variante del arnés (R-07). El 🔒7 se mide completo después del commit de este LOG (punto 6 de FASE L del encargo) y el resultado va en el reporte final.

**6. Dudas** (pregunta cerrada):

- **D7 (nueva):** en esta estación, `~/.Renviron` fija `LANG`, así que `env LC_ALL= LC_CTYPE= LANG=C Rscript ...` no arranca en C. ¿Las pruebas «bajo locale C» de los próximos encargos agregan `--no-environ`, la pieza del `--vanilla` del arnés del kit, a la receta de la POSICIÓN? (sí / no, se define otra receta)
- **D8 (nueva):** en el entorno normal de la estación, `LC_CTYPE` no viene declarada, y la guarda imprime en cada proceso de R su aviso de rama 1 («…Se exportaron LANG y LC_CTYPE…»). ¿Se declara `LC_CTYPE` en `~/.Renviron` para silenciarlo? (sí, lo hace el titular / no, se acepta el aviso). Este encargo no tocó `~/.Renviron`.
- D6 (del a12: método estándar de captura para AE) y D1, D2 y D3 (del a11) siguen abiertas; este encargo no las toca.

**7. Errores propios:**

- **Etiquetas de `obtenido` mal escritas.** Dos resultados se escribieron como «obtenido, variante del arnés…» (T1, paso 3) y «obtenido (`…cmp_salidas.R`)…» (T2), en vez de empezar por `obtenido:`. El conteo de FASE L dio 23 `esperado:` contra 21 `obtenido:`. Se corrigió solo la etiqueta de esas dos líneas, sin tocar la evidencia; después, la paridad es exacta.
- **Detalle cosmético.** El rango de `sed` que extrae el aviso de la guarda en `/tmp/cat_a13_locale_c.sh` imprimió también el resto de la salida del build. No afectó ninguna medición: los conteos y los md5 se leen aparte.

**8. Notas para el revisor:**

- El código de §1 no se editó: se verificó tal cual y se commiteó en `2d6ea89`. `10_utils/10_locale.R` es la plantilla sin cambios.
- La variante literal bajo `LANG=C` arranca en `es_ES.UTF-8` en esta estación (R-07). La corrección desde `C` se observó con `--no-environ` y también con el verificador del kit, que usa `--vanilla`. En una máquina sin `LANG` en `~/.Renviron`, las dos recetas equivalen.
- Los parquet regenerados difieren en md5 de los de julio solo por la versión de arrow escrita en el pie (23.0.1 → 24.0.0); su contenido es idéntico.
- El validador sigue marcando 4 advertencias estáticas anteriores al cambio o de la plantilla; ninguna es crítica.
- Los temporales quedan en `/tmp/cat_a13_*`, entre ellos la base de `40_salidas` y la copia con una celda alterada. No se borró nada.
- El `CLAUDE.md` local (ignorado por git) no se actualizó porque está fuera de ALCANCE. Queda para el cierre de sesión.

**9. Privacidad del LOG y conteos:**

esperado: grep del patrón de RUT sobre el LOG = 0; `grep -cF "$HOME"` = 0; sin nombres, sin RBD con número y sin datos
obtenido: 0; 0; la lectura no encuentra nombres de establecimiento ni de personas; 0 RBD con número; solo conteos, hashes y nombres de archivos y columnas. PASA

esperado: `grep -c '^### FASE'` = 3; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1
obtenido: se mide sobre este archivo terminado, antes del commit; la salida literal va en el reporte final junto con `ls -l` y `wc -l`

**10. Cierre:**
- commit `docs(log): guarda de locale UTF-8 a13` (solo el LOG);
- 🔒7 completo;
- simulacro del hook `refs/heads/main <HEAD> refs/heads/main <origin/main>` (esperado exit 0);
- `git push origin main`, el único acto externo, autorizado en el lanzamiento.

Estado esperado: `main` = `origin/main`, porcelain vacío.

## J. Juicio (lo rellena FASE L)

- **Meta y resultado:** verificar, ver fallar, commitear y documentar la guarda de locale UTF-8 que el asistente dejó escrita (A′). Resultado: `GUARDA INSTALADA`; la rotura se detecta; la corrección desde `C` deja el motor byte a byte igual; el pipeline completo reproduce el contenido de `40_salidas/`; hay constancia versionada. Veredicto de FASE R: **APROBADO CON ADVERTENCIAS**.
- **Estado por tarea:**
  - FASE 0: completa (M1 a M6 PASA, más el hallazgo de `~/.Renviron`).
  - T1: completada (`2d6ea89`).
  - T2: completada (sin commit).
  - T3: completada (`22f9e1d`).
  - FASE R: aprobado con advertencias.
  - FASE L: este cierre.
- **Commits:** `aa74983` (FASE 0) → `2d6ea89` (T1) → `22f9e1d` (T3) → `docs(log)` (este LOG), en `main` sobre `4aac27c`.
- **Auditoría:** cada afirmación se re-derivó con un comando distinto:
  - md5 con `openssl` y `git hash-object`;
  - la posición de la guarda con `parse()` y `deparse()` propios;
  - la locale con `l10n_info()` bajo `C`, con un control sin la guarda;
  - los parquet por filas ordenadas y `anti_join`;
  - el SHA con Python.

  Todo coincidió. Los controles positivos discriminan: la rotura da FALLO en V2, V3 y V4, y una celda alterada la detectan los dos comparadores.
- **Invariantes:** 🔒1 a 🔒6 y 🔒8 PASA con salida literal (FASE R, paso 3); el 🔒4, con la variante del arnés. El 🔒7 queda en 9 de 10 hasta el commit de este LOG y se mide completo en FASE L (reporte final).
- **Cifras críticas:**
  - 8 de 8 md5 = §1; plantilla `dc900c1b…`;
  - numstat `3	0`, `22	0`, `220	0` y cinco veces `1	0`;
  - motor `018f63657c227036899ae3194bf9c68e`, igual a la base en todas las corridas;
  - SHA `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`;
  - `40_salidas`: 9 de 9 con contenido igual;
  - validador: 0 críticas y 4 advertencias.
- **Decisiones autónomas de mayor riesgo:**
  - Evaluar el 🔒4 con `--no-environ` (la pieza del `--vanilla` del arnés del kit), después de medir que la receta literal no arranca en C por `~/.Renviron`, y dejar la literal como registro. El criterio del 🔒4 no cambió.
  - No tocar `~/.Renviron`.
- **Desviaciones:**
  - la receta de las corridas bajo C agrega `--no-environ` para la variante que evalúa el 🔒4 (declarada en FASE 0 y en R-07);
  - la única llamada git antes del `fetch` fue `rev-parse --show-toplevel`, que exige ENTORNO, con `GIT_OPTIONAL_LOCKS=0`.
- **Dudas abiertas:** D7 (receta bajo C con `--no-environ`) y D8 (declarar `LC_CTYPE` en `~/.Renviron`), nuevas; D6, D1, D2 y D3, heredadas.
- **Errores propios:** dos, en FASE L punto 7, sin efecto en las mediciones: dos etiquetas de `obtenido` mal escritas, corregidas en FASE L sin tocar la evidencia, y un rango de `sed` que imprimió de más.
- **Qué debe verificar el revisor:**
  - el diff de `2d6ea89` (8 rutas; solo agregados);
  - la constancia `50_locale_utf8.md`;
  - las respuestas a D7 y D8.
- **No publicado / queda al usuario:**
  - el push y el 🔒7 completo (en el reporte final);
  - D7, D8 y las dudas heredadas;
  - la actualización del `CLAUDE.md` local, fuera de ALCANCE;
  - los temporales de `/tmp/cat_a13_*`.
- **Ejecución:** autónoma, en un turno, sin subagentes ni workflows, esfuerzo `xhigh`. La sesión estaba en `ultracode` con Opus 5.5 y mandó el encargo. Sin pausas: el único acto externo venía autorizado en el lanzamiento.

