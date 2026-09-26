# Encargo autónomo: ordenación del repositorio (a11)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten.**
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0 (cadena que escribe en serie y publica una rama: tabla §2.12 del instrumento de encargos, filas 1 y 2). Si la sesión está en otro modo, el encargo manda y el encabezado del LOG lo declara.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS), lanzado en la raíz del repo `slep_categoria_desempeno`. Todo script empieza con `RAIZ="$(git rev-parse --show-toplevel)"` y usa rutas `"$RAIZ/<ruta>"`. FASE 0 verifica que `basename "$RAIZ"` = `slep_categoria_desempeno` y que `git -C "$RAIZ" remote get-url origin` = `https://github.com/tomgc/slep_categoria_desempeno.git`. **Ninguna ruta absoluta con nombre de usuario entra a un archivo versionado** (LOG, marcador, mensajes de commit, cuerpo del PR): en el LOG, `$RAIZ` se escribe como `<RAIZ>` y `RENV_PROJECT` como su `basename`.
- **INSUMOS (en disco, rutas desde la raíz):**
  - este encargo y `50_documentacion/andamios/20260925_errores_asistente_sesion32.md` (van juntos en el commit de FASE 0);
  - `50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md`, §4.7 (protocolo de esta tarea), y `50_documentacion/activa/POLITICA_PROYECTO.md`, §1.5, §2 y §7;
  - `00_escanear_proyecto.R`, `.gitignore`, `50_documentacion/activa/gobernanza_datos.md`;
  - `00_run_all.R`, `tests/auditar_cifras.R`, `tests/spot_check_publicado.R`;
  - el LOG del a10 (`50_documentacion/andamios/logs/20260925_css_muerto_a10_log.md`), sección M3, con la receta del SHA normalizado del payload y su calibración.
- **POSICIÓN:**
  - `bash` explícito; scripts en archivo (`/tmp/cat_a11_*.sh`, `/tmp/cat_a11_*.R`), sin heredocs en zsh y sin `Rscript -e` de varios pasos.
  - git de lectura con `GIT_OPTIONAL_LOCKS=0`. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`.
  - Toda corrida R arranca en la raíz con renv activo.
  - Temporales en `/tmp/cat_a11_*`; una copia del árbol para controles positivos en `/tmp/cat_a11_copia*` (con `rsync -a --exclude .git`).
  - Ningún shell en segundo plano al terminar.
- **LOG:** `50_documentacion/andamios/logs/20260925_ordenacion_repositorio_a11_log.md`
- **PUNTO DE RETORNO:** el hash del commit `chore(encargo): ordenación del repositorio a11` en `main` es `<inicio>`. La rama de trabajo `ordenacion/20260925` nace de `<inicio>`.
- **ALCANCE:** por tarea, en §4. La unión de todos es el alcance global de FASE R.
- **PRUEBAS:**
  - (a) `run_all(only = 33)` con renv activo: exit 0 y 0 warnings; si el build modificó `docs/index.html`, `git restore docs/index.html` y md5 = `587f4233baf7561f332235780a04805a`;
  - (b) `tests/auditar_cifras.R` (F1 a F4) y `tests/spot_check_publicado.R` en verde con renv activo;
  - (c) SHA del payload normalizado = `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`, con la receta y la calibración del LOG a10 (M3).
- **Topes:** 3 intentos por bug; 2 ciclos en FASE R; 1 reintento por falla transitoria; un push denegado no se reintenta.
- **Reglas canónicas:**
  - Commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`.
  - Mensajes de commit y cuerpo del PR sin `Co-Authored-By` ni atribución de coautoría a la herramienta (SETTINGS §4.7.3, punto 5).
  - LOG sin RBD con número, sin nombres de establecimiento ni de personas, sin rutas con nombre de usuario.
  - **Nada se borra:** lo que sale del árbol vivo va a `_archivo/20260925/` conservando su ruta relativa (POLITICA §1.5; SETTINGS §4.7.4). La única eliminación permitida es la poda propia del escáner (POLITICA §7.4).
  - **Nada en `30_procesamiento/` ni en el pipeline** (SETTINGS §4.7.4). Los 11 comentarios huérfanos del CSS **no** van en este encargo: son el a12.

## 1. Qué aprobó el titular (sesión 32 del chat, 2026-09-25)

Ruta «P1 y P2 separados». Este encargo es P1: el pendiente #4 del traspaso v31 (ordenación del repositorio, política v5.5, SETTINGS §4.7), **sin** los comentarios huérfanos del `<style>`. Esos comentarios viven en `30_procesamiento/33_motor_template.html`, y SETTINGS §4.7.4 prohíbe tocar `30_procesamiento/` y mezclar la ordenación con cambios de contenido. El a12 los retira después del merge de este PR.

El asistente midió el inventario en la sesión 32 sobre `HEAD` = `52b8dab`. FASE 0 lo vuelve a medir (M7) y **no agrega filas**: una fila que no calce se cancela y se registra.

**Regla de referencias históricas (decisión del redactor, declarada).** Estas referencias son registro histórico y no cancelan una fila: las que están en `50_documentacion/traspasos/archivo/`, `50_documentacion/andamios/` y `50_documentacion/estructura/`, en `50_documentacion/activa/backlog_acumulativo.md` y en `50_documentacion/activa/encargos/`. Esos archivos no se reescriben (POLITICA §1.2 y §1.3.1; SETTINGS §2.2.5). Tampoco cancela una fila una referencia desde un archivo que se mueve en el mismo commit. El grep de referencias vivas es el de SETTINGS §4.7.2: `grep -rn --exclude-dir=_archivo --exclude-dir=.git --exclude-dir=renv "<nombre>" "$RAIZ"`. Cada coincidencia va al LOG clasificada como viva o histórica.

**Mecánica del archivado de un archivo versionado.** `_archivo/` está en `.gitignore` (línea 25) y fuera de Git (POLITICA §1.5). Por eso el movimiento es `mkdir -p` del destino, `mv` del archivo y `git rm --cached -q -- <ruta de origen>`. El archivo queda en disco en `_archivo/20260925/<ruta>` y su historia queda en git. Un `git mv` hacia una ruta ignorada lo dejaría versionado dentro de `_archivo/`. La prohibición de `cp` + `rm` de §4.7.4 rige para lo que sigue en Git (traspasos, renombres), y aquí no se usa ninguna de las dos cosas.

### Bloque 1: traspasos y normativos (solo comprobación)

| Id | Qué | Estado medido | Tratamiento |
|---|---|---|---|
| B1-1 | `50_documentacion/traspasos/*.md` | 1 archivo, `traspaso_cierre_v31.md` (fuente: `ls ... \| wc -l`, sesión 32) | comprobación; sin movimiento |
| B1-2 | `POLITICA_PROYECTO.md` y `SETTINGS_Y_PROMPTS_OPERACIONALES.md` de `activa/` frente al kit | encabezados `Versión 5.8 — vigente.` y `Versión 38.`; el eco de `/apertura` los declara al día (fuente: `grep -m1` y eco de `/apertura`, sesión 32) | comprobación con `cmp` contra `$HERRAMIENTAS_DEV_PATH/gobernanza/`; si difieren, T1 congelada (este encargo no edita normativos) |

### Bloque 2: obsoletos y duplicados

| Id | Ruta | Versionado | Grado | Evidencia | Tratamiento |
|---|---|---|---|---|---|
| B2-1 | `50_documentacion/activa/P-matricula-actual_alcance.md` | sí; `git hash-object` `71d8fb1aa1dc2862fcfbff3877991372533fa1d2` (fuente: sesión 32) | medio | documento de alcance «bloqueado por dato» de la sesión 10. El traspaso v11 declara que no faltaba el dato, y la cobertura 2016-2025 se implementó (backlog c.57 y c.58) (fuente: `traspaso_cierre_v11.md` líneas 29 y 105; tabla de Clasificación temática, sesión 32). Referencias: solo `traspasos/archivo/` v10 y v11 (fuente: grep, sesión 32) | grep; si solo hay referencias históricas, a `_archivo/20260925/50_documentacion/activa/` |
| B2-2 | `50_documentacion/activa/P-matricula-grado_alcance.md` | sí; `1449e5baf7b697f439aa0942ae8ef56a20334f7c` (fuente: sesión 32) | medio | alcance «BLOQUEADO por dato» de la sesión 10. La matrícula por grado se implementó en v12 (c.60 y c.61) y se retiró en v16 y v17 (c.74 y c.81) (fuente: tabla de Clasificación temática, sesión 32). Referencias: B2-1 (se mueve en el mismo commit) y `traspasos/archivo/` v10 y v11 (fuente: grep, sesión 32) | igual que B2-1, en el mismo commit |
| B2-3 | `20_insumos/auxiliares/prompt_nuevo_proyecto_categoria_desempeno.md` | sí; `3375431a8cd5a2beaadf8270a18a2dac9de2a208` (fuente: sesión 32) | medio | prompt de apertura NEW PROJECT: documentación fuera de `50_*`. 0 referencias (fuente: grep, sesión 32). `30_construir_auxiliares.R` lee archivos nombrados, no el directorio (fuente: `grep -n auxiliares`, sesión 32) | grep; a `_archivo/20260925/20_insumos/auxiliares/` |
| B2-4 | `50_documentacion/traspasos/.Rhistory` | no; ignorado por `.gitignore:2`, 0 bytes (fuente: `git check-ignore -v` y `ls -la`, sesión 32) | alto (residuo de sesión) | una carpeta de traspasos no guarda historial de R | `mv` a `_archivo/20260925/50_documentacion/traspasos/`; no aparece en ningún commit |
| cancelada | `20_insumos/auxiliares/31_depurar_directorio_oficial.R` | sí | n/a | referencias vivas: `.gitignore:38`, `gobernanza_datos.md:82` y `:101` (que fija su ubicación) y `30_procesamiento/30_construir_auxiliares.R:56` (fuente: grep, sesión 32) | no se mueve; va al LOG y al marcador como excepción ubicada por gobernanza |
| duda | `10_utils/d3.min.js`, `pako.min.js`, `react-dom.production.min.js`, `react.production.min.js` | sí | bajo | librerías de terceros en la carpeta de utilidades R; las citan `33_generar_html.R` y `00_run_all.R` (fuente: grep, sesión 32); moverlas toca el pipeline | no se mueven; duda D1 |
| duda | `tests/reportes/` | no; ignorado por `.gitignore:28`; 45 archivos (fuente: `ls \| wc -l`, sesión 32) | bajo | reportes con sello que escribe `tests/auditar_cifras.R` | no se mueven; duda D2 |

`50_documentacion/andamios/` está congelado: ninguno de sus archivos es candidato.

### Bloque 3: nomenclatura de `50_documentacion/activa/`

| Id | Origen | Destino | Evidencia | Tratamiento |
|---|---|---|---|---|
| B3-1 | `50_documentacion/activa/resena_slep_categoria_desempeno.md` (`430074a074596885972cf56d75fafcfa2c35cd59`) | `50_documentacion/activa/50_resena_slep_categoria_desempeno.md` | 0 apariciones en POLITICA y SETTINGS de `activa/`. Referencias: solo `traspasos/archivo/` v26 y v27 (fuente: grep, sesión 32) | grep en los normativos (esperado 0); `git mv`; las referencias vivas, si M7 encuentra alguna, se actualizan en el mismo commit |
| cancelada | `50_documentacion/activa/contrato_categoria_desempeno_v1.md` | n/a | lo fija por nombre `30_procesamiento/34_exportar_contrato_categoria.R` (fuente: grep, sesión 32); renombrarlo exige editar el pipeline (§4.7.4) | no se renombra; va al LOG y al marcador |

Quedan fuera y se declaran en el marcador:

- las seis excepciones de POLITICA §2;
- `decisiones/`, que tiene patrón propio según POLITICA §2;
- `andamios/`, que está congelado;
- `P-matricula-*`, que salen por el Bloque 2;
- `encargos/` (duda D3).

### Bloque 4: escáner

| Id | Cambio (lista cerrada) | Dónde | Evidencia |
|---|---|---|---|
| C4a | `DIRS_EXCLUIR <- c(".git", "renv", ".Rproj.user")` → `DIRS_EXCLUIR <- c(".git", "renv", ".Rproj.user", "node_modules", "packrat", "venv")` | `00_escanear_proyecto.R`, línea 45 | 0 menciones de `node_modules`, `packrat` ni `venv` en el script (fuente: `grep -nE`, sesión 32); POLITICA §7.2 |
| C4b | en el encabezado de los dos snapshots, `ruta_raiz` → `nombre_proyecto`: `paste0("Raiz   : ", ruta_raiz)` → `paste0("Raiz   : ", nombre_proyecto)` y ``paste0("- **Raiz:** `", ruta_raiz, "`")`` → ``paste0("- **Raiz:** `", nombre_proyecto, "`")`` | `00_escanear_proyecto.R`, líneas 185 y 200 | hoy la ruta absoluta con nombre de usuario se versiona en cada snapshot (fuente: `estructura_actual.md` línea 3, sesión 32); aprobado en la ruta de la sesión 32 |

No existe `node_modules/`, `packrat/` ni `venv/` en la raíz (fuente: `ls -d`, sesión 32). Por eso C4a no cambia los totales. Es la cuenta del esperado de T4.

## 2. Estado de partida (premisas marcadas)

- `main` = `origin/main` = `52b8dab` (`chore(estado): abre sesion en ...`), con árbol limpio (fuente: `git rev-parse` y `git status --porcelain`, sesión 32, tras `/apertura`). Hipótesis para el ejecutor; se mide en M2.
- Al lanzar, el porcelain tiene solo `?? 50_documentacion/activa/encargos/encargo_claude_code_categoria_ordenacion_repositorio_a11.md` y `?? 50_documentacion/andamios/20260925_errores_asistente_sesion32.md` (hipótesis, se mide en M1).
- `docs/index.html` tiene md5 `587f4233baf7561f332235780a04805a`, igual al sitio publicado (fuente: `md5sum` y `curl`, sesión 32).
- No existe `50_documentacion/activa/50_ordenacion_repositorio.md` (fuente: `ls`, sesión 32).
- `gh` está instalado y autenticado en esta estación (hipótesis, se mide en M4).
- `HERRAMIENTAS_DEV_PATH` resuelve (hipótesis, se mide en M5).
- Los instrumentos del SHA del a10 siguen en `/tmp/cat_a10_*` (hipótesis, se mide en M6; si no están, se rearman desde el LOG a10, M3).

## 3. Invariantes 🔒

1. **Pipeline y motor intactos:** `git diff --name-only <inicio>..HEAD -- 30_procesamiento docs 10_utils tests renv.lock renv .github 00_run_all.R | wc -l` → `0`.
2. **Andamios y traspasos intactos salvo el LOG:** `git diff --name-only <inicio>..HEAD -- 50_documentacion/andamios 50_documentacion/traspasos | grep -vx '50_documentacion/andamios/logs/20260925_ordenacion_repositorio_a11_log.md' | wc -l` → `0`.
3. **Nada se pierde:** por cada fila del manifiesto, `git hash-object "$RAIZ/_archivo/20260925/<ruta>"` = hash de origen de §1, y `test -e "$RAIZ/<ruta de origen>"` falla. Para B2-4: el destino existe y tiene 0 bytes.
4. **Un traspaso vigente:** `ls "$RAIZ"/50_documentacion/traspasos/*.md | wc -l` → `1`.
5. **Solo salen del índice las filas de §1:** `git diff --no-renames --diff-filter=D --name-only <inicio>..HEAD`, sin las rutas de `50_documentacion/estructura/` que pode el escáner, debe ser exactamente {B2-1, B2-2, B2-3, ruta de origen de B3-1}.
6. **`main` no cambia desde el punto de retorno:** tras `fetch`, `git rev-parse origin/main` = `<inicio>` al final.
7. **Cifras intactas:** PRUEBAS b y c.
8. **Sin coautoría ni RUT:**
   - `git log <inicio>..HEAD --format=%B | grep -ci 'co-authored'` → `0`;
   - `git diff <inicio>..HEAD | grep '^+' | grep -cE '[0-9]{1,2}\.?[0-9]{3}\.?[0-9]{3}-[0-9kK]'` → `0`.
9. **Sin rutas de usuario en lo agregado:** `git diff <inicio>..HEAD | grep '^+' | grep -cF "$HOME"` → `0`. Se calibra en FASE 0: sobre la copia, una línea plantada con `$HOME` da 1.

## 4. Tareas

Grafo:

- T1, T2, T3 y T4 son independientes entre sí y sus ALCANCE son disjuntos.
- T5 corre siempre después de T4. Su paso del marcador exige que T1 a T4 estén en «completada» (una fila cancelada no impide completar; una tarea congelada, sí).
- FASE R y FASE L cierran la cadena y corren aunque una tarea quede congelada.

Orden: FASE 0 → T1 → T2 → T3 → T4 → T5 → FASE R → FASE L.

### Regla de detención

1. Stash no vacío, o porcelain antes del commit de FASE 0 distinto de {el encargo, el archivo de errores, el LOG} → FASE L (sesión detenida).
2. `HEAD` distinto de `origin/main` en M2, o `basename`/remoto de ENTORNO distintos → FASE L.
3. Push de FASE 0 denegado → sin rama, FASE L.
4. Una fila de M7 que no calce con §1 (hash distinto, archivo ausente, una referencia viva nueva, un nombre presente en los normativos) → **esa fila** se cancela y se registra. La tarea sigue con las demás filas. No se agregan filas.
5. Un 🔒 en FALLA tras el commit de una tarea → `git revert` de ese commit, tarea congelada.
6. PRUEBAS a o b en falla tras T2 → `git revert` del commit de T2 y los archivos vuelven desde `_archivo/` (el revert los repone en el índice; se verifica con hash), T2 congelada.
7. PRUEBAS c no medible (sin instrumentos y sin receta rearmable en un intento) → ADVIERTE, no detiene: el 🔒1 cubre el motor.
8. Cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda con pregunta cerrada y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- Commit en `main` de FASE 0 con el encargo y el archivo de errores, y `git push origin main` **una vez**. Solo si, tras el commit, el porcelain está vacío o solo tiene el LOG, `origin/main..HEAD` = 1 y `HEAD..origin/main` = 0.
- `git switch -c ordenacion/20260925` desde `<inicio>`.
- Para B2-1 a B2-4: `mkdir -p` bajo `_archivo/20260925/` y `mv` a su destino. `git rm --cached -q` solo de B2-1, B2-2 y B2-3.
- `git mv` de B3-1.
- Edición de `00_escanear_proyecto.R`: solo las líneas 45, 185 y 200, con los textos de C4a y C4b.
- Correr `00_escanear_proyecto.R` (escribe y poda en `50_documentacion/estructura/` según POLITICA §7.4).
- Crear `50_documentacion/activa/50_ordenacion_repositorio.md`.
- Un commit por bloque (T2, T3, T4) y el commit de T5; `git restore docs/index.html` tras un build.
- `git revert` de un commit propio de la rama si la regla 5 o 6, o FASE R, lo exige.
- `git push -u origin ordenacion/20260925`, **hasta dos veces**: tras T4 y tras `docs(log)`. Solo sin `BLOQUEADO`, con porcelain vacío y `HEAD..origin/ordenacion/20260925` = 0.
- `gh pr create --base main --head ordenacion/20260925` **una vez**, solo si M4 pasó.
- Temporales en `/tmp/cat_a11_*` y copias del árbol en `/tmp/cat_a11_copia*`. Lo temporal se descarta con `mv` a `/tmp/cat_a11_basura/`.
- Implícitas: `fix(auditoria): R-NN …` y `docs(log): ordenación del repositorio a11`.

Nada más:

- ni `rm`, `reset`, `checkout --`, `rebase`, `merge`, `push --force`, `gh pr merge` ni ningún push a `main` fuera del de FASE 0;
- ni ediciones fuera de los ALCANCE;
- ni operaciones de renv distintas de cargarlo.

### FASE 0 (cada medición con `esperado:` antes y `obtenido:` después)

Primer acto: crear el LOG con el encabezado, el slot vacío `## J. Juicio (lo rellena FASE L)` y el esqueleto.

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain; stash | `?? ...encargo_claude_code_categoria_ordenacion_repositorio_a11.md`, `?? ...20260925_errores_asistente_sesion32.md` y el LOG; stash vacío | regla 1 |
| M2 | `basename "$RAIZ"`; remoto; `fetch`; rama; `HEAD`; `HEAD..origin/main`; `origin/main..HEAD` | `slep_categoria_desempeno`; la URL de ENTORNO; exit 0; `main`; `52b8dab` = `origin/main`; 0; 0 | regla 2 |
| M3 | commit de FASE 0 (encargo y archivo de errores, rutas explícitas); push de `main`; creación de la rama; precondiciones de SETTINGS §4.7.1 sobre la rama | commit = los 2 archivos; push exit 0; `<inicio>` = `origin/main`; en la rama: porcelain vacío o solo el LOG, stash vacío, `git rev-list --left-right --count origin/main...HEAD` = `0	0` (la rama aún no tiene upstream, así que la referencia es `origin/main`), rama = `ordenacion/20260925` | regla 1 o 3 |
| M4 | `gh --version`; `gh auth status` | exit 0 en ambos | sin PR por `gh`: T5 empuja la rama y el PR queda al titular |
| M5 | `HERRAMIENTAS_DEV_PATH`; `cmp` de los dos normativos de `activa/` con `$HERRAMIENTAS_DEV_PATH/gobernanza/` | resuelve; idénticos | B1-2 no medida (ADVIERTE) o T1 congelada si difieren |
| M6 | PRUEBAS a, b y c sobre `<inicio>`; SHA con su calibración del a10 (fecha alterada → igual; cifra plantada → distinto) | a y b en verde; SHA `d9895a78…0442`; calibración correcta; md5 de `docs/index.html` `587f4233…` tras el restore | regla 7 para c; a o b en falla → FASE L |
| M7 | inventario de §1 re-medido fila por fila: existencia, versionado (`git ls-files --error-unmatch`), `git hash-object`, `git check-ignore -v` (B2-4), grep de referencias con su clasificación viva/histórica, grep de B3-1 en los dos normativos, contenido literal de las líneas 45, 185 y 200 del escáner | todo igual a §1 | regla 4 |
| M8 | línea base del escáner en una copia: `rsync -a --exclude .git "$RAIZ"/ /tmp/cat_a11_copia/` y `Rscript` del escáner dentro de la copia; totales de carpetas y archivos; `ls "$RAIZ/tests/reportes" \| wc -l` | la corrida termina con exit 0; se anotan `carpetas_M8`, `archivos_M8` y `reportes_M8` | se registra |
| M9 | calibración del 🔒9 y del grep de RUT: en `/tmp/cat_a11_copia2`, una línea plantada con `$HOME` y otra con un RUT ficticio en un diff de prueba | cada grep da 1 | el 🔒 correspondiente queda sin calibrar: ADVIERTE |

Último acto: anexar la sección `### FASE 0` al LOG.

### T1: Bloque 1 (solo comprobación)

- **ALCANCE:** ninguna ruta (solo lectura).
- Verificación (`esperado:` antes):
  - `ls "$RAIZ"/50_documentacion/traspasos/*.md | wc -l` = 1;
  - B1-2 según M5.
- Sin commit. Sección del LOG con «sin cambios; sin commit».

### T2: Bloque 2 (obsoletos a `_archivo/`)

- **ALCANCE:** las rutas de origen de B2-1, B2-2, B2-3 y B2-4, y `_archivo/20260925/`.
- Pasos:
  1. Imprimir el plan (origen → destino, hash) sin ejecutar. La lista impresa es lo autorizado.
  2. Ejecutar la mecánica de §1 fila por fila (B2-1 y B2-2 juntas).
  3. Escribir el manifiesto en el LOG: ruta de origen, ruta de destino, `git hash-object` antes y después, y grep con su clasificación.
- Verificación (`esperado:` antes):
  - 🔒3 para las cuatro filas;
  - `git status --porcelain` = exactamente `D  50_documentacion/activa/P-matricula-actual_alcance.md`, `D  50_documentacion/activa/P-matricula-grado_alcance.md` y `D  20_insumos/auxiliares/prompt_nuevo_proyecto_categoria_desempeno.md` (más el LOG si está sin versionar);
  - PRUEBAS a y b en verde;
  - 🔒1 y 🔒2.
- Commit `chore(ordenacion): bloque 2, obsoletos a _archivo (a11)`, solo con las tres rutas de origen.

### T3: Bloque 3 (nomenclatura)

- **ALCANCE:** `50_documentacion/activa/resena_slep_categoria_desempeno.md`, `50_documentacion/activa/50_resena_slep_categoria_desempeno.md` y las referencias vivas que M7 haya encontrado (esperado: ninguna).
- Pasos: grep del nombre en los dos normativos (esperado 0) y `git mv`.
- Verificación (`esperado:` antes):
  - `git status --porcelain` = `R  50_documentacion/activa/resena_slep_categoria_desempeno.md -> 50_documentacion/activa/50_resena_slep_categoria_desempeno.md`;
  - `git hash-object` del destino = `430074a0…`;
  - grep de referencias vivas al nombre viejo = 0.
- Commit `chore(ordenacion): bloque 3, nomenclatura de activa (a11)`.

### T4: Bloque 4 (escáner)

- **ALCANCE:** `00_escanear_proyecto.R`.
- Pasos: aplicar C4a y C4b.
- Verificación (`esperado:` antes):
  - `git diff --numstat -- 00_escanear_proyecto.R` = `3	3	00_escanear_proyecto.R`. Cuenta: tres líneas reemplazadas, 45, 185 y 200; cada una suma 1 y resta 1;
  - `Rscript -e 'invisible(parse("00_escanear_proyecto.R"))'` corrido desde la raíz: exit 0;
  - **control positivo de C4a:** en `/tmp/cat_a11_copia3` (copia nueva del árbol con el escáner editado) se crean `node_modules/plantado.txt`, `packrat/plantado.txt` y `venv/plantado.txt`, y se corre el escáner. Los totales de carpetas y archivos deben ser iguales a los de la misma copia sin los plantados, y hay 0 líneas con `plantado.txt` en el snapshot. Contraprueba: con el escáner de `<inicio>` en la misma copia, esas líneas aparecen (3);
  - **control de C4b:** en esa copia, la línea `Raiz` del `.md` y del `.txt` es el nombre de la carpeta, sin `/`; `grep -cF "$HOME"` sobre ambos snapshots = 0. Contraprueba: con el escáner de `<inicio>`, `grep -cF "$HOME"` ≥ 1;
  - 🔒1.
- Commit `fix(escaner): excluye dependencias de terceros y no versiona la ruta absoluta (a11)`.
- Push de la rama (primera de las dos autorizadas).

### T5: PR, marcador y escáner final

1. Si M4 pasó: `gh pr create --base main --head ordenacion/20260925` con:
   - título `Ordenación del repositorio (política v5.5, SETTINGS §4.7)`;
   - cuerpo en español con los cuatro bloques, las filas canceladas, las dudas D1 a D3 y la ruta del LOG, sin atribución.

   Anotar número y URL. Si M4 falló, se anota «PR pendiente de apertura por el titular» y la URL de comparación `https://github.com/tomgc/slep_categoria_desempeno/compare/main...ordenacion/20260925`.
2. Solo si T1 a T4 están en «completada»: crear `50_documentacion/activa/50_ordenacion_repositorio.md` con:
   - fecha 2026-09-25;
   - rama;
   - PR (número y URL, o la nota de pendiente);
   - hash corto del commit de cada bloque;
   - conteo de archivos movidos por bloque (B1: 0; B2: 4, de ellos 3 versionados; B3: 1 renombre; B4: 0 movidos y 1 script corregido);
   - filas canceladas con su motivo;
   - lo que quedó fuera (§1, Bloque 3);
   - dudas D1 a D3.

   Todo copiado del LOG, no de memoria. Si alguna tarea quedó congelada, no se crea el marcador y el LOG lo declara (el gatillo de SETTINGS §1.2.2 punto 4bis sigue encendido a propósito).
3. Escáner final, **último acto que toca el árbol:** `Rscript 00_escanear_proyecto.R` desde la raíz, con renv activo.
4. Verificación (`esperado:` antes):
   - un snapshot sellado nuevo (par `.txt`/`.md`), aliases iguales a él, y 2 timestamps sellados en `50_documentacion/estructura/`;
   - la línea `Raiz` es `slep_categoria_desempeno`;
   - `carpetas` = `carpetas_M8`;
   - `archivos` = `archivos_M8 − 4 + 1 + (reportes_T5 − reportes_M8)`. Cuenta: salen del árbol visible P-matricula ×2, el prompt y `.Rhistory` (el escáner cuenta ocultos y excluye `_archivo/`); entra el marcador; el renombre no cambia el total; `tests/reportes/` crece un archivo por corrida de `auditar_cifras.R` posterior a M8. Sin marcador (paso 2 omitido), `+ 1` pasa a `+ 0`;
   - si difiere, cada archivo de la diferencia se lista y se registra (ADVIERTE).
5. Commit `docs(ordenacion): marcador y escáner final (a11)`, con `git add -- 50_documentacion/activa/50_ordenacion_repositorio.md 50_documentacion/estructura`.

### FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta.

1. **Inventario** `R-01…` derivado del LOG (cada `Verificación:`, cada cifra, cada 🔒 con su comando, el alcance global), anexado **antes** de auditar.
2. **Re-derivación independiente** con un comando distinto del que produjo cada afirmación:
   - movimientos: `git show --stat` de cada commit y `git ls-tree -r <inicio>` contra `git ls-tree -r HEAD`, si antes fue por `status`;
   - hashes: `shasum` del contenido de `git show <inicio>:<ruta>` contra `shasum` del destino, si antes fue por `hash-object`;
   - totales del escáner: `find` con las mismas exclusiones, si antes fue por el snapshot;
   - SHA: desde `git show HEAD:docs/index.html`, con otra implementación.
3. **Invariantes:** el comando de cada 🔒, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE, más `50_documentacion/estructura/`, el marcador y el LOG. Además `git status --porcelain`: lo no commiteado es hallazgo, no se limpia.
5. **Regresión completa:** PRUEBAS a, b y c sobre el estado final.
6. **Control positivo de la auditoría:** en una copia temporal fuera del árbol, alterar un byte de un archivo archivado y comprobar que el chequeo del 🔒3 lo detecta. Simular además una ruta fuera de alcance en un diff de prueba y comprobar que el paso 4 la detecta.
7. **Veredicto por hallazgo:**
   - **BLOQUEA:** 🔒 en FALLA, alcance violado, archivo perdido o historia divergente. No se repara: la tarea se congela, se registra y, si compromete la rama, no hay segundo push.
   - **REPARA:** defecto propio dentro del ALCANCE, sin tocar un 🔒.
   - **ADVIERTE:** se registra.
8. **Ciclo de reparación, máximo 2:** causa raíz; fix dentro del ALCANCE; re-verificación con el mismo chequeo y con uno distinto; regresión; commit `fix(auditoria): R-NN …`; fila en la tabla. Después se repiten los pasos 2 a 5 sobre lo tocado. Un hallazgo que sobrevive al segundo ciclo queda pendiente.
9. **Prohibido:** ajustar criterios o esperados, ampliar un ALCANCE, tocar un 🔒, editar evidencia ya escrita en el LOG, reparar un BLOQUEA.
10. **Salida:**
    - tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación`;
    - veredicto `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

### FASE L: cierre del log (última, obligatoria)

1. `git status --porcelain` con su `esperado:` (vacío o solo el LOG); otra cosa es hallazgo y no se limpia.
2. Cierre del LOG:
   - resumen;
   - inventario de commits desde `git log <inicio>..HEAD --oneline` y el commit de FASE 0;
   - tabla de FASE R;
   - 🔒 con evidencia;
   - manifiesto completo del Bloque 2 y del renombre;
   - log de greps con todas las filas, las canceladas incluidas;
   - dudas D1 a D3 y las que surjan, con pregunta cerrada;
   - errores propios;
   - notas para el revisor.
3. Bloque J de trece campos, copiado del detalle.
4. Privacidad: el grep de RUT sobre el LOG = vacío, `grep -cF "$HOME"` sobre el LOG = 0, y una lectura confirma que no hay nombres de personas ni de establecimientos.
5. `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE' <LOG>` = fases ejecutadas; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. `git add` del LOG y commit `docs(log): ordenación del repositorio a11`. Después, el segundo push de la rama, según la autorización.
7. Estado de cierre: qué quedó en la rama, el PR, y qué queda al titular (revisar el PR y decidir el merge; nunca lo hace este encargo).

### Dudas previstas (con pregunta cerrada, para el LOG y el marcador)

- **D1:** ¿las cuatro librerías `.js` de `10_utils/` se mueven a una carpeta propia (por ejemplo `30_procesamiento/vendor/`) en un encargo aparte que edite `33_generar_html.R` y `00_run_all.R`? (sí / no, se declaran excepción)
- **D2:** ¿se archivan los reportes con sello de `tests/reportes/` y se conserva solo el alias `auditoria_cifras.md`? (sí / no)
- **D3:** ¿los encargos de `activa/encargos/` llevan prefijo `50_`? (sí: renombrarlos en un encargo aparte / no: se declaran excepción como `decisiones/`)

## 5. Reporte final

- **Primera línea:** la salida literal de `ls -l <LOG> && wc -l <LOG>` y el hash de `docs(log)`.
- **Segundo bloque:** el bloque J tal cual.
- **Después:**
  - `<inicio>` y la rama;
  - número y URL del PR (o la nota de pendiente);
  - manifiesto resumido por bloque (movidos, renombrados, cancelados);
  - totales del escáner, antes y después, con su cuenta;
  - resultado de cada 🔒;
  - PRUEBAS a, b y c;
  - dudas D1 a D3;
  - lo que falló o sorprendió (si nada, decirlo).
