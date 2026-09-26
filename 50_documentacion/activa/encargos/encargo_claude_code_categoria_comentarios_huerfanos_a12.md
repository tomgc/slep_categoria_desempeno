# Encargo autónomo: retiro de los 11 comentarios huérfanos del CSS del motor, y despliegue (a12)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten.**
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0 (cadena en serie con despliegue: tabla §2.12 del instrumento de encargos, filas 1 y 2). Si la sesión está en otro modo, el encargo manda y el LOG lo declara.
- **Actos externos y su autorización (D5 = a, decisión del titular del 2026-09-26):** este encargo tiene **un solo** acto externo, `git push origin main`, en FASE L. El OK del titular viaja en el mensaje de lanzamiento. Cualquier otro acto externo se consulta.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS), lanzado en la raíz del repo `slep_categoria_desempeno`. Todo script empieza con `RAIZ="$(git rev-parse --show-toplevel)"`. FASE 0 verifica que `basename "$RAIZ"` = `slep_categoria_desempeno` y que `origin` = `https://github.com/tomgc/slep_categoria_desempeno.git`. **Ninguna ruta absoluta con nombre de usuario entra a un archivo versionado:** en el LOG, `$RAIZ` se escribe `<RAIZ>`.
- **INSUMOS (en disco):**
  - este encargo y `50_documentacion/andamios/20260925_errores_asistente_sesion32.md` (modificado, 8 filas; van juntos en el commit de FASE 0);
  - `30_procesamiento/33_motor_template.html` (CSS en el bloque `<style>`, líneas 8 a 940) y `30_procesamiento/33_app.jsx`;
  - `30_procesamiento/33_generar_html.R`, `00_run_all.R`, `tests/auditar_cifras.R`, `tests/spot_check_publicado.R`;
  - LOG del a10 (`50_documentacion/andamios/logs/20260925_css_muerto_a10_log.md`): la lista de los 11 comentarios huérfanos (sección «Comentarios huérfanos»), la receta de M-DERIVA y la del SHA del payload (M3), y la medición de render;
  - LOG del a11b (`50_documentacion/andamios/logs/20260926_autorizacion_datos_y_pr_a11b_log.md`): el verificador Python del SHA (FASE R, paso 5);
  - encargo a6 (`50_documentacion/activa/encargos/encargo_claude_code_categoria_defectos_narrativa_ui_a6.md`), POSICIÓN: dónde vive el Puppeteer que usaron los encargos a6 a a10 y la receta de Babel.
- **POSICIÓN:**
  - `bash` explícito; scripts en archivo (`/tmp/cat_a12_*`), sin heredocs en zsh y sin `Rscript -e` de varios pasos. Nada de `echo` con cadenas de `=` en zsh.
  - git de lectura con `GIT_OPTIONAL_LOCKS=0`, **desde el primer comando**, y `fetch` con `-c maintenance.auto=false` como primer acto git.
  - Toda corrida R arranca en la raíz con renv activo.
  - Puppeteer con Chrome del sistema, motor por `file://`, con `*{transition:none!important;animation:none!important}` inyectado antes de medir. Si el Puppeteer de los encargos anteriores no está, se instala `puppeteer-core` en `/tmp/cat_a12_node` (autorizado).
  - Babel en `/tmp/cat_a12_babel`: se copia de una carpeta `/tmp/cat_a*_babel` anterior o se instala con `npm install` de `@babel/cli`, `@babel/core` y `@babel/preset-react`, con la configuración `{"presets":[["@babel/preset-react",{"runtime":"classic"}]]}`.
  - Ningún shell en segundo plano al terminar. El checkout queda en `main`.
- **LOG:** `50_documentacion/andamios/logs/20260926_comentarios_huerfanos_css_a12_log.md`
- **PUNTO DE RETORNO:** el hash del commit `chore(encargo): comentarios huérfanos del CSS a12` en `main` es `<inicio>`.
- **ALCANCE:** T1: `30_procesamiento/33_motor_template.html`. T2: `docs/index.html`. FASE L: el LOG.
- **PRUEBAS:**
  - (a) `run_all(only = 33)` con renv activo: exit 0 y 0 warnings. Fuera de T2, `git restore docs/index.html` después de cada build;
  - (b) `tests/auditar_cifras.R` (F1 a F4) y `tests/spot_check_publicado.R` en verde con renv activo;
  - (c) SHA del payload normalizado (solo la fecha) = `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`, con calibración: fecha alterada → igual; cifra plantada → distinto.
- **Topes:** 3 intentos por bug; 2 ciclos en FASE R; 1 reintento por falla transitoria; un push denegado no se reintenta.
- **Reglas canónicas:**
  - Commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify` ni `--force`; sin `Co-Authored-By` ni atribución a la herramienta.
  - LOG sin RBD con número, sin nombres de establecimiento ni de personas, sin literales con forma de RUT.
  - **Solo se borra:** en el template, solo salen las 26 líneas de §1; ningún carácter se agrega. El bloque transpilado no se toca (M-DERIVA antes y después).

## 1. Qué aprobó el titular (sesión 32 del chat)

Prioridad 2 de la ruta de la sesión 32 («P1 y P2 separados»): los 11 comentarios huérfanos que dejó el a10 en el `<style>` del template. P1 (ordenación, a11 y a11b) ya está mergeada en `main` = `568b418` (fuente: salida de `git pull` del titular, sesión 32).

**Medición del redactor (sesión 32, sobre el template en `main` = `568b418`):**

- md5 `fce2d439d4571f3bdd37fd85ecab8d47`; 111216 bytes; 2588 líneas por `wc -l`; `<style>` en las líneas 8 a 940 (fuente: `md5sum`, `wc -lc`, `grep -n`).
- 79 comentarios en el `<style>` (fuente: `re.findall(r'/\*.*?\*/', …, re.S)` sobre el texto entre `<style>` y `</style>`).
- El template no cambió desde el a10: su último commit es `596d1fb` (fuente: `git log -- 30_procesamiento/33_motor_template.html 30_procesamiento/33_app.jsx`). Por eso se espera el M-DERIVA del a10: bloque y retranspilación con md5 `84d079b74d35d93e0412f457020fc066` y 1614 líneas (fuente: LOG a10, M-DERIVA).

**Los 11 comentarios (lista cerrada; son los mismos del LOG a10, con su línea actual):**

| # | Líneas | Comentario | Qué lo sigue hoy |
|---|---|---|---|
| 1 | 280 | «Entities» | otro comentario («Buttons») |
| 2 | 293 | «Results» | otro comentario |
| 3 | 294 y 295 | «Fila única bajo el título: controles a la izquierda, leyenda a la derecha (mockup)…» | otro comentario |
| 4 | 296 y 297 | «La cabecera de la tabla conserva el layout horizontal…» | líneas vacías y «Tooltip» |
| 5 | 314 | «Tabla» | líneas vacías y «Footer» |
| 6 | 479 | «Filtro GSE» | el encabezado de sección «Vista de Categoría de Desempeño» |
| 7 | 930 | «Foco año en tabla» | otro comentario |
| 8 | 932 | «Celda vacía GSE: sin recuadro, fondo transparente» | otro comentario |
| 9 | 934 | «Heatmap fijo» | otro comentario |
| 10 | 936 | «Entities-bar: selector nueva estructura» | otro comentario |
| 11 | 938 | «Estab popup trigger en entidad chip» | `</style>` |

**Cambio (lista cerrada de líneas a borrar, numeración del template de md5 `fce2d439…`):** `280, 281, 293, 294, 295, 296, 297, 298, 299, 300, 301, 314, 315, 316, 479, 480, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939`. Son 26 líneas: 13 de los 11 comentarios y 13 vacías.

La regla que produce la lista es borrar las líneas de los comentarios y, en cada racha de líneas vacías que toca una línea borrada, conservar solo la primera línea vacía. El resultado deja una sola línea vacía entre bloques. La cuenta la hizo el redactor en la sesión 32 con un script sobre el archivo (fuente: script de medición del redactor):

- 111216 → 110703 bytes (−513);
- 2588 → 2562 líneas por `wc -l`;
- `<style>` en las líneas 8 a 914;
- 68 comentarios en el `<style>` (79 − 11);
- la racha máxima de líneas vacías dentro del `<style>` queda en 1;
- md5 del template nuevo `1b615464115cdaefb384c206c1a4f620`.

**Forma de implementación:** un script propio (`/tmp/cat_a12_borrar.py` o `.R`). Primero verifica el md5 de partida (`fce2d439…`), después borra por número las 26 líneas y escribe el archivo conservando el salto de línea final. No se usa `sed` por patrón.

## 2. Estado de partida (premisas marcadas)

- `main` = `origin/main` = `568b418` (merge del PR #3), con una sola modificación sin commitear: ` M 50_documentacion/andamios/20260925_errores_asistente_sesion32.md` (fuente: salida de `git status --short` del titular, sesión 32). Hipótesis para el ejecutor; se mide en M1 y M2. El porcelain tendrá además `?? ` de este encargo.
- `docs/index.html` tiene md5 `587f4233baf7561f332235780a04805a`, igual al publicado (fuente: `md5sum`, sesión 32; `curl` del sitio, apertura de la sesión 32). Hipótesis; se mide en M3.
- Puppeteer, Chrome del sistema y Babel están disponibles o se pueden instalar en `/tmp` (hipótesis, se mide en M4).
- El verificador del SHA del a11b sigue en `/tmp` (hipótesis, se mide en M3; si no está, se rearma desde el LOG a10, M3, y el LOG a11b, FASE R paso 5).

## 3. Invariantes 🔒

1. **Solo borrado y solo en el `<style>`:**
   - `git diff --numstat <inicio>..HEAD -- 30_procesamiento/33_motor_template.html` → `0	26	30_procesamiento/33_motor_template.html`;
   - cada línea borrada es vacía o pertenece a uno de los 11 comentarios, y todas están entre las líneas 8 y 940 de la base.
2. **Template esperado:**
   - md5 `1b615464115cdaefb384c206c1a4f620`, 110703 bytes y 2562 líneas;
   - 68 comentarios en el `<style>`;
   - 0 apariciones de cada uno de los 11 textos;
   - racha máxima de líneas vacías en el `<style>` = 1.
3. **Nada fuera del `<style>` cambia:** el SHA-256 del texto desde `</style>` hasta el final, y del texto hasta `<style>` inclusive, es igual antes y después. M-DERIVA, antes y después: el bloque de la app = la retranspilación de `33_app.jsx` (`84d079b7…`, 1614 líneas).
4. **Mismo CSSOM:** en Chrome, sobre el motor construido antes y después, `[...document.styleSheets].flatMap(s => [...s.cssRules].map(r => r.cssText))` da la misma lista (misma cantidad y mismo texto, en orden). Calibración en FASE 0: una copia del motor base con una regla viva borrada (por ejemplo, `.entity-select-btn`) da una lista distinta.
5. **Render igual:**
   - `textContent` de `#root` idéntico;
   - capturas con AE = 0 del estado inicial a 1280 px y a 390 px, y del modal abierto a 390 px, antes contra después (transiciones y animaciones desactivadas).
6. **Cifras intactas:** PRUEBAS b y c.
7. **Despliegue fiel:** tras T2, md5 de `docs/index.html` = md5 de `40_salidas/motor_categoria.html`. Además, bytes de `docs/index.html` = bytes del build base de M5 − 513. Cuenta: el template va entero al motor y solo cambian las 26 líneas; la fecha de generación conserva su largo. Si el largo de la fecha difiere, la diferencia se explica con la fecha y no es FALLA.
8. **Alcance:** `git diff --name-only <inicio>..HEAD` = {`30_procesamiento/33_motor_template.html`, `docs/index.html`, el LOG}.
9. **Sin coautoría, RUT ni rutas de usuario** en lo agregado:
   - `git log <inicio>..HEAD --format=%B | grep -ci co-authored` → 0;
   - `git diff <inicio>..HEAD | grep '^+' | grep -cE '[0-9]{1,2}\.?[0-9]{3}\.?[0-9]{3}-[0-9kK]'` → 0;
   - `... | grep -cF "$HOME"` → 0.

## 4. Tareas

Grafo: T1 → T2 (T2 requiere T1 completada). FASE R y FASE L corren siempre, en ese orden, con una tarea congelada incluida.

### Regla de detención

1. Porcelain, stash, rama o `HEAD` de M1 y M2 distintos de lo esperado → FASE L, sin push.
2. md5 de partida del template distinto de `fce2d439…`, o la lista de M6 distinta de §1 → T1 congelada (no se recalcula ninguna lista).
3. M-DERIVA con diferencias → T1 y T2 congeladas.
4. Un 🔒 en FALLA en T1 → `git restore 30_procesamiento/33_motor_template.html`, T1 congelada, sin T2.
5. PRUEBAS b o c en falla en T2 → `git restore docs/index.html`, sin commit de despliegue.
6. Simulacro del hook distinto de exit 0, o push denegado → no se empuja ni se reintenta; queda al titular.
7. Cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda con pregunta cerrada y pasa a la siguiente independiente (aquí, a FASE R).

### Autorizaciones (lista cerrada)

- Commit de FASE 0 con el encargo y el archivo de errores.
- Temporales en `/tmp/cat_a12_*`; instalación local de `puppeteer-core` o de Babel allí, si M4 lo exige.
- Commit de T1 tras su verificación; `git restore docs/index.html` tras cada build fuera de T2.
- `git restore` del template si la regla 4 lo exige.
- `git add` de `docs/index.html` y commit de despliegue en T2.
- `git revert` de un commit propio si FASE R lo exige.
- `git push origin main` **una vez**, en FASE L, con el OK del mensaje de lanzamiento. Solo si no hay `BLOQUEADO`, el porcelain está vacío, `HEAD..origin/main` = 0 y el simulacro del hook dio exit 0.
- Implícitas: `fix(auditoria): R-NN …` y `docs(log): comentarios huérfanos del CSS a12`.

Nada más:

- ni `rm`, `reset`, `checkout --`, `rebase`, `merge`, `--no-verify` ni `--force`;
- ni ediciones fuera de los ALCANCE;
- ni operaciones de renv distintas de cargarlo.

### FASE 0

Primer acto: crear el LOG con el encabezado, el slot `## J. Juicio (lo rellena FASE L)` y el esqueleto. Cada medición lleva `esperado:` antes y `obtenido:` después.

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | rama; porcelain; stash | `main`; ` M ...20260925_errores_asistente_sesion32.md`, `?? ...a12.md` y el LOG; vacío | regla 1 |
| M2 | `git -c maintenance.auto=false fetch origin`; `HEAD`; `origin/main`; deltas; basename y remoto; `grep -c '^| [A-Z]'` del archivo de errores | exit 0; `568b418` = `origin/main`; 0 y 0; los de ENTORNO; 8 filas | regla 1 |
| M3 | commit de FASE 0 (2 rutas); `<inicio>`; md5 del template y de `docs/index.html`; SHA del payload con calibración; PRUEBAS b | commit = 2 archivos; `fce2d439…`; `587f4233…`; `d9895a78…0442` y calibración correcta; verde | regla 2 para el template; si falla la PRUEBA c, se registra como ADVIERTE (el 🔒4 y el 🔒5 cubren el render) |
| M4 | Chrome del sistema; Puppeteer; Babel | disponibles o instalados en `/tmp/cat_a12_*` | sin Puppeteer, T1 congelada; sin Babel, regla 3 |
| M-DERIVA | retranspilación de `33_app.jsx` frente al bloque del template | idéntica: `84d079b7…`, 1614 líneas | regla 3 |
| M5 | build base (PRUEBAS a) y copia a `/tmp/cat_a12_base.html`, con sus bytes; CSSOM, `textContent` y las 3 capturas de la base, dos veces (determinismo); calibración del 🔒4 con la regla borrada | exit 0; `docs/index.html` restaurado; dos corridas iguales; la calibración da una lista distinta | se registra |
| M6 | las 11 filas de §1 re-medidas: texto de cada línea de la lista de borrado (comentario o vacía) y 79 comentarios en el `<style>` | igual a §1 | regla 2 |

Último acto: anexar la sección `### FASE 0`.

### T1: retiro de los 11 comentarios

1. El script de §1 verifica el md5 de partida y borra las 26 líneas.
2. Verificación (`esperado:` antes):
   - 🔒1, 🔒2 y 🔒3 (M-DERIVA repetido);
   - build (PRUEBAS a), 🔒4 y 🔒5 contra la base de M5, 🔒6;
   - `git restore docs/index.html`, con md5 `587f4233…`.
3. Commit `refactor(motor): retira los 11 comentarios huérfanos del CSS (a12 T1)`, solo con el template.

### T2: despliegue (solo si T1 terminó en verde)

1. Build con PRUEBAS a; `docs/index.html` queda con el build nuevo.
2. Verificación (`esperado:` antes):
   - 🔒7;
   - PRUEBAS b y c sobre `docs/index.html`;
   - por `file://`, 0 errores de consola y 🔒5 contra la base;
   - `git status --short` = `M docs/index.html` (más el LOG).
3. Commit `deploy(motor): publica el motor sin comentarios huérfanos del CSS (a12)`.

### FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio.

1. **Inventario** `R-01…` desde el LOG, antes de auditar.
2. **Re-derivación con otro comando:**
   - diff: `git show --stat` y `diff` de `git show <inicio>:<template>` contra `HEAD:<template>` con otra herramienta (`difflib` de Python), clasificando cada línea borrada;
   - CSSOM: con `postcss` (sin comentarios) sobre los dos `<style>`, si antes fue con Chrome;
   - md5 y bytes: con `shasum` y `stat`;
   - SHA: desde `git show HEAD:docs/index.html`, con otra implementación.
3. **Invariantes:** comando de cada 🔒, PASA/FALLA con salida literal.
4. **Alcance global** (🔒8) y `git status --porcelain`.
5. **Regresión:** PRUEBAS a, b y c sobre el estado final.
6. **Control positivo:**
   - en una copia fuera del árbol, una línea no vacía borrada de más (por ejemplo, un `}`) es detectada por el chequeo del 🔒1;
   - una regla viva borrada en una copia del motor es detectada por el 🔒4.
7. **Veredicto por hallazgo:** BLOQUEA (🔒 en FALLA, alcance, historia), REPARA (defecto propio dentro del ALCANCE) o ADVIERTE.
8. **Máximo 2 ciclos:** causa raíz, fix, re-verificación doble, regresión, commit `fix(auditoria): R-NN …` y fila en la tabla. Un BLOQUEA después de T2 obliga a `git revert` del despliegue antes del push.
9. **Prohibido:** ajustar criterios o esperados, ampliar un ALCANCE, tocar un 🔒, editar lo ya escrito en el LOG, reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto global.

### FASE L: cierre del log (última, obligatoria)

1. `git status --porcelain` = solo el LOG; otra cosa es hallazgo.
2. Cierre del LOG:
   - resumen;
   - commits (`git log --oneline <inicio>..HEAD` y el de FASE 0);
   - tabla de FASE R;
   - 🔒 con evidencia;
   - bytes antes y después del template y del motor;
   - dudas con pregunta cerrada;
   - errores propios;
   - notas para el revisor.
3. Bloque J de trece campos, copiado del detalle.
4. Privacidad sobre el LOG: grep de RUT vacío, `grep -cF "$HOME"` = 0, sin nombres de establecimiento ni de personas.
5. `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. Commit `docs(log): comentarios huérfanos del CSS a12` (solo el LOG).
7. Simulacro del hook para el push:

   ```
   printf 'refs/heads/main %s refs/heads/main %s\n' "$(git rev-parse HEAD)" "$(git rev-parse origin/main)" | bash "$HERRAMIENTAS_DEV_PATH/githooks/pre-push" origin https://github.com/tomgc/slep_categoria_desempeno.git
   ```

   Esperado exit 0. Después, `git push origin main` (el único, autorizado en el lanzamiento).
8. Después del push, con el comando literal en el reporte (no en el LOG, ya commiteado): `curl -s https://tomgc.github.io/slep_categoria_desempeno/ | md5`, hasta 10 intentos cada 30 s. Esperado: igual al md5 de `docs/index.html`. Si no llega, ADVIERTE y queda al titular.

## 5. Reporte final

- **Primera línea:** la salida literal de `ls -l <LOG> && wc -l <LOG>` y el hash de `docs(log)`.
- **Segundo bloque:** el bloque J tal cual.
- **Después:**
  - las 26 líneas borradas, clasificadas;
  - md5 y bytes del template y del motor, antes y después;
  - resultado de cada 🔒;
  - PRUEBAS a, b y c;
  - hash del despliegue;
  - simulacro del hook y salida del push;
  - md5 del sitio publicado;
  - qué revisar en el sitio (una pasada visual: nada debería verse distinto);
  - lo que falló o sorprendió (si nada, decirlo).
