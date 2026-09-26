# LOG — ordenación del repositorio (a11)

- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_categoria_ordenacion_repositorio_a11.md`
- **Ejecutor:** Claude Code, modo autónomo, sin subagentes, esfuerzo `xhigh`.
- **Fecha:** 2026-09-25.
- **Punto de retorno `<inicio>`:** `f560426` (commit `chore(encargo): ordenación del repositorio a11`).
- **Rama de trabajo:** `ordenacion/20260925`.

## Índice

- FASE 0
- T1: Bloque 1 (comprobación)
- T2: Bloque 2 (obsoletos a `_archivo/`)
- T3: Bloque 3 (nomenclatura)
- T4: Bloque 4 (escáner)
- T5: PR, marcador y escáner final
- FASE R: auditoría propia y reparación
- FASE L: cierre del log
- J. Juicio

### FASE 0

Primer acto: LOG creado con encabezado y esqueleto, antes de M1.

| # | Medición | esperado | obtenido |
|---|---|---|---|
| M1 | porcelain; stash | encargo, archivo de errores y LOG; stash vacío | exactamente esos tres `??`; `git stash list` vacío. PASA |
| M2 | basename; remoto; fetch; rama; HEAD; HEAD..origin/main; origin/main..HEAD | `slep_categoria_desempeno`; URL de ENTORNO; exit 0; `main`; `52b8dab`=`origin/main`; 0; 0 | `slep_categoria_desempeno`; `https://github.com/tomgc/slep_categoria_desempeno.git`; fetch exit=0; `main`; HEAD=origin/main=`52b8daba69194254279e76f433f35f0d54eb8212`; 0; 0. PASA |
| M3 | commit de FASE 0 (2 archivos, rutas explícitas); push; `<inicio>`=origin/main; rama `ordenacion/20260925`; porcelain solo LOG; stash vacío; `origin/main...HEAD` = `0	0` | commit `f560426a3ef5fda1919947b93cdfe1b3c94a4ae0` con exactamente `encargo_claude_code_categoria_ordenacion_repositorio_a11.md` y `20260925_errores_asistente_sesion32.md`; push `52b8dab..f560426 main -> main` exit 0; `<inicio>`=`f560426`=origin/main; rama creada y activa; porcelain solo `?? ...a11_log.md`; stash vacío; `0	0` | PASA |
| M4 | `gh --version`; `gh auth status` | exit 0 en ambos | `gh version 2.101.0`; logged in `tomgc`, `Active account: true`. PASA |
| M5 | `HERRAMIENTAS_DEV_PATH`; `cmp` de POLITICA y SETTINGS de `activa/` contra el kit | resuelve; idénticos | resuelve a `herramientas_dev` (basename); `cmp` exit 0 en ambos (idénticos). PASA — B1-2 verificada, sin actualización necesaria |
| M6 | PRUEBAS a, b y c sobre `<inicio>`; calibración SHA (fecha alterada → igual, cifra plantada → distinto); md5 tras restore | a y b verde; SHA `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`; calibración correcta; md5 `587f4233baf7561f332235780a04805a` | PRUEBA a: `run_all(only=33)` exit 0, 0 warnings, `docs/index.html` no cambió (sin entrada en porcelain), md5 `587f4233baf7561f332235780a04805a`; PRUEBA b: `auditar_cifras.R` exit 0 F1–F4 OK 0 discrepancias, `spot_check_publicado.R` exit 0, 6 celdas + 1 ausencia OK; PRUEBA c: SHA `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`, fecha alterada = igual, cifra plantada = `162ff49ef78211c17126c4291b7d2f0f48d875743ec71a4798f1b77d83a15cd8` (distinto). PASA |
| M7 | inventario de §1 re-medido fila por fila | todo igual a §1; sin filas nuevas canceladas | B1-1: 1 archivo (`traspaso_cierre_v31.md`). B1-2: ver M5. B2-1: existe, versionado, hash `71d8fb1aa1dc2862fcfbff3877991372533fa1d2` = §1; referencias encontradas todas en categorías exentas (`estructura/`, `encargos/`, `traspasos/archivo/` v10/v11) → 0 vivas. B2-2: existe, versionado, hash `1449e5baf7b697f439aa0942ae8ef56a20334f7c` = §1; referencias en `estructura/`, `encargos/`, `traspasos/archivo/` v10/v11 y en B2-1 (se mueve en el mismo commit) → 0 vivas. B2-3: existe, versionado, hash `3375431a8cd5a2beaadf8270a18a2dac9de2a208` = §1; referencias solo en `estructura/` y `encargos/` (exentas) → 0 vivas. B2-4: existe, ignorado (`check-ignore` → `.gitignore:2`), 0 bytes = §1. Cancelada (`31_depurar_directorio_oficial.R`): referencias vivas confirmadas en `.gitignore:38`, `gobernanza_datos.md:82,101` y `30_procesamiento/30_construir_auxiliares.R:56` → sigue cancelada. B3-1: grep en POLITICA y SETTINGS = 0 apariciones; hash origen `430074a074596885972cf56d75fafcfa2c35cd59` = §1; referencias vivas al nombre viejo = 0 (todas en `estructura/`, `encargos/`, `traspasos/archivo/`, exentas). Cancelada B3 (`contrato_categoria_desempeno_v1.md`): confirmado fijado por nombre en `34_exportar_contrato_categoria.R:21`. C4a: 0 menciones de `node_modules`/`packrat`/`venv` en el script; ninguna de esas carpetas existe en la raíz. C4b: líneas 185 y 200 con `ruta_raiz` literal, confirmadas. Todo igual a §1; sin filas nuevas canceladas. PASA |
| M8 | línea base del escáner en copia; `ls tests/reportes \| wc -l` | corrida exit 0; se anotan los totales | `rsync -a --exclude .git` a `/tmp/cat_a11_copia`; escáner exit 0: `carpetas_M8=24`, `archivos_M8=225`; `reportes_M8=46`. PASA |
| M9 | calibración 🔒9 y grep de RUT sobre diff plantado | cada grep da 1 | línea plantada con `$HOME` → `grep -cF "$HOME"` = 1; línea plantada con RUT ficticio → `grep -cE` = 1. PASA |

Registro literal `esperado:`/`obtenido:` de cada medición (mismos datos de la tabla, en el formato exigido por el encargo):

M1
esperado: `?? ...a11.md`, `?? ...sesion32.md` y el LOG; stash vacío
obtenido: exactamente esos tres `??`; `git stash list` vacío. PASA

M2
esperado: `slep_categoria_desempeno`; URL de ENTORNO; exit 0; `main`; `52b8dab`=`origin/main`; 0; 0
obtenido: `slep_categoria_desempeno`; `https://github.com/tomgc/slep_categoria_desempeno.git`; fetch exit=0; `main`; HEAD=origin/main=`52b8daba69194254279e76f433f35f0d54eb8212`; 0; 0. PASA

M3
esperado: commit = 2 archivos; push exit 0; `<inicio>`=origin/main; porcelain vacío o solo LOG; stash vacío; `origin/main...HEAD`=`0	0`; rama=`ordenacion/20260925`
obtenido: commit `f560426a3ef5fda1919947b93cdfe1b3c94a4ae0` con los 2 archivos; push `52b8dab..f560426 main -> main` exit 0; `<inicio>`=`f560426`=origin/main; porcelain solo `?? ...a11_log.md`; stash vacío; `0	0`; rama activa `ordenacion/20260925`. PASA

M4
esperado: exit 0 en ambos
obtenido: `gh version 2.101.0`; logged in `tomgc`, `Active account: true`. PASA

M5
esperado: resuelve; idénticos
obtenido: resuelve a `herramientas_dev` (basename); `cmp` exit 0 en ambos. PASA

M6
esperado: a y b verde; SHA `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`; calibración correcta; md5 `587f4233baf7561f332235780a04805a`
obtenido: PRUEBA a exit 0, 0 warnings, md5 `587f4233baf7561f332235780a04805a`; PRUEBA b F1–F4 OK, spot OK; PRUEBA c SHA `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`, fecha alterada = igual, cifra plantada = `162ff49ef78211c17126c4291b7d2f0f48d875743ec71a4798f1b77d83a15cd8` (distinto). PASA

M7
esperado: todo igual a §1; sin filas nuevas canceladas
obtenido: los cuatro hashes de B2-1/B2-2/B2-3/B2-4 = §1; 0 referencias vivas en cada fila; cancelada y cancelada-B3 confirmadas con referencias vivas propias; C4a 0 menciones; C4b líneas 185/200 confirmadas. PASA

M8
esperado: corrida exit 0; se anotan los totales
obtenido: `carpetas_M8=24`, `archivos_M8=225`, `reportes_M8=46`. PASA

M9
esperado: cada grep da 1
obtenido: `$HOME` → 1; RUT ficticio → 1. PASA

Sin errores propios en FASE 0.

### T1: Bloque 1 (solo comprobación)

- **ALCANCE:** ninguna ruta (solo lectura).
- Verificación:

esperado: 1
obtenido: `ls "$RAIZ"/50_documentacion/traspasos/*.md | wc -l` = 1 (`traspaso_cierre_v31.md`). PASA

esperado: idénticos (B1-2, según M5)
obtenido: `cmp` exit 0 en ambos normativos. PASA

- Sin cambios; sin commit.
- **T1: completada.**

### T2: Bloque 2 (obsoletos a `_archivo/`)

**Plan impreso antes de ejecutar (lo autorizado):**

| Origen | Destino | Hash |
|---|---|---|
| `50_documentacion/activa/P-matricula-actual_alcance.md` | `_archivo/20260925/50_documentacion/activa/P-matricula-actual_alcance.md` | `71d8fb1aa1dc2862fcfbff3877991372533fa1d2` |
| `50_documentacion/activa/P-matricula-grado_alcance.md` | `_archivo/20260925/50_documentacion/activa/P-matricula-grado_alcance.md` | `1449e5baf7b697f439aa0942ae8ef56a20334f7c` |
| `20_insumos/auxiliares/prompt_nuevo_proyecto_categoria_desempeno.md` | `_archivo/20260925/20_insumos/auxiliares/prompt_nuevo_proyecto_categoria_desempeno.md` | `3375431a8cd5a2beaadf8270a18a2dac9de2a208` |
| `50_documentacion/traspasos/.Rhistory` | `_archivo/20260925/50_documentacion/traspasos/.Rhistory` | 0 bytes, ignorado |

**Manifiesto (hash antes y después, idénticos, verificado con `git hash-object`):**

| Fila | Hash origen | Hash destino | Igual |
|---|---|---|---|
| B2-1 | `71d8fb1aa1dc2862fcfbff3877991372533fa1d2` | `71d8fb1aa1dc2862fcfbff3877991372533fa1d2` | sí |
| B2-2 | `1449e5baf7b697f439aa0942ae8ef56a20334f7c` | `1449e5baf7b697f439aa0942ae8ef56a20334f7c` | sí |
| B2-3 | `3375431a8cd5a2beaadf8270a18a2dac9de2a208` | `3375431a8cd5a2beaadf8270a18a2dac9de2a208` | sí |
| B2-4 | 0 bytes | 0 bytes | sí |

Mecánica: `mkdir -p` de los tres destinos bajo `_archivo/20260925/`; `mv` de los cuatro archivos; `git rm --cached -q` de B2-1, B2-2 y B2-3 (B2-4 no estaba versionado, solo `mv`). Tras el movimiento, `test -e` de las cuatro rutas de origen falló (no existen). 🔒3 verificado.

**Log de greps (con la clasificación viva/histórica; incluye la fila cancelada):**

- B2-1: referencias en `estructura/estructura_actual.{txt,md}`, `estructura/20260925_185058_estructura.{txt,md}`, `estructura/20260925_214612_estructura.{txt,md}` (históricas, exentas — `50_documentacion/estructura/`), `activa/encargos/encargo_claude_code_categoria_ordenacion_repositorio_a11.md` (histórica, exenta — `activa/encargos/`), `traspasos/archivo/traspaso_cierre_v11.md` y `traspaso_cierre_v10.md` (históricas, exentas — `traspasos/archivo/`). 0 referencias vivas. No cancelada.
- B2-2: referencias en `estructura/` (histórica), `activa/encargos/...a11.md` (histórica), `traspasos/archivo/` v10 y v11 (históricas), y en `P-matricula-actual_alcance.md` (se mueve en el mismo commit, no cancela). 0 referencias vivas. No cancelada.
- B2-3: referencias en `estructura/` (histórica) y `activa/encargos/...a11.md` (histórica). 0 referencias vivas. No cancelada.
- B2-4: ignorado por `.gitignore:2`; 0 referencias posibles (no versionado).
- Cancelada (`31_depurar_directorio_oficial.R`, no se mueve): referencias vivas confirmadas en `.gitignore:38`, `gobernanza_datos.md:82` y `:101`, y `30_procesamiento/30_construir_auxiliares.R:56`. Se mantiene sin mover, como excepción ubicada por gobernanza.

**Verificación:**

esperado: hash origen = hash destino en las 4 filas; rutas de origen ausentes (🔒3)
obtenido: las 4 iguales; las 4 rutas de origen ausentes. PASA

esperado: `D  20_insumos/auxiliares/prompt_nuevo_proyecto_categoria_desempeno.md`, `D  50_documentacion/activa/P-matricula-actual_alcance.md`, `D  50_documentacion/activa/P-matricula-grado_alcance.md` (más el LOG si sin versionar)
obtenido: exactamente eso en `git status --porcelain`. PASA

esperado: PRUEBA a y b en verde
obtenido: `run_all(only=33)` exit 0, 0 warnings, `docs/index.html` sin cambios; `auditar_cifras.R` F1–F4 OK; `spot_check_publicado.R` OK. PASA

esperado: 🔒1 = 0; 🔒2 = 0
obtenido: `git diff --name-only f560426..HEAD -- 30_procesamiento docs 10_utils tests renv.lock renv .github 00_run_all.R | wc -l` = 0; `git diff --name-only f560426..HEAD -- 50_documentacion/andamios 50_documentacion/traspasos | grep -vx '...a11_log.md' | wc -l` = 0. PASA

Commit `chore(ordenacion): bloque 2, obsoletos a _archivo (a11)` = `9f9d42d`, con las tres rutas de origen explícitas (`git rm --cached` staged; B2-4 no versionado, sin entrar al commit).

- **T2: completada.**

### T3: Bloque 3 (nomenclatura)

- Grep de `resena_slep_categoria_desempeno` en `POLITICA_PROYECTO.md` y `SETTINGS_Y_PROMPTS_OPERACIONALES.md` de `activa/`: 0 apariciones. PASA (esperado 0).
- `git mv 50_documentacion/activa/resena_slep_categoria_desempeno.md 50_documentacion/activa/50_resena_slep_categoria_desempeno.md`.
- Verificación:

esperado: `R  50_documentacion/activa/resena_slep_categoria_desempeno.md -> 50_documentacion/activa/50_resena_slep_categoria_desempeno.md`
obtenido: exactamente eso en `git status --porcelain`. PASA

esperado: hash destino = `430074a074596885972cf56d75fafcfa2c35cd59` (= §1)
obtenido: `git hash-object` del destino = `430074a074596885972cf56d75fafcfa2c35cd59`. PASA

esperado: 0 referencias vivas al nombre viejo
obtenido: 0 (excluyendo el propio destino y las categorías exentas). PASA
- Commit `chore(ordenacion): bloque 3, nomenclatura de activa (a11)` = `86a01af`, rename 100%.
- **T3: completada.**

### T4: Bloque 4 (escáner)

- Edición de `00_escanear_proyecto.R`: línea 45 (C4a) y líneas 185 y 200 (C4b), textos exactos del encargo.
- Verificación:

esperado: `3	3	00_escanear_proyecto.R`
obtenido: `git diff --numstat -- 00_escanear_proyecto.R` = `3	3	00_escanear_proyecto.R`. PASA

esperado: exit 0
obtenido: `Rscript -e 'invisible(parse("00_escanear_proyecto.R"))'` exit 0. PASA

esperado: control positivo C4a — totales iguales con/sin plantados, 0 líneas `plantado.txt`; contraprueba con líneas `plantado.txt`
obtenido: en `/tmp/cat_a11_copia3` (copia nueva con el escáner editado), baseline `24 carpetas, 222 archivos`; con `node_modules/plantado.txt`, `packrat/plantado.txt`, `venv/plantado.txt` plantados, mismos totales (`24 carpetas, 222 archivos`) y 0 líneas con `plantado.txt`. Contraprueba con el escáner de `<inicio>` sobre la misma copia (plantados aún presentes): `27 carpetas, 225 archivos` y 3 líneas con `plantado.txt`. PASA

esperado: control C4b — línea `Raiz` sin `/`, con el nombre del proyecto
obtenido: con el escáner editado, la línea `Raiz` es `cat_a11_copia3` (sin `/`) en `.txt` y `.md`; con el escáner de `<inicio>` sobre la misma copia, la línea `Raiz` es `/private/tmp/cat_a11_copia3` (con `/`, ruta absoluta). El `grep -cF "$HOME"` dio 0 en ambos casos porque la copia vive en `/tmp` (fuera de `$HOME` por diseño de POSICIÓN, que exige temporales ahí) — ese sub-chequeo específico de `$HOME` es estructuralmente no discriminante en esta copia; el chequeo que sí discrimina (ausencia de `/`) PASA con evidencia directa. El chequeo de `$HOME` con evidencia real se traslada al escáner final de T5 sobre la raíz real (bajo `$HOME`). PASA

esperado: 🔒1 = 0
obtenido: `git diff --name-only f560426..HEAD -- 30_procesamiento docs 10_utils tests renv.lock renv .github 00_run_all.R | wc -l` = 0. PASA
- Commit `fix(escaner): excluye dependencias de terceros y no versiona la ruta absoluta (a11)` = `1d13dd2`.
- **Push de la rama (primera de las dos autorizadas): DENEGADO.**

  ```
  git push -u origin ordenacion/20260925
  ```
  El hook global `pre-push` (`$HERRAMIENTAS_DEV_PATH/githooks/pre-push`, activo vía `core.hooksPath` de la estación) rechazó el push con 14 hallazgos R1 (archivos de datos sin autorizar): `20_insumos/auxiliares/*.xlsx`, `20_insumos/auxiliares/directorio_oficial_ee_publico.csv`, `20_insumos/cdb_*.xlsx`, `20_insumos/cdm_*.xlsx`, `20_insumos/matricula_rbd_*.parquet` y `renv/settings.json`.

  **Causa raíz (verificada leyendo el hook):** para el primer push de una rama nueva (`remote_sha` = cero), el hook evalúa `git ls-tree -r --name-only` sobre **todo el árbol** del commit, no el diff contra `origin/main`; ese árbol contiene los archivos de datos que el proyecto versiona desde antes de este encargo (dato público, Agencia de Calidad — `gobernanza_datos.md`). El repo **no tiene** `50_documentacion/activa/50_datos_versionados_autorizados.md` (el archivo que el hook necesita para no bloquear), por lo que **cualquier primer push de una rama nueva de este repo queda bloqueado estructuralmente**, sin relación con lo que este encargo movió. Por eso el push de `main` en M3 sí pasó (era fast-forward sobre una rama ya conocida por el remoto; el hook usó `git diff` contra `remote_sha`, que solo traía los 2 archivos de documentación).

  **Por qué no se resuelve de paso:** crear `50_datos_versionados_autorizados.md` no está en ninguna `ALCANCE` de T1–T5 ni en las Autorizaciones (lista cerrada) de este encargo; es una decisión de gobernanza de datos que excede la ordenación del repositorio. Las dos salidas de escape que el propio hook declara (`git config hooks.cartera false` — no aplica, este repo sí es de la cartera; `git push --no-verify` — prohibido por la regla canónica "nunca `--no-verify`") tampoco proceden. **Topes:** "un push denegado no se reintenta"; no se reintentó.

  **Duda D4 (nueva, no prevista en el encargo, pregunta cerrada):** ¿se autoriza `git push --no-verify` para publicar esta rama en particular, o se crea `50_documentacion/activa/50_datos_versionados_autorizados.md` (con los globs de los archivos de datos públicos ya versionados) en un encargo aparte, antes de intentar de nuevo cualquier push de rama nueva en este repo?

- **T4: congelada** (regla de detención 8: resultado no enumerado — la denegación del push; el commit `1d13dd2` no se revierte porque ningún 🔒 falló y el defecto no es del ALCANCE de T4, sino de una gobernanza externa al encargo). El árbol local queda con los tres commits de bloque intactos; nada se pierde.

### T5: PR, marcador y escáner final

1. **PR:** M4 pasó (`gh` operativo), pero la rama no está en el remoto (push denegado en T4, no reintentado por Topes). No se intentó `gh pr create` (fallaría sin la rama en `origin`, y equivaldría a reintentar el push que ya fue denegado). Se anota, análogo al caso "M4 falló": **«PR pendiente de apertura por el titular»**. URL de comparación: `https://github.com/tomgc/slep_categoria_desempeno/compare/main...ordenacion/20260925`.
2. **Marcador:** omitido. T4 quedó congelada, y el encargo dice explícitamente: «si alguna tarea quedó congelada, no se crea el marcador y el LOG lo declara (el gatillo de SETTINGS §1.2.2 punto 4bis sigue encendido a propósito)». No se creó `50_documentacion/activa/50_ordenacion_repositorio.md`.
3. **Escáner final** (`Rscript 00_escanear_proyecto.R` desde la raíz, renv activo), último acto que toca el árbol: exit 0. `Escaneo completo: 24 carpetas, 222 archivos.` Snapshot nuevo `20260925_232343_estructura.{txt,md}`; poda retiró el sello más antiguo (`20260925_185058_estructura.{txt,md}`, 2 archivos), conservando los 2 sellos más recientes (`20260925_214612` y `20260925_232343`) más los aliases. Retención = 2, conforme a POLITICA §7.4.
4. **Verificación:**

esperado: línea `Raiz` = nombre del proyecto, sin ruta; `grep -cF "$HOME"` = 0
obtenido: `slep_categoria_desempeno` en `.txt` y `.md`; `grep -cF "$HOME"` = 0 en ambos. **Este es el chequeo definitivo de C4b sobre la raíz real** (la copia de `/tmp` en T4 no era discriminante para el sub-chequeo de `$HOME`; aquí sí, porque la raíz real está bajo `$HOME`). PASA

esperado: `carpetas` = `carpetas_M8` (24)
obtenido: 24 = 24. PASA

esperado: `archivos` = `archivos_M8 − 4 + (0 ó 1, marcador) + (reportes_T5 − reportes_M8)`
obtenido: `225 − 4 + 0 (sin marcador, T4 congelada) + (47 − 46 = 1) = 222`, igual al obtenido por el escáner. PASA
5. Commit: dado que no hay marcador, se adapta el mensaje literal del encargo (`docs(ordenacion): marcador y escáner final (a11)`, escrito asumiendo que el marcador existiría) a **`docs(ordenacion): escáner final, sin marcador por T4 congelada (a11)`** = `f47030d`, con `git add -- 50_documentacion/estructura` (sin el marcador, que no se creó). Decisión declarada: mantiene el espíritu de la autorización («un commit... de T5», mensaje `docs(ordenacion)`) sin afirmar en el mensaje algo que no ocurrió.
- **T5: ejecutada** (el paso del marcador, condicionado a T1–T4 «completada», no corrió porque T4 quedó congelada; el resto de T5 sí corrió, según el grafo: «T5 corre siempre después de T4»).

### FASE R: auditoría propia y reparación

**1. Inventario R-01…R-24**, derivado del LOG anterior a esta auditoría (cada `Verificación:`, cada cifra, cada 🔒, el alcance global):

| id | afirmación (LOG) |
|---|---|
| R-01 | M1: porcelain = 3 archivos esperados; stash vacío |
| R-02 | M2: basename, remoto, HEAD=origin/main=`52b8dab`, deltas 0/0 |
| R-03 | M3: commit `f560426` (2 archivos), push exit 0, rama `ordenacion/20260925`, precondiciones |
| R-04 | M4: `gh` exit 0 en versión y auth |
| R-05 | M5: `cmp` exit 0 en POLITICA y SETTINGS contra el kit |
| R-06 | M6: PRUEBAS a, b, c en verde sobre `<inicio>`; SHA `d9895a78…0442`; calibración correcta |
| R-07 | M7: hashes y referencias de B2-1, B2-2, B2-3, B2-4, B3-1, cancelada, C4a, C4b, todas = §1 |
| R-08 | M8: `carpetas_M8=24`, `archivos_M8=225`, `reportes_M8=46` |
| R-09 | M9: calibración `$HOME` y RUT = 1 cada una |
| R-10 | T1: `ls traspasos/*.md` = 1 |
| R-11 | T2: manifiesto — 4 hashes origen=destino, `test -e` origen falla en las 4 |
| R-12 | T2: porcelain esperado tras el movimiento |
| R-13 | T2: PRUEBAS a y b en verde |
| R-14 | T2: 🔒1 = 0, 🔒2 = 0 |
| R-15 | T3: grep normativos = 0; hash destino `430074a0…`; `git mv` correcto |
| R-16 | T4: `git diff --numstat` = `3	3`; parse exit 0 |
| R-17 | T4: control C4a — totales iguales con/sin plantados (`24/222`), 0 líneas `plantado.txt`; contraprueba `27/225`, 3 líneas |
| R-18 | T4: control C4b — línea `Raiz` sin `/` con el escáner editado; con `/` con el de `<inicio>`; `$HOME`=0 no discriminante en `/tmp` |
| R-19 | T4: 🔒1 = 0 |
| R-20 | T4: push denegado por el hook `pre-push` (14 hallazgos R1); T4 congelada; commit `1d13dd2` no revertido |
| R-21 | T5: escáner final sobre la raíz real — `24 carpetas, 222 archivos`; línea `Raiz`=`slep_categoria_desempeno`; `$HOME`=0 |
| R-22 | T5: fórmula `archivos_M8 − 4 + 0 + (reportes_T5 − reportes_M8)` = `222`, igual a lo obtenido |
| R-23 | T5: PR pendiente (rama no publicada); marcador omitido por T4 congelada |
| R-24 | Alcance global e invariantes 🔒1–🔒9 sobre el estado final |

**2. Re-derivación independiente (comando distinto):**

| id | comando de re-derivación | resultado |
|---|---|---|
| R-11 | `shasum -a 1` del contenido vía `git show <inicio>:<ruta>` (o del archivo, para B2-4) contra `shasum -a 1` del destino en disco, en vez de `git hash-object` | B2-1 `097a910e…`=`097a910e…`; B2-2 `2d8e297c…`=`2d8e297c…`; B2-3 `81897a3d…`=`81897a3d…`; B2-4 `e69de29b…`(vacío)=`e69de29b…`. Iguales en las 4. |
| R-15 | `shasum -a 1` de `git show <inicio>:...resena...` contra `git show HEAD:...50_resena...` | `56d9cf04…`=`56d9cf04…`. Iguales. |
| R-16/R-20/R-21 | `git show --stat` de los 4 commits de la rama, y `diff <(git ls-tree -r --name-only <inicio>) <(git ls-tree -r --name-only HEAD)`, en vez de `git status` | Coincide exactamente con el manifiesto: salen `P-matricula-actual_alcance.md`, `P-matricula-grado_alcance.md`, `prompt_nuevo_proyecto_categoria_desempeno.md`, `resena_slep_categoria_desempeno.md` (renombrado), `20260925_185058_estructura.{md,txt}` (podados); entran `50_resena_slep_categoria_desempeno.md`, `20260925_232343_estructura.{md,txt}`. |
| R-08/R-17/R-21 | `find "$RAIZ" \( -name .git -o -name renv -o -name .Rproj.user -o -name node_modules -o -name packrat -o -name venv -o -name _archivo \) -prune -o -type f/-type d -print \| wc -l`, en vez del snapshot del escáner | `222` archivos, `24` carpetas. Igual a lo obtenido por el escáner. |
| R-06 | `/tmp/cat_a11_payload_verify.py` (Python: `zlib`, `base64`, `json`, `hashlib`, en vez de Node/`zlib`/`crypto`) sobre `docs/index.html` | `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`. Igual al obtenido con la implementación Node del a10. |

**3. Invariantes, comando de cada 🔒, PASA/FALLA con salida literal (sobre el estado final, `HEAD=f47030d`):**

| 🔒 | comando | salida | veredicto |
|---|---|---|---|
| 1 | `git diff --name-only f560426..HEAD -- 30_procesamiento docs 10_utils tests renv.lock renv .github 00_run_all.R \| wc -l` | `0` | PASA |
| 2 | `git diff --name-only f560426..HEAD -- 50_documentacion/andamios 50_documentacion/traspasos \| grep -vx '...a11_log.md' \| wc -l` | `0` | PASA |
| 3 | hash origen (`git show <inicio>:<ruta>` + `hash-object`) = hash destino, `test -e` origen falla; 4 filas | las 4 iguales; las 4 rutas de origen ausentes; B2-4 destino 0 bytes | PASA |
| 4 | `ls 50_documentacion/traspasos/*.md \| wc -l` | `1` | PASA |
| 5 | `git diff --no-renames --diff-filter=D --name-only f560426..HEAD` sin rutas de `estructura/` | `P-matricula-actual_alcance.md`, `P-matricula-grado_alcance.md`, `prompt_nuevo_proyecto_categoria_desempeno.md`, `resena_slep_categoria_desempeno.md` — exactamente {B2-1, B2-2, B2-3, origen B3-1} | PASA |
| 6 | `git rev-parse origin/main` (tras `fetch`) | `f560426a3ef5fda1919947b93cdfe1b3c94a4ae0` = `<inicio>` | PASA |
| 7 | PRUEBAS a, b y c sobre el estado final | a: exit 0, 0 warnings, md5 `587f4233…`; b: F1–F4 OK, spot OK; c: SHA `d9895a78…0442` | PASA |
| 8 | `git log f560426..HEAD --format=%B \| grep -ci co-authored`; `git diff f560426..HEAD \| grep '^+' \| grep -cE RUT` | `0`; `0` | PASA |
| 9 | `git diff f560426..HEAD \| grep '^+' \| grep -cF "$HOME"` | `0` | PASA |

**4. Alcance global:** `git diff --name-only f560426..HEAD` = `00_escanear_proyecto.R`, `20_insumos/auxiliares/prompt_nuevo_proyecto_categoria_desempeno.md`, `50_documentacion/activa/50_resena_slep_categoria_desempeno.md`, `50_documentacion/activa/P-matricula-actual_alcance.md`, `50_documentacion/activa/P-matricula-grado_alcance.md`, `50_documentacion/estructura/20260925_232343_estructura.{md,txt}`, `50_documentacion/estructura/estructura_actual.{md,txt}` — todo dentro de la unión de ALCANCE de T2, T3, T4 más `50_documentacion/estructura/`. `git status --porcelain` = solo `?? ...a11_log.md` (el LOG, pendiente de FASE L; no se limpia). PASA.

**5. Regresión completa sobre el estado final:** PRUEBA a exit 0, 0 warnings, `docs/index.html` md5 `587f4233baf7561f332235780a04805a`; PRUEBA b F1–F4 OK y spot-check OK; PRUEBA c SHA `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`. Las tres en verde.

**6. Control positivo de la auditoría:**
- Byte alterado en una copia de `_archivo/20260925/.../P-matricula-actual_alcance.md` (`/tmp/cat_a11_control_fasa_r/alterado.md`): hash `bca0b5952b05b798399915f91bf36b4f498051e9` ≠ `71d8fb1aa1dc2862fcfbff3877991372533fa1d2` de §1 → el chequeo del 🔒3 lo habría detectado.
- Diff de prueba con `30_procesamiento/33_app.jsx` simulado dentro de la lista de rutas: el paso 4 lo marca «FUERA DE ALCANCE (30_procesamiento está prohibido, SETTINGS 4.7.4)», mientras que `00_escanear_proyecto.R` y `50_documentacion/estructura/estructura_actual.md` se marcan dentro de alcance. El paso 4 discrimina correctamente.

**7. Veredicto por hallazgo:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-20 | push de la rama denegado; T4 congelada; sin marcador ni PR real | `git push -u origin ordenacion/20260925`; lectura del hook `pre-push` | push exitoso, rama publicada | push RECHAZADO (14 hallazgos R1, ajenos al ALCANCE de este encargo); commit del bloque no afectado | ADVIERTE | se registra; no se repara (repararlo exige crear `50_datos_versionados_autorizados.md`, fuera de todo ALCANCE de T1–T5 y de las Autorizaciones — prohibido ampliar ALCANCE, punto 9) | ninguno (nada que commitear: es un hallazgo de gobernanza externa) | duda D4 en FASE L |
| — | todo lo demás (R-01 a R-19, R-21 a R-24) | ver tablas arriba | — | igual a lo esperado en cada caso | — | ninguna acción | — | — |

No hay hallazgos **BLOQUEA** ni **REPARA**: ningún 🔒 falló, el alcance no se violó, ningún archivo se perdió y la historia no diverge. El único hallazgo (R-20) es **ADVIERTE**, y por diseño (punto 9, prohibido ampliar ALCANCE) no admite reparación dentro de este encargo.

**8. Ciclo de reparación:** no aplica — no hay hallazgos con veredicto REPARA.

**Veredicto de FASE R: APROBADO CON ADVERTENCIAS** (una advertencia: R-20, push de rama denegado por un hook de gobernanza externo al encargo; T4 quedó congelada por eso, sin pérdida de trabajo ni violación de ningún invariante).

### FASE L: cierre del log

**1. `git status --porcelain`:** esperado: vacío o solo el LOG; obtenido: `?? 50_documentacion/andamios/logs/20260925_ordenacion_repositorio_a11_log.md`. Coincide; nada más sin commitear.

**2. Resumen.** El encargo a11 (ordenación del repositorio, política v5.5, SETTINGS §4.7) ejecutó FASE 0, T1 (comprobación, sin cambios), T2 (cuatro obsoletos a `_archivo/20260925/`, tres versionados movidos con `git rm --cached`), T3 (un renombre de nomenclatura en `activa/`) y T4 (corrección del escáner: exclusión de dependencias de terceros y fin del leak de ruta absoluta). El push de la rama de T4 fue **denegado** por el hook global `pre-push` de la estación (14 archivos de datos preexistentes sin autorizar, por falta de `50_datos_versionados_autorizados.md` en este proyecto; causa ajena a este encargo). Por Topes, el push no se reintentó; T4 quedó **congelada** sin revertir su commit (ningún 🔒 falló). T5 corrió igual (el grafo lo exige), sin el paso del marcador (por diseño, al haber una tarea congelada) y sin PR real (rama no publicada); se dejó la nota de pendiente y la URL de comparación, y se corrió el escáner final sobre la raíz real, con verificación exacta de sus totales. FASE R re-derivó cada afirmación con un comando distinto del original y las 9 invariantes 🔒 PASAn sobre el estado final; el único hallazgo (la denegación del push) es ADVIERTE y no admite reparación dentro del ALCANCE de este encargo. Veredicto: **APROBADO CON ADVERTENCIAS**.

**3. Inventario de commits desde `<inicio>`** (`git log f560426..HEAD --oneline`, más el commit de FASE 0):

| commit | mensaje |
|---|---|
| `f560426` | `chore(encargo): ordenación del repositorio a11` (FASE 0, en `main`, pusheado) |
| `9f9d42d` | `chore(ordenacion): bloque 2, obsoletos a _archivo (a11)` |
| `86a01af` | `chore(ordenacion): bloque 3, nomenclatura de activa (a11)` |
| `1d13dd2` | `fix(escaner): excluye dependencias de terceros y no versiona la ruta absoluta (a11)` |
| `f47030d` | `docs(ordenacion): escáner final, sin marcador por T4 congelada (a11)` |

**4. Tabla de FASE R:** ver sección FASE R arriba (inventario R-01…R-24, re-derivación, invariantes, alcance, regresión, controles positivos, veredicto por hallazgo).

**5. 🔒 con evidencia:** los 9 invariantes PASAn con la salida literal registrada en FASE R, punto 3.

**6. Manifiesto completo del Bloque 2 y del renombre:** ver sección T2 (tabla de plan, manifiesto de hashes, mecánica) y sección T3 (grep, `git mv`, hash de destino) arriba.

**7. Log de greps, todas las filas (incluidas las canceladas):**

| fila | grep | resultado | clasificación |
|---|---|---|---|
| B2-1 | `P-matricula-actual_alcance.md` | `estructura/` (×6), `activa/encargos/...a11.md`, `traspasos/archivo/` v10 y v11 | todas históricas/exentas — 0 vivas |
| B2-2 | `P-matricula-grado_alcance.md` | `estructura/` (×6), `activa/encargos/...a11.md`, `traspasos/archivo/` v10 y v11, `P-matricula-actual_alcance.md` (se mueve en el mismo commit) | todas históricas/exentas o del mismo commit — 0 vivas |
| B2-3 | `prompt_nuevo_proyecto_categoria_desempeno` | `estructura/` (×6), `activa/encargos/...a11.md` | todas históricas/exentas — 0 vivas |
| cancelada | `31_depurar_directorio_oficial.R` | `.gitignore:38`, `gobernanza_datos.md:82,101`, `30_construir_auxiliares.R:56`, más históricas en `estructura/`, `traspasos/archivo/`, `encargos/` | **vivas** (.gitignore, gobernanza_datos.md, pipeline) → confirma la cancelación, no se mueve |
| B3-1 | `resena_slep_categoria_desempeno` en POLITICA y SETTINGS | sin coincidencias | 0 — no cancela |
| B3-1 | `resena_slep_categoria_desempeno` (nombre viejo) en todo el árbol | `estructura/` (×6), `traspasos/archivo/` v26 y v27 | todas históricas/exentas — 0 vivas |
| cancelada B3 | `contrato_categoria_desempeno_v1.md` en `34_exportar_contrato_categoria.R` | 1 coincidencia, fija por nombre | confirma la cancelación, no se renombra |
| C4a | `node_modules\|packrat\|venv` en `00_escanear_proyecto.R` (antes del fix) | 0 | confirma la falta de exclusión antes del fix |

Ejecución sin filas nuevas canceladas por M7 (todas las filas de §1 calzaron); las canceladas y de duda ya venían declaradas en el encargo.

**8. Dudas D1 a D3 (previstas) y las que surgieron:**

- **D1** (¿mover las 4 librerías `.js` de `10_utils/` a `30_procesamiento/vendor/` en un encargo aparte que edite el pipeline?): no resuelta en este encargo; queda para el titular.
- **D2** (¿archivar los reportes con sello de `tests/reportes/` y conservar solo el alias?): no resuelta en este encargo; queda para el titular.
- **D3** (¿los encargos de `activa/encargos/` llevan prefijo `50_`?): no resuelta en este encargo; queda para el titular.
- **D4 (nueva, surgida en T4):** ¿se autoriza `git push --no-verify` para publicar `ordenacion/20260925`, o se crea `50_documentacion/activa/50_datos_versionados_autorizados.md` (con los globs de los datos públicos ya versionados: `.xlsx`, `.csv`, `.parquet` de `20_insumos/` y `renv/settings.json`) en un encargo aparte, antes de reintentar cualquier push de rama nueva en este repo? Sin resolver esta duda, **ninguna rama nueva de este repositorio podrá publicarse** (el hook bloquea el primer push de cualquier rama mientras no exista ese archivo de autorización).

**9. Errores propios:** ninguno. La primera corrida del script de verificación del SHA (`/tmp/cat_a11_payload_verify.py`) falló por probar un único modo de descompresión (`zlib.MAX_WBITS`); se corrigió probando los cuatro modos posibles (`MAX_WBITS`, `-MAX_WBITS`, `\|16`, `\|32`) en la misma sesión, sin repetir el resto del encargo. No es un error de protocolo: es la mecánica normal de tantear el formato binario de un `atob()`+`pako` desconocido.

**10. Notas para el revisor:**

- La rama `ordenacion/20260925` **no está publicada**. Todo el trabajo (T2, T3, T4, T5, y este cierre) vive únicamente en el clon local de la estación hasta que el titular resuelva D4.
- No hay PR. La URL de comparación, una vez publicada la rama, es `https://github.com/tomgc/slep_categoria_desempeno/compare/main...ordenacion/20260925`.
- No se creó `50_documentacion/activa/50_ordenacion_repositorio.md`: el gatillo de SETTINGS §1.2.2 punto 4bis sigue encendido a propósito. Cuando D4 se resuelva y la rama se publique y el PR se abra, conviene reejecutar solo T5 (marcador + verificación) en vez de todo el encargo — T1 a T4 no necesitan repetirse.
- El commit `docs(ordenacion): escáner final, sin marcador por T4 congelada (a11)` usa un mensaje distinto al literal del encargo (`docs(ordenacion): marcador y escáner final (a11)`) porque el marcador no existe; se declaró la desviación en la sección T5.
- Los reportes de `tests/reportes/` crecieron en 2 durante este encargo (una corrida de `auditar_cifras.R` en M6 y otra en T2/FASE R comparten el mismo archivo con sello por segundo, así que el conteo neto entre M8 y T5 fue +1); es un efecto lateral esperado de correr las PRUEBAS varias veces, no un cambio de alcance.

## J. Juicio (lo rellena FASE L)

- **Meta y resultado:** ordenar el repositorio según la política v5.5 y SETTINGS §4.7 (traspasos, obsoletos, nomenclatura, escáner), sin tocar el pipeline. Resultado: T1–T4 y T5 ejecutadas; T4 quedó congelada por un push denegado (hallazgo externo al encargo); sin marcador ni PR reales. Veredicto de FASE R: **APROBADO CON ADVERTENCIAS**.
- **Estado por tarea:** T1 completada · T2 completada (`9f9d42d`) · T3 completada (`86a01af`) · T4 congelada (`1d13dd2`, push denegado) · T5 ejecutada sin el paso del marcador (`f47030d`).
- **Commits:** `f560426` (FASE 0, en `main`) → `9f9d42d` → `86a01af` → `1d13dd2` → `f47030d`, en `ordenacion/20260925` (rama no publicada).
- **Auditoría:** FASE R re-derivó cada afirmación con un comando distinto (shasum, `git show --stat`, `find`, Python) y todas coincidieron con lo obtenido en la ejecución.
- **Invariantes:** los 9 🔒 PASAn sobre el estado final (`HEAD=f47030d`), con salida literal en la tabla de FASE R.
- **Cifras críticas:** SHA del payload `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442` sin cambio; md5 de `docs/index.html` `587f4233baf7561f332235780a04805a` sin cambio; escáner final `24 carpetas, 222 archivos` (antes `225`,−4 por lo archivado, +1 por un reporte adicional, +0 por no haber marcador).
- **Decisiones autónomas de mayor riesgo:** no reintentar el push denegado (Topes) y congelar T4 sin revertir su commit, en vez de revertir por defecto; adaptar el mensaje del commit de T5 (`docs(ordenacion): escáner final, sin marcador por T4 congelada (a11)`) al no existir el marcador.
- **Desviaciones:** el mensaje del commit de T5 no es literalmente `docs(ordenacion): marcador y escáner final (a11)` (no hay marcador que mencionar); el control de C4b sobre `$HOME` en la copia de `/tmp` no fue discriminante por vivir fuera de `$HOME` (se resolvió corriendo el chequeo definitivo sobre la raíz real en T5).
- **Dudas abiertas:** D1, D2, D3 (previstas, sin resolver) y **D4** (nueva: autorizar `--no-verify` o crear `50_datos_versionados_autorizados.md` antes de poder publicar cualquier rama nueva de este repo).
- **Errores propios:** ninguno de protocolo; un tanteo de formato binario al escribir el verificador Python del SHA (no repitió trabajo).
- **Qué debe verificar el revisor:** que el hook `pre-push` no sea un falso rechazo (revisar los 14 archivos listados); decidir D4; si se publica la rama, abrir el PR con `gh pr create --base main --head ordenacion/20260925` y, después, correr solo T5 (marcador) para cerrar el ciclo completo.
- **No publicado / queda al usuario:** la rama `ordenacion/20260925` (local only); el PR; la resolución de D4; el marcador `50_ordenacion_repositorio.md`; D1, D2, D3.
- **Ejecución:** autónoma, sin subagentes, esfuerzo `xhigh`, todo en un turno, sobre el filesystem local de la estación.
