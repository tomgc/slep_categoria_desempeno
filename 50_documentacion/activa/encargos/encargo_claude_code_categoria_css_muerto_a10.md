# Encargo autónomo: limpieza del CSS muerto del motor, y despliegue (a10)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten.**
- **EJECUCIÓN:** esfuerzo `high`; orquestador el modelo de la sesión; subagentes 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_categoria_desempeno`, macOS.
- **INSUMOS (en disco):**
  - `30_procesamiento/33_motor_template.html` (el CSS va en el bloque `<style>`, líneas 8 a 1535);
  - `30_procesamiento/33_app.jsx`;
  - `30_procesamiento/33_generar_html.R`;
  - `00_run_all.R`, `tests/auditar_cifras.R` y `tests/spot_check_publicado.R`;
  - el LOG del a8 (`50_documentacion/andamios/logs/20260925_pestanas_modal_a8_log.md`), con los 19 estados, los 11 estados N, los instrumentos y la receta de build con renv activo.
- **POSICIÓN:**
  - Rutas absolutas desde la raíz; ningún comando asume `cd`.
  - `bash` explícito; scripts en archivo, sin heredocs en zsh y sin `node -e` ni `Rscript -e` de varios pasos.
  - Puppeteer y Chrome del sistema como en el a8, con transiciones y animaciones desactivadas antes de medir.
  - Instrumentos en `/tmp/cat_a10_*`, copiados de `/tmp/cat_a8_*`.
  - Toda corrida R arranca en la raíz con renv activo e imprime `RENV_PROJECT`.
  - Primer acto git: `fetch` y comparar `HEAD` con `origin/main`.
  - Ningún shell en segundo plano al terminar.
- **LOG:** `50_documentacion/andamios/logs/20260925_css_muerto_a10_log.md`
- **PUNTO DE RETORNO:** el hash del commit `chore(encargo): CSS muerto a10` es `<inicio>`.
- **PRUEBAS:**
  - (a) `run_all(only = 33)` con renv activo: exit 0 y 0 warnings;
  - (b) 0 errores de consola y 0 `pageerror` en los 19 estados y en los 11 N;
  - (c) SHA del payload normalizado = `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`;
  - (d) `tests/auditar_cifras.R` y `tests/spot_check_publicado.R` en verde con renv activo, sobre `docs/index.html` del build.
- **Topes:** 3 intentos; 2 ciclos en FASE R; 1 reintento por falla transitoria; un push denegado no se reintenta.
- **Reglas canónicas:**
  - Commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`.
  - El LOG no lleva RBD con número ni nombres de establecimiento, ni hex.
  - **Solo se borra CSS:** ningún carácter se agrega salvo lo de §1 (C2), y el bloque transpilado del template no cambia (M-DERIVA antes y después).

## 1. Qué aprobó el titular (sesión 31 del chat, 2026-09-25)

Pendiente #3 del traspaso v30 (CSS muerto heredado de `slep_simce_adecuado`), aprobado con "vamos con p3". La lista **no** es la del a3, que solo inventarió los usos de `--border-2` y marcaba `.tooltip` como muerta, aunque `tooltip` está viva en `<div id="global-tooltip" class="tooltip">`. La midió el asistente en la sesión 31 sobre el template de `HEAD` = `047bf4e` (md5 `b72f73d99a0b23a9d8b832feb52ad141`), con este método:

- **Clases del CSS:** tokens `.<clase>` en los selectores del bloque `<style>` (líneas 8 a 1535), sin comentarios; 317 clases distintas.
- **Clase viva:** aparece como palabra completa (sin letra, dígito, `_` ni `-` pegados a los lados) en al menos uno de estos lugares: `33_app.jsx`, el resto del template (HTML y todos los `<script>`, incluido el bloque transpilado) o `33_generar_html.R`. En `33_app.jsx` no hay nombres de clase armados por concatenación ni por plantilla con prefijo (búsqueda de `"prefijo-" +` y de `` `prefijo-${`` : 0).
- **Clase muerta:** no aparece en ninguno de esos lugares: **157 clases**.
- **Reglas:** 429 en total; **196** tienen todos los selectores de su lista con al menos una clase muerta, y **2** tienen una lista mixta: `.select, .input` y `.select:focus, .input:focus`. (`input` cuenta como viva por aparecer como palabra en el código, aunque no sea una clase usada; se deja, por conservador.)

**Lista cerrada de las 157 clases muertas:**

`app-header-right` `app-objective-note` `badge-traspaso` `bars-svg` `brand-lockup` `btn` `btn-ghost` `btn-icon-only` `btn-primary` `btn-small` `btn-toggle` `chart-cell` `chart-cell-eyebrow` `chart-cell-head` `chart-cell-title` `chart-hints` `chart-svg` `color-note` `color-preview` `controls-spacer` `data-table` `empty-board` `empty-board-text` `ent-cell` `ent-name` `entities-actions` `entities-bar` `entities-chips` `entities-chips-head` `entities-chips-inner` `entities-count` `entities-head` `entities-list` `entities-reset` `entity-btn` `entity-btn-remove` `entity-chip` `entity-estab-btn` `entity-meta` `entity-name` `entity-selector-actions` `entity-selector-bar` `entity-selector-divider` `entity-selector-field` `entity-selector-inner` `entity-slep-note` `entity-swatch` `entity-text` `estab-popup` `estab-popup-com` `estab-popup-header` `estab-popup-item` `estab-popup-list` `estab-popup-nom` `estab-popup-rbd` `estab-popup-title` `field` `field-full` `field-hint` `field-label` `form-grid` `formula` `gse-filter` `gse-filter-label` `has-year-focus` `heat-band-1` `heat-band-2` `heat-band-3` `heat-band-4` `heat-legend` `heat-legend-scale` `heat-legend-text` `heat-legend-title` `heat-ramp` `heat-ramp-bar` `heat-ramp-coral` `heat-ramp-mid` `heat-ramp-ocean` `heat-scale-bar` `heat-tick` `heat-tick-left` `heat-tick-mid` `heat-tick-right` `hint-asterisk` `hint-box` `hint-item` `hint-low-n` `hint-muted` `icon-export` `icon-export-label` `is-compact` `is-empty` `is-pinned` `loading-dot` `loading-pill` `multiselect-hint` `note-stack` `prelim-mark` `results-head` `results-head-controls` `results-head-top` `results-section` `results-title` `results-title-year` `row-ent-start` `section-actions` `section-eyebrow` `select` `sg-ent-meta` `sg-ent-name` `sg-gse-eyebrow` `sg-gse-name` `slep-disclaimer` `sparkline-svg` `sub-eyebrow` `sub-section` `sub-section-bars` `supergrid` `supergrid-entity-head` `supergrid-gse-label` `table-head` `table-head-titles` `table-meta` `table-meta-item` `table-section` `table-title` `table-wrap` `td-alert` `td-alert-dot` `td-cell` `td-empty` `td-ent` `td-focused-year` `td-gse` `td-n` `td-pct` `td-prelim` `terr-pill` `th-ent` `th-focused-year` `th-gse` `th-prelim` `th-year` `tt-ent` `tt-estab-link` `tt-gse` `tt-head` `tt-meta` `tt-pct` `tt-row` `tt-seg` `tt-seg-lbl` `tt-seg-sw` `tt-seg-val` `tt-segments` `tt-swatch` `tt-warn`

| Id | Cambio (lista cerrada) | Dónde |
|---|---|---|
| C1 | Borrar entera cada regla cuya lista de selectores tenga, en **todos** sus selectores, al menos una clase de la lista (196 reglas). También se borra un `@media` que quede sin reglas | template, `<style>` |
| C2 | En las dos listas mixtas, quitar solo el selector con `.select`: `.select, .input` → `.input` y `.select:focus, .input:focus` → `.input:focus` | template, `<style>` |
| — | Comentarios: no se tocan, aunque queden sin regla debajo; se listan en el LOG como candidatos para una pasada futura | — |

**Forma de implementación:** un script propio en `/tmp/cat_a10_*` que opere sobre el texto del bloque `<style>` y preserve byte a byte todo lo que no borra. Puede usar `postcss` (instalación local en `/tmp/cat_a10_css`, autorizada) o un recorrido de llaves propio. El resultado se verifica por las mediciones de T1, no por la herramienta.

**Límites:** nada fuera de las líneas 8 a 1535 del template. Nada en `33_app.jsx`, `33_generar_html.R`, el pipeline, `20_insumos`, `10_utils`, `tests/`, `renv` ni la suite.

## 2. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `047bf4e` con árbol limpio (fuente: `git log` y `git status`, sesión 31). Hipótesis para el ejecutor; se verifica en M2.
- Template md5 `b72f73d99a0b23a9d8b832feb52ad141`; `<style>` en las líneas 8 a 1535; 7 líneas con `@media` en el archivo (fuente: `md5sum`, `grep -n` y `grep -c`, sesión 31).
- `docs/index.html` md5 `2e408857208db6aa8eec094e8f10e5aa` = publicado (fuente: `curl` y `md5sum`, sesión 31, tras el a8; el a9 no lo tocó según su 🔒1).
- Porcelain esperado al lanzar: solo este encargo. Hipótesis; se verifica en M1.

## 3. Invariantes 🔒

1. Payload idéntico (PRUEBAS c).
2. Cifras intactas (PRUEBAS d).
3. **Solo borrado:** `git diff <inicio>..HEAD -- 30_procesamiento/33_motor_template.html` da 2 líneas agregadas (las de C2) y todas las demás son borradas; todas las líneas tocadas caen dentro del bloque `<style>` de la base.
4. `git diff <inicio>..HEAD -- 30_procesamiento/33_app.jsx 30_procesamiento/33_generar_html.R 30_procesamiento/30_* 30_procesamiento/31_* 30_procesamiento/32_* 30_procesamiento/34_* 20_insumos 10_utils tests renv.lock renv 50_documentacion/suite | wc -l` → `0`.
5. Tras T2, md5 de `docs/index.html` = md5 de `40_salidas/motor_categoria.html`.
6. M-DERIVA: el bloque transpilado es idéntico antes y después, y es igual a la retranspilación de `33_app.jsx`.
7. **Render idéntico:**
   - en los 19 estados y los 11 N, cada uno en su ancho, capturas con AE = 0 frente a la base;
   - `textContent` de `#root` idéntico;
   - para cada elemento visible de `document.body`, los valores computados de un conjunto fijo de propiedades idénticos a la base: `display`, `position`, `box-sizing`, `width`, `height`, `margin`, `padding`, `border`, `border-radius`, `color`, `background-color`, `font-family`, `font-size`, `font-weight`, `line-height`, `letter-spacing`, `text-align`, `white-space`, `overflow`, `opacity`, `visibility`, `z-index`, `gap`, `flex`, `grid-template-columns`, `outline`, `box-shadow`, `transform`.
8. Contraste: 0 fallas de texto y 0 gráficas en los 19 estados y en N4a a N4d (instrumento del a3).
9. Orden temporal: `.traj` ascendente con el anillo al final y `.ee-detail-list` descendente con el vigente primero.

## 4. Tareas

Orden: FASE 0 → T1 (C1 y C2) → T2 (despliegue, solo si T1 terminó en verde) → FASE R → FASE L.

### Regla de detención

1. Stash no vacío, o porcelain antes del primer commit fuera de {este encargo, el LOG} → FASE L.
2. `HEAD` distinto de `origin/main` → FASE L.
3. M-DERIVA en falla → congela T1 y T2.
4. **M4 con una lista distinta** de la de §1 (otra cantidad, o una clase de más o de menos) → se registra la diferencia literal y T1 congelada. No se borra nada fuera de la lista ni se amplía la lista.
5. PRUEBAS c o d en falla, o un 🔒 en FALLA en T1 → `git restore` del template y de `docs/index.html`, T1 congelada, sin despliegue.
6. **Diferencia de render en 🔒7** → se identifica la regla responsable (bisección sobre las reglas borradas), se registra y T1 queda congelada. **No** se "repara" dejando esa regla, porque eso cambia la lista cerrada; la decisión queda para el titular como duda cerrada.
7. PRUEBAS c o d en falla en T2 → `git restore docs/index.html`, sin commit de despliegue.

### Autorizaciones (lista cerrada)

- Commit de FASE 0 con el encargo.
- Temporales en `/tmp/cat_a10_*`, y `npm install postcss` local en `/tmp/cat_a10_css`.
- Commit de T1 tras su verificación; `git restore docs/index.html` tras su build.
- `git add` de la ruta absoluta de `docs/index.html` y commit de despliegue en T2.
- `git restore` del template si la regla 5 lo exige.
- `git revert` de un commit propio si FASE R lo exige.
- `git push origin main` **una vez**, tras `docs(log)`, solo sin `BLOQUEADO`, con porcelain vacío y `HEAD..origin/main` = 0.
- Implícitas: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más: ni `rm` (lo temporal va con `mv` a `/tmp/cat_a10_basura/`), ni `reset`, `checkout --`, `rebase`, ni instalaciones distintas de la autorizada, ni operaciones de renv distintas de cargarlo.

### FASE 0 (con `esperado:` antes y `obtenido:` después)

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain antes y después del primer commit; stash; archivos del commit | antes: el encargo; después: vacío o el LOG; stash vacío; commit = el encargo | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `047bf4e` = `origin/main`; 0; 1 | regla 2 |
| M3 | md5 del template y de `docs/index.html`; SHA con calibración; PRUEBAS d | `b72f73d9…`; `2e408857…`; `d9895a78…0442`; calibración correcta; verde | regla 5 |
| M-DERIVA | retranspilación frente al bloque | idéntica | regla 3 |
| M4 | lista de clases muertas recalculada con el método de §1, en un script propio, y comparada con la lista de §1 | 317 clases; 157 muertas; la misma lista, clase por clase; 196 reglas completas y 2 mixtas | regla 4 |
| M5 | línea base del build de `HEAD` (19 estados y 11 N): capturas, `textContent`, estilos computados de 🔒7, bloques de años y contraste, con determinismo (dos corridas) | igual entre corridas; motor `2e408857…` | se registra |

### T1: C1 y C2

1. Aplicar C1 y C2 con el script; build (PRUEBAS a), PRUEBAS c y d; `git restore docs/index.html` y md5 `2e408857…`.
2. Verificación (`esperado:` antes):
   - reglas borradas = 196, listas recortadas = 2 y `@media` vacíos borrados (cantidad informada);
   - sobre el template nuevo: 0 de las 157 clases siguen en el CSS, y las 160 vivas siguen todas;
   - 🔒3 (líneas agregadas = 2, dentro de `<style>`);
   - bytes del template y del motor antes → después;
   - 🔒6, 🔒7 (capturas, `textContent` y estilos computados, estado por estado), 🔒8, 🔒9, 🔒1, 🔒2 y 🔒4;
   - comentarios que quedaron sin regla, listados.
3. Commit `refactor(motor): retira el CSS muerto heredado (157 clases sin uso) (a10 T1)`.

### T2: despliegue (solo si T1 terminó en verde)

1. Build con PRUEBAS a; `docs/index.html` queda con el build nuevo.
2. Verificación (`esperado:` antes):
   - PRUEBAS c y d sobre `docs/index.html`;
   - 🔒5;
   - por `file://`: 0 errores y 🔒7 repetido frente al publicado (`2e408857…`);
   - `git status --short` = `M docs/index.html`.
3. Commit `deploy(motor): publica el motor sin CSS muerto (a10)`.

### FASE R (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio. El inventario `R-01…` se anexa antes de auditar. Cada afirmación se re-deriva por un camino distinto:

- lista de clases muertas por un segundo método: `document.styleSheets` en el navegador, clase por clase con `document.querySelectorAll('.<clase>').length` = 0 en los 19 estados y los 11 N, si antes fue por texto;
- render por diferencia de píxeles con otra herramienta, si antes fue por AE;
- SHA desde `git show` y en Python.

Incluye además:

- el comando y la salida literal de cada 🔒;
- el alcance: `git diff --name-only <inicio>..HEAD` debe dar el template, `docs/index.html`, el encargo y el LOG;
- la regresión PRUEBAS a a d;
- el control positivo: la herramienta de 🔒7 detecta una diferencia al borrar, en una copia de prueba, una regla viva cualquiera (por ejemplo, `.entity-select-btn`).

Veredicto por hallazgo (BLOQUEA / REPARA / ADVIERTE), con máximo 2 ciclos. Un BLOQUEA obliga a hacer `git revert` del despliegue antes del push.

### FASE L (última, obligatoria)

El LOG lleva:

- resumen, commits e invariantes;
- md5 de `docs/index.html` desplegado;
- bytes antes → después;
- conteo por familia de clases (prefijo) retiradas;
- comentarios huérfanos;
- dudas con pregunta cerrada y errores propios;
- bloque J de trece campos;
- privacidad (script con control plantado → vacío);
- `grep -c '^esperado:'` = `grep -c '^obtenido:'` y `grep -c '^## J'` = 1.

Cierra con el commit `docs(log): CSS muerto a10` y el push según la autorización.

## 5. Reporte final

- Primera línea: salida literal de `ls -l <LOG> && wc -l <LOG>` y hash de `docs(log)`.
- Segundo bloque: el bloque J tal cual.
- Después:
  - reglas y clases retiradas;
  - bytes antes → después del template y del motor;
  - resultado de 🔒3, 🔒5, 🔒6, 🔒7, 🔒8 y 🔒9;
  - hash del despliegue, md5 de `docs/index.html` y salida del push;
  - comentarios huérfanos;
  - qué revisar en el sitio publicado (una pasada visual por territorio, establecimiento, modal y comparador: nada debería verse distinto);
  - lo que falló o sorprendió (si nada, decirlo).
