# Encargo autónomo: trayectoria en orden cronológico, de izquierda a derecha (a4)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (edición en serie de una misma fuente, un build y un push).
- **EJECUCIÓN:** esfuerzo `high`; orquestador el modelo de la sesión; subagentes 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_categoria_desempeno`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/33_app.jsx`; `30_procesamiento/33_motor_template.html`; `00_run_all.R`; `tests/auditar_cifras.R`; `tests/spot_check_publicado.R`; el LOG del a3 (`50_documentacion/andamios/logs/20260925_contraste_a3_log.md`: recetas de build, retranspilación, payload, recorrido de 19 estados e instrumento de contraste).
- **POSICIÓN:** rutas absolutas desde la raíz; ningún comando asume `cd`. `bash` explícito (bash 3.2). `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`), con transiciones y animaciones desactivadas antes de medir. Babel en `/tmp/cat_a4_babel` (copia de `/tmp/cat_a3_babel` si existe; si no, `npm install` de `@babel/cli`, `@babel/core` y `@babel/preset-react`), receta de la cabecera de `33_app.jsx`. Instrumentos en `/tmp/cat_a4_*`: los de `/tmp/cat_a3_*` pueden copiarse y se recalibran; si no existen, se reconstruyen con las recetas del LOG a3. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. `renv` activo en toda corrida R. Ningún shell en segundo plano queda corriendo al terminar.
- **LOG:** `50_documentacion/andamios/logs/20260925_orden_trayectoria_a4_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): orden de la trayectoria a4` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_categoria_desempeno"); source("00_run_all.R"); run_all(only = 33)'` con exit 0 y 0 warnings; (b) 0 errores de consola y 0 `pageerror` en los 19 estados del LOG a3; (c) **payload idéntico al del a3:** SHA-256 del JSON embebido, descomprimido y con `fecha_generacion` normalizada, igual al del motor del a3 (`40_salidas/motor_categoria.html`, md5 `9a4e845c41a803ac40fb299c77b54511`), medido en M3; (d) `tests/auditar_cifras.R` y `tests/spot_check_publicado.R` en verde, corridos con `docs/index.html` del build nuevo y antes de restaurarlo.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`; el LOG no lleva RBD con número ni nombres de establecimiento. **El bloque de la app del template nunca se edita a mano:** el cambio se hace en `33_app.jsx` y llega al template solo por retranspilación completa, que reemplaza el bloque entero. **Ningún hex nuevo, ningún cambio de CSS.**

## 1. Qué aprobó el titular (sesión 30 del chat, 2026-09-25)

Los años de la trayectoria de categoría se muestran en **orden cronológico ascendente** (el más antiguo primero, el vigente al final), y el detalle "Trayectoria y matrícula por año" sigue el mismo orden. Esto deja sin efecto la parte "orden reciente → antiguo" de la c.20 del backlog (sesión 3); la entrada nueva del backlog la escribe el cierre de la sesión, no este encargo.

| Id | Cambio | Dónde |
|---|---|---|
| O1 | `Trayectoria`: el orden pasa de descendente (`b.anio - a.anio`) a ascendente (`a.anio - b.anio`). El comentario del encabezado del bloque ("reciente -> antiguo") y el comentario "Orden descendente: el año más reciente primero." se actualizan para decir lo que el código hace | `33_app.jsx`, función `Trayectoria` |
| O2 | `EeRow`: la serie del detalle pasa a ascendente; la variable `serieDesc` se renombra `serieAsc` (todas sus referencias) | `33_app.jsx`, función `EeRow` |

**Sin cambio:** el anillo del año vigente (sigue en el año vigente, que ahora queda a la derecha o al final), los colores, el CSS, la lista "Evolución de la matrícula" (ya es ascendente; se verifica, no se toca) y cualquier otro orden del motor.

**Límites:** nada en el pipeline 30 a 32, en `33_generar_html.R`, en `34_*`, en `10_utils`, en `20_insumos` ni en `tests/`; nada en el CSS del template; `docs/` no se despliega (el despliegue conjunto de a2, a3 y a4 lo decide el titular tras la revisión en pantalla).

## 2. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `118cf25` (fuente: `git log --oneline -1`, sesión 30 del chat).
- `git status --porcelain` = `?? 40_salidas/categoria_rbd_contrato.parquet` (preexistente; no se toca) más este encargo (fuente: `git status --short`, sesión 30 del chat).
- `33_app.jsx`: `Trayectoria` ordena con `serie.slice().sort((a, b) => b.anio - a.anio)` (L948) y `EeRow` con `const serieDesc = ee.serie.slice().sort((a, b) => b.anio - a.anio);` (L1002); son los dos únicos `sort` por año descendente del archivo (fuente: `grep -n 'sort('`, sesión 30 del chat). La lista de evolución de matrícula recorre `CatData.matriculaSerieNivel(...)` y calcula el delta de `conDato[0]` a `conDato[último]` (fuente: lectura de `EeRow`, sesión 30 del chat): su orden ascendente es hipótesis (verificar con M5).
- Motor del a3: `40_salidas/motor_categoria.html` md5 `9a4e845c41a803ac40fb299c77b54511`; `docs/index.html` md5 `45e612f1c9909a2dd1115d9e8628cde0` (fuente: LOG a3, T5).

## 3. Invariantes 🔒

1. **Payload idéntico al del a3:** PRUEBAS c.
2. **Cifras intactas:** PRUEBAS d.
3. **Sin CSS ni color:** `git diff <inicio>..HEAD -- 30_procesamiento/33_motor_template.html` toca solo líneas dentro del bloque de la app transpilado; 0 hex en líneas agregadas.
4. **Pipeline y pruebas intactos:** `git diff <inicio>..HEAD -- 30_procesamiento/30_* 30_procesamiento/31_* 30_procesamiento/32_* 30_procesamiento/33_generar_html.R 30_procesamiento/34_* 20_insumos 10_utils tests | wc -l` → `0`.
5. **`docs/` publicado intacto:** al cerrar, md5 `45e612f1…` y `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **Fuente y transpilado no divergen:** bloque del template = retranspilación de `33_app.jsx` (cadena idéntica).
7. **Solo cambia el orden:** en los 19 estados, el `textContent` de `#root` coincide con el de la línea base **salvo el orden de los años** dentro de cada `.traj` y de cada `.ee-detail-list`. Se comprueba así: (i) quitando esos dos tipos de nodo, `textContent` idéntico; (ii) dentro de cada `.traj` y de cada `.ee-detail-list`, el multiconjunto de pares (año, texto de su bloque o `title` de su marca) es idéntico al de la línea base y la secuencia de años es estrictamente ascendente.
8. **Contraste sin regresión:** el instrumento de contraste del a3 en los 19 estados da 0 fallas de texto y 0 gráficas exigidas en controles activos (como al cierre del a3).

## 4. Tareas

Orden: FASE 0 → T1 → T2 → T3; **FASE R** y **FASE L** corren siempre.

### Regla de detención

1. Stash no vacío o porcelain antes del primer commit fuera de {este encargo, el parquet, el LOG} → detén la sesión y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` → detén la sesión y pasa a FASE L.
3. M-DERIVA en falla → congela T1 y T3.
4. PRUEBAS c o d en falla, o cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. Residual (estado, conteo o resultado no enumerado) → congela ese ítem, regístralo como duda con pregunta cerrada y sigue con lo independiente.

### Autorizaciones (lista cerrada)

- FASE 0: `git add` y `git commit` de este encargo (`chore(encargo): orden de la trayectoria a4`).
- Instalación o copia de Babel en `/tmp/cat_a4_babel`; archivos temporales en `/tmp/cat_a4_*`.
- `git commit` de T1 y de T2, cada uno tras su verificación.
- Después de cada build: `git restore docs/index.html` y verificación del md5 `45e612f1…`.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` = `?? 40_salidas/categoria_rbd_contrato.parquet` y `HEAD..origin/main` = 0.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más: ni `rm`, `reset`, `checkout --`, `rebase`, ni commit de `docs/index.html`, ni `npx` de herramientas no listadas, ni instalación de paquetes R.

### FASE 0 (cada medición con `esperado:` antes y `obtenido:` después)

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash; archivos del primer commit | el parquet y el LOG; vacío; el encargo | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `118cf25` = `origin/main`; 0; 1 | regla 2 |
| M3 | md5 de §2; SHA del payload normalizado (fecha) del motor del a3, con instrumento recalibrado (fecha alterada → igual; una cifra plantada → distinto); PRUEBAS d | md5 de §2; SHA registrado como referencia de PRUEBAS c; calibración correcta; verde | regla 4 |
| M-DERIVA | retranspilar `33_app.jsx` y comparar con el bloque del template | cadena idéntica (así cerró el a3) | regla 3 |
| M5 | En el motor del a3: secuencia de años de cada `.traj` visible en S01 y S05, de la `.ee-detail-list` y de la `.ee-evol-list` en S03 | `.traj` y `.ee-detail-list` descendentes (2019, 2018, 2017, 2016); `.ee-evol-list` ascendente | se registra; si `.ee-evol-list` no es ascendente, pasa a duda (no se toca) |
| M6 | Línea base de los 19 estados (capturas y `textContent`), con determinismo | 19/19 texto igual entre corridas | sin acción |

### T1: orden ascendente (O1, O2)

1. Editar `33_app.jsx` según §1; retranspilar y reemplazar el bloque entero del template.
2. Build (PRUEBAS a), PRUEBAS c y d; `git restore docs/index.html`.
3. Verificación (`esperado:` antes): en S01, S05, S10 y S11, toda `.traj` con años ascendentes y el anillo (`.traj-mark.is-vigente` y `.traj-year-lbl.is-vigente`) en el **último** año; en S03, `.ee-detail-list` ascendente con la fila `is-vigente` al final; `.ee-evol-list` y el delta del detalle sin cambio respecto de M5; `grep -c 'serieDesc' 33_app.jsx` = 0; 🔒1 a 🔒7 aplicables.
4. Commit `feat(motor): trayectoria en orden cronológico ascendente (a4 T1: O1, O2)`.

### T2: contraste sin regresión

1. Instrumento de contraste del a3 en los 19 estados sobre el build de T1: 🔒8.
2. Sin commit (no cambia archivos versionados).

### T3: build final

1. Build con PRUEBAS a; PRUEBAS c y d; `git restore docs/index.html` y md5 `45e612f1…`.
2. md5 del motor nuevo; capturas antes y después de S01, S03 y S05 en `/tmp/cat_a4_gate/`.

### FASE R (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio. Inventario `R-01…` anexado antes de auditar; re-derivación por un camino distinto (leer los años desde el DOM por coordenada horizontal `getBoundingClientRect().left` en `.traj`, y por posición vertical en `.ee-detail-list`, en vez del orden de nodos); comando de cada 🔒 con salida literal; alcance global (`git diff --name-only <inicio>..HEAD`: solo `33_app.jsx`, el template y el LOG); regresión PRUEBAS a a d; control positivo (el motor del a3 sigue mostrando el orden descendente con el mismo instrumento). Veredicto por hallazgo (BLOQUEA / REPARA / ADVIERTE), máximo 2 ciclos de reparación, tabla `id | afirmación | comando | esperado | obtenido | severidad | acción | commit | re-verificación`.

### FASE L (última, obligatoria)

Resumen, commits, invariantes, md5 del motor nuevo, dudas con pregunta cerrada, errores propios, bloque J de trece campos, privacidad (script de RUT con control plantado → vacío), verificación del archivo (`grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1), commit `docs(log): orden de la trayectoria a4` y push según la autorización.

## 5. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J tal cual.
- Después: secuencia de años antes → después en `.traj` y `.ee-detail-list`; resultado de 🔒7 y 🔒8; salida del push; md5 del motor nuevo; lo que queda al titular para la revisión en pantalla (abrir `40_salidas/motor_categoria.html`: trayectorias en básica y media, detalle de un establecimiento, junto con lo pendiente de revisar de a2 y a3); "lo que falló o sorprendió; si nada, decirlo".
