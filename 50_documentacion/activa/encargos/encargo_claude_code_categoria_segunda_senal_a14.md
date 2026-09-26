# Encargo autónomo: segunda señal en la trayectoria (altura según la categoría), y despliegue (a14)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten.**
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus 0. Si la sesión está en otro modo, el encargo manda y el LOG lo declara.
- **Actos externos (D5 = a):** uno solo, `git push origin main` en FASE L, con el OK del mensaje de lanzamiento. Cualquier otro se consulta.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS), lanzado en la raíz del repo `slep_categoria_desempeno`. Todo script empieza con `RAIZ="$(git rev-parse --show-toplevel)"`. FASE 0 verifica el `basename` y que `origin` = `https://github.com/tomgc/slep_categoria_desempeno.git`. En el LOG, `$RAIZ` se escribe `<RAIZ>`. Ninguna ruta con nombre de usuario entra a un archivo versionado.
- **INSUMOS (en disco):**
  - este encargo;
  - `50_documentacion/andamios/20260925_errores_asistente_sesion32.md` (modificado, 10 filas);
  - `50_documentacion/activa/decisiones/20260926_decision_segunda_senal_trayectoria.md` (nuevo, escrito por el asistente; es la especificación de diseño de este encargo);
  - `30_procesamiento/33_app.jsx` (fuente de verdad de la interfaz) y `30_procesamiento/33_motor_template.html` (CSS y bloque transpilado);
  - `30_procesamiento/33_generar_html.R`, `00_run_all.R`, `tests/auditar_cifras.R`, `tests/spot_check_publicado.R`;
  - LOG del a12: medición de CSSOM, `textContent` y capturas de ventana (D6), y verificador Python del SHA;
  - encargo a6 (POSICIÓN): Puppeteer y receta de Babel.
- **POSICIÓN:**
  - `bash` explícito; scripts en archivo (`/tmp/cat_a14_*`), sin heredocs en zsh, sin `Rscript -e` de varios pasos y sin `echo` con cadenas de `=`.
  - git de lectura con `GIT_OPTIONAL_LOCKS=0` desde el primer comando; `fetch` con `-c maintenance.auto=false`.
  - R desde la raíz con renv.
  - Puppeteer con Chrome del sistema por `file://`, con transiciones y animaciones desactivadas antes de medir.
  - **Capturas: de ventana y de ventana estirada a la altura del documento, nunca `fullPage` (D6 = sí).**
  - Babel en `/tmp/cat_a14_babel`, copiado de `/tmp/cat_a12_babel` o instalado, con `{"presets":[["@babel/preset-react",{"runtime":"classic"}]]}`.
  - Ningún shell en segundo plano; checkout final en `main`.
- **LOG:** `50_documentacion/andamios/logs/20260926_segunda_senal_a14_log.md`
- **PUNTO DE RETORNO:** el hash del commit `chore(encargo): segunda señal de la trayectoria a14` es `<inicio>`.
- **ALCANCE:**
  - T1: `30_procesamiento/33_app.jsx` y `30_procesamiento/33_motor_template.html` (CSS de §1 y bloque transpilado por retranspilación completa);
  - T2: `docs/index.html`;
  - FASE L: el LOG.
- **PRUEBAS:**
  - (a) `run_all(only = 33)` con renv: exit 0 y 0 warnings; fuera de T2, `git restore docs/index.html` después de cada build;
  - (b) `tests/auditar_cifras.R` y `tests/spot_check_publicado.R` en verde con renv;
  - (c) SHA del payload normalizado = `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`, con su calibración.
- **Topes:** 3 intentos por bug; 2 ciclos en FASE R; 1 reintento por falla transitoria; un push denegado no se reintenta.
- **Reglas canónicas:**
  - Commits en español; `git add` con rutas explícitas; nunca `--no-verify` ni `--force`; sin atribución a la herramienta.
  - LOG sin RBD con número, sin nombres de establecimiento ni de personas.
  - **El bloque transpilado del template no se edita a mano:** se edita `33_app.jsx` y se retranspila completo.
  - Ningún color cambia.

## 1. Qué aprobó el titular y qué se cambia

Opción B del pendiente #7 («ok b», sesión 32), tras ver la maqueta de las tres opciones. La especificación es la decisión `20260926_decision_segunda_senal_trayectoria.md`, que va en el commit de FASE 0. La altura de la marca de cada año codifica la categoría, en el orden de `CatData.CATEGORIAS` (Insuficiente → Alto).

### Estado medido por el asistente (sesión 32, `HEAD` = `eb18baa`)

- md5: `33_app.jsx` `07066acf9bbc0ae827b49d111b3d9066`, template `1b615464115cdaefb384c206c1a4f620` y `docs/index.html` `018f63657c227036899ae3194bf9c68e` (fuente: `md5sum`).
- La trayectoria se dibuja en `function Trayectoria({ serie })` (líneas 956 a 985 aprox. de `33_app.jsx`), y la usa una sola fila (línea 1055). La leyenda está en las líneas 2013 a 2033: `traj-legend-sw` por categoría y una más para «Sin categoría» (fuente: `grep -n` y `sed`).
- El detalle en texto de la fila (`ee-detail-list`, línea 1060 y siguientes) no se toca.
- CSS del template (fuente: `sed -n`):
  - `.traj-mark { width: 18px; height: 18px; border-radius: var(--radius-1); border: 1px solid rgba(0,0,0,0.08); }` en la línea 581;
  - `.traj-legend-sw { width: 16px; height: 16px; … }` en la línea 906;
  - `* { box-sizing: border-box; }` en la línea 125, así que la altura que se fija es la altura renderizada.
- `CatData.CATEGORIAS` sigue el orden semántico «Insuf -> Alto» (fuente: `33_app.jsx`, línea 49).

### Cambios (lista cerrada)

| Id | Dónde | Cambio |
|---|---|---|
| J1 | `33_app.jsx`, antes de `function Trayectoria` | Constantes y función, con comentario `a14-B`: `const TRAJ_ALTURA_BASE = 7;` (px: Insuficiente y «sin categoría»), `const TRAJ_ALTURA_PASO = 6;` (px entre categorías consecutivas) y `function alturaTrayectoria(categoria) { const i = CatData.CATEGORIAS.indexOf(categoria); return TRAJ_ALTURA_BASE + (i < 0 ? 0 : i) * TRAJ_ALTURA_PASO; }` |
| J2 | `Trayectoria` | La marca va envuelta en `<span className="traj-bar">…</span>`. Su `style` pasa a `esSi ? { height: alturaTrayectoria(null) } : { background: color, height: alturaTrayectoria(p.categoria) }`. `className` y `title` no cambian |
| J3 | Leyenda | Cada `traj-legend-sw` va envuelto en `<span className="traj-bar">…</span>`. Las categorías llevan `style={{ background: CatData.CAT_COLORS[c], height: alturaTrayectoria(c) }}`; «Sin categoría» lleva `style={{ height: alturaTrayectoria(null) }}` |
| C1 | template, `<style>` | Regla nueva junto a `.traj-mark`: `.traj-bar { height: 25px; display: inline-flex; align-items: flex-end; }`, con el comentario `/* a14-B: contenedor de altura fija; la marca se apoya abajo y su altura codifica la categoria (25 = TRAJ_ALTURA_BASE + 3 x TRAJ_ALTURA_PASO en 33_app.jsx) */`. El comentario no puede contener `*/` antes del cierre |
| C2 | `.traj-mark` | `width: 18px; height: 18px;` → `width: 16px;` (la altura va inline) |
| C3 | `.traj-legend-sw` | `width: 16px; height: 16px;` → `width: 14px;` (la altura va inline) |
| T | template, bloque de la app | Retranspilación completa de `33_app.jsx` con la receta del proyecto. Nada a mano |

Cuenta de alturas: Insuficiente 7, Medio-Bajo 7 + 6 = 13, Medio 7 + 12 = 19, Alto 7 + 18 = 25, sin categoría 7. El máximo, 25, es el alto de `.traj-bar`.

## 2. Estado de partida (premisas marcadas)

- `main` = `origin/main` = `eb18baa` (fuente: `git log`, sesión 32). Se mide en M2.
- Porcelain (fuente: `git status`, sesión 32, más este encargo):
  - ` M 50_documentacion/andamios/20260925_errores_asistente_sesion32.md`;
  - `?? 50_documentacion/activa/decisiones/20260926_decision_segunda_senal_trayectoria.md`;
  - `?? ` de este encargo;
  - más el LOG.

  Se mide en M1.
- M-DERIVA: el bloque del template es la retranspilación de `33_app.jsx`, `84d079b7…`, 1614 líneas. Es hipótesis: el a12 lo midió y desde entonces no cambió ni el template fuera del `<style>` ni `33_app.jsx` (fuente: LOG a13, 🔒2). Se mide en FASE 0.
- Los colores no cambian, así que el contraste de las marcas medido en el a3 sigue valiendo (fuente: decisión de paleta v2). El 🔒5 lo comprueba.

## 3. Invariantes 🔒

1. **Alcance del código:**
   - `git diff --name-only <inicio>..HEAD` (sin el LOG; el LOG se mide en FASE L) = {`30_procesamiento/33_app.jsx`, `30_procesamiento/33_motor_template.html`, `docs/index.html`};
   - en `33_app.jsx`, el diff contiene solo J1 a J3;
   - en el `<style>`, el diff contiene solo C1 a C3;
   - fuera del `<style>`, el template solo cambia en el bloque de la app.
2. **M-DERIVA después:** el bloque de la app del template es idéntico a la retranspilación del `33_app.jsx` nuevo.
3. **Cifras intactas:** PRUEBAS b y c (payload sin cambio; `meta.cat_colors` igual).
4. **Geometría, en Chrome, en al menos tres estados con trayectorias:** el inicial a 1280 × 800, el inicial a 390 × 844 y uno con la lista «sin categoría vigente» o con marcas «sin categoría», elegido por programa desde el payload.
   - (a) Para cada `.traj-mark`, la altura renderizada es la del mapa por la etiqueta de su `title`: «Insuficiente» 7, «Medio-Bajo» 13, «Medio» 19, «Alto» 25 y «Sin categoría…» 7. Tolerancia 0,5 px.
   - (b) Dentro de cada `.traj`, todas las `.traj-year-lbl` tienen el mismo `top` y todas las marcas el mismo `bottom` (±0,5 px).
   - (c) El ancho de cada marca es 16 px.
   - (d) El vigente conserva el anillo: `box-shadow` sin cambio respecto de la base.
   - (e) La leyenda tiene 5 muestras con alturas 7, 13, 19, 25 y 7, en ese orden.
   - Calibración: una copia del motor con `TRAJ_ALTURA_PASO` en 0 (fuera del árbol) hace fallar el (a).
5. **Colores intactos:** para cada marca de categoría, el `background-color` computado es igual al de la base para la misma etiqueta. El CSSOM, comparado con la base, difiere solo en `.traj-bar` (nueva), `.traj-mark` y `.traj-legend-sw`.
6. **Resto del render igual:**
   - `textContent` de `#root` idéntico a la base en los estados medidos;
   - captura de ventana del modal abierto a 390 × 844 con AE = 0 frente a la base;
   - 0 errores de consola.
7. **Despliegue fiel:** tras T2, md5 de `docs/index.html` = md5 de `40_salidas/motor_categoria.html`.
8. **Sin coautoría, RUT ni rutas de usuario** en lo agregado (los mismos tres comandos del a12).

## 4. Tareas

Grafo: T1 → T2. FASE R y FASE L corren siempre.

### Regla de detención

1. M1 o M2 distintos de lo esperado → FASE L, sin push.
2. M-DERIVA con diferencias antes del cambio → T1 y T2 congeladas.
3. Un 🔒 en FALLA en T1 → `git restore` de `33_app.jsx` y del template, T1 congelada, sin T2.
4. PRUEBAS b o c en falla en T2 → `git restore docs/index.html`, sin commit de despliegue.
5. Push denegado → no se reintenta.
6. Cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda con pregunta cerrada y pasa a FASE R.

### Autorizaciones (lista cerrada)

- Commit de FASE 0: el encargo, el archivo de errores y la decisión.
- Edición de `33_app.jsx` con J1 a J3, del `<style>` con C1 a C3, y retranspilación del bloque de la app.
- Commit de T1 (las dos rutas); `git restore docs/index.html` tras cada build fuera de T2.
- `git restore` de `33_app.jsx` y del template si la regla 3 lo exige.
- Commit de despliegue en T2.
- `git revert` de un commit propio si FASE R lo exige.
- Temporales en `/tmp/cat_a14_*`; copia de Babel o su instalación allí.
- `git push origin main` una vez, en FASE L, con el simulacro del hook en exit 0.
- Implícitas: `fix(auditoria): R-NN …` y `docs(log): segunda señal de la trayectoria a14`.

Nada más: ni `rm`, `reset`, `checkout --`, `stash`, `--no-verify`, `--force`, ni ediciones fuera de los ALCANCE.

### FASE 0 (`esperado:` antes de cada `obtenido:`)

Primer acto: crear el LOG con el encabezado, el slot `## J. Juicio (lo rellena FASE L)` y el esqueleto.

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | rama; porcelain; stash | `main`; las líneas de §2; vacío | regla 1 |
| M2 | `fetch`; `HEAD`; `origin/main`; deltas; ENTORNO; filas del archivo de errores; md5 de la decisión | `eb18baa` = `origin/main`; 0 y 0; 10 filas; `6f356181f6013cd37d535a3334389b74` | regla 1 |
| M3 | commit de FASE 0 (3 rutas); `<inicio>`; md5 de `33_app.jsx`, del template y de `docs` | 3 archivos; `07066acf…`, `1b615464…` y `018f6365…` | regla 1 |
| M-DERIVA | retranspilación frente al bloque | idéntica, `84d079b7…`, 1614 líneas | regla 2 |
| M4 | base: build (PRUEBAS a) copiado a `/tmp/cat_a14_base.html`; en Chrome, en los estados del 🔒4 y en el modal: CSSOM, `textContent`, capturas de ventana, y por marca etiqueta, alto, ancho, `background-color` y `box-shadow`; dos corridas | dos corridas iguales; en la base, todas las marcas miden 18 × 18 | se registra |
| M5 | PRUEBAS b y c sobre la base | verde; `d9895a78…0442` | FASE L |

### T1: altura según la categoría

1. Aplicar J1 a J3 en `33_app.jsx` y C1 a C3 en el `<style>`, y retranspilar el bloque de la app completo.
2. Verificación (`esperado:` antes):
   - 🔒1 (diff por archivo);
   - 🔒2 (M-DERIVA después);
   - build (PRUEBAS a); 🔒3, 🔒4 con su calibración, 🔒5 y 🔒6 contra la base de M4;
   - `git restore docs/index.html`.
3. Commit `feat(motor): la altura de la marca de la trayectoria codifica la categoría (a14 T1)`, con las dos rutas.

### T2: despliegue (solo si T1 terminó en verde)

1. Build con PRUEBAS a; `docs/index.html` queda con el build nuevo.
2. Verificación (`esperado:` antes):
   - 🔒7;
   - PRUEBAS b y c sobre `docs/index.html`;
   - por `file://`, 0 errores y el 🔒4 repetido;
   - `git status --short` = ` M docs/index.html` (más el LOG).
3. Commit `deploy(motor): publica la trayectoria con segunda señal (a14)`.

### FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio.

1. **Inventario** `R-01…` desde el LOG, antes de auditar.
2. **Re-derivación con otro comando:**
   - las alturas, leídas de las capturas de ventana (bandas de color por columna en la imagen), si antes fue por DOM;
   - el CSSOM con `postcss`, si antes fue con Chrome;
   - md5 con `openssl`;
   - SHA con Python.
3. **Invariantes:** comando de cada 🔒, PASA/FALLA con salida literal. El 🔒1 sin el LOG.
4. **Alcance y porcelain.**
5. **Regresión:** PRUEBAS a, b y c.
6. **Control positivo:**
   - la calibración del 🔒4 (paso en 0);
   - además, un color alterado en una copia del motor es detectado por el 🔒5.
7. **Veredicto por hallazgo:** BLOQUEA, REPARA o ADVIERTE. Un BLOQUEA después de T2 obliga a `git revert` del despliegue antes del push.
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
   - la tabla de alturas medidas por etiqueta (cuántas marcas de cada categoría y su alto);
   - bytes del motor antes y después;
   - dudas con pregunta cerrada;
   - errores propios;
   - notas para el revisor.
3. Bloque J de trece campos, copiado del detalle.
4. Privacidad del LOG: RUT 0, `$HOME` 0, sin nombres.
5. `ls -l` y `wc -l` del LOG; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. Commit `docs(log): segunda señal de la trayectoria a14`. **Recién aquí** se mide el alcance completo: `git diff --name-only <inicio>..HEAD` = las 3 rutas del 🔒1 más el LOG.
7. Simulacro del hook (`refs/heads/main <HEAD> refs/heads/main <origin/main>`, exit 0) y `git push origin main`.
8. Después del push, `curl -s https://tomgc.github.io/slep_categoria_desempeno/ | md5`, hasta 10 intentos cada 30 s, contra el md5 de `docs/index.html`. El resultado va al reporte, no al LOG.

## 5. Reporte final

- **Primera línea:** la salida literal de `ls -l <LOG> && wc -l <LOG>` y el hash de `docs(log)`.
- **Segundo bloque:** el bloque J tal cual.
- **Después:**
  - la tabla de alturas medidas por categoría;
  - resultado de cada 🔒;
  - PRUEBAS a, b y c;
  - bytes y md5 del motor, antes y después;
  - hash del despliegue;
  - salida del push y md5 del sitio publicado;
  - dos capturas de ventana de la trayectoria (1280 y 390) guardadas en `/tmp/cat_a14_*`, con su ruta;
  - qué revisar en el sitio: una fila de cada categoría y la leyenda, en escritorio y en móvil;
  - lo que falló o sorprendió (si nada, decirlo).
