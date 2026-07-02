# Encargo autónomo — Saneamiento incidente PII (Fase 2)

## Contrato

- Modo autónomo, secuencial, ejecuta todo en este turno.
- Regla de detención: PARA y reporta si (a) `git-filter-repo` produce un
  resultado inesperado (conteo de commits reescritos distinto a 1, o
  `origin/main` no coincide tras el push), (b) el CSV depurado pierde
  filas respecto al crudo, (c) el push force-with-lease es rechazado.
- Rutas absolutas siempre. Sin `cd` previo asumido.
- Proyecto: `/Users/tomgc/Projects/slep_categoria_desempeno`
- R-only para cualquier transformación de datos.

## Contexto

Auditoría de Fase 1 confirmó: `directorio_oficial_ee.csv` (MRUN,
RUT_SOSTENEDOR pobladas en 16.768/16.768 filas) trackeado, sin regla
`.gitignore`, publicado en `origin/main` en un único commit `4751373`
(2026-06-11). `git-filter-repo` disponible en
`/opt/homebrew/bin/git-filter-repo`. Referencia de patrón de depuración:
`31_depurar_directorio_oficial.R` de `slep_idps` (adjunto).

## Invariantes 🔒

- 🔒 No se pierde ninguna columna no sensible del CSV original.
- 🔒 El CSV depurado debe tener exactamente 16.768 filas de datos (mismo
  conteo que el crudo).
- 🔒 `origin/main` tras el push debe seguir siendo la única fuente de
  verdad remota (no crear ramas paralelas, no dejar el remoto en estado
  divergente sin resolver).
- 🔒 El repo local debe quedar con un solo remote `origin` apuntando al
  mismo URL de antes (filter-repo elimina remotes por defecto: hay que
  reagregarlo).
- 🔒 No commitear el CSV crudo en ningún commit nuevo.

## Fases

### Fase 0 — Confirmar estado real antes de tocar nada

```
git -C /Users/tomgc/Projects/slep_categoria_desempeno status
git -C /Users/tomgc/Projects/slep_categoria_desempeno log --oneline -5
```
Confirmar working tree limpio y que sigues sobre `4751373` como el commit
que introdujo el archivo (no reconfirmar toda la Fase 1, solo estado
actual).

### Fase 1 — Rastrear puntos de lectura del CSV crudo en el pipeline

```
grep -rn "directorio_oficial_ee" /Users/tomgc/Projects/slep_categoria_desempeno/30_procesamiento/
grep -rn "directorio_oficial_ee" /Users/tomgc/Projects/slep_categoria_desempeno/00_run_all.R
```
Listar cada archivo y línea que referencia el CSV crudo (`30_construir_auxiliares.R`,
`31_leer_normalizar.R`, `32_agregar_territorial.R`, orquestador, u otros).
Esto define qué scripts hay que repuntar hacia la versión pública.

### Fase 2 — Crear script de depuración (adaptado del patrón slep_idps)

Crear `/Users/tomgc/Projects/slep_categoria_desempeno/20_insumos/auxiliares/31_depurar_directorio_oficial.R`,
adaptando el script de `slep_idps` (adjunto) a este proyecto:
- Mismas columnas sensibles: `MRUN`, `RUT_SOSTENEDOR`.
- Origen: `20_insumos/auxiliares/directorio_oficial_ee.csv`.
- Destino: `20_insumos/auxiliares/directorio_oficial_ee_publico.csv`.
- Conservar la validación pre/post (columnas esperadas presentes antes,
  ausentes después) y la escritura atómica.
- Detectar el delimitador/encoding real del CSV de este proyecto (Fase 1
  de la auditoría ya lo confirmó: `;`, UTF-8 con BOM — ajustar
  `locale()` si el BOM requiere manejo distinto al de `slep_idps`).

Ejecutar el script. Verificar 🔒 (16.768 filas, columnas sensibles
ausentes en el output, resto de columnas intacto).

### Fase 3 — Repuntar el pipeline a la versión pública

Para cada punto de lectura encontrado en Fase 1, cambiar la referencia
de `directorio_oficial_ee.csv` a `directorio_oficial_ee_publico.csv`.
Ejecutar `00_run_all.R` (o los pasos 30-32 relevantes) y confirmar que
el pipeline corre sin error con el nuevo insumo.

### Fase 4 — .gitignore

Agregar a `/Users/tomgc/Projects/slep_categoria_desempeno/.gitignore`:
```
# Datos personales identificables (MRUN, RUT_SOSTENEDOR) — nunca versionar
20_insumos/auxiliares/directorio_oficial_ee.csv
```
Comentario explicando el porqué (ver patrón de comentarios existente en
el archivo).

### Fase 5 — Commit del saneamiento del working tree (previo a reescribir historial)

Commit atómico, path-scoped (nunca `git add .`):
```
git -C /Users/tomgc/Projects/slep_categoria_desempeno add <rutas exactas tocadas>
git -C /Users/tomgc/Projects/slep_categoria_desempeno commit -m "fix(gobernanza): depurar PII de directorio_oficial_ee, repuntar pipeline a version publica"
```
No incluir el CSV crudo en este commit.

### Fase 6 — git rm --cached del crudo si aún queda trackeado

Verificar si `directorio_oficial_ee.csv` sigue en el índice tras Fase 5.
Si sí:
```
git -C /Users/tomgc/Projects/slep_categoria_desempeno rm --cached 20_insumos/auxiliares/directorio_oficial_ee.csv
git -C /Users/tomgc/Projects/slep_categoria_desempeno commit -m "chore(gobernanza): remover directorio_oficial_ee.csv del indice (PII, ver .gitignore)"
```

### Fase 7 — Reescritura de historial con git-filter-repo

**Antes de ejecutar, respaldo obligatorio:**
```
cp -r /Users/tomgc/Projects/slep_categoria_desempeno /Users/tomgc/Projects/slep_categoria_desempeno_BACKUP_PRE_FILTER_REPO
```

Guardar el URL del remote actual:
```
git -C /Users/tomgc/Projects/slep_categoria_desempeno remote get-url origin
```

Ejecutar filter-repo para purgar el archivo de TODO el historial:
```
git -C /Users/tomgc/Projects/slep_categoria_desempeno filter-repo --path 20_insumos/auxiliares/directorio_oficial_ee.csv --invert-paths --force
```

Reagregar el remote (filter-repo lo elimina por diseño):
```
git -C /Users/tomgc/Projects/slep_categoria_desempeno remote add origin <URL guardado>
```

Verificar que el archivo ya no existe en NINGÚN commit del historial
reescrito:
```
git -C /Users/tomgc/Projects/slep_categoria_desempeno log --all --full-history --oneline -- 20_insumos/auxiliares/directorio_oficial_ee.csv
```
Debe devolver vacío. Si no está vacío, DETENTE y reporta (regla de
detención).

### Fase 8 — Push force-with-lease

```
git -C /Users/tomgc/Projects/slep_categoria_desempeno push origin main --force-with-lease
```
Si es rechazado, DETENTE y reporta (no usar `--force` a secas sin
autorización explícita).

### Fase 9 — Reclasificación de gobernanza_datos.md

Reescribir `/Users/tomgc/Projects/slep_categoria_desempeno/50_documentacion/activa/gobernanza_datos.md`:
- Eliminar la clasificación "Rama A, 100% público, ninguna base contiene
  RUT".
- Documentar el incidente: qué columnas, cuántas filas, commit original,
  fecha de detección (2026-07-01), fecha de saneamiento (hoy), método
  (filter-repo + push force-with-lease).
- Documentar el patrón vigente: crudo en `.gitignore`, script
  `31_depurar_directorio_oficial.R`, solo la versión `_publico.csv` se
  versiona.
- Mantener el resto del documento (categoría de desempeño en sí sigue
  siendo dato público válido; el incidente fue solo el catálogo auxiliar).

## Criterios de éxito verificables

- Fase 2: conteo de filas del CSV depurado = 16.768. Columnas `MRUN` y
  `RUT_SOSTENEDOR` ausentes (`intersect()` vacío).
- Fase 3: pipeline corre sin error, output final (`categoria_rbd.parquet`
  u otro intermedio que dependa del directorio) sin cambios de cifras
  atribuibles al cambio de insumo (mismo conteo de RBDs).
- Fase 7: `git log --all --full-history` para el CSV crudo devuelve
  vacío tras la reescritura.
- Fase 8: `git ls-tree origin/main` (tras el push) no contiene el CSV
  crudo en ningún blob alcanzable.

## Mandato de auto-auditoría

Riesgo de datos alto (reescritura de historial público + PII). Antes de
reportar, lanzar verificación independiente:
```
git -C /Users/tomgc/Projects/slep_categoria_desempeno log --all --full-history -- 20_insumos/auxiliares/directorio_oficial_ee.csv
git -C /Users/tomgc/Projects/slep_categoria_desempeno cat-file --batch-all-objects --batch-check 2>/dev/null | grep -i "directorio_oficial_ee.csv" || echo "sin coincidencias"
```
Confirmar ambos comandos vacíos antes de declarar el saneamiento exitoso.

## Log de cierre

Generar `50_documentacion/andamios/logs/20260701_saneamiento_pii_directorio_log.md`
con la plantilla fija (sección 4 de `encargo_autonomo_claude_code_v1.md`):
resumen, inventario de commits, verificación de invariantes 🔒 con
evidencia, estado del backup, confirmación de vacío en Fase 7/8, y
pendientes (p.ej. notificar a colaboradores que deben re-clonar el repo,
ya que el historial fue reescrito).

No cerrar la sesión ni proponer cierre: eso lo decide el usuario.
