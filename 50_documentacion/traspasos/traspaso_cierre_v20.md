# Traspaso de cierre v20 — slep_categoria_desempeno

## 1. Identificacion
- **Proyecto:** slep_categoria_desempeno
- **Version:** v20
- **Fecha:** 2026-06-18
- **Sesion:** 20 — cierre de los dos administrativos heredados del v19 (consolidacion del
  cambio 86 al backlog sobre 86 + commit del snapshot de cierre del escaner) y preparacion
  de C3 (plan de 4 fases redactado, anclado al codigo real y versionado en decisiones/).
  Cero cambios de pipeline, calculo o motor. C3 NO se ejecuto: se difirio a sesion dedicada
  (s21) por D29 (higiene; no encadenar un refactor de alto riesgo con la sesion cargada).
- **Entorno:** R 4.5.x en Positron, macOS aarch64. Modelo: Claude Opus 4.8. Trabajo de
  Git delegado a Claude Code. Cinco proyectos en paralelo; no asumir sesion de R ni working
  directory entre comandos.
- **Archivos principales modificados:**
  - `50_documentacion/activa/backlog_consolidado.md`: consolidacion del cambio 86 sobre 86
    (subseccion "Sesion 19", fila s19 N=1, "Documentacion de proyecto" 10->11, ambas tablas
    sobre 86, delta v19, % recalculados). 59.2K -> 62.8K. Commit `0e173d5`.
  - `50_documentacion/estructura/`: commit del snapshot de cierre del v19 (`181821`) +
    apertura s20 (`183240`), poda retencion=2 (Git lo registro como rename). Commit `a3d62af`.
  - `50_documentacion/traspasos/traspaso_cierre_v19.md`: versionado (estaba untracked).
    Commit `e46d275`.
  - `50_documentacion/activa/decisiones/20260618_decision_plan_c3_eliminar_babel.md`: NUEVO,
    plan C3 de 4 fases anclado al codigo real. 8.5K. Commit `292d4ea`.

## 2. Resumen ejecutivo
La sesion 20 abrio como CONTINUATION del v19 con dos administrativos heredados (consolidar el
cambio 86 al backlog y commitear el snapshot de cierre `095106`) y C3 como unica deuda tecnica
viva. Se ejecuto la Prioridad 1 (administrativos): se consolido el cambio 86 al
`backlog_consolidado.md` llevandolo a 86, verificado en las tres vistas (cronologico termina en
86, tabla tematica suma 86, tabla por sesion suma 86); se commiteo el snapshot del escaner (que
al correrse al abrir genero `181821` de cierre v19 + `183240` de apertura s20, podando `094448`
y `095106`); y se descubrio el traspaso v19 untracked (mismo patron A32 del v18), que se
versiono. Se verifico ademas que los `.DS_Store` no estan trackeados (observacion de apertura,
cerrada). Resuelto el administrativo, el titular opto por preparar C3 sin ejecutarlo (opcion 2,
respetando D29): se leyeron el template y el generador reales, se mapeo el bloque Babel exacto
(unico `<script src>`, L1525-1527 del template, con SRI) y el bloque JSX (~1418 lineas,
L1544-2962, montaje con `createRoot().render(<App/>)`), y se redacto un plan C3 de 4 fases
anclado a ese estado real, versionado en `decisiones/`. Hallazgo de diseño que ajusta el plan
heredado: retirar Babel es edicion del TEMPLATE, no del generador (Babel nunca fue placeholder;
los 5 placeholders y las 5 inyecciones se conservan; el generador solo cambia un comentario).
Cero cambios de motor. La unica deuda tecnica viva sigue siendo C3, ahora con plan escrito y
listo para sesion dedicada.

## 3. Estado al cierre

### Que funciona (ultima ejecucion exitosa)
- **BACKLOG EN 86:** `backlog_consolidado.md` consolidado a 86, cuadrado en las tres vistas
  (cronologico termina en 86, tabla tematica suma 86, tabla por sesion suma 86). Commit `0e173d5`.
- **MOTOR INTACTO:** no se toco pipeline, calculo ni motor. `docs/index.html` y
  `40_salidas/motor_categoria.html` siguen en 1.82 MB (estado v18). Cifras del v18 vigentes; no
  se re-audito porque no se toco el motor.
- **PLAN C3 VERSIONADO:** `20260618_decision_plan_c3_eliminar_babel.md` en `decisiones/`,
  anclado al codigo real, con Fase 0 (snapshot) lista, criterio de exito definido y delta exacto
  del generador. Commit `292d4ea`.
- **ARBOL DE GIT LIMPIO Y PUSHEADO:** 4 commits de la sesion en origin/main
  (`616c749..292d4ea`): `a3d62af` (snapshot escaner), `0e173d5` (backlog 86), `e46d275`
  (traspaso v19), `292d4ea` (plan C3).

### Que no funciona / pendiente
- No hay nada roto. Pendiente tecnico vivo: C3 (eliminar Babel, DIFERIDO a sesion dedicada s21,
  plan ya escrito; ver seccion 11). Administrativo de apertura s21: commit del snapshot de cierre
  `190922` (quedo sin commitear, orden natural). Pendiente menor diferido: tras C3, actualizar la
  suite de documentacion (hoy `pie_extra$arq_tec` dice "C3 planificada").

### Delta respecto a v19
v19 actualizo la suite de documentacion y dejo el cambio 86 sin consolidar + el snapshot `095106`
sin commitear. v20 NO toca pipeline, calculo ni motor: cierra esos dos administrativos (backlog a
86, snapshot versionado), versiona el traspaso v19 que estaba untracked, y prepara C3 (plan
versionado). El backlog sube de 85 a 86 (consolidacion del cambio del v19).

## 4. Registro detallado de cambios

### Cambio administrativo A — Consolidacion del cambio 86 al backlog sobre 86
- **Categoria:** Documentacion de proyecto (ACTO de consolidacion de la s20; el cambio 86 en si
  es contenido del v19. NO se cuenta como cambio nuevo del backlog: las entradas 81-86 ya estan
  contabilizadas; este es el acto administrativo de absorber la 86 que el v19 dejo pendiente).
- **Que (`backlog_consolidado.md`):** se agrego la entrada 86 (actualizacion de la suite de
  documentacion, "Documentacion de proyecto") al detalle cronologico (nueva subseccion "Sesion
  19"); la fila s19 (N=1) a la tabla por sesion; "Documentacion de proyecto" 10->11 en la tabla
  tematica; la nota de conteo recalculada sobre 86; el bloque "Delta v19 (85->86)"; y el unico %
  que se movio por el recalculo sobre 86 ("Diseño UI — Hoja comparativa" 11%->10%, sin cambio de N).
- **Como se verifico (B.4, A22):** suma de la tabla tematica = 86; suma de la tabla por sesion =
  86; ultima entrada del cronologico = 86; verificado contra el cronologico, no contra la tabla
  heredada. Commit `0e173d5`.

### Cambio administrativo B — Commit del snapshot del escaner (cierre v19 + apertura s20)
- **Categoria:** Migracion y publicacion / DevOps.
- **Que (`50_documentacion/estructura/`):** el escaner corrido al abrir genero `181821` (cierre
  v19) y `183240` (apertura s20); la poda de retencion=2 conservo esos dos timestamps + aliases,
  descartando `094448` y `095106` (Git lo registro como renames). Se commiteo.
- **Como se verifico:** `git status` mostro 6 archivos (renames + aliases modificados);
  commit `a3d62af` atomico. Nota: el mensaje quedo como "snapshot de cierre s19" aunque versiono
  ambos; no se reescribio historia por un matiz de mensaje.

### Cambio administrativo C — Versionado del traspaso v19 (estaba untracked)
- **Categoria:** Migracion y publicacion / DevOps (higiene de repo).
- **Que:** `traspaso_cierre_v19.md` aparecia untracked pese a que el v19 se consideraba cerrado.
  Mismo patron A32 detectado en el v18. Se commiteo. Commit `e46d275`.
- **Como se verifico:** `git status` limpio tras el commit; `git log` muestra el traspaso.

### Cambio administrativo D — Plan C3 redactado y versionado
- **Categoria:** Documentacion de proyecto (artefacto de planificacion tecnica; NO cuenta como
  cambio del backlog: es preparacion de un pendiente, no una solicitud de producto distinguible).
- **Que (`decisiones/20260618_decision_plan_c3_eliminar_babel.md`):** plan de 4 fases para
  eliminar Babel, anclado al codigo real verificado en esta sesion (lectura directa del template
  y el generador). Incluye Fase 0 (snapshot obligatorio + criterio de exito), Fase 1
  (transpilacion manual con Babel, tarea del titular) + Fase 1-bis (el asistente genera el
  `app.jsx` recortado), Fase 2 (integracion: edicion del template + comentario del generador),
  Fase 3 (verificacion: regenerar + auditoria + spot-check + sin red/sin Babel), tabla de riesgos
  y la decision abierta `createElement` vs `htm`. Commit `292d4ea`.
- **Como se verifico:** plan contrastado contra el codigo real (no contra el supuesto del
  traspaso); versionado y pusheado.

## 5. Backlog acumulativo
[El backlog vive in extenso en `50_documentacion/activa/backlog_consolidado.md` (sin rango),
fuente de verdad del conteo. Total cronologico al cierre del v20: 86 (consolidado en esta sesion).
- Esta sesion (20) NO genero cambios nuevos de proyecto: fue administrativa (cierre de los
  pendientes del v19) + preparacion de C3. El cambio 86 es contenido del v19, consolidado aqui.
- El plan C3 es un artefacto de planificacion, NO un cambio de producto: no se contabiliza.
- Los administrativos (consolidacion 86, commit snapshot, versionado traspaso v19, push) son
  acciones de implementacion, no cambios.
- PENDIENTE DE CONSOLIDACION (s21): ninguno por ahora; el backlog queda en 86 y cuadrado. Cuando
  C3 se ejecute, generara una entrada nueva (87) que se consolidara en el cierre de la s21.]

## 6. Bugs de la sesion
No hubo bugs de codigo. Dos notas de higiene:
1. **Traspaso v19 sin commitear:** aparecia untracked pese a considerarse cerrado el v19. Mismo
   patron del v18 (A32). Se versiono (`e46d275`). REGLA (reforzada): el estado real es `git
   status`, no la afirmacion del traspaso anterior.
2. **Snapshot de cierre `190922` sin commitear:** el escaner se corrio al cierre y genero
   `190922`, posterior al ultimo commit de snapshot (`a3d62af`). Igual que en cada cierre, queda
   sin versionar: primer administrativo de la s21. NO es bug, es el orden natural (el chat se
   cierra tras el ultimo escaner).

## 7. Aprendizajes y restricciones descubiertas
Sin aprendizajes nuevos (A32 y A33 del v19 vigentes y aplicados). Una observacion reforzada:
- **Anclar todo plan tecnico al codigo real, no al supuesto del traspaso (B.1).** El plan C3
  heredado del v18 asumia que retirar Babel tocaba el generador; la lectura directa mostro que
  Babel es `src` en el TEMPLATE (nunca fue placeholder) y que el generador casi no cambia. Leer
  antes de planificar evito un plan con el delta puesto en el archivo equivocado.

## 8. Decisiones de diseno

### D33 (NUEVA) — Preparar C3 sin ejecutarlo; diferir a sesion dedicada
- **Decision:** ante la opcion de arrancar C3 en esta sesion o prepararlo para sesion dedicada,
  se redacto y versiono el plan completo SIN ejecutar el refactor, difiriendo la ejecucion a la
  s21 con contexto limpio.
- **Alternativas descartadas:** arrancar C3 aqui (descartada: la sesion ya traia carga del
  administrativo; D29 existe para evitar exactamente eso en un refactor de alto riesgo sobre UI
  aprobada).
- **Justificacion:** el plan versionado no se pierde; abrir en limpio no cuesta trabajo y reduce
  el riesgo de error a mitad de un cambio irreversible. Coherente con D29 (higiene) y politica 3
  (snapshot previo a cambio irreversible).

### D30-D32 (v19), D28-D29 (v18) y previas — vigentes sin cambios. D29 (eliminar Babel via C3)
sigue siendo la deuda tecnica viva; D33 formaliza el diferimiento a sesion dedicada.

## 9. Constantes y parametros vigentes
[Sin cambios respecto al v18/v19. No se toco pipeline, calculo ni motor.
- Motor en 1.82 MB; 5 placeholders (`__D3_INLINE__`, `__PAKO_INLINE__`, `__JSON_DATA__`,
  `__REACT_INLINE__`, `__REACTDOM_INLINE__`); React 18.3.1, ReactDOM 18.3.1, D3 v7, pako inline;
  Babel 7.29.0 CDN (unico `<script src>`, con SRI). Constantes de calculo del v18 sin cambios.
- `SPOT_CELDAS` (6) + `SPOT_AUSENCIAS` (1: media/2016) sin cambios.]

## 10. Arquitectura de archivos
Referencia al escaner de cierre: snapshot `20260618_190922` (`190922`; 21 carpetas, 122
archivos). Cambios estructurales de la sesion: `backlog_consolidado.md` 62.8K (era 59.2K);
nuevo `decisiones/20260618_decision_plan_c3_eliminar_babel.md` (8.5K); `traspaso_cierre_v19.md`
ahora versionado. Sin cambios de carpetas. Commits en origin/main (`616c749..292d4ea`):
`a3d62af`, `0e173d5`, `e46d275`, `292d4ea`. PENDIENTE: commit del snapshot de cierre `190922`
(s21).

## 11. Pendientes y ruta sugerida

### Inventario de pendientes
- **Eliminar Babel via C3 (DIFERIDO, alto riesgo, sesion dedicada s21).**
  Tipo: deuda tecnica / cumplimiento de politica 5.5. Unica dependencia de red del motor. Via
  decidida: C3 (D29): reescribir el JSX (~1418 lineas, bloque `text/babel` L1544-2962 del
  template) a `React.createElement` plano, usando Babel UNA vez como herramienta de migracion y
  retirando su `<script src>` (L1525-1527 del template, unico de red). NO C1 ni C2. Complejidad:
  ALTA. Precaucion: refactor sobre UI aprobada (D2); exige SNAPSHOT en `_archivo/YYYYMMDD/` ANTES
  de empezar (politica 3, Fase 0 del plan) y verificacion visual del titular al final. PLAN
  COMPLETO YA ESCRITO Y VERSIONADO: `decisiones/20260618_decision_plan_c3_eliminar_babel.md`
  (incluye estado real del codigo, 4 fases, criterio de exito, riesgos). Insumos para la s21:
  el plan + `33_motor_template.html` + `33_generar_html.R`. Criterio de exito: motor renderiza
  identico (revision visual) + auditoria F1-F4 + spot-check 6/6+1 + apertura sin red (DevTools
  Network offline) sin Babel; `grep -i babel docs/index.html` = 0. Decision abierta: si el
  `createElement` resulta ilegible, evaluar `htm` (~1 KB, JSX-like sin transpilacion) viendo el
  output real.
- **Commit del snapshot de cierre `190922` (NUEVO, administrativo s21).** Tipo: DevOps.
  Complejidad baja. Primer paso al abrir la s21.
- **Actualizar la suite tras C3 (NUEVO, diferido, depende de C3).** Tipo: documentacion. Hoy
  `pie_extra$arq_tec` dice "C3 planificada"; tras ejecutar C3 pasara a "C3 ejecutada / motor sin
  dependencias de red". No accionable hasta que C3 ocurra. Aplicar el criterio 4.6.3.6 (primera
  mencion completa por parrafo, D32) en esa regeneracion.
- **DT-template (CERRADA-SUPERADA, v17).** No es deuda activa.
- **`documentar.R` (vigilancia pasiva).** Si reaparece `deleted`, `git checkout -- documentar.R`.
- **Observaciones de `suitedoc` (para `herramientas_dev`, NO este repo).** Sin cambios.

### Pendientes del v19 cerrados en v20
- Consolidacion del cambio 86 al backlog: CERRADO (commit `0e173d5`, backlog en 86).
- Commit del snapshot de cierre `095106`: CERRADO (commit `a3d62af`; la poda lo absorbio en
  `181821`/`183240`).
- Versionado del traspaso v19 (descubierto untracked): CERRADO (`e46d275`).

### Evaluacion de deuda tecnica
- Deuda real viva: Babel en CDN (unica dependencia de red). Via decidida: C3, plan escrito.
- Sin deuda nueva introducida en esta sesion: el trabajo fue administrativo y de planificacion.

### Auditoria de cierre (politica 5.6)
- #2 pipeline corre de cero sin intervencion manual: Si (no se toco; verde desde v18).
- #5 cada transformacion critica tiene check: Si (sin cambios de pipeline).
- #6 outputs reproducibles e idempotentes: Si (no se toco el motor; cifras del v18 vigentes).
- #7 decisiones metodologicas como constantes nombradas: Si (sin cambios).
- #8 nombres sin tildes, ñ ni espacios: Si.
- "No" pendiente: el commit del snapshot de cierre `190922` queda como administrativo de la s21.

### Ruta sugerida para la sesion 21 (DEDICADA a C3)
1. Administrativo de apertura: commit del snapshot de cierre `190922`. Complejidad baja.
2. Ejecutar C3 segun el plan versionado: Fase 0 (snapshot obligatorio del template + generador en
   `_archivo/YYYYMMDD/`) -> Fase 1-bis (el asistente genera `app.jsx`) -> Fase 1 (titular corre
   Babel, devuelve `app.plain.js`) -> Fase 2 (integracion: template sin Babel + JSX transpilado;
   comentario del generador) -> Fase 3 (regenerar + auditoria + spot-check + sin red/sin Babel +
   revision visual). Complejidad ALTA. Snapshot previo OBLIGATORIO. Exito: motor sin ninguna
   dependencia de red; render identico; auditoria + spot-check en verde; apertura offline sin Babel.
**Diferir:** la actualizacion de la suite (depende de que C3 termine; va en sesion de
documentacion posterior).

## 12. Instrucciones especificas para la proxima sesion
- 🔒 Agregacion de categoria = conteo de establecimientos educacionales. La matricula es contexto,
  nunca pondera. (En notacion tecnica de formulas se conserva "EE"/"n_EE".)
- 🔒 Basica y media nunca se mezclan. Categoria 2016-2019; media sin 2016. NO mezclar.
- 🔒 `docs/index.html` versionado para Pages; `40_salidas/motor_categoria.html` regenerable. No
  editar a mano.
- 🔒 El motor conserva 5 placeholders; nunca dejarlos inyectados al guardar.
- 🔒 React 18.3.1 y ReactDOM 18.3.1 inline en `10_utils/`. Babel 7.29.0 en CDN (unpkg, SRI, unico
  `<script src>` del template, L1525-1527). NO arrastrar SRI a un inline (A30).
- 🔒 El backlog vive in extenso en `backlog_consolidado.md` (sin rango); fuente de verdad del
  conteo. Esta en 86, cuadrado en las tres vistas.
- 🔒 Terminologia: "establecimiento educacional" como termino generico (regla 4.6.3.6), completo
  en la primera mencion por parrafo, abreviado despues. Nunca "EE" en texto visible ni "colegio"
  como generico. La suite actual quedo con el reemplazo estricto; el criterio de primera mencion
  se aplica en la PROXIMA generacion (D32), incluida la actualizacion post-C3.
- ⚠️ Babel se elimina via C3, NO via C1/C2. C3 exige SNAPSHOT PREVIO en `_archivo/` y sesion
  dedicada (D29/D33). El plan completo esta en
  `decisiones/20260618_decision_plan_c3_eliminar_babel.md`. C3 toca el TEMPLATE (no el generador,
  salvo un comentario); Babel nunca fue placeholder.
- ⚠️ Snapshot de cierre `190922` SIN commitear: commitearlo al abrir la s21 antes de C3.
- ⚠️ Verificar reportes de Claude Code contra `git log`/`git show` cuando un hash no calce con el
  traspaso (A32). El arbol (`git status`) es la verdad.
- ⚠️ Cinco proyectos en paralelo: NO asumir sesion de R ni working directory. `regenerar_motor()`
  requiere `source(here::here("00_run_all.R"))` primero.
- ✅ ANTES de re-ejecutar un pendiente heredado: verificar su estado real en disco/Git (A27, A32).
- ✅ ANTES de tocar el template o el generador: leer el archivo completo (regla permanente).
- ✅ TODO comando de terminal con ruta completa desde la raiz; para git,
  `git -C /Users/tomgc/Projects/slep_categoria_desempeno ...`. No asumir directorio ni `cd`.
- ✅ La Fase 1 de C3 (correr Babel) es tarea manual del titular; el asistente entrega `app.jsx` y
  recibe `app.plain.js`, no ejecuta Node.

## 13. Fragmentos de codigo de referencia
[Conservar los del v16/v17/v18/v19 (modo de ausencia del spot-check; `EnseItem` simple; cabecera
del desacople; patron de internalizacion via placeholder; patron de actualizacion acotada de la
suite). El patron de referencia clave para la s21 es el mapa real del template para C3:]
```
# Mapa del template para C3 (verificado por lectura directa, s20):
#   33_motor_template.html (2963 lineas):
#     L1516-1517: <script>__REACT_INLINE__</script> + __REACTDOM_INLINE__  (inline, conservar)
#     L1525-1527: <script src="...@babel/standalone@7.29.0..."> + SRI      (UNICO src; RETIRAR)
#     L1530: __D3_INLINE__   L1533: __PAKO_INLINE__   L1536-1541: __JSON_DATA__  (conservar)
#     L1544: <script type="text/babel" data-presets="env,react">           (-> <script> normal)
#     L1545-2959: cuerpo JSX (~1418 lineas)                                 (-> transpilado plano)
#     L2960-2961: ReactDOM.createRoot(...).render(<App/>)                   (-> createElement(App))
#     L2962: </script>
#   33_generar_html.R: 5 placeholders (L446-451 validacion, L454-458 inyeccion) SE CONSERVAN;
#     Babel NO es placeholder. Solo cambia el comentario de cabecera L26-28.
```

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 21 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; leelo desde ahi. Retomamos
> slep_categoria_desempeno en sesion 21, DEDICADA a C3 (eliminar Babel). La sesion 20 cerro los
> dos administrativos heredados del v19 (backlog consolidado a 86 cuadrado en tres vistas, snapshot
> del escaner y traspaso v19 versionados) y redacto + versiono el plan C3 de 4 fases en
> decisiones/, anclado al codigo real. Unica deuda viva: C3. Snapshot previo OBLIGATORIO (D29/D33).
> Administrativo de apertura: commit del snapshot de cierre `190922` (quedo sin commitear). Adjunto
> el traspaso v20, el escaner, el plan C3, el template y el generador.

### Documentos para la proxima sesion
1. Protocolo en knowledge base (no se adjuntan): POLITICA_PROYECTO.md,
   SETTINGS_Y_PROMPTS_OPERACIONALES.md.
2. Opcionales segun foco (IMPRESCINDIBLES para C3): el plan
   `decisiones/20260618_decision_plan_c3_eliminar_babel.md`;
   `30_procesamiento/33_motor_template.html`; `30_procesamiento/33_generar_html.R`;
   `tests/auditar_cifras.R` + `tests/spot_check_publicado.R` (para la verificacion de Fase 3).
3. Especificos (SI se adjuntan): `traspaso_cierre_v20.md`; `estructura_actual.md` (correr el
   escaner al abrir para reflejar el commit del snapshot `190922`).

### Nota final obligatoria
El motor sigue en su estado v18 (React/ReactDOM inline; Babel en CDN, unico `<script src>`). El
backlog esta en 86, cuadrado. PENDIENTE administrativo: commit del snapshot de cierre `190922`.
La deuda tecnica real es C3 (eliminar Babel), con plan completo ya versionado en decisiones/; la
s21 es su sesion dedicada. Tras C3 quedara pendiente actualizar la suite (hoy dice "C3
planificada"). Si algun archivo listado cambio entre sesiones, adjuntar la version mas actualizada
al abrir y avisarlo en el mensaje de apertura.
