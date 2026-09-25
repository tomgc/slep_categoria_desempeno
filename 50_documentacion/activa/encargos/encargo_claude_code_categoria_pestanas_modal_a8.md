# Encargo autónomo: pestañas del modal en pantallas angostas, y despliegue (a8)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten.**
- **EJECUCIÓN:** esfuerzo `high`; orquestador el modelo de la sesión; subagentes 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_categoria_desempeno`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/33_motor_template.html`; `30_procesamiento/33_app.jsx` (solo para M-DERIVA); `00_run_all.R`; `tests/auditar_cifras.R`; `tests/spot_check_publicado.R`; el LOG del a7 (`50_documentacion/andamios/logs/20260925_ancho_y_despliegue_a7_log.md`), que trae estados, instrumentos, T1 congelada, la evidencia de Q-C4b y la receta de build con renv activo.
- **POSICIÓN:**
  - Rutas absolutas desde la raíz; ningún comando asume `cd`.
  - `bash` explícito; scripts en archivo, sin heredocs en zsh y sin `node -e` en línea.
  - Puppeteer y Chrome del sistema como en el a7, con transiciones y animaciones desactivadas antes de medir.
  - Instrumentos en `/tmp/cat_a8_*`, copiados de `/tmp/cat_a7_*`.
  - Toda corrida R arranca en la raíz e imprime `RENV_PROJECT`.
  - Primer acto git: `fetch` y comparar `HEAD` con `origin/main`.
  - Ningún shell en segundo plano al terminar.
- **LOG:** `50_documentacion/andamios/logs/20260925_pestanas_modal_a8_log.md`
- **PUNTO DE RETORNO:** el hash del commit `chore(encargo): pestañas del modal a8` es `<inicio>`.
- **PRUEBAS:**
  - (a) `run_all(only = 33)` con renv activo, exit 0 y 0 warnings;
  - (b) 0 errores de consola y 0 `pageerror` en los 19 estados y en los 11 estados N del a7;
  - (c) SHA del payload normalizado = `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`;
  - (d) `tests/auditar_cifras.R` y `tests/spot_check_publicado.R` en verde con renv activo, corridos sobre `docs/index.html` del build.
- **Topes:** 3 intentos; 2 ciclos en FASE R; 1 reintento por falla transitoria; un push denegado no se reintenta.
- **Reglas canónicas:**
  - Commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`.
  - El LOG no lleva RBD con número ni nombres de establecimiento.
  - Solo CSS: el bloque de la app del template no cambia (M-DERIVA antes y después).
  - Ningún hex nuevo.

## 1. Qué aprueba el titular al lanzar este encargo (sesión 31 del chat, 2026-09-25)

El asistente propuso en la sesión 31 las respuestas a las dudas del a7. Lanzar este encargo equivale a aprobarlas; si el titular cambió alguna, el encargo se corrige antes de lanzarlo.

- **Q-C4b: Sí**, C4 con `margin-right: 8px`.
- **Q-SH: Sí.** El criterio vertical pasa a ser «`scrollHeight − clientHeight` de `.modal-tabs` igual al de la base»: 1 px, que es el segundo píxel del subrayado pisando el separador y ya está en el publicado.

Además, el registro de errores del asistente de la sesión 31 (modificado: dos filas nuevas) entra en el primer commit junto con este encargo.

| Id | Cambio (lista cerrada, única forma) | Dónde |
|---|---|---|
| C4 | Agregar, después de la regla `.modal-tab.is-active`, `@media (max-width: 560px) { .modal-tabs { padding: 0 16px; flex-wrap: wrap; } .modal-tab { margin-right: 8px; } }`, con el comentario `a8-C4: las pestañas pasan a una segunda fila solo cuando no caben`. Sin `overflow` en ningún eje | template, CSS |

**Cálculo que respalda el esperado a 390 px** (fuente: LOG a7, T1). La suma de anchos de las pestañas es a lo más 279,2 px, con «Establecimiento» activa en negrita. Con el margen: 279,2 + 4 × 8 = 311,2 px, contra 390 − 40 − 32 = 318 px de ancho interior, así que queda una sola fila con 6,8 px de holgura. A 375 px hay 303 px de ancho interior, menos que 311,2, así que se esperan dos filas; lo mismo a 360 y 320.

**Cadenas de `textContent`:** ninguna cambia.

**Límites:** nada fuera del CSS de C4 en el template. Nada en el pipeline, en `33_generar_html.R`, `34_*`, `10_utils`, `20_insumos` ni `tests/`.

## 2. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `484c9f1` (`docs(log): ancho y despliegue a7`), según `git log --oneline -5` de la sesión 31. Esta línea es hipótesis para el ejecutor; se verifica en M2.
- `docs/index.html` md5 `d58d2f2c9fbc5469228cdee6be05bb61` = sitio publicado, según `curl` del sitio y `md5sum` en la sesión 31 del chat.
- Porcelain = ` M 50_documentacion/andamios/20260925_errores_asistente_sesion31.md` más este encargo, según `git status --porcelain` de la sesión 31 antes de guardar el encargo. Se verifica en M1.
- Base de C4 (fuente: LOG a7, M5):
  - «Establecimiento» cortada a 320, 360, 375 y 390 px;
  - `scrollHeight`/`clientHeight` 44/43;
  - subrayado de 2 px.
- Alternativa P16/M8 medida por inyección en el a7, con 1 fila a 390 px y 2 filas a 320, 360 y 375 (fuente: LOG a7, R.2).

## 3. Invariantes 🔒

1. Payload idéntico (PRUEBAS c).
2. Cifras intactas (PRUEBAS d).
3. 0 hex en las líneas agregadas.
4. `git diff <inicio>..HEAD -- 30_procesamiento/30_* 30_procesamiento/31_* 30_procesamiento/32_* 30_procesamiento/33_generar_html.R 30_procesamiento/34_* 30_procesamiento/33_app.jsx 20_insumos 10_utils tests | wc -l` → `0`.
5. Tras T2, md5 de `docs/index.html` = md5 de `40_salidas/motor_categoria.html`.
6. Bloque del template = retranspilación de `33_app.jsx`.
7. `textContent` de `#root` idéntico al del publicado (`d58d2f2c…`) en los 19 estados y en los 11 N: 30/30, sin cadenas nuevas.
8. Contraste: 0 fallas de texto y 0 gráficas en los 19 estados y en N4a a N4d.
9. Orden temporal: `.traj` ascendente con el anillo al final y `.ee-detail-list` descendente con el vigente primero.

## 4. Tareas

Orden: FASE 0 → T1 (C4) → T2 (despliegue, solo si T1 terminó en verde) → FASE R → FASE L.

### Regla de detención

1. Stash no vacío, o porcelain antes del primer commit fuera de {este encargo, el registro de errores modificado, el LOG} → FASE L.
2. `HEAD` distinto de `origin/main` → FASE L.
3. M-DERIVA en falla → congela T1 y T2.
4. PRUEBAS c o d en falla, o un 🔒 en FALLA en T1 → revierte a mano (sin `checkout`), verifica `git diff HEAD` = 0 en el template, T1 congelada, sin despliegue; `git restore docs/index.html`.
5. Un criterio de T1 no alcanzado, o un resultado visible no enumerado → misma acción que la regla 4, con la duda como pregunta cerrada. **No hay forma alternativa en la lista.**
6. PRUEBAS c o d en falla en T2 → `git restore docs/index.html`, sin commit de despliegue.

### Autorizaciones (lista cerrada)

- Commit de FASE 0 con el encargo y el registro de errores.
- Temporales en `/tmp/cat_a8_*`.
- Commit de T1 tras su verificación, y `git restore docs/index.html` tras su build.
- `git add` de la ruta absoluta de `docs/index.html` y commit de despliegue en T2.
- `git revert` de un commit propio si FASE R lo exige.
- `git push origin main` **una vez**, tras `docs(log)`, solo sin `BLOQUEADO`, con porcelain vacío y `HEAD..origin/main` = 0.
- Implícitas: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más: ni `rm` (lo temporal va con `mv` a `/tmp/cat_a8_basura/`), `reset`, `checkout --`, `rebase`, instalaciones ni operaciones de renv distintas de cargarlo.

### FASE 0 (con `esperado:` antes y `obtenido:` después)

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain antes y después del primer commit; stash; archivos del commit | antes: el registro modificado y el encargo; después: vacío o el LOG; stash vacío; commit = los dos | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `484c9f1` = `origin/main`; 0; 1 | regla 2 |
| M3 | md5 de `docs/index.html`; SHA con calibración; PRUEBAS d | `d58d2f2c…`; `d9895a78…0442`; calibración correcta; verde | regla 4 |
| M-DERIVA | retranspilación frente al bloque | idéntica | regla 3 |
| M4 | línea base del build de `HEAD` (19 estados y 11 N), con determinismo; C4 como en el a7 M5 | igual entre corridas; motor `d58d2f2c…`; cortada en los cuatro anchos; 44/43 | se registra |

### T1: C4

1. CSS de §1; build (PRUEBAS a), PRUEBAS c y d; `git restore docs/index.html` y md5 `d58d2f2c…`.
2. Verificación (`esperado:` antes), en N4 a 320, 360, 375 y 390 px, con cada pestaña activada por clic:
   - las 4 pestañas completas dentro de `.modal-tabs`;
   - `scrollWidth` ≤ `clientWidth`;
   - `scrollHeight − clientHeight` = 1 (el de la base);
   - `overflow` computado `visible` en los dos ejes;
   - **a 390, una sola fila con cualquier pestaña activa**;
   - a 375, 360 y 320, la cantidad de filas informada (se esperan 2);
   - subrayado de 2 px en las cuatro pestañas;
   - el clic cambia la activa;
   - separación visible entre pestañas de la misma fila ≥ 8 px (medida entre rectángulos).
   - Además: capturas a 1280 de los 19 estados idénticas a la base; 🔒7; 🔒8 en N4a a N4d; 🔒1 a 🔒6.
3. Commit `fix(motor): las pestañas del modal caben en pantallas angostas (a8 T1)`.

### T2: despliegue (solo si T1 terminó en verde)

1. Build con PRUEBAS a; `docs/index.html` queda con el build nuevo.
2. Verificación (`esperado:` antes):
   - PRUEBAS c y d sobre `docs/index.html`;
   - 🔒5;
   - por `file://`: 0 errores, las verificaciones de T1 repetidas y 🔒9;
   - C5 y C6 sin cambio frente al publicado (mediciones del a7);
   - `git status --short` = `M docs/index.html`.
3. Commit `deploy(motor): publica las pestañas del modal en pantallas angostas (a8)`.

### FASE R (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio. El inventario `R-01…` se anexa antes de auditar. Cada afirmación se re-deriva por otro camino:

- filas por bandas de tinta en captura 2× y subrayado por píxeles;
- 🔒7 por `innerText` frente al publicado, que ya incluye el `span` de C5, así que se esperan 30/30;
- SHA desde `git show` y en Python.

Incluye además:

- el comando y la salida literal de cada 🔒;
- el alcance: `git diff --name-only <inicio>..HEAD` debe dar el template, `docs/index.html`, el encargo, el registro de errores y el LOG;
- la regresión PRUEBAS a a d;
- el control positivo: `docs/index.html` de `<inicio>` corta «Establecimiento» en los cuatro anchos.

Veredicto por hallazgo (BLOQUEA / REPARA / ADVIERTE), con máximo 2 ciclos. Un BLOQUEA obliga a `git revert` del despliegue antes del push.

### FASE L (última, obligatoria)

El LOG lleva:

- resumen, commits e invariantes;
- md5 de `docs/index.html` desplegado;
- tabla de pestañas por ancho (posiciones, filas y separación);
- dudas con pregunta cerrada y errores propios;
- bloque J de trece campos;
- privacidad (script con control plantado → vacío);
- `grep -c '^esperado:'` = `grep -c '^obtenido:'` y `grep -c '^## J'` = 1.

Cierra con el commit `docs(log): pestañas del modal a8` y el push según la autorización.

## 5. Reporte final

- Primera línea: salida literal de `ls -l <LOG> && wc -l <LOG>` y hash de `docs(log)`.
- Segundo bloque: el bloque J tal cual.
- Después:
  - C4 antes → después por ancho;
  - resultados de 🔒5, 🔒7, 🔒8 y 🔒9;
  - hash del despliegue, md5 de `docs/index.html` y salida del push;
  - qué revisar en el sitio publicado (el modal de territorio en un teléfono, las cuatro pestañas);
  - lo que falló o sorprendió (si nada, decirlo).
