# Traspaso de cierre v21 — slep_categoria_desempeno

## 1. Identificacion
- **Proyecto:** slep_categoria_desempeno
- **Version:** v21
- **Fecha:** 2026-06-18
- **Sesion:** 21 — DEDICADA a C3: eliminacion de Babel del motor. Se ejecuto el plan de 4 fases
  versionado en la s20 (snapshot Fase 0, transpilacion clasica del JSX a `React.createElement`,
  integracion en template + generador, regeneracion y verificacion), mas el administrativo de
  apertura heredado (commit del snapshot `190922` + traspaso v20 untracked). Resultado: motor 100%
  autocontenido, sin ninguna dependencia de red en runtime. Cifras identicas (auditoria F1-F4 +
  spot-check 6/6+1 en verde). Visual aprobado por el titular (DevTools Network offline, render
  identico, Console sin errores).
- **Entorno:** R 4.5.x en Positron, macOS aarch64. Modelo: Claude Opus 4.8. Trabajo de Git y de
  integracion (edicion de archivos en disco, awk, regeneracion) delegado a Claude Code. Cinco
  proyectos en paralelo; no asumir sesion de R ni working directory entre comandos.
- **Archivos principales modificados:**
  - `30_procesamiento/33_motor_template.html`: eliminado el bloque Babel (comentario L1519-1524 +
    `<script src=...@babel/standalone@7.29.0...>` con integrity/crossorigin L1525-1527); cambiado
    `<script type="text/babel" data-presets="env,react">` por `<script>` normal; cuerpo JSX
    (~1417 lineas) reemplazado por su transpilado clasico (`React.createElement`); comentario del
    bloque React inline reescrito sin nombrar el dominio CDN. 123K -> 121K. Commit `5f53259`
    (+ retoque del comentario en el mismo commit del template).
  - `30_procesamiento/33_generar_html.R`: solo el comentario de cabecera (L26-28) que mencionaba
    "Babel se mantiene en CDN"; el codigo de validacion + 5 inyecciones NO cambio. Commit `3303b31`.
  - `docs/index.html`: motor regenerado sin Babel (1.81M). Commit `d065dc1`.
  - `40_salidas/motor_categoria.html`: regenerado (1.81M, gitignored, no versionado).
  - `50_documentacion/estructura/` + `traspaso_cierre_v20.md`: administrativo de apertura. Commit
    `7cd7049`.

## 2. Resumen ejecutivo
La sesion 21 abrio como CONTINUATION del v20, DEDICADA a C3, con el plan de 4 fases ya versionado.
Primero se cerro el administrativo heredado: se commiteo el snapshot de cierre `190922` y, al
descubrirse `traspaso_cierre_v20.md` untracked (tercer caso consecutivo del patron A32), se versiono
en el mismo commit (`7cd7049`). Luego se ejecuto C3: Fase 0 (snapshot del template y el generador en
`_archivo/20260618/`, verificado), Fase 1-bis (el asistente extrajo el cuerpo JSX exacto a `app.jsx`,
1417 lineas, L1545-2961 del template), Fase 1 (el titular corrio Babel como herramienta de migracion
desechable). La primera transpilacion salio con runtime AUTOMATICO (`_jsxDEV`), que habria roto el
render (helper no inyectado en el motor inline); se rehizo con `.babelrc` forzando `runtime: "classic"`,
produciendo `app.plain.js` con `React.createElement` puro (195 ocurrencias, 0 `_jsx/_jsxDEV`). Fase 2:
Claude Code reconstruyo el template con awk anclado por contenido (no por numero de linea), elimino el
bloque Babel, cambio el `type`, inyecto el transpilado y reescribio los dos comentarios que mencionaban
Babel/unpkg; actualizo el comentario de cabecera del generador. Fase 3: regeneracion + auditoria F1-F4
(0 discrepancias) + spot-check (6/6 presencia + 1 ausencia certificada media/2016) + greps de Babel y
de red en `docs/index.html` = 0. El titular aprobo el visual (Network offline: `0/2 requests`, recursos
2328 kB todos inline; UI completa; Console sin rojos). Tres commits atomicos + push (`292d4ea..d065dc1`).
La unica deuda tecnica viva del proyecto (Babel en CDN) queda ELIMINADA. Nuevo pendiente diferido:
actualizar la suite de documentacion (hoy dice "C3 planificada").

## 3. Estado al cierre

### Que funciona (ultima ejecucion exitosa)
- **MOTOR SIN BABEL, AUTOCONTENIDO:** `docs/index.html` (1.81M) y `40_salidas/motor_categoria.html`
  (1.81M) regenerados sin Babel. Cero dependencias de red en runtime. Verificado por el titular con
  DevTools Network offline: render identico, `0/2 requests` (documento + favicon), 2328 kB de recursos
  todos servidos inline, Console sin errores. Commit `d065dc1`.
- **CIFRAS INTACTAS:** auditoria F1-F4 en verde (0 discrepancias, "TODAS LAS FAMILIAS EN VERDE");
  spot-check 6/6 presencia + 1 ausencia certificada (media/2016). Reporte
  `tests/reportes/20260618_202358_auditoria_cifras.md`. El refactor no movio ningun numero.
- **GREPS LIMPIOS:** `grep -ic babel docs/index.html` = 0; `grep -icE "unpkg|jsdelivr|https?://...\.js"
  docs/index.html` = 0 (tras reescribir el comentario que nombraba unpkg).
- **ARBOL DE GIT LIMPIO Y PUSHEADO:** 4 commits de la sesion en origin/main (`292d4ea..d065dc1`):
  `7cd7049` (administrativo apertura), `5f53259` (template sin Babel + JSX transpilado), `3303b31`
  (comentario generador), `d065dc1` (motor regenerado). `origin/main` en `d065dc1`.
- **SNAPSHOT FASE 0 INTACTO:** `_archivo/20260618/30_procesamiento/` con el template y el generador
  pre-C3 (126448 B + 21232 B). Es respaldo local (gitignored); no se borra (`_archivo/` es historico).

### Que no funciona / pendiente
- No hay nada roto. C3 cerrado. Pendiente diferido: actualizar la suite de documentacion (hoy
  `pie_extra$arq_tec` dice "C3 planificada" -> debe pasar a "C3 ejecutada / motor sin dependencias de
  red"); va en sesion de documentacion, aplicando el criterio 4.6.3.6 de primera mencion (D32).
- Administrativo de apertura s22: commit del snapshot de cierre `211742` (quedo sin commitear, orden
  natural; el escaner se corre al cierre).

### Delta respecto a v20
v20 preparo C3 (plan versionado) sin ejecutarlo. v21 lo EJECUTA: retira Babel del template, transpila
el JSX a `React.createElement`, regenera el motor y verifica. Cierra ademas el administrativo heredado
(snapshot `190922` + traspaso v20 untracked). El backlog sube de 86 a 87 (entrada C3). El motor pasa
de "una dependencia de red (Babel CDN)" a "cero dependencias de red".

## 4. Registro detallado de cambios

### Cambio 87 — Eliminacion de Babel del motor (C3)
- **Categoria:** Migracion y publicacion / DevOps (cumplimiento de politica 5.5: web estatica sin
  dependencias externas salvo necesidad estricta). Es UNA solicitud distinguible del titular
  (eliminar la unica dependencia de red), implementada en multiples fases tecnicas: cuenta como UN
  cambio del backlog.
- **Que:** se reescribio el cuerpo JSX del motor (~1417 lineas) a `React.createElement` plano usando
  Babel UNA vez como herramienta de migracion desechable (no en build ni en runtime), y se retiro el
  `<script src>` de `@babel/standalone` (unico recurso de red del motor) del template. El generador
  solo cambio un comentario de cabecera; los 5 placeholders y las 5 inyecciones se conservan intactos.
- **Por que (C.11):** Babel en CDN era la unica dependencia de red del motor; un motor de GitHub Pages
  destinado a directivos debe abrir sin red (resiliencia, soberania, velocidad). Politica 5.5.
- **Como se verifico (B.4):** criterio de exito definido ANTES de codificar (Fase 0): render identico
  (revision visual del titular), auditoria F1-F4 en verde, spot-check 6/6+1, apertura sin red sin
  Babel, `grep -i babel docs/index.html` = 0. Los cinco criterios se cumplieron.
- **Anclaje:** el plan en `decisiones/20260618_decision_plan_c3_eliminar_babel.md`. Snapshot Fase 0 en
  `_archivo/20260618/`. Commits `5f53259` (template) + `3303b31` (generador) + `d065dc1` (motor).

### Cambio administrativo — Commit del snapshot `190922` + traspaso v20 untracked
- **Categoria:** Migracion y publicacion / DevOps (higiene de repo). NO cuenta como cambio del backlog.
- **Que:** el snapshot de cierre del v20 (`190922`) quedo sin commitear; al correr el escaner al abrir
  s21 se genero `191615`, y la poda retencion=2 dejo `190922`+`191615`. Ademas `traspaso_cierre_v20.md`
  aparecia untracked (tercer caso del patron A32: v18, v19, v20). Ambos versionados en `7cd7049`.
- **Como se verifico:** `git status` limpio tras el commit.

## 5. Backlog acumulativo
[El backlog vive in extenso en `50_documentacion/activa/backlog_consolidado.md` (sin rango), fuente de
verdad del conteo. Total cronologico al cierre del v21: **87** (era 86 al cierre del v20).
- La sesion 21 genero UN cambio nuevo de proyecto: el 87 (eliminacion de Babel via C3).
- El administrativo de apertura (snapshot + traspaso v20) son acciones de implementacion, no cambios.
- PENDIENTE DE CONSOLIDACION (s22): consolidar la entrada 87 al `backlog_consolidado.md` (agregarla al
  detalle cronologico en nueva subseccion "Sesion 21"; fila s21 N=1 a la tabla por sesion;
  "Migracion y publicacion / DevOps" +1 en la tabla tematica; nota de conteo y % recalculados sobre 87;
  bloque "Delta v20 (86->87)"). Verificar en las TRES vistas (A22): cronologico termina en 87, tabla
  tematica suma 87, tabla por sesion suma 87.]

## 6. Bugs de la sesion
No hubo bugs en el codigo entregado, pero SI un incidente de transpilacion atajado antes de integrar
(habria roto el render en produccion). Y una deteccion correcta ante un dato anomalo del prompt.

1. **Transpilacion con runtime automatico (`_jsxDEV`) — ATAJADO en Fase 1, no llego a integrarse.**
   - **Sintoma observable:** la primera corrida de Babel (`npx babel app.jsx --presets
     @babel/preset-env,@babel/preset-react`) produjo `root.render(/*#__PURE__*/_jsxDEV(App, {}, void 0,
     false))` y 260 ocurrencias de `_jsx/_jsxDEV`, 0 de `React.createElement`.
   - **Causa raiz:** las versiones recientes de `@babel/preset-react` usan por defecto
     `runtime: "automatic"`, que emite llamadas a `_jsxDEV`/`_jsx` esperando un helper inyectado
     (`react/jsx-dev-runtime`). El motor inline NO tiene ese helper: solo expone `React` global. El
     output automatico habria fallado con `_jsxDEV is not defined` al cargar. El runtime que el motor
     ejecutaba en el navegador (Babel con `data-presets="env,react"`) era el CLASICO.
   - **Solucion exacta:** `.babelrc` con `["@babel/preset-react", { "runtime": "classic" }]`. Resultado:
     `React.createElement` puro, 0 `_jsx`. (Un intento intermedio con flags inline `[...]` fallo por
     glob de zsh: `no matches found`; el `.babelrc` ademas evita el quoting fragil de la shell.)
   - **Criterio de verificacion:** `tail` cierra en `React.createElement(App, null)`; `grep -c
     "_jsxDEV\|_jsx("` = 0; `grep -c "React.createElement"` > 0.
   - **REGLA APRENDIDA (A34):** al transpilar JSX para un motor con React inline (sin bundler ni helper
     `jsx-runtime`), forzar SIEMPRE `runtime: "classic"` en preset-react. El automatico exige inyectar
     `react/jsx-runtime`, que reintroduce justo la dependencia que se busca eliminar. El transpilado
     debe coincidir con el runtime que el motor ya ejecutaba (`data-presets="env,react"` = clasico).
   - **Principio:** B.4 (criterio de exito verificable definido antes: "0 `_jsx`"); C.6 (consistencia
     de tipos/contratos: el output debe encajar con el `React` global existente, no con un helper nuevo).
   - **Estado:** resuelto.

2. **Dato anomalo en la instruccion (1736 vs 1462 lineas) — DETENCION correcta.**
   - **Sintoma:** el prompt de integracion declaraba `app.plain.js` = 1736 lineas; el archivo real
     tenia 1462. Claude Code se detuvo (parada dura) y pidio confirmacion en vez de integrar.
   - **Causa raiz:** error del asistente al armar el prompt: cito el `wc -l` del PRIMER transpilado (el
     automatico con `_jsxDEV`, 1736 lineas) en vez del clasico final (1462). El automatico infla por
     los helpers por nodo. La cifra correcta era 1462 (transpilado clasico del cuerpo real de 1417).
   - **REGLA REFORZADA:** detenerse ante cualquier desajuste con el mapa declarado es correcto AUNQUE la
     causa resulte ser el dato del prompt y no el archivo. La deteccion ahorro integrar a ciegas.
   - **Estado:** resuelto (se confirmo 1462 como correcto y se procedio).

## 7. Aprendizajes y restricciones descubiertas
- **A34 (NUEVO) — Runtime clasico obligatorio al transpilar para un motor con React inline.** Ver bug 1.
  Contexto: si se viola, el motor falla con `_jsxDEV is not defined` al cargar. Ejemplo de la sesion: la
  primera corrida automatica. Principio: C.6 (contratos), B.4 (criterio verificable).
- **Anclar la edicion por CONTENIDO, no por numero de linea (reforzado).** Claude Code reconstruyo el
  template con awk anclado a los marcadores de contenido (el comentario "Babel standalone desde CDN", el
  `<script src>`, el `type="text/babel"`, el `root.render`), no a numeros de linea. Esto lo hizo robusto
  ante el desfase de +1 linea (app.plain.js sin newline final) sin romperse. Principio: B.1, B.3.
- **A32 reforzado por TERCERA vez.** El traspaso de cierre queda untracked tras cada cierre (v18, v19,
  v20). El estado real es `git status`, no la afirmacion del traspaso anterior. Considerar versionar el
  traspaso como ultimo paso del cierre, o aceptar que es el primer administrativo de cada apertura.

## 8. Decisiones de diseno

### D34 (NUEVA) — Transpilacion clasica sobre `htm`; `createElement` puro como objetivo literal de C3
- **Decision:** ante la decision abierta heredada (`React.createElement` plano vs `htm`), se resolvio
  por `createElement` puro tras ver el output real: legible y funcional, cero dependencias.
- **Alternativas descartadas:** `htm` (~1 KB, JSX-like sin transpilacion) — descartada porque
  reintroduce una micro-dependencia que C3 busca eliminar, y el `createElement` resulto mantenible.
- **Justificacion:** objetivo literal de C3 = cero dependencias de red en runtime. `createElement` puro
  lo cumple sin matices. `htm` quedaba como plan B solo si la ilegibilidad comprometia mantenimiento;
  no fue el caso.

### D33 (v20), D29 (v18) — CERRADAS por ejecucion. D29 (eliminar Babel via C3) era la deuda viva; v21
la salda. D2 (UI aprobada) se respeto: la compuerta visual del titular fue la condicion de cierre.

## 9. Constantes y parametros vigentes
[Cambios respecto al v20:
- Motor: ahora **4 dependencias inline** (React 18.3.1, ReactDOM 18.3.1, D3 v7, pako) y **CERO recursos
  de red**. Babel ELIMINADO (ya no es `<script src>` ni nada). Antes: Babel 7.29.0 CDN era el unico
  `<script src>`.
- 5 placeholders sin cambios (`__REACT_INLINE__`, `__REACTDOM_INLINE__`, `__D3_INLINE__`,
  `__PAKO_INLINE__`, `__JSON_DATA__`). El generador los valida e inyecta igual (L446-458 sin cambios).
- Motor en 1.81M (era 1.82M; Babel era CDN, no inline, asi que el peso apenas se movio — lo que cambia
  es que ya no sale a la red).
- `SPOT_CELDAS` (6) + `SPOT_AUSENCIAS` (1: media/2016) sin cambios. Constantes de calculo del v18 sin
  cambios.]

## 10. Arquitectura de archivos
Referencia al escaner de cierre: snapshot `20260618_211742` (21 carpetas, 124 archivos). Cambios
estructurales de la sesion: `33_motor_template.html` 121K (era 123K); `33_generar_html.R` 20.8K (era
20.7K); `docs/index.html` y `40_salidas/motor_categoria.html` regenerados (1.81M); nuevo reporte
`tests/reportes/20260618_202358_auditoria_cifras.md`. Sin cambios de carpetas. Commits en origin/main
(`292d4ea..d065dc1`): `7cd7049`, `5f53259`, `3303b31`, `d065dc1`. PENDIENTE: commit del snapshot de
cierre `211742` (s22).

## 11. Pendientes y ruta sugerida

### Inventario de pendientes
- **Consolidar la entrada 87 al backlog (NUEVO, administrativo s22).** Tipo: documentacion. Agregar el
  cambio 87 (C3) al `backlog_consolidado.md` en las tres vistas; recalcular % sobre 87; delta v20->v21.
  Complejidad baja. Verificar con A22 (contra el cronologico, no la tabla heredada).
- **Commit del snapshot de cierre `211742` (NUEVO, administrativo s22).** Tipo: DevOps. Complejidad
  baja. Primer paso al abrir la s22.
- **Actualizar la suite de documentacion tras C3 (NUEVO, diferido).** Tipo: documentacion. Hoy
  `pie_extra$arq_tec` dice "C3 planificada"; tras C3 pasa a "C3 ejecutada / motor sin dependencias de
  red". Sesion de documentacion (BIBLIOTECA / protocolo 4.6), no de proyecto. Aplicar 4.6.3.6 (primera
  mencion completa de "establecimiento educacional" por parrafo, D32) en esa regeneracion. Verificar la
  version de `suitedoc` instalada antes (campos `pie_extra`, `rotulos`, etc.). Insumos: el escaner
  actual, README, traspaso v21, decisiones (incluida la de C3).
- **`documentar.R` (vigilancia pasiva).** Si reaparece `deleted`, `git checkout -- documentar.R`.

### Pendientes del v20 cerrados en v21
- C3 (eliminar Babel): CERRADO (commits `5f53259`/`3303b31`/`d065dc1`, motor sin red, verificado).
- Commit del snapshot de cierre `190922`: CERRADO (`7cd7049`).
- Versionado del traspaso v20 (descubierto untracked): CERRADO (`7cd7049`).

### Evaluacion de deuda tecnica
- **Deuda real viva: NINGUNA.** Babel era la unica dependencia de red; eliminada. El motor es ahora
  HTML 100% autocontenido. Por primera vez desde la migracion a Pages no hay deuda tecnica abierta.
- Sin deuda nueva introducida: el transpilado es JS estandar (`React.createElement`), el generador no
  cambio su logica, los placeholders se conservan.
- Nota de mantenimiento: el cuerpo del motor es ahora `createElement` plano (menos legible que JSX para
  editar a mano). Las ediciones futuras del motor deberian hacerse sobre una fuente JSX y retranspilar
  con runtime clasico, NO editar el `createElement` a mano. (Evaluar si conviene versionar un `app.jsx`
  fuente en el repo para futuras ediciones; decision abierta para s22+.)

### Auditoria de cierre (politica 5.6)
- #2 pipeline corre de cero sin intervencion manual: Si (`regenerar_motor()` regenero el motor end-to-end).
- #5 cada transformacion critica tiene check: Si (auditoria F1-F4 + spot-check en verde).
- #6 outputs reproducibles e idempotentes: Si (motor regenerado; cifras identicas al v18).
- #7 decisiones metodologicas como constantes nombradas: Si (sin cambios de calculo).
- #8 nombres sin tildes, ñ ni espacios: Si.
- "No" pendiente: el commit del snapshot de cierre `211742` queda como administrativo de la s22.

### Ruta sugerida para la sesion 22
1. Administrativos de apertura: (a) commit del snapshot de cierre `211742`; (b) consolidar la entrada
   87 al backlog en las tres vistas. Complejidad baja ambos.
2. A decidir por el titular el foco real de la s22. Opciones naturales: (a) actualizar la suite de
   documentacion post-C3 (sesion BIBLIOTECA, protocolo 4.6); (b) evaluar versionar un `app.jsx` fuente
   del motor para futuras ediciones (decision de mantenimiento abierta en seccion 11); (c) retomar otro
   de los proyectos en paralelo (`slep_idps` sigue bloqueado por el ponderador; `slep_simce_adecuado`
   cerrado en s18).
   **Recomendacion:** (a) la suite, porque es el unico pendiente que C3 dejo abierto y cierra el ciclo
   documental del motor sin Babel; las demas son exploraciones sin urgencia.
**Diferir:** versionar `app.jsx` fuente (decision de mantenimiento, no urgente); otros proyectos
(sesiones dedicadas propias).

## 12. Instrucciones especificas para la proxima sesion
- 🔒 Agregacion de categoria = conteo de establecimientos educacionales. La matricula es contexto, nunca
  pondera. (En notacion tecnica de formulas se conserva "EE"/"n_EE".)
- 🔒 Basica y media nunca se mezclan. Categoria 2016-2019; media sin 2016. NO mezclar.
- 🔒 `docs/index.html` versionado para Pages; `40_salidas/motor_categoria.html` regenerable. No editar a
  mano. El motor se edita por el TEMPLATE + regeneracion, nunca el HTML final.
- 🔒 El motor conserva 5 placeholders; nunca dejarlos inyectados al guardar el template.
- 🔒 React 18.3.1 y ReactDOM 18.3.1 inline en `10_utils/`. **Babel ELIMINADO (C3, s21): el motor ya no
  tiene NINGUNA dependencia de red en runtime.** No reintroducir CDNs.
- 🔒 El cuerpo del motor es ahora `React.createElement` plano (transpilado clasico). Para editarlo,
  trabajar sobre fuente JSX y retranspilar con `runtime: "classic"`; NO editar el `createElement` a mano
  ni transpilar con runtime automatico (A34).
- 🔒 El backlog vive in extenso en `backlog_consolidado.md` (sin rango); fuente de verdad del conteo.
  Esta en 86 EN EL ARCHIVO; la entrada 87 (C3) esta registrada en este traspaso y PENDIENTE de
  consolidar al archivo en la s22 (subir a 87, cuadrar en las tres vistas).
- 🔒 Terminologia: "establecimiento educacional" como termino generico (regla 4.6.3.6), completo en la
  primera mencion por parrafo, abreviado despues. Nunca "EE" en texto visible ni "colegio" como
  generico. Aplicar el criterio de primera mencion (D32) en la actualizacion de la suite post-C3.
- ⚠️ Snapshot de cierre `211742` SIN commitear: commitearlo al abrir la s22.
- ⚠️ Consolidar la entrada 87 al backlog ANTES de generar la suite post-C3 (la suite lee el backlog).
- ⚠️ Al transpilar cualquier JSX para este motor: `runtime: "classic"` SIEMPRE (A34). El automatico
  emite `_jsxDEV`/`_jsx` que el motor inline no puede resolver.
- ⚠️ Verificar reportes de Claude Code contra `git log`/`git show` cuando un hash no calce (A32). El
  arbol (`git status`) es la verdad.
- ⚠️ Cinco proyectos en paralelo: NO asumir sesion de R ni working directory. `regenerar_motor()`
  requiere `source(here::here("00_run_all.R"))` primero.
- ✅ ANTES de re-ejecutar un pendiente heredado: verificar su estado real en disco/Git (A27, A32).
- ✅ ANTES de tocar el template o el generador: leer el archivo completo (regla permanente).
- ✅ TODO comando de terminal con ruta completa desde la raiz; para git,
  `git -C /Users/tomgc/Projects/slep_categoria_desempeno ...`. No asumir directorio ni `cd`.
- ✅ El snapshot de Fase 0 de C3 (`_archivo/20260618/`) es historico: NO borrarlo.

## 13. Fragmentos de codigo de referencia
[Conservar los del v16-v20. El patron de referencia clave para C3 / futuras ediciones del motor:]
```
# Transpilacion correcta del motor (runtime CLASICO, A34):
#   1. Extraer el cuerpo del <script> de la app a un app.jsx (sin las etiquetas <script>).
#   2. .babelrc en un dir temporal fuera del repo:
#      { "presets": [ "@babel/preset-env", ["@babel/preset-react", { "runtime": "classic" }] ] }
#   3. npx babel app.jsx -o app.plain.js
#   4. Verificar: tail cierra en React.createElement(App, null);
#      grep -c "_jsxDEV\|_jsx(" app.plain.js  == 0   (si > 0: runtime automatico, REHACER)
#      grep -c "React.createElement" app.plain.js  > 0
#   5. Integrar en el template anclando por CONTENIDO (marcadores: comentario del bloque,
#      <script type=...>, root.render), no por numero de linea (robusto ante desfase de newline).
#
# Estado del motor tras C3 (s21):
#   33_motor_template.html: 4 <script> inline (React, ReactDOM, D3, pako) + bloque datos JSON +
#     <script> con el transpilado createElement + montaje. CERO <script src>. 5 placeholders.
#   33_generar_html.R: validacion + 5 sub() de inyeccion SIN cambios; solo el comentario L26-28 cambio.
```

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 22 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; leelo desde ahi. Retomamos
> slep_categoria_desempeno en sesion 22. La sesion 21 ejecuto C3: elimino Babel del motor (JSX
> transpilado a React.createElement con runtime clasico); el motor es ahora HTML 100% autocontenido,
> cero dependencias de red, verificado offline por el titular; auditoria + spot-check en verde. Sin
> deuda tecnica viva. Administrativos de apertura: (1) commit del snapshot de cierre `211742` (quedo
> sin commitear); (2) consolidar la entrada 87 (C3) al backlog en las tres vistas. Pendiente diferido:
> actualizar la suite de documentacion (hoy dice "C3 planificada"). Adjunto el traspaso v21 y el escaner.

### Documentos para la proxima sesion
1. Protocolo en knowledge base (no se adjuntan): POLITICA_PROYECTO.md, SETTINGS_Y_PROMPTS_OPERACIONALES.md.
2. Opcionales segun el foco real de la s22: si el foco es la suite post-C3, el protocolo 4.6 (esta en
   SETTINGS) + `documentar.R` + `decisiones/20260618_decision_plan_c3_eliminar_babel.md`;
   `backlog_consolidado.md` para la consolidacion del 87.
3. Especificos (SI se adjuntan): `traspaso_cierre_v21.md`; `estructura_actual.md` (correr el escaner al
   abrir para reflejar el commit del snapshot `211742`).

### Nota final obligatoria
El motor esta sin Babel (C3 ejecutada): React/ReactDOM/D3/pako inline, cero recursos de red,
`React.createElement` plano. El backlog esta en 86 EN EL ARCHIVO; la entrada 87 (C3) esta en este
traspaso y PENDIENTE de consolidar al `backlog_consolidado.md` en la s22. PENDIENTES administrativos:
commit del snapshot `211742` + consolidacion del 87. Pendiente diferido: suite post-C3. Snapshot de
Fase 0 en `_archivo/20260618/` es historico, no borrar. Si algun archivo listado cambio entre sesiones,
adjuntar la version mas actualizada al abrir y avisarlo en el mensaje de apertura.
