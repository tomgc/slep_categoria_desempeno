# Encargo autónomo: suite de documentación al día y `suitedoc` fuera de renv (a9)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten.**
- **EJECUCIÓN:** esfuerzo `high`; orquestador el modelo de la sesión; subagentes 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_categoria_desempeno`, macOS.
- **INSUMOS (en disco):**
  - `50_documentacion/suite/documentar.R` y los cuatro `*_standalone.html` y `suite_estilos.css` de esa carpeta;
  - `50_documentacion/activa/decisiones/20260925_decision_paleta_categorias_v2.md`;
  - `renv.lock`, `renv/activate.R` y `.Rprofile`;
  - `00_run_all.R`, `tests/auditar_cifras.R` y `tests/spot_check_publicado.R`;
  - SETTINGS §4.6 y §4.6.4 (protocolo `suitedoc`; en la knowledge base, **no** en el repo: lo que aplica está resumido en este encargo).
- **POSICIÓN:**
  - Rutas absolutas desde la raíz; ningún comando asume `cd`.
  - `bash` explícito; scripts en archivo, sin heredocs en zsh, sin `node -e` ni `Rscript -e` con más de una instrucción (las corridas R de varios pasos van en un `.R` en `/tmp/cat_a9_*`).
  - Temporales en `/tmp/cat_a9_*`.
  - Primer acto git: `fetch` y comparar `HEAD` con `origin/main`.
  - Ningún shell en segundo plano al terminar.
- **LOG:** `50_documentacion/andamios/logs/20260925_suite_documentacion_a9_log.md`
- **PUNTO DE RETORNO:** el hash del commit `chore(encargo): suite de documentación a9` es `<inicio>`.
- **Dos modos de R, declarados en cada corrida:**
  - **con renv** (arranque normal en la raíz, `RENV_PROJECT` impreso): pruebas del motor y `renv::status()`;
  - **sin renv** (`RENV_ACTIVATE_PROJECT=FALSE`, arranque en la raíz, `RENV_PROJECT` vacío impreso): solo la generación de la suite. `renv/activate.R` lee esa variable (fuente: `grep -n RENV_ACTIVATE_PROJECT renv/activate.R`, sesión 31 del chat). Si no la respeta, se aplica la regla 3.
- **Topes:** 3 intentos por tarea; 2 ciclos en FASE R; 1 reintento por falla transitoria (la red de npm incluida); un push denegado no se reintenta.
- **Reglas canónicas:**
  - Commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`.
  - El LOG no lleva RBD con número ni nombres de establecimiento.
  - Ningún hex nuevo fuera de la paleta v2 (los cuatro de §1 son de la paleta v2 y están permitidos solo en `documentar.R` y en los HTML generados).
  - No se toca el motor ni `docs/`.

## 1. Qué aprobó el titular (sesión 31 del chat, 2026-09-25)

- **Opción A para renv:** `.renvignore` con `50_documentacion/suite/`, y la suite se regenera fuera de renv. Aprobada con la respuesta "A" del titular en el chat.
- **Pendiente #2 del traspaso v30, con el criterio corregido.** El criterio heredado (`grep -c 'EE2D49\|E88663'` = 0 en `suite/`) mide un proxy: esas cadenas son tokens del tema de `suitedoc` (`--coral:#E88663` y `--mk-red:#EE2D49` en la línea 24 y la 30 de `suite_estilos.css`, repetidos en el CSS embebido de cada HTML), no la paleta de categorías (fuente: `grep -n` sobre la suite, sesión 31). `documentar.R` no cita ningún color de categoría. Lo que falta de verdad es que la suite documente las decisiones de la sesión 30. El tema **no se toca**.

**Lista cerrada de cambios:**

| Id | Cambio | Dónde |
|---|---|---|
| S1 | Archivo nuevo con una sola línea: `50_documentacion/suite/` | `.renvignore` (raíz) |
| S2 | Agregar dos entradas al final de `decisiones = list(...)`, después de la de "Portabilidad cross-OS" (hoy la séptima y última), con el texto exacto de §1.1 | `50_documentacion/suite/documentar.R` |
| S3 | Regenerar la suite con la llamada que `documentar.R` ya trae (`verificar = TRUE`, `standalone = TRUE`), sin cambiarla | los cuatro `*_standalone.html` (y `suite_estilos.css` si `suitedoc` lo reescribe) |

### 1.1 Texto de S2 (autoría del titular; se copia tal cual)

```r
    list(id='', titulo='Paleta de categorías con contraste WCAG 2.1 AA',
         cuerpo='<p>Cada categoría tiene un color fijo en todas las vistas, en orden de Insuficiente a Alto: Insuficiente <span class="inl">#D0112D</span>, Medio-Bajo <span class="inl">#E05D2F</span>, Medio <span class="inl">#2A8FD9</span> y Alto <span class="inl">#0062A0</span>. Las cabeceras de columna usan tonos más oscuros de la misma familia, con texto blanco.</p>',
         por_que='<strong>Por qué.</strong> Una auditoría figura-fondo del motor en 19 estados (septiembre de 2026) encontró textos, marcas y controles bajo los umbrales de WCAG 2.1 AA (4,5:1 para texto; 3:1 para gráficos y controles). Se recalibraron Insuficiente y Medio-Bajo, los grises de texto secundario y los bordes de los controles, y las cabeceras pasaron a tonos oscuros con texto blanco; tras el cambio no queda ninguna falla activa. Es un cambio de color: ninguna cifra cambia. Ver <span class="code-sm">50_documentacion/activa/decisiones/20260925_decision_paleta_categorias_v2.md</span>.'),
    list(id='', titulo='Orden temporal según la forma de la vista',
         cuerpo='<p>La trayectoria de cada establecimiento se lee de izquierda a derecha, de 2016 a 2019, con el año vigente a la derecha. El detalle por año, que es una lista vertical, empieza por el año vigente. La evolución de la matrícula va de lo más antiguo a lo más reciente.</p>',
         por_que='<strong>Por qué.</strong> Una línea de tiempo horizontal y corta se lee como un texto, de izquierda a derecha. Una lista vertical larga pone lo vigente arriba para no obligar a desplazarse hasta el final. Decisión de la sesión 30, registrada en el traspaso v30 y en el backlog del proyecto.')
```

La coma que separa la entrada de "Portabilidad cross-OS" de la primera nueva se agrega al cierre de esa entrada (`...')` pasa a `...'),`). No se cambia ningún otro carácter de `documentar.R`.

**Límites:** nada en `30_procesamiento/`, `docs/`, `20_insumos/`, `10_utils/`, `tests/`, `renv.lock` ni `renv/`. No se instala nada en renv. Tampoco se versiona `fonts/` ni `assets/`, que siguen ignorados.

## 2. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `d99801c`, árbol limpio (fuente: `git log` y `git status`, sesión 31). Hipótesis para el ejecutor; se verifica en M2.
- Porcelain esperado antes de lanzar: este encargo más ` M 50_documentacion/andamios/20260925_errores_asistente_sesion31.md` (una fila nueva). Hipótesis; se verifica en M1.
- `renv::status()` informa solo `suitedoc` como usado y no instalado (fuente: LOG a6, M0).
- No existe `.renvignore` (fuente: `ls`, sesión 31).
- `documentar.R` tiene 7 entradas `list(id=''` en `decisiones`, y la última es "Portabilidad cross-OS" en la línea ~180 (fuente: `grep -c` y `grep -n`, sesión 31).
- La suite se generó el 2026-06-24. `Agregación por conteo` aparece 1 vez en `documentacion_proyecto_…_standalone.html` y 0 en los otros tres (fuente: `ls -la` y `grep -c`, sesión 31).
- No se sabe si `suitedoc` está instalado en la biblioteca de usuario, ni su versión, ni si tiene `standalone` (hipótesis; se verifica en M4).
- No se sabe si hay `npm` y alcance al registro (hipótesis; se verifica en M5).

## 3. Invariantes 🔒

1. **Motor intacto:** `git diff <inicio>..HEAD -- 30_procesamiento docs 20_insumos 10_utils tests renv.lock renv | wc -l` → `0`.
2. **Motor sigue construyendo con renv:** `run_all(only = 33)` con renv activo, exit 0 y 0 warnings; SHA del payload normalizado `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`; `tests/auditar_cifras.R` y `tests/spot_check_publicado.R` en verde; `git restore docs/index.html` y md5 `2e408857208db6aa8eec094e8f10e5aa`.
3. **Suite offline:** en cada `*_standalone.html`, 0 referencias de red (`http://`, `https://`, `<link rel="stylesheet" href="http`, `src=`/`href=` a CDN); iconos como `<svg>` embebido (0 `data-lucide` y 0 `<script` de lucide); fuentes como `data:`.
4. **Solo los cuatro standalone:** tras generar, en `50_documentacion/suite/` no queda ningún `.html` que no termine en `_standalone.html`.
5. **Hex:** en las líneas agregadas de `documentar.R`, los únicos hex son `#D0112D`, `#E05D2F`, `#2A8FD9` y `#0062A0`.
6. **Tema sin cambio de autoría:** si `suite_estilos.css` cambia, el diff viene solo de `suitedoc` (no se edita a mano) y se declara en el LOG con su motivo (versión del paquete).

## 4. Tareas

Orden: FASE 0 → T1 (S1, renv) → T2 (S2 y S3, suite) → FASE R → FASE L. Un commit por tarea.

### Regla de detención

1. Stash no vacío, o porcelain antes del primer commit fuera de {este encargo, el registro de errores modificado, el LOG} → FASE L.
2. `HEAD` distinto de `origin/main` → FASE L.
3. `RENV_ACTIVATE_PROJECT=FALSE` no desactiva renv (`RENV_PROJECT` no vacío o `.libPaths()` con `renv/library`) → T2 congelada; T1 sigue.
4. `suitedoc` ausente de la biblioteca de usuario, o sin el argumento `standalone`, o `npm view` falla → T2 congelada con duda cerrada. **No se instala nada** (la instalación la decide el titular).
5. `generar_suite` aborta (verificación de residuos, icono inexistente u otro error) → T2 congelada. `git restore` de los HTML y el CSS de la suite; `documentar.R` revertido a mano; duda cerrada con el mensaje literal.
6. 🔒2 en falla tras T1 → `git revert` del commit de T1, T2 no corre.
7. Residual → se registra como duda con pregunta cerrada y se sigue con lo independiente.

### Autorizaciones (lista cerrada)

- Commit de FASE 0 con el encargo y el registro de errores.
- Temporales en `/tmp/cat_a9_*`.
- Commit de T1 (`.renvignore`) y de T2 (`documentar.R` y los archivos regenerados de la suite, con rutas explícitas).
- `git restore docs/index.html` tras el build de 🔒2.
- `git restore` de los HTML y el CSS de la suite si la regla 5 lo exige.
- `git revert` de un commit propio si FASE R o la regla 6 lo exigen.
- `git push origin main` **una vez**, tras `docs(log)`, solo sin `BLOQUEADO`, con porcelain vacío y `HEAD..origin/main` = 0.
- Implícitas: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más: ni `rm` (lo temporal va con `mv` a `/tmp/cat_a9_basura/`), `reset`, `checkout --`, `rebase`, instalaciones (R, renv o npm globales), `renv::snapshot()`, `renv::install()` ni `renv::restore()`. `npm pack` queda permitido solo dentro de `generar_suite`.

### FASE 0 (con `esperado:` antes y `obtenido:` después)

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain antes y después del primer commit; stash; archivos del commit | antes: el registro modificado y el encargo; después: vacío o el LOG; stash vacío; commit = los dos | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `d99801c` = `origin/main`; 0; 1 | regla 2 |
| M3 | `renv::status()` con renv, salida literal | solo `suitedoc` usado y no instalado | se registra |
| M4 | sin renv: `RENV_PROJECT`, `.libPaths()`, `packageVersion("suitedoc")`, `"standalone" %in% names(formals(suitedoc::generar_suite))`, y la versión de lucide-static que fija el paquete (buscada en su código) | `RENV_PROJECT` vacío; sin `renv/library`; versión impresa; `TRUE`; versión fijada impresa | regla 3 o 4 |
| M5 | `npm view lucide-static@<versión de M4> version` | imprime esa versión | regla 4 |
| M6 | línea base de la suite: md5 de los seis archivos versionados; texto visible de cada HTML extraído a `/tmp/cat_a9_base_*.txt` (etiquetas quitadas, espacios normalizados); conteo de `list(id=''` en `documentar.R` | md5 impresos; 4 textos; 7 | se registra |

### T1: S1 (renv)

1. Crear `.renvignore` con la línea de §1.
2. Verificación (`esperado:` antes):
   - `renv::status()` con renv ya no nombra `suitedoc`, con la salida literal (se espera "No issues found" o equivalente; cualquier otra salida se registra y, si nombra otro paquete, regla 7);
   - 🔒2 completo;
   - `git status --short` = `?? .renvignore` más el LOG.
3. Commit `chore(renv): excluye la suite de documentación del análisis de dependencias (a9 T1)`.

### T2: S2 y S3 (suite)

1. Editar `documentar.R` según §1.1. Verificar `list(id=''` = 9, `Rscript --vanilla -e 'invisible(parse("<ruta absoluta de documentar.R>"))'` sin error y `git diff --stat` = 1 archivo.
2. Generar **sin renv**, con un `.R` en `/tmp/cat_a9_generar.R` que haga `setwd(<raíz>)` y `source("50_documentacion/suite/documentar.R")`, e imprima al inicio `RENV_PROJECT` y `.libPaths()`. Salida literal al LOG.
3. Verificación (`esperado:` antes):
   - 🔒3 y 🔒4 por archivo;
   - `Paleta de categorías con contraste WCAG 2.1 AA` y `Orden temporal según la forma de la vista`: al menos 1 vez en `documentacion_proyecto_…_standalone.html`, y el conteo por archivo de los cuatro se informa (la ubicación de las decisiones la decide `suitedoc`);
   - `Agregación por conteo` con el mismo conteo por archivo que en M6;
   - diff de texto visible contra M6 por archivo: las dos decisiones nuevas y, si las hay, diferencias de plantilla de `suitedoc` (versión distinta a la de junio) **listadas y clasificadas**, nunca omitidas; una diferencia que no venga de S2 ni de la plantilla, regla 7;
   - 🔒5, 🔒6 y 🔒1;
   - `git status --short` = `documentar.R`, los HTML y (si cambió) el CSS, más el LOG; `fonts/` y `assets/` sin aparecer (`git check-ignore`).
4. Commit `docs(suite): documenta la paleta v2 con contraste AA y el orden temporal; regenera la suite (a9 T2)`.

### FASE R (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio. El inventario `R-01…` se anexa antes de auditar. Cada afirmación se re-deriva por un camino distinto:

- decisiones buscadas en el DOM renderizado con Puppeteer, si antes fue por `grep`;
- red contada por parseo del HTML, si antes fue por `grep`;
- `renv::status()` repetido en un proceso R nuevo.

Además: comando y salida literal de cada 🔒; alcance (`git diff --name-only <inicio>..HEAD` → `.renvignore`, `documentar.R`, los HTML de la suite, el CSS si cambió, el encargo, el registro de errores y el LOG); control positivo (el HTML de `<inicio>` no contiene los dos títulos nuevos). Veredicto por hallazgo (BLOQUEA / REPARA / ADVIERTE), con máximo 2 ciclos.

### FASE L (última, obligatoria)

El LOG lleva:

- resumen, commits e invariantes;
- versión de `suitedoc` y de lucide-static;
- salidas literales de `renv::status()` antes y después;
- tabla por archivo de la suite (md5 antes/después, red, iconos, fuentes, conteo de títulos);
- lista clasificada de diferencias de texto;
- dudas con pregunta cerrada y errores propios;
- bloque J de trece campos;
- privacidad (script con control plantado → vacío);
- verificación del archivo: `grep -c '^esperado:'` = `grep -c '^obtenido:'`, y `grep -c '^## J'` = 1.

Cierra con el commit `docs(log): suite de documentación a9` y el push según la autorización.

## 5. Reporte final

- Primera línea: salida literal de `ls -l <LOG> && wc -l <LOG>` y hash de `docs(log)`.
- Segundo bloque: el bloque J tal cual.
- Después:
  - `renv::status()` antes → después;
  - versión de `suitedoc`;
  - tabla por archivo de la suite;
  - dónde aparecen las dos decisiones nuevas;
  - diferencias de plantilla, si las hubo;
  - resultado de 🔒1 a 🔒6;
  - salida del push;
  - qué abrir para revisar (el HTML de documentación del proyecto, sección de decisiones);
  - lo que falló o sorprendió (si nada, decirlo).
