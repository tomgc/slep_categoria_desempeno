# Traspaso de cierre v03 — slep_categoria_desempeno

## 1. Identificacion

- **Proyecto:** slep_categoria_desempeno
- **Version del traspaso:** v03
- **Fecha:** 2026-06-12
- **Sesion:** 3, foco unico: construir el motor HTML (paso 33) sobre el pipeline R ya validado, mas iteraciones de UI.
- **Entorno:** R 4.5.x en Positron (macOS aarch64); motor HTML standalone (React 18 + D3 v7 + pako, JSON embebido gzip+base64).
- **Modelo:** Claude Opus 4.8.
- **Archivos principales modificados/creados:**
  - `30_procesamiento/33_generar_html.R` (nuevo)
  - `30_procesamiento/33_motor_template.html` (nuevo; reemplaza el molde portado del madre)
  - `10_utils/d3.min.js`, `10_utils/pako.min.js` (descargados, versionados)
  - `40_salidas/motor_categoria.html` (producto generado; no se versiona, regenerable)

---

## 2. Resumen ejecutivo

Se construyo desde cero el motor HTML del proyecto (paso 33), la unica pieza
estructural que faltaba sobre el pipeline R validado en la sesion 2. El trabajo
siguio la ruta P1 (diseno) -> P2 (generador R) -> P3 (componente JS), todas
completadas. El generador `33_generar_html.R` lee los 6 parquets, ensambla un
JSON columnar (territorial + sin_vigente + rbd) con validacion de integridad,
lo comprime gzip+base64 y lo embebe en el template; corre end-to-end via
`run_all()` paso 4, produciendo `motor_categoria.html` de ~928 KB. El template
se reescribio sobre el shell del madre `slep_simce_adecuado` (head, design
tokens, CSS de modal, patron de carga), descartando todo el aparato SIMCE de
lineas/GSE/ponderacion y construyendo una capa de datos nueva (`CatData`,
conteo de EE sin ponderacion ni GSE) y una vista de 4 columnas (Insuficiente ->
Alto) con filas de establecimientos, trayectoria por anio y seccion "sin
categoria vigente". Tras la version base se hicieron cuatro tandas de
iteracion visual a pedido del titular (paleta, año completo, trayectoria
rediseñada, filtros de comuna y dependencia, selector de establecimiento
individual, leyenda agrandada). Toda la logica de datos fue validada en Node
contra los parquets reales (distribucion de Costa Central basica 2019 = 56
categorizados, cuadra al EE; nacional media = 2837, cuadra). Quedo pendiente la
migracion a GitHub (proxima sesion) y una tanda de pendientes de UI/pipeline
acumulados durante la sesion.

---

## 3. Estado al cierre

### Funciona (ultima ejecucion exitosa: 2026-06-12)
- Pipeline R completo 30 -> 31 -> 32 (heredado de v02, sin cambios).
- `33_generar_html.R`: corre via `run_all()` paso 4; validacion C.8 pasa;
  JSON 5.7 MB -> 0.56 MB comprimido; HTML final 928 KB; abre sin red tras
  primera carga (React/Babel desde CDN con SRI).
- Motor HTML: carga, renderiza las 4 columnas con datos reales, semilla en
  SLEP Costa Central / nivel basica; selector de territorio (comuna / SLEP /
  region / establecimiento); toggle de nivel; filtros de comuna y dependencia;
  trayectoria por anio con año vigente destacado; seccion sin categoria vigente.

### No funciona / no existe aun
- Migracion a GitHub no iniciada (falta `gobernanza_datos.md`, `LICENSE`,
  auditoria de seguridad pre-migracion de la seccion 4.3).
- Pendientes de UI sin abordar (ver seccion 11): click en EE con trayectoria
  detallada, seccion metodologia, matricula + emplazamiento en ficha, filtro
  de "establecimientos en riesgo", posible vista dedicada de EE.

### Delta respecto a v02
- Se agrego el paso 33 completo (generador + template), antes inexistente.
- Se agregaron `d3.min.js` y `pako.min.js` a `10_utils/`.
- El producto `motor_categoria.html` ahora existe en `40_salidas/`.

---

## 4. Registro detallado de cambios

### Cambio 16 — 33_generar_html.R (nuevo)
- **Categoria:** Diseno UI / motor.
- **Que:** generador del producto final. Lee los 6 parquets, construye meta
  (anios, anio_vigente=2019, categorias en orden semantico, cat_colors,
  cat_labels, motivos, depe_labels), catalogos (regiones, comunas, sleps,
  establecimientos) y tres bloques columnares (territorial 10780, sin_vigente
  1985, rbd 41244). Serializa con jsonlite (auto_unbox, columnar), comprime
  gzip+base64, reemplaza los 3 placeholders del template, escribe
  `motor_categoria.html` en UTF-8.
- **Por que (C.11):** la mitad determinista del motor; estabilizarla antes del
  componente JS evita depurar dos capas a la vez.
- **Como se verifico (B.4):** corre via run_all paso 4; validacion C.8 (filas
  cuadran con parquets, categorias y niveles esperados, nacional presente);
  simulacion de compresion y roundtrip en Python (0.55 MB, roundtrip OK).
- **Clave:** strings no-ASCII con `\uXXXX` (bug locale C); `sub(..., fixed=TRUE)`
  en los 3 placeholders; escritura binaria UTF-8.

### Cambio 17 — 33_motor_template.html (nuevo, base)
- **Categoria:** Diseno UI / motor.
- **Que:** template React/D3 reescrito sobre el shell del madre. Capa `CatData`
  (conteo sin ponderacion ni GSE): indices territorial, sin_vigente y por-EE;
  `getDistribucion`, `getSinVigente`, `getEstablecimientos`. Vista de 4 columnas
  en orden Insuficiente -> Alto, filas de EE con trayectoria, seccion sin
  categoria vigente. Selector de entidad (modal). Formato chileno.
- **Por que (C.11):** el componente visual del madre es SIMCE de lineas/GSE,
  veneno aqui (instrucciones 🔒/⚠️ del traspaso v02). Se porto contenedor, no
  contenido.
- **Como se verifico (B.4):** JSX compila con Babel; logica de `CatData` probada
  en Node contra parquets reales (Costa Central basica 2019 = 56, suma cuadra;
  nacional media = 2837, cuadra; conteo por columna == encabezado territorial).

### Cambio 18 — Iteracion UI tanda 1 (paleta + año completo + comuna en ficha)
- **Categoria:** Diseno UI / motor.
- **Que:** paleta inicial corregida; chips de trayectoria con año completo (luego
  rediseñados); comuna agregada a la ficha; mas espacio entre EE.
- **Verificacion:** comuna poblada en todas las fichas (ej. Quintero, RBD 1853).

### Cambio 19 — Iteracion UI tanda 2 (paleta azul institucional)
- **Categoria:** Diseno UI / motor.
- **Que:** Alto = `#0062A0` (ocean, azul institucional); Medio = `#2A8FD9`
  (mark-blue, azul claro). Resuelve el choque rojo/coral.

### Cambio 20 — Iteracion UI tanda 3 (trayectoria rediseñada + filtro comuna + fix pct)
- **Categoria:** Diseno UI / motor.
- **Que:** trayectoria rediseñada (año como rotulo arriba, marca cuadrada de
  color abajo); orden reciente -> antiguo; año vigente con anillo; nombres de
  EE sin truncar; filtro de comuna multi-select (todas por defecto). Header de
  columna pasa a usar el pct autoritativo del territorial (resuelve el "0,0%"
  observado).
- **Bug resuelto:** ver seccion 6, Bug 1.

### Cambio 21 — Iteracion UI tanda 4 (selector EE + filtro dependencia + leyenda)
- **Categoria:** Diseno UI / motor.
- **Que:** eliminada la categoria "nacional" del selector; agregada
  "establecimiento" (busqueda por nombre/RBD, EE individual). Eliminados los
  atajos "Todas/Ninguna" de los filtros. Agregado filtro de dependencia bajo el
  de comuna. Dependencia agregada a la ficha. Año vigente con rotulo en azul.
  Leyenda de trayectoria agrandada (bloque con fondo, titulo destacado, swatches
  16px). Header de distribucion calculado desde los EE visibles (refleja
  filtros). `distribucionDesdeEE` nuevo en CatData.
- **Bug resuelto:** ver seccion 6, Bug 2.

---

## 5. Backlog acumulativo

### Objetivo del proyecto
slep_categoria_desempeno es un motor interactivo (R + HTML autocontenido) que
compara la distribucion de establecimientos por Categoria de Desempeno (Alto /
Medio / Medio-Bajo / Insuficiente) de la Agencia de Calidad, entre comunas,
SLEPs, regiones y el nivel nacional, separando basica y media. Pipeline en R
(xlsx -> parquet -> JSON embebido -> HTML), publicado en GitHub Pages. Para el
equipo de Monitoreo del SLEP Costa Central, desde 2026. Datos publicos.

(Nota v03: la opcion "nacional" del selector se elimino en la sesion 3 por
volumen de EE; se agrego seleccion de establecimiento individual. El objetivo
permanente del proyecto no cambia.)

### Nota metodologica del conteo
Un "cambio" es una solicitud distinguible del titular, no las acciones tecnicas
que la implementan. No cuentan los errores del asistente corregidos de
inmediato; si cuentan los bugfixes reportados por el titular. Clasificacion por
intencion primaria. Fuentes: registro de la sesion.

### Clasificacion tematica (refinada en sesion 2; sin cambios de taxonomia en sesion 3)
| Categoria | N | % | Descripcion |
|---|---|---|---|
| Scaffold e inicializacion | 9 | 43 | Estructura, scaffold, decisiones de diseno v01 |
| Diseno UI / motor | 6 | 29 | Diseno de grillas (v01); motor HTML + iteraciones (v03) |
| Pipeline R | 3 | 14 | Pasos 30-32 de procesamiento |
| Orquestacion | 1 | 5 | 00_run_all.R |
| Datos y normalizacion | 1 | 5 | Esquema xlsx, normalizacion categoria |

(En sesion 3 "Diseno UI / motor" paso de 1 a 6 cambios al construirse el motor;
supera el umbral de subdivision del 25%, candidato a desdoblar en "Motor:
generador R" vs "Motor: componente JS / UI" en la proxima sesion si sigue
creciendo.)

### Resumen estadistico por sesion
| Sesion | Traspasos | N cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 11 | (v01) | Scaffold y diseno |
| 2 | v02 | 4 | Opus 4.8 | Pipeline R 30-32 + orquestador |
| 3 | v03 | 6 | Opus 4.8 | Motor HTML (paso 33) + iteraciones UI |
| **Total** | | **21** | | |

### Detalle cronologico
- **Sesion 1 (cambios 1-11):** ver traspaso v01 (scaffold, repo, diseno de
  datos y UI, decisiones 1-3).
- **Sesion 2 (cambios 12-15):** 12 auxiliares; 13 leer/normalizar; 14
  agregacion territorial; 15 orquestador + archivo de stub.
- **Sesion 3 (cambios 16-21):** 16 generador `33_generar_html.R`; 17 template
  base `33_motor_template.html`; 18 iteracion UI tanda 1 (paleta inicial, año
  completo, comuna en ficha); 19 tanda 2 (azul institucional); 20 tanda 3
  (trayectoria rediseñada, filtro comuna, fix pct 0,0%); 21 tanda 4 (selector
  EE, filtro dependencia, leyenda agrandada, distribucion desde EE).

### Delta del backlog
6 entradas nuevas (16-21). Sin cambios de taxonomia, pero "Diseno UI / motor"
crecio a 29% (umbral de subdivision); marcado para desdoblar la proxima vez si
sigue creciendo.

---

## 6. Bugs de la sesion

### Bug 1 — Header de columna mostraba "0,0%" en algunos territorios
- **Sintoma observable:** una columna con N establecimientos mostraba "0,0%" en
  el encabezado (visto en captura del titular sobre Insuficiente con 4 EE).
- **Causa raiz:** el header recalculaba `n_ee / stat.total` en JS en lugar de
  usar el pct ya calculado en R (n_ee/n_categorizados). Ante cualquier desajuste
  de `total` en la celda, el cociente colapsaba a 0,0%.
- **Solucion exacta:** `CatColumn` usa `stat.pct` (autoritativo del territorial,
  calculado en R) con fallback a `n_ee/total`. (`33_motor_template.html`,
  funcion `CatColumn`.)
- **Criterio de verificacion:** Costa Central basica 2019 Insuficiente =
  7,1% en Node y en navegador.
- **Patron general aprendido:** no recalcular en el cliente una cifra que el
  pipeline R ya calculo de forma autoritativa; transportarla y mostrarla. El
  recalculo duplica logica y abre divergencias (regla DRY del proyecto).
- **Principio:** C.6 (rigor), evitar duplicacion de logica.
- **Estado:** resuelto.

### Bug 2 — Sort de catalogo de EE reventaba con nombres null
- **Sintoma observable:** `TypeError: Cannot read properties of null (reading
  'localeCompare')` al construir `ESTAB_CAT`.
- **Causa raiz:** algunos RBD en `categoria_rbd` tienen `nom_rbd` null; el sort
  por nombre fallaba.
- **Solucion exacta:** fallback `m.nom || ("RBD " + rbd)` en `ESTAB_CAT` y en
  `getEstablecimientos`. (`33_motor_template.html`, capa CatData.)
- **Criterio de verificacion:** ESTAB_CAT construye 9040 EE sin error; EE 1704
  (Kennedy) lista correctamente.
- **Patron general aprendido:** todo campo de texto proveniente del dato crudo
  puede venir null; blindar antes de operaciones que asumen string (sort,
  localeCompare). Auditar el caso general, no solo el reportado.
- **Principio:** C.8 (validacion de integridad), investigacion de causa raiz.
- **Estado:** resuelto.

---

## 7. Aprendizajes y restricciones descubiertas

### A4 — No recalcular en el cliente cifras autoritativas del pipeline
Toda cifra que el pipeline R calcula (pct = n_ee/n_categorizados) viaja en el
JSON y se muestra tal cual. Recalcularla en JS duplica logica y abre
divergencias (origen del Bug 1). Contexto si se viola: cifras inconsistentes
entre el dato y la UI. Ejemplo: el "0,0%" del header.

### A5 — Blindar campos de texto del dato crudo antes de operarlos
`nom_rbd` puede venir null en `categoria_rbd`. Cualquier sort/localeCompare
sobre texto crudo debe tener fallback. Contexto: crash de render. Ejemplo: Bug 2.

### A6 — El componente del madre se porta como contenedor, no como contenido
El shell (head, tokens, CSS de modal, patron de carga gzip+pako) es reutilizable;
la capa de visualizacion (lineas, GSE, ponderacion) es especifica del madre y se
descarta entera. Construir `CatData` desde cero evito arrastrar maquinaria
inaplicable. Ejemplo: se descarto SparklineSubchart/RecentBars/ResultsTable/
HeatLegend/GseFilter del madre.

### A7 — Definir criterio observable antes de iterar posicionamiento visual
Cada tanda de UI se cerro con criterio verificable (color exacto, conteo, orden
de chips) antes de tocar parametros. Respeta el anti-patron documentado del
proyecto hermano (parcheo iterativo sin criterio no converge).

---

## 8. Decisiones de diseno

### D-cobertura-temporal — Año vigente 2019, trayectoria sin hueco de pandemia
- **Decision:** la cobertura del dato es 2016-2019 (cuatro años consecutivos en
  basica; 2017-2019 en media). Año vigente = 2019. La trayectoria muestra los
  años disponibles sin dibujar hueco de pandemia (no ocurre en el rango).
- **Alternativa considerada:** replicar el "Last 5" con hueco de pandemia del
  madre (SIMCE 2016-2025). Descartada: inventaria un gap inexistente, falsearia
  el dato.
- **Implicancia:** si en el futuro entran mas años, el componente los toma de
  `meta.anios` automaticamente.
- **Confirmada por el titular en la sesion 3.**
- **Replicar como archivo:** `decisiones/20260612_decision_cobertura_temporal.md`
  (pendiente de creacion; ver seccion 11).

### D-paleta-categorias — Paleta de 4 categorias
- **Decision:** Insuficiente `#EE2D49` (rojo) / Medio-Bajo `#E88663` (coral) /
  Medio `#2A8FD9` (azul claro) / Alto `#0062A0` (azul institucional ocean).
- **Alternativa:** Alto en verde/olive (descartada por el titular: Alto debe ser
  azul institucional).
- **Implicancia:** la constante `CAT_COLORS` vive en `33_generar_html.R` y viaja
  en `meta.cat_colors`; el template no la hardcodea.
- **Confirmada por el titular en la sesion 3.**
- **Replicar como archivo:** `decisiones/20260612_decision_paleta_categorias.md`
  (pendiente; ver seccion 11).

### D-distribucion-desde-EE — Header de distribucion calculado desde EE visibles
- **Decision:** el conteo del encabezado (n_ee por categoria, total) se calcula
  desde la lista de EE visible (post-filtros), no solo desde el territorial.
- **Alternativa:** mostrar siempre el territorial completo ignorando filtros.
  Descartada: el header debe reflejar lo que el usuario ve filtrado.
- **Implicancia:** `distribucionDesdeEE` en CatData; coincide con el territorial
  cuando no hay filtros (verificado: 56 = 56).

### D-selector-establecimiento — EE individual reemplaza a nacional
- **Decision:** se quito "nacional" (demasiados EE) y se agrego seleccion de un
  establecimiento individual (busqueda por nombre/RBD).
- **Implicancia:** `rbdsDeEntidad` soporta `kind === "establecimiento"`; la
  grilla muestra ese EE en su columna vigente.

---

## 9. Constantes y parametros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| CAT_ORDEN | INSUFICIENTE, MEDIO-BAJO, MEDIO, ALTO | 33_generar_html.R | orden semantico |
| CAT_COLORS.ALTO | #0062A0 | 33_generar_html.R | azul institucional (cambio sesion 3) |
| CAT_COLORS.MEDIO | #2A8FD9 | 33_generar_html.R | azul claro (cambio sesion 3) |
| CAT_COLORS.MEDIO-BAJO | #E88663 | 33_generar_html.R | coral |
| CAT_COLORS.INSUFICIENTE | #EE2D49 | 33_generar_html.R | rojo |
| DEPE_LABELS | 1..5 -> Municipal/Part.Subv./Part.Pagado/CAD/SLEP | 33_generar_html.R | nuevo sesion 3 |
| PCT_DIGITS | 4 | 33_generar_html.R | redondeo de pct en JSON |
| anio_vigente | 2019 | meta (derivado de max(anios)) | decision D-cobertura |

---

## 10. Arquitectura de archivos

Referencia al escaner al cierre: re-ejecutar `00_escanear_proyecto.R` antes de
abrir la sesion 4 (el snapshot de este traspaso es previo a agregar
`33_generar_html.R`, `33_motor_template.html`, `d3.min.js`, `pako.min.js`).
La estructura respeta la politica: el paso 33 y los utils JS entran en sus
decenas correctas (`30_procesamiento/`, `10_utils/`). Sin desviaciones nuevas.

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**P-github — Migracion a GitHub (dos raices / Rama A publica)**
- **Tipo:** bloqueante para publicacion / despliegue.
- **Contexto:** el titular pidio cerrar esta sesion y partir con la migracion.
- **Que falta (seccion 4.3):** auditoria de seguridad pre-migracion
  (`diagnostico_migracion_github.R`: RUT, correos, rutas absolutas, tokens);
  `gobernanza_datos.md`; `LICENSE` (MIT, sin cubrir datos); confirmar
  visibilidad del repo (publico vs privado).
- **Decision estrategica abierta:** publico (coherente con datos publicos +
  GitHub Pages) vs privado. El titular debe definirla al abrir la sesion 4.
- **Complejidad:** Media.
- **Criterio de exito:** repo en GitHub con auditoria pasada, gobernanza y
  licencia presentes, primer push limpio (`git status` revisado).

**P-ee-trayectoria — Click en EE abre seccion de trayectoria detallada**
- **Tipo:** funcionalidad.
- **Contexto:** al hacer click en un establecimiento, abrir abajo una seccion
  que muestre su trayectoria (movimientos por las categorias en los años
  disponibles). Reutilizar el espacio que hoy ocupa "Sin categoria vigente";
  mover ese bloque a un lugar mas sutil.
- **Complejidad:** Media-Alta.
- **Criterio de exito:** click en una fila de EE despliega su trayectoria
  detallada; el bloque "sin categoria vigente" se reubica sin perder informacion.

**P-metodologia — Seccion de metodologia**
- **Tipo:** documentacion / UI.
- **Contexto:** agregar seccion de metodologia en el estilo del motor
  `slep_simce_adecuado` (nivel Adecuado).
- **Complejidad:** Baja-Media.
- **Criterio de exito:** seccion presente, coherente con el estilo del hermano,
  explicando conteo de EE, sin ponderacion, sin GSE, cobertura 2016-2019.

**P-ficha-datos — Matricula y emplazamiento en la ficha de EE**
- **Tipo:** funcionalidad / pipeline.
- **Contexto:** agregar a la ficha de cada EE matricula actual y emplazamiento
  (rural/urbano). NINGUNO esta en los parquets actuales: la matricula la aporta
  el titular; el emplazamiento esta en el directorio oficial de EE y hay que
  traerlo aguas arriba en el pipeline R (31/32 o un join contra el directorio).
- **Complejidad:** Media (toca pipeline R, no solo UI).
- **Criterio de exito:** ficha muestra comuna (ya), dependencia (ya), matricula
  y emplazamiento; los datos viajan en el bloque `rbd` del JSON.

**P-filtro-riesgo — Filtro de establecimientos en riesgo (bajo el de comuna)**
- **Tipo:** funcionalidad.
- **Contexto:** filtro con dos pills: "Todos los establecimientos" y
  "Establecimientos en riesgo". La definicion de "en riesgo" la dara el titular
  al abordar el pendiente (input de dominio requerido, NO resolver autonomamente).
- **Complejidad:** Baja-Media (depende de la definicion).
- **Criterio de exito:** dos pills operativas que filtran la grilla; "en riesgo"
  segun la definicion del titular.

**P-vista-ee — Vista dedicada para establecimiento individual (opcional)**
- **Tipo:** mejora visual.
- **Contexto:** al elegir un EE individual, la grilla de 4 columnas con una sola
  poblada es subaprovechada; podria ser una ficha ampliada con su trayectoria.
  Encaja con P-ee-trayectoria.
- **Complejidad:** Media.
- **Criterio de exito:** modo EE muestra una vista util (no 3 columnas vacias).

**P-decisiones — Documentar decisiones de la sesion 3**
- **Tipo:** documentacion.
- **Contexto:** crear `decisiones/20260612_decision_cobertura_temporal.md` y
  `decisiones/20260612_decision_paleta_categorias.md` (ver seccion 8).
- **Complejidad:** Baja.
- **Criterio de exito:** dos archivos en `50_documentacion/activa/decisiones/`.

### Evaluacion de deuda tecnica
- `CatData` quedo solido y validado; sin deuda nueva relevante.
- El modo "establecimiento" reutiliza la grilla de 4 columnas (subaprovechada
  con un solo EE): zona candidata a mejora (P-vista-ee).
- Categoria "Diseno UI / motor" del backlog supera el 25%: subdividir en la
  proxima sesion si sigue creciendo.

### Auditoria de cierre (politica 5.6, preguntas "Cierre")
- **5. Cada transformacion critica con check de validacion?** Si — el generador
  tiene validacion C.8 (filas cuadran, categorias/niveles esperados).
- **6. Outputs reproducibles e idempotentes?** Si — `run_all()` paso 4 regenera
  identico; escritura del HTML completa.
- **7. Decisiones metodologicas como constantes nombradas?** Si — CAT_ORDEN,
  CAT_COLORS, DEPE_LABELS, PCT_DIGITS al inicio del generador.
- **8. Nombres sin tildes/ñ/espacios?** Si — archivos del paso 33 en snake_case.
- Sin respuestas "no": no se agrega deuda nueva por auditoria de cierre.

### Ruta sugerida para la sesion 4
1. **P-github** (foco unico sugerido): es lo que el titular pidio explicitamente.
   Aplica el protocolo 4.3. Primera accion: confirmar visibilidad del repo
   (decision estrategica). Criterio de exito: primer push limpio con auditoria,
   gobernanza y licencia. Diferir el resto de pendientes de UI.
2. Si sobra tiempo: **P-decisiones** (cierre barato, dos archivos).
- **Diferir:** P-ee-trayectoria, P-metodologia, P-ficha-datos, P-filtro-riesgo,
  P-vista-ee (tanda de UI/pipeline; merecen su propia sesion con criterios de
  exito definidos y, en el caso de P-filtro-riesgo y P-ficha-datos, input de
  dominio del titular).

---

## 12. Instrucciones especificas para la proxima sesion

- 🔒 **Basica y media nunca se mezclan** en una cifra agregada (invariante del
  proyecto desde v01).
- 🔒 **Agregacion = conteo de EE.** Jamas ponderacion por matricula, jamas GSE.
- 🔒 **El pct mostrado en la UI es el autoritativo del territorial** (calculado
  en R). NO recalcular cifras en el cliente (Bug 1).
- ✅ ANTES de tocar `CatData`, recordar que `nom_rbd` puede venir null: blindar
  cualquier operacion de texto (Bug 2).
- ✅ ANTES del primer push a GitHub, ejecutar la auditoria de seguridad de la
  seccion 4.3 y esperar revision del titular (compuerta de gobernanza).
- ⚠️ NO definir "establecimiento en riesgo" de forma autonoma: requiere input
  de dominio del titular (P-filtro-riesgo).
- ⚠️ NO agregar matricula/emplazamiento sin traerlos aguas arriba en el pipeline
  R: no estan en los parquets actuales (P-ficha-datos).
- ⚠️ NO regenerar el HTML asumiendo que `d3.min.js`/`pako.min.js` existen: el
  generador falla con mensaje claro si faltan (estan versionados en `10_utils/`).

---

## 13. Fragmentos de codigo de referencia

### Patron de placeholders del generador (la forma correcta aqui)
```r
# fixed=TRUE evita interpretacion regex (nombres con caracteres especiales).
html <- sub("__D3_INLINE__",   d3_code,   plantilla, fixed = TRUE)
html <- sub("__PAKO_INLINE__", pako_code, html,      fixed = TRUE)
html <- sub("__JSON_DATA__",   json_b64,  html,      fixed = TRUE)
```

### Distribucion desde EE visibles (refleja filtros; cuadra con territorial)
```javascript
function distribucionDesdeEE(listaEE) {
  const cats = {};
  CATEGORIAS.forEach(c => { cats[c] = { n_ee: 0, pct: 0 }; });
  let total = 0;
  listaEE.forEach(ee => {
    if (ee.vigente && cats[ee.vigente]) { cats[ee.vigente].n_ee += 1; total += 1; }
  });
  CATEGORIAS.forEach(c => { cats[c].pct = total > 0 ? cats[c].n_ee / total : 0; });
  return { total, cats };
}
```

### Blindaje de texto crudo (Bug 2)
```javascript
out.push({ rbd, nom: m.nom || ("RBD " + rbd), /* ... */ });
```

---

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 4 (Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del Project;
> leelo desde ahi. Retomamos slep_categoria_desempeno en sesion 4, foco unico:
> migracion del proyecto a GitHub (Rama A, protocolo 4.3). Adjunto el traspaso
> v03 y el escaner actual.

### Documentos para la proxima sesion

**1. Protocolo en knowledge base (NO se adjuntan; verificar que esten al dia):**
- `POLITICA_PROYECTO.md`
- `SETTINGS_Y_PROMPTS_OPERACIONALES.md`

**2. Opcionales segun el foco (migracion a GitHub):**
- `CLAUDE.md` (si la sesion correra en Claude Code; copiar a la raiz).
- Protocolo 4.3 de `SETTINGS_Y_PROMPTS_OPERACIONALES.md` (migracion a GitHub).

**3. Especificos de la sesion (SI se adjuntan):**
- `traspaso_cierre_v03.md` (este documento).
- `estructura_actual.md` (re-ejecutar el escaner ANTES de adjuntar: debe incluir
  `33_generar_html.R`, `33_motor_template.html`, `d3.min.js`, `pako.min.js`).

### Nota final
Re-ejecutar `00_escanear_proyecto.R` antes de abrir la sesion 4: el escaner
actual es previo a los archivos del paso 33. Si algun archivo listado cambio,
adjuntar la version mas reciente y avisarlo en el mensaje de apertura.
