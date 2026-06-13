# Traspaso de cierre v07 — slep_categoria_desempeno

## 1. Identificacion

- **Proyecto:** slep_categoria_desempeno
- **Version:** v07
- **Fecha:** 2026-06-12
- **Sesion:** 7 — foco en limpieza de micro-deuda (comentario stale), bucket de
  establecimientos sin medicion 2019 en el modo territorio, boton de limpieza en
  la hoja comparativa, y reconciliacion de la taxonomia del backlog.
- **Entorno:** R 4.5.2 en Positron, macOS aarch64. Modelo: Claude Opus 4.8.
- **Archivos principales modificados:** `30_procesamiento/33_motor_template.html`
  (comentario stale ×2, componente `SinVigente`, calculo `sinMedicionEE` en `App`,
  boton `cmp-clear-btn` + su CSS). Regeneraciones de `40_salidas/motor_categoria.html`
  y `docs/index.html`. Sin cambios en el pipeline R 30-32 ni en `33_generar_html.R`.

---

## 2. Resumen ejecutivo

La sesion 7 ejecuto la ruta propuesta y agrego un pendiente nuevo detectado en
vivo. Se corrigio el comentario stale "tope de 4" (que estaba en DOS lugares
—L1655 y L2015—, no uno como registraba v06) a "tope de 10", coherente con
`LIMITE = 10`. Se implemento el bucket de establecimientos sin medicion 2019
(`vigente === null`) como una segunda lista en el bloque "Sin categoria vigente",
rotulada "Sin categoria de desempeno en 2019" (etiqueta definida por el titular);
resulto un cambio SOLO-template (el dato ya viajaba al cliente via L1555), contra
la expectativa de v06 de que exigiria una columna nueva en el generador. Se agrego
un boton "Limpiar" junto a "+ Agregar" en la hoja comparativa (pendiente nuevo,
P-comparativa-limpiar). Finalmente se reconcilio la taxonomia del backlog:
"Diseno UI / motor" (39%, sobre el 25%) se subdividio por subsistema (Motor base /
Hoja comparativa / Modo establecimiento) y se absorbio el descuadre heredado de
v05. No hubo bugs de codigo; el bloque babel se valido por transpilacion. Todo
commiteado y pusheado (`148b555`).

---

## 3. Estado al cierre

### Que funciona (ultima ejecucion exitosa)
- `run_all(only = 33)` regenera el motor (verificado 2026-06-12 22:09, HTML 969 KB,
  plantilla 101121 caracteres confirmando el template editado de esta sesion).
- Modo territorio: bajo "Sin categoria vigente" se muestran ahora dos listas
  separadas y rotuladas — "Establecimientos identificados" (s/i, poblacion del
  parquet) y "Sin categoria de desempeno en 2019" (sin medicion, `vigente null`),
  ambas reusando `EeRow`. El conteo oficial de cabecera sigue saliendo del parquet.
- Hoja comparativa: boton "Limpiar" visible cuando hay entidades seleccionadas;
  vacia el estado (`setEntidades([])`).
- Comentarios del template coherentes con el valor vigente (`LIMITE = 10`).
- Backlog con taxonomia reconciliada: ninguna categoria supera el 25%.

### Que no funciona / pendiente
- Sin pendientes bloqueantes ni deuda nueva. P-glosa-oficial sigue bloqueado por la
  glosa oficial de la Agencia.

### Delta respecto a v06
- v06 cerro con la orquestacion saneada, 5 decisiones documentadas y el modo EE
  rediseñado. v07 limpia la micro-deuda del comentario, agrega el bucket sin-medicion
  y el boton limpiar, y reconcilia la taxonomia. Sin cambios en el pipeline R ni en
  la estructura de carpetas.

---

## 4. Registro detallado de cambios

### Cambio 39 — Correccion del comentario stale "tope de 4" (P-comentario-stale-limite)
- **Categoria:** Diseno UI / Modo establecimiento (limpieza; ver nota de clasificacion).
- **Que:** `33_motor_template.html` L1655 y L2015: `// respeta el tope de 4` →
  `// respeta el tope de 10`. El comentario aparecia en DOS ubicaciones (en
  `EntityModal.toggleSel` y en `App.addEntity`), no solo en la registrada por v06.
- **Por que (C.11):** micro-deuda flagueada en v06; el valor real es `LIMITE = 10`.
  Auditoria de caso general (no solo la instancia reportada): ambas resuelven a 10
  (`EntityModal` recibe `limite={LIMITE}` en L2164; default tambien 10).
- **Como se verifico (B.4):** `grep -c "tope de 4"` → 0; ambos comentarios coherentes;
  transpilacion babel sin errores; placeholders intactos.
- **Dependencias:** ninguna; cero cambio de logica (B.3).

### Cambio 40 — Bucket de establecimientos sin medicion 2019 (P-ee-sin-medicion)
- **Categoria:** Diseno UI / Modo establecimiento.
- **Que (solo template):**
  - `App`: nuevo `sinMedicionEE = eeVisibles.filter(ee => ee.vigente === null)`,
    junto al `sinVigenteEE` (`=== "s/i"`) existente; pasado como prop
    `listaSinMedicion` a `SinVigente`.
  - `SinVigente`: recibe `listaSinMedicion`, ajusta el guard de retorno y renderiza
    un segundo bloque-lista rotulado "Sin categoria de desempeno en {ANIO_VIGENTE}",
    reusando `EeRow` (DRY). No suma al conteo oficial del parquet.
- **Por que (C.11):** los EE sin medicion 2019 no aparecian en ninguna vista
  (pendiente v06). El titular decidio hacerlos visibles con la etiqueta exacta
  "Sin categoria de desempeno en 2019" (elicitacion, A7).
- **Como se verifico (B.4):** regeneracion limpia; `grep` confirma la etiqueta y
  `sinMedicionEE` en el HTML final; transpilacion babel sin errores.
- **Hallazgo declarado (corrige expectativa de v06):** el dato `null` YA viajaba al
  cliente — `vigente = traj.has(ANIO_VIGENTE) ? traj.get(ANIO_VIGENTE) : null`
  (L1555). No requirio columna nueva en `33_generar_html.R`. La verificacion previa
  (A6) evito un cambio innecesario de dos archivos (B.2 / B.3).
- **Decision declarada (extiende D7):** tres buckets client-side distintos —
  categoria real, "s/i" (evaluado sin categoria), `null` (sin medicion). El conteo
  del parquet sigue siendo autoritativo solo para "s/i". La lista sin-medicion es
  navegacion, no fuente de cifra.

### Cambio 41 — Boton "Limpiar" en la hoja comparativa (P-comparativa-limpiar, nuevo)
- **Categoria:** Diseno UI / Hoja comparativa.
- **Que:** boton "Limpiar" tras "+ Agregar", visible solo con
  `entidades.length > 0`, que ejecuta `setEntidades([])`. CSS nuevo `.cmp-clear-btn`
  (secundario: contorno `--border-2`, sin relleno, para no competir con el primario
  azul "+ Agregar").
- **Por que (C.11):** pedido del titular en vivo (captura de pantalla): faltaba un
  modo rapido de vaciar la seleccion sin quitar chip por chip.
- **Como se verifico (B.4):** transpilacion babel sin errores; variable `--border-2`
  confirmada existente (la primera eleccion `--border` no existia, se corrigio antes
  de entregar); placeholders y marcadores A2 intactos.
- **Dependencias:** reusa el estado `entidades`/`setEntidades` existente; sin logica nueva.

### Cambio 42 — Reconciliacion de la taxonomia del backlog (P-taxonomia-subdivision)
- **Categoria:** Documentacion de proyecto.
- **Que:** "Diseno UI / motor" (15, ~39%) se subdivide por subsistema en "Motor base
  y diseno", "Hoja comparativa" y "Modo establecimiento"; se absorbe el descuadre
  heredado de la tabla de v05 (sumaba 34 declarando 35). La tabla tematica ahora
  cuadra con el detalle cronologico y ninguna categoria supera el 25%.
- **Por que (C.11):** deuda de backlog heredada (categoria > 25%) y descuadre 37/38.
- **Como se verifico (B.4):** suma de la tabla tematica = 41 (= detalle cronologico);
  max categoria "Scaffold inicial" 22% (< 25%).
- **Regla respetada:** no se reescriben ni renumeran entradas previas del detalle
  cronologico; la reclasificacion vive solo en la tabla tematica y se declara en el delta.

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

### Nota metodologica del conteo
Un "cambio" es una solicitud distinguible del titular, no las acciones tecnicas
que la implementan. No cuentan los errores del asistente corregidos de
inmediato; si cuentan los bugfixes reportados por el titular. Clasificacion por
intencion primaria. Fuentes: registro de la sesion.

### Clasificacion tematica
Reconciliacion v07: "Diseno UI / motor" se subdivide por subsistema. La tabla
ahora cuadra con el detalle cronologico (41 entradas).

| Categoria | N | % | Descripcion |
|---|---|---|---|
| Diseno UI — Motor base y diseno | 9 | 21 | Grillas (v01); motor HTML paso 33 + iteraciones UI (v03) |
| Scaffold inicial | 9 | 21 | Estructura, scaffold, repo, decisiones v01 |
| Diseno UI — Hoja comparativa | 6 | 14 | Comparativa, multi-seleccion, limites, lotes visuales (v05) |
| Migracion y publicacion / DevOps | 5 | 12 | Auditoria seguridad, gobernanza, LICENSE, CI, README migracion (v04) |
| Diseno UI — Modo establecimiento | 4 | 10 | Trayectoria EE detallada + lista sin-vigente (v06); comentario tope, bucket sin-medicion (v07) |
| Pipeline R | 3 | 7 | Pasos 30-32 de procesamiento |
| Orquestacion | 2 | 5 | 00_run_all.R (v02); consolidacion paso 33 + archivado de stub (v06) |
| Documentacion de proyecto | 2 | 5 | 5 archivos de decision v03/v04 (v06); reconciliacion de taxonomia (v07) |
| Documentacion (en producto) | 1 | 2 | Panel de notas metodologicas (v05) |
| Datos y normalizacion | 1 | 2 | Esquema xlsx, normalizacion categoria |

(Nota de conteo: el detalle cronologico es la fuente de verdad y tiene 42 entradas
(1-42). La tabla tematica suma 42, cuadrando con el cronologico por primera vez
desde v05. La subdivision de "Diseno UI / motor" (antes 15) en tres subsistemas
—Motor base 9, Hoja comparativa 6, Modo establecimiento 4 (incluye 39-40 de v07),
suman 19 porque 28-35 de la hoja comparativa y 38-40 del modo establecimiento son
posteriores a v05— se reconcilio contra el cronologico real, no contra la cifra 15
heredada. El descuadre 37/38 de v05-v06 se resuelve aqui. No se reescriben entradas
previas del detalle cronologico; la reclasificacion vive solo en la tabla tematica.)

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
| **Total** | | **42** | | |

(Nota: detalle cronologico y tabla tematica suman ambos 42 entradas (1-42). El
cambio 42 —reconciliacion de taxonomia— es una solicitud distinguible del titular
y cuenta como entrada, clasificada en "Documentacion de proyecto". Con esto el
descuadre 37/38 que arrastraban v05-v06 queda cerrado: cronologico = tematico.)

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

### Delta del backlog
4 entradas nuevas (39-42). Subdivision de "Diseno UI / motor" (15) en tres
subsistemas: "Motor base y diseno" (10, absorbe la entrada historica sin clasificar
de v05), "Hoja comparativa" (6, incluye 41), "Modo establecimiento" (4, incluye 39
y 40). "Documentacion de proyecto" 1→2 (incluye 42). Total cronologico 38→42. El
descuadre 37/38 heredado de v05-v06 queda resuelto: la tabla tematica cuadra con el
cronologico. Pendiente de revision para v08: si conviene una categoria separada
"Meta / backlog" para los cambios de reconciliacion (hoy en "Documentacion de
proyecto").

---

## 6. Bugs de la sesion

No aplica en esta sesion: no hubo bugs de codigo. El bloque babel del template se
valido por transpilacion (`@babel/preset-env` + `@babel/preset-react`) sin errores
de sintaxis antes de cada entrega.

---

## 7. Aprendizajes y restricciones descubiertas

### A8 — Una micro-deuda registrada puede tener mas instancias que la reportada
- **Regla:** al corregir una instancia flagueada (comentario, valor, patron),
  auditar el caso general con `grep` antes de cerrar; no asumir que la ubicacion del
  traspaso es la unica.
- **Principio:** root-cause sobre sintoma; B.3 acotado pero exhaustivo en su clase.
- **Contexto:** v06 registro el comentario "tope de 4" en ~L1911; en realidad estaba
  en L1655 y L2015. Corregir solo una habria dejado deuda viva.

### A6 (reafirmado, con matiz positivo) — Verificar el JSON puede AHORRAR un cambio de dos archivos
- **Regla:** el check A6 (¿el dato existe en el JSON?) no solo previene prometer
  features imposibles; tambien evita trabajo innecesario cuando el dato YA esta
  disponible client-side. Verificar antes de asumir que se necesita tocar el generador.
- **Principio:** B.1; B.2 (no agregar codigo especulativo).
- **Contexto:** P-ee-sin-medicion parecia exigir una columna nueva (expectativa de
  v06); `vigente === null` ya era distinguible (L1555). Cambio solo-template.

### A7 (reafirmado) — Etiqueta exacta definida por el titular
- **Regla:** para texto visible al usuario, elicitar la etiqueta literal en vez de
  inferirla ("no rindio" vs "Sin categoria de desempeno en 2019"). El titular fijo
  la redaccion oficial.

---

## 8. Decisiones de diseno

### D8 — Tres buckets de establecimientos en el modo territorio
- **Decision:** el cliente distingue tres poblaciones por el campo `vigente`:
  categoria real (Alto/Medio/...), `"s/i"` (evaluado pero sin categoria 2019),
  `null` (sin medicion 2019). Las dos ultimas se listan por separado en el bloque
  "Sin categoria vigente", rotuladas distinto.
- **Alternativa considerada:** unificar "s/i" y `null` en una sola lista, o dejar
  `null` invisible (status v06).
- **Justificacion:** son fenomenos distintos (sin categoria vs sin rendir); unirlos
  confundiria la lectura. El conteo del parquet sigue siendo autoritativo solo para
  "s/i", preservando el invariante de cifras (extiende D7).
- **Implicancia:** si una entidad no tiene EE sin medicion, la segunda lista no se
  renderiza (correcto). La etiqueta es "Sin categoria de desempeno en 2019".

### D9 — Boton "Limpiar" secundario, no primario
- **Decision:** `cmp-clear-btn` con estilo de contorno (sin relleno azul), visible
  solo con entidades presentes.
- **Alternativa:** boton siempre visible, o estilo igual al primario.
- **Justificacion:** una accion destructiva no debe competir visualmente con la
  accion principal ("+ Agregar"); ocultarlo sin seleccion evita ruido.

---

## 9. Constantes y parametros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `PASOS` (ids) | 30, 31, 32, 33 | 00_run_all.R | Sin cambios |
| `LIMITE` (territorios comparables) | 10 | 33_motor_template.html | Sin cambios; comentarios ahora coherentes |
| `PCT_DIGITS` | 4 | 33_generar_html.R | Sin cambios |
| Alfa heatmap | 0.10 + t*0.55 | 33_motor_template.html | Sin cambios |
| ANIO_VIGENTE | 2019 (= max anios) | JSON (meta) | Se recalcula con SIMCE 2025 |
| CAT_ORDEN / CAT_COLORS | Insuficiente→Alto | 33_generar_html.R | Sin cambios |
| `rbd.motivo` | en JSON | 33_generar_html.R | Sin cambios (v06) |
| Etiqueta sin-medicion | "Sin categoria de desempeno en 2019" | 33_motor_template.html | Nuevo v07 |

---

## 10. Arquitectura de archivos

Escaner al cierre de la sesion (re-ejecutar antes de cerrar): la estructura sigue
la canonica de la politica (decenas, naming, ubicacion). Sin cambios estructurales
en v07 (solo edicion de `33_motor_template.html` y regeneraciones). 16 carpetas,
75 archivos al cierre de v06; v07 no agrega archivos al repo (el traspaso v07 y el
snapshot nuevo se agregan al commitear el cierre).

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**P-glosa-oficial (pendiente menor, heredado de v05/v06)**
- **Descripcion:** contrastar las definiciones de las 4 categorias del panel de
  notas con la glosa oficial de la Agencia.
- **Tipo:** documentacion / correccion de contenido.
- **Complejidad:** Baja.
- **Dependencia:** que el titular tenga la glosa oficial.
- **Criterio de exito:** las 4 definiciones coinciden con la fuente oficial.

**P-taxonomia-meta (micro-deuda de backlog, nueva)**
- **Descripcion:** evaluar si los cambios de reconciliacion de backlog (como el 42)
  merecen una categoria propia "Meta / backlog" en vez de vivir en "Documentacion
  de proyecto".
- **Tipo:** documentacion / deuda de taxonomia.
- **Complejidad:** Trivial.
- **Precaucion:** decidir en una sesion con cierre; no reescribir entradas previas.
- **Criterio de exito:** decision tomada y, si aplica, categoria creada con las
  entradas meta reasignadas en la tabla tematica (no en el cronologico).

### Evaluacion de deuda tecnica
- **Zona fragil:** ninguna activa.
- **Oportunidad:** `33_motor_template.html` supero los 100 KB (101 KB). El modo EE
  y la hoja comparativa son ya subsistemas con identidad. Monitorear, no actuar
  (B.2); la entrega es un HTML unico autocontenido y modularizar romperia esa
  propiedad.

### Auditoria de cierre (politica 5.6)
- #2 ¿Pipeline corre de cero sin intervencion manual? → **Si** (un orquestador,
  `run_all()` end-to-end 30→33).
- #5 ¿Cada transformacion critica tiene check de validacion? → Sin cambios en el
  pipeline R; el generador conserva su bloque stopifnot (C.8).
- #6 ¿Outputs reproducibles e idempotentes? → Si (regenera identico desde template
  + parquets).
- #7 ¿Decisiones metodologicas como constantes nombradas? → Si.
- #8 ¿Nombres sin tildes/ñ/espacios? → Si (sin archivos nuevos en v07).
- Resto: sin cambios respecto a v06.

### Ruta sugerida para la proxima sesion (sesion 8)
Aplicando los criterios de priorizacion (1.2.4):

1. **P-glosa-oficial** (cuando el titular tenga la glosa; cierra contenido del panel).
   Criterio: 4 definiciones alineadas con la fuente oficial.
2. **P-taxonomia-meta** (trivial; en sesion con cierre). Criterio: decidido y, si
   aplica, categoria "Meta / backlog" creada.

Sin pendientes de codigo abiertos. La proxima sesion sera probablemente de
contenido/documentacion salvo nuevo pedido del titular.

**Diferir:** modularizacion del template (no mientras sea un HTML unico autocontenido).

---

## 12. Instrucciones especificas para la proxima sesion

- 🔒 Agregacion = conteo de establecimientos. Jamas ponderacion por matricula,
  jamas GSE.
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
- ✅ ANTES de prometer una feature de UI, verificar que el dato exista en el JSON
  embebido (A6). El check tambien puede AHORRAR un cambio de generador si el dato ya
  viaja (A6 reafirmado v07).
- ✅ ANTES de corregir una micro-deuda flagueada (comentario, valor), auditar el
  caso general con `grep`: puede haber mas instancias que la reportada (A8).
- ✅ ANTES de verificar un cambio del template: (1) reemplazar, (2) confirmar bytes,
  (3) regenerar. Nunca regenerar antes de reemplazar (A1).
- ✅ ANTES de editar `33_motor_template.html` al reabrir: confirmar marcadores de
  version (`function EeRow`, `RBD_MOTIVO`, `LIMITE = 10`, `cmp-clear-btn`,
  `sinMedicionEE`) (A2).
- ✅ ANTES de usar una variable CSS, confirmar que existe en `:root` (en v07 la
  primera eleccion `--border` no existia; la correcta es `--border-2`).
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

### Patron correcto: boton secundario condicional (no compite con el primario)
```javascript
<button className="cmp-add-btn" disabled={entidades.length >= LIMITE}
  onClick={() => setPicker(true)}>+ Agregar</button>
{entidades.length > 0 && (
  <button className="cmp-clear-btn" onClick={() => setEntidades([])}>Limpiar</button>
)}
```

### Patron correcto: auditar el caso general de una micro-deuda antes de corregir
```bash
grep -n "tope de 4" 30_procesamiento/33_motor_template.html
# Si devuelve mas de una linea, corregir TODAS, no solo la del traspaso.
```

---

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 8 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del Project;
> leelo desde ahi. Retomamos slep_categoria_desempeno en sesion 8. Foco sugerido:
> P-glosa-oficial (si tengo la glosa oficial de la Agencia) y P-taxonomia-meta
> (decidir si crear categoria "Meta / backlog"). Sin pendientes de codigo abiertos.
> Adjunto el traspaso v07 y el escaner actual.

### Documentos para la proxima sesion

**1. Protocolo en knowledge base (NO se adjuntan; verificar que esten al dia):**
- `POLITICA_PROYECTO.md` (vigente: v6)
- `SETTINGS_Y_PROMPTS_OPERACIONALES.md` (vigente: v1)

**2. Opcionales segun el foco real:**
- `CLAUDE.md` (si la sesion corre en Claude Code).
- La glosa oficial de la Agencia (PDF o texto) si se aborda P-glosa-oficial.
- `30_procesamiento/33_motor_template.html` como MOLDE solo si P-glosa-oficial
  exige editar el panel de notas (verificar marcadores A2 al cargar).

**3. Especificos de la sesion (SI se adjuntan):**
- `50_documentacion/traspasos/traspaso_cierre_v07.md` (este archivo).
- `50_documentacion/estructura/estructura_actual.md` (re-ejecutar el escaner al reabrir).

### Nota final obligatoria
Si algun archivo listado cambio entre sesiones, adjuntar la version mas
actualizada al abrir y avisarlo en el mensaje de apertura. `33_motor_template.html`
crecio a ~101 KB en la sesion 7 (bucket `sinMedicionEE`, boton `cmp-clear-btn`):
adjuntar la version actual, no una previa (A2).
