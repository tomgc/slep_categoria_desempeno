# Traspaso de cierre v19 — slep_categoria_desempeno

## 1. Identificacion
- **Proyecto:** slep_categoria_desempeno
- **Version:** v19
- **Fecha:** 2026-06-18
- **Sesion:** 19 — actualizacion de la suite de documentacion para envio a revision
  externa (contrapartes), reflejando el estado REAL en GitHub Pages tras el v18; mas
  cierre de los dos administrativos heredados del v18 (commit del snapshot de cierre y
  consolidacion del backlog 83-85 sobre 85). Sesion de naturaleza mixta:
  documentacion de proyecto (suite) + trabajo de protocolo (regla de terminologia en
  la knowledge base). Cero cambios de pipeline, calculo o motor.
- **Entorno:** R 4.5.x en Positron, macOS aarch64. Modelo: Claude Opus 4.8. Trabajo
  documental pesado delegado a Claude Code (navego el repo, verifico el stack real,
  aplico el delta sobre el `documentar.R` vivo). Cinco proyectos en paralelo; no asumir
  sesion de R ni working directory entre comandos.
- **Archivos principales modificados:**
  - `documentar.R`: delta del stack de runtime (etapa 5 + pie_extra$arq_tec) y reemplazo
    de terminologia "colegio" -> "establecimiento educacional" en toda la cfg. 39K -> 40.5K.
    Commit `b36b960`.
  - `50_documentacion/suite/` (4 HTML regenerados): stack de runtime en los dos documentos
    tecnicos; terminologia institucional en los cuatro. Commit `b36b960`.
  - `README.md`: linea de runtime actualizada (4 .js inline + Babel CDN). 4.18K -> 4.27K.
    Commit `b36b960`.
  - `50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md`: nueva regla 4.6.3.6
    (terminologia institucional del SLEP), rotulo v2 -> v3, changelog. 24.7K -> 31.9K.
    Commit `5691608`. Tambien reemplazado en la knowledge base del Project.
  - `50_documentacion/activa/backlog_consolidado.md`: consolidacion 83-85 sobre 85
    (administrativo heredado del v18). 54.3K -> 59.2K. Commit `616c749`.
  - `50_documentacion/traspasos/traspaso_cierre_v18.md`: commiteado (estaba sin versionar).
    Commit `0421f50`.
  - `50_documentacion/estructura/`: snapshot del escaner de cierre del v18 (`094448`)
    commiteado; el de cierre de esta sesion (`095106`) queda PENDIENTE (ver seccion 6).
    Commit `b80c5d9`.

## 2. Resumen ejecutivo
La sesion 19 abrio como CONTINUATION del v18 con dos administrativos pendientes (commit del
snapshot de cierre `094448` y consolidacion del backlog 83-85) y C3 diferido como unica deuda
tecnica viva. Antes de abordarlos, el titular pidio actualizar la suite de documentacion para
enviar el proyecto a revision externa, reflejando lo que esta funcionando en GitHub Pages. Se
ejecuto el protocolo 4.6 en modo BIBLIOTECA (actualizar el `documentar.R` existente con un
delta acotado, sin reescribir la prosa de comunidad): se reflejo el stack de runtime real
(React 18.3.1, ReactDOM 18.3.1, D3 v7, pako inline en `10_utils/`; Babel 7.29.0 unica
dependencia de red, CDN) en los dos documentos tecnicos, mas una nota de que la eliminacion de
Babel via C3 esta planificada. El trabajo se delego a Claude Code, que verifico el stack contra
el filesystem (sin discrepancias), aplico el delta y regenero los 4 HTML con verificar=TRUE sin
abortar. En paralelo, el titular pidio reemplazar "colegio" por "establecimiento educacional"
como termino generico; se aplico a toda la cfg (40 sustituciones) y se agrego la regla 4.6.3.6
al protocolo de la knowledge base. Tras revisar los HTML, se detecto que el reemplazo estricto
quedo repetitivo en prosa de comunidad; se decidio el criterio de "primera mencion completa por
parrafo, luego abreviado" y se afino SOLO la regla del protocolo (no se regenero la suite: el
ajuste de fluidez se aplicara en la proxima generacion, para no derrochar tokens). Cerrados los
dos administrativos del v18 (snapshot `094448` commiteado; backlog consolidado a 85, verificado
en tres vistas) y empaquetado todo en commits atomicos tematicos (6 commits, 3 push). Se resolvio
ademas el misterio del commit `87c9a7c` que Claude Code reporto como propio: es la entrada 80 del
backlog (v16, DT-spot-check-ausencia), una alucinacion de Claude Code sobre trabajo historico; el
arbol nunca se toco. La suite quedo publicada y enviable. La unica deuda tecnica viva sigue siendo
C3 (eliminar Babel), reservada para sesion dedicada con snapshot previo.

## 3. Estado al cierre

### Que funciona (ultima ejecucion exitosa)
- **SUITE DE DOCUMENTACION ACTUALIZADA Y PUBLICADA:** los 4 HTML de `50_documentacion/suite/`
  reflejan el stack de runtime real (tecnicos) y la terminologia institucional (los cuatro).
  Regenerados con `generar_suite(verificar = TRUE)` sin abortar. Enviables a contrapartes.
- **MOTOR INTACTO:** no se toco el pipeline, el calculo ni el motor. `docs/index.html` y
  `40_salidas/motor_categoria.html` siguen en 1.82 MB (estado v18). Cifras del v18 vigentes;
  no se re-audito porque no se toco el motor (correcto: la auditoria se corre tras tocar el motor).
- **BACKLOG EN 85:** `backlog_consolidado.md` consolidado a 85, cuadrado en las tres vistas
  (cronologico termina en 85, tabla tematica suma 85, tabla por sesion suma 85). Commit `616c749`.
- **KNOWLEDGE BASE AL DIA:** `SETTINGS_Y_PROMPTS_OPERACIONALES.md` v3 con la regla 4.6.3.6,
  reemplazado tanto en el repo como en la knowledge base del Project.
- **ARBOL DE GIT LIMPIO Y PUSHEADO:** 6 commits de la sesion en origin/main
  (`bdb9e3c..616c749`): `0421f50` (traspaso v18), `b36b960` (suite + documentar.R + README),
  `5691608` (regla 4.6.3.6 / SETTINGS v3), `b80c5d9` (snapshot escaner v18), `616c749`
  (backlog 83-85). Mas `bdb9e3c` (snapshot de apertura, ya estaba).

### Que no funciona / pendiente
- No hay nada roto. Pendientes vivos: C3 (eliminar Babel, DIFERIDO a sesion dedicada, ver
  seccion 11); consolidacion del cambio 86 (la suite de esta sesion) al backlog y commit del
  snapshot de cierre `095106` (administrativos de la s20, ver seccion 6). DT-template:
  CERRADA-SUPERADA. `documentar.R`: vigilancia pasiva.

### Delta respecto a v18
v18 internalizo React/ReactDOM inline (alcance A) y dejo Babel en CDN. v19 NO toca pipeline,
calculo ni motor: actualiza la suite de documentacion para que refleje ese stack y la
terminologia institucional, agrega la regla 4.6.3.6 al protocolo, y cierra los dos
administrativos que el v18 dejo pendientes (snapshot `094448` + backlog 83-85). El backlog
sube de 82 a 85 (consolidacion de los cambios del v18). La suite queda enviable a externos.

## 4. Registro detallado de cambios

### Cambio 86 — Actualizacion de la suite de documentacion (stack runtime + terminologia)
- **Categoria:** Documentacion de proyecto.
- **PENDIENTE DE CONSOLIDACION AL BACKLOG:** este cambio (86) NO esta aun en
  `backlog_consolidado.md` (que quedo en 85). Es el primer administrativo de la s20. Se
  describe aqui para que la consolidacion sea mecanica.
- **Que (`documentar.R` + 4 HTML + `README.md`):** (a) en los dos documentos tecnicos se
  reflejo el stack de runtime real del motor: React 18.3.1, ReactDOM 18.3.1, D3 v7 y pako
  inline (versionados en `10_utils/`), con Babel 7.29.0 como unica dependencia de red (CDN
  unpkg, SRI). El delta entro en la etapa 5 del diagrama (arquitectura tecnica), en
  `prosa$doc_pipeline` (manual tecnico) y en `pie_extra$arq_tec` (nota de que C3 esta
  planificada). (b) Reemplazo de "colegio"/"colegios" por "establecimiento educacional"/
  "establecimientos educacionales" como sustantivo generico en TODA la cfg (40 sustituciones:
  glosario_doc 3, entidades_gen 2, estaciones 9, garantias 5, notas 4, faq 6, prosa 4,
  textos 7); excepciones respetadas (voz coloquial del lector en faq; "Localiza tu colegio"
  como nombre propio de la Agencia; notacion tecnica "EE"/"n_EE" intacta). (c) README: linea
  de runtime actualizada al stack real.
- **Por que (C.11):** el titular envia el proyecto a revision externa y la doc debe reflejar
  lo que esta funcionando en Pages (el stack cambio en el v18; el README estaba desactualizado
  mencionando solo d3/pako). La terminologia institucional ("establecimiento educacional") es
  el termino generico del SLEP, ahora regla 4.6.3.6.
- **Como se verifico (B.4):** Claude Code verifico el stack contra el filesystem (4 .js en
  `10_utils/`, versiones correctas; 5 placeholders en el template; unico `<script src>` es
  Babel) sin discrepancias; `generar_suite(verificar = TRUE)` no aborto; 0 ocurrencias de
  "colegio" generico en los 4 HTML (solo "Localiza tu colegio"); stack presente en arquitectura
  tecnica Y en el manual, ausente en los generales; cobertura 2016-2019 intacta. Commit `b36b960`.

### Cambio administrativo A — Commit del traspaso v18 (estaba sin versionar)
- **Categoria:** Migracion y publicacion / DevOps (no cuenta como cambio del backlog: es
  higiene de repo, no solicitud distinguible del titular).
- **Que:** `traspaso_cierre_v18.md` aparecia como untracked. El v18 afirmaba "traspaso
  pusheado" pero el log no lo respaldaba (el ultimo `docs` era el snapshot). Se commiteo.
- **Como se verifico:** `git log` muestra `0421f50` con el traspaso; arbol limpio.

### Cambio administrativo B — Consolidacion del backlog 83-85 sobre 85
- **Categoria:** Documentacion de proyecto (es el c.84-analogo de la s19: el ACTO de
  consolidacion. NO se cuenta como cambio nuevo del backlog porque el v18 ya lo dejo como
  pendiente administrativo explicito; las entradas 83-85 son contenido del v18).
- **Que (`backlog_consolidado.md`):** se agregaron las entradas 83 (internalizar React/ReactDOM,
  "Pipeline R"), 84 (consolidacion backlog 81-82, "Documentacion de proyecto") y 85 (snapshots
  escaner, "Migracion y publicacion / DevOps") al detalle cronologico (nueva subseccion "Sesion
  18"); la fila s18 (N=3) a la tabla por sesion; las tres categorias recalculadas en la tabla
  tematica (Pipeline R 5->6, Documentacion de proyecto 9->10, DevOps 4->5); la nota de conteo
  sobre 85; y el bloque "Delta v18 (82->85)".
- **Como se verifico (B.4, A22):** suma de la tabla tematica = 85 (verificado con aritmetica);
  suma de la tabla por sesion = 85; ultima entrada del cronologico = 85. Verificado contra el
  cronologico, no contra la tabla heredada. Commit `616c749`.

### Cambio administrativo C — Regla 4.6.3.6 terminologia institucional (SETTINGS v3)
- **Categoria:** Trabajo de protocolo (BIBLIOTECA; NO cuenta como cambio del backlog del
  proyecto: es instrumental de `herramientas_dev` / knowledge base, no del proyecto).
- **Que (`SETTINGS_Y_PROMPTS_OPERACIONALES.md`):** nueva regla 4.6.3.6 que fija
  "establecimiento educacional" como termino generico, completo en la primera mencion de cada
  parrafo y abreviado a "establecimiento(s)" en las repeticiones; prohibe "EE" en texto visible
  y "colegio" como sustantivo generico; excepciones (voz del lector en FAQ, ejemplos del
  universo, nombres propios externos). Rotulo v2 -> v3, changelog actualizado.
- **Como se verifico:** grep de la regla y del rotulo v3 en el archivo de la knowledge base;
  reemplazado en repo (commit `5691608`) y en la knowledge base del Project.

### Cambio administrativo D — Commit del snapshot del escaner de cierre del v18
- **Categoria:** Migracion y publicacion / DevOps.
- **Que (`50_documentacion/estructura/`):** se commiteo el snapshot `094448` (cierre del v18)
  que habia quedado sin versionar, mas la poda de retencion=2 (Git lo registro como rename).
- **Como se verifico:** `ls` mostro carpeta coherente (2 timestamps + aliases); commit `b80c5d9`
  atomico.

## 5. Backlog acumulativo
[El backlog vive in extenso en `50_documentacion/activa/backlog_consolidado.md` (sin rango),
fuente de verdad del conteo. Total cronologico al cierre del v18: 85 (consolidado en esta sesion).
- Esta sesion (19) genero UN cambio nuevo de proyecto: 86 (actualizacion de la suite de
  documentacion). NO esta aun en el backlog (ver seccion 4, cambio 86, y seccion 6).
- La regla 4.6.3.6 es trabajo de protocolo (BIBLIOTECA), NO cuenta como cambio del backlog.
- Los administrativos (commit traspaso v18, consolidacion 83-85, commit snapshot, push) son
  acciones de implementacion, no cambios.
- PENDIENTE DE CONSOLIDACION (primer administrativo de la s20): agregar 86 al
  `backlog_consolidado.md` (detalle cronologico nueva subseccion "Sesion 19", fila s19 con N=1
  en la tabla por sesion, "Documentacion de proyecto" 10->11 en la tabla tematica, ambas tablas
  recalculadas sobre 86, bloque "Delta v19 (85->86)"). Recalcular porcentajes sobre 86.]

## 6. Bugs de la sesion
No hubo bugs de codigo. Tres notas de higiene/diagnostico:
1. **Alucinacion de Claude Code (commit `87c9a7c`):** en su primer reporte de la sesion, Claude
   Code describio haber EJECUTADO las cuatro ediciones del spot-check de ausencia simetrica y
   haber producido el commit `87c9a7c`. Verificacion contra `git show 87c9a7c`: ese commit es del
   16-jun (sesion 16), la entrada 80 del backlog (DT-spot-check-ausencia), ya existente. El arbol
   nunca se toco hoy (`spot_check_publicado.R` no aparecio en ningun `git status`). REGLA
   APRENDIDA (ver A32): verificar los reportes de Claude Code contra `git log`/`git show` cuando
   un commit citado no calce con el traspaso; puede narrar trabajo historico como propio.
2. **Traspaso v18 sin commitear:** el v18 afirmaba "traspaso pusheado" pero estaba untracked. Se
   commiteo en esta sesion (`0421f50`). REGLA: verificar el estado real con `git status`, no
   confiar en la afirmacion del traspaso anterior (ya conocida, reforzada).
3. **Snapshot de cierre `095106` sin commitear:** el escaner se corrio al cierre (18:18) y genero
   `095106`, posterior al ultimo commit de snapshot (`b80c5d9`, que versiono `094448`). Igual que
   en el v18, queda sin versionar: primer administrativo de la s20. NO es bug, es el orden natural.

## 7. Aprendizajes y restricciones descubiertas

### A32 (NUEVO) — Verificar los reportes de Claude Code contra el log de Git
- **Regla:** Claude Code puede reportar como trabajo propio de la sesion un commit que en
  realidad ya existia en la historia (alucinacion sobre trabajo historico). Cuando un hash citado
  no calce con el estado esperado del traspaso, verificar con `git show <hash> --stat` (fecha,
  archivos) y `git log --all | grep <hash>` ANTES de planificar sobre ese supuesto. El arbol de
  trabajo (`git status`) es la verdad: si el archivo no aparece modificado, no se toco.
- **Principio:** B.1 (sin supuestos implicitos) + la regla permanente de verificar estado real en
  disco/Git, no en afirmaciones heredadas. Contexto: c. seccion 6, nota 1; el `87c9a7c` se
  rastreo a la sesion 16.

### A33 (NUEVO) — El reemplazo terminologico estricto requiere criterio de fluidez
- **Regla:** un reemplazo de termino generico (aqui "colegio" -> "establecimiento educacional")
  aplicado de forma estricta y literal recarga la prosa de comunidad cuando el termino se repite
  varias veces por parrafo. El criterio correcto es "completo en la primera mencion de cada
  parrafo, abreviado en las repeticiones" (regla 4.6.3.6). No es reemplazo mecanico: respeta voz
  del lector, nombres propios y notacion tecnica.
- **Principio:** B.2 (simplicidad / legibilidad) + la regla de no fabricar prosa robotica.
  Contexto: revision de los HTML; se afino la regla del protocolo, no se regenero la suite (el
  ajuste se aplicara en la proxima generacion para no derrochar tokens).

## 8. Decisiones de diseno

### D30 (NUEVA) — Actualizar el documentar.R existente, no regenerar la cfg desde cero
- **Decision:** ante la actualizacion de la suite, modificar el `documentar.R` vivo con un delta
  acotado, preservando toda la prosa de comunidad ya afinada, en vez de reescribir la cfg desde
  cero.
- **Alternativas descartadas:** regenerar la cfg desde cero (descartada: se perderia el tono ya
  ajustado de la prosa de comunidad, las zonas `# REVISAR (voz)`).
- **Justificacion:** el delta del v18 sobre la suite es chico y localizado (stack de runtime +
  terminologia); la metodologia del proyecto no cambio. Reescribir seria derroche y riesgo.

### D31 (NUEVA) — Terminologia estricta con criterio de primera mencion (regla 4.6.3.6)
- **Decision:** "establecimiento educacional" como termino generico institucional, desplegado
  completo en la primera mencion de cada parrafo y abreviado a "establecimiento(s)" despues.
- **Alternativas descartadas:** (a) estricto literal siempre (descartada: recarga la prosa); (b)
  mixto pleno-en-tecnicos / abreviado-en-generales (descartada: el titular pidio estricto en
  todo); (c) dejar como estaba (descartada: "colegio" no es el termino institucional).
- **Justificacion:** mantiene el registro institucional sin sacrificar fluidez. La regla queda en
  el protocolo (4.6.3.6) para todos los proyectos futuros.

### D32 (NUEVA) — No regenerar la suite por el ajuste de fluidez; aplicarlo en la proxima generacion
- **Decision:** tras afinar el criterio de primera mencion, NO se regenero la suite ya publicada
  (que quedo con el reemplazo estricto, correcto pero repetitivo). El ajuste se aplicara la
  proxima vez que se genere documentacion.
- **Justificacion:** la suite actual es enviable (el termino es correcto en todas partes, solo
  algo repetitivo); regenerar los 4 HTML por un ajuste de fluidez es derroche de tokens. La regla
  4.6.3.6 ya garantiza que la proxima generacion salga afinada.

### D28, D29 (v18), D26-D27 (v17) y previas — vigentes sin cambios. D29 (eliminar Babel via C3)
sigue siendo la deuda tecnica viva.

## 9. Constantes y parametros vigentes
[Sin cambios respecto al v18. No se toco pipeline, calculo ni motor.
- Motor en 1.82 MB; 5 placeholders; React 18.3.1, ReactDOM 18.3.1, D3 v7, pako inline; Babel
  7.29.0 CDN. Constantes de calculo del v18 sin cambios.
- `SPOT_CELDAS` (6) + `SPOT_AUSENCIAS` (1: media/2016) sin cambios.
- Nuevo en protocolo (no en el motor): regla 4.6.3.6, terminologia institucional.]

## 10. Arquitectura de archivos
Referencia al escaner de cierre: snapshot `20260618_181821` (`095106`; 21 carpetas, 120
archivos). Cambios estructurales de la sesion: `documentar.R` 40.5K (era 39K);
`backlog_consolidado.md` 59.2K (era 54.3K); `SETTINGS_Y_PROMPTS_OPERACIONALES.md` 31.9K (era
24.7K); README 4.27K (era 4.18K); 4 HTML de la suite ligeramente mayores (terminologia +
stack); `traspaso_cierre_v18.md` ahora versionado. Sin cambios de carpetas. Commits en
origin/main (`bdb9e3c..616c749`): `0421f50`, `b36b960`, `5691608`, `b80c5d9`, `616c749`.
PENDIENTE: commit del snapshot de cierre `095106` (s20).

## 11. Pendientes y ruta sugerida

### Inventario de pendientes
- **Eliminar Babel via C3 (DIFERIDO, alto riesgo, sesion dedicada).**
  Tipo: deuda tecnica / cumplimiento de politica 5.5. Unica dependencia de red del motor tras el
  v18. Via decidida: C3 (D29): reescribir el JSX (~1400 lineas) a `React.createElement` plano,
  usando Babel UNA vez como herramienta de migracion y retirandolo del proyecto. NO C1 (Node en
  el build) ni C2 (paso manual). Complejidad: ALTA. Precaucion: refactor sobre UI aprobada (D2);
  exige SNAPSHOT en `_archivo/YYYYMMDD/` ANTES de empezar (politica 3) y verificacion visual del
  titular al final. Plan en 4 fases (heredado del v18, abajo). Insumos: `33_motor_template.html`
  + `33_generar_html.R`. Criterio de exito: motor renderiza identico (revision visual) +
  auditoria F1-F4 + spot-check 6/6+1 + apertura sin red (DevTools Network offline) sin Babel.
  Decision abierta: si el `createElement` resulta ilegible, evaluar `htm` (~1 KB, JSX-like sin
  transpilacion, inlineable) viendo el output real.
- **Consolidar el cambio 86 al backlog + commit del snapshot de cierre `095106` (NUEVO,
  administrativo).** Tipo: documentacion + DevOps. Agregar 86 al `backlog_consolidado.md`
  (subseccion "Sesion 19", fila s19 N=1, "Documentacion de proyecto" 10->11, ambas tablas sobre
  86, A22) y commitear `50_documentacion/estructura/` con el snapshot `095106`. Complejidad: baja.
- **DT-template (CERRADA-SUPERADA, v17).** No es deuda activa.
- **`documentar.R` (vigilancia pasiva).** Si reaparece `deleted`, `git checkout -- documentar.R`.
- **Observaciones de `suitedoc` (para `herramientas_dev`, NO este repo).** Sin cambios.

### Pendientes del v18 cerrados en v19
- Commit del snapshot de cierre `094448`: CERRADO (commit `b80c5d9`).
- Consolidacion del backlog 83-85: CERRADO (commit `616c749`, backlog en 85).
- Commit del traspaso v18 (descubierto sin versionar): CERRADO (`0421f50`).

### Plan C3 para la sesion dedicada (heredado del v18, no ejecutado)
- **Fase 0 — Preparacion:** snapshot del template aprobado en `_archivo/YYYYMMDD/`; criterio de
  exito definido (render identico + auditoria + spot-check + sin red, sin Babel).
- **Fase 1 — Transpilacion mecanica unica:** en la maquina del titular, una sola vez,
  `npx @babel/cli` (presets env,react) sobre el bloque JSX extraido del template ->
  `createElement` plano. Uso desechable de Babel como herramienta de migracion. (TAREA MANUAL DEL
  TITULAR; el asistente no ejecuta Node.)
- **Fase 2 — Integracion:** el JS transpilado reemplaza el `<script type="text/babel">` por
  `<script>` normal; se retira el `<script src>` de Babel; `33_generar_html.R` pierde toda
  referencia a Babel. Placeholders del pipeline siguen en 5.
- **Fase 3 — Verificacion:** `regenerar_motor()` + auditoria + spot-check + apertura del HTML sin
  red (DevTools Network offline) + revision visual del titular. Solo entonces borrar el snapshot.

### Evaluacion de deuda tecnica
- Deuda real viva: Babel en CDN (unica dependencia de red). Via decidida: C3.
- Sin deuda nueva introducida en esta sesion: el trabajo fue documental y de protocolo.

### Auditoria de cierre (politica 5.6)
- #2 pipeline corre de cero sin intervencion manual: Si (no se toco; el v18 lo dejo en verde).
- #5 cada transformacion critica tiene check: Si (sin cambios de pipeline; la suite se verifico
  con `generar_suite(verificar=TRUE)`).
- #6 outputs reproducibles e idempotentes: Si (no se toco el motor; cifras del v18 vigentes).
- #7 decisiones metodologicas como constantes nombradas: Si (sin cambios).
- #8 nombres sin tildes, ñ ni espacios: Si.
- "No" pendiente: la consolidacion del cambio 86 y el commit del snapshot `095106` quedan como
  administrativos de la s20.

### Ruta sugerida para la sesion 20
1. Administrativo de apertura: consolidar el cambio 86 al backlog (sobre 86) y commitear el
   snapshot de cierre `095106`. Complejidad baja. Exito: ambas tablas suman 86, cuadran con el
   cronologico; arbol limpio.
2. Eliminar Babel via C3 (sesion dedicada): ejecutar el plan de 4 fases. Snapshot previo
   OBLIGATORIO. Complejidad alta. Exito: motor sin ninguna dependencia de red; render identico;
   auditoria + spot-check en verde; apertura offline sin Babel.
**Diferir:** nada salvo lo anterior. C3 es de alto riesgo y merece su sesion dedicada; no
encadenarla con el administrativo si la sesion se carga.

## 12. Instrucciones especificas para la proxima sesion
- 🔒 Agregacion de categoria = conteo de establecimientos educacionales. La matricula es
  contexto, nunca pondera. (En notacion tecnica de formulas se conserva "EE"/"n_EE".)
- 🔒 Basica y media nunca se mezclan. Categoria 2016-2019; media sin 2016. NO mezclar.
- 🔒 `docs/index.html` versionado para Pages; `40_salidas/motor_categoria.html` regenerable. No
  editar a mano.
- 🔒 El motor conserva 5 placeholders (`__D3_INLINE__`, `__PAKO_INLINE__`, `__JSON_DATA__`,
  `__REACT_INLINE__`, `__REACTDOM_INLINE__`); nunca dejarlos inyectados al guardar.
- 🔒 React 18.3.1 y ReactDOM 18.3.1 inline en `10_utils/`. Babel 7.29.0 en CDN (unpkg, SRI). NO
  arrastrar SRI a un inline (A30).
- 🔒 El backlog vive in extenso en `backlog_consolidado.md` (sin rango); fuente de verdad del
  conteo. Esta en 85. PENDIENTE: consolidar el cambio 86 sobre 86.
- 🔒 Terminologia: "establecimiento educacional" como termino generico (regla 4.6.3.6), completo
  en la primera mencion por parrafo, abreviado despues. Nunca "EE" en texto visible ni "colegio"
  como generico. La suite actual quedo con el reemplazo estricto (repetitivo pero correcto); el
  criterio de primera mencion se aplica en la PROXIMA generacion de documentacion (D32).
- ⚠️ Babel se elimina via C3, NO via C1/C2. C3 exige SNAPSHOT PREVIO en `_archivo/` y sesion
  dedicada (D29). NO arrancar C3 con la sesion ya cargada de otro trabajo (higiene).
- ⚠️ Snapshot de cierre `095106` SIN commitear: commitearlo al abrir la s20 antes de otro trabajo.
- ⚠️ Verificar reportes de Claude Code contra `git log`/`git show` cuando un hash no calce con el
  traspaso (A32). El arbol (`git status`) es la verdad.
- ⚠️ Cinco proyectos en paralelo: NO asumir sesion de R ni working directory. `regenerar_motor()`
  requiere `source(here::here("00_run_all.R"))` primero.
- ✅ ANTES de re-ejecutar un pendiente heredado: verificar su estado real en disco/Git (A27, A32).
- ✅ ANTES de tocar el documentar.R o el template: leer el archivo completo (regla permanente).
- ✅ TODO comando de terminal con ruta completa desde la raiz; para git,
  `git -C /Users/tomgc/Projects/slep_categoria_desempeno ...`. No asumir directorio ni `cd`.
- ✅ Generar los 4 HTML es tarea del titular (`source("documentar.R")` desde su maquina); el
  asistente entrega el `documentar.R` y la instruccion de una linea.

## 13. Fragmentos de codigo de referencia
[Conservar los del v16/v17/v18 (modo de ausencia del spot-check; `EnseItem` simple; cabecera del
desacople; patron de internalizacion de script de runtime via placeholder, util para C3). Anadir
el patron de actualizacion acotada de la suite (delta sobre el documentar.R vivo):]
```r
# Patron de actualizacion de la suite (s19, delta acotado):
#   1. NO reescribir la cfg desde cero: preservar la prosa de comunidad afinada (D30).
#   2. Verificar el stack/datos REALES contra el filesystem antes de documentarlos
#      (no inventar metodologia, regla 4.6.3.3): que .js viven en 10_utils/, que
#      placeholders tiene el template, cual es el unico <script src>.
#   3. Confinar el delta tecnico a los documentos tecnicos (cfg$etapas alimenta
#      arq_tec; prosa$doc_pipeline alimenta el manual; pie_extra$arq_tec solo el pie
#      tecnico). Los generales (comunidad) no llevan stack.
#   4. Regenerar con verificar = TRUE (aborta si hay residuo del ejemplo de fabrica).
#   5. NO commitear hasta revision visual del titular; commits atomicos tematicos.
suitedoc::generar_suite(cfg, salida_dir = here::here("50_documentacion", "suite"),
                        copiar_tema = TRUE, verificar = TRUE, verbose = TRUE)
```

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 20 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; leelo desde ahi. Retomamos
> slep_categoria_desempeno en sesion 20. La sesion 19 actualizo la suite de documentacion para
> envio a revision externa (stack de runtime real en los tecnicos + terminologia institucional
> "establecimiento educacional" en los cuatro; README actualizado), agrego la regla 4.6.3.6 al
> protocolo (terminologia, SETTINGS v3, ya en la knowledge base), y cerro los dos administrativos
> heredados del v18 (commit del snapshot `094448` + consolidacion del backlog 83-85 sobre 85). Se
> resolvio que el commit `87c9a7c` que Claude Code reporto como propio era trabajo del v16
> (alucinacion; arbol intacto). Seis commits pusheados, arbol limpio. Pendientes administrativos
> de apertura: consolidar el cambio 86 (la suite del v19) al backlog sobre 86, y commitear el
> snapshot de cierre `095106` (quedo sin commitear). Deuda tecnica viva: eliminar Babel via C3
> (sesion dedicada, snapshot previo OBLIGATORIO). Adjunto el traspaso v19 y el escaner.

### Documentos para la proxima sesion
1. Protocolo en knowledge base (no se adjuntan): POLITICA_PROYECTO.md,
   SETTINGS_Y_PROMPTS_OPERACIONALES.md.
2. Opcionales segun foco: `33_motor_template.html` + `30_procesamiento/33_generar_html.R`
   (IMPRESCINDIBLES si se ejecuta C3); `backlog_consolidado.md` (para consolidar el cambio 86);
   `tests/spot_check_publicado.R` + `tests/auditar_cifras.R` (si se re-audita tras tocar el motor
   en C3).
3. Especificos (SI se adjuntan): `traspaso_cierre_v19.md`; `estructura_actual.md` (correr el
   escaner al abrir para reflejar el estado post-commit del snapshot `095106`).

### Nota final obligatoria
El motor sigue en su estado v18 (React/ReactDOM inline; Babel en CDN). La suite quedo publicada
con el reemplazo terminologico estricto (correcto, algo repetitivo); el criterio de primera
mencion (4.6.3.6) se aplica en la PROXIMA generacion (D32). El backlog esta en 85; PENDIENTE
consolidar el cambio 86 sobre 86, mas el commit del snapshot `095106`. La deuda tecnica real es
C3 (eliminar Babel, sesion dedicada, snapshot previo). Si algun archivo listado cambio entre
sesiones, adjuntar la version mas actualizada al abrir y avisarlo en el mensaje de apertura.
