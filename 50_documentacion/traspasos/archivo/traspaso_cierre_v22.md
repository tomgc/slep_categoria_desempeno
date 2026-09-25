# Traspaso de cierre v22 — slep_categoria_desempeno

## 1. Identificacion
- **Proyecto:** slep_categoria_desempeno
- **Version:** v22
- **Fecha:** 2026-06-18
- **Sesion:** 22 — administrativos de apertura heredados del v21, sin cambios de proyecto.
  Se cerraron los dos administrativos (commit del snapshot del escaner + consolidacion de la
  entrada 87 al backlog en las tres vistas), se saneo un error preexistente de la tabla tematica
  (6 celdas de % con denominador antiguo, A22) en commit aparte, y se versiono el traspaso v21
  untracked (A32, 4o caso). Cuatro commits, push en fast-forward. Sin tocar pipeline, calculo ni
  motor. El backlog se mantiene en 87 (la s22 no genera cambios contabilizables).
- **Entorno:** R 4.5.x en Positron, macOS aarch64. Modelo: Claude Opus 4.8. Trabajo de Git
  delegado a Claude Code. Cinco proyectos en paralelo; no asumir sesion de R ni working directory
  entre comandos.
- **Archivos principales modificados:**
  - `50_documentacion/estructura/`: versionados los snapshots `211742` (cierre s21) y `215605`
    (apertura s22, rescan) + aliases `estructura_actual.*` actualizados a `215605`; poda de
    retencion=2 elimino `190922` y `191615`. Commit `ce048c7`.
  - `50_documentacion/activa/backlog_consolidado.md`: (a) saneamiento de 6 celdas de % de la tabla
    tematica a round(N/86), error arrastrado desde v18 (denominador 82), commit `d44c96d`;
    (b) consolidacion de la entrada 87 (C3) en las tres vistas (cronologico Sesion 21/c.87, tabla
    tematica Migracion 5->6 6%->7%, tabla por sesion s20 N=0 + s21 N=1 total->87, nota de conteo y
    delta v21), commit `6c3796e`.
  - `50_documentacion/traspasos/traspaso_cierre_v21.md`: versionado (estaba untracked, A32).
    Commit `7c957d8`.

## 2. Resumen ejecutivo
La sesion 22 abrio como CONTINUATION del v21, dedicada a cerrar los dos administrativos heredados.
El escaner de apertura genero un snapshot nuevo (`215605`) posterior al de cierre de la s21
(`211742`); ambos se versionaron junto a la poda de retencion=2 (`ce048c7`). Al consolidar la
entrada 87 al backlog se detecto un error preexistente: 6 celdas de % de la tabla tematica
arrastraban el denominador 82 desde el v18 (la nota de conteo se habia actualizado a 86 pero las
celdas no, patron A22). Se decidio separar el saneamiento (commit `d44c96d`, % a round(N/86) sin
tocar N) de la consolidacion de la entrada 87 (commit `6c3796e`), respetando atomicidad: corregir
un error historico es un cambio conceptualmente distinto de agregar la entrada 87. Tras el
saneamiento, al pasar 86->87 solo "Migracion y publicacion / DevOps" cambio de entero (6%->7%),
por lo que el texto de la consolidacion quedo correcto sin reescritura. Las tres vistas dan 87. El
traspaso v21 se versiono como cuarto caso del patron A32, y se decidio elevar A32 a regla de
cierre (A35). Cuatro commits en fast-forward sobre `origin/main` (ahora en `7c957d8`). El backlog
se mantiene en 87: la s22 no genero cambios de proyecto contabilizables.

## 3. Estado al cierre

### Que funciona (ultima ejecucion exitosa)
- **MOTOR SIN BABEL, AUTOCONTENIDO (sin cambios desde v21):** `docs/index.html` (1.81M) y
  `40_salidas/motor_categoria.html` (1.81M) sin Babel, cero dependencias de red. No se toco en la
  s22. `origin/main` con C3 en `d065dc1` (base compartida, confirmado por `merge-base`).
- **BACKLOG EN 87, CUADRADO EN LAS TRES VISTAS:** `backlog_consolidado.md` con la entrada 87 (C3)
  consolidada. Cronologico cierra en c.87 (sin Sesion 20 ni c.88); tabla tematica suma 87 con
  todos los % en round(N/87); tabla por sesion suma 87 (s20 N=0, s21 N=1) con Total=87. Verificado
  (B.7, A22). Commits `d44c96d` (saneamiento) + `6c3796e` (entrada 87).
- **TABLA TEMATICA SANEADA:** las 6 celdas de % que arrastraban denominador 82 corregidas a
  round(N/86) en `d44c96d`, y luego coherentes con round(N/87) tras la entrada 87. La tabla y la
  nota de conteo ahora cuadran entre si.
- **SNAPSHOTS DEL ESCANER VERSIONADOS:** `211742` (cierre s21) y `215605` (apertura s22) en Git;
  aliases a `215605`; `190922` y `191615` podados (retencion 2). Commit `ce048c7`.
- **ARBOL LIMPIO Y SINCRONIZADO:** 4 commits de la s22 en `origin/main`
  (`ce048c7`, `d44c96d`, `6c3796e`, `7c957d8`). `git status` limpio, sin divergencia.

### Que no funciona / pendiente
- No hay nada roto. Sin deuda tecnica viva. Pendiente diferido (sin cambios desde v21): actualizar
  la suite de documentacion post-C3 (hoy `pie_extra$arq_tec` dice "C3 planificada").
- Administrativo de apertura s23: consolidar la fila s22 (N=0) a la tabla por sesion del backlog
  (igual que la s21 consolido la s20). El backlog se mantiene en 87; la s22 no aporta entradas
  cronologicas, solo la fila N=0 por completitud del registro de sesiones.
- Administrativo de apertura s23: commit del snapshot de cierre de la s22 (lo genera el escaner al
  cierre; queda sin commitear por orden natural).

### Delta respecto a v21
v21 ejecuto C3. v22 NO toca pipeline, calculo ni motor: cierra los dos administrativos heredados
(snapshot versionado, entrada 87 consolidada), sanea un error preexistente de la tabla tematica
(A22) y versiona el traspaso v21 (A32). El backlog permanece en 87 (s22 sin cambios de proyecto).

## 4. Registro detallado de cambios
Ningun cambio de proyecto contabilizable en la s22. Todo lo ejecutado es administrativo o
correccion de error preexistente (no cuenta como cambio del backlog segun la nota metodologica).

### Administrativo A — Commit de snapshots del escaner + poda
- **Categoria:** Migracion y publicacion / DevOps (higiene de repo). NO cuenta como cambio.
- **Que:** versionados `211742` (cierre s21) y `215605` (rescan de apertura s22) + aliases a
  `215605`; poda de retencion=2 elimino `190922` y `191615`. El `215605` es el escaner de apertura
  de esta sesion (coincide con la fecha de `estructura_actual.md`, 21:56:05), no accidental.
- **Como se verifico (A20):** `git ls-files 50_documentacion/estructura/` confirma `211742`,
  `215605` y los dos aliases versionados; `190922`/`191615` fuera. Commit `ce048c7`.

### Administrativo B1 — Saneamiento de la tabla tematica (A22)
- **Categoria:** Documentacion de proyecto (correccion de error preexistente). NO cuenta como cambio.
- **Que:** 6 celdas de % de la tabla tematica corregidas a round(N/86) (16->15, 15->14, 15->14,
  8->7, 3->2, 3->2), sin tocar ningun N. Error arrastrado desde el v18: al recalcular el
  denominador a 82->86 se actualizo la nota de conteo pero no las celdas de la tabla.
- **Como se verifico (A22):** tabla sigue sumando 86; todos los % = round(N/86). Commit `d44c96d`.

### Administrativo B2 — Consolidacion de la entrada 87 al backlog
- **Categoria:** Documentacion de proyecto (ACTO de consolidacion de la s22; el cambio 87 es
  contenido del v21). NO cuenta como cambio nuevo.
- **Que:** agregada la entrada 87 (C3) en las tres vistas: subseccion "Sesion 21" en el
  cronologico (c.87); fila Migracion 5->6 (6%->7%) en la tematica; filas s20 (N=0) y s21 (N=1) +
  Total 86->87 en la tabla por sesion; nota de conteo recalculada sobre 87; bloque "Delta v21
  (86->87)".
- **Como se verifico (B.7, A22):** cronologico cierra en c.87 sin Sesion 20 ni c.88; tematica suma
  87 con 0 celdas mal redondeadas; por sesion suma 87 con Total=87. Commit `6c3796e`.

### Administrativo C — Versionado del traspaso v21 untracked (A32, 4o caso)
- **Categoria:** Migracion y publicacion / DevOps (higiene de repo). NO cuenta como cambio.
- **Que:** `traspaso_cierre_v21.md` aparecia untracked (4o caso consecutivo: v18, v19, v20, v21).
  Versionado en commit atomico aparte. Commit `7c957d8`.

## 5. Backlog acumulativo
[El backlog vive in extenso en `50_documentacion/activa/backlog_consolidado.md` (sin rango), fuente
de verdad del conteo. Total cronologico al cierre del v22: **87** (sin cambios respecto al cierre
del v21; la entrada 87 quedo consolidada al archivo en esta sesion).
- La sesion 22 NO genero cambios de proyecto: todos los commits son administrativos (snapshots,
  traspaso v21) o correccion de error preexistente (saneamiento de % de la tabla tematica).
- PENDIENTE DE CONSOLIDACION (s23): agregar la fila s22 (N=0, "Administrativos de apertura +
  saneamiento A22") a la tabla por sesion del backlog, recalcular ninguna entrada (el total sigue
  en 87, N=0 no suma). Verificar en las tres vistas (A22): cronologico termina en 87, tabla
  tematica suma 87, tabla por sesion suma 87.]

## 6. Bugs de la sesion
No hubo bugs en codigo. Si dos detenciones correctas de Claude Code que evitaron registros falsos:

1. **Estado del escaner distinto del anticipado por la instruccion — DETENCION correcta.**
   - **Sintoma:** la instruccion anticipaba `211742` como unico snapshot sin commitear y
     `191615`+`211742` como sobrevivientes de la poda; en disco habia ademas `215605` (mas nuevo),
     los aliases apuntaban a `215605` y la poda habia borrado `190922`+`191615`.
   - **Causa raiz:** la instruccion se redacto asumiendo que `211742` seguia siendo el snapshot
     vivo, sin anticipar que el escaner de APERTURA de la s22 generaria `215605` y avanzaria el
     estado antes del commit. El `215605` es legitimo (rescan de apertura).
   - **Resolucion:** versionar el estado real (ambos snapshots + poda real) con mensaje corregido
     que distingue cierre s21 / apertura s22. El mensaje original habria dejado un registro falso.
   - **REGLA REFORZADA:** el escaner de apertura mueve el estado de `estructura/` antes del primer
     commit administrativo; al commitear snapshots, leer el disco real, no la instruccion. El arbol
     es la verdad (A20/A32).
   - **Estado:** resuelto (commit `ce048c7`).

2. **Tabla tematica con % stale (denominador 82) — DETECCION correcta, atajada antes de consolidar.**
   - **Sintoma:** 6 celdas de % de la tabla tematica no cuadraban con round(N/86); la nota de
     conteo decia "15% (13/86)" pero la celda decia 16 (= 13/82).
   - **Causa raiz:** en el v18 (denominador 82->85) y siguientes se actualizo la nota de conteo
     pero no las celdas de % de la tabla. Error de presentacion arrastrado; el cronologico (fuente
     de verdad) siempre estuvo correcto.
   - **Resolucion:** saneamiento previo en commit aparte (`d44c96d`) sobre 86, antes de consolidar
     la 87. Atomicidad: corregir error historico != agregar entrada nueva.
   - **REGLA APRENDIDA (A36):** al recalcular % sobre un nuevo denominador, actualizar las celdas
     de la tabla Y la nota de conteo en la MISMA operacion. Una sin la otra deja A22 latente.
   - **Estado:** resuelto (commit `d44c96d`).

## 7. Aprendizajes y restricciones descubiertas
- **A35 (NUEVO) — Versionar el traspaso como ultimo paso del cierre.** El patron A32 (traspaso
  untracked tras el cierre) se repitio por 4a vez (v18, v19, v20, v21). Decision del titular:
  elevar a regla. El versionado del traspaso es el ULTIMO commit del protocolo de cierre, no el
  primer administrativo de la apertura siguiente. Contexto: si se viola, el traspaso queda
  untracked y se arrastra como administrativo heredado. Principio: B.3, higiene de repo.
- **A36 (NUEVO) — Celdas de % y nota de conteo se actualizan juntas.** Ver bug 2. Al recalcular
  porcentajes sobre un nuevo denominador, las celdas de la tabla tematica y la nota de conteo deben
  moverse en la misma operacion. Contexto: si se viola, queda un descuadre A22 latente entre tabla
  y nota. Principio: A22, C.11 (transparencia).
- **El escaner de apertura mueve `estructura/` antes del primer commit (reforzado).** Ver bug 1.
  No anticipar el estado de `estructura/` desde un traspaso previo; leer el disco. Principio: A20,
  A32.
- **Atomicidad: error preexistente != cambio nuevo (reforzado).** El saneamiento A22 y la
  consolidacion de la 87 fueron a commits separados. Un error historico se corrige en su propio
  commit, no mezclado con la tarea que lo destapo. Principio: B.3, atomicidad.

## 8. Decisiones de diseno

### D35 (NUEVA) — Saneamiento A22 en commit separado de la consolidacion 87
- **Decision:** ante la tabla tematica con 6 % stale descubierta al consolidar la 87, separar el
  saneamiento (commit sobre 86) de la consolidacion (commit sobre 87), en vez de corregir todo en
  un commit.
- **Alternativas descartadas:** (A) cambiar solo Migracion y dejar las 6 stale para despues
  (deja la tabla inconsistente mas tiempo); (B) recalcular todo sobre 87 en un commit (mezcla
  correccion historica con la entrada nueva y obliga a reescribir el delta/commit de la 87).
- **Justificacion:** atomicidad (B.3); el saneamiento queda trazado como lo que es (correccion de
  error de v18), y el texto de la consolidacion 87 (B.6/delta/commit) queda verdadero sin
  reescritura porque parte de una tabla ya correcta sobre 86.

### D36 (NUEVA) — A35 elevada a regla de cierre
- **Decision:** versionar el traspaso como ultimo paso del protocolo de cierre (no como
  administrativo de apertura). Tras 4 repeticiones del patron A32.
- **Implicancia:** el protocolo de cierre de este proyecto incluye un commit final del traspaso.
  La proxima apertura ya no deberia encontrar el traspaso untracked.

## 9. Constantes y parametros vigentes
[Sin cambios respecto al v21. No se toco pipeline, calculo ni motor.
- Motor: 4 dependencias inline (React 18.3.1, ReactDOM 18.3.1, D3 v7, pako), cero recursos de red.
- 5 placeholders sin cambios. `SPOT_CELDAS` (6) + `SPOT_AUSENCIAS` (1: media/2016) sin cambios.
- Backlog en 87 (era 86 en el archivo al cierre del v20; la entrada 87 se consolido en la s22).]

## 10. Arquitectura de archivos
Referencia al escaner de cierre: snapshot de la s22 (lo genera el escaner al cerrar; pendiente de
commit en la s23). Cambios estructurales de la sesion: `backlog_consolidado.md` (saneamiento +
entrada 87); snapshots `211742`/`215605` versionados, `190922`/`191615` podados; `traspaso_cierre_v21.md`
versionado. Sin cambios de carpetas, pipeline ni motor. Commits en `origin/main`: `ce048c7`,
`d44c96d`, `6c3796e`, `7c957d8`. `origin/main` en `7c957d8`.

## 11. Pendientes y ruta sugerida

### Inventario de pendientes
- **Actualizar la suite de documentacion tras C3 (diferido, sin cambios desde v21).** Tipo:
  documentacion. Hoy `pie_extra$arq_tec` dice "C3 planificada" -> debe pasar a "C3 ejecutada /
  motor sin dependencias de red". Sesion BIBLIOTECA, protocolo 4.6. Aplicar 4.6.3.6 (primera
  mencion completa de "establecimiento educacional" por parrafo, D32). Verificar antes la version
  de `suitedoc` instalada (campos `pie_extra`, `rotulos`). Insumos: escaner actual, README,
  traspaso v22, decisiones (incluida la de C3). Complejidad media. **Foco recomendado para la s23.**
- **Consolidar la fila s22 (N=0) a la tabla por sesion (administrativo s23).** Tipo: documentacion.
  El backlog se mantiene en 87; solo se agrega la fila s22 N=0 por completitud. Complejidad baja.
- **Commit del snapshot de cierre de la s22 (administrativo s23).** Tipo: DevOps. Complejidad baja.
- **Evaluar versionar un `app.jsx` fuente del motor (decision de mantenimiento abierta).** Tras C3
  el cuerpo del motor es `React.createElement` plano; futuras ediciones deberian hacerse sobre
  fuente JSX y retranspilar con runtime clasico (A34). Decision abierta: si conviene versionar un
  `app.jsx` fuente en el repo. No urgente.
- **`documentar.R` (vigilancia pasiva).** Si reaparece `deleted`, `git checkout -- documentar.R`.

### Pendientes del v21 cerrados en v22
- Commit del snapshot de cierre `211742`: CERRADO (`ce048c7`, junto al rescan `215605`).
- Consolidacion de la entrada 87 al backlog: CERRADO (`6c3796e`, tres vistas en 87).
- (Adicional no listado en v21) Saneamiento A22 de la tabla tematica: CERRADO (`d44c96d`).
- (Adicional) Versionado del traspaso v21 untracked: CERRADO (`7c957d8`, A32 4o caso).

### Evaluacion de deuda tecnica
- **Deuda real viva: NINGUNA.** Sin cambios desde v21. El motor es HTML 100% autocontenido.
- Deuda saneada en la s22: el descuadre A22 de la tabla tematica (% stale desde v18) quedo
  corregido. A36 previene su reaparicion.

### Auditoria de cierre (politica 5.6)
- #2 pipeline corre de cero sin intervencion manual: Si (sin cambios; ultima corrida verde en v21).
- #5 cada transformacion critica tiene check: Si (sin cambios de pipeline).
- #6 outputs reproducibles e idempotentes: Si (sin cambios de motor).
- #7 decisiones metodologicas como constantes nombradas: Si (sin cambios).
- #8 nombres sin tildes, ñ ni espacios: Si.
- "No" pendiente: la fila s22 (N=0) y el snapshot de cierre de la s22 quedan como administrativos
  de la s23.

### Ruta sugerida para la sesion 23
1. Administrativos de apertura: (a) commit del snapshot de cierre de la s22; (b) consolidar la fila
   s22 (N=0) a la tabla por sesion. Complejidad baja ambos. (Nota A35: el traspaso v22 ya queda
   versionado en el cierre de esta sesion, no deberia aparecer untracked.)
2. Foco real: actualizar la suite de documentacion post-C3 (BIBLIOTECA, protocolo 4.6).
   **Recomendacion:** (2), porque es el unico pendiente sustantivo que C3 dejo abierto y cierra el
   ciclo documental del motor sin Babel.
**Diferir:** versionar `app.jsx` fuente (mantenimiento, no urgente); otros proyectos (sesiones
dedicadas: `slep_idps` bloqueado por ponderador, `slep_simce_adecuado` cerrado en s18).

## 12. Instrucciones especificas para la proxima sesion
- 🔒 Agregacion de categoria = conteo de establecimientos educacionales. La matricula es contexto,
  nunca pondera. (En notacion tecnica se conserva "EE"/"n_EE".)
- 🔒 Basica y media nunca se mezclan. Categoria 2016-2019; media sin 2016.
- 🔒 `docs/index.html` versionado para Pages; `40_salidas/motor_categoria.html` regenerable. No
  editar a mano. El motor se edita por el TEMPLATE + regeneracion.
- 🔒 5 placeholders en el template; nunca dejarlos inyectados al guardar.
- 🔒 React/ReactDOM 18.3.1 inline. **Babel ELIMINADO (C3): cero dependencias de red.** No
  reintroducir CDNs.
- 🔒 Cuerpo del motor en `React.createElement` plano. Para editarlo, trabajar sobre JSX y
  retranspilar con `runtime: "classic"` (A34); NO editar el `createElement` a mano.
- 🔒 El backlog vive in extenso en `backlog_consolidado.md` (sin rango); fuente de verdad del
  conteo. Esta en **87**, cuadrado en las tres vistas. La fila s22 (N=0) esta PENDIENTE de agregar
  a la tabla por sesion en la s23 (no altera el total).
- 🔒 Terminologia: "establecimiento educacional" como termino generico (4.6.3.6), completo en la
  primera mencion por parrafo, abreviado despues (D32). Nunca "EE" en texto visible ni "colegio"
  generico. Aplicar en la suite post-C3.
- ✅ A35 (NUEVO): versionar el traspaso como ULTIMO paso del cierre. (Aplicado en esta sesion.)
- ✅ A36 (NUEVO): al recalcular % sobre un nuevo denominador, actualizar las celdas de la tabla
  tematica Y la nota de conteo en la misma operacion (evita descuadre A22 latente).
- ✅ ANTES de commitear snapshots del escaner: leer el estado real de `estructura/` en disco; el
  escaner de apertura ya movio el estado (A20/A32). No fiarse del traspaso previo.
- ✅ ANTES de tocar el template, el generador o `documentar.R`: leer el archivo completo.
- ✅ TODO comando de terminal con ruta completa desde la raiz; para git,
  `git -C /Users/tomgc/Projects/slep_categoria_desempeno ...`. No asumir directorio ni `cd`.
- ⚠️ Verificar reportes de Claude Code contra `git log`/`git show`/`merge-base` cuando un hash no
  calce (A32). El arbol es la verdad.
- ⚠️ Cinco proyectos en paralelo: NO asumir sesion de R ni working directory.

## 13. Fragmentos de codigo de referencia
[Conservar los del v16-v21. Patron de referencia de esta sesion: verificacion de las tres vistas
del backlog y del delta local vs remoto.]
```
# Autoverificacion de las tres vistas del backlog (A22) — deben dar el mismo total:
#   1. Cronologico: ultima entrada numerada == total; sin subsecciones de sesiones sin cambios.
#   2. Tabla tematica: suma de la columna N == total; cada % == round(N/total).
#   3. Tabla por sesion: suma de la columna "N cambios" == total; fila Total coincide.
#   (Sesiones sin cambios: fila N=0 en la tabla por sesion, NO subseccion en el cronologico.)
#
# Delta local vs remoto antes de push (confirmar premisas, no fiarse del traspaso):
#   git -C <raiz> fetch origin
#   git -C <raiz> log --oneline origin/main..main        # commits por publicar
#   git -C <raiz> merge-base --is-ancestor <hash> origin/main  # confirmar base compartida
```

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 23 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; leelo desde ahi. Retomamos
> slep_categoria_desempeno en sesion 23. La sesion 22 cerro los administrativos de apertura
> heredados (snapshots del escaner versionados, entrada 87 consolidada al backlog en las tres
> vistas), saneo un error preexistente de la tabla tematica (6 % con denominador antiguo, A22) en
> commit aparte, y versiono el traspaso v21 (A32, ahora elevado a regla de cierre A35). Sin cambios
> de proyecto; backlog en 87. Sin deuda tecnica viva. Administrativos de apertura s23: (1) commit
> del snapshot de cierre de la s22; (2) consolidar la fila s22 (N=0) a la tabla por sesion. Foco
> propuesto: actualizar la suite de documentacion post-C3. Adjunto el traspaso v22 y el escaner.

### Documentos para la proxima sesion
1. Protocolo en knowledge base (no se adjuntan): POLITICA_PROYECTO.md, SETTINGS_Y_PROMPTS_OPERACIONALES.md.
2. Opcionales segun el foco real de la s23: si el foco es la suite post-C3, el protocolo 4.6 (esta
   en SETTINGS) + `documentar.R` + `decisiones/20260618_decision_plan_c3_eliminar_babel.md`;
   `backlog_consolidado.md` para la fila s22.
3. Especificos (SI se adjuntan): `traspaso_cierre_v22.md`; `estructura_actual.md` (correr el
   escaner al abrir para reflejar el commit del snapshot de cierre de la s22).

### Nota final obligatoria
El motor esta sin Babel (sin cambios desde v21): React/ReactDOM/D3/pako inline, cero recursos de
red. El backlog esta en **87**, cuadrado en las tres vistas; la fila s22 (N=0) esta PENDIENTE de
agregar a la tabla por sesion en la s23 (no altera el total). A35 (versionar traspaso en el cierre)
y A36 (celdas % + nota juntas) son reglas nuevas. Si algun archivo listado cambio entre sesiones,
adjuntar la version mas actualizada al abrir y avisarlo en el mensaje de apertura.
