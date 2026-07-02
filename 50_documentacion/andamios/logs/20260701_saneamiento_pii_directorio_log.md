# Log de saneamiento — Incidente PII `directorio_oficial_ee.csv`

- **Fecha:** 2026-07-01
- **Encargo:** `encargo_saneamiento_pii_fase2_v1_retry.md`
- **Proyecto:** `slep_categoria_desempeno`

## 1. Resumen

El crudo `20_insumos/auxiliares/directorio_oficial_ee.csv` contenía datos personales
identificables (`MRUN`, `RUT_SOSTENEDOR`, poblados en 16.768/16.768 filas),
versionado y publicado en `origin/main` (repo público) desde el commit `4751373`
(2026-06-11). Saneamiento del 2026-07-01: depuración a una versión pública, repunte
del pipeline, `.gitignore` + `git rm --cached`, reescritura de **todo** el historial
con `git-filter-repo` y `git push --force-with-lease`. Resultado: el crudo ya no
existe en ningún commit del historial (local ni remoto); el pipeline consume la
versión depurada; las cifras del producto no cambian (RBD = 10.945 antes y después).

## 2. Inventario de commits

Historial reescrito: **116 commits** resultantes (todos los descendientes de
`4751373` obtuvieron hash nuevo). Commits del saneamiento:

- `8362749` — `fix(gobernanza): depurar PII de directorio_oficial_ee, repuntar
  pipeline a version publica`. Contiene: `31_depurar_directorio_oficial.R`,
  `directorio_oficial_ee_publico.csv`, repunte de `30_construir_auxiliares.R`,
  regla en `.gitignore`.
- El commit `chore(gobernanza): remover … del indice` (`git rm --cached`) quedó
  **vacío** tras purgar el blob y `git-filter-repo` lo podó — comportamiento
  esperado y correcto (el crudo nunca existe en la historia reescrita).
- `4751373` reescrito → nuevo hash, ya sin el CSV en su árbol.
- (encima) `docs(gobernanza): reclasificar tras incidente PII + log de saneamiento`
  — reclasificación de `gobernanza_datos.md` y este log.

## 3. Verificación de invariantes 🔒 (con evidencia)

- 🔒 **Ninguna columna no sensible perdida:** `directorio_oficial_ee_publico.csv` =
  crudo menos `{MRUN, RUT_SOSTENEDOR}`; `diff` byte a byte tras normalizar CRLF→LF =
  **0 líneas**. 56 columnas (58−2).
- 🔒 **16.768 filas en el depurado:** `wc -l` (16.769 − header) y `nrow()` = 16.768.
- 🔒 **`origin/main` única fuente de verdad remota:** `--force-with-lease` sobre
  `main` (lease anclado a `00f2502`); sin ramas paralelas; `origin/main == HEAD`
  local (`8362749`).
- 🔒 **Remote `origin` re-agregado** al mismo URL
  (`https://github.com/tomgc/slep_categoria_desempeno.git`).
- 🔒 **Crudo no commiteado en ningún commit nuevo:** el commit de Fase 5 stageó solo
  script + `_publico.csv` + repunte + `.gitignore` (verificado path-scoped).

## 4. Estado del backup

`/Users/tomgc/Projects/slep_categoria_desempeno_BACKUP_PRE_FILTER_REPO` — 66 MB, con
`.git` y el crudo original (historia pre-rewrite íntegra, 117 commits).
**Contiene PII:** no publicar ni versionar; eliminar una vez confirmado el
saneamiento por el titular.

## 5. Confirmación de vacío (Fases 7/8)

- `git log --all --full-history -- <crudo>`: **VACÍO** (local y remoto).
- Blob original `f6c0362c…`: **no alcanzable** desde ningún ref (`rev-list --objects`).
- `git ls-tree -r origin/main`: crudo **AUSENTE**; `directorio_oficial_ee_publico.csv`
  **PRESENTE**.
- Push: `00f2502...8362749  main -> main (forced update)`.

## 6. Pendientes

- **Notificar a colaboradores:** el historial fue reescrito; cualquier clon previo
  debe **re-clonarse** (los hashes anteriores ya no existen en `origin`). Los PR/
  branches abiertos basados en el historial viejo quedarán divergentes.
- **Eliminar el backup** `..._BACKUP_PRE_FILTER_REPO` cuando el titular confirme el
  saneamiento (contiene el crudo con PII).
- **Exposición residual (relevante):** el `RUT_SOSTENEDOR` estuvo **público** entre
  2026-06-11 y 2026-07-01; terceros pudieron clonar/scrapear el repo o forks en ese
  lapso. La reescritura de historial **no** revierte una exposición ya ocurrida.
  GitHub puede conservar objetos en caché (vistas de commit por SHA, forks, PRs)
  hasta su GC; evaluar con el titular si contactar a soporte de GitHub para purga
  del lado servidor. La rotación de un RUT no es posible; el titular debe evaluar el
  impacto según el marco de Ley 21.719.
- Untracked no relacionados (traspasos v25/v26, `encargos/`, `resena_*`, andamios)
  siguen sin versionar; decisión aparte.
