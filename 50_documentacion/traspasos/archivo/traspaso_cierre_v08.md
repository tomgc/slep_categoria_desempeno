# Traspaso de cierre v08 — slep_categoria_desempeno

## 1. Identificacion

- **Proyecto:** slep_categoria_desempeno
- **Version:** v08
- **Fecha:** 2026-06-13
- **Sesion:** 8 — foco en P-glosa-oficial (alinear el panel metodologico con la
  caracterizacion oficial de la Agencia) y P-taxonomia-meta (decidir si crear
  categoria "Meta / backlog"). Se levanto ademas un pedido nuevo del titular
  (matricula por anio en la ficha del establecimiento), bloqueado por dato.
- **Entorno:** R 4.5.2 en Positron, macOS aarch64. Modelo: Claude Opus 4.8.
- **Archivos principales modificados:** `30_procesamiento/33_motor_template.html`
  (componente `NotasMetodologicas`: 4 definiciones reescritas al fraseo oficial,
  parrafo de ponderacion 67/33, nota de conteo afinada, nota de cobertura temporal
  precisada). Regeneraciones de `40_salidas/motor_categoria.html` y `docs/index.html`.
  Sin cambios en el pipeline R 30-32 ni en `33_generar_html.R`.

---

## 2. Resumen ejecutivo

La sesion 8 cerro los dos pendientes con que abrio. P-glosa-oficial: el titular
entrego una caracterizacion tecnica oficial de las categorias (en reemplazo de la
glosa), contra la cual se reescribieron las 4 definiciones del panel, que aplanaban
la distincion Insuficiente/Medio-Bajo (ambas como "por debajo"); ahora siguen el
fraseo oficial por grado ("muy por debajo" vs "por debajo" vs "similares" vs
"sobresalen", siempre respecto de lo esperado para el contexto). Se agrego un
parrafo de ponderacion (67% estandares de aprendizaje / 33% resto, ajuste por
contexto, calculo separado basica/media) y, como afinamiento de bajo riesgo, se
explicito que el conteo sin ponderacion es una eleccion deliberada del proyecto y se
precisaron los vacios temporales (2019 sin consecuencias, 2020-2021 sin
categorizacion, 2022 no usado). P-taxonomia-meta: se decidio NO crear "Meta /
backlog" (una sola entrada meta = 2%, viola el umbral de absorcion de la politica).
Se levanto un pedido nuevo del titular (matricula por anio en la ficha del EE) que
quedo bloqueado: el dato no esta en el pipeline y el portal de datos abiertos no
expone descarga directa alcanzable desde el contenedor. No hubo bugs de codigo; el
bloque babel se valido por transpilacion. Todo commiteado y pusheado (`30e1874`).

---

## 3. Estado al cierre

### Que funciona (ultima ejecucion exitosa)
- `run_all(only = 33)` regenera el motor (verificado 2026-06-13 10:01, HTML 970 KB,
  plantilla 102844 caracteres confirmando el template editado de esta sesion).
  Invariantes intactos: 10.945 EE, 41.244 filas RBD, anios 2016-2019, vigente 2019.
- Panel "Notas metodologicas": las 4 definiciones siguen el fraseo oficial de la
  Agencia; nota de Categoria de Desempeno incluye la ponderacion 67/33; nota de
  conteo declara la eleccion deliberada de no ponderar; nota de cobertura temporal
  precisa los tres vacios (2019/2020-2021/2022).
- `docs/index.html` actualizado para Pages; commit `30e1874` pusheado.
- Resto del motor sin cambios respecto a v07 (modo territorio con tres buckets, hoja
  comparativa con boton limpiar, modo EE con trayectoria).

### Que no funciona / pendiente
- Sin pendientes bloqueantes de codigo. **P-matricula-ficha (nuevo) queda bloqueado
  por dato**: requiere el "Resumen de Matricula por Establecimiento" del MINEDUC
  (2016-2019), que el titular descargara, mas un cambio de pipeline (insumo + join +
  columna JSON + render en ficha) para v09.

### Delta respecto a v07
- v07 limpio micro-deuda, agrego el bucket sin-medicion y el boton limpiar, y
  reconcilio la taxonomia. v08 alinea el panel metodologico con la fuente oficial
  (contenido), cierra P-taxonomia-meta sin crear categoria nueva, y abre
  P-matricula-ficha como primer pendiente que tocara el pipeline R desde v06. Sin
  cambios estructurales ni en el pipeline R en esta sesion.

---

## 4. Registro detallado de cambios

### Cambio 43 — Alineacion del panel metodologico con la caracterizacion oficial (P-glosa-oficial)
- **Categoria:** Documentacion (en producto).
- **Que (solo template, componente `NotasMetodologicas`):**
  - **4 definiciones reescritas** (nota "Categoria de Desempeno"): de un fraseo que
    aplanaba Insuficiente y Medio-Bajo (ambas "por debajo de lo esperado") al fraseo
    oficial por grado: Insuficiente "muy por debajo", Medio-Bajo "por debajo", Medio
    "similares", Alto "sobresalen", todas "respecto de lo esperado para el contexto
    social".
  - **Parrafo de ponderacion** agregado: 67% Estandares de Aprendizaje + 33% resto
    (puntaje Simce, tendencia, IDPS), ajuste por contexto, calculo separado
    basica/media.
  - **Nota "Conteo" afinada:** segundo parrafo que declara el no-ponderar como
    eleccion deliberada del proyecto (la pregunta es la distribucion de
    establecimientos, no de estudiantes), no un descuido metodologico.
  - **Nota "Cobertura temporal" precisada:** parrafo de vacios reemplazado para
    distinguir 2019 (sin consecuencias), 2020-2021 (sin categorizacion) y 2022 (no
    usado para ordenar).
- **Por que (C.11):** las definiciones heredadas no distinguian el grado entre las
  dos categorias bajas, contradiciendo la fuente oficial de la Agencia; el titular
  entrego una caracterizacion tecnica como referencia autoritativa. Las notas de
  conteo y cobertura se afinaron con la misma fuente (bajo riesgo, sin tocar logica).
- **Como se verifico (B.4):** transpilacion babel (`@babel/preset-env` +
  `@babel/preset-react`) sin errores; `grep` confirma textos viejos eliminados (0) y
  nuevos presentes; placeholder `{CatData.ANIO_VIGENTE}` y marcadores A2 intactos;
  regeneracion limpia (plantilla 102844 chars, +1723 sobre v07); invariantes de datos
  sin cambio.
- **Decision declarada de alcance:** se mantuvo el panel como glosa de lectura. NO se
  agregaron base legal, decretos, etapas de calculo ni IDPS detallados (scope creep
  evitado, B.2). El parrafo 67/33 es el unico dato metodologico nuevo, por pedido
  explicito del titular.
- **Dependencias:** ninguna; cero cambio de logica (B.3).

### Cambio 44 — Decision P-taxonomia-meta: no se crea "Meta / backlog"
- **Categoria:** Documentacion de proyecto.
- **Que:** se resolvio el pendiente P-taxonomia-meta decidiendo NO crear una
  categoria "Meta / backlog". Las entradas de reconciliacion de backlog (cambio 42,
  y este 44) permanecen en "Documentacion de proyecto".
- **Por que (C.11):** hoy existe una sola entrada de naturaleza meta (el cambio 42);
  una categoria con 1 entrada (~2%) viola el umbral de absorcion de la politica
  (categorias bajo 2% se absorben, no se crean; 2.2.5). Crear la categoria seria
  sobre-ingenieria de taxonomia (B.2).
- **Como se verifico (B.4):** decision registrada; tabla tematica sin categoria nueva;
  el cronologico no se reescribe.
- **Reevaluacion futura:** si las entradas meta llegan a 2-3, reabrir la decision.

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

### Nota metodologica del conteo
Un "cambio" es una solicitud distinguible del titular, no las acciones tecnicas
que la implementan. No cuentan los errores del asistente corregidos de
inmediato; si cuentan los bugfixes reportados por el titular. Clasificacion por
intencion primaria. Fuentes: registro de la sesion.

### Clasificacion tematica
Reconciliacion v07: "Diseno UI / motor" se subdivide por subsistema. La tabla
ahora cuadra con el detalle cronologico (44 entradas).

| Categoria | N | % | Descripcion |
|---|---|---|---|
| Diseno UI — Motor base y diseno | 9 | 20 | Grillas (v01); motor HTML paso 33 + iteraciones UI (v03) |
| Scaffold inicial | 9 | 20 | Estructura, scaffold, repo, decisiones v01 |
| Diseno UI — Hoja comparativa | 6 | 14 | Comparativa, multi-seleccion, limites, lotes visuales (v05) |
| Migracion y publicacion / DevOps | 5 | 11 | Auditoria seguridad, gobernanza, LICENSE, CI, README migracion (v04) |
| Diseno UI — Modo establecimiento | 4 | 9 | Trayectoria EE detallada + lista sin-vigente (v06); comentario tope, bucket sin-medicion (v07) |
| Documentacion de proyecto | 3 | 7 | 5 archivos de decision v03/v04 (v06); reconciliacion de taxonomia (v07); decision taxonomia-meta (v08) |
| Pipeline R | 3 | 7 | Pasos 30-32 de procesamiento |
| Orquestacion | 2 | 5 | 00_run_all.R (v02); consolidacion paso 33 + archivado de stub (v06) |
| Documentacion (en producto) | 2 | 5 | Panel de notas metodologicas (v05); alineacion con fuente oficial (v08) |
| Datos y normalizacion | 1 | 2 | Esquema xlsx, normalizacion categoria |

(Nota de conteo: el detalle cronologico es la fuente de verdad y tiene 44 entradas
(1-44). La tabla tematica suma 44, cuadrando con el cronologico. Las dos entradas
nuevas de v08 son el cambio 43 (Documentacion en producto: alineacion del panel) y
el cambio 44 (Documentacion de proyecto: decision taxonomia-meta). No se reescriben
entradas previas del detalle cronologico; las reclasificaciones, si las hubiera,
viven solo en la tabla tematica.)

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
| **Total** | | **44** | | |

(Nota: detalle cronologico y tabla tematica suman ambos 44 entradas (1-44). Los
cambios 43 y 44 son solicitudes distinguibles del titular: 43 la alineacion del
panel con la caracterizacion oficial, 44 la decision sobre P-taxonomia-meta. El
cuadre cronologico = tematico heredado de v07 se mantiene.)

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
  `setEntidades([])`); 42 reconciliacion de la taxonomia del backlog (subdivision
  de "Diseno UI" por subsistema; absorcion del descuadre heredado de v05).
- **Sesion 8 (cambios 43-44):** 43 alineacion del panel metodologico con la
  caracterizacion oficial de la Agencia (4 definiciones reescritas al fraseo por
  grado, parrafo de ponderacion 67/33, nota de conteo declarada como eleccion
  deliberada, nota de cobertura temporal con los tres vacios 2019/2020-2021/2022;
  solo-template); 44 decision P-taxonomia-meta: no se crea categoria "Meta /
  backlog" (1 entrada meta = 2%, bajo el umbral de absorcion).

### Delta del backlog
2 entradas nuevas (43-44). "Documentacion (en producto)" 1→2 (incluye 43);
"Documentacion de proyecto" 2→3 (incluye 44). Total cronologico 42→44. La tabla
tematica recalcula porcentajes sobre 44 (los enteros se mantienen; los % se ajustan
por el nuevo denominador) y sigue cuadrando con el cronologico; ninguna categoria
supera el 25%. P-taxonomia-meta queda cerrado en esta sesion (cambio 44).

---

## 6. Bugs de la sesion

No aplica en esta sesion: no hubo bugs de codigo. El bloque babel del template se
valido por transpilacion (`@babel/preset-env` + `@babel/preset-react`) sin errores
de sintaxis antes de la entrega.

---

## 7. Aprendizajes y restricciones descubiertas

### A9 — Una fuente oficial puede revelar que el contenido heredado era impreciso, no solo incompleto
- **Regla:** al contrastar contenido del producto con una fuente autoritativa, no
  asumir que solo falta agregar; verificar si lo existente esta MAL. Aqui las 4
  definiciones heredadas aplanaban dos categorias distintas (Insuficiente y
  Medio-Bajo, ambas "por debajo"); la fuente las separa por grado.
- **Principio:** B.1 (no operar sobre supuestos); C.11 (transparencia: la correccion
  se documenta con su porque).
- **Contexto:** P-glosa-oficial parecia un pendiente de "completar"; resulto una
  correccion de imprecision. El criterio de exito (coincidencia con la fuente) lo
  capturo.

### A10 — Acotar el alcance de un pedido abierto a su criterio de exito, no a su literalidad maxima
- **Regla:** ante "incorpora todo lo que enriquezca", descomponer en bloques con
  criterio propio y aprobar uno a uno, en vez de inflar el artefacto. El panel es
  glosa de lectura; base legal, decretos e IDPS detallados se dejaron fuera (scope
  creep) aunque la fuente los tenia.
- **Principio:** B.2 (simplicidad); B.3 (cambios quirurgicos); 🔒 no definir
  comportamiento de producto sobre EE de forma autonoma.
- **Contexto:** el pedido amplio se resolvio como A (definiciones) + C (afinar notas)
  ejecutados, y B (matricula) y el resto diferidos con decision de dominio del titular.

### A6 (reafirmado) — Verificar la disponibilidad del dato ANTES de prometer la feature
- **Regla:** el check A6 aplico de nuevo a P-matricula-ficha: el dato de matricula no
  esta en el JSON ni en los parquets, y la fuente externa no es descargable desde el
  contenedor. La feature se declaro bloqueada en vez de prometerla a ciegas. Ademas:
  cuando una feature exige un dato externo, identificar la fuente exacta (el "Resumen
  de Matricula por Establecimiento", no "Matricula por estudiante", que es por alumno
  y pesa cientos de MB) antes de que el titular descargue.
- **Principio:** B.1; B.4 (criterio de exito antes de codificar).

---

## 8. Decisiones de diseno

### D10 — El panel metodologico es glosa de lectura, no ficha tecnica completa
- **Decision:** el panel incorpora las definiciones oficiales y la ponderacion 67/33,
  pero NO base legal (Ley 20.529, Decreto 127/2023), etapas de calculo detalladas,
  ni el listado completo de IDPS.
- **Alternativa considerada:** volcar la caracterizacion oficial completa al panel.
- **Justificacion:** el panel sirve al usuario que lee una cifra y quiere entenderla;
  una ficha tecnica completa lo abrumaria y excede el proposito de la herramienta
  (B.2). La fuente completa puede vivir en documentacion del repo si se necesita.
- **Implicancia:** si en el futuro se quiere profundidad metodologica, va en
  `50_documentacion/activa/` o en una vista aparte, no en el panel.

### D11 — Conteo sin ponderacion declarado como eleccion deliberada en el producto
- **Decision:** el panel ahora dice explicitamente que no ponderar por matricula es
  una eleccion deliberada (la pregunta es la distribucion de establecimientos), no un
  descuido.
- **Alternativa:** dejar la nota como estaba (solo describia el conteo).
- **Justificacion:** la fuente oficial recomienda ponderar agregados por matricula
  para el Simce por estudiante; el motor mide otra cosa (distribucion de EE). Hacer
  explicita la eleccion previene que un lector informado lo lea como error
  metodologico. No contradice el invariante 🔒 (son preguntas distintas).

### Nota sobre P-matricula-ficha (decision de dominio del titular, no de diseno cerrada)
- El titular eligio **matricula total** (todos los niveles) para la ficha, con "por
  nivel evaluado" como evolucion futura posible. Razon: el pedido literal fue "cuantos
  estudiantes recibe el establecimiento" (cifra total); evita la complejidad de cruzar
  nivel-categoria en la ficha. El invariante 🔒 de no mezclar niveles aplica a las
  cifras de categoria agregadas, no a un dato de contexto del establecimiento.

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
| `rbd.motivo` | en JSON | 33_generar_html.R | Sin cambios (v06) |
| Etiqueta sin-medicion | "Sin categoria de desempeno en 2019" | 33_motor_template.html | Sin cambios (v07) |
| Ponderacion CdD (en panel) | 67% estandares / 33% resto | 33_motor_template.html | Nuevo v08 (texto del panel, no constante de calculo) |

---

## 10. Arquitectura de archivos

Escaner al cierre de la sesion (re-ejecutar antes de cerrar): la estructura sigue
la canonica de la politica (decenas, naming, ubicacion). Sin cambios estructurales
en v08 (solo edicion de `33_motor_template.html` y regeneraciones). 16 carpetas, 77
archivos al reabrir v08; v08 no agrega archivos al repo salvo el traspaso v08 y el
snapshot nuevo del escaner, que se agregan al commitear el cierre.

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**P-matricula-ficha (nuevo, alto valor, BLOQUEADO por dato)**
- **Descripcion:** mostrar la matricula total por anio del establecimiento en la
  ficha que se abre al hacer click sobre un EE, para ver cuantos estudiantes recibe.
- **Tipo:** funcionalidad (toca pipeline R + JSON + template).
- **Complejidad:** Media.
- **Dependencia:** el titular descarga el "Resumen de Matricula por Establecimiento"
  del MINEDUC (`datosabiertos.mineduc.cl`, seccion Estudiantes y Parvulos), anios
  2016-2019 (mas el mas reciente si se quiere matricula actual). NO "Matricula por
  estudiante" (es por alumno, cientos de MB). Formato CSV o XLSX.
- **Decision de dominio ya tomada:** matricula **total** (todos los niveles), no por
  nivel evaluado. "Por nivel" queda como evolucion futura posible.
- **Enfoque sugerido:** nuevo insumo en `20_insumos/` (publico, se versiona) →
  lectura/normalizacion (probablemente nuevo paso o ampliacion de `31`) → agregacion
  a `[rbd + anio] → matricula_total` → join al objeto EE en `33_generar_html.R` →
  nueva columna en el JSON (`mat` por anio en la trayectoria) → render en la ficha del
  EE junto a la categoria por anio. Verificar tipo `character` de RBD en el join
  (C.6); validar cobertura (RBDs del motor con matricula faltante).
- **Precauciones:** llaves RBD como `character`; el join no debe alterar el conteo de
  EE (10.945) ni las cifras de categoria; marcar visualmente los anios sin matricula
  si los hay; la matricula es dato de contexto, no entra en ninguna agregacion de
  categoria (no viola 🔒).
- **Criterio de exito:** la ficha de un EE muestra su matricula total por cada anio
  de la serie; el conteo de EE y las cifras de categoria quedan identicos al build
  previo (invariante verificado).

### Evaluacion de deuda tecnica
- **Zona fragil:** ninguna activa.
- **Oportunidad:** `33_motor_template.html` supero los 100 KB (≈103 KB tras v08).
  Monitorear, no actuar (B.2); la entrega es un HTML unico autocontenido y modularizar
  romperia esa propiedad. P-matricula-ficha sera el primer cambio que toque el
  pipeline R desde v06: buena ocasion para confirmar que el flujo 30→33 sigue corriendo
  end-to-end con un insumo nuevo.

### Auditoria de cierre (politica 5.6)
- #2 ¿Pipeline corre de cero sin intervencion manual? → **Si** (`run_all()` end-to-end
  30→33, verificado esta sesion para el paso 33).
- #5 ¿Cada transformacion critica tiene check de validacion? → Sin cambios en el
  pipeline R; el generador conserva su bloque stopifnot (C.8).
- #6 ¿Outputs reproducibles e idempotentes? → Si (regenera identico desde template +
  parquets).
- #7 ¿Decisiones metodologicas como constantes nombradas? → Si.
- #8 ¿Nombres sin tildes/ñ/espacios? → Si (sin archivos nuevos en v08).
- Resto: sin cambios respecto a v07.

### Ruta sugerida para la proxima sesion (sesion 9)
Aplicando los criterios de priorizacion (1.2.4):

1. **P-matricula-ficha** (cuando el titular adjunte el Resumen de Matricula). Es el
   unico pendiente abierto y de alto valor; toca el pipeline. Criterio: matricula
   total por anio visible en la ficha del EE, invariantes de EE y categoria intactos.

Sin otros pendientes abiertos. Si el titular no trae el dato, la sesion 9 puede ser
ONE-OFF o dedicarse a una mejora visual menor que surja.

**Diferir:** modularizacion del template (no mientras sea un HTML unico autocontenido);
matricula por nivel evaluado (evolucion futura de P-matricula-ficha, no ahora).

---

## 12. Instrucciones especificas para la proxima sesion

- 🔒 Agregacion = conteo de establecimientos. Jamas ponderacion por matricula,
  jamas GSE. (La matricula de P-matricula-ficha es dato de CONTEXTO del EE, no entra
  en ninguna agregacion de categoria.)
- 🔒 Basica y media nunca se mezclan en una cifra agregada.
- 🔒 El conteo de "sin categoria vigente" es el del parquet `sin_vigente`
  (autoritativo, por motivo, solo para "s/i"). Las listas client-side
  (`vigente === "s/i"` y `vigente === null`) son ayuda de navegacion, no la fuente
  del numero.
- 🔒 Tres buckets de `vigente`: categoria real / `"s/i"` / `null`. No unificar
  "s/i" y `null` (D8).
- 🔒 El pct de la hoja por territorio es el autoritativo del territorial (R). En la
  comparativa, el pct se deriva de los EE visibles (excepcion legitima al filtrar).
- 🔒 `40_salidas/motor_categoria.html` es fuente regenerable, IGNORADA por Git
  (`.gitignore`). `docs/index.html` es la copia versionada para Pages. No editar
  `docs/` a mano; no intentar commitear `40_salidas/motor_categoria.html` (git lo
  rechaza, es correcto).
- 🔒 El panel metodologico es glosa de lectura, no ficha tecnica completa (D10): no
  volcar base legal, decretos ni etapas de calculo al panel.
- ✅ ANTES de implementar P-matricula-ficha: confirmar que el insumo descargado es el
  "Resumen por Establecimiento" (una fila por RBD/anio), no "por estudiante";
  inspeccionar su esquema real antes de escribir el join (no deducir columnas).
- ✅ ANTES del join de matricula: RBD como `character` en ambos lados (C.6); verificar
  que el conteo de EE (10.945) y las cifras de categoria no cambian tras el join.
- ✅ ANTES de prometer una feature de UI, verificar que el dato exista en el JSON
  embebido (A6). Si exige dato externo, identificar la fuente exacta antes de pedir la
  descarga (A6 reafirmado v08).
- ✅ ANTES de corregir una micro-deuda flagueada (comentario, valor), auditar el
  caso general con `grep` (A8).
- ✅ ANTES de verificar un cambio del template: (1) reemplazar, (2) confirmar bytes,
  (3) regenerar. Nunca regenerar antes de reemplazar (A1).
- ✅ ANTES de editar `33_motor_template.html` al reabrir: confirmar marcadores de
  version (`function EeRow`, `RBD_MOTIVO`, `LIMITE = 10`, `cmp-clear-btn`,
  `sinMedicionEE`) (A2).
- ✅ ANTES de usar una variable CSS, confirmar que existe en `:root` (la correcta para
  bordes secundarios es `--border-2`).
- ✅ ANTES de cualquier push, `git status` revisado.
- ⚠️ NO reintroducir `00_build.R` (orquestador unico = `00_run_all.R`).
- ⚠️ NO definir comportamiento de producto sobre EE de forma autonoma: requiere
  input de dominio del titular.
- ⚠️ NO usar "EE" en texto visible al usuario: escribir "establecimientos".
- ⚠️ NO reintroducir `text-transform: uppercase` en ninguna parte del sitio.

---

## 13. Fragmentos de codigo de referencia

### Patron correcto: tres buckets de establecimientos client-side
```javascript
// vigente se calcula sin tocar el JSON: si no hay fila del anio vigente en la
// trayectoria, es null (sin medicion); si la hay con valor "s/i", es sin categoria.
const vigente = traj.has(ANIO_VIGENTE) ? traj.get(ANIO_VIGENTE) : null;
// ...
const sinVigenteEE  = eeVisibles.filter(ee => ee.vigente === "s/i");  // conteo parquet
const sinMedicionEE = eeVisibles.filter(ee => ee.vigente === null);   // navegacion
```

### Patron correcto: validar el JSX del template tras editarlo (antes de regenerar)
```bash
# Extraer el bloque <script type="text/babel"> y transpilarlo. Si transpila, el JSX
# es valido. Evita romper el motor por una etiqueta <p>/<div> desbalanceada.
node -e '
const babel = require("@babel/core");
const src = require("fs").readFileSync("babel_src.jsx","utf8");
babel.transformSync(src, {presets:["@babel/preset-env","@babel/preset-react"]});
console.log("OK");
'
```

### Patron correcto (referencia para v09): join de un dato de contexto al objeto EE
```r
# La matricula es dato de contexto del EE, NO entra en agregacion de categoria.
# Llaves como character; el join no debe alterar el conteo de EE.
ee <- ee |>
  dplyr::left_join(
    matricula |> dplyr::mutate(rbd = as.character(rbd)),
    by = c("rbd", "anio")
  )
stopifnot(dplyr::n_distinct(ee$rbd) == n_ee_antes)  # invariante de conteo
```

---

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 9 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del Project;
> leelo desde ahi. Retomamos slep_categoria_desempeno en sesion 9. Foco: 
> P-matricula-ficha (mostrar matricula total por anio en la ficha del establecimiento).
> Adjunto el traspaso v08, el escaner actual y el Resumen de Matricula por
> Establecimiento que descargue. Sin otros pendientes de codigo abiertos.

### Documentos para la proxima sesion

**1. Protocolo en knowledge base (NO se adjuntan; verificar que esten al dia):**
- `POLITICA_PROYECTO.md` (vigente: v6)
- `SETTINGS_Y_PROMPTS_OPERACIONALES.md` (vigente: v1)

**2. Opcionales segun el foco real:**
- `CLAUDE.md` (si la sesion corre en Claude Code).
- `30_procesamiento/33_motor_template.html` como MOLDE (P-matricula-ficha edita la
  ficha del EE; verificar marcadores A2 al cargar).
- `30_procesamiento/33_generar_html.R` (el join de matricula y la nueva columna JSON
  se hacen aqui).
- `30_procesamiento/31_leer_normalizar.R` (si la lectura del nuevo insumo se integra
  aqui en vez de un paso nuevo).

**3. Especificos de la sesion (SI se adjuntan):**
- `50_documentacion/traspasos/traspaso_cierre_v08.md` (este archivo).
- `50_documentacion/estructura/estructura_actual.md` (re-ejecutar el escaner al reabrir).
- **El "Resumen de Matricula por Establecimiento" descargado** (2016-2019), insumo
  critico de P-matricula-ficha. Sin el, el pendiente sigue bloqueado.

### Nota final obligatoria
Si algun archivo listado cambio entre sesiones, adjuntar la version mas
actualizada al abrir y avisarlo en el mensaje de apertura. `33_motor_template.html`
crecio a ≈103 KB en la sesion 8 (parrafos del panel metodologico): adjuntar la version
actual, no una previa (A2).
