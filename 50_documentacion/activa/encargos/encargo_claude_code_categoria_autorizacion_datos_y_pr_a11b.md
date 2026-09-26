# Encargo autónomo: autorización de datos versionados, publicación de la rama del a11 y PR (a11b)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten.**
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0 (cadena en serie con pushes y PR: tabla §2.12 del instrumento de encargos, filas 1 y 2). Si la sesión está en otro modo, el encargo manda y el encabezado del LOG lo declara.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS), lanzado en la raíz del repo `slep_categoria_desempeno`. Todo script empieza con `RAIZ="$(git rev-parse --show-toplevel)"`. FASE 0 verifica que `basename "$RAIZ"` = `slep_categoria_desempeno` y que el remoto `origin` = `https://github.com/tomgc/slep_categoria_desempeno.git`. **Ninguna ruta absoluta con nombre de usuario entra a un archivo versionado** (LOG, autorización, marcador, mensajes, cuerpo del PR): en el LOG, `$RAIZ` se escribe `<RAIZ>` y `$HERRAMIENTAS_DEV_PATH` se escribe `<KIT>`.
- **INSUMOS (en disco):**
  - este encargo y `50_documentacion/andamios/20260925_errores_asistente_sesion32.md` (modificado, con 6 filas; va en el commit de FASE 0);
  - el LOG del a11 (`50_documentacion/andamios/logs/20260925_ordenacion_repositorio_a11_log.md`, en la rama `ordenacion/20260925`): sus 🔒, su T5 y sus dudas D1 a D4;
  - el encargo a11 (`50_documentacion/activa/encargos/encargo_claude_code_categoria_ordenacion_repositorio_a11.md`), §4 T5, que este encargo repite;
  - `<KIT>/githooks/pre-push` (regla R1 y formato del archivo de autorización, líneas 40 y 55 a 75) y `<KIT>/50_documentacion/activa/50_datos_versionados_autorizados.md` (modelo de forma);
  - `<KIT>/plantillas/95_verificar_cierre.R` (I8, líneas 314 a 365);
  - `50_documentacion/activa/gobernanza_datos.md` (base de la decisión: producto público; directorio depurado sin `MRUN` ni `RUT_SOSTENEDOR`).
- **POSICIÓN:**
  - `bash` explícito; scripts en archivo (`/tmp/cat_a11b_*.sh`, `/tmp/cat_a11b_*.R`), sin heredocs en zsh y sin `Rscript -e` de varios pasos.
  - git de lectura con `GIT_OPTIONAL_LOCKS=0`; primer acto git: `fetch`.
  - Las corridas R del proyecto arrancan en la raíz con renv activo. `95_verificar_cierre.R` se corre **desde fuera del proyecto** (su propio uso lo exige): `cd /tmp && Rscript "$HERRAMIENTAS_DEV_PATH/plantillas/95_verificar_cierre.R" "$RAIZ"`.
  - Ningún shell en segundo plano al terminar. El checkout final queda en `main`.
- **LOG:** `50_documentacion/andamios/logs/20260926_autorizacion_datos_y_pr_a11b_log.md` (se crea en FASE 0, viaja sin versionar entre ramas y se commitea en `main` en FASE L).
- **PUNTO DE RETORNO:** el hash del commit `chore(encargo): autorización de datos y PR a11b` en `main` es `<inicio>`. La base previa es `f560426`.
- **ALCANCE:** por tarea, en §4.
- **PRUEBAS:**
  - (a) `run_all(only = 33)` con renv activo: exit 0 y 0 warnings; si modificó `docs/index.html`, `git restore docs/index.html`, y md5 = `587f4233baf7561f332235780a04805a`;
  - (b) `tests/auditar_cifras.R` y `tests/spot_check_publicado.R` en verde con renv activo.
  - Corren en FASE R sobre la rama final. Este encargo no toca el pipeline; el 🔒2 lo cubre.
- **Topes:** 3 intentos por bug; 2 ciclos en FASE R; 1 reintento por falla transitoria; un push denegado no se reintenta.
- **Reglas canónicas:**
  - Commits en español; `git add` con rutas explícitas.
  - **Nunca `--no-verify`** (`CLAUDE.md` del proyecto); ningún `git config hooks.cartera false`.
  - Sin `Co-Authored-By` ni atribución a la herramienta.
  - LOG sin RBD con número, sin nombres de establecimiento ni de personas, sin filas de datos (solo conteos y hashes).
  - Nada se borra.

## 1. Qué aprobó el titular (sesión 32 del chat, 2026-09-26)

Opción A de la duda D4 del a11 («Vamos con tu recomendación. A»). El hook global `pre-push`, en el primer push de una rama nueva, revisa el árbol completo (`git ls-tree -r`) y rechaza toda ruta con extensión de datos que no cubra `50_documentacion/activa/50_datos_versionados_autorizados.md` (fuente: `<KIT>/githooks/pre-push`, líneas 82 a 84 y 90 a 98, leídas en la sesión 32). Este repo versiona 14 de esas rutas y no tiene el archivo (fuente: `git ls-files | grep -E` y `ls`, sesión 32). La misma lista alimenta I8 de `95_verificar_cierre.R` (fuente: líneas 314 a 365, sesión 32).

Los datos son públicos por decisión del proyecto (fuente: `gobernanza_datos.md`, «Producto público con incidente de PII saneado», sesión 32). Por eso la salida es autorizarlos uno por uno, con la medición que justifica cada entrada, como pide el propio kit: «la justificación dice **cómo se supo** que la ruta está limpia» (fuente: `<KIT>/50_documentacion/activa/50_datos_versionados_autorizados.md`, «Cómo se amplía», sesión 32).

El hook lee la lista desde la **carpeta de trabajo** (`[ -f "$AUTORIZADOS" ]`, ruta relativa; fuente: líneas 55 a 62, sesión 32). Por eso la lista va en `main` y después la rama del a11 se rebasa sobre `main`, para contenerla también.

### Las 14 rutas (lista cerrada)

El hash de cada ruta es el de `git hash-object` y el tamaño viene de `wc -c` (fuente: sesión 32). La medición previa se hizo con un medio del asistente: patrón de RUT de R3 celda por celda, con control positivo (un RUT sintético armado por concatenación → sí; `RBD 1234-5` → no). Es hipótesis para el ejecutor y se re-mide en R en T1.

| # | Ruta | Hash | Bytes | Qué es | Medición previa (sesión 32) |
|---|---|---|---|---|---|
| 1 | `20_insumos/auxiliares/202602_Listado_SLEP_2026_vf.xlsx` | `3191b9a548920ba75acbc7c694ca4f4a12c041e3` | 56818 | listado oficial de SLEP 2026 | 0 RUT en 4690 celdas; 0 columnas sospechosas |
| 2 | `20_insumos/auxiliares/caracterizacion_establecimientos.xlsx` | `feeacad8f4961d4ad7758225bd672afe0a320205` | 16925 | caracterización de establecimientos del SLEP (RBD, `DV` del RBD, nombre, niveles, comuna, macrozona, emplazamiento, IVE) | 0 en 592 celdas; `DV` es el dígito del RBD |
| 3 | `20_insumos/auxiliares/diccionario_territorios.xlsx` | `1a655fa97487a61e65ae7bd8b8320d0ee282ae72` | 17170 | catálogo territorial | 0 en 1392 celdas |
| 4 | `20_insumos/auxiliares/directorio_oficial_ee_publico.csv` | `090d87ec71fab79517e332ccf02bb845b45dce3c` | 3584331 | directorio oficial depurado (sin `MRUN` ni `RUT_SOSTENEDOR`, `gobernanza_datos.md`) | 0 líneas con RUT de 16769; 0 columnas con `rut` o `mrun` en el encabezado |
| 5 | `20_insumos/cdb_2016.xlsx` | `004c663fd3e87759b1186e3f3aa7581a96116a9c` | 407568 | Categoría de Desempeño, básica, 2016 (Agencia de Calidad) | 0 en 58121 celdas |
| 6 | `20_insumos/cdb_2017.xlsx` | `61b93f67c9bc2b3a9933046a35bcecb90870a38d` | 352392 | ídem, 2017 | 0 en 57540 |
| 7 | `20_insumos/cdb_2018.xlsx` | `9cac4236e64a161c159276c536a34c2a5e585943` | 398878 | ídem, 2018 | 0 en 56168 |
| 8 | `20_insumos/cdb_2019.xlsx` | `18dfd00a81f3eeb18861f20b89d8b03bd4d839d5` | 385335 | ídem, 2019 | 0 en 55405 |
| 9 | `20_insumos/cdm_2017.xlsx` | `8af41cc9f76977c198164fb4e0723144441a5657` | 135653 | Categoría de Desempeño, media, 2017 | 0 en 20405 |
| 10 | `20_insumos/cdm_2018.xlsx` | `974455ad6af2e708b523e20159d779be4c5a0447` | 158983 | ídem, 2018 | 0 en 20559 |
| 11 | `20_insumos/cdm_2019.xlsx` | `a755683a2acb4dbf7aaa799bfa06b98f596db639` | 154544 | ídem, 2019 | 0 en 20559 |
| 12 | `20_insumos/matricula_rbd_ense.parquet` | `bbae62aecf4b5835664aa0e177df0d34e9a95d7a` | 785014 | matrícula por RBD y tipo de enseñanza (agregado por establecimiento) | 0 en 1056955 valores |
| 13 | `20_insumos/matricula_rbd_grado.parquet` | `6f7782a001d2db176a44f5afe191efe26c251c01` | 1537688 | matrícula por RBD y grado (agregado por establecimiento) | 0 en 4567495 valores |
| 14 | `renv/settings.json` | `ffdbb3200f779343ad1aa1a2fb6c74a02fd9b365` | 412 | configuración de renv, no es dato | 0 en 19 líneas |

`readxl` y `arrow` están en `renv.lock` y el pipeline los usa (fuente: `grep` en `renv.lock` y en `30_procesamiento/`, sesión 32).

### Texto del archivo de autorización (forma fija; `<n>` sale de la medición en R de T1)

Ruta: `50_documentacion/activa/50_datos_versionados_autorizados.md`.

````markdown
# Datos versionados autorizados (slep_categoria_desempeno)

> Requerido por la regla R1 de `githooks/pre-push` del kit y por I8 de
> `plantillas/95_verificar_cierre.R`, que leen las entradas del **primer bloque
> cercado** de este archivo y descartan lo que va tras la almohadilla.
>
> Escrito el 2026-09-26 (encargo a11b), cuando el primer push de la rama
> `ordenacion/20260925` se detuvo en el hook: el proyecto versiona desde su
> origen insumos públicos de la Agencia de Calidad y catálogos territoriales,
> y no tenía esta lista.
>
> **Esta lista no relaja la gobernanza.** Autoriza la extensión de las rutas
> enumeradas, una por una y sin comodines, no su contenido. R2 (credenciales) y
> R3 (patrón de RUT) siguen corriendo sobre todo lo que viaja en cada push. La
> base de la decisión está en `gobernanza_datos.md`: producto público,
> agregados por establecimiento, sin datos por estudiante, y un directorio
> depurado sin `MRUN` ni `RUT_SOSTENEDOR`.

## Entradas

```
20_insumos/auxiliares/202602_Listado_SLEP_2026_vf.xlsx    # listado oficial de SLEP 2026, público; 0 coincidencias del patrón de RUT de R3 en <n> celdas y 0 columnas con nombre MRUN, RUN o RUT, medido en R (readxl, todas las hojas) en el a11b, 2026-09-26, con control positivo
20_insumos/auxiliares/caracterizacion_establecimientos.xlsx    # caracterización pública de los establecimientos del SLEP (la columna DV es el dígito del RBD); 0 coincidencias en <n> celdas y 0 columnas MRUN, RUN o RUT, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/auxiliares/diccionario_territorios.xlsx    # catálogo territorial público; 0 coincidencias en <n> celdas y 0 columnas MRUN, RUN o RUT, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/auxiliares/directorio_oficial_ee_publico.csv    # directorio oficial depurado sin MRUN ni RUT_SOSTENEDOR (gobernanza_datos.md); 0 líneas con el patrón de RUT en <n> líneas y 0 columnas MRUN, RUN o RUT, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/cdb_2016.xlsx    # Categoría de Desempeño básica 2016, Agencia de Calidad, pública; 0 coincidencias en <n> celdas y 0 columnas MRUN, RUN o RUT, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/cdb_2017.xlsx    # Categoría de Desempeño básica 2017, pública; 0 coincidencias en <n> celdas, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/cdb_2018.xlsx    # Categoría de Desempeño básica 2018, pública; 0 coincidencias en <n> celdas, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/cdb_2019.xlsx    # Categoría de Desempeño básica 2019, pública; 0 coincidencias en <n> celdas, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/cdm_2017.xlsx    # Categoría de Desempeño media 2017, pública; 0 coincidencias en <n> celdas, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/cdm_2018.xlsx    # Categoría de Desempeño media 2018, pública; 0 coincidencias en <n> celdas, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/cdm_2019.xlsx    # Categoría de Desempeño media 2019, pública; 0 coincidencias en <n> celdas, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/matricula_rbd_ense.parquet    # matrícula agregada por RBD y tipo de enseñanza, sin datos por estudiante; 0 coincidencias en <n> valores y 0 columnas MRUN, RUN o RUT, medido en R (arrow) en el a11b, 2026-09-26, con control positivo
20_insumos/matricula_rbd_grado.parquet    # matrícula agregada por RBD y grado, sin datos por estudiante; 0 coincidencias en <n> valores y 0 columnas MRUN, RUN o RUT, medido en R (arrow) en el a11b, 2026-09-26, con control positivo
renv/settings.json    # configuración de renv, no es dato; 0 líneas con el patrón de RUT en <n> líneas, medido en R en el a11b, 2026-09-26
```

## Lo que esta lista NO autoriza

- El crudo `20_insumos/auxiliares/directorio_oficial_ee.csv`, con `MRUN` y
  `RUT_SOSTENEDOR`: sigue fuera de Git por `.gitignore` (ver
  `gobernanza_datos.md`, «Incidente de PII»).
- Ninguna ruta nueva con extensión de datos, aunque viva en `20_insumos/`.
- Comodines: cada ruta entra con su nombre exacto.

## Cómo se amplía

Una ruta nueva con extensión de datos entra solo con una entrada propia, su ruta
exacta y su justificación en la misma línea. La justificación dice cómo se supo
que la ruta está limpia (comando o medición, con control positivo), no solo que
lo está.
````

(En el archivo real el bloque exterior de cuatro comillas no existe. Empieza en `# Datos versionados autorizados` y el único bloque cercado es el de «Entradas».)

## 2. Estado de partida (premisas marcadas)

- Checkout en `ordenacion/20260925`, `HEAD` = `93f6fa0`, con 5 commits sobre `f560426`. La rama no está en el remoto: `git ls-remote --heads origin` solo muestra `main` = `f560426` (fuente: `git branch`, `git log`, `git ls-remote`, sesión 32). Hipótesis para el ejecutor; se mide en M2.
- Porcelain: ` M 50_documentacion/andamios/20260925_errores_asistente_sesion32.md` y `?? ` de este encargo (fuente: `git status --porcelain`, sesión 32, más la escritura de este encargo). Se mide en M1.
- `git diff --name-only f560426..ordenacion/20260925` da 10 rutas, que son el conjunto del a11 (fuente: sesión 32):
  - `00_escanear_proyecto.R`;
  - `20_insumos/auxiliares/prompt_nuevo_proyecto_categoria_desempeno.md`;
  - `50_documentacion/activa/50_resena_slep_categoria_desempeno.md`;
  - `50_documentacion/activa/P-matricula-actual_alcance.md` y `50_documentacion/activa/P-matricula-grado_alcance.md`;
  - `50_documentacion/andamios/logs/20260925_ordenacion_repositorio_a11_log.md`;
  - `50_documentacion/estructura/20260925_232343_estructura.md` y `.txt`;
  - `50_documentacion/estructura/estructura_actual.md` y `.txt`.
- No existe `50_documentacion/activa/50_datos_versionados_autorizados.md` en ninguna rama (hipótesis, se mide en M2 con `git ls-tree`).
- `core.hooksPath` global apunta a `<KIT>/githooks` y `gh` está autenticado (hipótesis, se mide en M4; el a11 midió `gh` en su M4).
- I8 de `95_verificar_cierre.R` falla hoy en este repo (hipótesis, se mide en M5).
- `readxl` y `arrow` cargan con renv (hipótesis, se mide en M4).

## 3. Invariantes 🔒

1. **Datos intactos:** `git hash-object` de las 14 rutas = columna Hash de §1, al inicio (M6) y al final; y `git diff --name-only f560426..origin/main -- 20_insumos renv renv.lock | wc -l` → `0`.
2. **Pipeline y motor intactos en las dos ramas:**
   - `git diff --name-only f560426..origin/main -- 30_procesamiento docs 10_utils tests renv.lock .github 00_run_all.R | wc -l` → `0`;
   - `git diff --name-only origin/main...origin/ordenacion/20260925 -- 30_procesamiento docs 10_utils tests renv.lock .github 00_run_all.R | wc -l` → `0`.
3. **`main` solo gana cuatro archivos:** `git diff --name-only f560426..origin/main` = exactamente {este encargo, `50_documentacion/andamios/20260925_errores_asistente_sesion32.md`, `50_documentacion/activa/50_datos_versionados_autorizados.md`, el LOG}.
4. **La rama conserva el trabajo del a11:** `git diff --name-only origin/main...origin/ordenacion/20260925` ⊆ {las 10 rutas de §2} ∪ {`50_documentacion/activa/50_ordenacion_repositorio.md`} ∪ {`50_documentacion/estructura/*`}. Además, los asuntos de `git log --format=%s origin/main..origin/ordenacion/20260925` contienen los 5 del a11, en el mismo orden, más el commit del marcador.
5. **Ningún escape del hook:** todos los pushes van como `git push` sin `--no-verify`, con el comando literal en el LOG; `git config --get hooks.cartera` no devuelve `false` al inicio ni al final.
6. **El PR no se mergea:** `gh pr view <número> --json state -q .state` → `OPEN`.
7. **Sin coautoría, sin RUT, sin rutas de usuario en lo agregado:**
   - `git log f560426..origin/main --format=%B | grep -ci co-authored` → 0, y lo mismo sobre `origin/main..origin/ordenacion/20260925`;
   - `git diff f560426..origin/main | grep '^+' | grep -cE '[0-9]{1,2}\.?[0-9]{3}\.?[0-9]{3}-[0-9kK]'` → 0;
   - `... | grep -cF "$HOME"` → 0 (en las dos ramas).

## 4. Tareas

Grafo: T1 → T2 → T3 → T4, en serie. Cada una requiere la anterior completada; si una se congela, sus descendientes no corren. FASE R y FASE L corren siempre.

### Regla de detención

1. Porcelain o rama de M1 y M2 distintos de lo esperado → FASE L.
2. Una ruta de las 14 con alguna coincidencia del patrón de RUT, o con una columna llamada MRUN, RUN o RUT, en la medición de T1 → **T1 congelada, sin autorizar nada**. Se registra la ruta y el conteo, nunca el valor. Es una compuerta de gobernanza del titular.
3. El simulacro del hook (M7, T1 y T2) no da el resultado esperado → la tarea se congela antes del push; no se empuja para «ver qué pasa».
4. Conflicto en el rebase → `git rebase --abort`, T2 congelada.
5. Push denegado → no se reintenta; la tarea se congela.
6. Un 🔒 en FALLA → la tarea de origen se congela; sin push posterior.
7. Cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda con pregunta cerrada y sigue con la próxima independiente (aquí no hay independientes: pasa a FASE R).

### Autorizaciones (lista cerrada)

- `git switch main` y `git switch ordenacion/20260925`.
- Commit en `main` de FASE 0 (encargo y archivo de errores) y de T1 (el archivo de autorización).
- `git push origin main`, **hasta dos veces**: tras T1 (lleva FASE 0 y T1) y tras `docs(log)`. Solo con el simulacro del hook en exit 0 y `HEAD..origin/main` = 0.
- `git rebase main` sobre `ordenacion/20260925`, **solo** si `git ls-remote --heads origin ordenacion/20260925` sale vacío en el mismo turno. `git rebase --abort` si hay conflicto.
- `git push -u origin ordenacion/20260925` y un segundo `git push origin ordenacion/20260925` tras T4. Solo con el simulacro del hook en exit 0. Nunca `--force`.
- `gh pr create --base main --head ordenacion/20260925` **una vez**.
- En la rama: crear `50_documentacion/activa/50_ordenacion_repositorio.md` y correr `00_escanear_proyecto.R`, que escribe y poda `50_documentacion/estructura/` según POLITICA §7.4.
- `git restore docs/index.html` tras un build.
- Temporales en `/tmp/cat_a11b_*` y copias con `rsync -a --exclude .git`.
- Implícitas: `fix(auditoria): R-NN …` y `docs(log): autorización de datos y PR a11b`.

Nada más:

- ni `rm`, `reset`, `checkout --`, `merge`, `gh pr merge`, `--no-verify`, `--force`;
- ni cambios en `hooks.cartera`;
- ni ediciones de las 14 rutas;
- ni ningún archivo fuera de los ALCANCE.

### FASE 0

Primer acto: crear el LOG con el encabezado, el slot vacío `## J. Juicio (lo rellena FASE L)` y el esqueleto. Cada medición lleva `esperado:` antes y `obtenido:` después.

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | rama; porcelain; stash | `ordenacion/20260925`; ` M ...20260925_errores_asistente_sesion32.md`, `?? ...a11b.md` y el LOG; stash vacío | regla 1 |
| M2 | `fetch`; `HEAD`; `origin/main`; `git ls-remote --heads origin`; `git log --format=%s f560426..HEAD`; `git diff --name-only f560426..HEAD`; `git ls-tree -r --name-only HEAD` y `main` con `grep -c 50_datos_versionados_autorizados` | `93f6fa0`; `f560426`; solo `refs/heads/main`; los 5 asuntos del a11; las 10 rutas de §2; 0 y 0 | regla 1 |
| M3 | `git switch main` (lleva la modificación); `HEAD` = `origin/main` = `f560426`; `grep -c '^| [A-Z]' ` sobre el archivo de errores; commit de FASE 0 con las 2 rutas; `<inicio>` | cambio de rama sin conflicto; `f560426`; 6 filas; commit = 2 archivos | regla 1 |
| M4 | `git config --global --get core.hooksPath` (anotado como `<KIT>/githooks`); `git config --get hooks.cartera`; `gh auth status`; `Rscript` con renv: `requireNamespace("readxl")` y `requireNamespace("arrow")` | `<KIT>/githooks`; vacío; exit 0; TRUE y TRUE | T1 congelada si falta un paquete; T3 congelada si falla `gh` |
| M5 | I8 de `95_verificar_cierre.R` sobre `<RAIZ>` (se anota solo su línea; los demás invariantes no se juzgan aquí) | I8 FALLA, con «14 rutas de datos versionadas y sin lista de autorizacion» (así, sin tilde, lo imprime el script) | se registra |
| M6 | `git hash-object` de las 14 rutas | = columna Hash de §1 | regla 7 |
| M7 | **simulacro del hook sobre la rama** sin empujar: `printf 'refs/heads/ordenacion/20260925 %s refs/heads/ordenacion/20260925 %s\n' "$(git rev-parse ordenacion/20260925)" 0000000000000000000000000000000000000000 \| bash "$HERRAMIENTAS_DEV_PATH/githooks/pre-push" origin https://github.com/tomgc/slep_categoria_desempeno.git`, con la carpeta de trabajo en `main` | exit 1 y 14 líneas `R1`, las mismas del a11. Es el control positivo del simulacro: reproduce la denegación | si no reproduce, el simulacro no vale como predictor: T1 a T4 congeladas |

### T1: medición en R y archivo de autorización (en `main`)

- **ALCANCE:** `50_documentacion/activa/50_datos_versionados_autorizados.md`.
- Pasos:
  1. Script `/tmp/cat_a11b_rut.R`, desde la raíz con renv. Por cada una de las 14 rutas, lee **todo** el contenido como texto:
     - `.xlsx`: `readxl::excel_sheets()` y `readxl::read_excel(col_names = FALSE, col_types = "text")` por hoja;
     - `.csv` y `.json`: `readLines()`;
     - `.parquet`: `arrow::read_parquet()` y `as.character()` por columna.
  2. Por ruta, informa:
     - `n` (celdas, valores o líneas no vacías);
     - coincidencias de `"[0-9]{1,2}\\.?[0-9]{3}\\.?[0-9]{3}-[0-9kK]"`;
     - columnas cuyo nombre calza con `"(?i)(^|_)(m?run|rut)(_|$)"` (para `.xlsx`, la primera fila de cada hoja; para `.csv`, el encabezado; para `.parquet`, `names()`).
  3. **Validez de lectura:**
     - `.csv` y `.json`: `length(readLines())` = `wc -l` + 0 o 1 (según el salto final, declarado);
     - `.parquet`: `nrow()` = `num_rows` de los metadatos (`arrow::ParquetFileReader`);
     - `.xlsx`: número de hojas leídas = `length(excel_sheets())`.
  4. **Control positivo en el mismo script, en memoria:** un RUT sintético armado por concatenación (`paste0("12.345.", "678-5")`; el literal completo no se escribe en ningún archivo del repo ni en el LOG, porque R3 del hook lo rechazaría en el push) da 1; `"RBD 1234-5"` da 0; un `names()` con `"RUT_SOSTENEDOR"` da 1; `"DV"` da 0.
  5. Escribir el archivo con el texto fijo de §1, sustituyendo cada `<n>` por el `n` medido. Sin comodines; 14 entradas.
- Verificación (`esperado:` antes):
  - 0 coincidencias y 0 columnas sospechosas en las 14 rutas (si no, regla 2);
  - el control positivo da 1, 0, 1 y 0;
  - las entradas del primer bloque cercado, parseadas como las parsea el hook (`awk` de las líneas 57 a 60 del hook), son exactamente las 14 rutas de §1;
  - I8 PASA con «14 rutas de datos, 14 cubiertas por la lista de autorizacion»;
  - **simulacro del hook sobre `main`** como rama nueva: `printf 'refs/heads/x %s refs/heads/x 0000000000000000000000000000000000000000\n' "$(git rev-parse HEAD)" | bash .../pre-push origin <url>` → exit 0. Se corre con el archivo ya creado, antes del commit, sobre el `HEAD` de `main`. Esperado exit 0, porque las 14 quedan cubiertas y la ruta del archivo es `.md`;
  - `git status --porcelain` = `?? 50_documentacion/activa/50_datos_versionados_autorizados.md` (más el LOG).
- Commit `docs(gobernanza): autoriza los 14 archivos de datos públicos versionados (a11b)`.
- Simulacro del hook para el push real: `printf 'refs/heads/main %s refs/heads/main %s\n' "$(git rev-parse HEAD)" f560426a3ef5fda1919947b93cdfe1b3c94a4ae0 | bash .../pre-push ...` → exit 0. Después, `git push origin main` (push de `main` 1). Esperado `f560426..<nuevo> main -> main`.

### T2: rebase y publicación de la rama del a11

- **ALCANCE:** `ordenacion/20260925` (sin archivos nuevos).
- Pasos:
  1. `git switch ordenacion/20260925`.
  2. `git ls-remote --heads origin ordenacion/20260925` vacío.
  3. `git rebase main`.
- Verificación (`esperado:` antes):
  - rebase sin conflicto;
  - `git log --format=%s main..HEAD` = los 5 asuntos del a11 en orden;
  - `git diff --name-only main...HEAD` = las 10 rutas de §2;
  - `git ls-tree -r --name-only HEAD | grep -c 50_datos_versionados_autorizados` = 1;
  - los 🔒1 a 🔒5 y 🔒7 a 🔒9 del a11, re-corridos con `$(git merge-base main HEAD)` en lugar de `f560426`: PASA. El 🔒6 del a11 ya no aplica, porque `main` avanzó por diseño; se declara;
  - simulacro del hook para la rama nueva (remote cero), con la carpeta de trabajo en la rama → exit 0. Cuenta: las 14 rutas quedan cubiertas por la lista, que ahora está en la carpeta de trabajo; R3 lee el parche del último commit (`docs(log)` del a11), cuyo LOG pasó el grep de RUT en la FASE L del a11.
- `git push -u origin ordenacion/20260925` (push de la rama 1).

### T3: PR

- `gh pr create --base main --head ordenacion/20260925`:
  - título `Ordenación del repositorio (política v5.5, SETTINGS §4.7)`;
  - cuerpo en español con los cuatro bloques y las filas canceladas (del LOG del a11), las dudas D1 a D3, D4 resuelta por el a11b, y las rutas de los dos LOG. Sin atribución.
- Anotar número y URL. Verificación: `gh pr view <número> --json state,baseRefName,headRefName` → `OPEN`, `main`, `ordenacion/20260925`.

### T4: marcador y escáner final (repite T5 del a11 sobre la rama)

- **ALCANCE:** `50_documentacion/activa/50_ordenacion_repositorio.md` y `50_documentacion/estructura/`.
- Pasos:
  1. Línea base del escáner en una copia (`rsync -a --exclude .git "$RAIZ"/ /tmp/cat_a11b_copia/` y el escáner allí): `carpetas_base` y `archivos_base`.
  2. Crear el marcador con el contenido que fija el a11, §4 T5 paso 2, copiado de los LOG del a11 y del a11b. Lleva:
     - fecha 2026-09-26;
     - rama;
     - número y URL del PR;
     - hashes de los commits de cada bloque **tras el rebase**;
     - conteos por bloque (B1: 0; B2: 4, de ellos 3 versionados; B3: 1 renombre; B4: 1 script corregido);
     - filas canceladas;
     - lo que quedó fuera;
     - dudas D1 a D3;
     - D4 resuelta por el a11b, con el hash del commit de autorización.
  3. Escáner final (`Rscript 00_escanear_proyecto.R` desde la raíz, con renv), **último acto que toca el árbol** de la rama.
- Verificación (`esperado:` antes):
  - un snapshot sellado nuevo, aliases iguales a él y 2 timestamps sellados;
  - línea `Raiz` = `slep_categoria_desempeno`;
  - `grep -cF "$HOME"` = 0;
  - `carpetas` = `carpetas_base`;
  - `archivos` = `archivos_base + 1` (entra el marcador; entre la línea base y el escáner no corre ninguna prueba que escriba en `tests/reportes/`);
  - si difiere, cada archivo de la diferencia se lista (ADVIERTE).
- Commit `docs(ordenacion): marcador y escáner final (a11b)`, con `git add -- 50_documentacion/activa/50_ordenacion_repositorio.md 50_documentacion/estructura`.
- Simulacro del hook para la rama ya publicada (remote = `origin/ordenacion/20260925`) → exit 0. Después, `git push origin ordenacion/20260925` (push de la rama 2).

### FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta.

1. **Inventario** `R-01…` derivado del LOG, anexado antes de auditar.
2. **Re-derivación con otro comando:**
   - conteos de RUT: con un segundo lector (`openxlsx2` si está; si no, `unzip -p` de `xl/sharedStrings.xml` y `xl/worksheets/*.xml` con `grep -cE`), `.csv` con `grep -cE`, `.parquet` con `arrow::open_dataset` y `dplyr`, si antes fue con los lectores de T1;
   - estado remoto: con `git ls-remote` y `gh api repos/tomgc/slep_categoria_desempeno/pulls/<número>`, si antes fue con `git log` y `gh pr view`;
   - totales del escáner: con `find` y las mismas exclusiones.
3. **Invariantes:** comando de cada 🔒, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only f560426..origin/main` y `git diff --name-only origin/main...origin/ordenacion/20260925` contra los ALCANCE, más `git status --porcelain`.
5. **Regresión:** PRUEBAS a y b sobre la rama final (después del escáner; los reportes nuevos de `tests/reportes/` no se versionan).
6. **Control positivo de la auditoría:**
   - en una copia fuera del árbol, una línea con el RUT sintético (armado por concatenación, nunca escrito literal) agregada a una copia del `.csv` → el conteo de T1 da 1;
   - una entrada quitada de una copia del archivo de autorización → el simulacro del hook da exit 1 con 1 línea `R1`.
7. **Veredicto por hallazgo:**
   - **BLOQUEA:** 🔒 en FALLA, RUT encontrado, alcance violado o historia divergente;
   - **REPARA:** defecto propio dentro del ALCANCE;
   - **ADVIERTE:** se registra.
8. **Máximo 2 ciclos:** causa raíz; fix; re-verificación doble; regresión; commit `fix(auditoria): R-NN …`; fila en la tabla.
9. **Prohibido:** ajustar criterios, ampliar un ALCANCE, tocar un 🔒, editar lo ya escrito en el LOG, reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto global.

### FASE L: cierre del log (última, obligatoria)

1. `git switch main` (el LOG viaja sin versionar). `git status --porcelain` = solo el LOG; otra cosa es hallazgo.
2. Cierre del LOG:
   - resumen;
   - commits de las dos ramas (`git log --oneline f560426..main` y `git log --oneline main..ordenacion/20260925`);
   - la tabla de medición de T1 (ruta, `n`, coincidencias, columnas sospechosas, validez de lectura) **sin valores de celdas**;
   - tabla de FASE R;
   - 🔒 con evidencia;
   - número y URL del PR;
   - dudas D1 a D3 abiertas y las nuevas, con pregunta cerrada;
   - errores propios;
   - notas para el revisor.
3. Bloque J de trece campos, copiado del detalle.
4. Privacidad sobre el LOG: el grep de RUT da vacío, `grep -cF "$HOME"` = 0, y una lectura confirma que no hay nombres de establecimiento ni de personas.
5. `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE' <LOG>`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. `git add` del LOG y commit `docs(log): autorización de datos y PR a11b` en `main`. Simulacro del hook (exit 0) y `git push origin main` (push de `main` 2).
7. Estado de cierre: checkout en `main`, igual a `origin/main`, con porcelain vacío; la rama publicada; el PR `OPEN`; lo que queda al titular (revisar y mergear el PR).

## 5. Reporte final

- **Primera línea:** la salida literal de `ls -l <LOG> && wc -l <LOG>` y el hash de `docs(log)`.
- **Segundo bloque:** el bloque J tal cual.
- **Después:**
  - la tabla de medición de T1 (sin valores);
  - I8 antes y después;
  - los tres simulacros del hook y los cuatro pushes, con su salida;
  - número y URL del PR;
  - hashes del rebase;
  - totales del escáner con su cuenta;
  - resultado de cada 🔒;
  - PRUEBAS a y b;
  - dudas;
  - lo que falló o sorprendió (si nada, decirlo).
