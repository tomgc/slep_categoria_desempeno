# Traspaso de cierre v09 — slep_categoria_desempeno

## 1. Identificacion

- **Proyecto:** slep_categoria_desempeno
- **Version:** v09
- **Fecha:** 2026-06-13
- **Sesion:** 9 — foco en P-matricula-ficha: incorporar matricula por tipo de
  ensenanza a la ficha del establecimiento (cifra del nivel vigente + panel
  expandido enriquecido con desglose por tipo de ensenanza por anio). Es el
  primer cambio que toca el pipeline (insumo + generador) desde v06.
- **Entorno:** R 4.5.2 en Positron, macOS aarch64. Modelo: Claude Opus 4.8.
- **Archivos principales modificados:**
  `30_procesamiento/33_generar_html.R` (carga del nuevo parquet, diccionarios
  `ENSE2_LABELS`/`ENSE2_A_NIVEL`, bloque columnar `matricula_lst`, validaciones);
  `30_procesamiento/33_motor_template.html` (indice `MAT_IX`, helpers de
  matricula, cifra vigente en la fila, panel expandido rediseniado, CSS nuevo);
  `docs/index.html` (regeneracion). Insumo nuevo:
  `20_insumos/matricula_rbd_ense.parquet` (402 KB, versionado). Script externo
  generador del insumo: `03_generar_matricula_rbd_ense.R` (vive en el proyecto
  hermano `slep_analisis_matricula`, NO en este repo).

---

## 2. Resumen ejecutivo

La sesion 9 cerro P-matricula-ficha, el unico pendiente abierto al cierre de v08,
y lo hizo con un alcance mayor al previsto. El bloqueo de v08 (faltaba el dato de
matricula) se resolvio via un one-off de analisis paralelo (`slep_analisis_matricula`)
que perfilo los 10 CSV nacionales del MINEDUC con DuckDB y produjo un informe que
fundamento, contra los datos reales, la granularidad de presentacion. El titular
reviso la decision de dominio que v08 habia dejado anotada (matricula total simple)
y la **cambio**: opto por la opcion 3 (matricula del nivel de la categoria con el
total del EE entre parentesis), y ademas pidio enriquecer el panel expandido (que
hasta v08 solo repetia la categoria ya visible) con el desglose de matricula por
tipo de ensenanza, anio a anio. Se generó un insumo agregado nuevo
(`matricula_rbd_ense.parquet`, grano rbd x anio x cod_ense2, 85.594 filas, 402 KB,
una sola foto historica 2016-2019) en el proyecto hermano, se integro al generador
como bloque JSON propio (grano distinto al de categoria; se cruzan en el cliente,
no se fusionan en R), y se rediseno la ficha en dos capas: cifra del nivel vigente
en la fila colapsada (con total del EE entre parentesis condicional) y panel
expandido con categoria + matricula del nivel + desglose por tipo de ensenanza +
total del establecimiento. Build end-to-end limpio: invariantes intactos (10.945
EE, 41.244 filas RBD, 2016-2019, vigente 2019). JSX validado por transpilacion.
Tres commits tematicos pusheados (`b12dc1e`, `82ee172`, `718b141`).

---

## 3. Estado al cierre

### Que funciona (ultima ejecucion exitosa)
- `run_all(only = 33)` / `source("33_generar_html.R")` regenera el motor
  (verificado 2026-06-13, HTML 1305 KB, plantilla 109237 chars). Invariantes
  intactos: 10.945 EE, 41.244 filas RBD, anios 2016-2019, vigente 2019. Las
  validaciones `stopifnot` del bloque matricula pasaron (dominio cod_ense2,
  total constante por EE, filas calzan con el parquet).
- Insumo `20_insumos/matricula_rbd_ense.parquet`: 85.594 filas, 11.988 RBD,
  2016-2019, 402 KB. Generado una sola vez en `slep_analisis_matricula`
  (`03_generar_matricula_rbd_ense.R`), validado (5 checks: llave unica, total
  constante, suma == total, sin NAs, cobertura). Matriculas anuales calzan al
  digito con el escaneo previo (3.550.949 / 3.558.394 / 3.582.448 / 3.624.343).
- Ficha del EE — fila colapsada: muestra "Matricula 2019: N" tras el RBD, con
  total del EE entre parentesis solo si difiere de la cifra del nivel (EE de
  nivel unico no muestran parentesis; EE basica+media si).
- Ficha del EE — panel expandido (al click): por anio (descendente), categoria
  del nivel + "N matriculados en Educacion Basica/Media", y debajo el desglose
  "Matricula por tipo de ensenanza" con cada cod_ense2 y su cifra (los con
  categoria resaltados, el resto como contexto) cerrando con "Total
  establecimiento". Verificado visualmente por el titular.
- Resto del motor sin cambios respecto a v08 (modo territorio con tres buckets,
  hoja comparativa con boton limpiar, panel metodologico alineado a fuente oficial).

### Que no funciona / pendiente
- Sin pendientes bloqueantes de codigo. Sin pendientes de codigo abiertos.

### Delta respecto a v08
- v08 alineo el panel metodologico con la fuente oficial y cerro P-taxonomia-meta
  sin tocar pipeline. v09 es la primera sesion desde v06 que toca el pipeline:
  agrega un insumo nuevo, un bloque JSON nuevo y rediseña la ficha del EE en dos
  capas. Cambia (con aprobacion explicita del titular) la decision de dominio que
  v08 habia anotado: de "matricula total simple" a "matricula del nivel + total
  entre parentesis + desglose por tipo de ensenanza" (opcion 3). Sin cambios
  estructurales de carpetas.

---

## 4. Registro detallado de cambios

### Cambio 45 — Insumo agregado de matricula por tipo de ensenanza (one-off + integracion)
- **Categoria:** Datos y normalizacion.
- **Que:** se genero `matricula_rbd_ense.parquet` (grano rbd x anio x cod_ense2,
  2016-2019) en el proyecto hermano `slep_analisis_matricula` mediante
  `03_generar_matricula_rbd_ense.R`, y se deposito en `20_insumos/` de este repo
  (versionado). Esquema: `rbd` (chr), `anio` (int), `cod_ense2` (chr, "1".."8"),
  `matricula` (int, COUNT(*) por grano), `matricula_total_ee` (int, suma de TODOS
  los cod_ense2 del EE ese anio, desnormalizado/repetido por rbd x anio).
- **Por que (C.11):** la ficha necesita matricula por tipo de ensenanza para
  cumplir la opcion 3 elegida. El grano cod_ense2 (no solo basica/media) habilita
  el desglose completo del panel expandido. La fuente nacional (10 CSV, ~5,4 GB)
  se lee UNA vez fuera de este proyecto (foto historica inmutable); aqui solo
  entra el agregado liviano.
- **Como se verifico (B.4):** 5 validaciones en el generador (llave unica,
  total constante por rbd x anio, suma de cod_ense2 == total, sin NAs, cobertura
  2016-2019), todas en verde; control COUNT(*) vs DISTINCT mrun = sin duplicados
  a ese grano en los 4 anios; matriculas anuales calzan al digito con el escaneo
  del informe.
- **Decisiones de lectura:** matricula = COUNT(*) (cifra estandar MINEDUC, cada
  fila es una matricula); SIN filtro por `estado_estab` (la matricula es hecho
  historico del anio; el universo final lo define el join contra RBD con
  categoria); `normalize_names = true` + `all_varchar = true` en DuckDB resuelve
  la inconsistencia de nombres mayusculas/minusculas entre anios (2016-2017 en
  minusculas, 2018-2019 en MAYUSCULAS) y mantiene las llaves como texto.
- **Dependencias:** insumo consumido por `33_generar_html.R` (cambio 46).

### Cambio 46 — Integracion de matricula en el generador (bloque JSON propio)
- **Categoria:** Pipeline R.
- **Que (`33_generar_html.R`):**
  - Carga de `20_insumos/matricula_rbd_ense.parquet` con guard de existencia
    (mensaje claro que apunta al script generador si falta).
  - Diccionarios `ENSE2_LABELS` (8 tipos de ensenanza, Anexo III) y `ENSE2_A_NIVEL`
    (mapa cod_ense2 -> nivel del motor: "2"->basica, "5"/"7"->media), expuestos
    en `meta`.
  - Bloque columnar `matricula_lst` (rbd, anio, cod_ense2, matricula,
    matricula_total_ee) agregado al JSON tras `rbd_lst` e incluido en `json_root`.
  - Validaciones `stopifnot`: filas calzan con el parquet, cod_ense2 en dominio
    1..8, matricula_total_ee constante dentro de rbd x anio.
- **Por que (C.11):** la matricula tiene grano cod_ense2, distinto al de categoria
  (nivel). Fusionarla en R con `categoria_rbd` habria forzado un grano artificial;
  viaja como bloque separado y el cliente la cruza. Mantiene cada cifra rastreable
  a un unico nivel (invariante de tests del informe del one-off, §8.3).
- **Como se verifico (B.4):** build end-to-end limpio; las validaciones pasaron
  (el script habria abortado antes del paso [4] si fallaban); conteos de las otras
  estructuras (territorial, sin_vigente, rbd) sin cambio; invariantes intactos.
- **Dependencias:** alimenta el indice `MAT_IX` del template (cambio 47).

### Cambio 47 — Cifra de matricula vigente en la fila colapsada de la ficha (iteracion 1)
- **Categoria:** Diseno UI — Modo establecimiento.
- **Que (`33_motor_template.html`):**
  - Desempaque de `ENSE2_LABELS`/`ENSE2_A_NIVEL` desde `meta`.
  - Indice `MAT_IX` (rbd -> anio -> {porEnse2: Map(cod->mat), total}) y helpers
    `matriculaNivel(rbd, nivel, anio)` (media = suma de cod_ense2 5 y 7),
    `matriculaTotalEE(rbd, anio)`, `matriculaDesglose(rbd, anio)`; expuestos en
    `CatData`.
  - El objeto `ee` de `getEstablecimientos` gana `nivel`, `mat_nivel_vig`,
    `mat_total_vig` (matricula del nivel y total del EE en el anio vigente).
  - En `ee-row-meta`: tras el RBD, "Matricula 2019: N" con total del EE entre
    parentesis solo si `mat_total_vig != mat_nivel_vig`. Formato chileno via
    `fmtInt` (ya existente).
- **Por que (C.11):** la cifra vigente da el tamanio del EE en la fila sin abrir
  el detalle; el parentesis condicional evita repetir la cifra cuando el EE es de
  nivel unico (76,7% de los EE en 2025 segun el informe), reduciendo ruido visual.
- **Como se verifico (B.4):** transpilacion babel sin errores; verificacion visual
  del titular (EE de nivel unico sin parentesis; EE basica+media con "N (total)").

### Cambio 48 — Panel expandido enriquecido con desglose por tipo de ensenanza (iteracion 2)
- **Categoria:** Diseno UI — Modo establecimiento.
- **Que (`33_motor_template.html`):** rediseno del panel que se abre al click.
  Antes (hasta v08) solo listaba la categoria por anio, repitiendo lo ya visible
  en la fila colapsada (sin valor agregado). Ahora, por anio (descendente):
  - Encabezado: categoria del nivel + "N matriculados en Educacion Basica/Media".
  - Bloque "Matricula por tipo de ensenanza": cada cod_ense2 que el EE imparte ese
    anio con su matricula; los tipos con categoria (basica, media) resaltados
    (`.has-cat`), el resto (parvularia, adultos, especial) como contexto tenue.
  - Cierre: "Total establecimiento" (suma de todos los tipos).
  - CSS nuevo: `.ee-detail-row` pasa de fila unica a columna; clases
    `.ee-detail-head`, `.ee-detail-matnivel`, `.ee-detail-ense*`, `.ee-ense-*`,
    `.ee-row-matricula`. Todos los tokens usados existen en `:root`; sin
    `text-transform: uppercase`.
- **Por que (C.11):** el titular observo que el panel expandido no aportaba nada
  que no estuviera ya arriba. El desglose por tipo de ensenanza da el panorama
  completo del establecimiento (que niveles imparte, con cuanta matricula cada
  uno, anio a anio) sin violar el invariante: cada categoria sigue atada a su
  nivel y los niveles sin categoria se muestran como contexto, no como si tuvieran
  etiqueta.
- **Como se verifico (B.4):** transpilacion babel sin errores; marcadores A2
  intactos (los 5); verificacion visual del titular ("se ve bien").
- **Tension declarada:** media HC (5) y TP (7) son dos cod_ense2 pero una sola
  categoria de media. Se resolvio sumando 5+7 bajo la categoria de media (la
  Agencia categoriza "media" como nivel unico). Desglosar HC/TP como categorias
  separadas habria sido falso.

---

## 5. Backlog acumulativo

### Objetivo del proyecto
slep_categoria_desempeno es un motor interactivo (R + HTML autocontenido) que
compara la distribucion de establecimientos por Categoria de Desempeno (Alto /
Medio / Medio-Bajo / Insuficiente) de la Agencia de Calidad, entre comunas,
SLEPs, regiones y el nivel nacional, separando basica y media. Pipeline en R
(xlsx → parquet → JSON embebido → HTML), publicado en GitHub Pages. Para el
equipo de Monitoreo del SLEP Costa Central, desde 2026. Datos publicos.

(Nota v03: la opcion "nacional" del selector se elimino en la sesion 3 por
volumen de EE; se agrego seleccion de establecimiento individual. El objetivo
permanente del proyecto no cambia.)

(Nota v04: el proyecto quedo publicado en GitHub Pages en
`https://tomgc.github.io/slep_categoria_desempeno/`. El objetivo permanente no
cambia.)

(Nota v05: se agrego una segunda hoja de comparacion entre territorios. El
objetivo permanente no cambia.)

(Nota v06: el modo EE se rediseño con trayectoria detallada al click y lista de
establecimientos sin categoria vigente; se consolido la orquestacion en un unico
punto de entrada. El objetivo permanente no cambia.)

(Nota v07: el modo territorio muestra ahora los establecimientos sin medicion 2019
como bucket visible aparte; la hoja comparativa gana un boton de limpieza. El
objetivo permanente no cambia.)

(Nota v08: el panel de notas metodologicas se alineo con la caracterizacion oficial
de la Agencia (definiciones por grado, ponderacion 67/33). El objetivo permanente no
cambia.)

(Nota v09: la ficha del establecimiento incorpora matricula por tipo de ensenanza
(cifra del nivel vigente en la fila + desglose completo por anio en el panel
expandido), a partir de un insumo agregado nuevo. La matricula es dato de contexto
del EE, no entra en ninguna agregacion de categoria. El objetivo permanente no
cambia.)

### Nota metodologica del conteo
Un "cambio" es una solicitud distinguible del titular, no las acciones tecnicas
que la implementan. No cuentan los errores del asistente corregidos de
inmediato; si cuentan los bugfixes reportados por el titular. Clasificacion por
intencion primaria. Fuentes: registro de la sesion.

### Clasificacion tematica

| Categoria | N | % | Descripcion |
|---|---|---|---|
| Diseno UI — Motor base y diseno | 9 | 19 | Grillas (v01); motor HTML paso 33 + iteraciones UI (v03) |
| Scaffold inicial | 9 | 19 | Estructura, scaffold, repo, decisiones v01 |
| Diseno UI — Modo establecimiento | 6 | 13 | Trayectoria EE detallada + lista sin-vigente (v06); comentario tope, bucket sin-medicion (v07); cifra de matricula vigente y panel expandido enriquecido (v09) |
| Diseno UI — Hoja comparativa | 6 | 13 | Comparativa, multi-seleccion, limites, lotes visuales (v05) |
| Migracion y publicacion / DevOps | 5 | 10 | Auditoria seguridad, gobernanza, LICENSE, CI, README migracion (v04) |
| Pipeline R | 4 | 8 | Pasos 30-32 de procesamiento; integracion de matricula al generador (v09) |
| Documentacion de proyecto | 3 | 6 | 5 archivos de decision v03/v04 (v06); reconciliacion de taxonomia (v07); decision taxonomia-meta (v08) |
| Datos y normalizacion | 2 | 4 | Esquema xlsx, normalizacion categoria; insumo de matricula por tipo de ensenanza (v09) |
| Documentacion (en producto) | 2 | 4 | Panel de notas metodologicas (v05); alineacion con fuente oficial (v08) |
| Orquestacion | 2 | 4 | 00_run_all.R (v02); consolidacion paso 33 + archivado de stub (v06) |

(Nota de conteo: el detalle cronologico es la fuente de verdad y tiene 48 entradas
(1-48). La tabla tematica suma 48, cuadrando con el cronologico. Las cuatro entradas
nuevas de v09 son los cambios 45 (Datos y normalizacion: insumo de matricula), 46
(Pipeline R: integracion al generador), 47 y 48 (Diseno UI — Modo establecimiento:
cifra vigente y panel expandido). No se reescriben entradas previas; los % se
recalculan sobre 48 y ninguna categoria supera el 25%.)

### Resumen estadistico por sesion
| Sesion | Traspasos | N cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 11 | (v01) | Scaffold y diseno |
| 2 | v02 | 4 | Opus 4.8 | Pipeline R 30-32 + orquestador |
| 3 | v03 | 6 | Opus 4.8 | Motor HTML (paso 33) + iteraciones UI |
| 4 | v04 | 6 | Opus 4.8 | Migracion a GitHub + Pages |
| 5 | v05 | 8 | Opus 4.8 | Hoja comparativa + notas + pulido visual |
| 6 | v06 | 3 | Opus 4.8 | Orquestacion + decisiones + trayectoria EE |
| 7 | v07 | 4 | Opus 4.8 | Comentario tope + bucket sin-medicion + boton limpiar + taxonomia |
| 8 | v08 | 2 | Opus 4.8 | Alineacion panel con fuente oficial + decision taxonomia-meta |
| 9 | v09 | 4 | Opus 4.8 | Matricula por tipo de ensenanza en la ficha (insumo + generador + ficha 2 capas) |
| **Total** | | **48** | | |

### Detalle cronologico
- **Sesion 1 (cambios 1-11):** ver traspaso v01 (scaffold, repo, diseno de
  datos y UI, decisiones 1-3).
- **Sesion 2 (cambios 12-15):** 12 auxiliares; 13 leer/normalizar; 14
  agregacion territorial; 15 orquestador + archivo de stub.
- **Sesion 3 (cambios 16-21):** 16 generador `33_generar_html.R`; 17 template
  base; 18 iteracion UI tanda 1; 19 tanda 2 (azul institucional); 20 tanda 3
  (trayectoria rediseñada, filtro comuna, fix pct); 21 tanda 4 (selector EE,
  filtro dependencia, leyenda, distribucion desde EE).
- **Sesion 4 (cambios 22-27):** 22 auditoria de seguridad; 23 `gobernanza_datos.md`;
  24 `LICENSE` (MIT con clausula de datos) + header del generador; 25 workflow CI;
  26 publicacion Pages (modelo B); 27 README de migracion.
- **Sesion 5 (cambios 28-35):** 28 hoja comparativa; 29 panel de notas
  metodologicas (P2); 30 multi-seleccion con checkboxes; 31 limite a 7; 32 limite
  a 10; 33 lote visual 1; 34 formato "% (n)" + tabla tarjeta; 35 heatmap por
  categoria + hover gris.
- **Sesion 6 (cambios 36-38):** 36 orquestacion del paso 33 (IDs 30-33, stub
  `00_build.R` archivado, comentarios stale limpiados); 37 documentacion de 5
  decisiones (cobertura_temporal, paleta_categorias, visibilidad_repo,
  modelo_pages, licencia); 38 rediseno del modo EE (motivo en rbd_lst del
  generador; `EeRow` clickeable con trayectoria en texto; `SinVigente` con lista
  de EE; indice `RBD_MOTIVO`).
- **Sesion 7 (cambios 39-42):** 39 correccion del comentario stale "tope de 4" →
  "tope de 10" en dos ubicaciones (L1655, L2015); 40 bucket de establecimientos
  sin medicion 2019 (`sinMedicionEE` en `App`, segunda lista en `SinVigente`
  rotulada "Sin categoria de desempeno en 2019"; solo-template, el dato ya viajaba
  via L1555); 41 boton "Limpiar" en la hoja comparativa (`cmp-clear-btn`,
  `setEntidades([])`); 42 reconciliacion de la taxonomia del backlog.
- **Sesion 8 (cambios 43-44):** 43 alineacion del panel metodologico con la
  caracterizacion oficial de la Agencia (4 definiciones reescritas al fraseo por
  grado, parrafo de ponderacion 67/33, nota de conteo declarada como eleccion
  deliberada, nota de cobertura temporal con los tres vacios 2019/2020-2021/2022;
  solo-template); 44 decision P-taxonomia-meta: no se crea categoria "Meta /
  backlog" (1 entrada meta = 2%, bajo el umbral de absorcion).
- **Sesion 9 (cambios 45-48):** 45 insumo agregado de matricula por tipo de
  ensenanza (`matricula_rbd_ense.parquet`, grano rbd x anio x cod_ense2,
  2016-2019, generado en `slep_analisis_matricula` via one-off de analisis con
  DuckDB; depositado en `20_insumos/`); 46 integracion al generador
  `33_generar_html.R` (carga del parquet, diccionarios ENSE2_LABELS/ENSE2_A_NIVEL,
  bloque columnar `matricula_lst`, validaciones de dominio y total constante); 47
  cifra de matricula del nivel vigente en la fila colapsada de la ficha (indice
  `MAT_IX`, helpers matriculaNivel/matriculaTotalEE/matriculaDesglose, total del
  EE entre parentesis condicional); 48 panel expandido enriquecido (categoria +
  matricula del nivel + desglose por tipo de ensenanza por anio + total del EE;
  CSS nuevo; media = 5+7 sumados bajo la categoria de media).

### Delta del backlog
4 entradas nuevas (45-48). "Datos y normalizacion" 1→2 (incluye 45); "Pipeline R"
3→4 (incluye 46); "Diseno UI — Modo establecimiento" 4→6 (incluye 47, 48). Total
cronologico 44→48. La tabla tematica recalcula porcentajes sobre 48 (los enteros se
mantienen; los % se ajustan por el nuevo denominador) y sigue cuadrando con el
cronologico; ninguna categoria supera el 25%. P-matricula-ficha queda cerrado en
esta sesion (cambios 45-48).

---

## 6. Bugs de la sesion

No aplica en esta sesion: no hubo bugs de codigo en este proyecto. El bloque babel
del template se valido por transpilacion (`@babel/preset-env` +
`@babel/preset-react`) sin errores antes de la entrega.

Nota lateral (no es de este proyecto): el script generador del one-off
(`03_generar_matricula_rbd_ense.R`, que vive en `slep_analisis_matricula`) tenia un
print de tibble bajo `source(echo = TRUE)` que disparaba `invalid 'na.print'
specification` (mismo patron que el script 02 de ese proyecto). Se corrigio
reemplazando `print(tibble)` por bucle de `message()` con `formatC(big.mark=".")`.
El parquet ya se habia escrito correctamente antes del error; la correccion solo
limpia el resumen final. No afecta a este repo.

---

## 7. Aprendizajes y restricciones descubiertas

### A11 — Una decision de dominio anotada en un traspaso puede cambiar; documentar el cambio, no silenciarlo
- **Regla:** v08 dejo anotado "matricula total simple, por nivel como evolucion
  futura". En v09 el titular reviso esa decision y eligio la opcion 3 (mas rica).
  El traspaso nuevo registra el cambio explicitamente en vez de actuar como si la
  decision previa no existiera. Las decisiones de dominio no son contratos
  inmutables; son el mejor juicio con la informacion de esa sesion.
- **Principio:** C.11 (transparencia del cambio); B.1 (no operar sobre supuestos:
  re-confirmar la decision de dominio al reabrir, no asumir la del traspaso).
- **Contexto:** el one-off de analisis aporto datos (23,3% de EE con basica+media)
  que cambiaron el calculo: la cifra total simple mezclaria niveles para 1 de cada
  4 EE en la capa de presentacion, lo que hizo preferible la opcion 3.

### A12 — Aislar el analisis pesado en un proyecto hermano mantiene limpio el proyecto de producto
- **Regla:** los 5,4 GB de CSV nacionales se leyeron en `slep_analisis_matricula`
  (proyecto de analisis), no en `slep_categoria_desempeno` (proyecto de producto).
  Este ultimo recibe solo el agregado liviano (402 KB) como insumo versionado. La
  lectura pesada es una foto unica del pasado; no se repite.
- **Principio:** B.2 (simplicidad: el producto no carga con la complejidad del
  analisis); separacion de responsabilidades.
- **Contexto:** `slep_categoria_desempeno` se mantiene como raiz unificada pura de
  datos publicos livianos. El insumo de matricula es solo un parquet mas, no una
  dependencia de los CSV originales.

### A13 — Grano distinto = bloque JSON distinto, cruzado en el cliente, no fusionado en R
- **Regla:** la matricula (grano cod_ense2) y la categoria (grano nivel) viajan
  como bloques separados en el JSON; el cliente los cruza via indices. Fusionarlas
  en R habria forzado un grano artificial y mezclado dos cifras de naturaleza
  distinta. Asi cada cifra queda rastreable a un unico nivel.
- **Principio:** C.6 (rigor de tipado/llaves); invariante de tests del informe
  (§8.3: ninguna cifra agregada combina basica con media).
- **Contexto:** media = suma de cod_ense2 5 y 7 se resuelve en el helper del
  cliente (`matriculaNivel`), no duplicando filas en el parquet.

### A6 (reafirmado) / A1 / A2 (vigentes)
- A6: P-matricula-ficha confirmo que verificar el dato ANTES de prometer la feature
  era correcto; el one-off produjo el dato y la decision sobre datos reales antes de
  tocar el render.
- A1: el flujo reemplazar → confirmar bytes/transpilacion → regenerar se respeto
  (transpilacion babel antes de regenerar el HTML).
- A2: los 5 marcadores de version (`function EeRow`, `RBD_MOTIVO`, `LIMITE = 10`,
  `cmp-clear-btn`, `sinMedicionEE`) se confirmaron intactos antes y despues de editar.

---

## 8. Decisiones de diseno

### D12 — Granularidad de matricula en la ficha: opcion 3 (nivel + total entre parentesis)
- **Decision:** la ficha muestra la matricula del NIVEL de la categoria (basica o
  media, nunca sumados) con el total del EE entre parentesis, condicional (solo si
  difiere). Reemplaza la decision anotada en v08 ("matricula total simple").
- **Alternativas consideradas:** (1) solo total del EE — descartada: mezcla niveles
  en una cifra para el 23,3% de los EE, violando el invariante en la capa de
  presentacion; (2) solo por nivel sin total — insuficiente: pierde la referencia
  de tamanio del EE.
- **Justificacion:** la opcion 3 preserva el invariante (cifra del nivel
  monovalente) y entrega el tamanio del EE como contexto. Fundamentada contra datos
  reales en el informe del one-off (`50_documentacion/activa/decisiones/`).
- **Implicancia:** "total del EE" = todos los cod_ense2 (parvularia, basica, media,
  adultos, especial), el tamanio completo del establecimiento, no solo los niveles
  evaluados.

### D13 — Panel expandido = panorama del EE, no repeticion de la fila colapsada
- **Decision:** el panel que se abre al click muestra, por anio, categoria +
  matricula del nivel + desglose de matricula por TODOS los tipos de ensenanza +
  total del EE. Antes solo repetia la categoria ya visible arriba.
- **Alternativa:** mantener el panel como lista de categorias por anio.
- **Justificacion:** un panel que repite lo visible no aporta valor. El desglose
  por tipo de ensenanza da el panorama completo del EE. Los niveles sin categoria
  (parvularia, adultos, especial) se muestran como contexto, claramente
  distinguidos de los que tienen categoria (resaltados), para no sugerir que tienen
  etiqueta de desempeno.
- **Tension resuelta:** media HC (5) + TP (7) suman bajo una sola categoria de media
  (la Agencia categoriza media como nivel unico). Desglosar HC/TP como categorias
  separadas seria falso; se muestran como lineas de contexto si se quisiera ese
  detalle en el futuro.

### D14 — Matricula = COUNT(*), sin filtro por estado del establecimiento
- **Decision:** la matricula se cuenta como filas del CSV (COUNT(*)), sin filtrar
  por `estado_estab`.
- **Alternativas:** COUNT(DISTINCT mrun) (descartada: a grano rbd x cod_ense2 no
  hay duplicados, verificado; COUNT(*) es la cifra estandar MINEDUC); filtrar
  `estado_estab == 1` desde 2018 (descartada: la matricula es hecho historico del
  anio, y el universo final lo define el join contra RBD con categoria, no el
  estado de funcionamiento actual).
- **Justificacion:** simplicidad (un solo criterio para los 4 anios) y fidelidad
  (un EE que tuvo 300 estudiantes en 2017 los tuvo, este abierto hoy o no).

---

## 9. Constantes y parametros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `PASOS` (ids) | 30, 31, 32, 33 | 00_run_all.R | Sin cambios |
| `LIMITE` (territorios comparables) | 10 | 33_motor_template.html | Sin cambios |
| `PCT_DIGITS` | 4 | 33_generar_html.R | Sin cambios |
| Alfa heatmap | 0.10 + t*0.55 | 33_motor_template.html | Sin cambios |
| ANIO_VIGENTE | 2019 (= max anios) | JSON (meta) | Se recalcula con SIMCE 2025 |
| CAT_ORDEN / CAT_COLORS | Insuficiente→Alto | 33_generar_html.R | Sin cambios |
| `ENSE2_LABELS` | 8 tipos (Anexo III) | 33_generar_html.R | Nuevo v09 |
| `ENSE2_A_NIVEL` | 2→basica, 5/7→media | 33_generar_html.R | Nuevo v09 |
| `ANIOS_OBJETIVO` (insumo matricula) | 2016:2019 | 03_generar_matricula_rbd_ense.R (proyecto hermano) | Nuevo v09 |
| `BASICA_ENSE2` / `MEDIA_ENSE2` | 2 / c(5,7) | informe del one-off; helper del cliente | Nuevo v09 (regla de corte) |
| Ponderacion CdD (en panel) | 67% estandares / 33% resto | 33_motor_template.html | Texto del panel (v08), no constante de calculo |

---

## 10. Arquitectura de archivos

Re-ejecutar el escaner antes de cerrar y referenciar el snapshot. La estructura
sigue la canonica de la politica (decenas, naming, ubicacion). v09 agrega un
archivo al repo: `20_insumos/matricula_rbd_ense.parquet` (insumo publico
versionado). El script generador del insumo NO vive en este repo (vive en
`slep_analisis_matricula`); se conserva su copia en `50_documentacion/` solo si se
decide documentarlo (ver pendiente DT). El informe del one-off se versiono en
`50_documentacion/activa/decisiones/` (renombrado a la convencion de decisiones).
Sin cambios estructurales de carpetas.

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

Sin pendientes de codigo abiertos al cierre de v09. P-matricula-ficha (el unico
abierto en v08) quedo cerrado.

**P-matricula-grado (idea futura, no comprometida)**
- **Descripcion:** desglose de matricula por grado (`cod_grado`) dentro de cada
  nivel, mayor detalle en el panel expandido.
- **Tipo:** funcionalidad (requiere regenerar el insumo a grano rbd x anio x
  cod_grado).
- **Complejidad:** Media. El insumo nuevo se generaria igual que el actual,
  cambiando el GROUP BY; el render del panel ganaria un sub-nivel.
- **Precaucion:** no comprometer sin pedido explicito; el panel actual ya es rico.

**P-matricula-actual (idea futura, no comprometida)**
- **Descripcion:** incorporar matricula del anio mas reciente disponible (2025) a
  la ficha, como referencia de tamanio actual, separada de la serie 2016-2019 que
  acompania la categoria.
- **Precaucion:** la categoria solo llega a 2019; la matricula 2025 seria dato de
  contexto puro, claramente separada de la trayectoria de categoria para no sugerir
  una categoria 2025 inexistente.

### Evaluacion de deuda tecnica
- **DT — documentar el script generador del insumo.** `03_generar_matricula_rbd_ense.R`
  vive en `slep_analisis_matricula`. Conviene dejar una nota en
  `50_documentacion/activa/decisiones/` de este repo que apunte a el y al informe,
  para que la procedencia del parquet sea rastreable desde aqui. Baja prioridad.
- **Zona fragil:** ninguna activa.
- **Oportunidad (heredada):** `33_motor_template.html` crecio a ≈109 KB (de ≈103 en
  v08). Sigue siendo un HTML unico autocontenido; modularizar romperia esa
  propiedad. Monitorear, no actuar (B.2).

### Auditoria de cierre (politica 5.6)
- #2 ¿Pipeline corre de cero sin intervencion manual? → **Si** (build end-to-end
  verificado esta sesion). Matiz: el insumo de matricula se genera una vez fuera
  (one-off); dentro del proyecto, `33` lo consume como cualquier parquet.
- #5 ¿Cada transformacion critica tiene check de validacion? → **Si**; el generador
  gano validaciones del bloque matricula (dominio cod_ense2, total constante).
- #6 ¿Outputs reproducibles e idempotentes? → Si (regenera identico desde template +
  parquets + insumo de matricula).
- #7 ¿Decisiones metodologicas como constantes nombradas? → Si (ENSE2_*, ANIOS_OBJETIVO,
  reglas de corte).
- #8 ¿Nombres sin tildes/ñ/espacios? → Si (`matricula_rbd_ense.parquet`,
  `03_generar_matricula_rbd_ense.R`).
- Resto: sin cambios respecto a v08.

### Ruta sugerida para la proxima sesion (sesion 10)
Sin pendientes de codigo abiertos. Opciones, segun lo que traiga el titular:
1. Cerrar la DT documental (nota de procedencia del insumo de matricula). Baja
   complejidad, deja el rastro completo.
2. Una de las ideas futuras (P-matricula-grado, P-matricula-actual) si el titular
   las prioriza, cada una con su decision de alcance previa.
3. Si no hay foco de codigo, la sesion 10 puede ser ONE-OFF o una mejora visual
   menor que surja.

**Diferir:** modularizacion del template (no mientras sea HTML unico autocontenido).

---

## 12. Instrucciones especificas para la proxima sesion

- 🔒 Agregacion de categoria = conteo de establecimientos. Jamas ponderacion por
  matricula, jamas GSE. La matricula de la ficha es dato de CONTEXTO del EE, no
  entra en ninguna agregacion de categoria.
- 🔒 Basica y media nunca se mezclan en una cifra agregada. En la ficha: la cifra
  del nivel es monovalente; media = cod_ense2 5+7 sumados (una sola categoria de
  media), nunca sumada con basica.
- 🔒 Matricula y categoria viajan como bloques JSON SEPARADOS (grano cod_ense2 vs
  nivel) y se cruzan en el cliente. No fusionarlas en R (A13).
- 🔒 `matricula_total_ee` = suma de TODOS los cod_ense2 del EE (tamanio completo),
  constante dentro de rbd x anio. No recortarlo a basica+media.
- 🔒 El conteo de "sin categoria vigente" es el del parquet `sin_vigente`
  (autoritativo). Las listas client-side son ayuda de navegacion, no la fuente.
- 🔒 Tres buckets de `vigente`: categoria real / `"s/i"` / `null`. No unificar.
- 🔒 `40_salidas/motor_categoria.html` es fuente regenerable, IGNORADA por Git.
  `docs/index.html` es la copia versionada para Pages. No editar `docs/` a mano.
- 🔒 El panel metodologico es glosa de lectura, no ficha tecnica completa (D10).
- ✅ ANTES de regenerar el insumo de matricula: correrlo en `slep_analisis_matricula`
  (`03_generar_matricula_rbd_ense.R`), NO en este repo; copiar el parquet a
  `20_insumos/` a mano.
- ✅ ANTES de tocar la matricula en el cliente: el grano es rbd x anio x cod_ense2;
  usar los helpers `matriculaNivel` (media = 5+7), `matriculaTotalEE`,
  `matriculaDesglose`. No reimplementar el cruce inline.
- ✅ ANTES de editar `33_motor_template.html` al reabrir: confirmar marcadores A2
  (`function EeRow`, `RBD_MOTIVO`, `LIMITE = 10`, `cmp-clear-btn`, `sinMedicionEE`).
- ✅ ANTES de verificar un cambio del template: (1) reemplazar, (2) transpilar babel,
  (3) regenerar. Nunca regenerar antes de transpilar (A1).
- ✅ ANTES de usar una variable CSS, confirmar que existe en `:root` (bordes
  secundarios: `--border-2`; texto tenue: `--fg-3`).
- ✅ ANTES de cualquier push, `git status` revisado.
- ⚠️ NO reintroducir `00_build.R` (orquestador unico = `00_run_all.R`).
- ⚠️ NO usar "EE" en texto visible al usuario: escribir "establecimientos".
- ⚠️ NO reintroducir `text-transform: uppercase` en ninguna parte del sitio.
- ⚠️ NO re-leer los CSV nacionales (5,4 GB) en este proyecto: el insumo agregado ya
  es la foto historica; solo se regenera en el proyecto hermano si cambia el grano.

---

## 13. Fragmentos de codigo de referencia

### Patron correcto: bloque JSON de grano propio, cruzado en el cliente
```r
# En 33_generar_html.R: la matricula viaja como bloque columnar aparte (grano
# cod_ense2), NO se fusiona con categoria_rbd (grano nivel). El cliente cruza.
matricula_lst <- list(
  rows               = nrow(df_mat_ord),
  rbd                = df_mat_ord$rbd,
  anio               = as.integer(df_mat_ord$anio),
  cod_ense2          = df_mat_ord$cod_ense2,
  matricula          = as.integer(df_mat_ord$matricula),
  matricula_total_ee = as.integer(df_mat_ord$matricula_total_ee)
)
```

### Patron correcto: helper de cruce nivel↔cod_ense2 en el cliente (media = 5+7)
```javascript
// matriculaNivel suma cod_ense2 5 y 7 para "media" (una sola categoria de media);
// "2" para basica. null si el EE no tiene ese nivel ese anio.
function matriculaNivel(rbd, nivel, anio) {
  const porAnio = MAT_IX.get(rbd);
  if (!porAnio) return null;
  const reg = porAnio.get(anio);
  if (!reg) return null;
  const e = reg.porEnse2;
  if (nivel === "basica") return e.has("2") ? e.get("2") : null;
  if (nivel === "media") {
    let s = null;
    if (e.has("5")) s = (s || 0) + e.get("5");
    if (e.has("7")) s = (s || 0) + e.get("7");
    return s;
  }
  return null;
}
```

### Patron correcto: agregacion perezosa con DuckDB y nombres no estables
```r
# normalize_names = true baja todos los nombres a minusculas (2016-2017 vienen en
# minusculas, 2018-2019 en MAYUSCULAS); all_varchar = true mantiene llaves como
# texto. El total del EE se calcula con window en la misma pasada.
from_csv <- function(ruta) {
  sprintf("read_csv_auto('%s', normalize_names = true, all_varchar = true)", ruta)
}
# ... SUM(matricula) OVER (PARTITION BY rbd) AS matricula_total_ee
```

---

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 10 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del Project;
> leelo desde ahi. Retomamos slep_categoria_desempeno en sesion 10. Sin
> pendientes de codigo abiertos; P-matricula-ficha quedo cerrado en v09. Adjunto
> el traspaso v09 y el escaner actual. [Indicar foco: cerrar la DT documental del
> insumo de matricula, una idea futura (matricula por grado / matricula actual), o
> lo que surja.]

### Documentos para la proxima sesion

**1. Protocolo en knowledge base (NO se adjuntan; verificar que esten al dia):**
- `POLITICA_PROYECTO.md` (vigente: v6)
- `SETTINGS_Y_PROMPTS_OPERACIONALES.md` (vigente: v1)

**2. Opcionales segun el foco real:**
- `CLAUDE.md` (si la sesion corre en Claude Code).
- `30_procesamiento/33_motor_template.html` como MOLDE (si se edita la ficha;
  verificar marcadores A2 al cargar).
- `30_procesamiento/33_generar_html.R` (si se toca el JSON o un insumo).
- `03_generar_matricula_rbd_ense.R` (en `slep_analisis_matricula`) si se regenera
  el insumo de matricula a otro grano.

**3. Especificos de la sesion (SI se adjuntan):**
- `50_documentacion/traspasos/traspaso_cierre_v09.md` (este archivo).
- `50_documentacion/estructura/estructura_actual.md` (re-ejecutar el escaner al reabrir).
- El archivo critico para el foco que se elija (si aplica).

### Nota final obligatoria
Si algun archivo listado cambio entre sesiones, adjuntar la version mas
actualizada al abrir y avisarlo en el mensaje de apertura. `33_motor_template.html`
crecio a ≈109 KB en la sesion 9 (cifra de matricula + panel expandido): adjuntar la
version actual, no una previa (A2).
