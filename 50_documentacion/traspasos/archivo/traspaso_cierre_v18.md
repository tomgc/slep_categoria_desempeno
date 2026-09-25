# Traspaso de cierre v18 — slep_categoria_desempeno

## 1. Identificacion
- **Proyecto:** slep_categoria_desempeno
- **Version:** v18
- **Fecha:** 2026-06-17
- **Sesion:** 18 — cierre de los dos pendientes vivos heredados del v17:
  consolidacion administrativa del backlog 81-82 sobre 82, e internalizacion de
  React/ReactDOM (alcance A; Babel queda en CDN por decision de peso). Cero cambios
  de calculo; el unico cambio de salida (peso del motor) se verifico con auditoria
  F1-F4 + spot-check 6/6 + 1 ausencia. Ademas se reevaluo a fondo el pendiente de
  internalizar Babel (alcance C) y se dejo una ruta escrita para una sesion dedicada.
- **Entorno:** R 4.5.x en Positron, macOS aarch64. Modelo: Claude Opus 4.8.
  Ejecucion en consola R de Positron y terminal zsh (cinco proyectos en paralelo;
  no asumir sesion ni working directory entre comandos).
- **Archivos principales modificados:**
  - `50_documentacion/activa/backlog_consolidado.md`: consolidacion 81-82 sobre 82
    (detalle cronologico sesion 17, fila por sesion N=2, ambas tablas recalculadas,
    nota de conteo y delta v17). 51K -> 54.3K. Commit `7a94b2d`.
  - `30_procesamiento/33_motor_template.html`: los `<script src>` de React y ReactDOM
    (unpkg) se reemplazaron por placeholders `__REACT_INLINE__` / `__REACTDOM_INLINE__`;
    Babel se mantuvo en CDN con su SRI. Comentario reescrito. 126.2K -> 123K (los dos
    src largos salieron; los placeholders son cortos).
  - `30_procesamiento/33_generar_html.R`: rutas + validacion de existencia de los dos
    `.js` nuevos (con instruccion curl en el `stop`), su lectura, los 5 placeholders en
    el `for` de validacion y en la inyeccion (5 `sub()`), y su liberacion en el `rm()`.
    19.4K -> 20.7K. Commit `d935805`.
  - `10_utils/react.production.min.js` (10.5K) y `10_utils/react-dom.production.min.js`
    (129K): NUEVOS, bajados de unpkg (versiones fijadas 18.3.1). Commit `d935805`.
  - `docs/index.html` y `40_salidas/motor_categoria.html`: regenerados. 1.72 -> 1.82 MB.
    Commit `98b127c`.
  - `50_documentacion/estructura/`: snapshots del escaner (poda retencion=2). Commit
    `bdb9e3c` (apertura) + snapshot de cierre `094448` PENDIENTE de commit (ver seccion 6).

## 2. Resumen ejecutivo
La sesion 18 abrio sobre el v17 con el motor estable (1.72 MB), desplegado, cifras
certificadas y sin bloqueantes. La ruta aprobada fue P1 (consolidar el backlog 81-82,
administrativo) y P2 (internalizar dependencias CDN, alcance A acordado: React/ReactDOM
inline, Babel en CDN). P1 se ejecuto: se agregaron las entradas 81-82 al detalle
cronologico, la fila de la sesion 17 (N=2) a la tabla por sesion, y ambas tablas se
recalcularon sobre 82 (verificadas: suman 82, cuadran con el cronologico; A22). P2 se
ejecuto: el motor cargaba React 18.3.1, ReactDOM 18.3.1 y Babel 7.29.0 desde unpkg en
runtime (unica violacion viva de 5.5); se internalizaron React y ReactDOM como scripts
inline via dos placeholders nuevos, dejando Babel en CDN por su peso (~3 MB standalone,
internalizarlo deshacia la ganancia del v17). El motor crecio de 1.72 a 1.82 MB (+~100 KB:
React 10.5K + ReactDOM 129K en disco, menor tras gzip+base64) con cifras identicas
(auditoria F1-F4 OK, 0 discrepancias; spot-check 6/6 presencia + 1 ausencia OK; F4 sin
drift). Cuatro commits atomicos pusheados a origin/main; arbol limpio. Tras cerrar P1-P2
se reevaluo el pendiente de Babel (alcance C): se reencuadro el problema (no es como
transpilar JSX, sino si el proyecto necesita JSX en runtime) y se concluyo que C3
(reescribir el JSX a React.createElement plano, eliminando Babel de raiz sin Node ni paso
manual) es la unica opcion que no compromete ningun principio estructural, pero es un
refactor de alto riesgo que exige snapshot previo y sesion dedicada. Se difirio a la s19
con ruta escrita (seccion 11). La sesion no abrio trabajo de producto nuevo: no hay
pendiente de funcionalidad en el backlog.

## 3. Estado al cierre

### Que funciona (ultima ejecucion exitosa)
- **MOTOR SIN DEPENDENCIA DE RED PARA REACT/REACTDOM:** el HTML embebe React y ReactDOM
  inline. Solo Babel sigue desde unpkg (CDN). `docs/index.html` regenerado (1.82 MB) y
  pusheado; GitHub Pages sirve la version nueva. La ficha (layout D2 del v16) sin cambios
  visuales.
- **PIPELINE INTACTO SALVO EL GENERADOR DE SALIDA:** los pasos 30-32 no se tocaron. El
  paso 33 (`33_generar_html.R`) cambio solo en lo que inyecta (2 placeholders nuevos +
  lectura de 2 `.js`); el calculo de todos los bloques es identico. `run_all()`/
  `regenerar_motor()` corren limpio (paso 33 OK en ~0.9 s).
- **CIFRAS CERTIFICADAS POR DOBLE VIA:** `source(here::here("tests","auditar_cifras.R"))`
  -> F1-F4 OK, 0 discrepancias (reporte `20260617_091115_auditoria_cifras.md`).
  `source(here::here("tests","spot_check_publicado.R"))` -> 6 presencia OK + 1 ausencia
  (media/2016) OK. Veredicto OK.
- **Arbol de Git limpio y pusheado:** `git status` -> working tree clean, up to date con
  origin/main. Commits `7a94b2d`, `d935805`, `98b127c`, `bdb9e3c` en origin/main
  (`44c7c23..bdb9e3c`).

### Que no funciona / pendiente
- No hay nada roto. Pendientes vivos: internalizar Babel / eliminar dependencia de red
  total (DIFERIDO a sesion dedicada, alcance C3, ver seccion 11); snapshot del escaner
  de cierre (`094448`) por commitear (administrativo de cierre). Observaciones de
  `suitedoc` (para `herramientas_dev`, no este repo). DT-template: CERRADA-SUPERADA (v17).
  `documentar.R`: diagnostico CERRADO (vigilancia pasiva).

### Delta respecto a v17
v17 desacoplo `matricula_grado`/`grado_labels` del JSON (2.80 -> 1.72 MB) y reclasifico
DT-template. v18 NO toca calculo ni JSON: cierra el pendiente administrativo (backlog
81-82 consolidado) e internaliza React/ReactDOM en el template (cambio de pipeline en el
paso 33: 2 placeholders nuevos). El motor sube de 1.72 a 1.82 MB por los dos `.js`
internalizados. Babel sigue en CDN (decision de alcance A). Cero cambios de calculo;
cifras identicas verificadas.

## 4. Registro detallado de cambios

### Cambio 83 — Internalizar React y ReactDOM (alcance A; Babel queda en CDN)
- **Categoria:** Pipeline R.
- **Que (`33_motor_template.html` + `33_generar_html.R` + `10_utils/`):** en el template,
  los dos `<script src>` de React y ReactDOM (unpkg, con SRI) se reemplazaron por
  `<script>__REACT_INLINE__</script>` y `<script>__REACTDOM_INLINE__</script>`; el bloque
  de Babel quedo intacto (CDN + SRI). En el generador: rutas `react_path` / `reactdom_path`
  a `10_utils/`, validacion de existencia con instruccion curl en el `stop`, lectura del
  codigo, los dos placeholders agregados al `for` de validacion (ahora 5) y a la inyeccion
  (5 `sub()`, React/ReactDOM primero), y `react_code`/`reactdom_code` liberados en el
  `rm()`. Dos `.js` nuevos bajados de unpkg a `10_utils/` (versiones 18.3.1).
- **Por que (C.11):** el motor cargaba React, ReactDOM y Babel desde unpkg en runtime: se
  rompe sin red o si unpkg cae, violando "web estatica sin dependencias externas" (5.5).
  Internalizar React/ReactDOM elimina dos de las tres dependencias de red con costo de peso
  marginal. Babel se dejo en CDN porque su build standalone (~3 MB) inflaria el motor
  deshaciendo la ganancia del v17 (decision de alcance A; alternativas en seccion 8).
- **Como se verifico (B.4):** template con 5 placeholders presentes (grep); unico `unpkg`
  en `<script src>` es Babel; balance sintactico del generador OK; `regenerar_motor()` OK
  (React 10 KB, ReactDOM 129 KB leidos; motor 1.82 MB); auditoria F1-F4 OK, 0
  discrepancias; spot-check 6/6 + 1 ausencia OK; F4 sin drift. SRI no se conserva en los
  inline (no aplica a scripts sin descarga de red; documentado en el comentario del
  template). Commits `d935805` (template + generador + 2 .js) y `98b127c` (motor
  regenerado).

### Cambio 84 — Consolidacion del backlog 81-82 sobre 82
- **Categoria:** Documentacion de proyecto.
- **Que (`backlog_consolidado.md`):** se agregaron las entradas 81 (desacople
  `matricula_grado`, "Pipeline R") y 82 (snapshots escaner, "Migracion y publicacion /
  DevOps") al detalle cronologico (nueva subseccion "Sesion 17"); la fila de la sesion 17
  (v17, N=2) a la tabla por sesion; las filas "Pipeline R" (4->5) y "Migracion y
  publicacion / DevOps" (3->4) en la tabla tematica; la nota de conteo recalculada sobre
  82; y un bloque "Delta v17 (80 -> 82)".
- **Por que (C.11):** el v17 dejo la consolidacion 81-82 como pendiente administrativo
  explicito de la sesion 18 (su seccion 5). El backlog es la fuente de verdad del conteo
  (politica 2.2.5); los traspasos agregan solo el delta y este archivo lo absorbe.
- **Como se verifico (B.4):** suma de la tabla tematica = 82; suma de la tabla por sesion
  = 82; ultima entrada del cronologico = 82 (A22: verificado contra el cronologico, no
  contra la tabla heredada). Commit `7a94b2d`.

### Cambio 85 — Snapshots del escaner (poda retencion=2)
- **Categoria:** Migracion y publicacion / DevOps.
- **Que (`50_documentacion/estructura/`):** el escaner se corrio al abrir (`082134`) y al
  cerrar (`094448`); la poda de retencion=2 conservo los 2 timestamps mas recientes +
  aliases. El commit `bdb9e3c` versiono el snapshot de apertura; el de cierre (`094448`)
  queda PENDIENTE de commit (ver seccion 6).
- **Por que (C.11):** el escaner se corre al abrir y cerrar (politica 7.1); se versiona
  aparte de los cambios de codigo (un cambio conceptual por commit).
- **Como se verifico (B.4):** commit `bdb9e3c` atomico (rename `130236`->`082134`); el
  snapshot `094448` confirmado en disco por el escaner de cierre (21 carpetas, 119
  archivos). El commit del snapshot de cierre es la primera tarea administrativa de la s19.

## 5. Backlog acumulativo
[El backlog vive in extenso en `50_documentacion/activa/backlog_consolidado.md` (sin
rango), fuente de verdad del conteo. Total cronologico 82 -> 85.
- Cambios nuevos de la sesion 18: 83 (internalizar React/ReactDOM, "Pipeline R"), 84
  (consolidacion del backlog 81-82, "Documentacion de proyecto"), 85 (snapshots del
  escaner, "Migracion y publicacion / DevOps").
- NOTA DE GRANULARIDAD: las entradas 81-82 son cambios de la sesion 17 (ya consolidados
  por el c.84 de esta sesion). El c.84 es el ACTO de consolidacion, propio de la s18, y
  cuenta como cambio de documentacion de la s18. No confundir: 81-82 = contenido de la
  s17; 84 = trabajo de la s18 que los absorbio.
- Delta de taxonomia: "Pipeline R" +1 (5->6); "Documentacion de proyecto" +1 (9->10);
  "Migracion y publicacion / DevOps" +1 (4->5). Sin categorias nuevas. Recalcular
  porcentajes sobre 85 al consolidar.
- PENDIENTE DE CONSOLIDACION: agregar 83-85 al `backlog_consolidado.md` (detalle
  cronologico de la sesion 18, fila de la sesion 18 en la tabla por sesion con N=3, y
  ambas tablas recalculadas sobre 85). Es el primer paso administrativo de la sesion 19,
  junto con el commit del snapshot de cierre.]

## 6. Bugs de la sesion
No hubo bugs de codigo. Dos notas de higiene de repositorio:
1. **Snapshot de cierre por commitear:** el escaner de cierre (`094448`) se sello en disco
   tras la regeneracion, pero el commit `bdb9e3c` (snapshot de sesion) se hizo ANTES de la
   regeneracion final, con el snapshot de apertura (`082134`). El `094448` (y su poda del
   `081708`) queda sin commitear al cierre del chat. NO es un bug: es el orden natural
   (se cierra el chat tras el ultimo escaner). Tarea de apertura de la s19: commitear
   `50_documentacion/estructura/`.
2. **Reportes de auditoria regenerables:** `auditar_cifras.R` reescribio
   `tests/reportes/auditoria_cifras.md` y emitio `20260617_091115_auditoria_cifras.md`.
   `tests/reportes/` esta ignorado por Git (A20: el escaner los lista pero Git no los
   trackea); no entran a ningun commit. Falsa deuda confirmada.

## 7. Aprendizajes y restricciones descubiertas

### A30 (NUEVO) — SRI no aplica a scripts inline; no arrastrar el integrity al internalizar
- **Regla:** al convertir un `<script src>` con `integrity`/`crossorigin` en un `<script>`
  inline, el SRI deja de tener sentido (protege la descarga por red, que ya no ocurre) y
  NO debe conservarse como atributo del inline ni como comentario que implique que sigue
  activo. Documentar en el comentario que la verificacion de integridad la da el versionado
  del `.js` en `10_utils/`, no el SRI.
- **Principio:** 5.5 (web estatica) + C.11 (transparencia del cambio). Contexto: c.83, al
  internalizar React/ReactDOM se reescribio el comentario del template para no afirmar SRI
  sobre los inline.

### A31 (NUEVO) — Reencuadrar el problema antes de elegir entre variantes de una solucion
- **Regla:** cuando las opciones para una deuda son todas variantes de una misma tactica
  (aqui: tres formas de "transpilar JSX"), conviene subir un nivel y preguntar si la tactica
  es necesaria. El reencuadre de Babel ("no es como transpilar, sino si el proyecto necesita
  JSX en runtime") revelo que C3 (eliminar JSX) no comparte el defecto estructural de C1/C2
  (Node en el pipeline / paso manual) y es la unica que no compromete un principio. Una
  recomendacion temprana ("no hacer nada") se corrigio tras el reencuadre.
- **Principio:** B.1 (pensar antes de codificar: supuestos sobre la mesa) + B.2 (simplicidad:
  cuestionar la necesidad antes que optimizar la implementacion). Contexto: reevaluacion de
  Babel, seccion 8 / 11.

## 8. Decisiones de diseno

### D28 (NUEVA) — Internalizar React/ReactDOM pero dejar Babel en CDN (alcance A)
- **Decision:** internalizar React 18.3.1 y ReactDOM 18.3.1 como scripts inline; mantener
  Babel standalone 7.29.0 en CDN (unpkg, con SRI).
- **Alternativas descartadas en esta sesion:** (B) internalizar tambien Babel (descartada:
  ~3 MB standalone llevarian el motor a ~4.7 MB, deshaciendo la reduccion del v17); (C)
  pre-transpilar el JSX en build para eliminar Babel (no descartada definitivamente:
  reencuadrada y diferida a sesion dedicada, ver D29 y seccion 11).
- **Justificacion:** elimina dos de las tres dependencias de red con costo de peso marginal
  (+~100 KB), cumpliendo 5.5 sobre las librerias de runtime estables, sin sacrificar la
  ganancia de peso recien obtenida. Babel queda como unica dependencia de red, fijada por
  version y servida por un CDN estable con SRI.
- **Implicancia:** el motor sigue necesitando red solo para Babel. Para eliminarla por
  completo, ver D29 (alcance C3, diferido).

### D29 (NUEVA) — Eliminar Babel via C3 (React.createElement), no via Node ni paso manual
- **Decision:** la via correcta para eliminar Babel es C3 (reescribir el JSX a
  React.createElement plano, usando Babel UNA sola vez como herramienta de migracion cuyo
  output se vuelve el nuevo fuente versionado, y retirando Babel del proyecto). NO C1 (Node
  en el build) ni C2 (transpilar a mano y commitear el JS manteniendo el JSX como fuente).
  Se difiere la EJECUCION a una sesion dedicada (alto riesgo, requiere snapshot previo).
- **Alternativas descartadas:** (C1) `system2()` a `npx babel`/`esbuild` en el paso 33
  (descartada: introduce Node como prerrequisito, rompe "una maquina nueva solo necesita R",
  viola portabilidad 5.3.7 y mete Node en el CI); (C2) transpilar a mano y commitear el JS
  con el JSX como fuente (descartada: reintroduce un paso manual fuera de `run_all()`,
  viola reproducibilidad completa 5.2.2 -> el motor y el fuente divergen en silencio si se
  regenera sin re-transpilar).
- **Justificacion:** C3 es la unica que no compromete un principio estructural: portabilidad
  intacta (sigue siendo R puro), reproducibilidad intacta (`run_all()` corre de cero),
  archivo unico intacto. Su costo es la legibilidad del `createElement` (mitigable con `htm`
  ~1 KB si el output es ilegible; a decidir viendo el output real). El riesgo es de ejecucion
  (refactor de ~1400 lineas sobre UI aprobada), no de principio.
- **Implicancia:** la deuda de Babel deja de ser "internalizar" y pasa a ser "eliminar JSX
  de runtime". Es la deuda real viva de 5.5 tras el v18. Requiere sesion dedicada con
  snapshot previo (politica 3).

### D26, D27 (v17), D25 (v16) y previas — vigentes sin cambios.

## 9. Constantes y parametros vigentes
[Sin cambios de CALCULO respecto al v17. El pipeline cambio solo en lo que el paso 33
inyecta (2 placeholders nuevos de runtime, no de datos).
- `33_generar_html.R`: placeholders ahora 5 (`__D3_INLINE__`, `__PAKO_INLINE__`,
  `__JSON_DATA__`, `__REACT_INLINE__`, `__REACTDOM_INLINE__`). Constantes de calculo
  (`CAT_ORDEN`, `CAT_COLORS`, `CAT_LABELS`, `MOTIVO_LABELS`, `DEPE_LABELS`, `ENSE2_LABELS`,
  `ENSE2_A_NIVEL`, `PCT_DIGITS`) sin cambios.
- `SPOT_CELDAS` (6 presencia) + `SPOT_AUSENCIAS` (1: media/2016) sin cambios.
- Versiones de runtime internalizadas: React 18.3.1, ReactDOM 18.3.1 (en `10_utils/`).
  Babel 7.29.0 en CDN (unpkg, SRI sha384 vigente).
- Valores del motor sin cambio: `anio_vigente`=2019, `anio_matricula_vigente`=2025,
  cobertura categoria 2016-2019, matricula 2016-2025, `CAT_REALES`, copy institucional.]

## 10. Arquitectura de archivos
Referencia al escaner de cierre: snapshot `20260617_094448` (21 carpetas, 119 archivos).
Cambios estructurales: `10_utils/` gana `react.production.min.js` (10.5K) y
`react-dom.production.min.js` (129K) -> extension `js` pasa de 2 a 4. `33_generar_html.R`
20.7K (era 19.4K). `33_motor_template.html` 123K (era 126.2K). `docs/index.html` y
`40_salidas/motor_categoria.html` 1.82 MB (eran 1.72). `backlog_consolidado.md` 54.3K (era
51K). Sin cambios de carpetas. Commits de la sesion (en origin/main, `44c7c23..bdb9e3c`):
`7a94b2d` (backlog 81-82), `d935805` (internalizar React/ReactDOM: template + generador +
2 .js), `98b127c` (motor regenerado 1.72->1.82 MB), `bdb9e3c` (snapshot escaner apertura),
mas el commit del traspaso v18. PENDIENTE: commit del snapshot de cierre `094448`.

## 11. Pendientes y ruta sugerida

### Inventario de pendientes
- **Eliminar Babel / dependencia de red total via C3 (DIFERIDO, alto riesgo, sesion
  dedicada).**
  Tipo: deuda tecnica / cumplimiento de politica 5.5. Tras el v18 el motor solo necesita
  red para Babel (unpkg). La via decidida es C3 (D29): reescribir el JSX (~1400 lineas) a
  React.createElement plano, usando Babel una vez como herramienta de migracion y
  retirandolo del proyecto. Complejidad: ALTA. Precaucion: refactor sobre UI aprobada (D2);
  exige snapshot en `_archivo/YYYYMMDD/` ANTES de empezar (politica 3) y verificacion visual
  del titular al final. Plan en 4 fases (abajo). Insumos: `33_motor_template.html` +
  `33_generar_html.R`. Criterio de exito: motor renderiza identico (revision visual) +
  auditoria F1-F4 + spot-check 6/6+1 + apertura sin red (DevTools Network offline) sin
  Babel. Decision abierta para la s19: si el `createElement` resulta ilegible, evaluar `htm`
  (~1 KB, sintaxis JSX-like sin transpilacion, inlineable) viendo el output real.
- **Consolidar backlog 83-85 + commit del snapshot de cierre (NUEVO, administrativo).**
  Tipo: documentacion + DevOps. Agregar 83-85 al `backlog_consolidado.md` (fila sesion 18,
  N=3, ambas tablas sobre 85, A22) y commitear `50_documentacion/estructura/` con el
  snapshot `094448`. Complejidad: baja.
- **DT-template (CERRADA-SUPERADA, v17).** No es deuda activa. Se conserva como decision.
- **`documentar.R` (diagnostico CERRADO, vigilancia pasiva).** Si reaparece `deleted`,
  `git checkout -- documentar.R` y anotar la sesion previa.
- **Observaciones de `suitedoc` (para `herramientas_dev`, NO este repo).** Sin cambios.

### Pendientes del v17 cerrados en v18
- Consolidar backlog 81-82: CERRADO (c.84).
- Internalizar dependencias CDN (alcance A): CERRADO (c.83; React/ReactDOM inline, Babel
  en CDN por decision de peso).

### Plan C3 para la sesion 19 (escrito, no ejecutado)
- **Fase 0 — Preparacion:** snapshot del template aprobado en `_archivo/YYYYMMDD/`;
  criterio de exito del refactor definido (render identico + auditoria + spot-check + sin
  red, sin Babel).
- **Fase 1 — Transpilacion mecanica unica:** en la maquina del titular, una sola vez,
  `npx @babel/cli` (presets env,react) sobre el bloque JSX extraido del template ->
  `createElement` plano. Uso desechable de Babel como herramienta de migracion, no
  dependencia del pipeline.
- **Fase 2 — Integracion:** el JS transpilado reemplaza el `<script type="text/babel">`
  por `<script>` normal; se retira el `<script src>` de Babel; `33_generar_html.R` pierde
  toda referencia a Babel. Placeholders del pipeline siguen en 5 (los 2 de React/ReactDOM;
  Babel sale sin placeholder porque era CDN, no inyectado).
- **Fase 3 — Verificacion:** `regenerar_motor()` + auditoria + spot-check + apertura del
  HTML sin red (DevTools Network offline) + revision visual del titular. Solo entonces
  borrar el snapshot de respaldo.

### Evaluacion de deuda tecnica
- Deuda real viva: Babel en CDN (unica dependencia de red tras el v18). Via decidida: C3.
- Resuelto en v18: dos de tres dependencias de red (React, ReactDOM).
- Sin deuda nueva introducida: el cambio fue aditivo (2 placeholders, 2 .js versionados).

### Auditoria de cierre (politica 5.6)
- #2 pipeline corre de cero sin intervencion manual: Si (`run_all()`/`regenerar_motor()`
  limpio; paso 33 OK; los 2 .js viven versionados en `10_utils/`, sin paso manual de build).
- #5 cada transformacion critica tiene check: Si (validacion de los 5 placeholders en el
  generador; validaciones de los bloques de datos intactas).
- #6 outputs reproducibles e idempotentes: Si (cifras identicas; auditoria F1-F4 +
  spot-check 6/6 + 1 ausencia; F4 sin drift).
- #7 decisiones metodologicas como constantes nombradas: Si (sin numeros magicos nuevos;
  los placeholders son constantes de plantilla).
- #8 nombres sin tildes, ñ ni espacios: Si.
- "No" pendiente: la consolidacion del backlog 83-85 y el commit del snapshot de cierre
  quedan como pendientes administrativos de la sesion 19.

### Ruta sugerida para la sesion 19
1. Administrativo de apertura: commitear el snapshot de cierre `094448`
   (`50_documentacion/estructura/`) y consolidar el backlog 83-85 sobre 85 (A22).
   Complejidad baja. Exito: ambas tablas suman 85, cuadran con el cronologico; arbol limpio.
2. Eliminar Babel via C3 (sesion dedicada): ejecutar el plan de 4 fases. Snapshot previo
   OBLIGATORIO. Complejidad alta. Exito: motor sin ninguna dependencia de red; render
   identico (visual del titular); auditoria + spot-check en verde.
**Diferir:** nada salvo lo anterior. C3 es de alto riesgo y merece su sesion dedicada con
el snapshot ya tomado.

## 12. Instrucciones especificas para la proxima sesion
- 🔒 Agregacion de categoria = conteo de EE. La matricula es contexto, nunca pondera.
- 🔒 Basica y media nunca se mezclan. Categoria 2016-2019; media sin 2016. Matricula
  2016-2025. NO mezclar.
- 🔒 `docs/index.html` versionado para Pages; `40_salidas/motor_categoria.html`
  regenerable. No editar `docs/` ni `40_salidas/` a mano.
- 🔒 El motor conserva 5 placeholders al guardar el template (`__D3_INLINE__`,
  `__PAKO_INLINE__`, `__JSON_DATA__`, `__REACT_INLINE__`, `__REACTDOM_INLINE__`); NUNCA
  dejarlos inyectados al guardar. El grep de control verifica PRESENCIA de los 5.
- 🔒 React 18.3.1 y ReactDOM 18.3.1 viven en `10_utils/` (versionados, inline en el motor).
  Babel 7.29.0 sigue en CDN (unpkg, SRI). NO arrastrar el SRI a un inline (A30).
- 🔒 `matricula_rbd_grado.parquet` es INSUMO (`20_insumos/`, read-only). El desacople del
  v17 dejo de leerlo, NO lo borro (A28).
- 🔒 El JSON NO embebe `matricula_grado` ni `grado_labels` (desde v17).
- 🔒 La ficha usa el layout D2 del v16 (filas a todo el ancho, sin grado, encabezado de
  columnas). Estado aprobado; partir de el para futura UI.
- 🔒 `run_all()` corre el pipeline completo; atajo `regenerar_motor()` (= only=33). La
  AUDITORIA de cifras NO es parte del pipeline (D23); se corre a mano desde `tests/`.
- 🔒 El backlog vive in extenso en `backlog_consolidado.md` (sin rango); fuente de verdad
  del conteo. PENDIENTE: consolidar 83-85 sobre 85.
- ⚠️ Babel se elimina via C3, NO via C1 (Node en el build) ni C2 (paso manual). C3 exige
  SNAPSHOT PREVIO en `_archivo/` y sesion dedicada (D29). NO arrancar C3 con la sesion ya
  cargada de otro trabajo (higiene de sesion).
- ⚠️ DT-template esta CERRADA-SUPERADA (v17): NO reabrir como particion de archivos.
- ⚠️ Cinco proyectos en paralelo: NO asumir sesion de R ni working directory entre
  comandos. Verificar `here::here()` antes de `source()`; confirmar el `.Rproj` abierto.
  `regenerar_motor()` requiere `source(here::here("00_run_all.R"))` primero.
- ⚠️ NO confundir el escaner (filesystem) con el indice de Git. `tests/reportes/` y
  `.DS_Store` se LISTAN pero NO se trackean (A20). Verificar con `git status`/`git ls-files`.
- ⚠️ Snapshot de cierre `094448` SIN commitear al cierre del chat: commitearlo al abrir la
  s19 antes de cualquier otro trabajo.
- ✅ ANTES de re-ejecutar un pendiente heredado: verificar su estado real en disco (A27).
- ✅ ANTES de abrir una deuda de alto riesgo: releer el codigo; el diagnostico puede haber
  caducado (A29). Y reencuadrar el problema antes de elegir entre variantes (A31).
- ✅ ANTES de modificar el template: leer el archivo completo (regla permanente).
- ✅ TODO comando de terminal con ruta completa desde la raiz; para git,
  `git -C /Users/tomgc/Projects/slep_categoria_desempeno ...`. No asumir directorio ni `cd`.
- ✅ Tras tocar el motor: `regenerar_motor()` + `source(here::here("tests","auditar_cifras.R"))`
  + `source(here::here("tests","spot_check_publicado.R"))`. Esperar F1-F4 OK + 6/6 + 1 ausencia.

## 13. Fragmentos de codigo de referencia
[Conservar los del v16/v17 (modo de ausencia del spot-check; `EnseItem` simple; cabecera
documentada del desacople). Anadir el patron de internalizacion de un script de runtime
via placeholder, para que la futura eliminacion de Babel (C3) o cualquier internalizacion
nueva lo reuse:]
```r
# Patron de internalizacion de un script de runtime (s18, React/ReactDOM):
#   1. En el template: reemplazar <script src="...CDN..." integrity=...> por
#      <script>__NOMBRE_INLINE__</script>. El SRI NO se conserva en el inline (A30).
#   2. En el generador: ruta a 10_utils/, validacion de existencia con instruccion
#      curl en el stop, lectura del codigo, el placeholder en el for de validacion
#      y en la inyeccion (sub fixed=TRUE), y liberacion en el rm() final.
#   3. El .js se versiona en 10_utils/ (sin paso manual de build: el pipeline lo
#      inyecta en cada corrida, manteniendo reproducibilidad completa 5.2.2).
react_path    <- here::here("10_utils", "react.production.min.js")
reactdom_path <- here::here("10_utils", "react-dom.production.min.js")
if (!file.exists(react_path)) {
  stop("No existe react.production.min.js: ", react_path,
       "\n  Descargar: curl -fsSL ",
       "https://unpkg.com/react@18.3.1/umd/react.production.min.js -o 10_utils/react.production.min.js")
}
# ... lectura ...
for (ph in c("__D3_INLINE__", "__PAKO_INLINE__", "__JSON_DATA__",
             "__REACT_INLINE__", "__REACTDOM_INLINE__")) {
  if (!grepl(ph, plantilla, fixed = TRUE)) stop("La plantilla no contiene el placeholder ", ph, ".")
}
html <- sub("__REACT_INLINE__",    react_code,    plantilla, fixed = TRUE)
html <- sub("__REACTDOM_INLINE__", reactdom_code, html,      fixed = TRUE)
# ... resto de placeholders ...
```

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 19 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; leelo desde ahi.
> Retomamos slep_categoria_desempeno en sesion 19. La sesion 18 cerro los dos pendientes
> del v17: consolido el backlog 81-82 sobre 82 (administrativo) e internalizo React 18.3.1
> y ReactDOM 18.3.1 como scripts inline (alcance A), dejando Babel 7.29.0 en CDN por su
> peso (~3 MB standalone deshacia la ganancia del v17). El motor subio de 1.72 a 1.82 MB
> con cifras identicas (auditoria F1-F4 OK, spot-check 6/6 + 1 ausencia OK). Babel queda
> como unica dependencia de red. Se reevaluo a fondo como eliminarla y se decidio la via
> C3 (reescribir el JSX a React.createElement plano, usando Babel una vez como herramienta
> de migracion; NO Node en el build, NO paso manual), DIFERIDA a esta sesion por ser
> refactor de alto riesgo que exige snapshot previo. Pendientes administrativos de
> apertura: commitear el snapshot del escaner de cierre (`094448`, quedo sin commitear) y
> consolidar el backlog 83-85 sobre 85. Cuatro commits del v18 pusheados, arbol limpio.
> Adjunto el traspaso v18 y el escaner.

### Documentos para la proxima sesion
1. Protocolo en knowledge base (no se adjuntan): POLITICA_PROYECTO.md,
   SETTINGS_Y_PROMPTS_OPERACIONALES.md.
2. Opcionales segun foco: `33_motor_template.html` + `30_procesamiento/33_generar_html.R`
   (IMPRESCINDIBLES si se ejecuta C3); `backlog_consolidado.md` (para consolidar 83-85);
   `tests/spot_check_publicado.R` + `tests/auditar_cifras.R` (si se re-audita tras tocar
   el motor).
3. Especificos (SI se adjuntan): `traspaso_cierre_v18.md`; `estructura_actual.md` (correr
   el escaner al abrir para reflejar el estado post-commit del snapshot de cierre).

### Nota final obligatoria
El motor (`33_motor_template.html`) sigue en su estado aprobado v16 (ficha D2). Cambio en
v18: React/ReactDOM internalizados (5 placeholders); Babel sigue en CDN. La proxima deuda
real es eliminar Babel via C3 (sesion dedicada, snapshot previo OBLIGATORIO). El backlog
in extenso es la fuente de verdad del conteo (`backlog_consolidado.md`, sin rango) y tiene
PENDIENTE la consolidacion de 83-85 sobre 85, mas el commit del snapshot de cierre
`094448`. Si algun archivo listado cambio entre sesiones, adjuntar la version mas
actualizada al abrir y avisarlo en el mensaje de apertura.
