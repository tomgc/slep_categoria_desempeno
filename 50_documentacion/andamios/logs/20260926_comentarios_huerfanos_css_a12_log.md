# LOG — retiro de los 11 comentarios huérfanos del CSS del motor, y despliegue (a12)

- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_categoria_comentarios_huerfanos_a12.md`
- **Ejecutor:** Claude Code, modo autónomo, todo en un turno, sin subagentes, esfuerzo `xhigh`, sobre el filesystem local de la estación (macOS).
- **Modo de la sesión (declarado por el encabezado de contrato):** la sesión corre con el modelo Opus 5.5 (1M) y el esfuerzo `ultracode` (`xhigh` más orquestación dinámica de workflows). Manda el encargo: orquestador el modelo de la sesión, 0 subagentes, 0 workflows, cadena en serie.
- **Acto externo autorizado en el lanzamiento (D5 = a):** un único `git push origin main` en FASE L, solo con el simulacro del hook en exit 0 y sin `--no-verify` ni `--force`. Cualquier otro acto externo se consulta.
- **Fecha:** 2026-09-26.
- **Punto de retorno `<inicio>`:** se fija en M3.
- **Rama:** `main`.
- **Convención de rutas:** `<RAIZ>` es la raíz del repositorio. Ninguna ruta absoluta de la estación entra a este LOG.

## Índice

- FASE 0
- T1: retiro de los 11 comentarios
- T2: despliegue
- FASE R: auditoría propia y reparación
- FASE L: cierre del log
- J. Juicio

### FASE 0

Primer acto: LOG creado con encabezado, esqueleto y el slot vacío del bloque J, antes de cualquier comando git del turno. El primer script (`/tmp/cat_a12_m12.sh`) exporta `GIT_OPTIONAL_LOCKS=0` en su primera línea; su única llamada git anterior al `fetch` es `git rev-parse --show-toplevel`, que exige ENTORNO. El `fetch` corrió con `-c maintenance.auto=false`.

| # | Medición | esperado | obtenido |
|---|---|---|---|
| M1 | rama; porcelain; stash | `main`; ` M ...20260925_errores_asistente_sesion32.md`, `?? ...a12.md` y el LOG; vacío | `main`; exactamente esas tres líneas; stash con 0 líneas. PASA |
| M2 | `fetch`; `HEAD`; `origin/main`; deltas; basename y remoto; filas del archivo de errores | exit 0; `568b418` = `origin/main`; 0 y 0; los de ENTORNO; 8 filas | fetch exit 0; `HEAD` = `origin/main` = `568b4188e7e12b24bffd792cc040ccf52703b9c0` (merge del PR #3); 0 y 0; `slep_categoria_desempeno` y `https://github.com/tomgc/slep_categoria_desempeno.git`; 8 filas. El último commit que tocó el template o `33_app.jsx` es `596d1fb`. En el remoto solo queda `refs/heads/main`. PASA |
| M3 | commit de FASE 0; `<inicio>`; md5 del template y de `docs/index.html`; SHA con calibración; PRUEBAS b | 2 archivos; `fce2d439…`; `587f4233…`; `d9895a78…0442` con calibración correcta; verde | commit `ccc0741af59c1fc63aca3601798fd7494717c349` con exactamente el encargo y el archivo de errores (privacidad previa: RUT 0 y `$HOME` 0); `<inicio>` = `ccc0741`; template `fce2d439d4571f3bdd37fd85ecab8d47` (111216 bytes, 2588 líneas); `docs/index.html` `587f4233baf7561f332235780a04805a` (1889390 bytes); SHA `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442` (fecha alterada = igual; cifra plantada = `162ff49e…`, distinto; verificador Python del a11b = el mismo SHA); `auditar_cifras.R` exit 0, F1 a F4 OK, 0 warnings; `spot_check_publicado.R` exit 0, 6 celdas y 1 ausencia OK, 0 warnings; renv activo. PASA |
| M4 | Chrome del sistema; Puppeteer; Babel | disponibles o instalados en `/tmp/cat_a12_*` | Chrome 153.0.8010.53; Puppeteer 25.9.0, el de los encargos a6 a a10 (por `NODE_PATH`, el `node_modules` de otro proyecto de la estación; sin instalar nada); Babel 8.0.6 copiado de `/tmp/cat_a10_babel` a `/tmp/cat_a12_babel`, configuración `{"presets":[["@babel/preset-react",{"runtime":"classic"}]]}`; además `postcss` 8.5.28 copiado de `/tmp/cat_a10_css` a `/tmp/cat_a12_css` (para FASE R), ImageMagick 7.1.2 y Node 26.5. Sin instalaciones. PASA |
| M-DERIVA | retranspilación de `33_app.jsx` frente al bloque del template | idéntica: `84d079b7…`, 1614 líneas | `template 84d079b74d35d93e0412f457020fc066 1614 lineas \| retrans 84d079b74d35d93e0412f457020fc066 1614 lineas \| distintas: 0`. PASA |
| M5 | build base; copia y bytes; CSSOM, `textContent` y 3 capturas, dos veces; calibración del 🔒4 | exit 0; `docs` restaurado; dos corridas iguales; calibración con lista distinta | PRUEBAS a exit 0, 0 warnings, renv activo; motor base `08fb74b9062c480eaa37901031d8f52f`, **1889390 bytes**, SHA `d9895a78…0442`, fecha de generación `2026-09-26`, copiado a `/tmp/cat_a12_base.html`; el build dejó `docs/index.html` = motor; `git restore` → `587f4233…`. Medición (ver abajo): CSSOM 232 reglas en 1 hoja; dos corridas iguales en CSSOM, `textContent` (3 de 3) y capturas AE 0 (3 de 3, más 2 de 2 en ventana alta); 0 errores de consola. Calibración: la copia sin `.entity-select-btn { … }` (8 líneas) da 231 reglas, 53 posiciones distintas, lista distinta, y AE > 0 en todas las capturas. PASA, con un hallazgo registrado |
| M6 | las 11 filas de §1; texto de las 26 líneas; 79 comentarios | igual a §1 | `<style>` en las líneas 8 a 940; 79 comentarios; 11 de 11 filas: cada comentario empieza en la línea de §1, calza con su descripción, ocupa sus líneas enteras y lo sigue lo que dice §1 (en la fila 6, el encabezado de sección «Vista de Categoría de Desempeño»); las 26 líneas de la lista son 13 de comentario y 13 vacías, 0 de otra clase, todas dentro del `<style>`. Informativo: la regla de §1 aplicada al archivo da exactamente la misma lista (26 líneas). No se recalculó ni se reemplazó la lista. PASA |

**Hallazgo de M5 (se registra) y decisión de instrumento.** En la primera medición, las capturas de página completa (`fullPage` de Puppeteer) no fueron deterministas: dos corridas sobre el mismo motor base dieron AE 3.35 (1280 px, 331 píxeles dispersos entre las filas 659 y 2351) y 0.27 (390 px, 76 píxeles), con CSSOM y `textContent` iguales; la captura del modal, que es de ventana, dio AE 0. Es ruido del mecanismo de captura, no del motor. El 🔒5 se mide con capturas **de ventana**: 1280 × 800, 390 × 844 y modal a 390 × 844, que es el método del a10. Para cubrir la página entera se agregan dos capturas **adicionales** con la ventana estirada a la altura del documento (1280 × 2416 y 390 × 6518). Las cinco dieron AE 0 entre dos corridas de la base. El CSSOM se mide antes de inyectar el estilo sin transiciones, así que la lista es la del motor, sin la hoja que agrega la medición. Instrumentos: `/tmp/cat_a12_medir.js` y `/tmp/cat_a12_cmp.sh`.

M1
esperado: `main`; ` M ...20260925_errores_asistente_sesion32.md`, `?? ...a12.md` y el LOG; stash vacío
obtenido: `main`; esas tres líneas exactas; stash con 0 líneas. PASA

M2
esperado: fetch exit 0; `HEAD` = `origin/main` = `568b418`; 0 y 0; basename y remoto de ENTORNO; 8 filas
obtenido: fetch exit 0; `568b418` = `origin/main`; 0 y 0; basename y remoto de ENTORNO; 8 filas. PASA

M3
esperado: commit = 2 archivos; template `fce2d439…`; `docs` `587f4233…`; SHA `d9895a78…0442` con calibración correcta; PRUEBAS b en verde
obtenido: commit `ccc0741` con 2 archivos; `fce2d439…`; `587f4233…`; `d9895a78…0442`, fecha alterada igual y cifra plantada distinta; PRUEBAS b en verde. PASA

M4
esperado: Chrome, Puppeteer y Babel disponibles o instalados en `/tmp/cat_a12_*`
obtenido: los tres disponibles; Babel copiado a `/tmp/cat_a12_babel`; sin instalar nada. PASA

M-DERIVA
esperado: bloque del template = retranspilación, `84d079b7…`, 1614 líneas
obtenido: `84d079b74d35d93e0412f457020fc066`, 1614 líneas, 0 distintas. PASA

M5
esperado: build exit 0; `docs` restaurado; dos corridas iguales; la calibración da una lista distinta
obtenido: exit 0 y 0 warnings; `docs` restaurado a `587f4233…`; con capturas de ventana, dos corridas iguales (CSSOM, 3 de 3 `textContent`, 3 de 3 AE 0, más 2 de 2 en ventana alta); calibración con 231 contra 232 reglas, lista distinta. La primera variante con `fullPage` no fue determinista (hallazgo registrado; no se usa). PASA

M6
esperado: las 11 filas y las 26 líneas iguales a §1; 79 comentarios
obtenido: 11 de 11; 13 de comentario y 13 vacías; 79. PASA

**Cierre de FASE 0:** ninguna regla de detención activa.

### T1: retiro de los 11 comentarios

- **ALCANCE:** `30_procesamiento/33_motor_template.html`.
- **Borrado** (`/tmp/cat_a12_borrar.py`). Verifica el md5 de partida, borra por número las 26 líneas de §1 sobre los bytes del archivo y lo escribe con su salto de línea final; no usa `sed` ni patrones. Salida: `md5 de partida: fce2d439d4571f3bdd37fd85ecab8d47`; `lineas: 2588 -> 2562 (borradas 26); bytes: 111216 -> 110703 (-513); md5 nuevo: 1b615464115cdaefb384c206c1a4f620`.
- **Instrumento de los 🔒1 a 🔒3** (`/tmp/cat_a12_candados_tpl.py`, base = `git show ccc0741:30_procesamiento/33_motor_template.html`). El 🔒1 se lee del diff de git (`git diff --no-index -U0`) y clasifica cada línea borrada con la clasificación de la base de M6 (los 11 textos guardados en `/tmp/cat_a12_textos11.json`).

esperado: 🔒1: `git diff --numstat` = `0	26`; cada línea borrada es vacía o de uno de los 11 comentarios, entre las líneas 8 y 940 de la base
obtenido: `0	26	30_procesamiento/33_motor_template.html`; 0 agregadas y 26 borradas (13 de comentario y 13 vacías); 0 fuera de clase o fuera de 8 a 940; líneas tocadas de la 280 a la 939. PASA

esperado: 🔒2: md5 `1b615464…`, 110703 bytes, 2562 líneas; 68 comentarios en el `<style>`; 0 apariciones de cada uno de los 11 textos; racha máxima de vacías = 1
obtenido: `1b615464115cdaefb384c206c1a4f620`, 110703 bytes, 2562 líneas; `<style>` en las líneas 8 a 914; 68 comentarios; 11 ceros; racha máxima 1. PASA

esperado: 🔒3: SHA-256 del texto hasta `<style>` inclusive y desde `</style>` hasta el final, iguales antes y después; M-DERIVA idéntico
obtenido: `d2aafc4b8d7dfbe2…` = `d2aafc4b8d7dfbe2…` y `9fa29e09b3ea8735…` = `9fa29e09b3ea8735…`; M-DERIVA `84d079b74d35d93e0412f457020fc066`, 1614 líneas, 0 distintas (bloque igual al de FASE 0). PASA

esperado: PRUEBAS a con el template nuevo: exit 0 y 0 warnings; motor = base − 513 bytes
obtenido: exit 0, 0 warnings, renv activo; motor `018f63657c227036899ae3194bf9c68e`, 1888877 bytes = 1889390 − 513; el build dejó `docs/index.html` = motor. PASA

esperado: 🔒4: mismo CSSOM que la base de M5 (misma cantidad y mismo texto, en orden)
obtenido: 232 contra 232 reglas, 0 posiciones distintas, misma lista. PASA

esperado: 🔒5: `textContent` de `#root` idéntico y AE = 0 en el estado inicial a 1280 px y a 390 px y en el modal a 390 px, contra la base
obtenido: `textContent` 3 de 3 iguales (11250, 11250 y 17504 bytes); AE 0 en 3 de 3 (1280 × 800, 390 × 844, modal 390 × 844); adicional en ventana alta (1280 × 2416 y 390 × 6518): 2 de 2 iguales con AE 0; 0 errores de consola. PASA

esperado: 🔒6: PRUEBAS b en verde; PRUEBA c = `d9895a78…0442` con calibración
obtenido: `auditar_cifras.R` exit 0, F1 a F4 OK, 0 warnings; `spot_check_publicado.R` sobre `docs/index.html` = build nuevo: exit 0, 6 celdas y 1 ausencia OK; SHA del motor nuevo `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442` (fecha alterada igual; cifra plantada `162ff49e…`); el verificador Python dice «payload igual salvo la fecha: True» contra la base. PASA

esperado: `git restore docs/index.html` con md5 `587f4233…`
obtenido: restore exit 0; md5 `587f4233baf7561f332235780a04805a`; porcelain: ` M` del template y el LOG. PASA

- **Commit** `refactor(motor): retira los 11 comentarios huérfanos del CSS (a12 T1)` = `c0aa5aab7e9f48c39a1c79dd02f63f6f0240140a`, solo con el template; `git diff --numstat ccc0741..HEAD -- 30_procesamiento/33_motor_template.html` = `0	26`.
- **T1: completada.**

### T2: despliegue

- Corre porque T1 terminó en verde. **ALCANCE:** `docs/index.html`.
- Build con PRUEBAS a (`/tmp/cat_a12_t2.sh`); `docs/index.html` queda con el build nuevo.

esperado: PRUEBAS a exit 0 y 0 warnings
obtenido: exit 0, 0 warnings, renv activo. PASA

esperado: 🔒7: md5 de `docs/index.html` = md5 de `40_salidas/motor_categoria.html`; bytes de `docs` = bytes del build base de M5 − 513
obtenido: `018f63657c227036899ae3194bf9c68e` = `018f63657c227036899ae3194bf9c68e`; 1888877 = 1889390 − 513 (misma fecha de generación, `2026-09-26`, en la base y en el despliegue); además, `docs` es idéntico al motor de T1. PASA

esperado: PRUEBAS b y c sobre `docs/index.html`
obtenido: `auditar_cifras.R` exit 0, F1 a F4 OK, 0 warnings; `spot_check_publicado.R` exit 0, 6 celdas y 1 ausencia OK, 0 warnings; SHA `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442` (fecha alterada igual; cifra plantada `162ff49e…`). PASA

esperado: por `file://`, 0 errores de consola y 🔒5 contra la base
obtenido: 0 errores en los cuatro recorridos (s1280, s390, m390 y s390 en ventana alta); CSSOM 232 = 232, misma lista; `textContent` 3 de 3 iguales; AE 0 en 3 de 3; adicional en ventana alta: 2 de 2. PASA

esperado: `git status --short` = ` M docs/index.html` (más el LOG)
obtenido: ` M docs/index.html` y `?? ...a12_log.md`. PASA

- **Commit** `deploy(motor): publica el motor sin comentarios huérfanos del CSS (a12)` = `bbabda6c71f79f1bf22f275c7bac4fb65c77e037`, solo con `docs/index.html`. RUT 0 y `$HOME` 0 en lo agregado. `git show HEAD:docs/index.html` tiene md5 `018f6365…`. El numstat es `1	27`: salen las 26 líneas del CSS y se reemplaza la línea del payload (`atob(`), cuya fecha de generación pasa de `2026-09-25` (publicado) a `2026-09-26`; el SHA normalizado es el mismo.
- **T2: completada.**

### FASE R: auditoría propia y reparación

**1. Inventario R-01…R-22**, derivado del LOG anterior a esta auditoría y anexado antes de auditar:

| id | afirmación (LOG) |
|---|---|
| R-01 | M1: `main`; porcelain de 3 líneas; stash vacío |
| R-02 | M2: fetch exit 0; `HEAD` = `origin/main` = `568b418`; 0 y 0; ENTORNO; 8 filas |
| R-03 | M3: commit `ccc0741` con 2 archivos; template `fce2d439…` (111216 bytes, 2588 líneas); `docs` `587f4233…`; SHA `d9895a78…0442` con calibración; PRUEBAS b en verde |
| R-04 | M4: Chrome, Puppeteer y Babel disponibles; Babel y `postcss` copiados a `/tmp/cat_a12_*` |
| R-05 | M-DERIVA: `84d079b7…`, 1614 líneas, 0 distintas (FASE 0 y T1) |
| R-06 | M5: build base exit 0, 0 warnings, 1889390 bytes; dos corridas iguales; calibración del 🔒4 con 231 contra 232 reglas |
| R-07 | M5: la captura `fullPage` no es determinista; las de ventana y de ventana alta, sí |
| R-08 | M6: 11 de 11 filas; 26 líneas = 13 de comentario y 13 vacías, dentro del `<style>`; 79 comentarios; la regla reproduce la lista |
| R-09 | T1: borrado con `fce2d439…` → `1b615464…`, 111216 → 110703 bytes, 2588 → 2562 líneas |
| R-10 | T1: 🔒1 (`0	26`; 13 + 13; 0 fuera de clase ni de 8 a 940) |
| R-11 | T1: 🔒2 (md5, bytes, líneas, 68 comentarios, 11 ceros, racha 1, `<style>` en 8 a 914) |
| R-12 | T1: 🔒3 (extremos fuera del `<style>` iguales; M-DERIVA idéntico) |
| R-13 | T1: build exit 0, 0 warnings, motor 1888877 bytes (−513); 🔒4 (232 = 232, misma lista) |
| R-14 | T1: 🔒5 (`textContent` 3 de 3; AE 0 en 3 de 3; ventana alta 2 de 2) |
| R-15 | T1: 🔒6 (PRUEBAS b en verde; SHA `d9895a78…0442`; payload igual salvo la fecha) |
| R-16 | T1: `docs` restaurado a `587f4233…`; commit `c0aa5aa` solo con el template |
| R-17 | T2: 🔒7 (md5 `docs` = md5 motor = `018f6365…`; 1888877 = 1889390 − 513) |
| R-18 | T2: PRUEBAS b y c sobre `docs` |
| R-19 | T2: 0 errores por `file://`; 🔒5 contra la base |
| R-20 | T2: commit `bbabda6` solo con `docs`; numstat `1	27` (26 del CSS y la línea del payload por la fecha) |
| R-21 | 🔒1 a 🔒9 sobre el estado final |
| R-22 | Alcance global (🔒8) y porcelain |

**2. Re-derivación con otro comando** (estado final, `HEAD` = `bbabda6`):

| id | comando de re-derivación (distinto del original) | resultado |
|---|---|---|
| R-09, R-10, R-20 | `git show --stat` de `c0aa5aa` y `bbabda6` | template: 26 borradas, 0 agregadas; `docs`: 1 agregada y 27 borradas. Coincide |
| R-10, 🔒1 | `difflib.SequenceMatcher` de Python sobre `git show ccc0741:<template>` contra `git show HEAD:<template>`, clasificando cada línea borrada por su contenido (vacía o parte de uno de los 11 comentarios tomados de la base por las líneas de §1), sin la clasificación de M6 | 5 bloques, todos `delete`; 0 agregadas o reemplazadas; 26 borradas = 13 vacías y 13 de comentario, 0 de otra clase, 0 fuera de 8 a 940: PASA. Con difflib el conjunto de números no es la lista de §1: borra 292, 313, 478 y 929 en lugar de 301, 316, 480 y 939. Son vacías de las mismas cuatro rachas (292 a 301, 313 a 316, 478 a 480 y 929 a 939): difflib alinea en la primera vacía de cada racha y la lista de §1 en la última. Aplicar cualquiera de los dos conjuntos a la base da exactamente `HEAD`, y el diff de git (Myers) da exactamente la lista de §1. No es hallazgo |
| R-13, R-19, 🔒4 | `postcss` 8.5.28, sin comentarios y sin raws, sobre el `<style>` de los dos templates y de los dos `docs` (`ccc0741` contra `HEAD`), en lugar del CSSOM de Chrome | templates: 1261 = 1261 nodos (236 reglas, 1016 declaraciones, 9 at-reglas), comentarios 79 → 68, 0 posiciones distintas, misma lista; `docs`: ídem. Coincide |
| R-03, R-09, R-11, R-13, R-17 | `openssl dgst -md5`, `stat -f %z` y `awk 'END{print NR}'`, en lugar de `md5`, `wc -c` y `wc -l`; `shasum` para la identidad entre copias | template `fce2d439…` 111216 bytes y 2588 líneas → `1b615464…` 110703 y 2562; `docs` `587f4233…` 1889390 y 2886 → `018f6365…` 1888877 y 2860; base de M5 `08fb74b9…` 1889390; diferencia −513 en el template y en `docs`; `shasum` de `HEAD:docs`, `docs` del árbol y motor de `40_salidas` = 1 solo valor; `HEAD:template` = árbol. Coincide |
| R-15, R-18 | SHA desde `git show HEAD:docs/index.html` con el verificador Python (`zlib`, `json`, `hashlib`), en lugar de node | `HEAD`: `d9895a78…0442`; `ccc0741`: `d9895a78…0442`; «payload igual salvo la fecha: True», con fechas `2026-09-25` y `2026-09-26`. Coincide |
| R-05, R-12 | `cmp` del bloque de la app extraído con `awk` de `ccc0741:<template>` y de `HEAD:<template>`, en lugar de Babel | bloque de `ccc0741` = bloque de `HEAD` (1614 líneas) = retranspilación de T1. Fuera del `<style>`, comparación directa de las cadenas: template con prefijo y sufijo iguales; `docs` con prefijo y sufijo iguales, salvo la línea del payload. Coincide |
| R-02, R-20 | `git ls-remote --heads origin` | `main` = `568b418` en el remoto (el push va en FASE L). Coincide |
| R-01, R-03 | `git show --stat ccc0741` | 2 archivos (encargo +230, errores +2). Coincide |

**3. Invariantes, con salida literal** (sobre el estado final, antes del commit del LOG):

| 🔒 | comando | salida | veredicto |
|---|---|---|---|
| 1 | `git diff --numstat ccc0741..HEAD -- 30_procesamiento/33_motor_template.html`; clasificación (`/tmp/cat_a12_candados_tpl.py`) | `0	26	30_procesamiento/33_motor_template.html`; `agregadas 0 · borradas 26 (comentario 13, vacias 13) · fuera de clase o fuera de 8-940: 0 [] · lineas de la base tocadas 280-939` | PASA |
| 2 | ídem | `md5 1b615464115cdaefb384c206c1a4f620 · 110703 bytes · 2562 lineas · <style> 8-914 · comentarios en el <style> 68 · apariciones de los 11 textos [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] · racha maxima de vacias en el <style> 1` | PASA |
| 3 | ídem y `/tmp/cat_a12_retrans.sh R` | `SHA-256 hasta <style> inclusive d2aafc4b8d7dfbe2 / d2aafc4b8d7dfbe2 · desde </style> 9fa29e09b3ea8735 / 9fa29e09b3ea8735`; `M-DERIVA [R]: template 84d079b74d35d93e0412f457020fc066 1614 lineas \| retrans 84d079b74d35d93e0412f457020fc066 1614 lineas \| distintas: 0` | PASA |
| 4 | CSSOM en Chrome, base de M5 contra el build de regresión | `CSSOM: 232 vs 232 reglas · posiciones distintas 0 · misma lista: SI` | PASA |
| 5 | `textContent` y AE, base de M5 contra el build de regresión | `textContent iguales 3/3 · capturas AE=0 3/3`; ventana alta `2/2`; 0 errores de consola | PASA |
| 6 | PRUEBAS b y c | F1 a F4 OK, `SPOT-CHECK OK: 6 celdas de presencia + 1 de ausencia`; SHA `d9895a78…0442` (motor y `docs`), calibración correcta | PASA |
| 7 | md5 de `docs` contra md5 del motor; bytes contra la base de M5 | `018f63657c227036899ae3194bf9c68e` = `018f63657c227036899ae3194bf9c68e`; `1888877 - 1889390 = -513` | PASA |
| 8 | `git diff --name-only ccc0741..HEAD` | `30_procesamiento/33_motor_template.html`, `docs/index.html`; el LOG entra en FASE L | PASA en lo medible (2 de 3 por diseño); se re-verifica tras el push |
| 9 | `git log ccc0741..HEAD --format=%B \| grep -ci co-authored`; `git diff ccc0741..HEAD \| grep '^+' \| grep -cE` RUT; `grep -cF "$HOME"` | `0`; `0`; `0` | PASA |

**4. Alcance global:** `git diff --name-only ccc0741..HEAD` = el template (ALCANCE de T1) y `docs/index.html` (ALCANCE de T2); el LOG entra en FASE L. `git status --porcelain` = solo `?? ...a12_log.md`. PASA.

**5. Regresión sobre el estado final:**

esperado: PRUEBAS a exit 0 y 0 warnings; PRUEBAS b en verde; PRUEBA c = `d9895a78…0442` con calibración
obtenido: build exit 0, 0 warnings, renv activo. El motor `018f6365…` (1888877 bytes) queda idéntico a `HEAD:docs`, así que el build no cambió `docs/index.html` y no hizo falta restore. F1 a F4 OK y spot-check OK, con 0 warnings. SHA `d9895a78…0442` en el motor y en `docs`; fecha alterada igual y cifra plantada distinta. PASA

**6. Control positivo:**

esperado: una línea no vacía borrada de más en una copia del template, fuera del árbol, la detecta el chequeo del 🔒1
obtenido: la copia de `HEAD` sin la línea 123 (`}`), en `/tmp/cat_a12_ctrl/`, da `borradas 27 ... fuera de clase o fuera de 8-940: 1 [(123, 'OTRA')]` → `🔒1: FALLA`; con difflib, `borradas 27 {'vacia': 13, 'comentario': 13, 'OTRA': 1}` → `FALLA`. PASA

esperado: una regla viva borrada en una copia del motor la detecta el 🔒4
obtenido: la copia de `docs` sin `.entity-select-btn { … }` (8 líneas) da en Chrome `232 vs 231 reglas · posiciones distintas 53 · misma lista: NO` y capturas con AE = 0 en 0 de 3; con `postcss`, `1261 vs 1246` nodos, lista distinta. PASA

**7 a 10. Veredicto por hallazgo:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-07 | capturas de la base, dos corridas iguales | dos corridas de `/tmp/cat_a12_medir.js` sobre el mismo motor | AE 0 | con `fullPage`, AE 3.35 y 0.27, ruido del mecanismo de captura; con ventana y ventana alta, AE 0 en 5 de 5 | ADVIERTE | se registra; el 🔒5 se mide con capturas de ventana (el método del a10) más dos de ventana alta; el criterio (AE = 0) no cambia | — | T1, T2 y R: AE 0 en 3 de 3 y 2 de 2 |
| R-21 (🔒8) | alcance = template, `docs` y LOG | `git diff --name-only ccc0741..HEAD` | 3 rutas | 2 antes de FASE L | ADVIERTE (por diseño) | se re-verifica tras el push de FASE L (reporte final) | — | tras FASE L |
| R-10 (difflib) | lista borrada = §1 | difflib | la lista de §1 | otra alineación de las vacías en 4 rachas; resultado idéntico | — (no es hallazgo) | explicado arriba | — | git diff = §1; los dos conjuntos dan `HEAD` |
| resto | R-01 a R-06, R-08, R-09, R-11 a R-20 y R-22 | pasos 2 a 6 | lo que dice cada fila | igual a lo esperado | — | ninguna | — | — |

No hay hallazgos **BLOQUEA** (ningún 🔒 falla, el alcance se respeta y la historia es lineal sobre `568b418`) ni **REPARA**. No hubo ciclo de reparación ni `git revert`.

**Veredicto de FASE R: APROBADO CON ADVERTENCIAS** (R-07, instrumental, y el 🔒8 pendiente de FASE L por diseño).

### FASE L: cierre del log

**1. Porcelain.**

esperado: `git status --porcelain` = solo el LOG
obtenido: `?? 50_documentacion/andamios/logs/20260926_comentarios_huerfanos_css_a12_log.md`, en `main`. PASA

**2. Resumen.** El a12 retiró del `<style>` del template los 11 comentarios huérfanos que dejó el a10.
- Se borraron las 26 líneas de §1: 13 de comentario y 13 vacías, sin agregar ningún carácter y fuera del bloque transpilado. M-DERIVA quedó idéntico antes y después.
- El motor se desplegó en `docs/index.html`. Antes y después son idénticos en CSSOM (232 reglas; y con `postcss`, 1261 nodos sin comentarios), `textContent` y capturas (AE 0, con ventana y con ventana alta), con 0 errores de consola.
- Las cifras quedaron intactas: SHA `d9895a78…0442` y PRUEBAS b en verde. El motor pesa exactamente 513 bytes menos.
- Una medición de FASE 0 mostró que la captura `fullPage` no es determinista; el 🔒5 se midió con capturas de ventana, que sí lo son.
- FASE R re-derivó cada afirmación con otro comando (difflib, `postcss`, `openssl` y `stat`, Python, `cmp`), y los dos controles positivos discriminan. Veredicto: **APROBADO CON ADVERTENCIAS**.

**3. Commits** (`git log --oneline ccc0741..HEAD`, más el de FASE 0; el `docs(log)` va encima y su hash queda en el reporte final):

| commit | mensaje |
|---|---|
| `ccc0741` | `chore(encargo): comentarios huérfanos del CSS a12` (FASE 0, `<inicio>`) |
| `c0aa5aa` | `refactor(motor): retira los 11 comentarios huérfanos del CSS (a12 T1)` |
| `bbabda6` | `deploy(motor): publica el motor sin comentarios huérfanos del CSS (a12)` |

**4. Tabla de FASE R:** en FASE R, pasos 1 a 10.

**5. 🔒 con evidencia** (salida literal en FASE R, paso 3): 🔒1 a 🔒7 y 🔒9 PASA. El 🔒8 tenía 2 de 3 rutas por diseño en FASE R, porque la tercera es este LOG; se re-verifica tras el push y el resultado va en el reporte final.

**6. Bytes antes y después:**

| archivo | antes | después | diferencia |
|---|---|---|---|
| `30_procesamiento/33_motor_template.html` | `fce2d439…`, 111216 bytes, 2588 líneas, `<style>` 8 a 940, 79 comentarios | `1b615464…`, 110703 bytes, 2562 líneas, `<style>` 8 a 914, 68 comentarios | −513 bytes, −26 líneas |
| motor (`docs/index.html`) | `587f4233…` publicado (1889390 bytes, fecha `2026-09-25`); base de M5 `08fb74b9…` (1889390, fecha `2026-09-26`) | `018f6365…`, 1888877 bytes (fecha `2026-09-26`) | −513 bytes |

**7. Dudas** (pregunta cerrada):

- **D6 (nueva):** la captura `fullPage` de Puppeteer no fue determinista en este motor (dos corridas del mismo archivo: AE 3.35 y 0.27). ¿Se fija como método estándar de AE, en los próximos encargos de UI, la captura de ventana más la de ventana estirada a la altura del documento, y se descarta `fullPage`? (sí / no)
- D1, D2 y D3 (del a11) siguen abiertas; este encargo no las toca.

**8. Errores propios:**

- **`echo` con cadena de `=` en zsh.** Al leer los insumos de FASE 0, corrí `echo =====` como separador dentro de una cadena de comandos, que la POSICIÓN de este encargo prohíbe expresamente. zsh cortó la cadena después del primer comando, y repetí la lectura sin el separador. Efecto: ninguno sobre el repo ni sobre las mediciones. Es la misma clase de error que declaró el a11b.

**9. Notas para el revisor:**

- Una pasada visual por el sitio publicado no debería mostrar ninguna diferencia. El CSSOM es idéntico y las capturas de 1280 px, 390 px, del modal y de la página entera dan AE 0 contra la base.
- En `docs/index.html` cambian dos cosas: salen las 26 líneas del CSS y la línea del payload cambia de fecha de generación (`2026-09-25` → `2026-09-26`). El contenido del payload es el mismo (SHA normalizado igual).
- Una alineación distinta de las líneas vacías con difflib no es un hallazgo: los dos conjuntos de líneas producen el mismo archivo.
- Los temporales quedan en `/tmp/cat_a12_*`. No se instaló nada: Babel y `postcss` son copias de `/tmp/cat_a10_*`, y Puppeteer es el de los encargos anteriores.
- El `CLAUDE.md` local (ignorado por git) no se actualizó porque está fuera de ALCANCE. Queda para el cierre de sesión.

**10. Privacidad del LOG y conteos:**

esperado: grep del patrón de RUT sobre el LOG = 0; `grep -cF "$HOME"` = 0; sin nombres de establecimiento ni de personas, y sin RBD con número
obtenido: 0; 0; la lectura no encuentra nombres de establecimiento ni de personas, y hay 0 RBD con número. Los textos de los comentarios citados son del CSS del motor, no datos. PASA

esperado: `grep -c '^### FASE'` = 3; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1
obtenido: se mide sobre este archivo terminado, antes del commit; la salida literal va en el reporte final junto con `ls -l` y `wc -l`

**11. Cierre:** commit `docs(log): comentarios huérfanos del CSS a12` (solo el LOG); simulacro del hook con remote = `origin/main` (esperado exit 0); `git push origin main`, el único acto externo, autorizado en el lanzamiento; después, `curl` del sitio publicado (hasta 10 intentos cada 30 s) con resultado en el reporte final. Estado esperado: checkout en `main` = `origin/main`, porcelain vacío.

## J. Juicio (lo rellena FASE L)

- **Meta y resultado:** retirar del `<style>` del motor los 11 comentarios huérfanos del a10, sin cambiar nada más, y desplegar. Resultado: 26 líneas borradas (13 de comentario y 13 vacías), CSS y render idénticos, motor desplegado con 513 bytes menos. Veredicto de FASE R: **APROBADO CON ADVERTENCIAS**.
- **Estado por tarea:**
  - FASE 0: completa (M1 a M6 y M-DERIVA PASA).
  - T1: completada (`c0aa5aa`).
  - T2: completada (`bbabda6`).
  - FASE R: aprobado con advertencias.
  - FASE L: este cierre.
- **Commits:** `ccc0741` (FASE 0) → `c0aa5aa` (T1) → `bbabda6` (T2) → `docs(log)` (este LOG), en `main` sobre `568b418`.
- **Auditoría:** cada afirmación se re-derivó con un comando distinto:
  - el diff con difflib, además del diff de git;
  - el CSSOM con `postcss`, además de Chrome;
  - md5 y bytes con `openssl` y `stat`;
  - el SHA con Python desde `git show`;
  - el bloque de la app con `cmp`.

  Todo coincidió. Los controles positivos discriminan: una `}` borrada de más da FALLA del 🔒1, y una regla viva borrada da un CSSOM distinto.
- **Invariantes:** 🔒1 a 🔒7 y 🔒9 PASA con salida literal (FASE R, paso 3). El 🔒8 queda en 2 de 3 por diseño hasta el commit y el push de este LOG, y se re-verifica en el reporte final.
- **Cifras críticas:**
  - template `fce2d439…` → `1b615464…` (111216 → 110703 bytes; 2588 → 2562 líneas; 79 → 68 comentarios);
  - motor 1889390 → 1888877 bytes (`587f4233…` → `018f6365…`);
  - CSSOM 232 = 232;
  - SHA del payload `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`, sin cambio;
  - M-DERIVA `84d079b7…`, 1614 líneas, idéntico.
- **Decisiones autónomas de mayor riesgo:**
  - Medir el 🔒5 con capturas de ventana, más dos de ventana alta, en lugar de `fullPage`, después de comprobar que `fullPage` no era determinista. El criterio de AE = 0 no cambió.
  - Medir el CSSOM antes de inyectar el estilo sin transiciones.
- **Desviaciones:** ninguna respecto del ALCANCE ni de los criterios. La única llamada git antes del `fetch` fue `rev-parse --show-toplevel`, que exige ENTORNO, con `GIT_OPTIONAL_LOCKS=0`.
- **Dudas abiertas:** D6 (nueva: método estándar de captura para AE); D1, D2 y D3 del a11, fuera de este encargo.
- **Errores propios:** uno, un `echo =====` en zsh al leer los insumos, contra la POSICIÓN; sin efecto.
- **Qué debe verificar el revisor:**
  - una pasada visual por el sitio: nada debería verse distinto;
  - el diff de `c0aa5aa`: solo borrados en el `<style>`;
  - la respuesta a D6.
- **No publicado / queda al usuario:**
  - el push y la verificación del sitio publicado (en el reporte final);
  - D6;
  - la actualización del `CLAUDE.md` local, fuera de ALCANCE;
  - los temporales de `/tmp/cat_a12_*`.
- **Ejecución:** autónoma, en un turno, sin subagentes ni workflows, esfuerzo `xhigh`. La sesión estaba en `ultracode` con Opus 5.5 y mandó el encargo. Sin pausas: el único acto externo venía autorizado en el lanzamiento.

