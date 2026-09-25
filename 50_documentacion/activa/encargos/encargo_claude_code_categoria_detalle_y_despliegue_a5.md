# Encargo autónomo: detalle por año de lo más reciente a lo más antiguo, y despliegue de a2 a a5 (a5)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (edición en serie de una misma fuente, un build, un despliegue y un push).
- **EJECUCIÓN:** esfuerzo `high`; orquestador el modelo de la sesión; subagentes 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_categoria_desempeno`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/33_app.jsx`; `30_procesamiento/33_motor_template.html`; `00_run_all.R`; `tests/auditar_cifras.R`; `tests/spot_check_publicado.R`; el LOG del a4 (`50_documentacion/andamios/logs/20260925_orden_trayectoria_a4_log.md`: recetas de build, retranspilación, payload, orden por bloque, 🔒7 y contraste).
- **POSICIÓN:** rutas absolutas desde la raíz; ningún comando asume `cd`. `bash` explícito (bash 3.2). `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`), con transiciones y animaciones desactivadas antes de medir. Babel en `/tmp/cat_a5_babel` (copia de `/tmp/cat_a4_babel`; si no existe, `npm install` de `@babel/cli`, `@babel/core` y `@babel/preset-react`). Instrumentos en `/tmp/cat_a5_*`, copiados de `/tmp/cat_a4_*` y recalibrados, o reconstruidos con las recetas del LOG a4. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. `renv` activo en toda corrida R. Ningún shell en segundo plano queda corriendo al terminar.
- **LOG:** `50_documentacion/andamios/logs/20260925_detalle_y_despliegue_a5_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): detalle y despliegue a5` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_categoria_desempeno"); source("00_run_all.R"); run_all(only = 33)'` con exit 0 y 0 warnings; (b) 0 errores de consola y 0 `pageerror` en los 19 estados del LOG a4; (c) **payload idéntico al del a4:** SHA-256 del JSON embebido, descomprimido y con `fecha_generacion` normalizada = `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442` (fuente: LOG a4, M3 y T3); (d) `tests/auditar_cifras.R` y `tests/spot_check_publicado.R` en verde, corridos con `docs/index.html` del build nuevo.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria. Un push denegado no se reintenta por otra vía.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`; el LOG no lleva RBD con número ni nombres de establecimiento. **El bloque de la app del template nunca se edita a mano:** el cambio se hace en `33_app.jsx` y llega al template solo por retranspilación completa. **Ningún hex nuevo, ningún cambio de CSS.**

## 1. Qué aprobó el titular (sesión 30 del chat, 2026-09-25)

1. **Revertir O2 del a4, y solo O2.** El detalle "Trayectoria y matrícula por año" (`.ee-detail-list`, lista vertical larga) vuelve a ir del año vigente al más antiguo, para que el vigente quede junto a la trayectoria y no al final de un scroll. La trayectoria horizontal (`.traj`, O1) **sigue ascendente**, con el vigente a la derecha. La lista "Evolución de la matrícula" (`.ee-evol-list`) sigue ascendente, sin cambio.
2. **Desplegar** a `docs/index.html` el motor con a2, a3, a4 y esta reversión, en el mismo encargo, encadenado: el despliegue (T2) corre solo si T1 terminó en verde.
3. **Q-SEP del a3:** se mantiene la opacidad 1 del separador "·" (lectura de P1); no hay nada que revertir.

| Id | Cambio | Dónde |
|---|---|---|
| R1 | `EeRow`: `const serieAsc = ee.serie.slice().sort((a, b) => a.anio - b.anio);` → `const serieDesc = ee.serie.slice().sort((a, b) => b.anio - a.anio);` y su único uso; comentario breve: `a5: el detalle vertical va del vigente al más antiguo; la trayectoria horizontal (Trayectoria) sigue ascendente`. `Trayectoria` no se toca | `33_app.jsx` |

**Límites:** nada en el pipeline 30 a 32, en `33_generar_html.R`, en `34_*`, en `10_utils`, en `20_insumos` ni en `tests/`; nada en el CSS del template.

## 2. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `a6a997a` (fuente: `git log --oneline -4` y `.git/refs/remotes/origin/main`, sesión 30 del chat).
- `git status --porcelain` = `?? 40_salidas/categoria_rbd_contrato.parquet` (preexistente; no se toca) más este encargo.
- Motor del a4: `40_salidas/motor_categoria.html` md5 `dbbf572202d2de1a7bb5cbf97f397793`; `docs/index.html` md5 `45e612f1c9909a2dd1115d9e8628cde0`, que es el motor publicado anterior a a2 (fuente: LOG a4, T3).
- `33_app.jsx`, `EeRow`: `serieAsc` con orden ascendente y un único uso; `Trayectoria` ordena ascendente con el comentario `a4-O1` (fuente: LOG a4, T1).

## 3. Invariantes 🔒

1. **Payload idéntico al del a4:** PRUEBAS c, antes y después del despliegue.
2. **Cifras intactas:** PRUEBAS d.
3. **Sin CSS ni color:** los cambios del template están todos dentro del bloque de la app transpilado; 0 hex en líneas agregadas.
4. **Pipeline y pruebas intactos:** `git diff <inicio>..HEAD -- 30_procesamiento/30_* 30_procesamiento/31_* 30_procesamiento/32_* 30_procesamiento/33_generar_html.R 30_procesamiento/34_* 20_insumos 10_utils tests | wc -l` → `0`.
5. **Despliegue fiel:** tras T2, `docs/index.html` es el build de las fuentes de `HEAD`: md5 de `docs/index.html` = md5 de `40_salidas/motor_categoria.html` del mismo build.
6. **Fuente y transpilado no divergen:** bloque del template = retranspilación de `33_app.jsx` (cadena idéntica).
7. **Solo cambia el orden del detalle:** en los 19 estados, frente a la línea base (motor del a4): (i) quitando las `.ee-detail-list`, `textContent` de `#root` idéntico; (ii) dentro de cada `.ee-detail-list`, el multiconjunto de pares (año, texto de su fila) idéntico y la secuencia de años estrictamente **descendente**, con la fila vigente en el índice 0; (iii) toda `.traj` sigue estrictamente **ascendente**, con el anillo en el último año; (iv) `.ee-evol-list` y el delta del detalle sin cambio.
8. **Contraste sin regresión:** instrumento del a3 en los 19 estados: 0 fallas de texto y 0 gráficas exigidas en controles activos.

## 4. Tareas

Orden: FASE 0 → T1 → T2 (solo si T1 terminó sin congelarse) → FASE R → FASE L.

### Regla de detención

1. Stash no vacío o porcelain antes del primer commit fuera de {este encargo, el parquet, el LOG} → detén la sesión y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` → detén la sesión y pasa a FASE L.
3. M-DERIVA en falla → congela T1 y T2.
4. PRUEBAS c o d en falla, o cualquier 🔒 en FALLA durante T1 → congela T1 y **no se despliega** (T2 congelada); `git restore docs/index.html`.
5. PRUEBAS c o d en falla durante T2 → `git restore docs/index.html`, T2 congelada, sin commit de despliegue.
6. Residual (estado, conteo o resultado no enumerado) → congela ese ítem, regístralo como duda con pregunta cerrada y sigue con lo independiente; si afecta a T1, T2 no corre.

### Autorizaciones (lista cerrada)

- FASE 0: `git add` y `git commit` de este encargo (`chore(encargo): detalle y despliegue a5`).
- Instalación o copia de Babel en `/tmp/cat_a5_babel`; archivos temporales en `/tmp/cat_a5_*`.
- `git commit` de T1 tras su verificación.
- En T1, después del build: `git restore docs/index.html` y verificación del md5 `45e612f1…`.
- En T2: `git add /Users/tomgc/Projects/slep_categoria_desempeno/docs/index.html` y `git commit` de despliegue, solo tras sus verificaciones.
- `git revert <hash>` de un commit propio, si FASE R lo exige (si revierte el despliegue, se declara en el LOG y en el reporte).
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` = `?? 40_salidas/categoria_rbd_contrato.parquet` y `HEAD..origin/main` = 0.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más: ni `rm`, `reset`, `checkout --`, `rebase`, ni `npx` de herramientas no listadas, ni instalación de paquetes R.

### FASE 0 (cada medición con `esperado:` antes y `obtenido:` después)

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash; archivos del primer commit | el parquet y el LOG; vacío; el encargo | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `a6a997a` = `origin/main`; 0; 1 | regla 2 |
| M3 | md5 de §2; SHA del payload normalizado (fecha) del motor del a4, instrumento recalibrado (fecha alterada → igual; una cifra plantada → distinto); PRUEBAS d | md5 de §2; `d9895a78…0442`; calibración correcta; verde | regla 4 |
| M-DERIVA | retranspilación de `33_app.jsx` frente al bloque del template | cadena idéntica | regla 3 |
| M5 | En el motor del a4: orden de `.traj` (S01, S05, S10, S11), `.ee-detail-list` y `.ee-evol-list` (S03) | `.traj` ascendente; `.ee-detail-list` ascendente con el vigente al final; `.ee-evol-list` ascendente | se registra |
| M6 | Línea base de los 19 estados (capturas, `textContent` y bloques de años), con determinismo | 19/19 igual entre corridas | sin acción |

### T1: revertir O2 (R1)

1. Editar `33_app.jsx` según §1; retranspilar y reemplazar el bloque entero del template.
2. Build (PRUEBAS a), PRUEBAS c y d; `git restore docs/index.html` y md5 `45e612f1…`.
3. Verificación (`esperado:` antes): 🔒7 completo en los 19 estados (orden por nodos y por coordenada: `left` en `.traj`, `top` en `.ee-detail-list`); `grep -c serieAsc 33_app.jsx` = 0; `grep -c 'b.anio - a.anio' 33_app.jsx` = 1 (el de `EeRow`); 🔒1 a 🔒6; 🔒8.
4. Commit `fix(motor): el detalle por año vuelve a empezar en el vigente (a5 T1: revierte O2 del a4)`.

### T2: despliegue (solo si T1 terminó en verde)

1. Build con PRUEBAS a; `docs/index.html` queda con el build nuevo (**no** se restaura).
2. Verificación (`esperado:` antes): PRUEBAS c sobre `docs/index.html` = `d9895a78…0442`; PRUEBAS d en verde; 🔒5 (md5 de `docs/index.html` = md5 de `40_salidas/motor_categoria.html`); en `docs/index.html` abierto por `file://`: 0 errores en los 19 estados, `meta.cat_colors` = `{"INSUFICIENTE":"#D0112D","MEDIO-BAJO":"#E05D2F","MEDIO":"#2A8FD9","ALTO":"#0062A0"}`, `.traj` ascendentes y `.ee-detail-list` descendentes; `git status --short` = `M docs/index.html` más el parquet.
3. Commit `deploy(motor): publica alineamiento (a2), contraste (a3), orden de la trayectoria (a4) y detalle por año (a5)`, con `git add` de la ruta absoluta de `docs/index.html`.

### FASE R (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio. Inventario `R-01…` anexado antes de auditar; re-derivación por un camino distinto (orden por coordenada si antes fue por nodos, y viceversa; SHA del payload recalculado desde `docs/index.html` del commit de despliegue con `git show <hash>:docs/index.html`); comando de cada 🔒 con salida literal; alcance global (`git diff --name-only <inicio>..HEAD`: `33_app.jsx`, el template, `docs/index.html` y el LOG); regresión PRUEBAS a a d; control positivo (el motor del a4 sigue mostrando el detalle ascendente con el mismo instrumento). Veredicto por hallazgo (BLOQUEA / REPARA / ADVIERTE), máximo 2 ciclos, tabla `id | afirmación | comando | esperado | obtenido | severidad | acción | commit | re-verificación`. **Un BLOQUEA en T1 o en T2 obliga a `git revert` del commit de despliegue antes del push**, y se declara.

### FASE L (última, obligatoria)

Resumen, commits, invariantes, md5 de `docs/index.html` publicado, dudas con pregunta cerrada, errores propios, bloque J de trece campos, privacidad (script de RUT con control plantado → vacío), verificación del archivo (`grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1), commit `docs(log): detalle y despliegue a5` y push según la autorización.

## 5. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J tal cual.
- Después: orden de `.traj`, `.ee-detail-list` y `.ee-evol-list` antes → después; resultado de 🔒5, 🔒7 y 🔒8; hash del commit de despliegue; md5 de `docs/index.html`; salida del push; qué revisar en el sitio publicado una vez que GitHub Pages lo actualice (las cabeceras, una trayectoria, el detalle de un establecimiento y el comparador); "lo que falló o sorprendió; si nada, decirlo".
