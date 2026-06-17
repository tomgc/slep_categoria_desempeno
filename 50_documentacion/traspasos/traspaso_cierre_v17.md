# Traspaso de cierre v17 — slep_categoria_desempeno

## 1. Identificacion
- **Proyecto:** slep_categoria_desempeno
- **Version:** v17
- **Fecha:** 2026-06-17
- **Sesion:** 17 — saneamiento de pendientes administrativos y de pipeline:
  consolidacion del backlog (ya materializada), desacople de `matricula_grado`/
  `grado_labels` del JSON embebido (toca pipeline), diagnostico del borrado de
  `documentar.R`, y reclasificacion de la deuda mayor DT-template tras leer el
  template completo. Cero cambios de calculo; el unico cambio de salida (peso del
  motor) se verifico con auditoria + spot-check.
- **Entorno:** R 4.5.x en Positron, macOS aarch64. Modelo: Claude Opus 4.8.
  Ejecucion en consola R de Positron y terminal zsh (cinco proyectos en paralelo;
  no asumir sesion ni working directory entre comandos).
- **Archivos principales modificados:**
  - `30_procesamiento/33_generar_html.R`: nucleo de la sesion. Se retiro la lectura
    de `matricula_rbd_grado.parquet`, la constante `GRADO_LABELS`, `meta$grado_labels`,
    el bloque columnar `matricula_grado_lst` (+ `df_mat_grado_ord`), su validacion
    (`stopifnot` + `chk_grado`), la clave `matricula_grado` en `json_root` y el
    `message` de resumen. 22.7K -> 19.4K.
  - `docs/index.html`: regenerado (motor publicado). 2.80 MB -> 1.72 MB (~39%).
  - `50_documentacion/estructura/`: snapshots del escaner (poda retencion=2).
  - `tests/reportes/`: reporte de auditoria regenerado (ignorado por Git; ver seccion 6).

## 2. Resumen ejecutivo
La sesion 17 abrio sobre el v16 con el motor estable, desplegado, cifras certificadas y
sin bloqueantes. La ruta aprobada fue P1 (consolidar backlog 74-80), P2 (desacoplar
`matricula_grado` del JSON) y P3 (diagnosticar el borrado de `documentar.R`). P1 resulto
ya hecho en disco: el v16 ejecuto la consolidacion (detalle 74-80, tablas tematica y por
sesion sobre 80, delta v16) aunque su seccion 5 lo dejo anotado como pendiente; se
verifico el cuadre (suma 80) y no hubo que tocar nada. P2 se ejecuto: el motor habia
dejado de consumir el desglose por grado en el v16 (c.79) pero el generador lo seguia
embebiendo, dato inerte; se retiro su lectura, construccion, validacion y serializacion,
bajando el motor de 2.80 a 1.72 MB con cifras identicas (auditoria F1-F4 OK, spot-check
6/6 + 1 ausencia OK). El parquet permanece en `20_insumos/` como insumo externo, sin
consumirse. P3 cerro como diagnostico: `documentar.R` esta presente, trackeado, 39.905
bytes, solo lo toca su commit de origen (`51b5159`, sesion 15); el repo vive fuera de
OneDrive (`/Users/tomgc/Projects/...`), descartando sincronizacion como causa; el borrado
del v16 fue un evento unico no reproducible, sin patron recurrente. Ademas, al abordar la
deuda mayor DT-template y leer el template completo, se constato que el diagnostico del
v16 quedo superado: el CSS YA esta tokenizado y el JSX, aunque largo (~1418 lineas), esta
internamente modularizado por componentes de responsabilidad unica; partir el archivo
fisicamente no da reuso real (el HTML final sigue siendo un unico `<script>` transpilado
en cliente) y agrega un punto de fallo de build, contra B.2 y 5.1. DT-template se
reclasifica como cerrada-superada y emerge un pendiente nuevo y real: internalizar las
dependencias CDN (React/ReactDOM/Babel via unpkg), unica violacion viva de la politica
5.5. Tres commits atomicos pusheados; arbol limpio.

## 3. Estado al cierre

### Que funciona (ultima ejecucion exitosa)
- **MOTOR MAS LIVIANO Y DESPLEGADO:** el JSON ya no embebe `matricula_grado` ni
  `grado_labels`. `docs/index.html` regenerado (1.72 MB) y pusheado; GitHub Pages sirve
  la version nueva. La ficha de establecimiento (layout D2 del v16) sin cambios visuales.
- **PIPELINE INTACTO SALVO EL GENERADOR DE SALIDA:** los pasos 30-32 no se tocaron. El
  paso 33 (`33_generar_html.R`) cambio solo en lo que embebe (retiro del bloque grado);
  el calculo de los bloques vivos (territorial, sin_vigente, rbd, matricula por ense2) es
  identico. `run_all()`/`regenerar_motor()` corren limpio (paso 33 OK en ~1 s).
- **CIFRAS CERTIFICADAS POR DOBLE VIA:** `source(here::here("tests","auditar_cifras.R"))`
  -> F1-F4 OK, 0 discrepancias. `source(here::here("tests","spot_check_publicado.R"))` ->
  6 celdas de presencia OK + 1 de ausencia simetrica (media/2016) OK. Veredicto OK.
- **Arbol de Git limpio y pusheado al cierre:** commits `22e317f`, `1108c60`, `e0ee56e`
  en origin/main.

### Que no funciona / pendiente
- No hay nada roto. Pendientes vivos: internalizar dependencias CDN (NUEVO, deuda de
  politica 5.5); observaciones de `suitedoc` (para `herramientas_dev`, no este repo).
  DT-template: CERRADA-SUPERADA (ver seccion 8). `documentar.R`: diagnostico CERRADO
  (evento unico no reproducible; vigilancia pasiva).

### Delta respecto a v16
v16 rediseño la ficha (D2, sin grado, encabezado de columnas) tocando solo presentacion
del motor, sin tocar pipeline ni JSON. v17 SI toca el pipeline (paso 33): desacopla
`matricula_grado` del JSON, completando el ciclo abierto por c.79. Ademas cierra dos
diagnosticos administrativos (P1 ya hecho, P3) y RECLASIFICA la deuda mayor del backlog
(DT-template) tras constatar que su premisa quedo obsoleta. Cero cambios de calculo;
cifras identicas verificadas. El motor pasa de 2.80 MB (v16) a 1.72 MB (v17).

## 4. Registro detallado de cambios

### Cambio 81 — Desacoplar `matricula_grado` y `grado_labels` del JSON embebido
- **Categoria:** Pipeline R.
- **Que (`33_generar_html.R`):** se retiro todo lo que solo servia al desglose por grado:
  la constante `GRADO_LABELS` (~16 lineas), la carga de `matricula_rbd_grado.parquet`
  (ruta + `stop` + `read_parquet` + filtro 2/5/7 + `message`), `meta$grado_labels`, el
  bloque columnar `df_mat_grado_ord` + `matricula_grado_lst`, su validacion de integridad
  (`stopifnot` del bloque grado + el cruce `chk_grado` de suma de grados vs ense2), la
  clave `matricula_grado` de `json_root` y el `message` "Matric.grado" del resumen.
- **Por que (C.11):** el motor dejo de consumir el desglose en el v16 (c.79); el generador
  lo seguia embebiendo -> ~1 MB de dato inerte en el HTML. El desacople cierra el ciclo.
- **Como se verifico (B.4):** grep de control sobre el template vacio (sin `grado_labels|
  matricula_grado|GRADO_LABELS|matriculaPorGrado|MATG`); `regenerar_motor()` OK; JSON sin
  comprimir 11.0 MB -> motor 1.72 MB (era 2.80); auditoria F1-F4 OK; spot-check 6/6 + 1
  ausencia OK. El parquet permanece en `20_insumos/` (insumo externo, no salida del
  pipeline; no se toca). Commits `22e317f` (generador) + `1108c60` (motor regenerado).

### Cambio 82 — Snapshots del escaner (poda retencion=2)
- **Categoria:** Migracion y publicacion / DevOps.
- **Que (`50_documentacion/estructura/`):** se versionaron los snapshots generados en la
  sesion; la poda de retencion=2 (politica 7.4) conservo los 2 timestamps mas recientes +
  aliases y elimino los anteriores. Git lo registro como rename.
- **Por que (C.11):** el escaner se corrio al abrir y al cerrar; se versiona aparte del
  cambio de pipeline (un cambio conceptual por commit).
- **Como se verifico (B.4):** commit atomico separado del generador y del motor. Commit
  `e0ee56e`.

## 5. Backlog acumulativo
[El backlog vive in extenso en `50_documentacion/activa/backlog_consolidado.md` (nombre
sin rango), fuente de verdad del conteo. Total cronologico 80 -> 82.
- NOTA DE CONTINUIDAD: el v16 anoto la consolidacion de 74-80 como pendiente, pero en los
  hechos quedo materializada en el archivo (detalle 74-80, tablas sobre 80, delta v16).
  La sesion 17 lo verifico (suma 80, cuadra) y NO tuvo que rehacerlo. P1 quedo cerrado por
  verificacion, no por trabajo nuevo.
- Cambios nuevos: 81 (desacople `matricula_grado` del JSON, "Pipeline R"), 82 (snapshots
  del escaner, "Migracion y publicacion / DevOps").
- Delta de taxonomia: "Pipeline R" +1 (4->5); "Migracion y publicacion / DevOps" +1
  (3->4). Sin categorias nuevas. Recalcular porcentajes sobre 82 al consolidar.
- PENDIENTE DE CONSOLIDACION: agregar 81-82 al `backlog_consolidado.md` (detalle
  cronologico de la sesion 17, fila de la sesion 17 en la tabla por sesion con N=2, y
  ambas tablas recalculadas sobre 82). Es el primer paso administrativo de la sesion 18.]

## 6. Bugs de la sesion
No hubo bugs de codigo. Dos hallazgos de higiene de repositorio:
1. **P1 ya estaba hecho:** la consolidacion del backlog 74-80 que el v16 dejo como
   pendiente ya estaba materializada en `backlog_consolidado.md`. Se verifico el cuadre y
   se descarto como trabajo. No es un bug; es un desfase entre lo anotado y lo hecho en el
   v16.
2. **Reportes de auditoria regenerables:** `auditar_cifras.R` reescribe
   `tests/reportes/auditoria_cifras.md` y emite un snapshot con timestamp
   (`20260616_131340_auditoria_cifras.md`). Se verifico con `git status` que el directorio
   `tests/reportes/` esta ignorado (regla A20: el escaner los lista pero Git no los
   trackea); no entran a ningun commit. Falsa deuda.

## 7. Aprendizajes y restricciones descubiertas

### A27 (NUEVO) — Verificar el estado real antes de re-ejecutar un pendiente heredado
- **Regla:** un pendiente anotado en el traspaso anterior puede estar ya resuelto en
  disco. Antes de ejecutarlo, verificar su estado actual (leer el archivo, correr el
  check). P1 (consolidar backlog) figuraba como pendiente del v16 pero ya estaba hecho;
  re-ejecutarlo habria duplicado o corrompido entradas.
- **Principio:** 1.2.6 (nunca operar sobre un estado supuesto). Contexto: el desfase
  surge cuando una sesion hace el trabajo pero su seccion 5 no actualiza el estado del
  pendiente.

### A28 (NUEVO) — El parquet de grado es insumo, no salida: no se borra al desacoplar
- **Regla:** desacoplar `matricula_grado` del JSON significa dejar de LEERLO y EMBEBERLO,
  no eliminar `matricula_rbd_grado.parquet`. Ese parquet es insumo externo generado en
  `slep_analisis_matricula`; vive en `20_insumos/` (read-only del pipeline). Tocar
  insumos por un cambio de salida violaria la inmutabilidad de la fuente (5.2.1).
- **Principio:** 5.2.1 (inmutabilidad de la fuente) + 1.3 (separacion input/output).
  Contexto: c.81.

### A29 (NUEVO) — Un diagnostico de deuda caduca; releer antes de ejecutarla
- **Regla:** la descripcion de una deuda en el backlog puede quedar obsoleta si el codigo
  evoluciono. DT-template se heredaba como "template monolitico, CSS sin tokenizar"; al
  leer el archivo se constato que el CSS YA esta tokenizado (custom properties completas)
  y el JSX YA esta modularizado por componentes de responsabilidad unica. La deuda mayor
  no era tal en su forma actual. Releer SIEMPRE antes de abrir una deuda heredada de alto
  riesgo (criterio de higiene + 1.2.6).
- **Principio:** B.2 (simplicidad: no modularizar sin reuso real, 5.1) + 1.2.6 (no operar
  sobre supuestos). Contexto: reclasificacion de DT-template (seccion 8).

## 8. Decisiones de diseno

### D26 (NUEVA) — Desacople de `matricula_grado` sin tocar el insumo
- **Decision:** el generador deja de leer `matricula_rbd_grado.parquet` y de embeber
  `matricula_grado`/`grado_labels`; el parquet permanece en `20_insumos/` intacto.
- **Alternativas descartadas:** (a) borrar el parquet (descartada: es insumo externo,
  viola 5.2.1); (b) dejar el dato inerte en el JSON (descartada: ~1 MB de peso muerto);
  (c) modificar el pipeline upstream en `slep_analisis_matricula` para no generarlo
  (descartada: fuera de alcance; el parquet puede servir a otros consumidores).
- **Justificacion:** separa la decision de producto (no mostrar grado) de la integridad
  del insumo; reduce el motor ~1 MB sin tocar la fuente.
- **Implicancia:** si se reintroduce el desglose por grado en la ficha, restaurar la
  carga, el bloque columnar, su validacion y la clave en `json_root` (el comentario de
  cabecera del generador lo documenta).

### D27 (NUEVA) — DT-template reclasificada: no se modulariza por particion de archivos
- **Decision:** NO ejecutar DT-template como particion fisica del template (ni fragmentos
  reconcatenados en build, ni extraccion de CSS/JS a archivos inyectados). Se cierra como
  deuda superada y se reemplaza por el pendiente real (internalizar dependencias CDN).
- **Alternativas descartadas:** (a) particion en fragmentos que `33_generar_html.R`
  concatena (descartada: el HTML final sigue siendo un unico `<script>` transpilado en
  cliente -> sin reuso real, y agrega un punto de fallo de build y fragilidad del criterio
  byte-a-byte); (b) extraer CSS/JS a archivos propios via placeholders nuevos (descartada:
  reorganizacion arquitectonica mayor, alto riesgo, contra el modelo de archivo unico de
  5.5, desproporcionada al estado real del codigo).
- **Justificacion:** el diagnostico v16 quedo obsoleto. CSS ya tokenizado; JSX ya modular
  por componentes. Modularizar fisicamente seria alto riesgo con beneficio marginal,
  contra 5.1 ("modularizar solo con reuso real") y B.2.
- **Implicancia:** la deuda mayor del backlog deja de figurar como tal. El trabajo de
  calidad real disponible sobre el template es internalizar React/ReactDOM/Babel (hoy via
  unpkg), unica violacion viva de 5.5.

### D25 (v16), D24 (v15), D23 (v14), D21, D22 (v13) y previas — vigentes sin cambios.

## 9. Constantes y parametros vigentes
[Tabla del v16 sin cambios de CALCULO. El pipeline cambio solo en lo que el paso 33
embebe; los bloques de calculo y sus constantes son identicos.
- `33_generar_html.R`: ELIMINADA la constante `GRADO_LABELS`. `CAT_ORDEN`, `CAT_COLORS`,
  `CAT_LABELS`, `MOTIVO_LABELS`, `DEPE_LABELS`, `ENSE2_LABELS`, `ENSE2_A_NIVEL`,
  `PCT_DIGITS` sin cambios. `meta` ya no incluye `grado_labels`.
- `SPOT_CELDAS` (6 presencia) + `SPOT_AUSENCIAS` (1: media/2016) sin cambios.
- Valores del motor sin cambio: `anio_vigente`=2019, `anio_matricula_vigente`=2025,
  cobertura categoria 2016-2019, matricula 2016-2025, `CAT_REALES`, copy institucional.]

## 10. Arquitectura de archivos
Referencia al escaner del cierre: snapshot `20260617_081708` (21 carpetas, 115 archivos).
`33_generar_html.R` 19.4K (era 22.7K). `docs/index.html` y `40_salidas/motor_categoria.html`
1.68 MB (eran 2.67). Sin cambios estructurales de carpetas. Archivos modificados en la
sesion: `33_generar_html.R` (desacople), `docs/index.html` (motor regenerado),
`50_documentacion/estructura/` (snapshots). Reportes de `tests/reportes/` regenerados pero
ignorados. Commits de la sesion (todos en origin/main): `22e317f` (desacople generador),
`1108c60` (motor regenerado 2.80->1.72 MB), `e0ee56e` (snapshots escaner poda retencion=2),
mas el commit del traspaso v17.

## 11. Pendientes y ruta sugerida

### Inventario de pendientes
- **Internalizar dependencias CDN (NUEVO, medio).**
  Tipo: deuda tecnica / cumplimiento de politica 5.5. El motor carga React 18.3.1,
  ReactDOM 18.3.1 y Babel standalone 7.29.0 desde `unpkg.com` en runtime (template lineas
  ~1514-1522): el motor se rompe sin red o si unpkg cae, y viola "web estatica sin
  dependencias externas" (5.5). Accion: descargar los tres `.js` a `10_utils/`, agregar
  placeholders (`__REACT_INLINE__`, `__REACTDOM_INLINE__`, `__BABEL_INLINE__`) e inyectarlos
  en `33_generar_html.R` como D3/pako. Complejidad: media. Precaucion: Babel standalone es
  voluminoso (~3 MB) -> el motor crecera; evaluar si compensa vs. mantener Babel en CDN y
  solo internalizar React/ReactDOM. Decidir el alcance en frio. Insumos:
  `33_motor_template.html` + `33_generar_html.R`. Tarea manual del titular: bajar los `.js`.
- **Consolidar backlog 81-82 (NUEVO, administrativo).**
  Tipo: documentacion. Agregar 81-82 al `backlog_consolidado.md`, fila de la sesion 17
  (N=2) en la tabla por sesion, ambas tablas recalculadas sobre 82 (regla A22).
  Complejidad: baja.
- **DT-template (CERRADA-SUPERADA).** Ya no es deuda activa (D27). Se conserva en el
  registro como decision, no como pendiente.
- **`documentar.R` (diagnostico CERRADO, vigilancia pasiva).** Evento unico no
  reproducible; el repo esta fuera de OneDrive (causa de sync descartada); el archivo
  esta trackeado, asi que `git checkout -- documentar.R` lo restaura si reaparece. Si
  vuelve a aparecer `deleted` en una apertura, anotar que se corrio en la sesion previa
  (especialmente pasos de `suitedoc` o limpieza que toquen la raiz) para acotar.
- **Observaciones de `suitedoc` (para `herramientas_dev`, NO este repo).** Sin cambios:
  (a) lucide via CDN; (b) `dec_block()` con `id=""` deja espacio inicial.

### Pendientes del v16 cerrados en v17
- P1 consolidar backlog 74-80: CERRADO por verificacion (ya estaba hecho).
- P2 desacoplar `matricula_grado`: CERRADO (c.81).
- P3 diagnostico `documentar.R`: CERRADO (evento unico no reproducible).
- DT-template: CERRADA-SUPERADA (D27).

### Evaluacion de deuda tecnica
- Deuda mayor heredada (DT-template): disuelta tras releer el codigo (A29).
- Deuda real viva: dependencias CDN en runtime (viola 5.5).
- Resuelto en v17: dato inerte `matricula_grado` en el JSON.

### Auditoria de cierre (politica 5.6)
- #2 pipeline corre de cero sin intervencion manual: Si (`run_all()`/`regenerar_motor()`
  limpio; paso 33 OK).
- #5 cada transformacion critica tiene check: Si (se RETIRO la validacion del bloque grado
  junto con el bloque; las validaciones de los bloques vivos permanecen intactas).
- #6 outputs reproducibles e idempotentes: Si (cifras identicas; auditoria F1-F4 +
  spot-check 6/6 + 1 ausencia).
- #7 decisiones metodologicas como constantes nombradas: Si (sin numeros magicos nuevos;
  se eliminaron constantes, no se agregaron).
- #8 nombres sin tildes, ñ ni espacios: Si.
- "No" pendiente: la consolidacion del backlog 81-82 queda como pendiente administrativo
  de la sesion 18.

### Ruta sugerida para la sesion 18
1. Administrativo de apertura: correr el escaner y consolidar el backlog 81-82 sobre 82
   (A22). Complejidad baja. Exito: ambas tablas suman 82, cuadran con el cronologico.
2. Decision en frio sobre internalizar dependencias CDN: definir alcance (los tres `.js`
   o solo React/ReactDOM dejando Babel en CDN, dado el peso de Babel standalone). Es la
   unica deuda de politica viva. Complejidad media. Exito: el motor abre sin red;
   byte-equivalente salvo los scripts internalizados; auditoria + spot-check en verde.
**Diferir:** nada de alto riesgo pendiente. La internalizacion CDN es de riesgo medio y
merece su propia sesion con decision de alcance previa.

## 12. Instrucciones especificas para la proxima sesion
- 🔒 Agregacion de categoria = conteo de EE. La matricula es contexto, nunca pondera.
- 🔒 Basica y media nunca se mezclan. Categoria 2016-2019; media sin 2016. Matricula
  2016-2025. NO mezclar.
- 🔒 `docs/index.html` versionado para Pages; `40_salidas/motor_categoria.html`
  regenerable, ignorado. No editar `docs/` ni `40_salidas/` a mano.
- 🔒 El motor conserva los 3 placeholders del pipeline (`__D3_INLINE__`, `__PAKO_INLINE__`,
  `__JSON_DATA__`); NUNCA dejarlos inyectados al guardar el template. Si se internaliza CDN,
  se AGREGAN placeholders nuevos (no se tocan estos tres).
- 🔒 La ficha usa el layout D2 del v16 (filas a todo el ancho, sin grado, con encabezado de
  columnas). Estado aprobado; partir de el para futura UI (A18/A19).
- 🔒 `matricula_rbd_grado.parquet` es INSUMO (vive en `20_insumos/`, read-only). El
  desacople (c.81) dejo de leerlo, NO lo borro. No tocar insumos por cambios de salida
  (A28, 5.2.1).
- 🔒 El JSON ya NO embebe `matricula_grado` ni `grado_labels`. Si se reintroduce el
  desglose por grado, restaurar carga + bloque columnar + validacion + clave en
  `json_root` (documentado en la cabecera de `33_generar_html.R`).
- 🔒 `run_all()` corre el pipeline completo; atajo `regenerar_motor()` (= only=33). La
  AUDITORIA de cifras NO es parte del pipeline (D23); se corre a mano desde `tests/`.
- 🔒 El backlog vive in extenso en `backlog_consolidado.md` (sin rango); fuente de verdad
  del conteo. Los traspasos agregan solo el delta. PENDIENTE: consolidar 81-82 sobre 82.
- ⚠️ DT-template esta CERRADA-SUPERADA (D27): NO reabrir como particion de archivos. El CSS
  ya esta tokenizado y el JSX ya es modular por componentes. La deuda real es CDN, no
  particion.
- ⚠️ Cinco proyectos en paralelo: NO asumir sesion de R ni working directory entre
  comandos. Verificar `here::here()` antes de `source()`; confirmar el `.Rproj` abierto.
  `regenerar_motor()` requiere `source(here::here("00_run_all.R"))` primero.
- ⚠️ NO confundir el escaner (filesystem) con el indice de Git. `tests/reportes/` y
  `.DS_Store` se LISTAN pero NO se trackean (A20). Verificar con `git status`/`git ls-files`.
- ⚠️ `documentar.R`: si reaparece `deleted`, restaurar con `git checkout --` y anotar la
  sesion previa (vigilancia pasiva; causa del v16 no reproducible).
- ✅ ANTES de re-ejecutar un pendiente heredado: verificar su estado real en disco (A27).
- ✅ ANTES de abrir una deuda de alto riesgo: releer el codigo; el diagnostico puede haber
  caducado (A29).
- ✅ ANTES de modificar el template: leer el archivo completo (regla permanente).
- ✅ TODO comando de terminal con ruta completa desde la raiz; para git,
  `git -C /Users/tomgc/Projects/slep_categoria_desempeno ...`. No asumir directorio ni `cd`.
- ✅ Tras tocar el JSON: `regenerar_motor()` + `source(here::here("tests","auditar_cifras.R"))`
  + `source(here::here("tests","spot_check_publicado.R"))`. Esperar F1-F4 OK + 6/6 + 1 ausencia.

## 13. Fragmentos de codigo de referencia
[Conservar los del v16 (modo de ausencia del spot-check; `EnseItem` simple). Añadir el
patron de la cabecera documentada del generador tras un desacople, para que una futura
reintroduccion sepa que restaurar:]
```r
# Nota (sesion 17, desacople de grado): el motor dejo de consumir el desglose
#   por grado en la sesion 16 (c.79, retiro de codigo muerto). Este generador
#   ya no lee matricula_rbd_grado.parquet ni embebe matricula_grado/grado_labels
#   en el JSON: era dato inerte que inflaba el peso. El parquet permanece en
#   20_insumos/ (insumo externo de slep_analisis_matricula), simplemente no se
#   consume aqui. Si se reintroduce el desglose por grado en la ficha, restaurar
#   la carga, el bloque columnar, su validacion y la clave en json_root.
```
```r
# json_root tras el desacople: el bloque matricula (por ense2) permanece;
# matricula_grado YA NO figura. Los 9 bloques vivos:
json_root <- list(
  meta             = meta,            # sin grado_labels
  regiones         = regiones_lst,
  comunas          = comunas_lst,
  sleps            = sleps_lst,
  establecimientos = establecimientos_lst,
  territorial      = territorial_lst,
  sin_vigente      = sin_vigente_lst,
  rbd              = rbd_lst,
  matricula        = matricula_lst    # por cod_ense2; NO por grado
)
```

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 18 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; leelo desde ahi.
> Retomamos slep_categoria_desempeno en sesion 18. La sesion 17 desacoplo
> `matricula_grado`/`grado_labels` del JSON embebido (el motor habia dejado de
> consumirlos en el v16): el generador ya no lee `matricula_rbd_grado.parquet` ni los
> embebe, bajando el motor de 2.80 a 1.72 MB con cifras identicas (auditoria F1-F4 OK,
> spot-check 6/6 + 1 ausencia OK). El parquet permanece en `20_insumos/` como insumo.
> Ademas: P1 (consolidar backlog 74-80) resulto ya hecho en disco; P3 cerro el
> diagnostico de `documentar.R` (evento unico no reproducible, repo fuera de OneDrive);
> y la deuda mayor DT-template se RECLASIFICO como superada (el CSS ya esta tokenizado y
> el JSX ya es modular por componentes; partir el archivo no da reuso real). Emergio un
> pendiente nuevo y real: internalizar las dependencias CDN (React/ReactDOM/Babel via
> unpkg, unica violacion viva de 5.5). Pendientes vivos: consolidar el backlog 81-82
> (administrativo) y decidir en frio el alcance de la internalizacion CDN. Todo pusheado,
> arbol limpio. Adjunto el traspaso v17 y el escaner.

### Documentos para la proxima sesion
1. Protocolo en knowledge base (no se adjuntan): POLITICA_PROYECTO.md,
   SETTINGS_Y_PROMPTS_OPERACIONALES.md.
2. Opcionales segun foco: `33_motor_template.html` + `30_procesamiento/33_generar_html.R`
   (si se internaliza CDN); `backlog_consolidado.md` (para consolidar 81-82);
   `tests/spot_check_publicado.R` + `tests/auditar_cifras.R` (si se re-audita tras tocar
   el motor).
3. Especificos (SI se adjuntan): `traspaso_cierre_v17.md`; `estructura_actual.md` (correr
   el escaner al abrir para reflejar el estado post-v17).

### Nota final obligatoria
El motor (`33_motor_template.html`) sigue en su estado aprobado v16 (ficha D2). El JSON
embebido cambio en v17: ya NO incluye `matricula_grado` ni `grado_labels`. DT-template
esta CERRADA-SUPERADA (no reabrir como particion). El backlog in extenso es la fuente de
verdad del conteo (`backlog_consolidado.md`, sin rango) y tiene PENDIENTE la consolidacion
de 81-82 sobre 82. La proxima deuda real es internalizar las dependencias CDN. Si algun
archivo listado cambio entre sesiones, adjuntar la version mas actualizada al abrir y
avisarlo en el mensaje de apertura.
