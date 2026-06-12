# traspaso_cierre_v01.md — slep_categoria_desempeno

## 1. Identificación

- **Proyecto:** `slep_categoria_desempeno`
- **Versión:** v01
- **Fecha:** 2026-06-11
- **Sesión 1** — foco: NEW PROJECT. Scaffold (Paso 0) + diseño completo del
  modelo de datos y de visualización. No se escribió pipeline ni motor todavía.
- **Entorno:** interfaz web (sesión de diseño/arquitectura). La implementación
  (sesión 2) corre en Claude Code.
- **Archivos principales creados:** estructura canónica completa, `00_build.R`
  (stub), `00_escanear_proyecto.R`, `10_utils/10_utils.R`, `.gitignore`,
  `README.md`, `CLAUDE.md`, dos decisiones en `decisiones/`, primer snapshot
  de estructura.

## 2. Resumen ejecutivo

Se inició el proyecto `slep_categoria_desempeno`, motor de comparación
interactivo (React 18 + D3 v7, HTML autocontenido) de la Categoría de Desempeño
de establecimientos (Alto / Medio / Medio-Bajo / Insuficiente, Agencia de
Calidad), hermano de `slep_simce_adecuado`. Se ejecutó el Paso 0 completo
(estructura canónica, stubs, git local, repo remoto privado `tomgc/
slep_categoria_desempeno`, primer escaneo), todo versionado y pusheado a `main`.
Se inspeccionaron los 7 archivos de datos reales (`cdb`/`cdm` 2016–2019) y el
directorio oficial, resolviendo el esquema (dos órdenes de columnas, mismos
headers) y la llave del dato (`RBD × nivel × año`). Se cerró el diseño completo
del modelo de visualización: dos grillas apiladas (básica/media), cuatro
columnas por categoría con descriptivos n/%, y filas de establecimiento con
trayectoria histórica de chips por año. Quedó pendiente toda la implementación:
pipeline R (pasos 30–33) y motor HTML. El diseño está validado con el usuario
mediante boceto.

## 3. Estado al cierre

**Qué funciona:**
- Repo `tomgc/slep_categoria_desempeno` vivo, privado, `main` rastreando origin.
  Último push verificado por el usuario (clone desde bundle + push OK).
- Estructura canónica completa según POLÍTICA §1.1 (Rama A, raíz unificada).
- Stubs cargables: `00_build.R` (sin pasos aún), `10_utils/10_utils.R`
  (`instalar_si_falta`, `log_msg`), `00_escanear_proyecto.R` (idéntico al madre,
  identidad adaptada).
- Snapshot de estructura inicial commiteado.

**Qué no funciona / no existe aún:**
- No hay pipeline: `30_construir_auxiliares.R`, `31_leer_normalizar.R`,
  `32_agregar_territorial.R`, `33_generar_html.R` no existen.
- No hay motor HTML (`33_motor_template.html` ni `motor_categoria.html`).
- No hay parquets intermedios.

**Delta vs. v00:** proyecto creado desde cero.

## 4. Registro detallado de cambios

1. **Scaffold de estructura canónica** (POLÍTICA §1.1, §8.2 Rama A). Carpetas
   por decenas con `.gitkeep` en vacías. Verificado: árbol calza con la política.
2. **`00_build.R` stub** adaptado: orquestador con pasos comentados (se
   descomentan al construirse), producto final nombrado `motor_categoria.html`.
3. **`10_utils/10_utils.R` propio**: NO se copió el del madre (era específico de
   `agregar_ponderado()`/GSE, inaplicable aquí). Solo bootstrapping
   (`instalar_si_falta`, `log_msg`). Causa (C.11): la lógica de conteo categórico
   no es ponderada; migrar la del madre habría arrastrado código muerto.
4. **`00_escanear_proyecto.R`**: copiado del madre, adaptada solo la identidad
   (header, referencia a sección 7 de la política, fecha). Motor de poda
   (retención 2), árbol y escritura atómica idénticos.
5. **`.gitignore` Rama A**: estándar sin bloque de datos (datos públicos
   versionados); ignora `motor_categoria.html` y parquets intermedios
   (regenerables).
6. **`.Rproj`, `README.md`, `CLAUDE.md`** creados. `CLAUDE.md` documenta las
   tres rupturas con el madre y el modelo de visualización.
7. **Protocolo copiado** a `50_documentacion/activa/` (POLÍTICA + SETTINGS).
8. **Dos decisiones** en `decisiones/`: `20260611_decision_sin_gse.md`,
   `20260611_decision_nombres_establecimientos.md`.
9. **Git local + remoto**: dos commits (`scaffold inicial` → `primer escaneo`),
   remoto configurado, push a `main` verificado por el usuario.
10. **Inspección de datos**: 7 xlsx + directorio. Resolución del esquema y de la
    llave del dato (ver sección 6 y 7).
11. **Diseño de visualización cerrado**: dos grillas apiladas (Opción B),
    validado con boceto (ver sección 8).

## 5. Backlog acumulativo

### Objetivo del proyecto (permanente)

`slep_categoria_desempeno` es un motor de comparación interactivo (React 18 +
D3 v7, HTML autocontenido publicado en GitHub Pages) de la **Categoría de
Desempeño** de los establecimientos educacionales chilenos (clasificación
integral de la Agencia de Calidad: Alto / Medio / Medio-Bajo / Insuficiente).
Compara territorios (comuna, SLEP, región, Chile, grupos personalizados) y
establecimientos del SLEP Costa Central a lo largo del tiempo, mostrando la
distribución de establecimientos por categoría y la trayectoria histórica de
cada uno. Producido con un pipeline R (Positron) desde archivos xlsx de la
Agencia, para el Área de Monitoreo y Seguimiento del SLEP Costa Central. Hermano
de `slep_simce_adecuado`, del que reutiliza arquitectura y patrones. Desde
junio 2026.

### Nota metodológica (permanente)

Un "cambio" es una solicitud distinguible del usuario (no las acciones técnicas
que la implementan). No cuentan los errores del asistente corregidos de
inmediato; sí cuentan los bugfixes reportados por el usuario. La clasificación
es por intención primaria. Fuentes del conteo: registro detallado de cada
traspaso.

### Clasificación temática (inicial, a refinar)

| Categoría | N° | % | Descripción |
|---|---|---|---|
| Inicialización / scaffold | 9 | 82% | Estructura, stubs, git, repo, protocolo, decisiones |
| Diseño de datos | 1 | 9% | Inspección de fuentes, esquema, llave del dato |
| Diseño de visualización | 1 | 9% | Modelo de grillas, encoding categórico, trayectoria |

(Taxonomía orgánica: se expandirá al entrar pipeline y motor. Categorías
previstas a futuro: pipeline/normalización, agregación, motor HTML/UI, despliegue,
gobernanza, deuda técnica, bugfix.)

### Resumen estadístico por sesión

| Sesión | Traspasos | N° cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 11 | Opus 4.8 | Scaffold + diseño de datos y UI |
| Total | | 11 | | |

### Detalle cronológico

**Sesión 1 (scaffold + diseño):**
1–11: ver sección 4 (numeración correlativa global; estas 11 entradas son la
base del conteo histórico).

### Delta del backlog

v01: backlog inicial creado (11 entradas, objetivo, nota metodológica,
taxonomía inicial de 3 categorías).

## 6. Bugs de la sesión

No aplica en esta sesión: no hubo bugs (no se ejecutó código de pipeline).
Una **autocorrección** de lectura, no contabilizada como bug: en la inspección
inicial se interpretó erróneamente que los archivos 2016–2018 tenían el esquema
"corrido"; al ir a la raíz (leer headers reales) se confirmó que solo cambia el
ORDEN de columnas entre años, con headers correctos en cada archivo. Regla
aprendida abajo (sección 7).

## 7. Aprendizajes y restricciones descubiertas

1. **Leer xlsx por nombre de header, nunca por posición.** Contexto: los 7
   archivos tienen dos órdenes de columnas distintos (esquema A: 2016–2018;
   esquema B: 2019), pero todos con headers correctos. Si se lee por posición,
   2019 se corrompe (matrícula en lugar de nombre, etc.). Principio: C.6 (rigor
   de tipado/lectura), C.8 (validación). Ejemplo: en esquema A la col 2 es
   NOMBRE; en B es MATRÍCULA.
   - Esquema A: `RBD | NOMBRE | REGION | COMUNA | DEPENDENCIA | MATRICULA | CATEGORIA`
   - Esquema B: `RBD | MATRICULA | COMUNA | DEPENDENCIA | REGION | NOMBRE | CATEGORIA`
   - Los headers de matrícula y categoría incluyen el año (`Matrícula Básica
     2018`, `Categoría Desempeño 2019`): normalizar por prefijo.

2. **La llave del dato es `RBD × nivel × año`, no `RBD × año`.** Contexto: hay
   dos archivos por año (`cdb` = básica, `cdm` = media). Un EE puede impartir
   ambos niveles con categorías distintas. Niveles NUNCA se mezclan (invariante
   heredado del madre 4B/2M). Si se colapsa a RBD, se pierde el nivel y se
   mezclan mediciones incomparables.

3. **El directorio es snapshot 2025 (RBD único, sin historia).** Contexto: el
   cruce para recuperar `cod_com_rbd`/`cod_depe2`/región usa el estado 2025 del
   EE, no el de su año. Un RBD presente en un CDB viejo y ausente del directorio
   2025 (EE cerrado) no cruza: marcar `RBD sin match en directorio`, NO descartar
   en silencio (C.8).

4. **Categoría final = 5 valores** tras normalización: ALTO, MEDIO, MEDIO-BAJO,
   INSUFICIENTE, s/i. Decisiones de colapso en sección 8.

5. **Reutilizar el madre como biblioteca de patrones, no copiar ciego.** El
   `10_utils.R` del madre era inaplicable (ponderado/GSE). Verificar pertinencia
   antes de copiar cada artefacto.

## 8. Decisiones de diseño

1. **Sin segmentación GSE** (documentada en `decisiones/20260611_decision_sin_gse.md`).
   La categoría ya integra contexto socioeconómico. Contraparte del "GSE
   inviolable" del madre.

2. **Nombres de EE permitidos en agregados públicos por RBD** (documentada en
   `decisiones/20260611_decision_nombres_establecimientos.md`). Heredada de la
   decisión B2 del madre.

3. **Dependencia homologada a `cod_depe2` (5 categorías) cruzando por RBD contra
   el directorio.** Alternativa descartada: usar la columna `Dependencia` texto
   del CDB (3 cat., "Público" agrupado). Razón: granularidad completa y
   consistencia con el madre. La columna texto queda como validación cruzada.

4. **`MEDIO-BAJO (NUEVO)` colapsa en `MEDIO-BAJO`.** Razón: "nuevo" indica
   antigüedad del EE, no un nivel de desempeño distinto. PENDIENTE: documentar en
   `decisiones/`.

5. **Las dos `SIN CATEGORIA` (baja matrícula, falta de información) se unifican
   en `s/i`.** Se conserva el motivo en columna auxiliar `motivo_sin_categoria`
   (para tooltip futuro), sin ensuciar la categoría. PENDIENTE: documentar en
   `decisiones/`.

6. **Visualización: dos grillas apiladas (Opción B).** Básica arriba, media
   abajo; cada una con 4 columnas (orden semántico Insuficiente → Alto),
   descriptivos n/% por columna, y filas de EE con trayectoria de chips por año.
   Alternativas descartadas: (A) doble sub-fila por EE — obliga a un EE a ocupar
   dos columnas contradictorias si básica≠media; (C) chip dual en una grilla —
   exige un "nivel primario" artificial. Razón de B: única que muestra ambos
   niveles sin violar "niveles no se mezclan" ni forzar posiciones imposibles.
   PENDIENTE: documentar en `decisiones/`.

7. **Columna de cada EE = su categoría del último año disponible.** EE con s/i en
   el último año → sección "Sin categoría vigente" aparte bajo cada grilla.

8. **Trayectoria con continuidad temporal explícita.** Chip gris s/i para años
   sin medición; el hueco se ve, no se omite (paralelo al gap de pandemia del
   madre).

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| RETENER_SNAPSHOTS | 2 | `00_escanear_proyecto.R` | Poda de snapshots |
| EXCLUIR_ARCHIVO | TRUE | `00_escanear_proyecto.R` | |
| Categorías nominales | ALTO/MEDIO/MEDIO-BAJO/INSUFICIENTE | (pipeline futuro) | + s/i |
| Orden semántico UI | Insuficiente → Medio-bajo → Medio → Alto | (motor futuro) | |
| Paleta | rojo/ámbar/azul/teal + gris s/i | (motor futuro) | fija |
| Niveles | basica, media | (pipeline futuro) | nunca mezclados |
| Cobertura | básica 2016–2019, media 2017–2019 | datos | falta 2020+ |

## 10. Arquitectura de archivos

Estructura canónica Rama A. Ver snapshot al cierre en
`50_documentacion/estructura/estructura_actual.md`. Sin desviaciones respecto a
la política (proyecto nuevo).

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

- **P1 — Inspección final de catálogos del madre** (bloqueante de P2).
  Tipo: pipeline. Traer del madre `30_construir_auxiliares.R`,
  `31_leer_normalizar.R`, `33_generar_html.R`, `33_motor_template.html` para
  reutilizar como molde. Complejidad: baja. Criterio de éxito: moldes a la vista,
  catálogos territoriales identificados.

- **P2 — Pipeline R completo.** Tipo: funcionalidad. `30_construir_auxiliares.R`
  (catálogos desde directorio), `31_leer_normalizar.R` (lectura por header,
  normalización de categoría a 5 valores, RBD character, cruce con directorio,
  marca sin-match → `categoria_rbd.parquet`), `32_agregar_territorial.R`
  (conteo por territorio × nivel × año × categoría → `categoria_territorial.
  parquet`). Complejidad: alta. Principios: C.6, C.8, C.10. Precaución: leer por
  header (aprendizaje 1); llave RBD×nivel×año (aprendizaje 2); marcar sin-match
  (aprendizaje 3). Criterio de éxito: parquets generados, validación de conteos
  (suma de EE por territorio = filas del CDB cruzadas), niveles separados.

- **P3 — Motor HTML.** Tipo: funcionalidad. `33_generar_html.R` (JSON gzip+pako
  embebido) + template nuevo con dos grillas apiladas. Componente de grilla es
  nuevo (no existe en el madre). Complejidad: alta. Precaución: scroll/tope en
  columnas con muchos EE; sección "sin categoría vigente" bajo cada grilla.
  Criterio de éxito: motor renderiza ambas grillas con datos reales, trayectoria
  correcta, selección de entidad funcionando.

- **P4 — Publicación en GitHub Pages.** Tipo: despliegue. Copia a `/docs`,
  deploy desde `main`. Complejidad: baja.

- **P5 — Documentar decisiones 4, 5, 6** (MEDIO-BAJO NUEVO, unificación s/i,
  grillas apiladas) como archivos en `decisiones/`. Tipo: documentación.
  Complejidad: baja.

- **P6 — Gobernanza y normativos.** Tipo: documentación/gobernanza. Leer los
  normativos que el usuario tiene en `20_insumos/auxiliares/`
  (`condiciones_uso_bd.doc`, `rex_589/1440/1459.pdf`) — NO adjuntos en sesión 1 —
  para afinar `gobernanza_datos.md`. Complejidad: media.

### Auditoría de cierre (POLÍTICA 5.6, preguntas "Cierre")

- ¿Pipeline corre de cero sin intervención? → No aplica (sin pipeline aún).
- ¿Checks de validación por transformación crítica? → Pendiente (P2).
- ¿Outputs reproducibles/idempotentes? → Pendiente (P2/P3).
- ¿Decisiones metodológicas como constantes nombradas? → Sí en diseño; a
  materializar en código (P2/P3).
- ¿Nombres sin tildes/ñ/espacios? → Sí, verificado en scaffold.

### Ruta sugerida para sesión 2

Orden: P1 (traer moldes) → P2 (pipeline) → P5 (documentar decisiones, barato y
en contexto) → P3 (motor) → P4 (deploy). P6 cuando el usuario adjunte los
normativos. Correr en Claude Code. Arrancar con escáner + lectura de este
traspaso (Fase A del protocolo).

## 12. Instrucciones específicas para la próxima sesión

- ✅ ANTES de leer cualquier xlsx, verificar el orden de columnas por header
  (dos esquemas: A 2016–2018, B 2019). Leer por nombre, jamás por posición.
- 🔒 Niveles básica/media NUNCA se mezclan en una cifra agregada. Llave del
  dato: `RBD × nivel × año`.
- 🔒 Sin GSE en ninguna vista. Sin ponderación por matrícula: agregación = CONTEO
  de EE.
- ⚠️ NO descartar RBD sin match en directorio: marcarlo explícitamente.
- ⚠️ NO copiar artefactos del madre sin verificar pertinencia (el `10_utils.R`
  del madre no aplica aquí).
- ✅ ANTES de generar el motor, recordar: sección "sin categoría vigente" bajo
  cada grilla para EE con s/i en el último año.

## 13. Fragmentos de código de referencia

Patrón de lectura por header (la forma correcta para este proyecto):

```r
# Normalizar headers variables por prefijo, leer por nombre (no por posicion).
# Resuelve los dos esquemas de orden de columnas (A: 2016-2018, B: 2019).
leer_cdb <- function(ruta, nivel, anio) {
  crudo <- readxl::read_excel(ruta) |> janitor::clean_names()
  # clean_names produce p.ej. categoria_desempeno_2019, matricula_basica_2018
  col_cat <- names(crudo)[stringr::str_detect(names(crudo), "^categoria_desempeno")]
  crudo |>
    dplyr::transmute(
      rbd      = as.character(rbd),
      nivel    = nivel,
      anio     = anio,
      categoria_raw = .data[[col_cat]]
    )
}

# Normalizacion de categoria a 5 valores (decisiones 4 y 5 del traspaso).
normalizar_categoria <- function(x) {
  dplyr::case_when(
    x == "MEDIO-BAJO (NUEVO)"                    ~ "MEDIO-BAJO",
    stringr::str_starts(x, "SIN CATEGORIA")      ~ "s/i",
    TRUE                                          ~ x
  )
}
```

## 14. Reapertura

- **Nombre del chat:** `slep_categoria_desempeno, sesión 2 (Claude Code)`
- **Mensaje de apertura pre-armado:**

  > Tipo de sesión: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
  > SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del Project;
  > léelo desde ahí. Retomamos `slep_categoria_desempeno` en sesión 2, foco:
  > construir el pipeline R (pasos 30–32) y luego el motor HTML. Adjunto el
  > traspaso v01, el escáner actual, y los moldes del proyecto madre.

- **Documentos para la próxima sesión:**
  1. *Protocolo en knowledge base* (NO adjuntar, solo verificar que esté al día):
     `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales según foco:* `CLAUDE.md` (correrá en Claude Code).
  3. *Específicos de la sesión (SÍ adjuntar):*
     - `traspaso_cierre_v01.md` (este).
     - `estructura_actual.md` (escáner).
     - Datos: `cdb_2016/2017/2018/2019.xlsx`, `cdm_2017/2018/2019.xlsx`,
       `directorio_oficial_ee.csv` (voluminoso pero crítico).
     - Moldes del madre: `30_construir_auxiliares.R`, `31_leer_normalizar.R`,
       `33_generar_html.R`, `33_motor_template.html`.
     - Si se aborda P6: `condiciones_uso_bd.doc`, `rex_589/1440/1459.pdf`.

- **Nota final:** si algún archivo cambió entre sesiones, adjuntar la versión más
  actualizada y avisarlo en el mensaje de apertura.
