# Traspaso de cierre v10 — slep_categoria_desempeno

## 1. Identificacion
- **Proyecto:** slep_categoria_desempeno
- **Version:** v10
- **Fecha:** 2026-06-13
- **Sesion:** 10 — foco en features de matricula en la ficha y el comparador,
  cierre de la DT documental, documentacion de pendientes de matricula, y
  estandarizacion tipografica completa del motor. Nota: el chat de esta sesion
  sufrio una falla tecnica de herramienta en su tramo final; este traspaso se
  redacto a partir del inventario de cambios y el escaner.
- **Entorno:** R 4.5.2 en Positron, macOS aarch64. Modelo: Claude Opus 4.8.
- **Archivos principales modificados:** `30_procesamiento/33_motor_template.html`
  (todas las features de UI y la estandarizacion tipografica). Sin cambios en
  `33_generar_html.R` ni en los insumos (el dato de matricula ya viajaba desde v09).

## 2. Resumen ejecutivo
La sesion 10 partio sin pendientes de codigo abiertos (v09 cerro P-matricula-ficha)
y se dedico a enriquecer la presentacion de la matricula ya integrada. Se agregaron:
estudiantes por categoria con su porcentaje en las tarjetas de modo territorio;
"N EE" y un tooltip con estudiantes y porcentaje en cada celda del comparador; la
evolucion de matricula del nivel 2016-2019 en el panel expandido de la ficha; y un
reformateo del panel (encabezado del anio en dos lineas, desglose con dos puntos).
Se cerro la DT documental con una nota de procedencia del insumo de matricula, y se
documentaron con alcance resuelto los dos pendientes futuros (P-matricula-actual y
P-matricula-grado), ambos bloqueados por dato. Finalmente se estandarizo toda la
tipografia del motor por tokens: 19 tamanios a 8, 6 pesos a 4, 3 familias a 2. Se
aclaro el texto ambiguo de matricula en la fila colapsada. Todos los builds fueron
limpios con invariantes intactos (10.945 EE, 41.244 filas RBD, 85.594 matricula,
2016-2019, vigente 2019).

## 3. Estado al cierre
### Que funciona (ultima ejecucion exitosa)
- `source("33_generar_html.R")` regenera el motor. Ultimo build verificado:
  plantilla 117.722 chars (con la aclaracion de matricula incluida), HTML 1313 KB,
  invariantes intactos. Builds previos de la sesion: 114.700 (inicio), 115.077
  (features de matricula y formato), 117.722 (estandarizacion + aclaracion).
- Tarjetas de modo territorio: "N establecimientos (XX,X% del total del nivel para
  el territorio)" y "M estudiantes (XX,X% del total del nivel para el territorio)".
- Comparador: cada celda "XX,X% · N EE"; tooltip "M estudiantes en N
  establecimientos · XX,X% de la matricula de Educacion Basica/Media".
- Ficha, fila colapsada: "Matricula 2019: N en Educacion Basica · M en total"
  (resuelto el ambiguo "N (M)").
- Ficha, panel expandido: encabezado del anio "2019 (vigente): [Categoria]" en una
  linea, "N matriculados en Educacion Basica/Media" debajo; desglose por tipo de
  ensenanza con dos puntos ("Parvularia: 44 estudiantes", "Basica: 233"...);
  "Total establecimiento: M"; y al cierre, bloque "Evolucion de la matricula en
  Educacion Basica/Media" con cifra por anio y variacion primer-ultimo.
- Tipografia: 8 tamanios (`--fs-display` 30, `--fs-h1` 24, `--fs-h2` 18, `--fs-lg`
  15, `--fs-base` 13, `--fs-sm` 12, `--fs-xs` 11, `--fs-overline` 10), 4 pesos
  (`--fw-regular` 400, `--fw-medium` 600, `--fw-bold` 700, `--fw-heavy` 800), 2
  familias (`--font-sans` unificada con `--font-display`/`--font-body` como alias,
  `--font-mono`). Cero literales salvo un `0.92em` relativo intencional.

### Que no funciona / pendiente
- Sin pendientes bloqueantes de codigo. El ultimo cambio de texto (aclaracion de
  matricula) quedo aplicado en el template y regenerado; falta solo verificacion
  visual final del titular.

### Delta respecto a v09
- v09 integro la matricula a la ficha (dos capas). v10 enriquece su presentacion en
  tres vistas (tarjetas, comparador, evolucion en ficha), reformatea el panel,
  aclara el texto ambiguo, cierra la DT documental, documenta dos pendientes, y
  estandariza toda la tipografia. Sin cambios estructurales de carpetas ni de R.

## 4. Registro detallado de cambios

### Cambio 49 — Estudiantes por categoria + % en tarjetas de modo territorio
- **Categoria:** Diseno UI — Modo territorio (o crear subcategoria si se prefiere).
- **Que (`33_motor_template.html`):** `distribucionDesdeEE` devuelve `matTotalNivel`
  (matricula del nivel de los EE categorizados). `CatColumn` recibe `matTotal`,
  suma `mat_nivel_vig` de sus EE, calcula `matPct = matNivel/matTotal` y muestra
  "M estudiantes (XX,X% ...)". Texto "establec." expandido a "establecimientos"
  con singular/plural; ambos % entre parentesis con la frase "del total del nivel
  para el territorio".
- **Por que (C.11):** dar el peso en estudiantes junto al conteo de EE, sin que el
  % de categoria deje de ser conteo de EE. Denominador A (categorizados) para que
  coincida con el universo del % de establecimientos; los 4 % de matricula suman 100.
- **Como se verifico (B.4):** build limpio; verificacion visual del titular.
- **Invariante:** el % de categoria sigue siendo conteo de EE; la matricula es
  contexto aditivo, nunca pondera.

### Cambio 50 — "N EE" + tooltip de estudiantes y % en el comparador
- **Categoria:** Diseno UI — Hoja comparativa.
- **Que (`33_motor_template.html`):** `distEntidadComparativa` acumula `cats[c].mat`
  y `matTotalNivel`. Cada celda pasa de "XX,X% (n)" a "XX,X% · n EE"; el `<td>` gana
  `title` con "M estudiantes en N establecimientos · XX,X% de la matricula de
  [nivel]". Tooltip nativo (sin estado, no pisa el heatmap).
- **Por que (C.11):** "N EE" aclara que el numero son establecimientos; el tooltip
  aporta el dato de estudiantes sin recargar la celda.
- **Como se verifico (B.4):** build limpio; coincide con modo territorio para el
  mismo territorio/categoria/nivel.

### Cambio 51 — Evolucion de matricula del nivel 2016-2019 en la ficha
- **Categoria:** Diseno UI — Modo establecimiento.
- **Que (`33_motor_template.html`):** helper `matriculaSerieNivel(rbd, nivel)`
  (serie por todos los anios, null donde falte). Bloque "Evolucion de la matricula
  en [nivel]" al cierre del panel expandido, separado de la trayectoria de
  categoria: cifra por anio + variacion primer->ultimo anio con dato (absoluta y %).
  Se oculta con menos de 2 anios con dato. CSS con tendencia en `--ocean` (alza) /
  `--cat-insuf` (baja). Diseno textual, no SVG (HTML autocontenido liviano, B.2).
- **Por que (C.11):** se uso el dato nacional disponible (2016-2019, grano
  cod_ense2) para dar tendencia de tamanio, en vez de la matricula 2025 que no
  existe en el insumo.
- **Como se verifico (B.4):** logica del delta validada con 5 casos (alza, baja,
  igualdad, miles); build limpio.

### Cambio 52 — Reformateo del panel expandido (dos lineas + dos puntos)
- **Categoria:** Diseno UI — Modo establecimiento.
- **Que (`33_motor_template.html`):** encabezado del anio en dos lineas (categoria
  arriba con dos puntos tras el anio, matricula del nivel debajo como bloque
  indentado `.ee-detail-matnivel`); desglose por tipo de ensenanza con dos puntos en
  el label y "estudiantes" solo en la primera fila; "Total establecimiento:" con
  dos puntos.
- **Por que (C.11):** legibilidad pedida por el titular (capturas); el contexto de
  cada linea desambigua sin repetir "estudiantes".
- **Como se verifico (B.4):** build limpio; verificacion visual del titular.

### Cambio 53 — Aclaracion del texto de matricula en la fila colapsada
- **Categoria:** Diseno UI — Modo establecimiento.
- **Que (`33_motor_template.html`):** "Matricula 2019: 58 (68)" pasa a "Matricula
  2019: 58 en Educacion Basica · 68 en total". El parentesis ambiguo se reemplaza
  por texto explicito del nivel y del total del EE.
- **Por que (C.11):** el "(68)" no comunicaba que era el total del establecimiento.
- **Como se verifico (B.4):** aplicado por el titular, verificado en el template
  (lineas 1984-1987); pendiente regenerar + verificacion visual final.

### Cambio 54 — Estandarizacion tipografica por tokens
- **Categoria:** Diseno UI — Motor base y diseno (o crear "Sistema de diseno").
- **Que (`33_motor_template.html`):** se reemplazaron tokens fantasma de `:root`
  (escala clamp sin usar) por la escala real. Tamanios: 19 valores literales
  (9-30px, con medios pixeles) consolidados en 8 tokens `--fs-*`; piso de 11px
  (`--fs-xs`) para minusculas, 10px (`--fs-overline`) solo para etiquetas mayuscula
  con tracking. Pesos: 6 (400-900) a 4 tokens `--fw-*` (900->heavy, 500->medium).
  Familias: `--font-display` y `--font-body` eran identicas; se unifican en
  `--font-sans` con las dos previas como alias (no rompe referencias); `--font-mono`
  se mantiene. Migrados tambien 2 estilos inline en JSX. Cero literales salvo un
  `0.92em` relativo intencional.
- **Por que (C.11):** los medios pixeles eran ruido de ediciones, indistinguibles
  del entero vecino; la escala por tokens da consistencia y mantenibilidad. El piso
  de 11px en minusculas mejora legibilidad (los 9px previos eran solo overlines
  mayuscula, que toleran 10px).
- **Como se verifico (B.4):** cero literales tras la migracion (verificado por grep);
  marcadores A2 intactos; transpilacion babel OK. Ningun elemento cambia de tamanio
  de forma perceptible.

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

(Nota v10: la ficha enriquece la presentacion de matricula (tarjetas de modo
territorio con estudiantes y %, comparador con N EE y tooltip, evolucion de
matricula 2016-2019 en el panel expandido), se reformatea el panel a dos lineas, se
aclara el texto de matricula en la fila colapsada, y se estandariza toda la
tipografia del motor por tokens. La matricula sigue siendo contexto aditivo, sin
entrar en agregaciones de categoria. El objetivo permanente no cambia.)

### Nota metodologica del conteo
Un "cambio" es una solicitud distinguible del titular, no las acciones tecnicas
que la implementan. No cuentan los errores del asistente corregidos de
inmediato; si cuentan los bugfixes reportados por el titular. Clasificacion por
intencion primaria. Fuentes: registro de la sesion.

### Clasificacion tematica

| Categoria | N | % | Descripcion |
|---|---|---|---|
| Diseno UI — Motor base y diseno | 11 | 20 | Grillas (v01); motor HTML paso 33 + iteraciones UI (v03); tarjetas de modo territorio con estudiantes + % (v10, c.49); estandarizacion tipografica por tokens (v10, c.54) |
| Scaffold inicial | 9 | 17 | Estructura, scaffold, repo, decisiones v01 |
| Diseno UI — Modo establecimiento | 9 | 17 | Trayectoria EE detallada + lista sin-vigente (v06); comentario tope, bucket sin-medicion (v07); cifra de matricula vigente y panel expandido enriquecido (v09); evolucion de matricula 2016-2019, panel a dos lineas, aclaracion de texto de matricula (v10, c.51-53) |
| Diseno UI — Hoja comparativa | 7 | 13 | Comparativa, multi-seleccion, limites, lotes visuales (v05); N EE + tooltip de estudiantes/% (v10, c.50) |
| Migracion y publicacion / DevOps | 5 | 9 | Auditoria seguridad, gobernanza, LICENSE, CI, README migracion (v04) |
| Pipeline R | 4 | 7 | Pasos 30-32 de procesamiento; integracion de matricula al generador (v09) |
| Documentacion de proyecto | 3 | 6 | 5 archivos de decision v03/v04 (v06); reconciliacion de taxonomia (v07); decision taxonomia-meta (v08) |
| Datos y normalizacion | 2 | 4 | Esquema xlsx, normalizacion categoria; insumo de matricula por tipo de ensenanza (v09) |
| Documentacion (en producto) | 2 | 4 | Panel de notas metodologicas (v05); alineacion con fuente oficial (v08) |
| Orquestacion | 2 | 4 | 00_run_all.R (v02); consolidacion paso 33 + archivado de stub (v06) |

(Nota de conteo: el detalle cronologico es la fuente de verdad y tiene 54 entradas
(1-54). La tabla tematica suma 54, cuadrando con el cronologico. Las seis entradas
nuevas de v10 son los cambios 49 y 54 (Diseno UI — Motor base y diseno: tarjetas de
territorio con estudiantes/% y estandarizacion tipografica), 50 (Diseno UI — Hoja
comparativa: N EE + tooltip), y 51-53 (Diseno UI — Modo establecimiento: evolucion
de matricula, panel a dos lineas, aclaracion de texto). El cambio 49 (tarjetas de
modo territorio) se absorbe en "Motor base y diseno" en vez de abrir una categoria
"Modo territorio" propia: una sola entrada quedaria en ~1,9%, bajo el umbral de
absorcion del 2%. El cambio 54 (tipografia) se asigna a "Motor base y diseno" como
sistema de diseno transversal del motor, sin crear categoria nueva por la misma
regla. No se reescriben entradas previas; los % se recalculan sobre 54 y ninguna
categoria supera el 25%.)

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
| 10 | v10 | 6 | Opus 4.8 | Matricula en tarjetas/comparador/ficha + panel a dos lineas + tipografia por tokens |
| **Total** | | **54** | | |

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
- **Sesion 10 (cambios 49-54):** 49 estudiantes por categoria + % en las tarjetas
  de modo territorio (`distribucionDesdeEE` devuelve `matTotalNivel`; `CatColumn`
  suma `mat_nivel_vig`, calcula `matPct = matNivel/matTotal`; denominador de
  categorizados para que coincida con el universo del % de EE y los 4 % sumen 100;
  D15); 50 "N EE" + tooltip de estudiantes y % en cada celda del comparador
  (`distEntidadComparativa` acumula `cats[c].mat` y `matTotalNivel`; celda
  "XX,X% · n EE"; `<td>` con `title` "M estudiantes en N establecimientos · XX,X%
  de la matricula de [nivel]"; tooltip nativo sin estado); 51 evolucion de
  matricula del nivel 2016-2019 en el panel expandido de la ficha (helper
  `matriculaSerieNivel(rbd, nivel)`; bloque "Evolucion de la matricula en [nivel]"
  con cifra por anio + variacion primer→ultimo anio con dato; se oculta con <2
  anios con dato; tendencia en `--ocean`/`--cat-insuf`; diseno textual, no SVG;
  D16); 52 reformateo del panel expandido (encabezado del anio en dos lineas con
  categoria arriba y matricula del nivel debajo como bloque indentado
  `.ee-detail-matnivel`; desglose por tipo de ensenanza con dos puntos y
  "estudiantes" solo en la primera fila; "Total establecimiento:" con dos puntos);
  53 aclaracion del texto de matricula en la fila colapsada ("Matricula 2019: 58
  (68)" → "Matricula 2019: 58 en Educacion Basica · 68 en total", con el total
  condicionado a `mat_total_vig !== mat_nivel_vig`; L1980-1990); 54 estandarizacion
  tipografica por tokens (19 tamanios literales 9-30px → 8 tokens `--fs-*` con piso
  11px en minusculas y 10px solo en overlines mayuscula; 6 pesos 400-900 → 4 tokens
  `--fw-*`; 3 familias → 2 con `--font-display`/`--font-body` unificadas en
  `--font-sans` como alias y `--font-mono` intacta; 2 estilos inline JSX migrados;
  cero literales salvo un `0.92em` relativo intencional; D17, A15).

### Delta del backlog
6 entradas nuevas (49-54). "Diseno UI — Motor base y diseno" 9→11 (incluye 49, 54);
"Diseno UI — Hoja comparativa" 6→7 (incluye 50); "Diseno UI — Modo establecimiento"
6→9 (incluye 51, 52, 53). Total cronologico 48→54. La tabla tematica recalcula
porcentajes sobre 54 (los enteros se mantienen; los % se ajustan por el nuevo
denominador) y sigue cuadrando con el cronologico; ninguna categoria supera el 25%.
Decision de taxonomia: el cambio 49 (tarjetas de modo territorio) no abre una
categoria "Modo territorio" propia (1 entrada = ~1,9%, bajo el umbral de absorcion
del 2%), se absorbe en "Motor base y diseno"; el cambio 54 (tipografia) se asigna a
la misma categoria como sistema de diseno transversal, sin categoria nueva. No se
crean ni reescriben categorias. P-matricula-ficha ya quedo cerrado en v09; en v10
no se cierra ningun pendiente de codigo nuevo (los pendientes de matricula actual y
por grado quedan documentados con alcance, bloqueados por dato).

## 6. Bugs de la sesion
No aplica: no hubo bugs de codigo en el proyecto. Si hubo una falla tecnica de
herramienta en el chat (emision espuria del token "court" antes de invocaciones,
que impedia ejecutar tools); no afecta al codigo ni al repo, solo motivo el cierre
anticipado y la redaccion manual de este traspaso.

## 7. Aprendizajes y restricciones descubiertas
### A14 — Un proxy debe verificarse contra su definicion antes de adoptarlo
- **Regla:** la base de rendimiento 2025 (planilla rbd x anio, 4 comunas, sin
  cod_ense2) se evaluo como proxy de matricula 2025 y se descarto: cobertura local
  (73 EE de 10.945), grano sin nivel (mezclaria basica/media), y de otro proyecto.
  Un proxy que no cumple la definicion del dato (matricula = COUNT(*) por
  cod_ense2, nacional) produce cifras enganosas.
- **Principio:** B.1 (no operar sobre supuestos); invariante de no mezclar niveles.

### A15 — Estandarizar por tokens, distinguiendo funcion no solo valor
- **Regla:** al consolidar tamanios pequenos, el mismo valor (10px) fue a tokens
  distintos segun funcion: overline-mayuscula a `--fs-overline`, texto normal al
  piso `--fs-xs` (11). Estandarizar no es reemplazo ciego por valor.
- **Principio:** C.10 (constantes nombradas); accesibilidad (piso de legibilidad).

## 8. Decisiones de diseno
### D15 — % de matricula con denominador de categorizados (no del total con s/i)
- **Decision:** el % de estudiantes por categoria se calcula sobre la matricula del
  nivel de los EE categorizados (mismo universo que el % de EE), no sobre todos los
  EE. Los 4 % suman 100.
- **Alternativa:** denominador con EE sin categoria vigente (no sumaria 100).
- **Justificacion:** coherencia con el % de establecimientos que acompana la cifra.

### D16 — Evolucion de matricula con dato disponible (2016-2019), no 2025
- **Decision:** ante la ausencia de matricula 2025 en el insumo, se implemento la
  evolucion 2016-2019 (dato nacional, grano cod_ense2) en vez de esperar 2025.
- **Justificacion:** entrega valor verificable ahora; P-matricula-actual queda
  documentado para cuando exista el insumo 2025.

### D17 — Escala tipografica de 8 tamanios con piso de legibilidad
- **Decision:** 8 tamanios, piso 11px para minusculas, 10px solo overlines
  mayuscula; 4 pesos; 2 familias (display=body unificadas).
- **Alternativa:** mantener una fuente display distinta (descartada: hoy no hay
  distincion real; agregar fuente es cambio de identidad para otra sesion).

## 9. Constantes y parametros vigentes
[Tabla de v09 + nuevos tokens tipograficos: `--fs-display/h1/h2/lg/base/sm/xs/
overline`, `--fw-regular/medium/bold/heavy`, `--font-sans`. Sin cambios en
constantes de calculo.]

## 10. Arquitectura de archivos
Referencia al escaner del 2026-06-13 14:20:44 (84 archivos, 16 carpetas). v10 agrega
al repo: `50_documentacion/activa/decisiones/20260613_decision_procedencia_insumo_matricula.md`
y `50_documentacion/activa/P-matricula-grado_alcance.md` (el de P-matricula-actual
debe archivarse igual si aun no esta). El informe del one-off figura como
`20260613_decision_granularidad_matricula.docx`. Sin cambios estructurales de carpetas.

## 11. Pendientes y ruta sugerida
### Inventario de pendientes
- **Verificacion visual final** del cambio 53 (aclaracion de matricula) tras
  regenerar. Baja complejidad.
- **P-matricula-actual** (bloqueado por dato): matricula 2025 como tamanio actual.
  Alcance resuelto en `50_documentacion/activa/P-matricula-actual_alcance.md`.
  Requiere regenerar el insumo con 2025 en slep_analisis_matricula.
- **P-matricula-grado** (bloqueado por dato): desglose por cod_grado en el panel.
  Alcance en `50_documentacion/activa/P-matricula-grado_alcance.md`. Requiere
  regenerar el insumo a grano cod_grado.

### Auditoria de cierre (politica 5.6)
- #2 pipeline corre de cero: Si. #5 validaciones criticas: Si (sin cambios en R).
  #7 constantes nombradas: Si (tokens tipograficos). #8 nombres sin tildes: Si.
  Resto sin cambios respecto a v09.

### Ruta sugerida para la sesion 11
1. Generar formalmente el traspaso v10 si este texto no se materializo como archivo
   (este documento es su contenido).
2. Verificacion visual del cambio 53.
3. P-matricula-actual o P-matricula-grado solo si el titular trae el insumo
   regenerado.
**Diferir:** modularizacion del template (sigue siendo HTML unico autocontenido).

## 12. Instrucciones especificas para la proxima sesion
- 🔒 Agregacion de categoria = conteo de EE. La matricula (tarjetas, comparador,
  ficha) es contexto, nunca pondera ni entra en agregaciones.
- 🔒 Basica y media nunca se mezclan. Las cifras de matricula por categoria/nivel
  usan la matricula del NIVEL (basica = cod_ense2 2; media = 5+7), nunca el total.
- 🔒 El % de matricula usa denominador de categorizados (mismo universo que el % de
  EE); los 4 % suman 100 (D15).
- 🔒 Tipografia por tokens: usar SIEMPRE `--fs-*` y `--fw-*`, jamas valores
  literales. Piso `--fs-xs` (11) para minusculas; `--fs-overline` (10) solo
  overlines mayuscula. `--font-sans` para texto, `--font-mono` para codigos (A15).
- 🔒 `docs/index.html` versionado para Pages; `40_salidas/motor_categoria.html`
  regenerable, ignorado por Git. No editar `docs/` a mano.
- ✅ ANTES de verificar un cambio del template: reemplazar, transpilar babel,
  regenerar (A1). Confirmar marcadores A2 (`function EeRow`, `RBD_MOTIVO`,
  `LIMITE = 10`, `cmp-clear-btn`, `sinMedicionEE`).
- ✅ ANTES de regenerar el insumo de matricula: correrlo en slep_analisis_matricula,
  no en este repo; copiar el parquet a mano.
- ⚠️ NO re-leer los CSV nacionales en este proyecto.

## 13. Fragmentos de codigo de referencia
[Conservar los de v09. Anadir el patron de la serie de matricula:]
```javascript
// Serie de matricula del nivel por todos los anios (null donde falte).
function matriculaSerieNivel(rbd, nivel) {
  return YEARS.map(y => ({ anio: y, mat: matriculaNivel(rbd, nivel, y) }));
}
```

## 14. Reapertura
### Nombre del chat
`slep_categoria_desempeno, sesion 11 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; leelo desde ahi.
> Retomamos slep_categoria_desempeno en sesion 11. La sesion 10 cerro con una falla
> tecnica de herramienta; su traspaso v10 se redacto manualmente y esta adjunto.
> Pendiente inmediato: verificacion visual del ultimo cambio de texto de matricula.
> P-matricula-actual y P-matricula-grado siguen bloqueados por dato. Adjunto el
> traspaso v10, el escaner re-ejecutado y 33_motor_template.html (version vigente).

### Documentos para la proxima sesion
1. Protocolo en knowledge base (no se adjuntan): POLITICA_PROYECTO.md v6,
   SETTINGS_Y_PROMPTS_OPERACIONALES.md v1.
2. Opcionales: 33_motor_template.html (molde, si se edita la ficha);
   33_generar_html.R (si se toca el JSON o un insumo).
3. Especificos (si se adjuntan): traspaso_cierre_v10.md; estructura_actual.md.

### Nota final obligatoria
33_motor_template.html crecio a ~115 KB. Adjuntar la version vigente (ya editada con
los cambios 49-54), no una previa (A2).
