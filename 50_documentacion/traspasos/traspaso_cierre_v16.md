# Traspaso de cierre v16 — slep_categoria_desempeno

## 1. Identificacion
- **Proyecto:** slep_categoria_desempeno
- **Version:** v16
- **Fecha:** 2026-06-16
- **Sesion:** 16 — rediseño UI/UX de la ficha de establecimiento ("Trayectoria y
  matricula por año"): eliminacion del detalle por grado, layout de filas a todo el
  ancho (D2), encabezado de columnas por año, limpieza de redundancia y retiro de
  codigo muerto; mas el cierre del pendiente menor DT-spot-check-ausencia. Cambio de
  presentacion en el motor; cero cambios de calculo.
- **Entorno:** R 4.5.x en Positron, macOS aarch64. Modelo: Claude Opus 4.8. Ejecucion
  delegada a Claude Code (mismo entorno local).
- **Archivos principales modificados:**
  - `30_procesamiento/33_motor_template.html`: nucleo de la sesion. Componente
    `EnseItem` simplificado (sin grado, sin sufijo redundante); bloque por año de
    `EeRow` rediseñado a D2; encabezado de columnas nuevo; CSS del bloque reescrito;
    retiro del indice `MATG`/`MATG_IX`, la funcion `matriculaPorGrado` y `GRADO_LABELS`.
  - `docs/index.html` y `40_salidas/motor_categoria.html`: regenerados (motor publicado).
  - `tests/spot_check_publicado.R`: modo de certificacion de ausencia simetrica
    (`SPOT_AUSENCIAS` + dos funciones nuevas + Paso 1-bis).
  - `50_documentacion/estructura/`: snapshots del escaner (poda retencion=2).

## 2. Resumen ejecutivo
La sesion 16 abrio sobre el v15 con el motor estable, desplegado y con cifras
certificadas, sin pendientes bloqueantes. El titular fue un rediseño UI/UX de la ficha
de establecimiento: la seccion "Trayectoria y matricula por año" organizaba los datos en
columna estrecha, desaprovechando el ancho. Se rediseño a un layout de filas a todo el
ancho (variante D2 acordada con el titular): cabecera año + categoria, subtitulo de
matricula del nivel, filas de enseñanza a todo el ancho (sin limite de tipos) y total
destacado. En el proceso, el titular decidio eliminar el detalle por grado (1°-8°), por
ser un nivel de detalle que no corresponde a una vista de categorias de desempeño; se
retiro su render y, en pasada posterior, su codigo muerto en el motor (sin tocar el
pipeline ni el JSON, que sigue embebiendo `matricula_grado`). Se agrego un encabezado de
columnas sutil ("Nivel" / "N° de estudiantes") por bloque-año, y al notar que la primera
fila repetia la palabra "estudiantes" se quito el sufijo redundante. Por separado se
cerro DT-spot-check-ausencia: el spot-check ahora certifica la ausencia simetrica de
combinaciones que la fuente no publica (media/2016), cerrando la verificacion por ambos
lados. Todo en commits atomicos, motor regenerado, spot-check 6/6 OK (mas 1 de ausencia),
placeholders intactos, todo pusheado. La auditoria de apertura habia marcado `.DS_Store`
como deuda; se verifico que NO estan trackeados (falsa deuda, regla A20), y el titular
los limpio del disco a mano. Se descarto esa "deuda".

## 3. Estado al cierre

### Que funciona (ultima ejecucion exitosa)
- **Motor REDISEÑADO Y DESPLEGADO:** la ficha de establecimiento muestra la trayectoria
  por año en layout D2 (filas a todo el ancho) con encabezado de columnas, sin detalle
  por grado y sin sufijo redundante. `docs/index.html` regenerado y pusheado; GitHub
  Pages sirve la version nueva. Commits `0e74548`, `1535110`, `b4b5596`, `1ed0524`,
  `2d6e570` (template) + `796b6aa`, `f823b60` (motor publicado).
- **PIPELINE Y CALCULO INTACTOS:** no se toco ningun script `.R` del pipeline (30-33).
  El JSON embebido no cambio de contenido (solo se dejo de consumir `matricula_grado` en
  el motor, sin dejar de generarlo). Cifras sin cambio.
- **SPOT-CHECK POR AMBOS LADOS Y EN VERDE:** `source(here::here("tests",
  "spot_check_publicado.R"))` verifica 6 celdas de presencia (6/6 OK) + 1 de ausencia
  simetrica (media/2016 → crudo 0 + publicado sin fila → OK). Veredicto final OK.
  Commit `87c9a7c`.
- **Arbol de Git limpio y pusheado al cierre:** todos los commits en origin/main.

### Que no funciona / pendiente
- No hay nada roto. Pendiente NUEVO derivado de la sesion: desacoplar `matricula_grado`
  del JSON embebido (el motor ya no lo consume; el pipeline sigue generandolo → dato
  inerte que infla el peso del motor). Deuda mayor sin cambio: DT-template. Diagnostico
  pendiente: causa del borrado de `documentar.R` en el working tree (ver seccion 7).

### Delta respecto a v15
v15 cerro tres pendientes menores y agrego la suite de documentacion, sin tocar motor ni
pipeline. v16 es la primera sesion desde v13 que TOCA el motor (`33_motor_template.html`),
pero solo en presentacion: rediseña la ficha de establecimiento (D2), elimina el detalle
por grado, agrega encabezado de columnas, quita una redundancia y retira el codigo muerto
resultante. Ademas CIERRA DT-spot-check-ausencia. Cero cambios de calculo; cifras
certificadas se mantienen (spot-check 6/6 + 1 ausencia). El motor pasa de su estado
aprobado del v13 a un estado aprobado v16.

## 4. Registro detallado de cambios

### Cambio 74 — Eliminar la expansion por grado en la ficha de establecimiento
- **Categoria:** Interfaz / visualizacion.
- **Que (`33_motor_template.html`):** se simplifico `EnseItem` a una fila simple
  (etiqueta de enseñanza + matricula): se quitaron el estado `abierto` (`useState`), la
  invocacion `CatData.matriculaPorGrado`, la variable `tieneGrado`, el boton
  `ee-ense-toggle` y el `<ul ee-grado-list>` con sus filas de grado. Call site sin las
  props `rbd`/`anio`. CSS de grado eliminado (`.ee-ense-toggle`, `.ee-grado-*`).
- **Por que (C.11):** decision del titular — el detalle por grado (1°-8°) es un nivel de
  detalle que no corresponde a una vista de categorias de desempeño (las categorias no
  son por curso).
- **Como se verifico (B.4):** JSX transpila con `@babel/preset-react` sin error;
  placeholders=3; no quedan `ee-grado`/`ee-ense-toggle` en el template. Commit `0e74548`.

### Cambio 75 — Rediseñar trayectoria por año a layout de filas a todo el ancho (D2)
- **Categoria:** Interfaz / visualizacion.
- **Que (`33_motor_template.html`):** el `<li>` por año de `EeRow` apila como hijos
  directos de `.ee-detail-row`: cabecera (año + marca + categoria, sin dos puntos),
  subtitulo "N matriculados en {NIVEL}", lista de enseñanza a todo el ancho, y fila
  "Total establecimiento" destacada (condicion independiente `totalEE != null`). CSS:
  se quito `margin-left: 100px` del subtitulo, se eliminaron `.ee-detail-ense` y
  `.ee-detail-ense-title` (el wrapper y el mini-titulo "Matricula por tipo de enseñanza"
  ya no se renderizan); la lista ocupa el ancho completo.
- **Por que (C.11):** la organizacion en columna estrecha desaprovechaba el ancho de la
  ficha; el modelo de filas escala a establecimientos con 5+ tipos de enseñanza (donde
  un layout de columnas por enseñanza no cabe).
- **Como se verifico (B.4):** JSX valido; placeholders=3; sin referencias residuales a
  clases removidas; revision visual del titular (aprobada). Commit `1535110`.

### Cambio 76 — Snapshots del escaner (poda retencion=2)
- **Categoria:** Documentacion de proyecto.
- **Que (`50_documentacion/estructura/`):** se commitearon los snapshots del escaner
  generados durante la sesion; la poda de retencion=2 (politica 7.4) elimino el snapshot
  `133903` y conservo `143652` + aliases. Git lo registro como rename.
- **Por que (C.11):** el escaner se corrio en la sesion y dejo el working tree con
  snapshots pendientes; se versionan aparte del rediseño de UI (un cambio conceptual por
  commit).
- **Como se verifico (B.4):** commit atomico separado del template. Commit `599b3df`.

### Cambio 77 — Encabezado de columnas por año en la ficha de establecimiento
- **Categoria:** Interfaz / visualizacion.
- **Que (`33_motor_template.html`):** se agrego un encabezado de columnas sutil, UNO POR
  bloque-año, entre el subtitulo y la lista de enseñanza: "Nivel" (izquierda) y "N° de
  estudiantes" (derecha), bajo la condicion `desglose.length > 0`. CSS nuevo
  `.ee-detail-ense-head` (flex `space-between`, atenuado, borde inferior fino). Token de
  tamaño `var(--fs-xs)` (no `--fs-overline`, reservado a mayusculas).
- **Por que (C.11):** las filas de enseñanza quedaban sin rotular tras el rediseño D2; el
  encabezado da contexto a las dos columnas. Por año, porque cada año es un bloque
  independiente.
- **Como se verifico (B.4):** JSX valido; placeholders=3; spot-check 6/6 OK; el header
  aparece en `docs/index.html`; sin `text-transform: uppercase`. Commit `b4b5596`.

### Cambio 78 — Quitar sufijo redundante "estudiantes" en la ficha
- **Categoria:** Interfaz / visualizacion.
- **Que (`33_motor_template.html`):** la cifra de `EnseItem` dejo de llevar el sufijo
  condicional del primer item (`{di === 0 ? " estudiantes" : ""}`); como `di` quedo sin
  uso, se elimino en cascada de la firma (`{ d, di }` → `{ d }`), el `map` y el call
  site.
- **Por que (C.11):** tras agregar el encabezado "N° de estudiantes", la primera fila
  repetia la palabra ("36 estudiantes"); el rotulo ya da el contexto.
- **Como se verifico (B.4):** JSX valido; `di` ya no aparece en el archivo;
  placeholders=3. Commit `1ed0524`.

### Cambio 79 — Retirar codigo muerto de matricula por grado en el motor
- **Categoria:** Mantenimiento / refactor.
- **Que (`33_motor_template.html`):** se retiraron del motor el indice `MATG` y
  `MATG_IX` (con el `for` que lo poblaba), la funcion `matriculaPorGrado` completa, la
  entrada `matriculaPorGrado` del objeto `CatData`, y `GRADO_LABELS` (su unica
  referencia viva estaba dentro de `matriculaPorGrado`). SOLO el motor; NO se toco el
  pipeline ni el JSON: `DATA.matricula_grado` sigue embebido, el motor solo deja de
  consumirlo.
- **Por que (C.11):** al eliminar la expansion por grado (c.74) ese codigo quedo sin
  uso; dejarlo es ruido que confunde a futuras sesiones.
- **Como se verifico (B.4):** grep de control vacio (`matriculaPorGrado|MATG|MATG_IX|
  ee-grado`); JSX valido; placeholders=3; spot-check 6/6 OK. Commit `2d6e570`.

### Cambio 80 — Certificar ausencia simetrica en el spot-check (DT-spot-check-ausencia)
- **Categoria:** Validacion / integridad.
- **Que (`tests/spot_check_publicado.R`):** nueva lista `SPOT_AUSENCIAS` (combinaciones
  tipo/nom/nivel/anio que la fuente no publica, sin `categoria`), dos funciones nuevas
  (`spot_esperado_ausencia_slep` cuenta filas en crudo sin filtrar categoria;
  `spot_publicado_ausencia_slep` cuenta filas en el territorial publicado sin filtrar
  categoria y SIN `stop()` ante 0), un Paso 1-bis que recorre `SPOT_AUSENCIAS` (PASS si
  crudo==0 && pub==0; FALLA acumulada en el mismo vector `fallas`), y el veredicto
  agregado ajustado a presencia + ausencia.
- **Por que (C.11):** el spot-check solo verificaba presencia y reventaba ante una celda
  ausente (A24); el modo de ausencia cierra la verificacion por ambos lados y certifica
  como correcta la ausencia legitima (media/2016).
- **Como se verifico (B.4):** ejecucion real, 6 presencia OK + 1 ausencia OK, veredicto
  final OK; el script ya no aborta ante media/2016. Commit `87c9a7c`.

## 5. Backlog acumulativo
[El backlog vive in extenso en `50_documentacion/activa/backlog_consolidado.md` (nombre
sin rango). Este traspaso NO lo reproduce: referencia ese archivo como fuente de verdad y
le agrega las entradas 74-80 de esta sesion. Total cronologico 73 -> 80.
- Cambios nuevos: 74 (eliminar expansion por grado, "Interfaz / visualizacion"), 75
  (rediseño D2, "Interfaz / visualizacion"), 76 (snapshots escaner, "Documentacion de
  proyecto"), 77 (encabezado de columnas, "Interfaz / visualizacion"), 78 (quitar sufijo
  redundante, "Interfaz / visualizacion"), 79 (retiro codigo muerto, "Mantenimiento /
  refactor"), 80 (ausencia simetrica spot-check, "Validacion / integridad").
- Delta de taxonomia: "Interfaz / visualizacion" +4; "Documentacion de proyecto" +1
  (9->10); "Validacion / integridad" +1 (3->4); "Mantenimiento / refactor" +1. Revisar
  si "Interfaz / visualizacion" se acerca al umbral de subdivision (25%) tras este salto;
  recalcular porcentajes sobre 80 al consolidar.
- PENDIENTE DE CONSOLIDACION: agregar las entradas 74-80 al `backlog_consolidado.md` y
  recalcular ambas tablas (tematica y por sesion) sobre 80 (regla A22). No se hizo en
  esta sesion; queda como primer paso administrativo de la 17 o como cierre de esta si
  el titular lo pide.]

## 6. Bugs de la sesion
No hubo bugs de codigo. Un hallazgo de higiene de repositorio, no atribuible a esta
sesion: el working tree traia `documentar.R` marcado como `deleted` desde antes de
empezar (el archivo se habia borrado del disco entre el cierre del v15 y la apertura del
v16). Se restauro con `git checkout -- documentar.R` (39.905 bytes, coincide con el
escaner). No se identifico la causa del borrado; queda como diagnostico pendiente
(seccion 11). Ademas, la auditoria de apertura marco `.DS_Store` como posible deuda; al
verificar con `git ls-files` se confirmo que NO estan trackeados (el `.gitignore` ya
tiene el patron, linea 16): falsa deuda por confundir el escaner (filesystem) con el
indice de Git (regla A20). El titular limpio los `.DS_Store` del disco a mano.

## 7. Aprendizajes y restricciones descubiertas

### A25 (NUEVO) — El render de la ficha no se subordina a la disponibilidad del dato
- **Regla:** que el pipeline genere y embeba un dato (p. ej. `matricula_grado`) no obliga
  al motor a mostrarlo. La decision de que se muestra es de producto, no tecnica: el
  grado existe en el JSON pero no corresponde a una vista de categorias de desempeño, y
  se retira del render. El dato puede quedar embebido (inerte) hasta una limpieza de
  pipeline separada.
- **Principio:** B.3 (cambios quirurgicos) + separacion producto/dato. Contexto: se
  retiro el consumo en el motor (c.79) sin tocar el pipeline; el desacople del JSON queda
  como pendiente propio.

### A26 (NUEVO) — Layout de la ficha por filas, no por columnas de enseñanza
- **Regla:** el desglose por tipo de enseñanza se renderiza como filas a todo el ancho,
  una por tipo, nunca como columnas horizontales por enseñanza. Hay establecimientos con
  5+ tipos de enseñanza; un layout de columnas por enseñanza no escala. El encabezado de
  columnas ("Nivel" / "N° de estudiantes") va por bloque-año, porque cada año es
  independiente.
- **Principio:** B.1 (no operar sobre supuestos: validar contra el caso real de 5+
  enseñanzas). Contexto: decision de diseño D2 del titular.

### A24 (reforzada) — Spot-check por ambos lados (presencia y ausencia)
- **Regla (ampliada):** ademas de exigir que las celdas de presencia existan en crudo y
  publicado, el spot-check ahora certifica la AUSENCIA simetrica de combinaciones que la
  fuente no publica (`SPOT_AUSENCIAS`): crudo 0 + publicado sin fila = PASS. media/2016
  es el caso canonico. La funcion de ausencia NO hace `stop()` ante 0 (0 es el resultado
  esperado).
- **Principio:** B.1. Contexto: cierra DT-spot-check-ausencia.

## 8. Decisiones de diseno

### D25 (NUEVA) — Rediseño D2 de la ficha y eliminacion del detalle por grado
- **Decision:** la seccion "Trayectoria y matricula por año" usa un layout de filas a
  todo el ancho (cabecera año+categoria, subtitulo de matricula del nivel, filas de
  enseñanza, total destacado, encabezado de columnas por año). Se elimina el detalle por
  grado (1°-8°) del render.
- **Alternativas descartadas:** (a) columnas horizontales por tipo de enseñanza
  (descartada: no escala a 5+ enseñanzas); (b) tabla pura año×categoria×cifras
  (descartada: perdia el desglose por enseñanza); (c) conservar la expansion por grado
  (descartada por el titular: detalle excesivo para una vista de categorias).
- **Justificacion:** aprovecha el ancho de la ficha, escala a cualquier numero de
  enseñanzas, y elimina un nivel de detalle (grado) que no corresponde al proposito de la
  vista.
- **Implicancia:** `matriculaPorGrado`/`MATG`/`GRADO_LABELS` quedaron sin uso y se
  retiraron del motor (c.79); `matricula_grado` sigue en el JSON hasta una limpieza de
  pipeline (pendiente nuevo).

### D24 (v15), D23 (v14), D21, D22 (v13) y previas — vigentes sin cambios.

## 9. Constantes y parametros vigentes
[Tabla del v15 sin cambios de CALCULO. El motor cambio solo en presentacion; el pipeline
y el JSON no se tocaron.
- `SPOT_CELDAS` (en `spot_check_publicado.R`): 6 celdas ancla de presencia, sin cambios.
  NUEVO: `SPOT_AUSENCIAS` (lista de constantes nombradas) con la combinacion
  media/2016 como ausencia simetrica certificada. `SPOT_CAT_REALES` sin cambios.
- Constantes de auditoria (`tests/`) sin cambios.
Valores del motor sin cambios de calculo: `anio_vigente`=2019, `anio_matricula_vigente`=
2025, filtro de grado cod_ense2 IN (2,5,7) en el PIPELINE (el motor ya no lo consume),
`CAT_REALES`, copy institucional. Clases CSS retiradas del motor: `.ee-ense-toggle`,
`.ee-grado-*`, `.ee-detail-ense`, `.ee-detail-ense-title`. Clase nueva:
`.ee-detail-ense-head`.]

## 10. Arquitectura de archivos
Referencia al escaner del cierre: el ultimo snapshot sellado es `20260614_141327`; los
snapshots `133903`→`143652` se commitearon en c.76 (poda retencion=2). NOTA: conviene
correr el escaner al inicio de la sesion 17 para reflejar el estado post-v16 (el motor y
el spot-check cambiaron de tamaño/contenido). Sin cambios estructurales de carpetas.
Archivos modificados en la sesion: `33_motor_template.html` (template del motor),
`docs/index.html` + `40_salidas/motor_categoria.html` (motor regenerado),
`tests/spot_check_publicado.R` (modo ausencia), `50_documentacion/estructura/`
(snapshots). `documentar.R` restaurado (no modificado). Arbol de Git limpio y pusheado al
cierre. Commits de la sesion (todos en origin/main):
`0e74548` (eliminar grado), `1535110` (D2), `599b3df` (snapshots), `b4b5596` (encabezado),
`1ed0524` (quitar sufijo), `2d6e570` (retiro codigo muerto), `796b6aa` (motor publicado
D2), `87c9a7c` (ausencia spot-check), `f823b60` (motor publicado limpieza), mas el commit
del traspaso.

## 11. Pendientes y ruta sugerida

### Inventario de pendientes
- **Desacoplar `matricula_grado` del JSON embebido (NUEVO, menor-medio).**
  Tipo: deuda tecnica / limpieza de pipeline. El motor ya no consume `matricula_grado`
  (c.79), pero `33_generar_html.R` lo sigue generando y embebiendo en el JSON → dato
  inerte que infla el peso del motor. Accion: modificar el generador para no incluir
  `matricula_grado` (y `grado_labels` si solo servia al grado), regenerar y re-auditar.
  Complejidad: baja-media. Precaucion: TOCA pipeline (cambio de salida); requiere
  spot-check + auditoria tras regenerar. Insumo: `30_procesamiento/33_generar_html.R`.
- **Investigar el borrado de `documentar.R` (NUEVO, diagnostico).**
  Tipo: higiene de repositorio. El archivo aparecio como `deleted` en el working tree al
  abrir la sesion; se restauro, pero la causa es desconocida (¿proceso externo?, ¿error
  de sesion previa?, ¿sincronizacion?). Accion: entender por que se borro antes de que
  reaparezca. Complejidad: baja. Sin cambio de codigo necesariamente.
- **Consolidar backlog 74-80 (NUEVO, administrativo).**
  Tipo: documentacion. Agregar las entradas 74-80 al `backlog_consolidado.md` y
  recalcular ambas tablas sobre 80 (regla A22). Revisar si "Interfaz / visualizacion"
  supera el 25% tras el salto de +4. Complejidad: baja.
- **DT-template (deuda tecnica, diferida) — modularizar `33_motor_template.html`.**
  Tipo: deuda tecnica. Heredado. Template monolitico (~126 KB, CSS sin tokenizar), la
  deuda mayor. Complejidad: alta. Precaucion: refactor de riesgo, sesion dedicada con
  snapshot previo y criterio de build identico byte-a-byte. AHORA es mas oportuno: la
  sesion 16 toco el template a fondo y hay contexto fresco de su estructura; aun asi,
  sigue siendo una sesion propia, no un apendice. Diferir salvo decision explicita.
- **Observaciones de `suitedoc` (para `herramientas_dev`, NO para este repo).** Sin
  cambios respecto al v15: (a) lucide via CDN; (b) `dec_block()` con `id=""` deja espacio
  inicial. Se anotan para el mantenedor del paquete.

### Pendientes del v15 cerrados en v16
- DT-spot-check-ausencia: CERRADO (c.80, modo de ausencia simetrica). De los pendientes
  vivos heredados, DT-template sigue abierto (diferido).

### Evaluacion de deuda tecnica
- Deuda mayor sin cambio: el template monolitico (DT-template), ahora con contexto fresco.
- Resuelto en v16: DT-spot-check-ausencia. Codigo muerto del grado retirado del motor.
- Friccion nueva controlada: `matricula_grado` inerte en el JSON (pendiente de desacople);
  `documentar.R` con borrado de causa desconocida (pendiente de diagnostico).

### Auditoria de cierre (politica 5.6)
- #2 pipeline corre de cero sin intervencion manual: Si (no se toco; el motor se regenera
  con `regenerar_motor()`).
- #5 cada transformacion critica tiene check: Si (no se agregaron transformaciones de
  calculo; el spot-check se reforzo con el modo de ausencia).
- #6 outputs reproducibles e idempotentes: Si (cambio solo de presentacion; cifras
  identicas verificadas con spot-check 6/6 + ausencia).
- #7 decisiones metodologicas como constantes nombradas: Si (`SPOT_AUSENCIAS` es lista de
  constantes; sin numeros magicos nuevos).
- #8 nombres sin tildes, ñ ni espacios: Si (clases CSS y archivos en ASCII; el texto
  visible "N° de estudiantes" es contenido, no nombre de archivo).
- "No" pendiente: la consolidacion del backlog 74-80 (regla A22) queda como pendiente
  administrativo (seccion 11), no se cerro en la sesion.

### Ruta sugerida para la sesion 17
1. Administrativo de apertura: correr el escaner (reflejar post-v16) y consolidar el
   backlog 74-80 con tablas recalculadas sobre 80 (A22).
2. Barato y conectado con el hilo: desacoplar `matricula_grado` del JSON embebido (cierra
   el ciclo del grado de raiz; reduce el peso del motor). Toca pipeline → regenerar +
   auditar.
3. Diagnostico: investigar el borrado de `documentar.R`.
4. Si hay apetito de deuda mayor: DT-template (modularizacion), en sesion dedicada con
   snapshot y criterio de build identico.
**Diferir:** DT-template salvo decision explicita; observaciones de `suitedoc` (van a
`herramientas_dev`).

## 12. Instrucciones especificas para la proxima sesion
- 🔒 Agregacion de categoria = conteo de EE. La matricula (ense2 y grado) es contexto,
  nunca pondera agregaciones.
- 🔒 Basica y media nunca se mezclan. El grado vive DENTRO de su cod_ense2 (en el
  pipeline; el motor ya no muestra grado).
- 🔒 La categoria mantiene cobertura 2016-2019 (anio_vigente=2019); la media no tiene
  2016. La matricula es 2016-2025 (vigente de tamaño 2025). NO mezclar.
- 🔒 `docs/index.html` versionado para Pages; `40_salidas/motor_categoria.html`
  regenerable, ignorado. No editar `docs/` ni `40_salidas/` a mano.
- 🔒 El motor conserva los 3 placeholders del pipeline (`__D3_INLINE__`,
  `__PAKO_INLINE__`, `__JSON_DATA__`); NUNCA dejarlos inyectados al guardar el template.
- 🔒 La ficha de establecimiento usa el layout D2 (filas a todo el ancho), SIN detalle
  por grado, CON encabezado de columnas por año ("Nivel" / "N° de estudiantes"). Es el
  estado APROBADO v16; partir de el para futuros cambios de UI (A18/A19).
- 🔒 `matricula_grado` sigue embebido en el JSON pero el motor NO lo consume. Si se
  desacopla, es cambio de pipeline (regenerar + auditar).
- 🔒 `run_all()` corre el pipeline completo; el atajo es `regenerar_motor()` (= only=33).
  La AUDITORIA de cifras NO es parte del pipeline (D23); se corre a mano desde `tests/`.
- 🔒 El backlog vive in extenso en `backlog_consolidado.md` (sin rango); es la fuente de
  verdad del conteo. Los traspasos agregan solo el delta. PENDIENTE: consolidar 74-80.
- 🔒 La documentacion narrativa se genera con `suitedoc` desde `documentar.R` (cfg desde
  cero, A23/D24).
- ⚠️ NO re-leer los CSV nacionales. El insumo de grado se genera en
  `slep_analisis_matricula` (OneDrive).
- ⚠️ NO confundir el escaner (filesystem) con el indice de Git. Verificar con
  `git ls-files` antes de afirmar que algo esta versionado (A20). Los `.DS_Store` NO
  estan trackeados (ya ignorados).
- ⚠️ `documentar.R` aparecio borrado del working tree en la apertura del v16 (causa
  desconocida, restaurado). Vigilar; si reaparece, diagnosticar la causa.
- ⚠️ El spot-check verifica presencia (`SPOT_CELDAS`) Y ausencia simetrica
  (`SPOT_AUSENCIAS`); las funciones de ausencia NO hacen `stop()` ante 0 (0 es el PASS).
- ✅ ANTES de modificar el template: leer el archivo completo; el layout D2 es la
  referencia APROBADA v16 (A18/A19).
- ✅ ANTES de retirar codigo del motor: mapear referencias con grep y confirmar que NO
  hay uso vivo antes de borrar.
- ✅ TODO comando de terminal con ruta completa desde la raiz del proyecto; para git,
  `git -C /Users/tomgc/Projects/slep_categoria_desempeno ...`. No asumir directorio
  actual ni usar `cd`.
- ✅ Para regenerar el HTML del motor: `regenerar_motor()`. Para certificar cifras:
  `source(here::here("tests","auditar_cifras.R"))` + `spot_check_publicado.R`.

## 13. Fragmentos de codigo de referencia
[Conservar los del v15 (cfg construida desde cero para suitedoc; celdas ancla como lista).
Añadir el patron del modo de ausencia del spot-check (la forma correcta de certificar una
combinacion que la fuente no publica):]
```r
# spot_check_publicado.R: ausencia simetrica. Una celda de SPOT_AUSENCIAS (sin
# `categoria`) certifica que una combinacion nivel/anio NO existe ni en crudo ni en
# publicado. La funcion de publicado NO hace stop() ante 0: 0 es el resultado esperado.
SPOT_AUSENCIAS <- list(
  list(tipo = "slep", nom = "Costa Central", nivel = "media", anio = 2016L)
  # media no tiene 2016 en la fuente -> crudo 0 + publicado sin fila = PASS.
)

spot_publicado_ausencia_slep <- function(celda) {
  cod_objetivo <- mapa_slep |>
    dplyr::filter(.data$nombre_slep == celda$nom) |>
    dplyr::distinct(cod_slep) |>
    dplyr::pull(cod_slep) |>
    as.character()
  idx <- which(
    ter$tipo_entidad == celda$tipo &
    ter$nivel == celda$nivel &
    ter$anio == celda$anio
  )
  idx <- idx[ter$cod_entidad[idx] %in% cod_objetivo]
  length(idx)   # 0 esperado; NO stop()
}
```
```r
# EnseItem ya NO recibe `di` ni renderiza grado: fila simple etiqueta + cifra.
function EnseItem({ d }) {
  return (
    <li className={"ee-ense-item" + (d.nivel ? " has-cat" : "")}>
      <div className="ee-ense-head">
        <span className="ee-ense-label">{d.label + ":"}</span>
        <span className="ee-ense-mat">{fmtInt(d.matricula)}</span>
      </div>
    </li>
  );
}
```

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 17 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; leelo desde ahi.
> Retomamos slep_categoria_desempeno en sesion 17. La sesion 16 rediseño la ficha de
> establecimiento ("Trayectoria y matricula por año") a un layout de filas a todo el
> ancho (D2): se elimino el detalle por grado, se agrego un encabezado de columnas por
> año ("Nivel" / "N° de estudiantes"), se quito una redundancia de texto y se retiro el
> codigo muerto resultante en el motor (sin tocar el pipeline; `matricula_grado` sigue
> embebido en el JSON). Ademas se cerro DT-spot-check-ausencia: el spot-check certifica
> ahora la ausencia simetrica de combinaciones no publicadas (media/2016). Motor
> regenerado y desplegado; spot-check 6/6 + 1 ausencia OK; todo pusheado, arbol limpio.
> Pendientes vivos: consolidar el backlog 74-80 y correr el escaner (administrativo de
> apertura); desacoplar `matricula_grado` del JSON (toca pipeline); investigar el borrado
> de `documentar.R` (causa desconocida); DT-template diferida. Adjunto el traspaso v16 y
> el escaner.

### Documentos para la proxima sesion
1. Protocolo en knowledge base (no se adjuntan): POLITICA_PROYECTO.md,
   SETTINGS_Y_PROMPTS_OPERACIONALES.md.
2. Opcionales segun foco: `30_procesamiento/33_generar_html.R` (si se desacopla
   `matricula_grado`); `33_motor_template.html` (si se sigue con UI o se modulariza el
   template); `tests/spot_check_publicado.R` + `tests/auditar_cifras.R` (si se re-audita
   tras tocar el JSON); `backlog_consolidado.md` (para consolidar 74-80).
3. Especificos (SI se adjuntan): `traspaso_cierre_v16.md`; `estructura_actual.md`
   (correr el escaner al abrir para reflejar el estado post-v16).

### Nota final obligatoria
El motor (`33_motor_template.html`) esta en su estado APROBADO v16 (ficha D2, sin grado,
con encabezado de columnas). Si se adjunta para trabajo de UI o modularizacion, partir de
esa version y conservar los 3 placeholders. El backlog in extenso es la fuente de verdad
del conteo (`backlog_consolidado.md`, sin rango) y tiene PENDIENTE la consolidacion de las
entradas 74-80. `matricula_grado` sigue en el JSON aunque el motor no lo use (pendiente de
desacople). `documentar.R` fue restaurado tras aparecer borrado (causa desconocida). Si
algun archivo listado cambio entre sesiones, adjuntar la version mas actualizada al abrir
y avisarlo en el mensaje de apertura.
