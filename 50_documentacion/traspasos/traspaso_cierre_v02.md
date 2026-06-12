# traspaso_cierre_v02.md

## 1. Identificacion

- **Proyecto:** slep_categoria_desempeno
- **Version traspaso:** v02
- **Fecha:** 2026-06-11
- **Sesion:** 2 — foco: construir el pipeline R completo (pasos 30-32) y el
  orquestador canonico. El motor HTML (paso 33) queda para sesion 3.
- **Entorno:** Claude Code (zsh, macOS aarch64), R 4.5.2, Positron.
- **Archivos principales creados/modificados:**
  - `30_procesamiento/30_construir_auxiliares.R` (nuevo)
  - `30_procesamiento/31_leer_normalizar.R` (nuevo)
  - `30_procesamiento/32_agregar_territorial.R` (nuevo)
  - `00_run_all.R` (nuevo, reemplaza el stub `00_build.R` archivado)
  - 5 parquets en `40_salidas/intermedios/` (nuevos)

---

## 2. Resumen ejecutivo

Sesion de implementacion pura: se partio del diseno cerrado en v01 (cero
codigo de pipeline) y se llego a un pipeline R completo, validado de cero y
reproducible con un solo comando (`run_all()`). Se construyeron los tres
pasos de procesamiento (auxiliares territoriales, lectura/normalizacion de
los 7 xlsx de categoria, agregacion territorial por conteo) y el orquestador
canonico que reemplaza al stub `00_build.R`. Todas las validaciones internas
pasan en verde, incluido el cruce de control de nacional contra conteo directo
(dif = 0). Se tomo la decision metodologica B (s/i separado del conteo de
categorias reales, porcentajes sobre EE categorizados). Quedo pendiente para
sesion 3 el motor HTML (paso 33), de alto riesgo, y las tres decisiones de
diseno de la sesion (documentacion barata). El pipeline corre en 0.8 s.

---

## 3. Estado al cierre

### Funciona (ultima ejecucion exitosa: 2026-06-11 23:09)
- `run_all()` ejecuta los pasos 1-3 de cero, en secuencia limpia, sin
  intervencion manual. Paso 4 (motor) reportado como ausente sin romper.
- Los 5 parquets se generan y validan:
  - `comunas_chile.parquet` (345 filas)
  - `sleps_chile.parquet` (2337 filas, 36 SLEPs, incluye 10 prospectivos 2026)
  - `establecimientos_chile.parquet` (10945 filas, RBD llave unica)
  - `categoria_rbd.parquet` (41244 filas, llave rbd x nivel x anio unica)
  - `categoria_territorial.parquet` (10780 filas, formato largo 4 categorias)
  - `categoria_sin_vigente.parquet` (1985 filas, s/i con motivo)

### No funciona / no existe aun
- `33_generar_html.R` (motor): no construido. Es el unico pendiente
  estructural del pipeline.

### Delta respecto a v01
- v01 cerro con scaffold + diseno, cero pipeline. v02 cierra con pipeline R
  completo (3/4 pasos), orquestador canonico y datos auditados. El unico paso
  faltante es el motor.

---

## 4. Registro detallado de cambios

### Cambio 12 — 30_construir_auxiliares.R (nuevo)
- **Categoria:** pipeline / auxiliares.
- **Que:** adaptacion del molde madre. Construye comunas_chile,
  sleps_chile y establecimientos_chile desde el directorio oficial y el
  listado SLEP.
- **Por que:** P2 depende de los catalogos para cruzar RBD -> territorio.
- **Como se verifico:** Costa Central reporta sus 4 comunas exactas; RBD
  llave unica en establecimientos (sin duplicados); 10 SLEP prospectivos
  2026 incluidos.
- **Decisiones:** eliminados los bloques SIMCE/IVE del madre (no aplican);
  agregada columna cod_reg_rbd a establecimientos (P3 agrega por region);
  agregado COD_DEPE a la validacion de columnas (el bloque SLEP lo usa).

### Cambio 13 — 31_leer_normalizar.R (nuevo)
- **Categoria:** pipeline / dato nuclear.
- **Que:** lee los 7 xlsx por header (clean_names resuelve esquemas A/B),
  normaliza categoria a 5 valores, cruza con directorio, emite
  categoria_rbd.parquet (llave rbd x nivel x anio).
- **Por que:** es el dato base de todo el proyecto.
- **Como se verifico:** 5 categorias limpias; llave unica; 0 NAs criticos;
  motivo_sin_categoria coherente; 41244 filas = suma de los 7 archivos.
- **Decisiones:** NO se arrastraron las anomalias del madre (A1/A3/A4 de
  comunas): la inspeccion confirmo que el territorio sale del directorio por
  RBD, no de las columnas del cdb. Se ignoran comuna/region/dependencia del
  cdb (redundantes y de calidad inferior).

### Cambio 14 — 32_agregar_territorial.R (nuevo)
- **Categoria:** pipeline / agregacion.
- **Que:** conteo de EE por entidad (comuna/slep/region/nacional) x nivel x
  anio x categoria. Formato largo. Emite categoria_territorial.parquet y
  categoria_sin_vigente.parquet.
- **Por que:** es el parquet que consume el motor.
- **Como se verifico:** 4 validaciones en verde (4 categorias por celda; pct
  suma 1; n_ee <= categorizados; nacional cuadra con conteo directo dif = 0).
- **Decisiones:** opcion B (ver seccion 8). Funcion contar_territorial()
  generica reutilizada en los 4 niveles.

### Cambio 15 — 00_run_all.R (nuevo) + archivo de 00_build.R
- **Categoria:** orquestacion.
- **Que:** orquestador canonico (protocolo 4.1): PASOS con id/etiqueta/ruta,
  run_all(from/to/only/skip), validacion de rutas, raiz via rprojroot,
  duracion por paso, resumen. El stub 00_build.R se archivo a _archivo/.
- **Por que:** reproducibilidad de un comando; requisito de auditoria 5.6 p2.
- **Como se verifico:** run_all() corre 1-3 de cero en 0.8 s; paso 4 ausente
  reportado sin romper.

---

## 5. Backlog acumulativo

### Objetivo del proyecto
slep_categoria_desempeno es un motor interactivo (R + HTML autocontenido) que
compara la distribucion de establecimientos por Categoria de Desempeno (Alto /
Medio / Medio-Bajo / Insuficiente) de la Agencia de Calidad, entre comunas,
SLEPs, regiones y el nivel nacional, separando basica y media. Pipeline en R
(xlsx -> parquet -> JSON embebido -> HTML), publicado en GitHub Pages. Para el
equipo de Monitoreo del SLEP Costa Central, desde 2026. Datos publicos.

### Nota metodologica del conteo
Un "cambio" es una solicitud distinguible del titular, no las acciones tecnicas
que la implementan. No cuentan los errores del asistente corregidos de
inmediato; si cuentan los bugfixes reportados por el titular. Clasificacion por
intencion primaria. Fuentes: registro de la sesion.

### Clasificacion tematica (refinada en sesion 2)
| Categoria | N | % | Descripcion |
|---|---|---|---|
| Scaffold e inicializacion | 9 | 60 | Estructura, scaffold, decisiones de diseno v01 |
| Pipeline R | 3 | 20 | Pasos 30-32 de procesamiento |
| Orquestacion | 1 | 7 | 00_run_all.R |
| Datos y normalizacion | 1 | 7 | Esquema xlsx, normalizacion categoria |
| Diseno UI / motor | 1 | 7 | Diseno de grillas (v01); motor pendiente |

### Resumen estadistico por sesion
| Sesion | Traspasos | N cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 11 | (v01) | Scaffold y diseno |
| 2 | v02 | 4 | Opus 4.8 | Pipeline R 30-32 + orquestador |
| **Total** | | **15** | | |

### Detalle cronologico
- **Sesion 1 (cambios 1-11):** ver traspaso v01 (scaffold, repo, diseno de
  datos y UI, decisiones 1-3).
- **Sesion 2 (cambios 12-15):** 12 auxiliares; 13 leer/normalizar; 14
  agregacion territorial; 15 orquestador + archivo de stub.

### Delta del backlog
4 entradas nuevas (12-15). Taxonomia refinada: se desdoblaron "Pipeline R",
"Orquestacion" y "Datos y normalizacion" desde la categoria generica de v01,
al entrar implementacion real.

---

## 6. Bugs de la sesion

No aplica en esta sesion: no se reportaron bugs. Todo el codigo paso sus
validaciones en la primera ejecucion. (Nota: el 6.7% de RBDs sin match
territorial se investigo y se confirmo como comportamiento esperado —cierres
historicos de EE—, no un bug; ver seccion 7.)

---

## 7. Aprendizajes y restricciones descubiertas

### A1 — El territorio canonico es el directorio, no el cdb
- **Regla:** el cruce RBD -> comuna/region/dependencia SIEMPRE sale de
  establecimientos_chile.parquet (snapshot 2025), nunca de las columnas
  comuna/region del cdb/cdm.
- **Principio:** C.6 (rigor de fuente).
- **Contexto:** las columnas territoriales del cdb son texto de calidad
  inferior; usarlas reintroduciria las anomalias que el madre tuvo que
  parchear. Al ir al directorio por RBD, esas anomalias no existen.
- **Ejemplo:** se descartaron los parches A1/A3/A4 del molde madre sin perdida.

### A2 — El sin-match territorial es historico, no un bug
- **Regla:** un % de RBDs sin match en el directorio 2025 es esperable y
  decreciente hacia anios recientes (8.9% en 2016 -> 2.4% en 2019); son EE
  cerrados entre el anio del dato y el snapshot. No descartar; marcar.
- **Principio:** C.8 (validacion) + restriccion del traspaso v01.
- **Contexto:** si un RBD sin match se descartara, se subestimaria el nacional.
  Por eso nacional incluye todos los EE categorizados; comuna/region solo los
  que tienen match (no se les puede asignar territorio).
- **Ejemplo:** Costa Central tiene 0 RBDs sin match (cobertura completa); el
  universo que el SLEP mira esta intacto.

### A3 — clean_names() resuelve los dos esquemas de columnas
- **Regla:** leer por header con janitor::clean_names() + seleccion por
  prefijo (^categoria_desempeno) absorbe el cambio de orden de columnas entre
  esquema A (2016-2018) y B (2019) sin codigo condicional por archivo.
- **Principio:** B.2 (simplicidad) sobre el manejo posicional.
- **Contexto:** evita un mapa de posiciones por archivo, fuente clasica de
  bugs silenciosos.

---

## 8. Decisiones de diseno

### D-sesion2 — Opcion B: s/i separado del conteo de categorias
- **Decision:** el conteo territorial y los porcentajes consideran SOLO las 4
  categorias reales (ALTO/MEDIO/MEDIO-BAJO/INSUFICIENTE). Los EE con categoria
  s/i van a un parquet separado (categoria_sin_vigente) con desglose por
  motivo (baja_matricula / falta_informacion).
- **Alternativas:** opcion A (s/i como 5a categoria en el conteo, denominador
  incluye s/i).
- **Justificacion:** un territorio con muchos s/i (ej. 40%) empujaria
  artificialmente a la baja todas las proporciones reales bajo la opcion A. La
  opcion B calcula pct sobre EE efectivamente categorizados, y calza con la
  seccion "sin categoria vigente" separada que el motor ya contempla (diseno
  v01). Decidida por el titular.
- **Implicancia:** pendiente documentarla como
  20260611_decision_agregacion_sin_vigente.md (ver pendientes).

### D-formato-largo — Parquet territorial en formato largo
- **Decision:** categoria_territorial.parquet en formato largo (una fila por
  entidad x nivel x anio x categoria).
- **Alternativas:** formato ancho (una columna por categoria).
- **Justificacion:** el motor React+D3 del madre consume series largas via
  getSeriesForEntity; apilar entidades heterogeneas en ancho obligaria a
  pivotar en JS.
- **Implicancia:** el motor (sesion 3) lee este formato directamente.

---

## 9. Constantes y parametros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| ANIO_DATOS_VIGENTE | 2025 | 30_construir_auxiliares.R | Anio del directorio, no del dato |
| CAT_VALIDAS | ALTO, MEDIO, MEDIO-BAJO, INSUFICIENTE, s/i | 31_leer_normalizar.R | 5 valores normalizados |
| ANIOS_BASICA | 2016:2019 | 31_leer_normalizar.R | Cobertura basica |
| ANIOS_MEDIA | 2017:2019 | 31_leer_normalizar.R | Cobertura media |
| CAT_REALES | ALTO, MEDIO, MEDIO-BAJO, INSUFICIENTE | 32_agregar_territorial.R | 4 categorias del conteo |

---

## 10. Arquitectura de archivos

Referencia al escaner al cierre: `50_documentacion/estructura/estructura_actual.md`
(regenerado al final de la sesion). Cambio estructural respecto a v01:
`00_build.R` archivado a `_archivo/YYYYMMDD/`, reemplazado por `00_run_all.R`
en raiz; tres scripts nuevos en `30_procesamiento/`; cinco parquets nuevos en
`40_salidas/intermedios/`. Verificado contra la politica: orquestador con
nombre canonico, scripts con prefijo de decena y orden de ejecucion correcto.

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**P-motor — Construir el motor HTML (paso 33)**
- **Descripcion:** `33_generar_html.R` (JSON gzip + pako embebido, patron
  madre) + template HTML con componente de grilla apilada (basica/media),
  trayectoria de categorias por anio, y seccion "sin categoria vigente".
- **Tipo:** funcionalidad (alta complejidad).
- **Contexto:** ultimo paso del pipeline. Consume categoria_territorial.parquet
  y categoria_sin_vigente.parquet.
- **Dependencias:** los 5 parquets (ya existen y estan validados).
- **Precauciones:** el componente de grilla apilada NO existe en el molde
  madre (es SIMCE/lineas); hay que construirlo. No copiar artefactos del madre
  sin verificar pertinencia (restriccion v01). El JSON debe respetar el
  formato largo y separar s/i.
- **Criterio de exito sugerido:** ambas grillas renderizan con datos reales;
  trayectoria correcta por anio; seccion sin-categoria presente; HTML
  autocontenido abre sin dependencias externas.

**P-decisiones — Documentar decisiones de sesion 2**
- **Descripcion:** crear en `50_documentacion/activa/decisiones/`:
  20260611_decision_agregacion_sin_vigente.md (opcion B),
  20260611_decision_formato_largo.md (parquet largo). Las decisiones 4-6 que
  el plan menciono se consolidan en estas dos (el colapso MEDIO-BAJO NUEVO y la
  unificacion s/i ya quedaron documentados como constantes; si se quiere archivo
  propio, agregarlo aqui).
- **Tipo:** documentacion (baja complejidad).
- **Criterio de exito:** un archivo por decision, autocontenido, con
  alternativas y justificacion.

**P-deploy — Publicar en GitHub Pages**
- **Descripcion:** desplegar el HTML final en GitHub Pages.
- **Tipo:** deploy (baja complejidad).
- **Dependencias:** P-motor terminado.

**P-gobernanza — Gobernanza de datos (diferido de v01)**
- **Descripcion:** revisar normativos (condiciones_uso_bd.doc, rex). Datos
  publicos, pero las Condiciones de Uso de la Agencia aplican (no identificar
  EE por nombre en outputs). Nota: en este proyecto los nombres de EE SI se
  permiten en agregados (decision v01); revisar consistencia con las
  Condiciones de Uso antes de publicar.
- **Tipo:** deuda / gobernanza (media complejidad).
- **Precaucion:** compuerta de gobernanza; revisar antes del deploy publico.

### Evaluacion de deuda tecnica
Sin deuda nueva. El pipeline cumple la politica (rutas via here, constantes
nombradas, validaciones por paso, llaves character). Unica zona a vigilar: el
motor introducira JS, donde la disciplina de la politica (seccion 5.5, web
estatica) debe sostenerse.

### Auditoria de cierre (politica 5.6, preguntas "Cierre")
- **2. Pipeline corre de cero sin intervencion manual?** Si — run_all() en
  0.8 s desde cero.
- **5. Cada transformacion critica tiene check de validacion?** Si — los 3
  scripts validan post-transformacion.
- **6. Outputs reproducibles e idempotentes?** Si — escritura determinista;
  re-correr produce identico resultado.
- **7. Decisiones metodologicas como constantes nombradas?** Si — CAT_REALES,
  CAT_VALIDAS, ANIOS_*, ANIO_DATOS_VIGENTE.
- **8. Nombres sin tildes/n/espacios?** Si.

Ninguna respuesta "no": sin deuda de cierre que documentar.

### Ruta sugerida para sesion 3
1. **P-motor** (prioridad unica de peso): construir `33_generar_html.R` y el
   template. Es alto riesgo y merece la sesion completa. Empezar inspeccionando
   a fondo `33_generar_html.R` y `33_motor_template.html` del madre para portar
   el patron JSON+pako, y disenar desde cero el componente de grilla apilada.
   Criterio de exito: ver P-motor arriba.
2. **P-decisiones** como cierre barato si queda tiempo.
3. Diferir P-deploy y P-gobernanza hasta tener el motor validado.

---

## 12. Instrucciones especificas para la proxima sesion

- 🔒 Niveles basica y media NUNCA se mezclan en una cifra agregada. Llave del
  dato: rbd x nivel x anio.
- 🔒 Agregacion = CONTEO de EE. Jamas ponderacion por matricula, jamas GSE.
- 🔒 Porcentajes territoriales sobre EE CATEGORIZADOS (denominador excluye s/i).
  Los s/i van en su seccion aparte.
- ✅ ANTES de tocar el motor, inspeccionar a fondo el molde madre
  (33_generar_html.R, 33_motor_template.html) y verificar pertinencia de cada
  artefacto antes de portarlo.
- ✅ ANTES de leer cualquier parquet en el motor, recordar el formato largo y
  la separacion s/i (dos parquets distintos).
- ⚠️ NO copiar el componente visual del madre (es lineas SIMCE): la grilla
  apilada se construye nueva.
- ⚠️ NO publicar sin pasar la compuerta de gobernanza (nombres de EE vs
  Condiciones de Uso de la Agencia).

---

## 13. Fragmentos de codigo de referencia

### Conteo territorial generico (la forma correcta en este proyecto)
```r
# Conteo de EE por celda, denominador = categorizados, pct sin redondear.
# Reutilizable para comuna/slep/region/nacional. NUNCA ponderar por matricula.
conteo <- df_rbd |>
  dplyr::filter(.data$categoria %in% CAT_REALES) |>
  dplyr::count(tipo_entidad, cod_entidad, nom_entidad, nivel, anio, categoria,
               name = "n_ee") |>
  dplyr::mutate(
    n_categorizados = sum(n_ee),
    .by = c(tipo_entidad, cod_entidad, nom_entidad, nivel, anio)
  ) |>
  dplyr::mutate(pct = dplyr::if_else(n_categorizados > 0,
                                     n_ee / n_categorizados, NA_real_))
```

### Cruce de control de nacional (patron de auditoria)
```r
# Toda cifra agregada se valida contra un conteo directo independiente.
control_nac <- df_cat |>
  dplyr::filter(categoria %in% CAT_REALES) |>
  dplyr::count(nivel, anio, name = "n_control")
# dif debe ser 0 en todas las filas.
```

---

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 3 (Opus 4.8)`

### Mensaje de apertura pre-armado
```
Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del Project;
leelo desde ahi. Retomamos slep_categoria_desempeno en sesion 3, foco unico:
construir el motor HTML (paso 33) sobre el pipeline R ya validado. Adjunto el
traspaso v02, el escaner actual, los 5 parquets de salida, y los moldes del
madre 33_generar_html.R y 33_motor_template.html.
```

### Documentos para la proxima sesion

**1. Protocolo en knowledge base (NO se adjuntan; verificar que esten al dia):**
- `POLITICA_PROYECTO.md`
- `SETTINGS_Y_PROMPTS_OPERACIONALES.md`

**2. Opcionales segun el foco (motor HTML):**
- `CLAUDE.md` (la sesion correra en Claude Code).

**3. Especificos de la sesion (SI se adjuntan):**
- `traspaso_cierre_v02.md` (este documento).
- `estructura_actual.md` (escaner al cierre).
- Los 5 parquets de `40_salidas/intermedios/`: `categoria_territorial.parquet`
  y `categoria_sin_vigente.parquet` (criticos para el motor),
  `establecimientos_chile.parquet` (popup de EE), `comunas_chile.parquet` y
  `sleps_chile.parquet` (selectores territoriales).
- Del madre: `33_generar_html.R` y `33_motor_template.html` (moldes a portar;
  voluminoso el template, pero critico).

### Nota final
Si algun archivo listado cambio entre sesiones, adjuntar la version mas
actualizada al abrir y avisarlo en el mensaje de apertura.
