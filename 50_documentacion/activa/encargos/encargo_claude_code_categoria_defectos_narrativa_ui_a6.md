# Encargo autónomo: seis defectos visibles de narrativa y UI, y despliegue (a6)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (edición en serie de una misma fuente, un build, un despliegue y un push).
- **EJECUCIÓN:** esfuerzo `high`; orquestador el modelo de la sesión; subagentes 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_categoria_desempeno`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/33_app.jsx`; `30_procesamiento/33_motor_template.html`; `00_run_all.R`; `tests/auditar_cifras.R`; `tests/spot_check_publicado.R`; los LOG del a2 (defectos anotados, §"lo que falló o sorprendió"), del a3 (instrumento de contraste y los 19 estados) y del a5 (recetas de build, retranspilación, payload, orden por bloque y 🔒7), en `50_documentacion/andamios/logs/`.
- **POSICIÓN:** rutas absolutas desde la raíz; ningún comando asume `cd`. `bash` explícito (bash 3.2). `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`), con `*{transition:none!important;animation:none!important}` inyectado antes de medir. Babel en `/tmp/cat_a6_babel` (copia de `/tmp/cat_a5_babel`; si no existe, `npm install` de `@babel/cli`, `@babel/core` y `@babel/preset-react`). Instrumentos en `/tmp/cat_a6_*`, copiados de `/tmp/cat_a5_*` y recalibrados, o reconstruidos con las recetas de los LOG a3 y a5. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. `renv` activo en toda corrida R. Ningún shell en segundo plano queda corriendo al terminar.
- **LOG:** `50_documentacion/andamios/logs/20260925_defectos_narrativa_ui_a6_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): defectos de narrativa y UI a6` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_categoria_desempeno"); source("00_run_all.R"); run_all(only = 33)'` con exit 0 y 0 warnings; (b) 0 errores de consola y 0 `pageerror` en los 19 estados del LOG a3 y en los estados nuevos N1 a N6; (c) **payload idéntico:** SHA-256 del JSON embebido, descomprimido y con `fecha_generacion` normalizada = `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442` (fuente: traspaso v30 §3 y LOG a5); (d) `tests/auditar_cifras.R` y `tests/spot_check_publicado.R` en verde, corridos con `docs/index.html` del build nuevo.
- **Topes de esfuerzo:** 3 intentos por defecto; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria. Un push denegado no se reintenta por otra vía.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`; el LOG no lleva RBD con número ni nombres de establecimiento (los estados se identifican por índice o por hash corto del RBD). **El bloque de la app del template nunca se edita a mano:** la lógica y el JSX van en `33_app.jsx` y llegan al template solo por retranspilación completa; el CSS sí se edita en el template, solo en los selectores de §1. **Ningún hex nuevo.**

## 1. Qué aprobó el titular (sesión 31 del chat, 2026-09-25)

Ruta de la sesión 31, prioridad 1: corregir los seis defectos del pendiente #1 del traspaso v30, cada uno reproducido con medición antes y cerrado con medición después, sin efecto en payload ni cifras, y desplegar en el mismo encargo si todo termina en verde.

| Id | Defecto | Cambio (lista cerrada) | Dónde |
|---|---|---|---|
| C1 | Frase 3 vacía ("Considerando la matrícula 2025, .") cuando la matrícula del nivel está solo en Medio-Bajo | En `narrativa…`, bloque "Frase 3": tras armar `tramos`, si `tramos.length === 0`, `frase3` queda `null` (la frase se omite). Comentario: `a6-C1: sin matrícula en Medio/Alto ni en Insuficiente, la frase 3 se omite` | `33_app.jsx` |
| C2 | Frase 3 con un establecimiento como sujeto ("…asisten a uno de desempeño…", "…a un establecimiento de desempeño…") | Si `entity.kind === "establecimiento"` y `matTotalNivel > 0`, `frase3` = `["Considerando la matrícula ", b(anioMat), ", el establecimiento tiene ", b(fmtInt(matTotalNivel)), " " + (matTotalNivel === 1 ? "estudiante" : "estudiantes") + " en el nivel."]`, en lugar de los tramos. C2 precede a C1. Comentario: `a6-C2: variante para un establecimiento como sujeto (como a2-T2.3 en la frase 1)` | `33_app.jsx` |
| C3 | `el<b>Simce 2022</b>` sin espacio en la nota de cobertura temporal | `pandemia, y el<b>Simce 2022</b>` → `pandemia, y el{" "}<b>Simce 2022</b>` | `33_app.jsx` |
| C4 | A 390 px la pestaña "Establecimiento" del modal queda cortada | Forma A: agregar `@media (max-width: 560px) { .modal-tabs { padding: 0 16px; } .modal-tab { margin-right: 16px; } }` después de la regla `.modal-tab.is-active`. Forma B, **solo si** con A alguna pestaña sigue cortada a 320 px: agregar además `overflow-x: auto;` a `.modal-tabs` dentro de esa misma media query. Se declara en el LOG cuál quedó | template, CSS |
| C5 | A 320 px, con un nombre largo, el botón de territorio de la barra fija ocupa gran parte de la pantalla | JSX: `<button className="entity-select-btn" title={entity.nom} …><span className="entity-select-nom">{entity.nom}</span> ▾</button>`. CSS: `.entity-select-btn` suma `max-width: 100%; min-width: 0;`; regla nueva `.entity-select-nom { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; min-width: 0; }`. **Solo si** la medición lo exige: `.controls-bar .control-group { min-width: 0; max-width: 100%; }` | `33_app.jsx` + template, CSS |
| C6 | Tras "Limpiar" en el comparador, el foco cae en `BODY` | `onClick` de `.cmp-clear-btn`: `() => { focoTrasQuitar.current = entidades.length; setEntidades([]); }`, que reutiliza el efecto a1-F04 (no hay `.cmp-chip-x` en ese índice → cae en `.cmp-add-btn`). Comentario: `a6-C6: tras Limpiar, el foco pasa a "+ Agregar"` | `33_app.jsx` |

**Cadenas de `textContent` que pueden cambiar (y ninguna otra):**
- C1: desaparece `Considerando la matrícula <año>, .` en los estados donde se reproduce.
- C2: en todo estado con un establecimiento como entidad y matrícula del nivel > 0, la frase 3 pasa de la versión con tramos a `Considerando la matrícula <año>, el establecimiento tiene <N> estudiante(s) en el nivel.`
- C3: `elSimce 2022` → `el Simce 2022`.
- C4, C5 y C6: ninguna (el `title` es un atributo, y el `span` no altera el texto).

**Límites:** nada en el pipeline 30 a 32, en `33_generar_html.R`, en `34_*`, en `10_utils`, en `20_insumos` ni en `tests/`. En el CSS, solo los selectores de C4 y C5.

## 2. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `0396c2a` (`chore(estado): abre sesion en MacBook-Pro-de-Tomas.local`), árbol limpio, `sesion_abierta: true` (fuente: `git log --oneline -2`, `git status --porcelain` y `grep` de ESTADO.md, sesión 31 del chat).
- `docs/index.html` md5 `788d5026562a67a73af43abffd97034e`, igual al sitio publicado (fuente: `md5sum` y `curl` del sitio, sesión 31).
- `33_app.jsx`: frase 3 en las líneas ~517-560, con `tramos` y sin guarda para `tramos` vacío ni variante para un establecimiento; `el<b>Simce 2022</b>` en la ~1826; `.cmp-clear-btn` con `onClick={() => setEntidades([])}` en la ~1507; `focoTrasQuitar` y su efecto en las ~1415-1428; `entity-select-btn` con `{entity.nom} ▾` en la ~1963 (fuente: `grep -n` y `sed -n`, sesión 31).
- Template: `.modal-tabs` con `padding: 0 22px` y `.modal-tab` con `margin-right: 24px` (~869-887); `.entity-select-btn` sin `max-width` (~1272); `.control-group` con `display: flex` (~212) (fuente: `sed -n`, sesión 31).
- `renv` avisa "project is out-of-sync". `renv.lock` tiene 44 paquetes, la biblioteca del proyecto también tiene 44 y ninguna versión difiere; `suitedoc::` se usa en `50_documentacion/suite/documentar.R` y no está en el lock (fuente: lectura de `renv.lock` y de los enlaces de la biblioteca, sesión 31). Que `suitedoc` sea la causa es hipótesis (M0).

## 3. Invariantes 🔒

1. **Payload idéntico:** PRUEBAS c, antes y después del despliegue.
2. **Cifras intactas:** PRUEBAS d.
3. **Color:** 0 hex en las líneas agregadas (`git diff <inicio>..HEAD -U0 | grep '^+' | grep -ciE '#[0-9a-f]{3,8}\b'` → `0`).
4. **Pipeline y pruebas intactos:** `git diff <inicio>..HEAD -- 30_procesamiento/30_* 30_procesamiento/31_* 30_procesamiento/32_* 30_procesamiento/33_generar_html.R 30_procesamiento/34_* 20_insumos 10_utils tests | wc -l` → `0`.
5. **Despliegue fiel:** tras T2, md5 de `docs/index.html` = md5 de `40_salidas/motor_categoria.html` del mismo build.
6. **Fuente y transpilado no divergen:** bloque del template = retranspilación de `33_app.jsx` (cadena idéntica).
7. **Texto:** en los 19 estados y en N1 a N6, `textContent` de `#root` idéntico a la línea base salvo las cadenas declaradas en §1, con el conteo de apariciones de cada cadena informado por estado.
8. **Contraste sin regresión:** instrumento del a3 en los 19 estados más N4 y N5: 0 fallas de texto y 0 gráficas exigidas en controles activos.
9. **Orden temporal intacto:** toda `.traj` estrictamente ascendente con el anillo en el último año; toda `.ee-detail-list` estrictamente descendente con el vigente en el índice 0.

## 4. Tareas

Orden: FASE 0 → T1 (C1 a C3, textos) → T2 (C4 y C5, ancho) → T3 (C6, foco) → T4 despliegue (solo si T1 a T3 terminaron sin congelarse) → FASE R → FASE L. Un commit por tarea.

### Regla de detención

1. Stash no vacío, o porcelain antes del primer commit fuera de {este encargo, el LOG} → detén la sesión y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` → detén la sesión y pasa a FASE L.
3. M-DERIVA en falla → congela T1 a T4.
4. PRUEBAS c o d en falla, o cualquier 🔒 en FALLA durante T1 a T3 → congela esa tarea y las siguientes; **no se despliega**; `git restore docs/index.html`.
5. Un defecto que no se reproduce en M5 → no se corrige; su tarea sigue con los demás, se registra como duda con pregunta cerrada y se declara en el reporte.
6. PRUEBAS c o d en falla durante T4 → `git restore docs/index.html`, T4 congelada, sin commit de despliegue.
7. Residual (estado, conteo o resultado no enumerado) → congela ese ítem, regístralo como duda con pregunta cerrada y sigue con lo independiente; si afecta a T1 a T3, T4 no corre.

### Autorizaciones (lista cerrada)

- FASE 0: `git add` y `git commit` de este encargo (`chore(encargo): defectos de narrativa y UI a6`).
- Instalación o copia de Babel en `/tmp/cat_a6_babel`; archivos temporales en `/tmp/cat_a6_*`.
- `git commit` de T1, T2 y T3, cada uno tras su verificación.
- En T1 a T3, después de cada build: `git restore docs/index.html` y verificación del md5 `788d5026…`.
- En T4: `git add /Users/tomgc/Projects/slep_categoria_desempeno/docs/index.html` y `git commit` de despliegue, solo tras sus verificaciones.
- `git revert <hash>` de un commit propio, si FASE R lo exige (si revierte el despliegue, se declara en el LOG y en el reporte).
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` vacío y `HEAD..origin/main` = 0.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más: ni `rm`, `reset`, `checkout --`, `rebase`, ni `npx` de herramientas no listadas, ni instalación de paquetes R, ni `renv::snapshot()`, `renv::install()` o `renv::restore()`.

### FASE 0 (cada medición con `esperado:` antes y `obtenido:` después)

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M0 | `Rscript -e 'renv::status()'` en la raíz, salida literal al LOG | informa desfase atribuible solo a `suitedoc` (usado y no registrado); ninguna versión distinta | se registra; **no se actúa** sobre renv |
| M1 | porcelain tras el primer commit; stash; archivos del primer commit | el LOG o vacío; vacío; el encargo | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `0396c2a` = `origin/main`; 0; 1 | regla 2 |
| M3 | md5 de `docs/index.html`; SHA del payload normalizado (fecha) de `docs/index.html`, con el instrumento recalibrado (fecha alterada → igual; una cifra plantada → distinto); PRUEBAS d | `788d5026…`; `d9895a78…0442`; calibración correcta; verde | regla 4 |
| M-DERIVA | retranspilación de `33_app.jsx` frente al bloque del template | cadena idéntica | regla 3 |
| M4 | Estados nuevos, elegidos por programa desde el payload y registrados por hash corto: **N1** una entidad territorial (comuna, SLEP o región) y un nivel con matrícula del nivel > 0 y 0 en Medio/Alto e Insuficiente (si no existe ninguna, declararlo); **N2** un establecimiento Medio-Bajo como entidad; **N3** un establecimiento Insuficiente como entidad; **N4** el modal de territorio abierto a 390 y a 320 px; **N5** 320 px con el establecimiento de nombre más ancho (medido en canvas) como entidad; **N6** comparador con 2 territorios y clic en "Limpiar" | cuatro estados definidos (N1 puede declararse vacío) | se registra |
| M5 | Reproducción de cada defecto en `docs/index.html`: C1 en N1 y N2 (cadena `Considerando la matrícula 2025, .`); C2 en N3 (`a uno de desempeño`) y en N2; C3 (`elSimce 2022`, conteo); C4 en N4 (`getBoundingClientRect().right` de cada `.modal-tab` contra el de `.modal-tabs`, y `scrollWidth` contra `clientWidth`); C5 en N5 (alto y ancho del botón, alto de `.controls-bar` y fracción del viewport que ocupa, comparados con un SLEP como entidad); C6 en N6 (`document.activeElement` tras el clic y tras Enter sobre "Limpiar") | los seis se reproducen | regla 5 |
| M6 | Línea base de los 19 estados y N1 a N6 (capturas, `textContent` y bloques de años), con determinismo | igual entre corridas | sin acción |

### T1: textos (C1, C2, C3)

1. Editar `33_app.jsx` según §1 (C2 antes que C1 en el flujo); retranspilar y reemplazar el bloque entero del template.
2. Build (PRUEBAS a), PRUEBAS c y d; `git restore docs/index.html` y md5 `788d5026…`.
3. Verificación (`esperado:` antes): N1 sin frase 3 y sin `Considerando la matrícula 2025, .`; N2 y N3 con la variante C2, sin `a uno de desempeño` ni `a un establecimiento de desempeño`; en todo el motor, `elSimce` 0 y `el Simce 2022` 1; 🔒7 (solo C1 a C3); 🔒1 a 🔒6; 🔒9.
4. Commit `fix(motor): frase 3 de la narrativa sin vacío ni autorreferencia, y espacio en la nota de cobertura (a6 T1)`.

### T2: ancho (C4, C5)

1. CSS de C4 (forma A) y C5 en el template; JSX de C5 en `33_app.jsx`; retranspilar. Si tras medir la forma A de C4 alguna pestaña sigue cortada a 320 px, aplicar la forma B. Si el botón de C5 sigue desbordando, aplicar la regla opcional de `.control-group`.
2. Build, PRUEBAS c y d, `git restore docs/index.html` y md5.
3. Verificación (`esperado:` antes): N4 a 390 px, las 4 pestañas completas dentro de `.modal-tabs` sin scroll; a 320 px, completas o alcanzables por scroll horizontal (forma B declarada); N5, el botón en una sola línea, su borde derecho dentro del viewport, `.controls-bar` a lo más tan alta como con un SLEP como entidad, y `title` igual al nombre completo; desborde horizontal de `#root` 0 a 320, 390 y 1280; 🔒7 sin cadenas nuevas; 🔒8 en N4 y N5; 🔒1 a 🔒6.
4. Commit `fix(motor): pestañas del modal y botón de territorio caben en pantallas angostas (a6 T2)`.

### T3: foco (C6)

1. Editar `33_app.jsx` según §1; retranspilar; build, PRUEBAS c y d, `git restore docs/index.html` y md5.
2. Verificación (`esperado:` antes): en N6, tras el clic y tras Enter sobre "Limpiar", `document.activeElement` = `BUTTON.cmp-add-btn`; quitar un chip sigue llevando el foco como en a1-F04 (medido con 3 territorios, quitando el del medio y el último); 🔒7 sin cadenas nuevas; 🔒1 a 🔒6.
3. Commit `fix(motor): tras Limpiar el comparador, el foco pasa a "+ Agregar" (a6 T3)`.

### T4: despliegue (solo si T1 a T3 terminaron en verde)

1. Build con PRUEBAS a; `docs/index.html` queda con el build nuevo (**no** se restaura).
2. Verificación (`esperado:` antes): PRUEBAS c sobre `docs/index.html` = `d9895a78…0442`; PRUEBAS d en verde; 🔒5; en `docs/index.html` abierto por `file://`: 0 errores en los 19 estados y en N1 a N6, las verificaciones de T1 a T3 repetidas y 🔒9; `git status --short` = `M docs/index.html`.
3. Commit `deploy(motor): publica las correcciones de narrativa, ancho y foco (a6)`, con `git add` de la ruta absoluta de `docs/index.html`.

### FASE R (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio. El inventario `R-01…` se anexa antes de auditar. Cada afirmación se re-deriva por un camino distinto: cadenas por `innerText` si antes fue `textContent`; ancho por captura y conteo de píxeles en el borde si antes fue por `getBoundingClientRect`; foco por el evento `focusin` si antes fue `activeElement`; SHA del payload recalculado desde `git show <hash>:docs/index.html`. Se incluyen:
- el comando de cada 🔒 con su salida literal;
- el alcance global: `git diff --name-only <inicio>..HEAD` debe dar `33_app.jsx`, el template, `docs/index.html`, el encargo y el LOG;
- la regresión PRUEBAS a a d;
- el control positivo: `docs/index.html` de `<inicio>` sigue reproduciendo los seis defectos con los mismos instrumentos.

Cada hallazgo lleva veredicto (BLOQUEA / REPARA / ADVIERTE), con máximo 2 ciclos y la tabla `id | afirmación | comando | esperado | obtenido | severidad | acción | commit | re-verificación`. **Un BLOQUEA en T1 a T4 obliga a hacer `git revert` del commit de despliegue antes del push**, y se declara.

### FASE L (última, obligatoria)

El LOG lleva:
- resumen, commits e invariantes;
- md5 de `docs/index.html` desplegado;
- forma de C4 aplicada (A o B) y si se usó la regla opcional de C5;
- salida literal de M0;
- dudas con pregunta cerrada y errores propios;
- bloque J de trece campos;
- privacidad (script de RUT con control plantado → vacío);
- verificación del archivo: `grep -c '^esperado:'` = `grep -c '^obtenido:'`, y `grep -c '^## J'` = 1.

Termina con el commit `docs(log): defectos de narrativa y UI a6` y el push según la autorización.

## 5. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J tal cual.
- **Después:**
  - por defecto, la medición antes → después (C1 a C6);
  - la forma de C4 y la regla opcional de C5;
  - el resultado de 🔒5, 🔒7, 🔒8 y 🔒9;
  - el hash del commit de despliegue, el md5 de `docs/index.html` y la salida del push;
  - la salida de M0 (`renv::status()`);
  - qué revisar en el sitio publicado una vez que GitHub Pages lo actualice: la narrativa de un establecimiento, la nota de cobertura, el modal a 390 px, el botón de territorio en un teléfono y "Limpiar" en el comparador;
  - "lo que falló o sorprendió; si nada, decirlo".
