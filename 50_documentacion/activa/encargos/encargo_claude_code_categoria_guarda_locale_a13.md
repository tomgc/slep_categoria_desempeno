# Encargo autónomo: guarda de locale UTF-8 (pendiente #5), verificada y documentada (a13)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten.**
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. Si la sesión está en otro modo, el encargo manda y el LOG lo declara.
- **Actos externos (D5 = a):** uno solo, `git push origin main` en FASE L, con el OK del mensaje de lanzamiento. Cualquier otro se consulta.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS), lanzado en la raíz del repo `slep_categoria_desempeno`. Todo script empieza con `RAIZ="$(git rev-parse --show-toplevel)"`. FASE 0 verifica el `basename` y que `origin` = `https://github.com/tomgc/slep_categoria_desempeno.git`. En el LOG, `$RAIZ` se escribe `<RAIZ>` y `$HERRAMIENTAS_DEV_PATH` se escribe `<KIT>`. Ninguna ruta con nombre de usuario entra a un archivo versionado.
- **INSUMOS (en disco):**
  - este encargo y `50_documentacion/andamios/20260925_errores_asistente_sesion32.md` (modificado, 9 filas);
  - **los cambios de código ya escritos por el asistente en la carpeta (§1), sin commitear**;
  - `<KIT>/plantillas/10_locale.R` y `<KIT>/plantillas/90_verificar_locale.R`;
  - `10_utils/10_validar_portabilidad.R`;
  - `00_run_all.R`, `tests/auditar_cifras.R`, `tests/spot_check_publicado.R`;
  - LOG del a12 (verificador Python del SHA y receta de calibración);
  - modelo de marcador: `50_documentacion/activa/50_locale_utf8.md` de `slep_simce_adecuado`, §5. Solo como referencia de forma; no se copia su texto ni sus rutas.
- **POSICIÓN:**
  - `bash` explícito; scripts en archivo (`/tmp/cat_a13_*`), sin heredocs en zsh, sin `Rscript -e` de varios pasos y **sin `echo` con cadenas de `=`**.
  - git de lectura con `GIT_OPTIONAL_LOCKS=0` desde el primer comando; `fetch` con `-c maintenance.auto=false`.
  - Corridas R desde la raíz con renv activo. `90_verificar_locale.R` se corre desde la raíz del kit: `Rscript plantillas/90_verificar_locale.R "$RAIZ" dc900c1b0d2d252c9e5730875be5d632`.
  - Las corridas «bajo locale C» usan `env LC_ALL= LC_CTYPE= LANG=C`, igual que el arnés del kit.
  - Ningún shell en segundo plano al terminar; checkout final en `main`.
- **LOG:** `50_documentacion/andamios/logs/20260926_guarda_locale_a13_log.md`
- **PUNTO DE RETORNO:** el hash del commit `chore(encargo): guarda de locale UTF-8 a13` es `<inicio>`.
- **ALCANCE:**
  - T1: las 8 rutas de §1.
  - T2: ninguna ruta versionada; solo corre el pipeline, y `40_salidas/` está fuera de git.
  - T3: `50_documentacion/activa/50_locale_utf8.md`.
  - FASE L: el LOG.
  - En cualquier fase, `git restore docs/index.html` tras un build.
- **PRUEBAS:**
  - (a) `run_all(only = 33)` con renv: exit 0 y 0 warnings; después, `git restore docs/index.html` si cambió;
  - (b) `tests/auditar_cifras.R` y `tests/spot_check_publicado.R` en verde con renv;
  - (c) SHA del payload normalizado = `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`, con su calibración.
- **Topes:** 3 intentos por bug; 2 ciclos en FASE R; 1 reintento por falla transitoria; un push denegado no se reintenta.
- **Reglas canónicas:**
  - Commits en español; `git add` con rutas explícitas; nunca `--no-verify` ni `--force`; sin atribución a la herramienta.
  - LOG sin datos, sin RBD con número, sin nombres.
  - `10_utils/10_locale.R` es copia idéntica de la plantilla y **no se edita** (POLITICA §5.2bis).
  - Nunca `try(..., silent = TRUE)` ni `suppressWarnings()` alrededor de la guarda.

## 1. Qué aprobó el titular y qué dejó escrito el asistente

Pendiente #5 del traspaso v31, con punto de arranque **A′**, aprobado por el titular en la sesión 32 («tu recomendación. si»). A′ es el esquema de `slep_simce_adecuado` y de `slep_reportes_modelo_resguardo_asistencia`:

- `10_utils/10_configuracion.R` tiene como primera línea ejecutable la guarda, y declara `ruta_insumos()`;
- lo cargan `00_run_all.R` y cada script ejecutable de `30_procesamiento/`, en la línea siguiente a `library(here)`.

**Por qué el accesor:** `10_utils/10_validar_portabilidad.R` es idéntico al del madre (fuente: `cmp`, sesión 32). Cuando `10_configuracion.R` existe, lo carga y busca un accesor, y sin ninguno marca FALLA en `data_root_resuelto` (fuente: líneas 251 a 283, sesión 32).

**Cambios ya escritos por el asistente en la carpeta, sin commitear** (fuente: `git status`, `git diff --numstat` y `md5sum`, sesión 32, sobre `HEAD` = `4aac27c`):

| Ruta | Cambio | numstat | md5 después |
|---|---|---|---|
| `10_utils/10_locale.R` | nuevo, copia de `<KIT>/plantillas/10_locale.R` | (nuevo) | `dc900c1b0d2d252c9e5730875be5d632` (= plantilla) |
| `10_utils/10_configuracion.R` | nuevo: encabezado, `source(here::here("10_utils", "10_locale.R"))`, `asegurar_locale_utf8("10_configuracion")` y `ruta_insumos <- function(...) here::here("20_insumos", ...)`; solo ASCII | (nuevo) | `e426f50d6186e728706c80491841e3c6` |
| `00_run_all.R` | después del bloque `instalar_si_falta(...)` (línea 39): una vacía, el comentario `# ---- Configuracion: guarda de locale UTF-8 (POLITICA 5.2bis) ---------------` y `source(file.path(raiz, "10_utils", "10_configuracion.R"))` | `3	0` | `1ef59c7b711e225ac79ef5e5dc6ceea8` |
| `30_procesamiento/30_construir_auxiliares.R` | después de `library(here)` (línea 31): `source(here::here("10_utils", "10_configuracion.R"))  # guarda de locale UTF-8 (POLITICA 5.2bis)` | `1	0` | `effdf44be6a530f8040374d297fb6ccb` |
| `30_procesamiento/31_leer_normalizar.R` | ídem, después de la línea 37 | `1	0` | `707fcdfdc040dd0176f77de3d2d4f116` |
| `30_procesamiento/32_agregar_territorial.R` | ídem, después de la línea 41 | `1	0` | `09e297abf64bd959ec059275f13f086d` |
| `30_procesamiento/33_generar_html.R` | ídem, después de la línea 50 | `1	0` | `10e63e69293ae5122b4ffd781c539054` |
| `30_procesamiento/34_exportar_contrato_categoria.R` | ídem, después de la línea 30 | `1	0` | `a19987bf49f9df3b73e8c62260fc819b` |

El CI (`.github/workflows/validacion_seguridad.yml`) no corre R (fuente: `grep` de `Rscript`, `setup-r` y `LANG`, 0 coincidencias, sesión 32). Por eso no hace falta fijar `LANG` en el workflow; el marcador lo declara.

## 2. Estado de partida (premisas marcadas)

- `main` = `origin/main` = `4aac27c` (fuente: `git rev-parse`, sesión 32). Hipótesis; se mide en M2.
- Porcelain (fuente: `git status --porcelain`, sesión 32, más este encargo):
  - ` M` de `00_run_all.R`, de los 5 scripts y del archivo de errores;
  - `??` de `10_utils/10_configuracion.R`, de `10_utils/10_locale.R` y de este encargo;
  - más el LOG.

  Se mide en M1.
- `40_salidas/` contiene los productos del último build (hipótesis, se mide en M5; el directorio no se versiona).
- No existe `50_documentacion/activa/50_locale_utf8.md` (fuente: `ls`, apertura de la sesión 32).

## 3. Invariantes 🔒

1. **Los cambios son los de §1 y solo esos:**
   - md5 de las 8 rutas = §1;
   - `cmp 10_utils/10_locale.R <KIT>/plantillas/10_locale.R` → exit 0;
   - `git diff --numstat <inicio>..HEAD` para las 6 rutas modificadas = §1;
   - las 2 nuevas se agregan completas.
2. **El resto del pipeline no cambia:** `git diff --name-only <inicio>..HEAD -- 30_procesamiento/33_app.jsx 30_procesamiento/33_motor_template.html docs tests 20_insumos renv.lock .github 10_utils/10_utils.R 10_utils/10_validar_portabilidad.R | wc -l` → `0`.
3. **Guarda instalada y vista fallar:**
   - el verificador del kit da `GUARDA INSTALADA` (V1 a V4 OK);
   - con la invocación comentada en `10_configuracion.R`, falla (esperado: V2, V3 y V4 en FALLO);
   - restaurado el archivo, `git diff` sale vacío y el verificador vuelve a `GUARDA INSTALADA`.
4. **Bajo locale C la guarda corrige y el producto no cambia:**
   - `run_all(only = 33)` y `Rscript 30_procesamiento/33_generar_html.R`, los dos bajo `env LC_ALL= LC_CTYPE= LANG=C`: exit 0;
   - la guarda emite su `message()` de corrección, nombrando la locale de partida;
   - SHA del payload = `d9895a78…0442`.
5. **Cifras intactas:**
   - PRUEBAS b y c;
   - tras la corrida completa de T2, el **contenido** de cada archivo de `40_salidas/` (parquet y HTML) es igual a la línea base de M5. Los parquet se comparan con `identical()` de R sobre `arrow::read_parquet()`; el HTML, por SHA del payload.
6. **Validador de portabilidad:** en `validar_portabilidad()`, `locale_utf8` y `data_root_resuelto` PASA (este último «Resuelto por ruta_insumos()»), y el check `configuracion_presente` ya no aparece. Los demás checks se anotan tal como salgan.
7. **Alcance (se mide en FASE L, después del commit del LOG; en FASE R se mide sin el LOG):** `git diff --name-only <inicio>..HEAD` = las 8 rutas de §1 ∪ {`50_documentacion/activa/50_locale_utf8.md`} ∪ {el LOG}.
8. **Sin coautoría, RUT ni rutas de usuario** en lo agregado (mismos tres comandos del a12).

## 4. Tareas

Grafo: T1 → T2 → T3, en serie. FASE R y FASE L corren siempre.

### Regla de detención

1. M1 o M2 distintos de lo esperado → FASE L, sin push.
2. md5 de §1 distinto (M3) → T1 congelada. No se «corrige» ningún archivo del asistente: se registra la diferencia.
3. Verificador sin `GUARDA INSTALADA`, o una rotura que no lo hace fallar → T1 congelada, sin commit de código.
4. Contenido de `40_salidas/` distinto de la base, o PRUEBAS b o c en falla → BLOQUEA: `git revert` del commit de T1, sin marcador y sin push. Se registra qué archivo y qué columna difieren.
5. Push denegado → no se reintenta.
6. Cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda con pregunta cerrada y pasa a FASE R.

### Autorizaciones (lista cerrada)

- Commit de FASE 0 (encargo y archivo de errores); commit de T1 (las 8 rutas de §1); commit de T3 (marcador).
- Durante la prueba de rotura, comentar la línea `asegurar_locale_utf8("10_configuracion")` y después `git restore 10_utils/10_configuracion.R`.
- `git restore docs/index.html` tras cada build.
- Correr el pipeline completo (`run_all()`, pasos 30 a 33) y `34_exportar_contrato_categoria.R` suelto; escriben en `40_salidas/`, que está fuera de git.
- Copias de `40_salidas/` en `/tmp/cat_a13_base/`.
- `git revert` de un commit propio si la regla 4 o FASE R lo exige.
- `git push origin main` una vez, en FASE L, con el simulacro del hook en exit 0.
- Implícitas: `fix(auditoria): R-NN …` y `docs(log): guarda de locale UTF-8 a13`.

Nada más:

- ni `rm`, `reset`, `checkout --`, `stash`, `--no-verify` ni `--force`;
- ni ediciones de `10_locale.R` ni de rutas fuera de los ALCANCE.

### FASE 0 (`esperado:` antes de cada `obtenido:`)

Primer acto: crear el LOG con el encabezado, el slot `## J. Juicio (lo rellena FASE L)` y el esqueleto.

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | rama; porcelain; stash | `main`; exactamente las líneas de §2; vacío | regla 1 |
| M2 | `fetch`; `HEAD`; `origin/main`; deltas; basename y remoto; filas del archivo de errores | `4aac27c` = `origin/main`; 0 y 0; los de ENTORNO; 9 filas | regla 1 |
| M3 | md5 de las 8 rutas; `cmp` con la plantilla; `git diff --numstat` de las 6 modificadas; texto de las líneas insertadas; `10_configuracion.R` solo ASCII y parsea | = §1 | regla 2 |
| M4 | commit de FASE 0 con 2 rutas (encargo y errores; el código queda sin commitear); `<inicio>` | commit = 2 archivos; porcelain = las 8 rutas de §1 y el LOG | regla 1 |
| M5 | línea base: copia de `40_salidas/` (con `intermedios/`) a `/tmp/cat_a13_base/`, con listado, md5 y bytes; SHA del motor de la base con calibración | copia completa; SHA `d9895a78…0442` | se registra |
| M6 | `HERRAMIENTAS_DEV_PATH` resuelve; md5 de la plantilla; `Rscript`, renv y `arrow` | `dc900c1b…`; disponibles | T1 congelada |

### T1: verificar la guarda, verla fallar y commitear el código

1. Verificador del kit (desde la raíz del kit, con el hash de la plantilla). Esperado: V1 a V4 OK y `GUARDA INSTALADA`.
2. `validar_portabilidad(detener_si_falla = FALSE)` desde la raíz con renv. Esperado: el 🔒6; se anota la tabla completa.
3. Bajo locale C: `run_all(only = 33)` y `Rscript 30_procesamiento/33_generar_html.R`, cada uno seguido de PRUEBA c y de `git restore docs/index.html`. Esperado: el 🔒4.
4. Commit `feat(entorno): instala la guarda de locale UTF-8 en el arranque (a13)`, con las 8 rutas de §1 explícitas.
5. **Prueba de rotura:** comentar la línea de la guarda en `10_configuracion.R` y correr el verificador. Esperado: FALLO en V2, V3 y V4. Después, `git restore 10_utils/10_configuracion.R`, `git diff --stat` vacío y el verificador en `GUARDA INSTALADA`.

### T2: el pipeline completo reproduce la base

1. `run_all()` (pasos 30 a 33) con renv, en el entorno normal: exit 0 y 0 warnings.
2. `Rscript 30_procesamiento/34_exportar_contrato_categoria.R`: exit 0.
3. Por cada archivo de `40_salidas/`, comparación de contenido con la base de M5 (🔒5). Si un parquet difiere en md5 pero es `identical()`, se anota como diferencia binaria y no es FALLA.
4. PRUEBAS b y c; `git restore docs/index.html`.
5. Sin commit: T2 no toca rutas versionadas.

### T3: marcador

Crear `50_documentacion/activa/50_locale_utf8.md` («Constancia: guarda de locale UTF-8»), con lo medido en T1 y T2 copiado del LOG:

- fecha, encargo y LOG;
- decisión del titular (A′) y su motivo (el incidente medido en `slep_simce_adecuado`);
- tabla de piezas: `10_locale.R` con su md5 igual a la plantilla, `10_configuracion.R` y sus invocadores (el orquestador y los 5 scripts);
- salida del verificador;
- prueba de rotura;
- corridas bajo locale C;
- corrida completa con contenido igual a la base;
- la tabla de `validar_portabilidad()`;
- «CI: no corre R; `LANG` no aplica»;
- lo que queda fuera: tests y suite, que se corren aparte.

Sin rutas absolutas. Commit `docs(entorno): constancia de la guarda de locale UTF-8 (a13)`.

### FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio.

1. **Inventario** `R-01…` desde el LOG, antes de auditar.
2. **Re-derivación con otro comando:**
   - md5 con `openssl`;
   - posición de la guarda con `parse()` y `deparse()` propios, además del V2 del kit;
   - locale del proceso bajo C con `l10n_info()` en un `Rscript` que carga `10_configuracion.R`;
   - igualdad de parquet con `dplyr::all_equal` o una comparación por filas ordenadas;
   - SHA con el verificador Python.
3. **Invariantes:** comando de cada 🔒, PASA/FALLA con salida literal. El 🔒7 sin el LOG; su forma completa va en FASE L.
4. **Alcance y porcelain.**
5. **Regresión:** PRUEBAS a, b y c.
6. **Control positivo:**
   - la rotura de T1 ya lo es para el verificador;
   - además, en una copia fuera del árbol, un parquet con una celda alterada es detectado por la comparación del 🔒5.
7. **Veredicto por hallazgo:** BLOQUEA, REPARA o ADVIERTE.
8. **Máximo 2 ciclos de reparación.**
9. **Prohibido:** ajustar criterios o esperados, ampliar un ALCANCE, tocar un 🔒, editar lo ya escrito en el LOG, reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto global.

### FASE L: cierre del log (última, obligatoria)

1. Porcelain = solo el LOG.
2. Cierre del LOG:
   - resumen;
   - commits;
   - tabla de FASE R;
   - 🔒 con evidencia;
   - dudas con pregunta cerrada;
   - errores propios;
   - notas para el revisor.
3. Bloque J de trece campos, copiado del detalle.
4. Privacidad del LOG: RUT 0, `$HOME` 0, sin nombres.
5. `ls -l` y `wc -l` del LOG; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. Commit `docs(log): guarda de locale UTF-8 a13`. Recién aquí se mide el 🔒7 completo.
7. Simulacro del hook con `refs/heads/main <HEAD> refs/heads/main <origin/main>`, con exit 0; después `git push origin main`.

## 5. Reporte final

- **Primera línea:** la salida literal de `ls -l <LOG> && wc -l <LOG>` y el hash de `docs(log)`.
- **Segundo bloque:** el bloque J tal cual.
- **Después:**
  - la salida literal del verificador, instalada y en rotura;
  - las dos corridas bajo locale C, con el mensaje de la guarda;
  - la corrida completa y la comparación de `40_salidas/`;
  - la tabla de `validar_portabilidad()`;
  - resultado de cada 🔒;
  - PRUEBAS a, b y c;
  - salida del push;
  - lo que falló o sorprendió (si nada, decirlo).
