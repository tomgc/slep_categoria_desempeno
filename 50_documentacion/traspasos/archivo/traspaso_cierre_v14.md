# Traspaso de cierre v14 — slep_categoria_desempeno

## 1. Identificacion
- **Proyecto:** slep_categoria_desempeno
- **Version:** v14
- **Fecha:** 2026-06-13
- **Sesion:** 14 — foco en cerrar dos deudas diferidas del v13: (a) consolidar
  el backlog 1-66 in extenso (DT-backlog-documental); (b) auditar las cifras
  publicadas del motor por doble calculo (protocolo 4.5). Ambas COMPLETADAS y
  desplegadas a remoto. No se toco el pipeline ni el motor.
- **Entorno:** R 4.5.2 en Positron, macOS aarch64. Modelo: Claude Opus 4.8.
- **Archivos principales agregados (ninguno modificado del pipeline):**
  - `50_documentacion/activa/backlog_consolidado_1-66.md`: NUEVO. Backlog
    historico completo, 66 entradas autonomas + objetivo + nota metodologica +
    tabla tematica recalculada + estadistico por sesion.
  - `tests/auditar_cifras_helpers.R`: NUEVO. Camino B (recalculo independiente
    desde el crudo, sin reusar contar_territorial) + comparadores con
    tolerancias nombradas.
  - `tests/auditar_cifras.R`: NUEVO. Orquestador de 4 familias (cada una en
    tryCatch); reporte sellado + alias en `tests/reportes/`.
  - `tests/spot_check_publicado.R`: NUEVO. Spot-check de extremo a extremo
    (crudo -> JSON embebido en docs/index.html).
  - `.gitignore`: +1 regla (`tests/reportes/`, salida regenerable).

## 2. Resumen ejecutivo
La sesion 14 abrio sobre el v13 con el motor estable y desplegado, sin foco de UI
y con dos deudas diferidas vivas. Se cerraron ambas. Primero se consolido el
backlog completo 1-66 in extenso, reconstruyendo las 66 entradas desde el
registro detallado (seccion 4) de cada traspaso de origen, ya que el detalle se
arrastraba por referencia desde el v11; durante la verificacion se detecto y
corrigio a la raiz un descuadre latente de la tabla tematica (venia sumando mal
desde versiones previas), recontando la asignacion por intencion primaria entrada
por entrada hasta cuadrar en 66 (categoria lider 20%, bajo el umbral de
subdivision). Segundo, se implemento la auditoria de cifras del protocolo 4.5 con
el patron de tres scripts (helpers + orquestador + spot-check) en `tests/`: las 4
familias (distribucion territorial, sin vigente, cierre por-EE, invariante de
referencia) salieron en verde con tolerancia exacta, y el spot-check confirmo que
la cifra publicada en docs/index.html coincide con el crudo (Costa Central/basica/
2019/MEDIO: 26 de 56). Todo versionado en commits tematicos y pusheado; el reporte
regenerable quedo ignorado. Arbol de Git limpio al cierre.

## 3. Estado al cierre

### Que funciona (ultima ejecucion exitosa)
- **Motor y pipeline INTACTOS:** no se toco ningun script del pipeline (30-33) ni
  el template. El motor sigue en su estado aprobado del v13. Ultima corrida del
  pipeline registrada: v13 (2026-06-13 22:28/20:09).
- **Backlog consolidado 1-66 COMPLETO Y VERIFICADO:** 66 entradas autonomas,
  numeracion continua sin huecos ni duplicados (verificado con `seq 1 66` vs
  extraccion); tabla tematica suma 66 (verificada entrada por entrada);
  granularidad declarada (1-11 conservan el formato de su origen, 12-66
  individuales). Versionado en commit `998cfd3`, pusheado.
- **Auditoria de cifras EN VERDE Y VERIFICADA:** `source(here::here("tests",
  "auditar_cifras.R"))` corrio las 4 familias OK (0 discrepancias cada una);
  `spot_check_publicado.R` OK (crudo == publicado). Reporte en
  `tests/reportes/auditoria_cifras.md`. Scripts versionados en commit `729dbf0`.
- **Higiene de Git CORRECTA:** `tests/reportes/` ignorado (commit `b6e0634`);
  snapshot del escaner commiteado (`2a5d0c0`); `git status --short` vacio al
  cierre (arbol limpio, todo en remoto).

### Que no funciona / pendiente
- No hay nada roto. Deudas diferidas sin cambio: DT-template (modularizar el
  template monolitico, riesgo alto). Dos notas menores nuevas (ver seccion 11).

### Delta respecto a v13
v13 dejo el motor estable con dos deudas diferidas (DT-template y
DT-backlog-documental). v14 CIERRA DT-backlog-documental (backlog in extenso) y
AGREGA una capa de verificacion independiente de las cifras publicadas (auditoria
4.5) que el proyecto no tenia. DT-template sigue diferida sin agravarse. Cero
cambios en el pipeline, el motor o el calculo. Solo documentacion + tests + un
ajuste de `.gitignore`.

## 4. Registro detallado de cambios

### Cambio 67 — Backlog consolidado 1-66 in extenso (DT-backlog-documental)
- **Categoria:** Documentacion de proyecto.
- **Que (`50_documentacion/activa/backlog_consolidado_1-66.md`, NUEVO):** se
  materializo el detalle cronologico completo 1-66 como entradas autonomas. Se
  reconstruyeron las entradas desde el registro detallado (seccion 4) de cada
  traspaso de origen: 1-11 del v01 (lista sin numeracion individual, conservada
  asi), 12-66 individuales (v02-v13). Incluye objetivo del proyecto (con notas
  v03-v13), nota metodologica, tabla tematica (12 categorias), resumen estadistico
  por sesion (13 sesiones, total 66) y delta de la consolidacion.
- **Por que (C.11):** el detalle se arrastraba por referencia ("copiar integro
  1-54/1-58/1-62") desde el v11; el backlog es la unica fuente de verdad del
  conteo historico (politica 2.2.5) y en estado referenciado no cumplia esa funcion.
- **Como se verifico (B.4):** numeracion continua 1-66 sin huecos ni duplicados
  (`diff <(seq 1 66) <(extraccion)` vacio); tabla tematica suma 66 (conteo entrada
  por entrada con script de asignacion). Versionado y pusheado (`998cfd3`).
- **Hallazgo corregido a la raiz:** la tabla tematica heredada sumaba mal (un
  primer borrador replico el error y dio 61, no 66). Se reconto la asignacion por
  intencion primaria entrada por entrada; la categoria lider bajo a 20% (13/66),
  corrigiendo un descuadre latente que venia de versiones previas, no solo el
  sintoma de esta consolidacion.
- **Limitacion declarada:** los cambios 1-11 conservan la granularidad de su
  origen (el v01 nunca los numero como "Cambio N"); no se inventaron entradas.

### Cambio 68 — Auditoria de cifras publicadas (protocolo 4.5, patron de 3 scripts)
- **Categoria:** Validacion / integridad.
- **Que (`tests/`, 3 archivos NUEVOS):**
  - `auditar_cifras_helpers.R`: camino B independiente. Recalcula la distribucion
    territorial y el sin-vigente desde el crudo (`categoria_rbd.parquet`) SIN
    reusar `contar_territorial()` del paso 32 (usa `summarise` + `tidyr::complete`
    en vez de `crossing` + `left_join`). Replica las reglas de inclusion del 32
    (comuna excluye NA, nacional incluye todo, SLEP inner join). Tolerancias
    nombradas (`AUD_TOL_CONTEO = 0L`, `AUD_TOL_PCT = 1e-9`) y bloque de referencia
    (`AUD_REF_ENTIDAD`/`AUD_REF_NIVEL`).
  - `auditar_cifras.R`: orquestador de 4 familias, cada una en `tryCatch` (una que
    falla no aborta las demas). F1 distribucion territorial, F2 sin vigente, F3
    cierre por-EE (nacional == `n_distinct(rbd)` del crudo), F4 invariante de
    referencia. Emite reporte sellado + alias en `tests/reportes/`.
  - `spot_check_publicado.R`: cierra el tramo parquet -> JSON -> HTML
    descomprimiendo el `atob(...)` embebido en docs/index.html y comparando una
    celda ancla contra el crudo.
- **Por que (C.11):** el pipeline tenia validacion interna (6 invariantes del paso
  32, controles de calce del 33) pero NO un auditor independiente que recalculara
  las cifras finales por un camino distinto al de produccion y cerrara el tramo
  hasta el HTML publicado. Es exactamente el doble calculo del protocolo 4.5.
- **Como se verifico (B.4):** ejecucion real en R 4.5.2: 4 familias OK (0
  discrepancias cada una); spot-check OK (crudo `n_ee=26, n_cat=56` == publicado).
  El esquema de `categoria_rbd` reconstruido desde el uso en 32/33 resulto correcto
  (0 errores de columna en el primer run). Versionado (`729dbf0`).
- **Decision de diseno (D23):** la auditoria vive en `tests/`, NO como paso del
  pipeline. No produce artefacto del motor; es verificacion a demanda y no debe
  acoplarse al `run_all()` reproducible (politica 1.3 p8, tests sin numerar).

### Cambio 69 — Higiene de Git: ignorar reporte regenerable + snapshot del escaner
- **Categoria:** Migracion y publicacion / DevOps.
- **Que:** (a) `.gitignore` +1 regla `tests/reportes/` (el reporte de la auditoria
  es salida regenerable, como `motor_categoria.html`); (b) commit del snapshot del
  escaner generado durante la sesion (poda de retencion 2 aplicada:
  `20260613_223325` reemplaza a `20260613_222451`).
- **Por que (C.11):** mantener fuera de Git lo regenerable (defensa contra ruido en
  el historial); versionar el snapshot del escaner es la convencion del proyecto.
- **Como se verifico (B.4):** `git status --short tests/` vacio tras el ignore;
  `git status --short` vacio al cierre. Commits `2a5d0c0` (escaner) y `b6e0634`
  (ignore), ambos pusheados.

## 5. Backlog acumulativo
[A partir de esta sesion el backlog vive in extenso en
`50_documentacion/activa/backlog_consolidado_1-66.md` (cambio 67). Este traspaso
NO lo reproduce: referencia ese archivo como fuente de verdad y le agrega las
entradas 67-69 de esta sesion. Total cronologico 66 -> 69.
- Cambios nuevos: 67 (backlog consolidado, "Documentacion de proyecto"), 68
  (auditoria de cifras, "Validacion / integridad"), 69 (higiene de Git,
  "Migracion y publicacion / DevOps").
- Delta de taxonomia: sin categorias nuevas. "Documentacion de proyecto" 5->6;
  "Validacion / integridad" 1->2; "Migracion y publicacion / DevOps" 1->2.
- Accion para la proxima consolidacion: agregar 67-69 al
  `backlog_consolidado_1-66.md` (renombrarlo a `backlog_consolidado.md` sin
  rango fijo en el nombre, para que crezca por delta sin renombres) y recalcular
  la tabla tematica sobre 69. Verificar que siga sumando.]

## 6. Bugs de la sesion
No hubo bugs de codigo del pipeline (no se toco). Una imprecision propia del
asistente, corregida en la misma sesion (no cuenta como bug del pipeline): el
primer borrador de la tabla tematica del backlog consolidado heredo un descuadre
de las tablas previas y sumaba 61 en vez de 66; se detecto al verificar la suma
contra el detalle cronologico y se corrigio recontando entrada por entrada. Refuerza
la regla de verificar el conteo contra la fuente de verdad (cronologico), no
contra la tabla heredada.

## 7. Aprendizajes y restricciones descubiertas

### A21 (NUEVO) — El camino B de una auditoria debe ser codigo distinto, no una copia
- **Regla:** para que el doble calculo del protocolo 4.5 tenga valor, el camino B
  (recalculo) debe usar una implementacion DISTINTA a la de produccion, no la misma
  funcion. Aqui el camino B usa `summarise` + `tidyr::complete` donde el paso 32
  usa `crossing` + `left_join`: si ambos compartieran `contar_territorial`, un error
  de logica se replicaria identico en los dos lados y la comparacion daria un falso
  verde. La independencia es la fuente del valor, no la redundancia.
- **Principio:** B.4 (criterio de exito real, no aparente). Contexto: las 4 familias
  en verde certifican porque los dos caminos son genuinamente independientes.

### A22 (NUEVO) — Verificar el conteo del backlog contra el cronologico, no contra la tabla heredada
- **Regla:** la tabla tematica de un backlog puede arrastrar un descuadre entre
  versiones (sumar distinto al detalle cronologico). Al consolidar o recalcular,
  la fuente de verdad es el detalle cronologico (politica 2.2.5, regla 7), no la
  tabla de la version anterior. Recontar la asignacion por intencion primaria
  entrada por entrada, no copiar los totales heredados.
- **Principio:** B.1 (no operar sobre supuestos heredados). Contexto: el descuadre
  61/66 se corrigio recontando desde el cronologico.

## 8. Decisiones de diseno

### D23 (NUEVA) — La auditoria de cifras vive en tests/, no en el pipeline
- **Decision:** los tres scripts del protocolo 4.5 van a `tests/`, se corren a
  demanda con `source()`, y NO son un paso del `00_run_all.R`.
- **Alternativa descartada:** un `34_auditar_cifras.R` en `30_procesamiento/`
  invocable como paso opcional del orquestador. Descartada: la auditoria no produce
  artefacto del motor ni alimenta el pipeline; acoplarla al `run_all()` reproducible
  contradice que el orquestador solo orquesta produccion (politica seccion 4).
- **Justificacion:** `tests/` es la ubicacion canonica de verificacion (politica
  1.3 p8). La auditoria es independiente por diseño (A21); su lugar es fuera del
  flujo de produccion.
- **Implicancia:** nadie garantiza que la auditoria se corra antes de cada deploy
  (nota menor de la seccion 11). Es un trade-off aceptado a favor de la pureza del
  orquestador.

### D21, D22 (v13) y previas — vigentes sin cambios.

## 9. Constantes y parametros vigentes
[Tabla del v13 sin cambios de CALCULO. El motor y el pipeline no se tocaron.
Constantes NUEVAS, solo en los scripts de auditoria (`tests/`), sin efecto sobre el
producto:
- `AUD_TOL_CONTEO = 0L` (tolerancia exacta para conteos de EE).
- `AUD_TOL_PCT = 1e-9` (tolerancia de punto flotante para pct).
- `AUD_CAT_REALES = c("ALTO","MEDIO","MEDIO-BAJO","INSUFICIENTE")` (replica de
  `CAT_REALES` del paso 32, independiente por diseño).
- `AUD_REF_ENTIDAD = "Costa Central"`, `AUD_REF_NIVEL = "basica"` (bloque ancla F4).
- `SPOT_*` en spot_check_publicado.R: celda ancla del spot-check (Costa Central /
  basica / 2019 / MEDIO).
Valores del motor sin cambios: `anio_vigente`=2019, `anio_matricula_vigente`=2025,
filtro de grado cod_ense2 IN (2,5,7), `CAT_REALES`, copy institucional.]

## 10. Arquitectura de archivos
Referencia al escaner del cierre: `00_escanear_proyecto.R` corrido 2026-06-13
22:33 (16 carpetas, 92 archivos; poda de retencion = 2 aplicada). Nuevos archivos
versionados, todos fuera del pipeline:
`50_documentacion/activa/backlog_consolidado_1-66.md`,
`tests/auditar_cifras_helpers.R`, `tests/auditar_cifras.R`,
`tests/spot_check_publicado.R`. Nuevo directorio `tests/reportes/` (ignorado por
Git, contiene el reporte regenerable de la auditoria). Sin cambios estructurales de
carpetas. `.gitignore` +1 regla. Arbol de Git limpio al cierre (`git status`
vacio). Commits de la sesion: `998cfd3` (backlog), `729dbf0` (scripts auditoria),
`2a5d0c0` (snapshot escaner), `b6e0634` (gitignore tests/reportes).

## 11. Pendientes y ruta sugerida

### Inventario de pendientes
- **DT-template (deuda tecnica, diferida) — modularizar `33_motor_template.html`.**
  Tipo: deuda tecnica. Heredado del v13 sin cambios. El template monolitico
  (~126 KB, CSS sin tokenizar) es la deuda mayor. Complejidad: alta. Precaucion:
  refactor de riesgo, en sesion dedicada con snapshot previo y criterio de build
  identico byte-a-byte. Diferir salvo que un trabajo de UI grande lo exija.
- **DT-spot-check-cobertura (NUEVO, menor) — ampliar el spot-check a varias celdas.**
  Tipo: mejora de test. `spot_check_publicado.R` verifica una sola celda ancla
  (Costa Central/basica/2019/MEDIO). La auditoria completa (F1-F4) ya cubre todas
  las cifras a nivel parquet; el spot-check solo cierra el tramo JSON->HTML en un
  punto. Complejidad: baja (parametrizar `SPOT_*` a una lista de celdas).
  Criterio de exito: N celdas ancla verificadas de extremo a extremo, todas OK.
- **DT-auditoria-no-integrada (NUEVO, menor, nota) — la auditoria se corre a mano.**
  Tipo: proceso/DevOps. Por D23 la auditoria no es paso del pipeline; nadie
  garantiza que se corra antes de cada deploy. Opcion futura: nota en el README o
  un recordatorio en el flujo de publicacion. NO integrarla al `run_all()`
  (contradiria D23). Complejidad: baja.
- **DT-backlog-renombre (NUEVO, menor) — renombrar el backlog a nombre sin rango.**
  Tipo: documentacion. `backlog_consolidado_1-66.md` lleva el rango en el nombre;
  crecera por delta y obligaria a renombrar cada sesion. Al agregar 67-69,
  renombrar a `backlog_consolidado.md` (sin rango) para que sea un documento vivo
  estable. Complejidad: baja (un `git mv` + actualizar referencias).

### Evaluacion de deuda tecnica
- Deuda mayor sin cambio: el template monolitico (DT-template).
- Resuelto en v14: DT-backlog-documental (backlog in extenso). Agregada: capa de
  verificacion independiente de cifras (no existia). Sin friccion nueva en el
  pipeline (no se toco).

### Auditoria de cierre (politica 5.6)
- #2 pipeline corre de cero: Si (no se toco; ultima corrida limpia en v13).
- #5 validaciones criticas: Si (ademas, se AGREGO una capa de auditoria
  independiente externa al pipeline).
- #6 reproducible/idempotente: Si (sin cambios de calculo).
- #8 nombres sin tildes/ñ: Si (los archivos nuevos cumplen; nota:
  `backlog_consolidado_1-66.md` usa guion, valido).
- No quedan "no" sin convertir en pendiente.

### Ruta sugerida para la sesion 15
1. Si el titular trae trabajo de UI grande: evaluar PRIMERO DT-template
   (modularizar) como prerequisito de estabilidad, con snapshot previo y criterio
   de build identico.
2. Oportunista y barato: agregar las entradas 67-69 al backlog consolidado y
   renombrarlo sin rango (DT-backlog-renombre); ampliar el spot-check a varias
   celdas (DT-spot-check-cobertura). Ambas de baja complejidad.
3. Si no: atacar lo que el titular priorice; el motor esta estable, desplegado y
   con cifras certificadas.
**Diferir:** modularizacion del template salvo que un trabajo de UI la exija.

## 12. Instrucciones especificas para la proxima sesion
- 🔒 Agregacion de categoria = conteo de EE. La matricula (ense2 y grado) es
  contexto, nunca pondera agregaciones.
- 🔒 Basica y media nunca se mezclan. El grado vive DENTRO de su cod_ense2.
- 🔒 La categoria mantiene cobertura 2016-2019 (anio_vigente=2019); la matricula es
  2016-2025 y su vigente de tamano es 2025 (anio_matricula_vigente). NO mezclar.
- 🔒 El parquet de grado se filtra a cod_ense2 IN (2,5,7) en el motor.
- 🔒 `docs/index.html` versionado para Pages; `40_salidas/motor_categoria.html`
  regenerable, ignorado. No editar `docs/` a mano.
- 🔒 El motor conserva los 3 placeholders del pipeline (`__D3_INLINE__`,
  `__PAKO_INLINE__`, `__JSON_DATA__`); NUNCA dejarlos inyectados al guardar el
  template.
- 🔒 `run_all()` sin argumentos corre el pipeline completo (reproducibilidad). El
  atajo es `regenerar_motor()` (= only = 33). La AUDITORIA de cifras NO es parte
  del pipeline: se corre a mano desde `tests/` (D23).
- 🔒 El backlog vive in extenso en
  `50_documentacion/activa/backlog_consolidado_1-66.md`; es la fuente de verdad del
  conteo. Los traspasos a partir del v14 referencian ese archivo y agregan solo el
  delta de la sesion.
- ⚠️ NO re-leer los CSV nacionales en este proyecto. El insumo de grado se genera en
  `slep_analisis_matricula` (OneDrive).
- ⚠️ NO confundir el escaner (filesystem) con el indice de Git. Verificar con
  `git ls-files` antes de afirmar que algo esta versionado (A20).
- ⚠️ Al recalcular el backlog, verificar el conteo contra el DETALLE CRONOLOGICO,
  no contra la tabla tematica heredada (A22).
- ✅ ANTES de modificar el template: leer el archivo completo; el layout actual es la
  referencia APROBADA (A18/A19).
- ✅ ANTES de tocar una auditoria: el camino B debe ser codigo DISTINTO al de
  produccion, no una copia de las funciones del pipeline (A21).
- ✅ Para regenerar solo el HTML: `regenerar_motor()`. Para certificar cifras:
  `source(here::here("tests", "auditar_cifras.R"))` + `spot_check_publicado.R`.

## 13. Fragmentos de codigo de referencia
[Conservar los del v13. Anadir el patron del camino B independiente de la
auditoria (la forma correcta de un recalculo 4.5 en este proyecto):]
```r
# Camino B (auditoria 4.5): recalculo de la distribucion territorial SIN reusar
# contar_territorial() del paso 32. summarise + complete (no crossing+left_join):
# implementacion distinta para que un error de logica no se replique en ambos
# caminos. Tolerancias como constantes nombradas (AUD_TOL_CONTEO=0, AUD_TOL_PCT=1e-9).
aud_recalcular_distribucion <- function(df_etiquetado) {
  base <- df_etiquetado |>
    dplyr::filter(.data$categoria %in% AUD_CAT_REALES)
  conteo <- base |>
    dplyr::summarise(
      n_ee = dplyr::n(),
      .by = c(tipo_entidad, cod_entidad, nom_entidad, nivel, anio, categoria)
    ) |>
    tidyr::complete(
      tidyr::nesting(tipo_entidad, cod_entidad, nom_entidad, nivel, anio),
      categoria = AUD_CAT_REALES,
      fill = list(n_ee = 0L)
    )
  conteo |>
    dplyr::mutate(
      n_categorizados = sum(.data$n_ee),
      .by = c(tipo_entidad, cod_entidad, nom_entidad, nivel, anio)
    ) |>
    dplyr::mutate(
      pct = dplyr::if_else(.data$n_categorizados > 0,
                           .data$n_ee / .data$n_categorizados, NA_real_),
      n_ee = as.integer(.data$n_ee),
      n_categorizados = as.integer(.data$n_categorizados)
    )
}
```
```r
# F3 — cierre por-EE: el conteo nacional por categoria debe igualar el numero de
# EE distintos (rbd) del crudo en ese nivel x anio. Detecta duplicacion o perdida
# de EE en la agregacion. Llaves character; full_join para captar ausencias.
nac_C <- df_cat |>
  dplyr::filter(.data$categoria %in% AUD_CAT_REALES) |>
  dplyr::summarise(n_ee_C = dplyr::n_distinct(rbd), .by = c(nivel, anio, categoria))
```

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 15 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; leelo desde ahi.
> Retomamos slep_categoria_desempeno en sesion 15. La sesion 14 cerro dos deudas
> diferidas: el backlog consolidado 1-66 in extenso (DT-backlog-documental) y la
> auditoria de cifras del motor por doble calculo (protocolo 4.5, 4 familias en
> verde + spot-check de extremo a extremo OK). No se toco el pipeline ni el motor.
> Todo versionado y pusheado; arbol de Git limpio. Queda diferida la modularizacion
> del template monolitico (DT-template) y cuatro pendientes menores (ver traspaso).
> Adjunto el traspaso v14 y el escaner.

### Documentos para la proxima sesion
1. Protocolo en knowledge base (no se adjuntan): POLITICA_PROYECTO.md v6,
   SETTINGS_Y_PROMPTS_OPERACIONALES.md v1.
2. Opcionales segun foco: `33_motor_template.html` (si se modulariza el CSS o se
   toca UI); `backlog_consolidado_1-66.md` (si se agregan 67-69 o se renombra);
   `tests/spot_check_publicado.R` (si se amplia la cobertura del spot-check);
   `33_generar_html.R` / `32_agregar_territorial.R` (si se vuelve a auditar o se
   toca el calculo).
3. Especificos (SI se adjuntan): `traspaso_cierre_v14.md`; `estructura_actual.md`.

### Nota final obligatoria
El motor (`33_motor_template.html`) sigue en su estado APROBADO del v13 (no se toco
en v14). Si se adjunta para trabajo de UI, partir de esa version y conservar los 3
placeholders. El backlog in extenso es ahora la fuente de verdad del conteo
(`backlog_consolidado_1-66.md`); los traspasos solo agregan delta. Si algun archivo
listado cambio entre sesiones, adjuntar la version mas actualizada al abrir y
avisarlo en el mensaje de apertura.
