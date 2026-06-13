# Traspaso de cierre v05 — slep_categoria_desempeno

## 1. Identificacion

- **Proyecto:** slep_categoria_desempeno
- **Version:** v05
- **Fecha:** 2026-06-12
- **Sesion:** 5 — foco en UI de la hoja comparativa (nueva) y panel de notas
  metodologicas; ocho intervenciones encadenadas sobre `33_motor_template.html`.
- **Entorno:** R 4.5.2 en Positron, macOS aarch64. Modelo: Claude Opus 4.8.
- **Archivos principales modificados:** `30_procesamiento/33_motor_template.html`
  (unico archivo de codigo tocado en toda la sesion). Regeneraciones de
  `40_salidas/motor_categoria.html` y `docs/index.html` via el generador.

---

## 2. Resumen ejecutivo

La sesion 5 era de UI/documentacion (ruta del v04: P-decisiones, P-metodologia,
P-ee-trayectoria) pero derivo en su totalidad hacia la hoja comparativa, una
funcionalidad nueva pedida por el titular al inicio. Se construyo una segunda
hoja "Comparar territorios" (tabla n/% por categoria, hasta 10 entidades de tipo
mixto), un selector multi-seleccion con checkboxes, y un panel colapsable de
notas metodologicas (P2, cumplido). Se aplicaron siete iteraciones visuales sobre
la tabla (separacion de columnas, hover cruz en gris, heatmap por categoria,
alineaciones, eliminacion global de ALLCAPS, agrandado de textos, formato "% (n)",
tabla como tarjeta). No hubo bugs de codigo, pero si un incidente operativo
recurrente: el generador se corrio dos veces sobre el template viejo (desfase
entre reemplazo manual y regeneracion), y una version antigua del template se
subio al chat por error. P1 (P-decisiones) quedo bloqueado todo el rato esperando
el molde de formato; P3 (P-ee-trayectoria) no se abordo. Se detecto y registro
deuda nueva: el paso 33 no esta en el orquestador.

---

## 3. Estado al cierre

### Que funciona (ultima ejecucion exitosa)
- Pipeline completo regenerando el motor: `33_generar_html.R` corrio limpio
  (ultima vez con `Plantilla: 95272 caracteres`, HTML de ~948 KB).
- Hoja "Por territorio" (la original): intacta, sin cambios de comportamiento.
- Hoja "Comparar territorios" (nueva): tabla n/% por categoria, hasta 10
  entidades mixtas, filtro de dependencia global, fila "sin categoria vigente",
  heatmap por categoria, hover cruz en gris, multi-seleccion por checkboxes.
- Panel "Notas metodologicas" colapsable al pie de ambas hojas.
- GitHub Pages: el sitio sigue publicado; cada regeneracion actualiza
  `docs/index.html`.

### Que no funciona / pendiente
- `run_all(only = 33)` no ejecuta el generador: el paso 33 no esta registrado en
  `PASOS` de `00_run_all.R`, y `00_build.R` tiene todos los pasos comentados. El
  HTML se regenera a mano con `source(here::here("30_procesamiento",
  "33_generar_html.R"))`. (Deuda P-orquestar-paso-33.)

### Delta respecto a v04
- v04 cerro con el proyecto publicado y sin hoja comparativa. v05 agrega toda la
  hoja comparativa, el panel de notas y el refinamiento visual. Sin cambios en el
  pipeline R (30-33) ni en la estructura de carpetas.

---

## 4. Registro detallado de cambios

Un bloque por cambio conceptualmente independiente (solicitud distinguible del
titular). Todos tocan exclusivamente `33_motor_template.html`.

### Cambio 28 — Hoja comparativa "Comparar territorios" (P-comparativa)
- **Categoria:** Diseno UI / motor.
- **Que:** segunda hoja conmutable por pestaña (`Segmented` "Vista"). Tabla con
  filas = 4 categorias (orden semantico Insuficiente -> Alto) y columnas =
  entidades elegidas (comuna/SLEP/region, tipo mixto). Cada celda n y %; fila
  "Total categorizados" y fila "Sin categoria vigente" al pie.
- **Por que (C.11):** el titular pidio contar y comparar la distribucion de
  establecimientos por categoria entre varias entidades a la vez, lo que la hoja
  por territorio (una entidad por vez) no permite.
- **Como se verifico (B.4):** render con 4 SLEPs lado a lado; n/% coherentes con
  la vista por territorio; transpilacion Babel sin errores.
- **Componentes nuevos:** `ComparativaSheet`, `CmpDepFilter`,
  `distEntidadComparativa`. Estado `hoja` y `cmpDep` en `App`.
- **Decision:** el % se calcula desde los EE visibles via `distEntidadComparativa`
  (mismo camino con y sin filtro de dependencia); respeta el 🔒 de no recalcular
  el territorial en cliente cuando no hay filtro, y la excepcion legitima cuando
  si lo hay.

### Cambio 29 — Panel de notas metodologicas (P2, P-metodologia)
- **Categoria:** Documentacion (en producto).
- **Que:** componente `NotasMetodologicas` colapsable al pie de ambas hojas, con
  6 notas (Categoria de Desempeno y sus 4 niveles; SLEP y dependencia actual;
  conteo sin ponderacion; sin GSE por diseno; categoria vigente y denominador;
  cobertura temporal con mencion de sin categorizacion 2020 y proxima con SIMCE
  2025) mas linea de fuente.
- **Por que (C.11):** el header ya traia un parrafo introductorio, pero faltaba
  la metodologia detallada al estilo del proyecto hermano.
- **Como se verifico (B.4):** despliegue/colapso correcto; texto usa
  "establecimientos educacionales" (no "EE"); transpilacion limpia.
- **Reusa** los estilos `.notes-*` ya presentes en el scaffold (sin CSS nuevo).
- **Salvedad documentada:** las definiciones de las 4 categorias fueron redactadas
  con criterio general, NO copiadas de la glosa oficial de la Agencia. Conviene
  contrastarlas con la fuente antes de publicar (pendiente menor P-glosa-oficial).

### Cambio 30 — Multi-seleccion con checkboxes en el selector de la comparativa
- **Categoria:** Diseno UI / motor.
- **Que:** `EntityModal` gana prop `multiple` (con `yaElegidas` y `limite`). En
  modo simple queda identico (hoja por territorio sin cambios); en modo multiple
  muestra checkboxes, acumula seleccion entre pestañas, respeta el tope, marca en
  gris las ya presentes, y confirma todas con "Agregar (N)". `addEntity` de la
  comparativa acepta uno o varios items (array).
- **Por que (C.11):** el titular pidio no agregar de a uno.
- **Como se verifico (B.4):** seleccion multiple cruzando pestañas comuna/SLEP/
  region, tope respetado, ya-agregadas deshabilitadas; transpilacion limpia.
- **CSS nuevo:** `.check-box`, `.check-row.is-checked`, `.modal-hint-multi`,
  `.estab-popup-btn.is-primary` y estados `:disabled`.

### Cambio 31 — Limite de territorios a 7
- **Categoria:** Diseno UI / motor.
- **Que:** `LIMITE` y default del modal de 4 a 7; los tres textos de limite
  parametrizados para leer la constante (sin numeros magicos, C.10).
- **Como se verifico (B.4):** tope efectivo en 7.

### Cambio 32 — Limite de territorios a 10
- **Categoria:** Diseno UI / motor.
- **Que:** `LIMITE` y default del modal de 7 a 10 (segunda solicitud, posterior).
- **Como se verifico (B.4):** tope efectivo en 10; `overflow-x: auto` evita
  ruptura de layout con 10 columnas.

### Cambio 33 — Lote visual 1 de la tabla comparativa
- **Categoria:** Diseno UI / motor.
- **Que (seis ajustes en una solicitud):** (a) separacion de columnas (bordes
  verticales + padding); (b) hover cruz que resalta fila y columna; (c) heatmap en
  fila Insuficiente (rojo por intensidad); (d) territorios centrados, columna
  Categoria a la derecha; (e) eliminacion GLOBAL de ALLCAPS (6 `text-transform:
  uppercase` removidos de todo el sitio, no solo la comparativa); (f) agrandado de
  textos pequeños y separacion de los años de trayectoria (gap 6->11, rotulo
  9->11px).
- **Por que (C.11):** lote de pulido visual pedido por el titular tras revisar la
  hoja.
- **Como se verifico (B.4):** captura del titular; 0 uppercase restantes;
  transpilacion limpia.

### Cambio 34 — Formato "% (n)", menos negrita, tabla como tarjeta
- **Categoria:** Diseno UI / motor.
- **Que:** en las 4 filas de categoria, orden invertido a porcentaje primero
  (negro, peso medio) y n entre parentesis (gris oscuro, sin negrita). Reduccion
  de negrita en cabeceras/categoria/total. La tabla pasa a tarjeta con fondo papel
  propio, borde y sombra, separada del crema del sitio.
- **Por que (C.11):** el titular pidio menos negrita, gris mas oscuro, dato
  principal en %, y mejor contraste de la tabla contra el fondo amarillo.
- **Como se verifico (B.4):** captura del titular; transpilacion limpia.

### Cambio 35 — Heatmap por categoria, renombre de encabezado, hover gris
- **Categoria:** Diseno UI / motor.
- **Que:** (a) heatmap extendido a las 4 filas, cada una con el color de su
  categoria (helper `hexToRgba` sobre `CAT_COLORS`, intensidad normalizada al
  maximo de la fila); (b) encabezado "Categoria" -> "Categoria de desempeño";
  (c) hover cruz de azul a gris translucido via `box-shadow inset` (no pisa el
  background inline del heatmap), con bordes en `--fg-3` para las celdas
  resaltadas.
- **Por que (C.11):** solicitud del titular; el azul se reserva para otros usos.
- **Decision / cambio de significado declarado:** al pasar de "solo Insuficiente
  rojo (gravedad)" a "todas las filas con su color", la intensidad ya no expresa
  gravedad sino CONCENTRACION de cada categoria en el territorio (en Alto, mas
  intenso = mejor). Documentado y comunicado al titular.
- **Como se verifico (B.4):** captura del titular; sin referencias huerfanas a la
  logica vieja (`INSUF`/`maxInsuf`/`esHeat` eliminados); transpilacion limpia.

---

## 5. Backlog acumulativo

### Objetivo del proyecto
slep_categoria_desempeno es un motor interactivo (R + HTML autocontenido) que
compara la distribucion de establecimientos por Categoria de Desempeno (Alto /
Medio / Medio-Bajo / Insuficiente) de la Agencia de Calidad, entre comunas,
SLEPs, regiones y el nivel nacional, separando basica y media. Pipeline en R
(xlsx -> parquet -> JSON embebido -> HTML), publicado en GitHub Pages. Para el
equipo de Monitoreo del SLEP Costa Central, desde 2026. Datos publicos.

(Nota v03: la opcion "nacional" del selector se elimino en la sesion 3 por
volumen de EE; se agrego seleccion de establecimiento individual. El objetivo
permanente del proyecto no cambia.)

(Nota v04: el proyecto quedo publicado en GitHub Pages en
`https://tomgc.github.io/slep_categoria_desempeno/`. El objetivo permanente no
cambia.)

(Nota v05: se agrego una segunda hoja de comparacion entre territorios. El
objetivo permanente no cambia: sigue siendo comparar la distribucion de
establecimientos por categoria entre entidades.)

### Nota metodologica del conteo
Un "cambio" es una solicitud distinguible del titular, no las acciones tecnicas
que la implementan. No cuentan los errores del asistente corregidos de
inmediato; si cuentan los bugfixes reportados por el titular. Clasificacion por
intencion primaria. Fuentes: registro de la sesion.

### Clasificacion tematica (subdividida en sesion 5)
La categoria "Scaffold e inicializacion" (52% en v04) se desdobla aqui en
"Scaffold inicial" y "Migracion y publicacion / DevOps", como se venia
recomendando desde v04.

| Categoria | N | % | Descripcion |
|---|---|---|---|
| Diseno UI / motor | 14 | 40 | Grillas (v01); motor HTML + iteraciones (v03); Pages (v04); hoja comparativa, multi-seleccion, limites, lotes visuales (v05) |
| Scaffold inicial | 9 | 26 | Estructura, scaffold, repo, decisiones v01 |
| Migracion y publicacion / DevOps | 5 | 14 | Auditoria seguridad, gobernanza, LICENSE, CI, README migracion (v04) |
| Pipeline R | 3 | 9 | Pasos 30-32 de procesamiento |
| Documentacion (en producto) | 1 | 3 | Panel de notas metodologicas (v05) |
| Orquestacion | 1 | 3 | 00_run_all.R |
| Datos y normalizacion | 1 | 3 | Esquema xlsx, normalizacion categoria |

(Subdivision aplicada: las 14 entradas de "Scaffold e inicializacion" del v04 se
reparten en "Scaffold inicial" 9 y "Migracion y publicacion / DevOps" 5. "Diseno
UI / motor" crece a 14 (40%) por las 7 entradas de UI de la sesion 5: supera el
umbral del 25%, candidato a subdividir en la proxima sesion (p. ej. "Motor base"
vs "Hoja comparativa"). Total 35 cambios.)

### Resumen estadistico por sesion
| Sesion | Traspasos | N cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 11 | (v01) | Scaffold y diseno |
| 2 | v02 | 4 | Opus 4.8 | Pipeline R 30-32 + orquestador |
| 3 | v03 | 6 | Opus 4.8 | Motor HTML (paso 33) + iteraciones UI |
| 4 | v04 | 6 | Opus 4.8 | Migracion a GitHub + Pages |
| 5 | v05 | 8 | Opus 4.8 | Hoja comparativa + notas + pulido visual |
| **Total** | | **35** | | |

### Detalle cronologico
- **Sesion 1 (cambios 1-11):** ver traspaso v01 (scaffold, repo, diseno de
  datos y UI, decisiones 1-3).
- **Sesion 2 (cambios 12-15):** 12 auxiliares; 13 leer/normalizar; 14
  agregacion territorial; 15 orquestador + archivo de stub.
- **Sesion 3 (cambios 16-21):** 16 generador `33_generar_html.R`; 17 template
  base `33_motor_template.html`; 18 iteracion UI tanda 1 (paleta inicial, año
  completo, comuna en ficha); 19 tanda 2 (azul institucional); 20 tanda 3
  (trayectoria rediseñada, filtro comuna, fix pct 0,0%); 21 tanda 4 (selector
  EE, filtro dependencia, leyenda agrandada, distribucion desde EE).
- **Sesion 4 (cambios 22-27):** 22 auditoria de seguridad pre-migracion;
  23 `gobernanza_datos.md` (Rama A ligera); 24 `LICENSE` (MIT con clausula de
  datos) + alineacion del header del generador; 25 workflow de CI de seguridad;
  26 publicacion en Pages (modelo B, docs/ + copia automatica en el generador);
  27 README de migracion.
- **Sesion 5 (cambios 28-35):** 28 hoja comparativa "Comparar territorios"
  (tabla n/%, entidades mixtas, filtro dependencia, fila sin-vigente); 29 panel
  de notas metodologicas colapsable (P2); 30 multi-seleccion con checkboxes en el
  selector; 31 limite a 7; 32 limite a 10; 33 lote visual 1 (separacion columnas,
  hover cruz, heatmap Insuficiente, alineaciones, eliminacion global de ALLCAPS,
  agrandado de textos, separacion de años de trayectoria); 34 formato "% (n)",
  menos negrita, tabla como tarjeta; 35 heatmap por categoria, renombre de
  encabezado a "Categoria de desempeño", hover gris con bordes mas oscuros.

### Delta del backlog
8 entradas nuevas (28-35). Taxonomia subdividida: "Scaffold e inicializacion" ->
"Scaffold inicial" (9) + "Migracion y publicacion / DevOps" (5); nueva categoria
"Documentacion (en producto)" (1). "Diseno UI / motor" 7 -> 14. Total 27 -> 35.

---

## 6. Bugs de la sesion

No aplica en esta sesion: no hubo bugs de codigo. Hubo dos incidentes operativos
(no de codigo), documentados como aprendizajes en la seccion 7:
- El generador se corrio sobre el template viejo (desfase reemplazo/regeneracion).
- Una version antigua del template se subio al chat por error.

Ambos se diagnosticaron comparando el tamaño del template (`Plantilla: N
caracteres` del log vs. bytes reales del archivo entregado).

---

## 7. Aprendizajes y restricciones descubiertas

### A1 — El desfase entre reemplazo manual y regeneracion produce "no veo el cambio"
- **Regla:** tras entregar un template nuevo, la verificacion DEBE seguir el
  orden: (1) reemplazar el archivo, (2) confirmar su tamaño en bytes, (3)
  regenerar. Si se regenera antes de reemplazar, el generador lee el template
  viejo y el cambio "no aparece", sin que haya ningun bug.
- **Principio:** B.4 (criterio de exito verificable antes de dar por hecho).
- **Contexto (que pasa si se viola):** se pierde tiempo buscando un bug
  inexistente en el codigo. Ya ocurrio dos veces esta sesion.
- **Diagnostico canonico:** comparar `Plantilla: N caracteres` del log del
  generador con `wc -c` del template. Si no coinciden, el generador leyo otro
  archivo.
- **Mitigacion estructural:** P-orquestar-paso-33 (registrar el paso en el
  orquestador) elimina la clase entera de error, porque `run_all` lee siempre el
  template vigente del repo.

### A2 — Una version antigua del template puede entrar al chat por error
- **Regla:** al retomar trabajo sobre `33_motor_template.html`, verificar que la
  version cargada contenga los marcadores de los ultimos cambios (p. ej.
  `function EntityModal({ onSelect, onCancel, multiple`) antes de editar; si no,
  recuperar la version correcta desde la ultima entrega (`outputs`) en vez de
  construir sobre la vieja.
- **Principio:** B.1 (no operar sobre estado supuesto), regla permanente "nunca
  modificar codigo sin haberlo leido primero".
- **Contexto:** se empezo a editar sobre un template pre-multi-seleccion; se
  detecto al fallar un `sed` de constante y se recupero la version correcta.

### A3 — Un background inline bloquea el highlight por background en CSS
- **Regla:** cuando una celda tiene `style={{ background }}` inline (heatmap), el
  hover NO puede expresarse con `background` en CSS (el inline gana). Usar
  `box-shadow: inset 0 0 0 9999px <color>` para el realce, que se superpone sin
  competir con el inline.
- **Principio:** C.6 (rigor), B.2 (solucion minima que funciona).
- **Contexto:** el hover cruz dejo de verse al extender el heatmap a todas las
  celdas; se resolvio con box-shadow inset.

### A4 — Heatmap por categoria cambia la semantica de la intensidad
- **Regla:** un heatmap monocromo de gravedad (solo Insuficiente, mas rojo = peor)
  y un heatmap por color de categoria (cada fila su color) NO significan lo mismo:
  el segundo expresa concentracion, no gravedad. Declarar el cambio de
  significado al titular antes de aplicarlo.
- **Principio:** C.10 (transparencia de decisiones metodologicas).
- **Contexto:** se comunico explicitamente; el titular acepto la lectura de
  concentracion.

---

## 8. Decisiones de diseno

### D1 — Filtro de dependencia de la comparativa: universo completo, no presentes
- **Decision:** el `CmpDepFilter` ofrece las 5 dependencias del catalogo
  (`DEPE_LABELS`) mas "Todas", no solo las presentes en una entidad.
- **Alternativa:** listar solo las dependencias presentes (como en la hoja por
  territorio).
- **Justificacion:** el conjunto de entidades de la comparativa es heterogeneo;
  un filtro estable e identico para todas las columnas es mas predecible.

### D2 — Limite de territorios comparables: 10
- **Decision:** tope en 10 (evoluciono 4 -> 7 -> 10 en la sesion).
- **Justificacion:** equilibrio entre comparabilidad y utilidad; `overflow-x:
  auto` absorbe el desborde horizontal en pantallas chicas.
- **Implicancia:** con 10 columnas hay scroll lateral en laptops; aceptado.

### D3 — Heatmap por color de categoria (intensidad = concentracion)
- **Decision:** cada fila pinta su fondo con el color de su categoria, alfa
  proporcional al % normalizado al maximo de la fila.
- **Alternativa considerada:** rampa verde->rojo de "bueno a malo" transversal.
- **Justificacion:** mantiene la paleta de 4 categorias coherente con el resto
  del motor; se descarto la rampa verde-rojo para no introducir una quinta y
  sexta familia de color.
- **Tension resuelta:** intensidad como concentracion, no gravedad (ver A4).

### D4 — Formato de celda "% (n)"
- **Decision:** porcentaje como dato principal (negro), n entre parentesis
  secundario (gris). Solo en las 4 filas de categoria; total y sin-vigente
  muestran n solo.
- **Justificacion:** pedido del titular; el % es la medida comparable entre
  territorios de distinto tamaño.

---

## 9. Constantes y parametros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `LIMITE` (territorios comparables) | 10 | 33_motor_template.html | Cambio de valor: 4 -> 7 -> 10 en esta sesion |
| `limite` (default EntityModal) | 10 | 33_motor_template.html | Alineado con `LIMITE` |
| Alfa heatmap | 0.10 + t*0.55 | 33_motor_template.html | t = pct / maxPctPorCat[categoria] |
| Highlight hover | rgba(60,54,44,0.06) / 0.11 | 33_motor_template.html | Gris; cruce mas intenso |
| ANIO_VIGENTE | 2019 | JSON (M) | Sin cambios |
| CATEGORIAS | Insuficiente->Alto | JSON (M) | Orden semantico, sin cambios |

---

## 10. Arquitectura de archivos

Sin cambios estructurales. El escaner al cierre (2026-06-12 12:41,
`estructura_actual.md`) refleja la estructura canonica vigente: 16 carpetas, 68
archivos. El unico archivo de codigo modificado fue
`30_procesamiento/33_motor_template.html` (de ~66 KB en v04 a ~95 KB en v05 por
los componentes nuevos). `40_salidas/motor_categoria.html` y `docs/index.html`
se regeneraron. No se ejecuto un escaneo nuevo posterior a esta sesion porque no
hubo cambios de estructura (solo de contenido de un archivo ya inventariado);
ejecutar el escaner al reabrir.

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**P1 — P-decisiones (BLOQUEADO por molde)**
- **Descripcion:** crear los archivos de decision pendientes de v03
  (cobertura_temporal, paleta_categorias) y v04 (visibilidad-repo, modelo-pages,
  licencia).
- **Tipo:** documentacion.
- **Bloqueante:** requiere el molde de formato
  `50_documentacion/activa/decisiones/20260611_decision_sin_gse.md` (no se
  adjunto en la sesion 5).
- **Complejidad:** Baja (una vez con el molde).
- **Criterio de exito:** 5 archivos en `decisiones/` con el formato canonico del
  proyecto.
- **Precaucion:** no inventar plantilla; usar el molde existente.

**P3 — P-ee-trayectoria (no abordado)**
- **Descripcion:** rediseño del modo EE (click en fila despliega trayectoria
  detallada; reubicar bloque "Sin categoria vigente").
- **Tipo:** funcionalidad / mejora visual.
- **Complejidad:** Media-Alta.
- **Principios:** B.2, C.6.
- **Precaucion:** definir criterio observable ANTES de iterar parametros (A7 del
  proyecto: el patcheo incremental sin criterio no converge).

**P-orquestar-paso-33 (deuda nueva, alta prioridad)**
- **Descripcion:** el paso 33 (`33_generar_html.R`) no esta en `PASOS` de
  `00_run_all.R`; `00_build.R` tiene todos los pasos comentados. El HTML se
  regenera a mano. Conviven dos orquestadores con roles solapados.
- **Tipo:** deuda tecnica.
- **Complejidad:** Media (protocolo 4.1; decidir si `00_build.R` se absorbe en
  `00_run_all.R` o se elimina).
- **Criterio de exito:** `run_all()` corre el pipeline 30->33 end-to-end; un solo
  orquestador canonico.
- **Impacto:** elimina la clase entera de error A1 (desfase template/regeneracion).

**P-glosa-oficial (pendiente menor, nuevo)**
- **Descripcion:** contrastar las definiciones de las 4 categorias del panel de
  notas con la glosa oficial de la Agencia de Calidad (hoy redactadas con criterio
  general, no citadas de fuente).
- **Tipo:** documentacion / correccion de contenido.
- **Complejidad:** Baja.
- **Criterio de exito:** las 4 definiciones coinciden con la fuente oficial.

### Evaluacion de deuda tecnica
- **Zona fragil:** ausencia de orquestacion del paso 33 (viola el principio del
  orquestador como punto de entrada unico; politica seccion 4). Cada regeneracion
  manual reintroduce el riesgo del incidente A1.
- **Oportunidad:** `33_motor_template.html` paso de ~66 KB a ~95 KB; la hoja
  comparativa es ya un subsistema con identidad propia. Si crece mas, evaluar
  separar su logica, pero NO mientras sea un solo archivo autocontenido (la
  entrega es un HTML unico; modularizar romperia esa propiedad). Monitorear, no
  actuar aun (B.2).

### Auditoria de cierre (politica 5.6)
- #2 ¿Pipeline corre de cero sin intervencion manual? -> **No** para el paso 33
  (no esta en el orquestador). Se agrega como pendiente P-orquestar-paso-33.
- #5 ¿Cada transformacion critica tiene check de validacion? -> Sin cambios en el
  pipeline R esta sesion; aplica a sesiones de pipeline.
- #6 ¿Outputs reproducibles e idempotentes? -> Si (el generador regenera identico
  desde el template + JSON).
- #7 ¿Decisiones metodologicas como constantes nombradas? -> Si (LIMITE, alfas,
  colores via CAT_COLORS).
- #8 ¿Nombres sin tildes/ñ/espacios? -> Si (sin archivos nuevos).
- Resto: sin cambios respecto a v04.

### Ruta sugerida para la proxima sesion (sesion 6)
Aplicando los criterios de priorizacion (1.2.4):

1. **P-orquestar-paso-33** (deuda tecnica que elimina una clase de error
   recurrente). Complejidad Media. Criterio: `run_all()` end-to-end 30->33.
   Justificacion: es deuda que ya causo dos incidentes operativos; resolverla
   antes de seguir construyendo UI evita repetirlos.
2. **P1 / P-decisiones** (documentacion barata) — en cuanto se adjunte el molde
   `20260611_decision_sin_gse.md`. Criterio: 5 archivos de decision.
3. **P3 / P-ee-trayectoria** (funcionalidad de complejidad media-alta, al final
   con mas contexto). Criterio: click en fila de EE despliega trayectoria;
   "sin categoria vigente" reubicado.
4. **P-glosa-oficial** (correccion menor, cuando el titular tenga la glosa).

**Diferir:** subdivision de la taxonomia "Diseno UI / motor" (40%) — hacerla en
una sesion con cierre, no como tarea suelta.

---

## 12. Instrucciones especificas para la proxima sesion

- 🔒 Basica y media nunca se mezclan en una cifra agregada (la hoja comparativa
  opera sobre el nivel global).
- 🔒 Agregacion = conteo de establecimientos. Jamas ponderacion por matricula,
  jamas GSE.
- 🔒 El pct de la hoja por territorio es el autoritativo del territorial (R). En
  la comparativa, el pct se deriva de los EE visibles (excepcion legitima al
  filtrar dependencia).
- 🔒 `40_salidas/motor_categoria.html` es fuente de verdad; `docs/index.html` es
  copia derivada. No editar `docs/` a mano.
- ✅ ANTES de verificar un cambio del template: (1) reemplazar el archivo, (2)
  confirmar su tamaño en bytes, (3) regenerar. Nunca regenerar antes de
  reemplazar (incidente A1).
- ✅ ANTES de editar `33_motor_template.html` al reabrir: confirmar que la version
  cargada contiene los marcadores de los ultimos cambios (p. ej. `multiple` en la
  firma de `EntityModal`, `LIMITE = 10`). Si no, recuperar la version correcta
  (incidente A2).
- ✅ ANTES de tocar `CatData`, recordar que `nom_rbd` puede venir null: blindar
  operaciones de texto.
- ✅ ANTES de cualquier push, `git status` revisado.
- ⚠️ NO definir "establecimiento en riesgo" de forma autonoma: requiere input de
  dominio del titular.
- ⚠️ NO usar "EE" en texto visible al usuario: escribir "establecimientos
  educacionales".
- ⚠️ NO reintroducir `text-transform: uppercase` en ninguna parte del sitio (el
  titular pidio eliminar el ALLCAPS globalmente).

---

## 13. Fragmentos de codigo de referencia

### Patron correcto: derivar rgba desde un hex de categoria (heatmap)
```javascript
const hexToRgba = (hex, alfa) => {
  const h = String(hex).replace("#", "");
  const r = parseInt(h.length === 3 ? h[0] + h[0] : h.slice(0, 2), 16);
  const g = parseInt(h.length === 3 ? h[1] + h[1] : h.slice(2, 4), 16);
  const b = parseInt(h.length === 3 ? h[2] + h[2] : h.slice(4, 6), 16);
  return "rgba(" + r + ", " + g + ", " + b + ", " + alfa.toFixed(3) + ")";
};
```

### Patron correcto: highlight que no pisa un background inline
```css
/* La celda tiene style={{ background }} inline (heatmap); el hover usa
   box-shadow inset, no background, para superponerse sin competir. */
.cmp-table td.is-hl-cross {
  box-shadow: inset 0 0 0 9999px rgba(60, 54, 44, 0.11);
  border-color: var(--fg-3);
}
```

### Patron correcto: componente con doble modo (simple / multiple)
```javascript
// EntityModal({ onSelect, onCancel, multiple = false, yaElegidas = [], limite = 10 })
// - multiple=false: onClick={() => onSelect(item)}  (selecciona y cierra)
// - multiple=true:  acumula en estado, confirma con onSelect(sel) donde sel es array
// El consumidor (addEntity) acepta uno o varios:
const addEntity = (itemOrList) => {
  const nuevos = Array.isArray(itemOrList) ? itemOrList : [itemOrList];
  // ... agrega los que quepan sin duplicar, respetando LIMITE
};
```

---

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 6 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del Project;
> leelo desde ahi. Retomamos slep_categoria_desempeno en sesion 6. Foco sugerido:
> P-orquestar-paso-33 (registrar el paso 33 en el orquestador), luego P-decisiones
> (adjunto el molde) y P-ee-trayectoria. Adjunto el traspaso v05 y el escaner
> actual.

### Documentos para la proxima sesion

**1. Protocolo en knowledge base (NO se adjuntan; verificar que esten al dia):**
- `POLITICA_PROYECTO.md`
- `SETTINGS_Y_PROMPTS_OPERACIONALES.md`

**2. Opcionales segun el foco real:**
- `CLAUDE.md` (si la sesion corre en Claude Code).
- Protocolo 4.1 de SETTINGS (generar orquestador) — aplica directo a
  P-orquestar-paso-33.
- `50_documentacion/activa/decisiones/20260611_decision_sin_gse.md` como MOLDE de
  formato — imprescindible para desbloquear P1/P-decisiones.

**3. Especificos de la sesion (SI se adjuntan):**
- `50_documentacion/traspasos/traspaso_cierre_v05.md` (este archivo).
- `50_documentacion/estructura/estructura_actual.md` (re-ejecutar el escaner al
  reabrir).
- `30_procesamiento/33_motor_template.html` (critico si se aborda P3 o se sigue
  iterando la UI; verificar marcadores de version al cargar).
- `00_run_all.R` y `00_build.R` (criticos para P-orquestar-paso-33).
- `30_procesamiento/33_generar_html.R` (para entender como se consume el template
  en P-orquestar-paso-33).

### Nota final obligatoria
Si algun archivo listado cambio entre sesiones, adjuntar la version mas
actualizada al abrir y avisarlo en el mensaje de apertura. En particular,
`33_motor_template.html` evoluciono fuerte en la sesion 5 (~95 KB): adjuntar la
version regenerada/actual, no una previa (ver incidente A2).
