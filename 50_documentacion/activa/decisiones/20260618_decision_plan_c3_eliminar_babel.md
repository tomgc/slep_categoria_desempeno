# Plan C3 — Eliminar Babel del motor (sesión dedicada)

> Reescribir el JSX a `React.createElement` plano, usar Babel UNA vez como
> herramienta de migración y retirarlo del proyecto. NO C1 (Node en build) ni
> C2 (paso manual). Alto riesgo: refactor sobre UI aprobada (D2). Snapshot
> previo OBLIGATORIO (política 3). Este documento se ejecuta en sesión limpia,
> no encadenado a otro trabajo (D29, higiene).

## Estado real verificado del código (sesión 20, lectura directa)

- **Template** `30_procesamiento/33_motor_template.html` (2963 líneas):
  - L1516-1517: `<script>__REACT_INLINE__</script>` + `__REACTDOM_INLINE__` (inline, s18).
  - L1525-1527: **único `<script src>`** → Babel standalone `@7.29.0` (unpkg, con
    `integrity` sha384 + `crossorigin`). Es lo único que se retira.
  - L1530: `__D3_INLINE__`. L1533: `__PAKO_INLINE__`. L1536-1541: bloque de datos
    (`__JSON_DATA__`, descompresión pako).
  - L1544: `<script type="text/babel" data-presets="env,react">` → inicio del JSX.
  - L2962: `</script>` → cierre. **Bloque JSX ≈ 1418 líneas** (1544-2962).
  - L2960-2961: montaje `ReactDOM.createRoot(document.getElementById("root")).render(<App/>)`.
- **Generador** `30_procesamiento/33_generar_html.R` (509 líneas):
  - L446-451: `for` de validación con los **5** placeholders.
  - L454-458: 5 `sub(..., fixed = TRUE)` de inyección.
  - Babel NO pasa por el generador: es `src` fijo en el template, no placeholder.
    El generador no lo toca hoy y no lo tocará: lo que cambia en el generador es
    solo el comentario de cabecera (L26-28) que menciona Babel.

**Consecuencia de diseño:** retirar Babel es una edición del **template**
(quitar L1525-1527 y cambiar el `type` del bloque JSX), más el reemplazo del
contenido JSX por su transpilado. El generador casi no cambia (solo el
comentario); los 5 placeholders y las 5 inyecciones se conservan intactas.

---

## Fase 0 — Preparación (en sesión, antes de tocar nada)

1. **Snapshot obligatorio** del template y el generador aprobados:

   → Claude Code:
   ```
   FECHA=$(date +%Y%m%d)
   mkdir -p /Users/tomgc/Projects/slep_categoria_desempeno/_archivo/$FECHA/30_procesamiento
   cp /Users/tomgc/Projects/slep_categoria_desempeno/30_procesamiento/33_motor_template.html \
      /Users/tomgc/Projects/slep_categoria_desempeno/_archivo/$FECHA/30_procesamiento/33_motor_template.html
   cp /Users/tomgc/Projects/slep_categoria_desempeno/30_procesamiento/33_generar_html.R \
      /Users/tomgc/Projects/slep_categoria_desempeno/_archivo/$FECHA/30_procesamiento/33_generar_html.R
   ls -la /Users/tomgc/Projects/slep_categoria_desempeno/_archivo/$FECHA/30_procesamiento/
   ```

   (`_archivo/` está gitignored: es respaldo local, no se versiona. Conserva la
   ruta relativa según política 1.5.)

2. **Commit limpio previo** (precondición de cambio irreversible, política 3):

   → Claude Code:
   ```
   git -C /Users/tomgc/Projects/slep_categoria_desempeno status
   ```
   El árbol debe estar limpio antes de empezar. Si no lo está, resolver primero.

3. **Criterio de éxito (B.4), definido ANTES de codificar:**
   - El motor renderiza **idéntico** a la versión actual (revisión visual del titular).
   - Auditoría F1-F4 (`tests/auditar_cifras.R`) en verde, 0 discrepancias.
   - Spot-check 6/6 presencia + 1 ausencia certificada (`tests/spot_check_publicado.R`).
   - Apertura del HTML con **DevTools → Network offline**: render completo, **sin
     ninguna petición de red** y **sin Babel** en el documento.
   - `grep -i babel docs/index.html` → 0 ocurrencias.

---

## Fase 1 — Transpilación mecánica única (TAREA MANUAL DEL TITULAR)

El asistente no ejecuta Node. Tú corres Babel una sola vez, como herramienta de
migración desechable, sobre el bloque JSX extraído.

1. Extraer el contenido del bloque (líneas 1545-2959, es decir, lo de adentro
   del `<script type="text/babel">` sin las etiquetas) a un archivo `app.jsx`
   temporal fuera del repo (p. ej. `~/tmp_c3/app.jsx`). El asistente puede
   prepararte el `app.jsx` exacto en la Fase 1-bis de abajo para que no recortes
   a mano.

2. Transpilar con presets idénticos a los del runtime (`env,react`):

   ```
   cd ~/tmp_c3
   npm init -y
   npm install --no-save @babel/cli @babel/core @babel/preset-env @babel/preset-react
   npx babel app.jsx --presets @babel/preset-env,@babel/preset-react -o app.plain.js
   ```

   `app.plain.js` queda en `React.createElement(...)` plano, sin JSX.

3. Devuélveme `app.plain.js` (o pégamelo). Yo lo integro al template en la Fase 2;
   no lo pegas tú a mano (regla de ediciones: archivo completo, no fragmentos).

### Fase 1-bis (la hago yo, en la sesión dedicada, antes de que corras Babel)
Genero el `app.jsx` recortando exactamente el interior del bloque `text/babel`
del template vivo, para que la transpilación opere sobre el código real sin
riesgo de recorte manual. Te lo entrego como descargable.

---

## Fase 2 — Integración (asistente, con el transpilado en mano)

1. **Editar el template** `33_motor_template.html`:
   - Eliminar L1525-1527 (el `<script src>` de Babel completo, con su SRI y
     `crossorigin`) y su comentario L1519-1524.
   - Cambiar L1544 `<script type="text/babel" data-presets="env,react">` por
     `<script>` normal.
   - Reemplazar el cuerpo JSX (1545-2959) por el contenido de `app.plain.js`.
   - El montaje `ReactDOM.createRoot(...).render(...)` ya es JS válido transpilado;
     queda dentro del mismo `<script>` o se mantiene como está (el transpilado lo
     incluye si `app.jsx` lo contenía; verificar que `<App/>` quedó como
     `React.createElement(App)`).
   - Conservar intactos los 5 placeholders y los demás `<script>` inline.

2. **Editar el generador** `33_generar_html.R`:
   - Solo el comentario de cabecera L26-28: quitar la mención a que "Babel se
     mantiene en CDN". El código (validación + inyección de 5 placeholders) NO
     cambia: sigue habiendo 5 placeholders, Babel nunca fue uno.

3. Entrego ambos archivos completos como descargables. Tú los reemplazas a mano.

---

## Fase 3 — Verificación (tras regenerar)

1. **Regenerar el motor** (no asumir sesión R activa; cargar el orquestador primero):

   → Claude Code:
   ```
   cd /Users/tomgc/Projects/slep_categoria_desempeno
   Rscript -e 'source(here::here("00_run_all.R")); regenerar_motor()'
   ```

2. **Auditoría + spot-check:**

   → Claude Code:
   ```
   Rscript /Users/tomgc/Projects/slep_categoria_desempeno/tests/auditar_cifras.R
   Rscript /Users/tomgc/Projects/slep_categoria_desempeno/tests/spot_check_publicado.R
   ```

3. **Sin Babel / sin red:**

   → Claude Code:
   ```
   grep -ic babel /Users/tomgc/Projects/slep_categoria_desempeno/docs/index.html
   grep -icE "unpkg|jsdelivr|https?://[^\"']*\.js" /Users/tomgc/Projects/slep_categoria_desempeno/docs/index.html
   ```
   Ambos deben dar 0 (salvo URLs en comentarios/texto, que se revisan a mano).

4. **Revisión visual del titular** con Network offline en DevTools: el motor debe
   verse y comportarse idéntico. Solo entonces el snapshot de Fase 0 se considera
   superado (no se borra: `_archivo/` es histórico).

5. **Commits atómicos temáticos** (cuando todo esté en verde):
   - Uno: template sin Babel + JSX transpilado.
   - Uno: comentario del generador.
   - Uno: motor regenerado (`40_salidas/` está gitignored; se versiona
     `docs/index.html`).
   - Push y `git log` de cierre.

---

## Riesgos y mitigaciones

| Riesgo | Mitigación |
|---|---|
| El `createElement` plano queda ilegible (~1418 líneas) | Decisión abierta heredada: evaluar `htm` (~1 KB, JSX-like sin transpilación, inlineable) viendo el output real ANTES de commitear. No decidir a ciegas. |
| Transpilado cambia comportamiento (presets distintos) | Usar exactamente `env,react`, los mismos `data-presets` del runtime actual. |
| Drift visual no detectado | Revisión visual del titular como compuerta dura, no opcional. |
| Pérdida del template aprobado | Snapshot Fase 0 obligatorio antes de la primera edición. |
| Suite de documentación desactualizada (menciona Babel) | El `pie_extra$arq_tec` dice "C3 planificada"; tras C3, actualizar la suite (próxima sesión de documentación, no esta). Anotar como pendiente. |

## Decisión abierta a resolver durante la ejecución
Si `React.createElement` resulta ilegible, evaluar `htm` (JSX-like sin
transpilación, inlineable ~1 KB) sobre el output real. **Recomendación:**
intentar primero `createElement` puro (cero dependencias, objetivo literal de
C3); pasar a `htm` solo si la ilegibilidad compromete el mantenimiento futuro,
porque `htm` reintroduce una micro-dependencia que C3 busca evitar.
