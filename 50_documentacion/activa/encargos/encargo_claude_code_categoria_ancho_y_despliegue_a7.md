# Encargo autónomo: pestañas del modal y botón de territorio en pantallas angostas, y despliegue (a7)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (edición en serie de una misma fuente, un build, un despliegue y un push).
- **EJECUCIÓN:** esfuerzo `high`; orquestador el modelo de la sesión; subagentes 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_categoria_desempeno`, macOS.
- **INSUMOS (en disco):**
  - `30_procesamiento/33_app.jsx` y `30_procesamiento/33_motor_template.html`;
  - `00_run_all.R`, `tests/auditar_cifras.R` y `tests/spot_check_publicado.R`;
  - el LOG del a6 (`50_documentacion/andamios/logs/20260925_defectos_narrativa_ui_a6_log.md`): estados N1 a N6, instrumentos, mediciones de T2 (candidatos t2a y t2b) y receta de build con renv activo.
- **POSICIÓN:**
  - Rutas absolutas desde la raíz; ningún comando asume `cd`. `bash` explícito (bash 3.2); **nada de heredocs en zsh**: los scripts se escriben como archivos (lección de los errores 1 y 5 del a6).
  - `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`), con `*{transition:none!important;animation:none!important}` inyectado antes de medir.
  - Babel en `/tmp/cat_a7_babel`, copia de `/tmp/cat_a6_babel`.
  - Instrumentos en `/tmp/cat_a7_*`, copiados de `/tmp/cat_a6_*` y recalibrados, o reconstruidos con las recetas del LOG a6.
  - Toda corrida R arranca en la raíz, con `RENV_PROJECT` impreso (receta `/tmp/cat_a6_build.sh`).
  - Primer acto git: `fetch` y comparar `HEAD` con `origin/main`.
  - Ningún shell en segundo plano queda corriendo al terminar.
- **LOG:** `50_documentacion/andamios/logs/20260925_ancho_y_despliegue_a7_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): ancho y despliegue a7` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):**
  - (a) `run_all(only = 33)` con renv activo: exit 0 y 0 warnings.
  - (b) 0 errores de consola y 0 `pageerror` en los 19 estados y en N1 a N6 (más N5m y N5d).
  - (c) SHA-256 del payload normalizado (solo la fecha) = `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`.
  - (d) `tests/auditar_cifras.R` y `tests/spot_check_publicado.R` en verde con renv activo, corridos con `docs/index.html` del build nuevo.
- **Topes de esfuerzo:** 3 intentos por defecto; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria. Un push denegado no se reintenta por otra vía.
- **Reglas canónicas:**
  - Commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`.
  - El LOG no lleva RBD con número ni nombres de establecimiento (hash corto, como en el a6).
  - **El bloque de la app del template nunca se edita a mano:** el JSX va en `33_app.jsx` y llega al template solo por retranspilación completa. El CSS se edita en el template, solo en los selectores de §1.
  - **Ningún hex nuevo.**

## 1. Qué aprobó el titular (sesión 31 del chat, 2026-09-25)

Resoluciones a las dudas del a6:

- **Q-DEPLOY: Sí.** C1, C2, C3 y C6 (commits `3bc0c57` y `eabf8ad`) se despliegan en este encargo aunque C4 o C5 se congelen.
- **Q-C4: No** a la forma B. C4 se replantea con `flex-wrap`, que solo parte la fila cuando no cabe.
- **Q-C5: No** tal cual. Se conserva el candidato del a6 con la regla que la medición exigió, y el `gap` del botón baja a 4 px para devolver el ancho del espacio que había antes del ▾.
- **Q-CLAUDEMD: Sí**, se conserva (ignorado por git; no se toca).

Además, el registro de errores del asistente de la sesión 31 entra al repositorio en el primer commit, junto con este encargo.

| Id | Defecto | Cambio (lista cerrada) | Dónde |
|---|---|---|---|
| C4 | A 390 y 320 px la pestaña "Establecimiento" del modal queda cortada | Agregar, después de la regla `.modal-tab.is-active`, `@media (max-width: 560px) { .modal-tabs { padding: 0 16px; flex-wrap: wrap; } .modal-tab { margin-right: 16px; } }`. **Sin** `overflow` en ningún eje | template, CSS |
| C5 | A 320 px, con un nombre largo, el botón de territorio ocupa gran parte de la pantalla | JSX: `<button className="entity-select-btn" title={entity.nom} …><span className="entity-select-nom">{entity.nom}</span> ▾</button>` (igual al candidato del a6). CSS: en `.entity-select-btn`, `gap: 8px` → `gap: 4px` y se agrega `max-width: 100%; min-width: 0;`; regla nueva `.entity-select-nom { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; min-width: 0; }`; regla nueva `.controls-bar .control-group { min-width: 0; max-width: 100%; }` (la medición del a6 la exigió: sin ella, el botón desbordaba 652 px) | `33_app.jsx` + template, CSS |

**Cadenas de `textContent` que pueden cambiar frente a `docs/index.html` publicado (`788d5026…`), y ninguna otra:** las de C1, C2 y C3 declaradas en el a6 (§1 del encargo a6), con los conteos por estado que midió el a6 (FASE R, R.2). C4 y C5 no agregan ninguna cadena.

**Límites:** nada en el pipeline 30 a 32, en `33_generar_html.R`, en `34_*`, en `10_utils`, en `20_insumos` ni en `tests/`. En el CSS, solo los selectores de C4 y C5. No se toca `CLAUDE.md`.

## 2. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `099101a` (`docs(log): defectos de narrativa y UI a6`), 0/0 y 0 locks. Fuente: `git rev-parse`, `git rev-list --left-right --count` y `find .git -name '*.lock'`, sesión 31 del chat, tras el `fetch`.
- `docs/index.html` md5 `788d5026562a67a73af43abffd97034e`, es decir, el publicado sin C1 a C6. Fuente: `md5sum`, sesión 31.
- `33_app.jsx`:
  - contiene los comentarios `a6-C2` (~529) y `a6-C6` (~1520);
  - `entity-select-btn` con `{entity.nom} ▾` en la ~1980.
  - Fuente: `grep -n`, sesión 31.
- Template:
  - `.modal-tab.is-active` en la ~884;
  - `.entity-select-btn` con `display: inline-flex; align-items: center; gap: 8px;` (~1272).
  - Fuente: `grep -n` y `sed -n`, sesión 31.
- Mediciones de partida del a6 (fuente: LOG a6, M5 y T2):
  - "Establecimiento" termina en 391,3 px, contra el borde en 370 (390 px) y en 300 (320 px).
  - Con la forma A sola, a 390 cabe sin scroll y a 320 queda cortada.
  - El SLEP por defecto mide 145×36 a 320 px; con el `gap` de 8 px, el candidato lo recorta en unos 2 px.
- Archivos que el titular deja sin versionar antes de lanzar: este encargo y `50_documentacion/andamios/20260925_errores_asistente_sesion31.md`. Es hipótesis; verificar con `git status --porcelain` en M1.
- Candidato del a6 en `/tmp/cat_a6_t2_candidato.patch`, md5 `05904b58…`. Es hipótesis; verificar con `md5`. Si no existe, C5 se reconstruye desde §1, que es la fuente.

## 3. Invariantes 🔒

1. **Payload idéntico:** PRUEBAS c, antes y después del despliegue.
2. **Cifras intactas:** PRUEBAS d.
3. **Color:** 0 hex en las líneas agregadas (`git diff <inicio>..HEAD -U0 | grep '^+' | grep -ciE '#[0-9a-f]{3,8}\b'` → `0`).
4. **Pipeline y pruebas intactos:** `git diff <inicio>..HEAD -- 30_procesamiento/30_* 30_procesamiento/31_* 30_procesamiento/32_* 30_procesamiento/33_generar_html.R 30_procesamiento/34_* 20_insumos 10_utils tests | wc -l` → `0`.
5. **Despliegue fiel:** tras T3, md5 de `docs/index.html` = md5 de `40_salidas/motor_categoria.html` del mismo build.
6. **Fuente y transpilado no divergen:** bloque del template = retranspilación de `33_app.jsx` (cadena idéntica).
7. **Texto:** en T1 y T2, el `textContent` de `#root` en los 19 estados y en N1 a N6 es idéntico al del motor de `099101a` (sin cadenas nuevas). En T3, frente a `docs/index.html` publicado, solo cambian las cadenas de C1, C2 y C3 con los conteos del a6.
8. **Contraste sin regresión:** instrumento del a3 en los 19 estados más N4 y N5: 0 fallas de texto y 0 gráficas exigidas en controles activos.
9. **Orden temporal intacto:** toda `.traj` estrictamente ascendente con el anillo en el último año; toda `.ee-detail-list` estrictamente descendente con el vigente en el índice 0.

## 4. Tareas

Orden: FASE 0 → T1 (C4) → T2 (C5) → T3 despliegue → FASE R → FASE L. Un commit por tarea. **T3 corre siempre que FASE 0 haya pasado**: despliega lo que esté commiteado en verde (C1, C2, C3, C6, más C4 y C5 si sus tareas terminaron en verde).

### Regla de detención

1. Stash no vacío, o porcelain antes del primer commit fuera de {este encargo, el registro de errores, el LOG} → detén la sesión y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` → detén la sesión y pasa a FASE L.
3. M-DERIVA en falla → congela T1, T2 y T3.
4. PRUEBAS c o d en falla, o cualquier 🔒 en FALLA durante T1 o T2 → revierte a mano la edición de esa tarea (sin `checkout`), verifica `git diff HEAD` = 0 en las dos fuentes, congela la tarea y sigue con la siguiente; `git restore docs/index.html`.
5. Un criterio de T1 o T2 no alcanzado tras 3 intentos dentro de la lista cerrada, o un resultado visible no enumerado → misma acción que la regla 4, con la duda registrada como pregunta cerrada.
6. PRUEBAS c o d en falla durante T3 → `git restore docs/index.html`, T3 congelada, sin commit de despliegue.
7. Residual → congela ese ítem y regístralo como duda con pregunta cerrada. T3 sigue corriendo con lo que esté en verde.

### Autorizaciones (lista cerrada)

- FASE 0: `git add` y `git commit` de este encargo y del registro de errores (`chore(encargo): ancho y despliegue a7`).
- Copia de Babel e instrumentos en `/tmp/cat_a7_*`.
- `git commit` de T1 y de T2, cada uno tras su verificación. En T1 y T2, después de cada build: `git restore docs/index.html` y verificación del md5 `788d5026…`.
- En T3: `git add /Users/tomgc/Projects/slep_categoria_desempeno/docs/index.html` y `git commit` de despliegue, solo tras sus verificaciones.
- `git revert <hash>` de un commit propio, si FASE R lo exige; se declara.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más: ni `rm` (tampoco sobre `/tmp`: lo temporal se mueve con `mv` a `/tmp/cat_a7_basura/`), ni `reset`, `checkout --`, `rebase`, ni instalación de paquetes, ni operaciones de renv distintas de cargarlo.

### FASE 0 (cada medición con `esperado:` antes y `obtenido:` después)

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain antes y después del primer commit; stash; archivos del primer commit | antes: el encargo y el registro de errores; después: vacío o el LOG; stash vacío; commit = los dos archivos | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `099101a` = `origin/main`; 0; 1 | regla 2 |
| M3 | md5 de `docs/index.html`; SHA del payload normalizado, con calibración (fecha alterada → igual; una cifra plantada → distinto); PRUEBAS d | `788d5026…`; `d9895a78…0442`; calibración correcta; verde con renv activo | regla 4 |
| M-DERIVA | retranspilación de `33_app.jsx` frente al bloque del template | cadena idéntica | regla 3 |
| M4 | Build de `HEAD` (sin cambios) como línea base, en los 19 estados, N1 a N6, N5m y N5d: capturas, `textContent`, bloques de años, contraste; para C4, además, N4 a 360 y 375 px; con determinismo | igual entre corridas; motor md5 `6871dcb0…` (el del a6) | se registra |
| M5 | Reproducción en la línea base: C4 (pestañas a 320, 360, 375 y 390 px: borde derecho de cada `.modal-tab` contra el de `.modal-tabs`); C5 (N5 a 320 px: 9 líneas, barra 385 px; SLEP 145×36) | C4 cortada a 320, 360 y 375; a 390, cortada según el a6; C5 como en el a6 | se registra |

### T1: C4 (pestañas)

1. CSS de §1 en el template; build (PRUEBAS a), PRUEBAS c y d; `git restore docs/index.html` y md5.
2. Verificación (`esperado:` antes, con N4 a 320, 360, 375 y 390 px):
   - las 4 pestañas completas dentro de `.modal-tabs` en los cuatro anchos, con `scrollWidth` ≤ `clientWidth` y `scrollHeight` ≤ `clientHeight` en `.modal-tabs`;
   - `overflow-x` y `overflow-y` computados `visible`;
   - a 390, una sola fila (todas las pestañas con el mismo `top`); a 320, la cantidad de filas informada;
   - el subrayado de la pestaña activa completo (2 px de `--ocean`, por captura 2×) en las cuatro pestañas activadas una por una;
   - clic en cada pestaña cambia la pestaña activa;
   - a 1280, las capturas de los 19 estados idénticas a la base (el modal está cerrado).
   - Además: 🔒7 (sin cadenas nuevas), 🔒8 en N4 y 🔒1 a 🔒6.
3. Commit `fix(motor): las pestañas del modal pasan a una segunda fila cuando no caben (a7 T1)`.

### T2: C5 (botón de territorio)

1. JSX y CSS de §1; retranspilar; build, PRUEBAS c y d, `git restore docs/index.html` y md5.
2. Verificación (`esperado:` antes):
   - N5 a 320 px: el botón en una sola línea, su borde derecho dentro del viewport y `.controls-bar` a lo más tan alta como con el SLEP.
   - El `title` es igual al nombre completo.
   - El SLEP por defecto a 320, 360, 375, 390 y 1280 px sin recorte: `scrollWidth` ≤ `clientWidth` en `.entity-select-nom` y sin puntos suspensivos por captura.
   - Ancho del botón con el SLEP a 1280 dentro de ±1 px de la base (145 px), y posición del ▾ dentro de ±1 px de la base.
   - Desborde horizontal de `#root` 0 a 320, 390 y 1280.
   - Además: 🔒7 (sin cadenas nuevas), 🔒8 en N5 y 🔒1 a 🔒6.
3. Commit `fix(motor): el botón de territorio recorta nombres largos sin desbordar la barra (a7 T2)`.

### T3: despliegue

1. Build con PRUEBAS a; `docs/index.html` queda con el build nuevo (**no** se restaura).
2. Verificación (`esperado:` antes):
   - PRUEBAS c sobre `docs/index.html` = `d9895a78…0442`; PRUEBAS d en verde; 🔒5.
   - En `docs/index.html` por `file://`: 0 errores; 🔒7 de T3 (frente al publicado, solo C1 a C3 con los conteos del a6); C6 (foco en `BUTTON.cmp-add-btn` tras clic y tras Enter en "Limpiar"); las verificaciones de T1 y T2 que hayan quedado commiteadas; 🔒9.
   - `git status --short` = `M docs/index.html`.
3. Commit `deploy(motor): publica narrativa, foco y ancho corregidos (a6 y a7)`. Si C4 o C5 quedaron congelados, el mensaje nombra solo lo publicado.

### FASE R (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio. El inventario `R-01…` se anexa antes de auditar. Cada afirmación se re-deriva por un camino distinto (píxeles si antes fue por rectángulos, `innerText` si antes fue `textContent`, `focusin` si antes fue `activeElement`, SHA desde `git show <hash>:docs/index.html` y en Python). Se incluyen:
- el comando de cada 🔒 con su salida literal;
- el alcance global: `git diff --name-only <inicio>..HEAD` → `33_app.jsx`, el template, `docs/index.html` y el LOG;
- la regresión PRUEBAS a a d;
- el control positivo: `docs/index.html` de `<inicio>` reproduce C1 a C6.

Cada hallazgo lleva veredicto (BLOQUEA / REPARA / ADVIERTE), con máximo 2 ciclos. **Un BLOQUEA en T1 a T3 obliga a hacer `git revert` del commit de despliegue antes del push**, y se declara.

### FASE L (última, obligatoria)

El LOG lleva:
- resumen, commits, invariantes y md5 de `docs/index.html` desplegado;
- filas por pestaña de C4 en cada ancho, y ancho del botón y posición del ▾ de C5;
- dudas con pregunta cerrada y errores propios;
- bloque J de trece campos;
- privacidad (script de RUT con control plantado → vacío);
- verificación del archivo: `grep -c '^esperado:'` = `grep -c '^obtenido:'`, y `grep -c '^## J'` = 1.

Termina con el commit `docs(log): ancho y despliegue a7` y el push según la autorización.

## 5. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J tal cual.
- **Después:**
  - por defecto (C4, C5), la medición antes → después;
  - qué quedó publicado (C1 a C6, o cuáles);
  - el resultado de 🔒5, 🔒7, 🔒8 y 🔒9;
  - el hash del commit de despliegue, el md5 de `docs/index.html` y la salida del push;
  - qué revisar en el sitio publicado una vez que GitHub Pages lo actualice: la narrativa de un establecimiento, la nota de cobertura, "Limpiar" en el comparador, el modal en un teléfono y el botón de territorio con un nombre largo;
  - "lo que falló o sorprendió; si nada, decirlo".
