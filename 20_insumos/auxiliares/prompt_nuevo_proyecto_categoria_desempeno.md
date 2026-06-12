# Prompt de apertura — `slep_categoria_desempeno` (NEW PROJECT)

> Pega este mensaje como primer turno de un chat nuevo, dentro del Project.
> Adjunta los archivos listados al final. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; léelo desde ahí.

---

Tipo de sesión: **NEW PROJECT**.

## Qué quiero construir

Un motor de comparación interactivo, hermano de `slep_simce_adecuado`, sobre la
**Categoría de Desempeño** de los establecimientos (Agencia de Calidad). Mismo
producto: HTML autocontenido (React 18 + D3 v7), comparación de territorios y
establecimientos en el tiempo, publicado en GitHub Pages. Nombre:
`slep_categoria_desempeno`.

## Qué es la Categoría de Desempeño (y en qué difiere del proyecto madre)

Clasifica a cada **establecimiento** (no al estudiante) en una de cuatro
categorías: **Alto, Medio, Medio-Bajo, Insuficiente**. Evaluación integral
(cognitivo + IDPS). En régimen desde 2016 (básica) y 2017 (media).

Rompe tres invariantes del proyecto madre; el diseño parte de aquí:

1. **Unidad = establecimiento, dato categórico.** Una etiqueta por RBD por año,
   no un porcentaje continuo.
2. **Sin ponderación por `nalu`.** No se promedia: se **cuenta** EE por
   categoría. Al agregar a comuna/SLEP/región/Chile, el motor muestra la
   **distribución de establecimientos por categoría**, con su total.
3. **Sin segmentación GSE.** La categoría ya integra el contexto socioeconómico.
   **Documentar como decisión metodológica explícita** (la contraparte del "GSE
   inviolable" del proyecto madre).

Se conserva: comparación por entidad (comuna/SLEP/región/establecimiento/Chile/
grupos), serie temporal con años faltantes explícitos, HTML autocontenido con
JSON comprimido (gzip+pako), publicación en Pages, IDs `character`,
`here::here()`, convenciones R.

## Esquema real de la fuente (ya inspeccionado)

Archivo de muestra `CDB2019.xlsx` (una fila por establecimiento-año):

| Columna | Notas |
|---|---|
| RBD | ID establecimiento |
| Matrícula Básica 201X | matrícula |
| Comuna | nombre |
| Dependencia | "Público" / "Particular subvencionado" / "Particular pagado" (texto, no código) |
| Región | nombre |
| Nombre Establecimiento | identifica el EE — ver gobernanza |
| **Categoría Desempeño** | "ALTO" / "MEDIO" / "MEDIO-BAJO" / "INSUFICIENTE" (la variable clave) |

Implicancias para el pipeline (a confirmar al abrir):
- La dependencia viene como **texto**, no como `cod_depe2` numérico. Homologar
  al esquema del proyecto madre para reutilizar catálogos.
- Falta `cod_com_rbd`: cruzar por RBD contra el directorio oficial del proyecto
  madre (más robusto que por nombre de comuna).
- Un archivo por año (CDB2019, CDB2020, ...). Armar manifiesto multi-año como en
  `31_leer_normalizar.R`.

## Decisiones de diseño a resolver en la apertura

1. **Encoding de una variable categórica en el tiempo.** EE individual: secuencia
   de etiquetas (Alto→Medio→...). Territorio: distribución apilada por año.
   Proponer encoding (barras apiladas 100% por categoría, conteo absoluto, o
   ambos según vista). No son sparklines de %.
2. **Paleta de las 4 categorías**, fija, orden semántico Insuficiente→Alto.
3. **Años disponibles y faltantes**, marcados explícitamente.

## Sensibilidad de datos (bifurcación §8.1 — Rama A, público)

La Categoría de Desempeño por RBD es información pública (portal y "Localiza tu
colegio"). Raíz unificada, datos versionados, sin data root externo, `.gitignore`
estándar sin bloque de datos.

> **Gobernanza a verificar al abrir:** el archivo trae `Nombre Establecimiento`.
> El proyecto madre ya resolvió (sesión 13, decisión B2) que la prohibición de
> identificar establecimientos de las Condiciones de Uso aplica a las bases por
> estudiante, no a los agregados públicos por RBD. La Categoría de Desempeño por
> establecimiento es pública por diseño. Confirmar que se mantiene el criterio y
> documentarlo en `decisiones/`.

## Paso 0 obligatorio: scaffold + versionado temprano (antes de cualquier pipeline)

La PRIMERA acción concreta, antes de leer un solo xlsx o escribir lógica de
datos, es dejar el proyecto inicializado y versionado. Esto NO es opcional ni se
mezcla con el pipeline:

1. **Crear el esqueleto de carpetas vacías** según la estructura canónica
   (POLÍTICA §1.1), listas para poblarse: `10_utils/`, `20_insumos/`,
   `30_procesamiento/`, `40_salidas/intermedios/`, `50_documentacion/{activa,
   activa/decisiones,traspasos,andamios,estructura}/`, `tests/`. Cada carpeta que
   aún no tenga contenido lleva un `.gitkeep` para que git la versione. Los
   nombres de carpetas y archivos siguen la nomenclatura de la política
   (decenas, snake_case, sin tildes/ñ/espacios).
2. **Stubs mínimos en su sitio** (POLÍTICA §8.4): `00_build.R` (orquestador
   stub funcional), `00_escanear_proyecto.R`, `10_utils/10_utils.R` con
   bootstrapping, `10_utils/10_configuracion.R` con rutas vía `here::here()`
   (Rama A, sin data root externo), `.gitignore` estándar (sin bloque de datos),
   `README.md` mínimo, `slep_categoria_desempeno.Rproj`, y copia de `POLITICA_PROYECTO.md` +
   `SETTINGS_Y_PROMPTS_OPERACIONALES.md` a `50_documentacion/activa/` (o
   verificación de que están en la knowledge base) y `CLAUDE.md` en la raíz.
3. **Git local desde el primer commit:** `git init`, `.gitignore` correcto,
   primer commit con el esqueleto ("scaffold inicial: estructura canónica
   vacía"). El versionado arranca con el esqueleto, no después de tener código.
4. **Repo remoto GitHub de inmediato** (no diferido): crear el repo **privado**
   `tomgc/slep_categoria_desempeno`, conectar el remoto y hacer push del scaffold.
   Branch principal `main`. Esto deja el proyecto respaldado y trazable desde el
   minuto cero, replicando lo que ya tiene `slep_simce_adecuado`.
5. **Primer escaneo** (`00_escanear_proyecto.R`) y commit del snapshot inicial.

Solo con el Paso 0 cerrado (estructura creada, git local + remoto, primer
escaneo) se pasa a inspeccionar datos y construir el pipeline. La idea es ir
**poblando** carpetas que ya existen y versionando cada avance, no crear
estructura sobre la marcha.

Tareas manuales que son MÍAS (la inicialización las indica en una línea, sin
script): crear el repo en GitHub si requiere acción en la web, y cualquier
descarga o arrastre de archivos.

## Ruta de trabajo propuesta (confírmala o ajústala)

1. **Paso 0** completo (scaffold + git local + repo GitHub privado + primer
   escaneo), según la sección anterior. Reutilizar el esqueleto de
   `slep_simce_adecuado` como molde de carpetas y stubs.
2. Inspección del esquema real (pipeline arriba).
3. Pipeline: lectura multi-año → normalización (homologar dependencia, recuperar
   `cod_com_rbd` por cruce con directorio) → reutilizar catálogos de entidades →
   tabla `categoria_rbd` → agregación por **conteo** a `categoria_territorial`.
4. Motor HTML: adaptar el template a distribución categórica.
5. Publicación en Pages.

## Antes de empezar

Ejecuta la pregunta de bifurcación (ya resuelta: Rama A) y, en tu plan, el paso 1 debe ser el **Paso 0** (scaffold + git local + repo GitHub privado + primer escaneo). Entrégame el plan
NEW PROJECT del protocolo. No escribas código hasta que apruebe la ruta.

## Reutilización del proyecto madre (biblioteca de patrones, no reescribir)

Ya resuelto allí: catálogos de entidades, escáner, orquestador, gzip+pako,
export SVG/PNG, tooltip clampeado, buscador con diacríticos, Pages.

---

**Adjuntar a este mensaje:**
- `CDB2019.xlsx` (y los demás años CDB disponibles).
- Del proyecto madre: `30_construir_auxiliares.R`, `31_leer_normalizar.R`,
  `33_generar_html.R`, `33_motor_template.html`, `00_build.R`, y el directorio
  oficial de EE para el cruce de comuna.
