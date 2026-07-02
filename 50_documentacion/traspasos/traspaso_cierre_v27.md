# Traspaso de cierre — slep_categoria_desempeno v27

## 1. Identificación

- **Proyecto:** slep_categoria_desempeno
- **Versión:** v27
- **Fecha:** 2026-07-01
- **Sesión:** 27, CONTINUATION. Foco único: incidente de gobernanza PII
  en `directorio_oficial_ee.csv` (auditoría + saneamiento completo).
- **Entorno:** chat conversacional (análisis) + Claude Code (ejecución).
- **Archivos principales modificados:** `directorio_oficial_ee.csv`
  (purgado del historial), `31_depurar_directorio_oficial.R` (nuevo),
  `directorio_oficial_ee_publico.csv` (nuevo), `30_construir_auxiliares.R`,
  `.gitignore`, `gobernanza_datos.md`, `ESTADO.md`, `POLITICA_PROYECTO.md`,
  `SETTINGS_Y_PROMPTS_OPERACIONALES.md`, snapshots de estructura.

## 2. Resumen ejecutivo

La sesión abrió como continuación directa de v26, con el incidente PII
como único pendiente de prioridad 1. La auditoría (Fase 1, solo lectura)
confirmó que `directorio_oficial_ee.csv` tenía `MRUN` y `RUT_SOSTENEDOR`
pobladas en 16.768/16.768 filas, trackeado sin regla `.gitignore` y
publicado en `origin/main` desde el commit `4751373` (2026-06-11). El
saneamiento (Fase 2) depuró el CSV al patrón de `slep_idps`, repuntó el
pipeline, y reescribió los 116 commits del historial con
`git-filter-repo`, seguido de `push --force-with-lease`. Auto-auditoría
independiente confirmó purga completa (log vacío, blob no alcanzable) sin
alterar cifras del producto (RBD = 10.945 antes y después). Se
reclasificó `gobernanza_datos.md` (deroga "Rama A 100% público"). Backup
local con PII eliminado tras confirmación. Decisión de exposición
residual (20 días públicos): riesgo aceptado, sin gestión con GitHub.
Sesión cerrada con el incidente resuelto en sus dos ejes técnico y de
gobernanza.

## 3. Estado al cierre

**Funciona:**
- Pipeline completo (pasos 30-32) corre sobre `directorio_oficial_ee_publico.csv`,
  sin error, mismo conteo de establecimientos (10.945) que antes del cambio
  de insumo. Última ejecución: sesión 27, Fase 3 del saneamiento.
- `origin/main` sincronizado con local en `fdfd5d6`, sin PII en ningún
  commit alcanzable (verificado por `rev-list --objects` y `ls-tree -r`).
- `.gitignore` cubre el crudo (`directorio_oficial_ee.csv`) hacia
  adelante.

**No funciona / pendiente:**
- Ninguna falla funcional detectada. Pendientes son de gobernanza y
  administración (sección 8).

**Delta respecto a v26:** el incidente PII, único pendiente de prioridad
1 heredado, queda cerrado. No hubo trabajo de producto (motor, cifras,
UI) en esta sesión.

## 4. Registro detallado de cambios

### 4.1 Auditoría PII (solo lectura)

- **Qué:** encargo de 6 fases ejecutado por Claude Code, confirmando
  esquema del CSV, estado del índice, historial completo, contenido
  histórico, publicación en remoto, disponibilidad de `git-filter-repo`.
- **Por qué:** decidir el saneamiento sin datos reales habría sido
  fabricar metodología (antipatrón documentado en
  `encargo_autonomo_claude_code_v1.md` §7).
- **Cómo se verificó:** comandos `git log`, `git show`, `merge-base
  --is-ancestor` ejecutados directamente, sin inferencia.
- **Hallazgo:** 1 commit de origen (`4751373`), publicado en
  `origin/main`, `git-filter-repo` ya disponible vía Homebrew.

### 4.2 Interrupción por árbol sucio (antes de Fase 2)

- **Qué:** Claude Code se detuvo en Fase 0 del encargo de saneamiento al
  encontrar 2 commits locales sin pushear y working tree con cambios no
  relacionados (docs, rotación de snapshots).
- **Por qué:** `filter-repo --force` sobre árbol sucio habría descartado
  cambios tracked no commiteados; el push force-with-lease habría
  publicado commits ajenos al saneamiento como efecto colateral
  (invariante 🔒 de única fuente de verdad remota).
- **Resolución:** dos commits temáticos separados (`3703bb4` docs de
  ESTADO/POLITICA/SETTINGS; `00f2502` rotación de snapshots), push normal
  de los 4 commits pendientes antes de tocar el historial. Untracked no
  relacionados (encargos, traspasos v25/v26, reseña, andamio) se dejaron
  sin versionar, decisión aparte.
- **Patrón aprendido:** separar el riesgo de "contenido nuevo" del riesgo
  de "reescritura de historial" en dos operaciones de push distintas,
  con punto de verificación intermedio.

### 4.3 Depuración del CSV y repunte del pipeline

- **Qué:** `31_depurar_directorio_oficial.R` creado en
  `20_insumos/auxiliares/`, adaptado del patrón de `slep_idps` (mismas
  columnas sensibles: `MRUN`, `RUT_SOSTENEDOR`). Genera
  `directorio_oficial_ee_publico.csv`. `30_construir_auxiliares.R`
  repuntado a leer la versión pública (única referencia funcional al
  crudo en todo el pipeline; `31_leer_normalizar.R` y
  `32_agregar_territorial.R` no lo referencian, consumen parquets).
- **Por qué:** eliminar el crudo del índice sin dejar el pipeline roto.
- **Cómo se verificó:** invariantes 🔒 — 16.768 filas, 56 columnas
  (58−2), columnas sensibles ausentes (`intersect()` vacío), diff
  byte a byte contra el crudo tras normalizar CRLF→LF = 0 líneas
  diferentes. Pipeline completo corrido end-to-end, mismo conteo de RBD.
- **Nota:** `docs/index.html` cambió 1 línea (JSON embebido) tras la
  regeneración pese a cifras idénticas (timestamp de generación,
  esperado); se revirtió para mantener el commit del saneamiento
  enfocado solo en gobernanza.

### 4.4 Reescritura de historial (git-filter-repo)

- **Qué:** backup completo pre-reescritura
  (`slep_categoria_desempeno_BACKUP_PRE_FILTER_REPO`, 66 MB, con `.git`);
  `git-filter-repo --path <crudo> --invert-paths --force` sobre 117
  commits, resultando en 116 (el commit de `rm --cached` quedó vacío y
  fue podado, comportamiento esperado); remote `origin` reagregado al
  mismo URL (se pierde por diseño de la herramienta); push
  `--force-with-lease` anclado al SHA remoto exacto verificado antes de
  forzar.
- **Por qué:** purgar el blob de TODA la historia, no solo del working
  tree; el archivo persistió sin cambios desde `4751373` hasta HEAD, por
  lo que la reescritura afecta en cascada a todos sus descendientes.
- **Ambigüedad resuelta en el chat:** la regla de detención literal del
  encargo ("PARA si el conteo de commits reescritos es distinto a 1")
  habría bloqueado la operación por diseño (114 ≠ 1 siempre). Se
  confirmó explícitamente que el criterio de éxito real es `git log
  --all --full-history` vacío para el crudo, no el conteo de commits
  reescritos. Documentado aquí para que la próxima sesión no reinterprete
  la regla al pie de la letra en un contexto similar.
- **Cómo se verificó:** `git log --all --full-history` vacío (local y
  remoto); blob original no alcanzable vía `rev-list --objects`;
  `ls-tree -r origin/main` sin el crudo, con `_publico.csv` presente;
  push confirmado `00f2502...8362749 main -> main (forced update)`.

### 4.5 Reclasificación de gobernanza

- **Qué:** `gobernanza_datos.md` reescrito: derogada la clasificación
  "Rama A, 100% público, ninguna base contiene RUT"; documentado el
  incidente (columnas, filas, commit origen, fechas de detección y
  saneamiento, método); documentado el patrón vigente (crudo en
  `.gitignore`, script de depuración, solo `_publico.csv` se versiona).
- **Por qué:** el documento de gobernanza previo era la causa raíz del
  incidente (no distinguía crudo de depurado, y clasificaba el proyecto
  sin datos personales cuando sí los tenía).
- **Cómo se verificó:** lectura completa antes de editar; el resto del
  documento (categoría de desempeño en sí como dato público válido) se
  conservó sin cambios.

### 4.6 Decisiones de gate del usuario

- **Exposición residual (20 días públicos, 2026-06-11 a 2026-07-01):**
  riesgo aceptado. No se contacta a soporte de GitHub para GC del lado
  servidor (repo pequeño, sin evidencia de scraping ni forks de
  terceros).
- **Backup local con PII:** eliminado inmediatamente tras confirmar el
  saneamiento (`rm -rf .../slep_categoria_desempeno_BACKUP_PRE_FILTER_REPO`,
  verificado con `ls`).

## 5. Backlog acumulativo

Ver `50_documentacion/activa/backlog_acumulativo.md` (no adjuntado en
esta sesión; el asistente no tiene el contenido íntegro para copiarlo).
**Pendiente de acción para la próxima apertura:** adjuntar
`backlog_acumulativo.md` real y agregar la entrada correlativa
correspondiente a esta sesión (tema: gobernanza de datos / incidente
PII), continuando la numeración global sin renumerar entradas previas.
Entrada propuesta para cuando se adjunte:

> **N (siguiente correlativo).** Auditoría y saneamiento de incidente PII
> en `directorio_oficial_ee.csv` (MRUN, RUT_SOSTENEDOR): depuración,
> repunte de pipeline, reescritura de historial con `git-filter-repo`,
> reclasificación de `gobernanza_datos.md`. Categoría temática: deuda de
> datos / gobernanza.

## 6. Bugs de la sesión

Ninguno de código. La "interrupción por árbol sucio" (§4.2) no es un bug:
es la regla de detención funcionando como debía ante un supuesto del
encargo que no se cumplía en el estado real.

## 7. Aprendizajes y restricciones (nuevas, esta sesión)

- **Reglas de detención cuantitativas en encargos de reescritura de
  historial deben expresarse en términos del criterio de éxito real**
  (p.ej. "log vacío para la ruta purgada"), no en conteo de commits
  afectados, que es inherentemente variable según la profundidad del
  archivo en el historial. Aplicar este matiz al redactar encargos
  futuros de `filter-repo` en cualquier proyecto hermano.
- **Separar el push de "contenido nuevo pendiente" del push de
  "reescritura de historial"** en dos operaciones distintas, con
  verificación intermedia del remoto, cuando ambas coinciden en una
  misma sesión.
- Confirmado (no nuevo, pero reforzado): el patrón de
  `31_depurar_directorio_oficial.R` de `slep_idps` es reutilizable
  directamente entre proyectos hermanos con el mismo insumo
  (`directorio_oficial_ee.csv`), incluyendo el manejo de BOM UTF-8.

## 8. Pendientes (mapa de la próxima ruta)

| # | Descripción | Prioridad | Bloqueante | Acción requerida |
|---|---|---|---|---|
| 1 | Adjuntar `backlog_acumulativo.md` real y agregar la entrada de esta sesión (§5) | media | no | usuario adjunta el archivo |
| 2 | Notificar/re-clonar: cualquier clon previo del repo (si existe) debe re-clonarse; historial reescrito invalida hashes anteriores | media | no | usuario, acción manual, una vez |
| 3 | s21 slep_categoria_desempeno: documentar cierre de gobernanza 4b/depe4 en archivo de decisiones; revisar 2 marcadores `# REVISAR` en `documentar.R`; transferir entradas al backlog histórico | baja | no | heredado de v21, no tocado esta sesión |
| 4 | Untracked sin versionar: `encargos/` (los dos encargos PII), `resena_slep_categoria_desempeno.md`, `andamios/compass_artifact_*.md`, `traspaso_cierre_v25.md`, `traspaso_cierre_v26.md` | baja | no | decisión aparte: versionar o no |

## 9. Errores del asistente (registro obligatorio)

| momento | disparador | que_paso | regla_violada | estado |
|---|---|---|---|---|
| — | — | Sin errores registrados en esta sesión | — | n/a |

## 10. Registro de ejecución detallado

`50_documentacion/andamios/logs/20260701_saneamiento_pii_directorio_log.md`
(log de la sesión de Claude Code; detalle paso a paso no reproducido
aquí).

## 11. Reapertura

**Nombre del chat:** `slep_categoria_desempeno, sesión 28 (Claude Sonnet 5)`

**Mensaje de apertura pre-armado:**

> Sesión 28, CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del
> proyecto. Adjunto el traspaso v27 y el escáner actualizado.

**Documentos para la próxima sesión:**

1. *Protocolo en knowledge base* (verificar que esté al día, no
   adjuntar): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
2. *Opcionales según foco real:* `CLAUDE.md` si corre en Claude Code;
   `auditoria_codigo_proyecto_md_v1.md` si habrá auditoría de cifras.
3. *Específicos de la sesión (SÍ adjuntar):*
   - `traspaso_cierre_v27.md` (este documento)
   - `estructura_actual.md` (re-correr el escáner si pasaron más de unas
     horas)
   - `backlog_acumulativo.md` (pendiente #1, crítico para no perder
     numeración correlativa)
   - `gobernanza_datos.md` (si la próxima sesión toca datos)

**Nota final obligatoria:** si algún archivo listado cambió entre
sesiones, adjuntar la versión más actualizada al abrir.
