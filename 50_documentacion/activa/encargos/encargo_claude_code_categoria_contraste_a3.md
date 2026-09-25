# Encargo autónomo: contraste figura-fondo completo del motor (a3)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (edición en serie de una misma fuente, un build y un push; `encargo_autonomo_claude_code_v1.md` §2.12, fila 5).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_categoria_desempeno`, macOS.
- **INSUMOS (en disco):** `50_documentacion/andamios/20260925_auditoria_contraste_motor.md` (**fuente de verdad**: §3 y §4 las fallas con sus valores, §5 los cambios P1 a P11); `50_documentacion/andamios/20260925_cabeceras_variante.png` (maqueta aprobada de las cabeceras, P11); `30_procesamiento/33_app.jsx`; `30_procesamiento/33_motor_template.html`; `30_procesamiento/33_generar_html.R`; `00_run_all.R`; `tests/auditar_cifras.R`; `tests/spot_check_publicado.R`; `50_documentacion/activa/decisiones/20260612_decision_paleta_categorias.md` y `20260925_decision_contraste_texto_categorias.md`; el LOG del a2 (`50_documentacion/andamios/logs/20260925_alineamiento_motores_a2_log.md`: recetas de build, retranspilación, payload y capturas).
- **POSICIÓN:** rutas absolutas desde la raíz; ningún comando asume `cd`. `bash` explícito (bash 3.2). `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`). Babel solo como herramienta de desarrollo, en `/tmp/cat_a3_babel` (puede copiarse de `/tmp/cat_a2_babel` si existe), receta de la cabecera de `33_app.jsx`. Instrumentos en `/tmp/cat_a3_*`; los de `/tmp/cat_a2_*` pueden copiarse y se recalibran antes de usarlos. **Antes de medir, desactivar transiciones y animaciones** inyectando `*,*::before,*::after{transition:none!important;animation:none!important}`: con transiciones activas se miden colores intermedios (así ocurrió en la auditoría). Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Ningún shell en segundo plano queda corriendo al terminar. `renv` activo en toda corrida R.
- **LOG:** `50_documentacion/andamios/logs/20260925_contraste_a3_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): contraste del motor a3` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_categoria_desempeno"); source("00_run_all.R"); run_all(only = 33)'` con exit 0 y 0 warnings; (b) 0 errores de consola y 0 `pageerror` en los 19 estados de §5 (M5); (c) **payload intacto salvo la paleta:** SHA-256 del JSON embebido, descomprimido, con `fecha_generacion` normalizada **y con `meta.cat_colors` restituido a los valores anteriores** (`INSUFICIENTE` `#EE2D49`, `MEDIO-BAJO` `#E88663`) = `0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8`; además, `meta.cat_colors` del build nuevo = `{"INSUFICIENTE":"#D0112D","MEDIO-BAJO":"#E05D2F","MEDIO":"#2A8FD9","ALTO":"#0062A0"}`; (d) `tests/auditar_cifras.R` y `tests/spot_check_publicado.R` en verde, corridos con `docs/index.html` del build nuevo y antes de restaurarlo.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria. Un push denegado no se reintenta por otra vía.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`; en código R, `here::here()`; el LOG no lleva RBD con número ni nombres de establecimiento. **El bloque de la app del template nunca se edita a mano:** la lógica y el JSX se editan en `33_app.jsx` y llegan al template solo por retranspilación completa, que reemplaza el bloque entero. El CSS sí se edita en el template. **Colores:** los únicos hex nuevos admitidos son los nueve de la lista cerrada de §1; cualquier otro es FALLA de 🔒3.

## 1. Qué aprobó el titular (sesión 30 del chat, 2026-09-25)

**Opción A de la auditoría (P1 a P10) más la variante P11.** Lista cerrada de cambios:

| Id | Cambio | Archivo |
|---|---|---|
| P1 | `--fg-3: var(--slate);` → `--fg-3: #5E5E5E;` (`--slate` no cambia) | template, `:root` |
| P2 | `--border-2: var(--line-strong);` → `--border-2: #8A7F68;` (`--line-strong` no cambia). Luego, cada uso de `var(--border-2)` se clasifica: si el elemento vivo es un control (campo, casilla, botón, selector), se queda con `--border-2`; si es una línea decorativa viva (regla de tabla, separador), pasa a `var(--line-strong)` para conservar su aspecto; si pertenece al CSS muerto heredado (pendiente #2 del traspaso v29, sin referencia en `33_app.jsx`), **no se toca**. Las tres reglas de "sin categoría" (`.traj-mark.is-si`, `.traj-legend-sw.is-si`, `.ee-detail-mark[data-si="1"]`), que hoy usan `var(--line-strong)` directo, pasan a `var(--border-2)` | template |
| P3 | Variable nueva `--fg-on-dark-muted: #A9B7BB;` en `:root`. `.brand-eyebrow-muted` y `.brand-divider` usan ese color con `opacity: 1` | template |
| P4 | `CAT_COLORS$INSUFICIENTE`: `#EE2D49` → `#D0112D`. Variable nueva `--cat-insuf: #D0112D;` en `:root` (hoy solo existe como respaldo `var(--cat-insuf, #EE2D49)`; los respaldos se actualizan a `#D0112D`) | `33_generar_html.R` (solo el bloque `CAT_COLORS` y su comentario) y template |
| P5 | `CAT_COLORS$MEDIO-BAJO`: `#E88663` → `#E05D2F` | `33_generar_html.R` (mismo bloque) |
| P6 | Sin opacidad en `.cat-col-stat` y `.cat-col-mat` | template |
| P7 | Delta negativo y ✕ del chip al pasar el cursor: quedan en el rojo nuevo por P4 (sin cambio propio; se verifica) | template |
| P8 | `.cmp-cell.is-max .cmp-cell-pct { color: var(--ink); font-weight: var(--fw-heavy); }` y `.cmp-cell.is-max { outline: 2px solid var(--ink); outline-offset: -2px; }` | template |
| P9 | `.segmented-btn.is-active { background: var(--ocean); color: var(--paper); }`, más `.segmented-btn.is-active:hover { color: var(--paper); }` | template |
| P10 | Borde del botón secundario `.estab-popup-btn` ("Cancelar"): `var(--border-1)` → `var(--border-2)`; el primario conserva su borde `--ocean` | template |
| P11 | Cabeceras de columna con tono oscuro propio y **texto blanco en las cuatro**. Variables nuevas en `:root`: `--cat-insuf-cab: #B30F27; --cat-mbajo-cab: #C1481D; --cat-medio-cab: #2074B2; --cat-alto-cab: #004976;`. En `CatColumn` (`33_app.jsx`) el fondo de `.cat-col-head` sale de un mapa categoría → variable (`"var(--cat-insuf-cab)"`, etc.) y no de `CatData.CAT_COLORS`. Se retiran `CAT_CABECERA_TINTA`, la clase `is-tinta` y las dos reglas `.cat-col-head.is-tinta` del template. Las marcas, la leyenda, los puntos del comparador y el mapa de calor siguen leyendo `CAT_COLORS` | `33_app.jsx` y template |

**Lista cerrada de hex nuevos (🔒3):** `#5E5E5E`, `#8A7F68`, `#A9B7BB`, `#D0112D`, `#E05D2F`, `#B30F27`, `#C1481D`, `#2074B2`, `#004976`.

**Límites:** nada que cambie una cifra ni otra parte del payload que `meta.cat_colors`; nada en el pipeline 30 a 32, en `34_*`, en `10_utils`, en `20_insumos` ni en `tests/`; en `33_generar_html.R`, solo el bloque `CAT_COLORS` y su comentario; ningún texto visible cambia; el CSS muerto no se toca; `docs/` no se despliega.

## 2. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `2238930` (fuente: `git log --oneline -1`, sesión 30 del chat).
- `git status --porcelain` = `?? 40_salidas/categoria_rbd_contrato.parquet` (preexistente; no se toca), `?? 50_documentacion/andamios/20260925_auditoria_contraste_motor.md`, `?? 50_documentacion/andamios/20260925_cabeceras_variante.png` y este encargo (fuente: `git status --short`, sesión 30 del chat).
- md5: motor `40_salidas/motor_categoria.html` `91570b620f1de44ea84ca7c7ae33f8bc` (build del a2); `docs/index.html` `45e612f1c9909a2dd1115d9e8628cde0` (fuente: LOG a2, T4, y md5 del motor auditado en la sesión 30).
- Template: `--fg-3: var(--slate);` y `--border-2: var(--line-strong);` en `:root`; `.brand-eyebrow-muted { opacity: 0.55; … }`; `.brand-divider { color: var(--cream); opacity: 0.35; … }`; `.cat-col-stat` opacidad 0.92 y `.cat-col-mat` 0.82; `.cat-col-head.is-tinta` y su regla hija; respaldos `var(--cat-insuf, #EE2D49)` en el delta negativo y en la ✕ del chip; `.estab-popup-btn` con `border: 1px solid var(--border-1)`; 20 usos de `var(--border-2)`, uno de ellos en línea en `33_app.jsx` (el campo de búsqueda) (fuente: `grep -n` sobre ambos archivos, sesión 30 del chat).
- `33_app.jsx`: `const CAT_CABECERA_TINTA = new Set(["INSUFICIENTE", "MEDIO-BAJO", "MEDIO"]);` y su uso en `CatColumn` (fuente: `grep -n`, sesión 30 del chat).
- `33_generar_html.R`: bloque `CAT_COLORS <- list(...)` con `#EE2D49`, `#E88663`, `#2A8FD9`, `#0062A0` (fuente: `sed`, sesión 30 del chat).
- Los hex viejos aparecen también en documentos (decisiones, traspasos, suite, andamios); **no se tocan**, salvo la línea `Estado:` de las dos decisiones de §6 T3 (fuente: `grep -rIl`, sesión 30 del chat).

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto salvo la paleta:** PRUEBAS c.
2. **Cifras intactas:** PRUEBAS d.
3. **Solo los hex aprobados:** el conjunto de hex en líneas agregadas del diff `-U0 <inicio>..HEAD` de template, `33_app.jsx` y `33_generar_html.R` está contenido en la lista cerrada de §1; en `:root` solo cambian o se agregan `--fg-3`, `--border-2`, `--fg-on-dark-muted`, `--cat-insuf` y las cuatro `--cat-*-cab`.
4. **Pipeline y pruebas intactos:** `git diff <inicio>..HEAD -- 30_procesamiento/30_* 30_procesamiento/31_* 30_procesamiento/32_* 30_procesamiento/34_* 20_insumos 10_utils tests | wc -l` → `0`; `git diff -U0 <inicio>..HEAD -- 30_procesamiento/33_generar_html.R` toca solo líneas del bloque `CAT_COLORS`.
5. **`docs/` publicado intacto:** al cerrar, md5 `45e612f1…` y `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **Fuente y transpilado no divergen:** bloque del template = retranspilación de `33_app.jsx` (cadena idéntica).
7. **Ningún texto cambia:** `textContent` de `#root` idéntico al de la línea base en los 19 estados (el cambio es solo de color, borde y opacidad). Las capturas sí cambian.

## 4. Grafo de tareas y ALCANCE

- **T1** (P1, P2, P3, P6, P8, P9, P10: solo CSS) · ALCANCE: template.
- **T2** (P4, P5, P7: paleta) · ALCANCE: `33_generar_html.R` (bloque `CAT_COLORS`) y template (`:root` y respaldos `--cat-insuf`).
- **T3** (P11: cabeceras) · ALCANCE: `33_app.jsx` y template.
- **T4** (documentos) · ALCANCE: decisión nueva `50_documentacion/activa/decisiones/20260925_decision_paleta_categorias_v2.md`; **solo la línea `Estado:`** de `20260612_decision_paleta_categorias.md` y de `20260925_decision_contraste_texto_categorias.md`; anexo `## 9. Implementación (a3)` al final de la auditoría (§1 a §8 no se reescriben). Corre siempre.
- **T5** (build final y verificación) · ALCANCE: ninguna ruta versionada.
- Orden: T1 → T2 → T3 → T4 → T5. **FASE R** y **FASE L** corren siempre.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, el parquet preexistente, la auditoría, la maqueta PNG, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` → detén la sesión y pasa a FASE L.
3. M-DERIVA en falla (el bloque del template no es la retranspilación de `33_app.jsx`) → congela T3 y T5; T1, T2 y T4 siguen.
4. PRUEBAS c o d fallan en cualquier build → congela la tarea en curso y las siguientes que dependan de ella.
5. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
6. Un cambio que exige tocar fuera del ALCANCE o un hex fuera de la lista cerrada → ese ítem pasa a duda; la tarea sigue con los demás.
7. **Residual:** cualquier estado, conteo o resultado no enumerado → congela ESE ítem, regístralo como duda (contexto, pregunta cerrada y qué quedó bloqueado) y sigue con lo independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo, la auditoría y la maqueta PNG (`chore(encargo): contraste del motor a3`).
- `npm install` en `/tmp/cat_a3_babel` de `@babel/cli`, `@babel/core` y `@babel/preset-react`, o copia de `/tmp/cat_a2_babel`.
- `git commit` de T1, T2, T3 y T4, cada uno tras su verificación.
- Después de **cada** build: `git restore docs/index.html` y verificación del md5 `45e612f1…`.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` = `?? 40_salidas/categoria_rbd_contrato.parquet` y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/cat_a3_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular ni `rm`, `reset`, `checkout --`, `rebase`, ni commit de `docs/index.html`, ni `npx` de herramientas no listadas, ni `renv::restore()` o instalación de paquetes R.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit autorizado. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` escrito **antes** de su comando y `obtenido:` literal después.

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash; archivos del primer commit | el parquet y el LOG; vacío; encargo, auditoría y PNG | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `2238930` = `origin/main`; 0; 1 | regla 2 |
| M3 | md5 de §2; SHA del payload normalizado con el instrumento recalibrado (fecha alterada → igual; una cifra plantada → distinto; **`cat_colors` alterado → igual tras restituir**, que es la calibración nueva de PRUEBAS c); PRUEBAS d | los de §2; `0ffd9899…2ad8`; calibración correcta; verde | regla 4 |
| M-DERIVA | retranspilar `33_app.jsx` y comparar con el bloque del template | cadena idéntica (así quedó en el a2) | regla 3 |
| M5 | **Contraste de línea base** con el instrumento de §7, en los 19 estados de abajo, sobre el motor actual (`91570b62…` o un build de las fuentes en `<inicio>`) | los valores de la auditoría §2 a §4: 19 pares de texto fallidos en controles activos (2.103 mediciones de 13.725) y los grupos gráficos G1 a G5 fallidos | si difiere, se registra y la verificación usa el valor nuevo; si el instrumento no reproduce la auditoría en al menos T1, T7, T10, G1 y G3, se corrige el instrumento antes de seguir (sin tocar el criterio) |
| M6 | Capturas y `textContent` de `#root` de línea base en los 19 estados, a 1280 × 900, con determinismo (dos corridas) | 19/19 texto igual entre corridas | — |

**Los 19 estados** (los mismos de la auditoría): S01 apertura básica; S02 primer chip de comuna apagado; S02b cursor sobre el segundo chip; S03 detalle de un establecimiento con delta de matrícula negativo (recorrer las tarjetas hasta hallar `.ee-detail-evol-delta.is-down`); S04 S03 con las notas metodológicas abiertas; S05 apertura media; S06 modal simple, pestaña Comuna; S06b cursor sobre una fila; S07 pestaña SLEP; S08 pestaña Región; S09 pestaña Establecimiento con búsqueda "liceo"; S10 narrativa con el primer establecimiento de esa búsqueda; S11 comuna con "sin categoría" (búsqueda "alhu"); S12 comparador vacío; S13 modal múltiple abierto; S14 modal múltiple, pestaña SLEP, 10 filas marcadas (tope); S15 comparador con esos 10 territorios; S15b cursor sobre la ✕ del primer chip; S16 S15 en media.

## 6. Tareas

### T1: CSS (P1, P2, P3, P6, P8, P9, P10)

1. Aplicar los cambios de §1 en el template. Para P2, escribir en el LOG, **antes de editar**, la tabla de los 20 usos de `var(--border-2)` con su clasificación (control vivo / decorativo vivo / muerto) y la evidencia (clase buscada en `33_app.jsx`).
2. Build (PRUEBAS a), luego PRUEBAS c; `git restore docs/index.html`.
3. Verificación (`esperado:` antes) con el instrumento de §7: T1 a T6 y T10 de la auditoría resueltos con los valores de su tabla (6,02; 5,36; 4,99; 6,48; 5,74; 5,74; 5,47 a 8,38) y G2 a G6 (3,95; 3,95; 3,82; 5,34; 3,67 a 3,95); 🔒3, 🔒6, 🔒7.
4. Commit `style(motor): contraste de texto y controles (a3 T1: P1, P2, P3, P6, P8, P9, P10)`.

### T2: paleta (P4, P5, P7)

1. `33_generar_html.R`: los dos hex del bloque `CAT_COLORS` y su comentario (que diga que la paleta se recalibró por contraste el 2026-09-25 y cite la decisión nueva). Template: `--cat-insuf: #D0112D;` en `:root` y respaldos actualizados.
2. Build, PRUEBAS c (con la restitución de `cat_colors`) y d; `git restore docs/index.html`.
3. Verificación: G1 con Insuficiente 5,53 y Medio-Bajo 3,64 sobre blanco y 3,38 sobre crema; T8 5,34; T9 5,53; texto de las celdas del mapa de calor sin fallas; 🔒1, 🔒2, 🔒3, 🔒4, 🔒7.
4. Commit `style(motor): recalibra Insuficiente y Medio-Bajo por contraste (a3 T2: P4, P5, P7)`.

### T3: cabeceras (P11)

1. `33_app.jsx`: mapa categoría → variable de cabecera en `CatColumn`; retirar `CAT_CABECERA_TINTA` y la clase `is-tinta`. Template: las cuatro variables `--cat-*-cab` en `:root` y retiro de las reglas `.cat-col-head.is-tinta`. Retranspilar y reemplazar el bloque entero.
2. Build, PRUEBAS c y d; `git restore docs/index.html`.
3. Verificación: texto de las cuatro cabeceras (título, conteo, matrícula) en blanco con 6,97 / 4,99 / 5,00 / 9,48; en básica y en media; `grep -c "is-tinta\|CAT_CABECERA_TINTA"` = 0 en `33_app.jsx` y en el template; captura de las cabeceras comparada visualmente con la maqueta aprobada (misma disposición y colores); 🔒3, 🔒6 (cadena idéntica), 🔒7.
4. Commit `style(motor): cabeceras oscuras con texto blanco (a3 T3: P11)`.

### T4: documentos

1. `50_documentacion/activa/decisiones/20260925_decision_paleta_categorias_v2.md`, en el formato del directorio: contexto (auditoría del 2026-09-25, valores de §3 y §4); decisión (tabla de la paleta nueva: color de marca y color de cabecera por categoría, con su contraste; las variables de texto y borde P1 a P3); qué reemplaza (los dos hex de `20260612_decision_paleta_categorias.md` y la excepción de `20260925_decision_contraste_texto_categorias.md`, que desaparece); qué conserva (el orden rojo → azul, Medio y Alto sin cambio, `CAT_COLORS` como fuente única de las marcas); alternativas consideradas (opción B sin paleta; oscurecer toda la paleta y no solo las cabeceras, descartada por el mapa de calor y la distinción entre marcas, auditoría §5); implicancia (el payload cambia en `meta.cat_colors`; las cifras no).
2. En las dos decisiones anteriores, **solo** la línea `**Estado:** vigente` → `**Estado:** reemplazada por 20260925_decision_paleta_categorias_v2.md` (en la de contraste, "reemplazada en su excepción por …"). Ninguna otra línea.
3. Auditoría: anexar `## 9. Implementación (a3)` con los valores medidos después, por falla (T1 a T10, G1 a G6), y los commits.
4. Verificación: `git diff --numstat` de las decisiones anteriores = 1 agregada y 1 quitada cada una; auditoría con 0 líneas quitadas; privacidad 0/0/0.
5. Commit `docs(contraste): decisión de paleta v2 y cierre de la auditoría (a3 T4)`.

### T5: build final y verificación

1. Build con PRUEBAS a; PRUEBAS c y d; `git restore docs/index.html` y md5 = `45e612f1…`.
2. **Auditoría completa repetida** con el instrumento de §7 en los 19 estados: **0 pares de texto fallidos en controles activos** y **0 fallas no textuales exigidas**; las únicas fallas admitidas son las 4 de controles deshabilitados de la auditoría (filas bloqueadas al tope y botones "Agregar" sin selección).
3. md5 del motor nuevo; capturas antes y después de S01, S03, S05, S06, S14 y S15 en `/tmp/cat_a3_gate/`.

## 7. Instrumento de contraste (se copia tal cual a `/tmp/cat_a3_contraste.js`)

Función que se evalúa en la página (`page.evaluate(fn, nombreEstado)`) y devuelve una fila por texto visible y por gráfico o control. Compone fondos y opacidades de toda la cadena de ancestros. Texto: umbral 4,5 (3 si ≥ 24 px, o ≥ 18,66 px con peso ≥ 700). No textual: 3, sobre relleno o borde, lo mayor. **Clasificación de lo no textual (criterio de la auditoría §1):** se exige en las marcas de categoría (`.traj-mark`, `.traj-legend-sw`, `.cmp-cat-dot`, `.ee-detail-mark`), en `.input-search`, en `.check-box` y en el estado activo de `.segmented-btn`; se informa sin exigir en los botones con texto, los contenedores decorativos y las celdas del mapa de calor (`.cmp-cell-heat`, que llevan su valor escrito). Deshabilitados: filas `.check-row.is-disabled` y botones `:disabled`, exentos. Este criterio no se modifica durante el encargo.

```js
(stateName) => {
  function parse(c){ if(!c) return null; const m=c.match(/rgba?\(([^)]+)\)/); if(!m) return null; const p=m[1].split(/[ ,\/]+/).filter(Boolean).map(Number); return {r:p[0],g:p[1],b:p[2],a:p.length>3?p[3]:1}; }
  function over(f,b){ const a=f.a; return {r:f.r*a+b.r*(1-a), g:f.g*a+b.g*(1-a), b:f.b*a+b.b*(1-a), a:1}; }
  function mix(top,bot,o){ return {r:top.r*o+bot.r*(1-o),g:top.g*o+bot.g*(1-o),b:top.b*o+bot.b*(1-o),a:1}; }
  function lum(c){ const f=v=>{v/=255;return v<=0.03928?v/12.92:Math.pow((v+0.055)/1.055,2.4)}; return 0.2126*f(c.r)+0.7152*f(c.g)+0.0722*f(c.b); }
  function cr(a,b){ const l1=lum(a),l2=lum(b); return (Math.max(l1,l2)+0.05)/(Math.min(l1,l2)+0.05); }
  function hex(c){ return '#'+[c.r,c.g,c.b].map(v=>Math.round(v).toString(16).padStart(2,'0')).join('').toUpperCase(); }
  function visible(el){ const r=el.getBoundingClientRect(); if(r.width<1||r.height<1) return false; let n=el; while(n&&n.nodeType===1){ const s=getComputedStyle(n); if(s.display==='none'||s.visibility==='hidden'||parseFloat(s.opacity)===0) return false; n=n.parentElement;} return true; }
  // effective background under element (and flags)
  function bgInfo(el){
    const chain=[]; let n=el; while(n&&n.nodeType===1){chain.unshift(n); n=n.parentElement;}
    let c={r:255,g:255,b:255,a:1}; const ops=[]; let grad=false; let img=false;
    for(const node of chain){ const s=getComputedStyle(node); const o=parseFloat(s.opacity);
      if(o<1) ops.push({backdrop:c,o});
      const bc=parse(s.backgroundColor); if(bc&&bc.a>0) c=over(bc,c);
      if(s.backgroundImage&&s.backgroundImage!=='none'){ if(/gradient/.test(s.backgroundImage)) grad=true; else img=true; }
    }
    return {c,ops,grad,img};
  }
  function applyOps(col,ops){ for(let i=ops.length-1;i>=0;i--) col=mix(col,ops[i].backdrop,ops[i].o); return col; }
  function label(el){ const cls=(el.className&&el.className.baseVal!==undefined)?el.className.baseVal:(el.className||''); return el.tagName.toLowerCase()+(cls?'.'+String(cls).trim().split(/\s+/).join('.'):''); }
  const out=[];
  // TEXT
  const walker=document.createTreeWalker(document.body,NodeFilter.SHOW_TEXT);
  const seen=new Set();
  while(walker.nextNode()){ const t=walker.currentNode; const txt=t.nodeValue.replace(/\s+/g,' ').trim(); if(!txt) continue; const el=t.parentElement; if(!el||['SCRIPT','STYLE','NOSCRIPT'].includes(el.tagName)) continue; if(!visible(el)) continue;
    const s=getComputedStyle(el); const fg=parse(s.color); const fs=parseFloat(s.fontSize); const fw=parseInt(s.fontWeight)||400;
    const bi=bgInfo(el); let bg=applyOps(bi.c,bi.ops); let f=over(fg,bi.c); f=applyOps(f,bi.ops);
    const large= fs>=24 || (fs>=18.66 && fw>=700);
    const req= large?3:4.5; const ratio=cr(f,bg);
    const key=label(el)+'|'+hex(f)+'|'+hex(bg)+'|'+fs+'|'+fw;
    out.push({state:stateName,kind:'texto',sel:label(el),text:txt.slice(0,60),fs,fw,fg:hex(f),bg:hex(bg),ratio:Math.round(ratio*100)/100,req,pass:ratio>=req,grad:bi.grad||bi.img,key});
  }
  // NON-TEXT: graphics and UI components
  const gsel='.check-box,.traj-mark,.traj-legend-sw,.cat-col-bar,.cat-col-bar-fill,.filter-chip,.segmented,.segmented-btn,.entity-select-btn,.notes-toggle,input,select,button,[role=button],[role=checkbox],.check-row input,[class*=heat],[class*=cmp-cell],[class*=bar],[class*=swatch],[class*=chip],[class*=mark],[class*=dot],svg rect,svg circle,svg path';
  document.querySelectorAll(gsel).forEach(el=>{ if(!visible(el)) return; const s=getComputedStyle(el);
    const parentBi=bgInfo(el.parentElement); const pbg=applyOps(parentBi.c,parentBi.ops);
    let fill=null; const bc=parse(s.backgroundColor); if(bc&&bc.a>0){ fill=applyOps(over(bc,parentBi.c),parentBi.ops); }
    if(el instanceof SVGElement){ const fc=parse(s.fill); if(fc&&fc.a>0&&s.fill!=='none'){ fill=applyOps(over({...fc,a:fc.a*(parseFloat(s.fillOpacity)||1)},parentBi.c),parentBi.ops);} }
    let border=null; const bw=parseFloat(s.borderTopWidth)||0; const bcol=parse(s.borderTopColor); if(bw>0&&s.borderTopStyle!=='none'&&bcol&&bcol.a>0) border=applyOps(over(bcol,parentBi.c),parentBi.ops);
    const rf= fill? cr(fill,pbg):null; const rb= border? cr(border,pbg):null;
    const best=Math.max(rf||0,rb||0);
    out.push({state:stateName,kind:'grafico',sel:label(el),text:(el.innerText||el.getAttribute('aria-label')||el.getAttribute('title')||'').replace(/\s+/g,' ').slice(0,40),fill:fill?hex(fill):null,border:border?hex(border):null,bg:hex(pbg),rFill:rf&&Math.round(rf*100)/100,rBorder:rb&&Math.round(rb*100)/100,ratio:Math.round(best*100)/100,req:3,pass:best>=3,key:label(el)+'|'+(fill?hex(fill):'')+'|'+(border?hex(border):'')+'|'+hex(pbg)});
  });
  return out;
}
```

## 8. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta.

1. **Inventario** derivado del LOG: cada cambio P1 a P11, cada falla T1 a T10 y G1 a G6, cada 🔒, M3, M-DERIVA y el alcance. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** contraste de cada falla corregida por un camino distinto (color computado leído por `getComputedStyle` y calculado con la fórmula WCAG en un script aparte, o muestreo de píxeles de la captura en el centro del texto y en su fondo); y una lectura del diff buscando cualquier hex, opacidad o selector cambiado que no esté en §1.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD`; `git status --porcelain`.
5. **Regresión completa:** PRUEBAS a a d.
6. **Control positivo:** el motor del a2 (`91570b62…`) sigue mostrando las fallas de M5 con el mismo instrumento.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, cifra alterada: no se repara); **REPARA** (defecto propio dentro del ALCANCE); **ADVIERTE** (sin efecto sobre la meta). "0 hallazgos" solo junto al control positivo.
8. **Ciclo de reparación (máximo 2)**, con commit `fix(auditoria): R-NN …`, rebuild y restauración de `docs/index.html`.
9. **Prohibido:** ajustar criterio, umbral o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita; reclasificar un elemento de "exigido" a "informado" para que pase.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto.

## 9. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → el parquet preexistente y el LOG. Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits; tabla por falla (antes → después); auditoría; invariantes; md5 del motor nuevo; dudas con pregunta cerrada; errores propios; estado de cierre.
3. Bloque J: trece campos, una línea cada uno (meta y resultado; estado por tarea; commits; auditoría; invariantes; cifras críticas; decisiones autónomas de mayor riesgo; desviaciones; dudas abiertas; errores propios; qué debe verificar el revisor; no publicado / queda al usuario; ejecución).
4. Privacidad: grep de RUT con script (`/tmp/cat_a3_priv.sh`, con control plantado) → vacío en el LOG, la decisión nueva y el anexo de la auditoría.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): contraste del motor a3"`; luego el push según la autorización.

## 10. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: tabla por falla (`id | antes | después | commit`); la clasificación de los 20 usos de `--border-2`; salida del push; md5 del motor nuevo; lo que queda al titular para la revisión en pantalla (abrir `40_salidas/motor_categoria.html`: cabeceras en básica y media, trayectorias con Medio-Bajo y "sin categoría", el comparador con 10 territorios, los selectores de Vista y Nivel, el modal múltiple con casillas); "lo que falló o sorprendió; si nada, decirlo".
