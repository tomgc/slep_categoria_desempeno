# Traspaso de cierre v06 — slep_categoria_desempeno

## 1. Identificacion

- **Proyecto:** slep_categoria_desempeno
- **Version:** v06
- **Fecha:** 2026-06-12
- **Sesion:** 6 — foco en deuda de orquestacion (paso 33), documentacion de
  decisiones pendientes y rediseno del modo EE (trayectoria detallada + lista
  sin categoria vigente).
- **Entorno:** R 4.5.2 en Positron, macOS aarch64. Modelo: Claude Opus 4.8.
- **Archivos principales modificados:** `00_run_all.R` (IDs de paso),
  `30_procesamiento/33_generar_html.R` (columna `motivo` en el bloque rbd),
  `30_procesamiento/33_motor_template.html` (componente `EeRow`, `SinVigente`
  con lista, indice `RBD_MOTIVO`). `00_build.R` archivado a `_archivo/20260612/`.
  Cinco archivos nuevos en `50_documentacion/activa/decisiones/`. Regeneraciones
  de `40_salidas/motor_categoria.html` y `docs/index.html`.

---

## 2. Resumen ejecutivo

La sesion 6 ejecuto completa la ruta propuesta (P1 → P2 → P3). Se cerro la deuda
de orquestacion: los IDs de paso de `00_run_all.R` se alinearon a los prefijos de
archivo (30-33), de modo que `run_all(only = 33)` ahora funciona, y el stub muerto
`00_build.R` se archivo, dejando un solo orquestador canonico. Se documentaron las
cinco decisiones pendientes de v03 y v04 (cobertura temporal, paleta, visibilidad
del repo, modelo Pages, licencia) replicando el molde existente. Se rediseno el
modo EE: cada fila es clickeable y despliega la trayectoria ano por ano en texto
(con motivo cuando el ano esta sin categoria), y el bloque "Sin categoria vigente"
paso de mostrar solo conteos a listar los establecimientos identificados con su
trayectoria, conservando arriba el conteo oficial del parquet. La feature de
motivo por ano requirio un cambio en el generador R (la columna no estaba en el
JSON). No hubo bugs de codigo; el bloque babel se valido por transpilacion. Una
divergencia notable: el v05 afirmaba que el paso 33 no estaba registrado en el
orquestador, pero si lo estaba; el sintoma real era el desacople id/prefijo.

---

## 3. Estado al cierre

### Que funciona (ultima ejecucion exitosa)
- `run_all()` corre el pipeline 30→33 end-to-end (1.1 s) y `run_all(only = 33)`
  ejecuta solo el generador (verificado 2026-06-12 21:49, HTML 968 KB).
- Un unico orquestador (`00_run_all.R`); `00_build.R` archivado fuera de Git.
- Motor con modo EE rediseñado: fila clickeable que despliega trayectoria en
  texto; bloque sin-vigente con conteo oficial arriba y lista de EE abajo.
- Generador exporta `motivo` por rbd×nivel×anio (JSON crecio 5.67M → 5.99M
  caracteres; gzip se mantuvo en 0.56 MB por ser casi todo null).
- Cinco archivos de decision en `50_documentacion/activa/decisiones/`.
- GitHub Pages: `docs/index.html` se regenera en cada corrida; sitio publicado.

### Que no funciona / pendiente
- Sin pendientes bloqueantes. Deuda menor abierta: comentario stale en
  `33_motor_template.html` L1911 (`// respeta el tope de 4`, hoy `LIMITE = 10`);
  EE con `vigente === null` (sin medicion 2019) no aparecen en ninguna vista.

### Delta respecto a v05
- v05 cerro con la hoja comparativa y el paso 33 fuera del orquestador (segun su
  propio diagnostico). v06 consolida la orquestacion, documenta 5 decisiones y
  rediseña el modo EE. Sin cambios en el pipeline R 30-32 ni en la estructura de
  carpetas (salvo `00_build.R` archivado y los nuevos archivos de decision).

---

## 4. Registro detallado de cambios

### Cambio 36 — Orquestacion del paso 33 (P-orquestar-paso-33)
- **Categoria:** Orquestacion.
- **Que:** IDs de `PASOS` en `00_run_all.R` de `1-4` a `30/31/32/33` (coinciden con
  el prefijo del script); comentarios stale limpiados ("PENDIENTE sesion 3", "el
  paso 4 aun no existe"); ejemplos de uso renumerados; `00_build.R` (stub con
  todos los pasos comentados) archivado a `_archivo/20260612/`.
- **Por que (C.11):** deuda flagueada en v05; eliminaba la clase de error A1 y la
  coexistencia de dos orquestadores. El sintoma `run_all(only = 33)` provenia del
  desacople id/prefijo, no de un paso ausente.
- **Como se verifico (B.4):** `run_all()` ejecuta 30,31,32,33; `run_all(only = 33)`
  ejecuta solo 33; `00_build.R` ya no esta en la raiz (`delete mode 100644`).
- **Dependencias:** ninguna; el pipeline R y la UI no se tocaron (B.3).

### Cambio 37 — Documentacion de 5 decisiones pendientes (P-decisiones)
- **Categoria:** Documentacion de proyecto.
- **Que:** cinco archivos en `decisiones/` replicando el molde
  `20260611_decision_sin_gse.md`: `cobertura_temporal`, `paleta_categorias`
  (origen v03); `visibilidad_repo`, `modelo_pages`, `licencia` (origen v04). Cada
  uno con Contexto, Decision, Justificacion, Alternativas, Implicancia.
- **Por que (C.11):** documentar decisiones ya tomadas pero no registradas;
  pendiente arrastrado desde v05 (bloqueado por falta del molde, ya adjuntado).
- **Como se verifico (B.4):** 5 archivos creados con las 5 secciones canonicas.
- **Salvedad documentada:** la rationale de `visibilidad_repo` y `modelo_pages` se
  reconstruyo desde el contexto disponible (header del generador, LICENSE, backlog
  v04), no desde los traspasos v03/v04. Fechadas 2026-06-12 (dia de redaccion) con
  la sesion de origen anotada en cada cabecera.

### Cambio 38 — Rediseno del modo EE: trayectoria detallada + lista sin-vigente (P-ee-trayectoria)
- **Categoria:** Diseno UI / motor.
- **Que (R + template):**
  - **R (`33_generar_html.R`):** `rbd_lst` gana `motivo = df_rbd_ord$motivo_sin_categoria`
    (NA→null en filas categorizadas), para exponer el motivo por ano al cliente.
  - **Template:** indice `RBD_MOTIVO` (rbd|nivel → ano → motivo) con degradacion
    controlada (`R_MOT = R.motivo || null`); `serie` de cada EE incluye `motivo`;
    componente unico `EeRow` (fila clickeable que despliega trayectoria en texto:
    "2019: Medio · 2018: Sin categoria · Baja matricula · 2017: Sin medicion");
    `CatColumn` consume `EeRow` (elimina la fila inline duplicada); `SinVigente`
    conserva el conteo oficial del parquet y lista los EE identificados con su
    trayectoria; `App` calcula `sinVigenteEE = eeVisibles.filter(vigente === "s/i")`.
    CSS nuevo: `.ee-row-li`, `.ee-detail*`, `.sin-vigente-lista*`.
- **Por que (C.11):** pedido del titular (confirmado por elicitacion: detalle ano
  por ano en texto + motivo; lista de EE bajo la grilla).
- **Como se verifico (B.4):** transpilacion babel (presets env,react) sin errores;
  placeholders `__D3_INLINE__/__PAKO_INLINE__/__JSON_DATA__` intactos; regeneracion
  limpia (JSON 5.99M, HTML 968 KB) confirmando que `motivo` viaja al cliente.
- **Decision declarada:** la lista sin-vigente usa `vigente === "s/i"` (evaluados
  pero sin categoria 2019), poblacion coherente con el parquet; los `null` (sin
  medicion 2019) son otro bucket y no se listan. El conteo del parquet sigue siendo
  autoritativo (ver D7).
- **Tension:** DRY vs duplicacion — se extrajo `EeRow` para que columnas y lista
  sin-vigente compartan la misma fila (evita el patron de bug por logica duplicada).

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

### Nota metodologica del conteo
Un "cambio" es una solicitud distinguible del titular, no las acciones tecnicas
que la implementan. No cuentan los errores del asistente corregidos de
inmediato; si cuentan los bugfixes reportados por el titular. Clasificacion por
intencion primaria. Fuentes: registro de la sesion.

### Clasificacion tematica
Nueva categoria en v06: "Documentacion de proyecto" (decisiones, distinta de
"Documentacion (en producto)" que es el panel de notas del motor).

| Categoria | N | % | Descripcion |
|---|---|---|---|
| Diseno UI / motor | 15 | 39 | Grillas (v01); motor HTML + iteraciones (v03); Pages (v04); hoja comparativa, multi-seleccion, lotes visuales (v05); trayectoria EE detallada + lista sin-vigente (v06) |
| Scaffold inicial | 9 | 24 | Estructura, scaffold, repo, decisiones v01 |
| Migracion y publicacion / DevOps | 5 | 13 | Auditoria seguridad, gobernanza, LICENSE, CI, README migracion (v04) |
| Pipeline R | 3 | 8 | Pasos 30-32 de procesamiento |
| Orquestacion | 2 | 5 | 00_run_all.R (v02); consolidacion paso 33 + archivado de stub (v06) |
| Documentacion (en producto) | 1 | 3 | Panel de notas metodologicas (v05) |
| Documentacion de proyecto | 1 | 3 | 5 archivos de decision v03/v04 (v06) |
| Datos y normalizacion | 1 | 3 | Esquema xlsx, normalizacion categoria |

(Nota de conteo: el detalle cronologico es la fuente de verdad y tiene 38 entradas
(1-38). La tabla tematica suma 37: arrastra un descuadre heredado de v05 (su tabla
sumaba 34 declarando 35; una entrada historica quedo sin clasificar). No se
reescriben entradas previas (regla de backlog); la reconciliacion se difiere a la
sesion de subdivision de la taxonomia.)

### Resumen estadistico por sesion
| Sesion | Traspasos | N cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 11 | (v01) | Scaffold y diseno |
| 2 | v02 | 4 | Opus 4.8 | Pipeline R 30-32 + orquestador |
| 3 | v03 | 6 | Opus 4.8 | Motor HTML (paso 33) + iteraciones UI |
| 4 | v04 | 6 | Opus 4.8 | Migracion a GitHub + Pages |
| 5 | v05 | 8 | Opus 4.8 | Hoja comparativa + notas + pulido visual |
| 6 | v06 | 3 | Opus 4.8 | Orquestacion + decisiones + trayectoria EE |
| **Total** | | **38** | | |

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

### Delta del backlog
3 entradas nuevas (36-38). Nueva categoria "Documentacion de proyecto" (1).
"Orquestacion" 1→2; "Diseno UI / motor" 14→15. Total cronologico 35→38.
Reclasificacion / correccion declarada: se documenta el descuadre heredado de la
tabla tematica de v05 (sumaba 34 declarando 35) sin reescribir entradas previas.

---

## 6. Bugs de la sesion

No aplica en esta sesion: no hubo bugs de codigo. El bloque babel del template se
valido por transpilacion (`@babel/preset-env` + `@babel/preset-react`) sin errores
de sintaxis antes de la entrega.

---

## 7. Aprendizajes y restricciones descubiertas

### A5 — El traspaso puede describir un estado desactualizado respecto a los archivos reales
- **Regla:** en la apertura, verificar las afirmaciones del traspaso contra los
  archivos actuales antes de planificar; el archivo es la verdad, y la divergencia
  se declara en el acuse de recibo.
- **Principio:** B.1 (no operar sobre estado supuesto).
- **Contexto:** v05 afirmaba que el paso 33 no estaba registrado en `PASOS`; si lo
  estaba (id 4). El sintoma real (`run_all(only = 33)` no corre) venia del
  desacople id/prefijo, no de un paso ausente. Planificar sobre la afirmacion del
  traspaso habria producido un fix incorrecto.

### A6 — Una feature de UI puede requerir datos que el JSON del cliente no expone
- **Regla:** antes de comprometer una feature, verificar que el dato exista en el
  JSON embebido (bloques `rbd`, `territorial`, `sin_vigente`); si no, la feature es
  de dos archivos (generador R + template) y exige regeneracion.
- **Principio:** B.1; B.4 (criterio de exito realista).
- **Contexto:** "motivo por ano al hacer click" parecia solo-template, pero el
  motivo no estaba en `rbd_lst`; hubo que agregar la columna en el generador.

### A7 (reafirmado) — Definir criterio observable antes de iterar
- **Regla:** ante una feature de UI poco especificada ("trayectoria detallada",
  "reubicar"), elicitar el comportamiento esperado y fijar el criterio de exito
  ANTES de tocar el template. Se cumplio esta sesion (elicitacion de 2 preguntas).

---

## 8. Decisiones de diseno

### D5 — IDs de paso = prefijo del archivo (30-33)
- **Decision:** los `id` de `PASOS` pasan de `1-4` a `30/31/32/33`.
- **Alternativa:** mantener IDs secuenciales 1-4.
- **Justificacion:** `run_all(only = 33)` es intuitivo (el numero del archivo es el
  numero del paso) y cierra el sintoma registrado en v05.
- **Implicancia:** `from/to/only/skip` operan sobre 30-33; los ejemplos del script
  se actualizaron; muscle-memory de `skip = c(1, 2)` deja de aplicar.

### D6 — Un unico orquestador (00_build.R archivado)
- **Decision:** `00_build.R` (stub con todos los pasos comentados) se archiva;
  `00_run_all.R` queda como punto de entrada unico.
- **Alternativa:** absorber `00_build.R` o mantener ambos.
- **Justificacion:** `00_run_all.R` ya estaba completo; el stub solo aportaba
  ambiguedad y riesgo (politica seccion 4: orquestador como entrada unica).

### D7 — Poblacion de la lista sin-vigente y conteo autoritativo
- **Decision:** la lista de EE sin categoria vigente usa `vigente === "s/i"`
  (evaluados pero sin categoria 2019); el conteo de cabecera viene del parquet
  `sin_vigente` (autoritativo, por motivo).
- **Alternativa considerada:** incluir tambien `vigente === null`, o derivar el
  conteo client-side desde los EE.
- **Justificacion:** "s/i" es la poblacion coherente con el parquet; los `null`
  (sin medicion 2019) son un bucket distinto. Mantener el numero del parquet como
  autoritativo respeta el invariante de cifras y evita divergencias al filtrar.
- **Tension resuelta:** lista client-side (navegable, filtro-aware) vs conteo
  oficial (entidad completa); se muestran ambos, rotulados.

---

## 9. Constantes y parametros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `PASOS` (ids) | 30, 31, 32, 33 | 00_run_all.R | Cambio v06: antes 1-4 |
| `LIMITE` (territorios comparables) | 10 | 33_motor_template.html | Sin cambios |
| `PCT_DIGITS` | 4 | 33_generar_html.R | Sin cambios |
| Alfa heatmap | 0.10 + t*0.55 | 33_motor_template.html | Sin cambios |
| ANIO_VIGENTE | 2019 (= max anios) | JSON (meta) | Se recalcula con SIMCE 2025 |
| CAT_ORDEN / CAT_COLORS | Insuficiente→Alto | 33_generar_html.R | Sin cambios |
| `rbd.motivo` | nuevo en JSON | 33_generar_html.R | Motivo por rbd×nivel×anio (s/i) |

---

## 10. Arquitectura de archivos

Escaner al cierre (2026-06-12 21:51:39, `estructura_actual.md`): 16 carpetas, 75
archivos. Delta de estructura respecto a la apertura: `00_build.R` movido a
`_archivo/20260612/` (fuera de Git, excluido del escaner); 5 archivos nuevos en
`50_documentacion/activa/decisiones/`. Sin otros cambios estructurales. La
estructura sigue la canonica de la politica (decenas, naming, ubicacion).

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**P-glosa-oficial (pendiente menor, heredado de v05)**
- **Descripcion:** contrastar las definiciones de las 4 categorias del panel de
  notas con la glosa oficial de la Agencia.
- **Tipo:** documentacion / correccion de contenido.
- **Complejidad:** Baja.
- **Dependencia:** que el titular tenga la glosa oficial.
- **Criterio de exito:** las 4 definiciones coinciden con la fuente oficial.

**P-taxonomia-subdivision (deuda tecnica de backlog, heredada)**
- **Descripcion:** subdividir "Diseno UI / motor" (15, ~39%, supera el 25%) en
  subcategorias (p. ej. "Motor base" vs "Hoja comparativa" vs "Modo EE") y
  reconciliar el descuadre heredado de la tabla tematica de v05 (suma 1 menos que
  el detalle cronologico).
- **Tipo:** deuda tecnica / documentacion.
- **Complejidad:** Baja-Media.
- **Precaucion:** hacerla en una sesion con cierre, no como tarea suelta.
- **Criterio de exito:** tabla tematica que cuadra con el detalle cronologico (38)
  y ninguna categoria > 25%.

**P-comentario-stale-limite (micro-deuda, nueva)**
- **Descripcion:** `33_motor_template.html` L~1911 tiene `// respeta el tope de 4`
  cuando `LIMITE = 10`.
- **Tipo:** limpieza de comentario.
- **Complejidad:** Trivial.
- **Criterio de exito:** comentario coherente con el valor vigente.

**P-ee-sin-medicion (mejora de producto, nueva, requiere input de dominio)**
- **Descripcion:** los EE con `vigente === null` (sin medicion en 2019) no aparecen
  en ninguna vista del modo territorio. Evaluar si merecen un bucket explicito ("no
  rindio 2019") o quedan deliberadamente fuera.
- **Tipo:** funcionalidad / decision de producto.
- **Complejidad:** Media.
- **Precaucion:** definir el criterio con el titular antes de iterar (A7); no
  romper la coherencia con el conteo del parquet.

### Evaluacion de deuda tecnica
- **Zona fragil:** ninguna activa. La orquestacion quedo saneada (elimina A1).
- **Oportunidad:** `33_motor_template.html` paso de ~95 KB a ~100 KB; el modo EE es
  ya un subsistema con identidad. Monitorear, no actuar (B.2); la entrega es un
  HTML unico y modularizar romperia esa propiedad.

### Auditoria de cierre (politica 5.6)
- #2 ¿Pipeline corre de cero sin intervencion manual? → **Si** (resuelto: un
  orquestador, `run_all()` end-to-end 30→33).
- #5 ¿Cada transformacion critica tiene check de validacion? → Sin cambios en el
  pipeline R; el generador conserva su bloque stopifnot (C.8).
- #6 ¿Outputs reproducibles e idempotentes? → Si (regenera identico desde template
  + parquets).
- #7 ¿Decisiones metodologicas como constantes nombradas? → Si.
- #8 ¿Nombres sin tildes/ñ/espacios? → Si (5 archivos nuevos en snake_case).
- Resto: sin cambios respecto a v05.

### Ruta sugerida para la proxima sesion (sesion 7)
Aplicando los criterios de priorizacion (1.2.4):

1. **P-comentario-stale-limite** (trivial; abre la sesion limpiando la micro-deuda
   detectada). Criterio: comentario coherente.
2. **P-ee-sin-medicion** (funcionalidad media con input de dominio; entrar temprano
   con mas contexto). Criterio: decidido con el titular y, si aplica, bucket
   implementado sin romper el conteo del parquet.
3. **P-taxonomia-subdivision** (sesion con cierre; reconcilia el backlog).
4. **P-glosa-oficial** (cuando el titular tenga la glosa).

**Diferir:** modularizacion del template (no mientras sea un HTML unico autocontenido).

---

## 12. Instrucciones especificas para la proxima sesion

- 🔒 Agregacion = conteo de establecimientos. Jamas ponderacion por matricula,
  jamas GSE.
- 🔒 Basica y media nunca se mezclan en una cifra agregada.
- 🔒 El conteo de "sin categoria vigente" es el del parquet `sin_vigente`
  (autoritativo, por motivo). La lista client-side (`vigente === "s/i"`) es ayuda
  de navegacion, no la fuente del numero.
- 🔒 El pct de la hoja por territorio es el autoritativo del territorial (R). En la
  comparativa, el pct se deriva de los EE visibles (excepcion legitima al filtrar).
- 🔒 `40_salidas/motor_categoria.html` es fuente de verdad; `docs/index.html` es
  copia derivada. No editar `docs/` a mano.
- ✅ ANTES de prometer una feature de UI, verificar que el dato exista en el JSON
  embebido (bloques rbd/territorial/sin_vigente). Si no esta, es cambio de dos
  archivos (generador + template) (A6).
- ✅ `run_all()` usa ids = prefijo del archivo (30-33); `only/from/to/skip` operan
  sobre esos numeros.
- ✅ ANTES de verificar un cambio del template: (1) reemplazar, (2) confirmar bytes,
  (3) regenerar. Nunca regenerar antes de reemplazar (A1).
- ✅ ANTES de editar `33_motor_template.html` al reabrir: confirmar marcadores de
  version (p. ej. `function EeRow`, `RBD_MOTIVO`, `LIMITE = 10`) (A2).
- ✅ ANTES de tocar `CatData`, recordar que `nom_rbd` puede venir null.
- ✅ ANTES de cualquier push, `git status` revisado.
- ⚠️ NO reintroducir `00_build.R` (orquestador unico = `00_run_all.R`).
- ⚠️ NO definir comportamiento de producto sobre EE (p. ej. "no rindio") de forma
  autonoma: requiere input de dominio del titular.
- ⚠️ NO usar "EE" en texto visible al usuario: escribir "establecimientos".
- ⚠️ NO reintroducir `text-transform: uppercase` en ninguna parte del sitio.

---

## 13. Fragmentos de codigo de referencia

### Patron correcto: id de paso = prefijo del archivo (orquestador)
```r
PASOS <- list(
  list(id = 30L, etiqueta = "Construir auxiliares (catalogos territoriales)",
       ruta = file.path("30_procesamiento", "30_construir_auxiliares.R")),
  list(id = 33L, etiqueta = "Generar motor HTML autocontenido",
       ruta = file.path("30_procesamiento", "33_generar_html.R"))
)
# run_all(only = 33) ejecuta exactamente el generador.
```

### Patron correcto: exponer una columna opcional con degradacion graceful
```javascript
// El template no asume que el JSON traiga 'motivo'; si falta, no rompe.
const R_MOT = R.motivo || null;
const mot = R_MOT ? R_MOT[i] : null;
if (mot) { /* poblar indice solo cuando existe */ }
```

### Patron correcto: componente de fila unico reusado (DRY)
```javascript
// EeRow se usa en CatColumn (columnas) y en SinVigente (lista). Una sola
// definicion evita el patron de bug por logica duplicada en dos lugares.
function EeRow({ ee }) {
  const [open, setOpen] = React.useState(false);
  // ... fila clickeable + detalle de trayectoria en texto ...
}
```

---

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 7 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del Project;
> leelo desde ahi. Retomamos slep_categoria_desempeno en sesion 7. Foco sugerido:
> P-comentario-stale-limite (limpieza trivial), luego P-ee-sin-medicion (decision
> de producto sobre EE sin medicion 2019) y P-taxonomia-subdivision. Adjunto el
> traspaso v06 y el escaner actual.

### Documentos para la proxima sesion

**1. Protocolo en knowledge base (NO se adjuntan; verificar que esten al dia):**
- `POLITICA_PROYECTO.md`
- `SETTINGS_Y_PROMPTS_OPERACIONALES.md`

**2. Opcionales segun el foco real:**
- `CLAUDE.md` (si la sesion corre en Claude Code).
- `30_procesamiento/33_motor_template.html` como MOLDE/insumo si se aborda
  P-comentario-stale-limite o P-ee-sin-medicion (verificar marcadores A2 al cargar).

**3. Especificos de la sesion (SI se adjuntan):**
- `50_documentacion/traspasos/traspaso_cierre_v06.md` (este archivo).
- `50_documentacion/estructura/estructura_actual.md` (re-ejecutar el escaner al reabrir).
- `30_procesamiento/33_motor_template.html` actual (~100 KB) si se sigue con UI.
- `30_procesamiento/33_generar_html.R` si se toca el JSON (p. ej. nuevo bucket EE).

### Nota final obligatoria
Si algun archivo listado cambio entre sesiones, adjuntar la version mas
actualizada al abrir y avisarlo en el mensaje de apertura. En particular,
`33_motor_template.html` evoluciono a ~100 KB en la sesion 6 (componente `EeRow`,
indice `RBD_MOTIVO`): adjuntar la version actual, no una previa (A2).
