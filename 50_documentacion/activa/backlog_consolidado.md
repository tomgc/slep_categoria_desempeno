# Backlog acumulativo consolidado — slep_categoria_desempeno

> **Propósito.** Consolidación in extenso del detalle cronológico completo,
> cerrando la deuda documental DT-backlog-documental que se arrastraba por
> referencia ("copiar íntegro 1-54/1-58/1-62") desde el v11. Cada entrada queda
> reproducida como entrada autónoma, no referenciada. A partir del v14 este es el
> documento vivo del backlog: crece por delta cada sesión (los traspasos solo
> agregan las entradas nuevas y este archivo las absorbe). El nombre no lleva rango
> fijo para no renombrarlo en cada consolidación. Granularidad:
> los cambios 1-11 (sesión 1) nunca tuvieron numeración individual en su traspaso
> de origen (el v01 los redactó como lista 1-11 en su sección 4); aquí se preservan
> con esa misma granularidad. Los cambios 12-66 provienen del registro detallado
> (sección 4) de su traspaso de origen, comprimidos a entrada autocontenida sin
> perder lo esencial.
>
> Este documento materializa la sección 5 del traspaso conforme a la política
> 2.2.5. No reescribe ni renumera ninguna entrada previa: la numeración correlativa
> global es permanente.

## Objetivo del proyecto

slep_categoria_desempeno es un motor interactivo (R + HTML autocontenido) que
compara la distribución de establecimientos por Categoría de Desempeño (Alto /
Medio / Medio-Bajo / Insuficiente) de la Agencia de Calidad, entre comunas, SLEPs,
regiones y el nivel nacional, separando básica y media. Pipeline en R (xlsx →
parquet → JSON embebido → HTML), publicado en GitHub Pages. Para el equipo de
Monitoreo del SLEP Costa Central, desde 2026. Datos públicos.

(Nota v03: la opción "nacional" del selector se eliminó en la sesión 3 por volumen
de EE; se agregó selección de establecimiento individual. El objetivo permanente no
cambia.)

(Nota v04: el proyecto quedó publicado en GitHub Pages en
`https://tomgc.github.io/slep_categoria_desempeno/`. El objetivo permanente no
cambia.)

(Nota v05: se agregó una segunda hoja de comparación entre territorios. El objetivo
permanente no cambia.)

(Nota v06: el modo EE se rediseñó con trayectoria detallada al click y lista de
establecimientos sin categoría vigente; se consolidó la orquestación en un único
punto de entrada. El objetivo permanente no cambia.)

(Nota v07: el modo territorio muestra ahora los establecimientos sin medición 2019
como bucket visible aparte; la hoja comparativa gana un botón de limpieza. El
objetivo permanente no cambia.)

(Nota v08: el panel de notas metodológicas se alineó con la caracterización oficial
de la Agencia (definiciones por grado, ponderación 67/33). El objetivo permanente no
cambia.)

(Nota v09: la ficha del establecimiento incorpora matrícula por tipo de enseñanza
(cifra del nivel vigente en la fila + desglose completo por año en el panel
expandido), a partir de un insumo agregado nuevo. La matrícula es dato de contexto
del EE, no entra en ninguna agregación de categoría. El objetivo permanente no
cambia.)

(Nota v10: la ficha enriquece la presentación de matrícula (tarjetas de modo
territorio con estudiantes y %, comparador con N EE y tooltip, evolución de
matrícula 2016-2019 en el panel expandido), se reformatea el panel a dos líneas, se
aclara el texto de matrícula en la fila colapsada, y se estandariza toda la
tipografía del motor por tokens. La matrícula sigue siendo contexto aditivo, sin
entrar en agregaciones de categoría. El objetivo permanente no cambia.)

(Nota v11: la cobertura del insumo de matrícula se amplió de 2016-2019 a 2016-2025;
sesión de infraestructura de datos y Git, sin cambios de UI. El objetivo permanente
no cambia.)

(Nota v12: se expone matrícula 2025 como tamaño vigente (convivencia con categoría
2019); se agrega el grano de grado como nuevo insumo y desglose en ficha. El
objetivo permanente no cambia.)

(Nota v13: se cierra el rediseño de cabecera territorial y layout (D21) adoptando
una referencia UI aprobada por ingeniería inversa; se silencia el warning de
readLines, se agrega el atajo `regenerar_motor()` y el check 6.5 de partición
territorial. El objetivo permanente no cambia.)

(Nota v14: sesión de cierre documental y certificación, sin tocar el pipeline ni el
motor: se consolidó el backlog in extenso y se agregó una capa de auditoría
independiente de las cifras publicadas (protocolo 4.5, en `tests/`). El objetivo
permanente no cambia.)

## Nota metodológica del conteo

Un "cambio" es una solicitud distinguible del titular, no las acciones técnicas que
la implementan. No cuentan los errores del asistente corregidos de inmediato; sí
cuentan los bugfixes reportados por el titular. Clasificación por intención
primaria. Fuentes: registro de cada sesión.

## Clasificación temática

| Categoría | N | % | Descripción |
|---|---|---|---|
| Diseño UI — Motor base y diseño | 13 | 16 | Diseño de visualización (v01, c.11); motor HTML paso 33 base + iteraciones UI 1-4 (v03, c.17-21); publicación Pages en el generador (v04, c.26); tarjetas de modo territorio con estudiantes + % (v10, c.49); estandarización tipográfica por tokens (v10, c.54); convivencia año de matrícula (v12, c.59); desglose por grado en motor (v12, c.61); bloque narrativo territorial parcial (v12, c.62); D21 template regenerado desde referencia UI (v13, c.63) |
| Scaffold e inicialización | 12 | 15 | Estructura, scaffold, utils, escáner, gitignore, rproj/readme, protocolo, decisiones, git (v01, c.1-9 salvo orquestación); auditoría seguridad, gobernanza, LICENSE, CI, README migración (v04, c.22-25,27) |
| Diseño UI — Hoja comparativa | 9 | 10 | Comparativa, multi-selección, límites, lotes visuales (v05, c.28,30-35); botón limpiar (v07, c.41); N EE + tooltip de estudiantes/% (v10, c.50) |
| Documentación de proyecto | 11 | 13 | Decisiones (v01, c.8); 5 archivos de decisión (v06, c.37); reconciliación de taxonomía (v07, c.42); decisión taxonomía-meta (v08, c.44); materialización del backlog v10 (v11, c.56); backlog consolidado in extenso 1-66 (v14, c.67); consolidación 67-69 + renombre del backlog sin rango (v15, c.70); nota de verificación de cifras en README, D23 (v15, c.72); suite de documentación con suitedoc, 4 HTML + documentar.R (v15, c.73); consolidación del backlog 81-82 sobre 82 (v18, c.84); actualización de la suite (stack runtime + terminología institucional) (v19, c.86) |
| Diseño UI — Modo establecimiento | 12 | 15 | Trayectoria EE detallada + lista sin-vigente (v06, c.38); bucket sin-medición (v07, c.39-40); cifra de matrícula vigente y panel expandido enriquecido (v09, c.47-48); evolución de matrícula, panel a dos líneas, aclaración de texto (v10, c.51-53); eliminación del detalle por grado en la ficha (v16, c.74); rediseño D2 de la trayectoria a filas a todo el ancho (v16, c.75); encabezado de columnas por año (v16, c.77); eliminación del sufijo redundante "estudiantes" (v16, c.78) |
| Datos y normalización | 6 | 8 | Inspección de datos (v01, c.10); esquema xlsx, normalización categoría (v02, c.12-13); insumo de matrícula por tipo de enseñanza (v09, c.45); ampliación cobertura 2016-2025 (v11, c.57); parquet de grado (v12, c.60) |
| Pipeline R | 6 | 7 | Agregación territorial (v02, c.14); generador del producto (v03, c.16); integración de matrícula al generador (v09, c.46); regeneración con insumo 2016-2025 (v11, c.58); desacople de matrícula por grado del JSON embebido (v17, c.81); internalización de React/ReactDOM inline, alcance A (v18, c.83) |
| Orquestación | 4 | 5 | Stub 00_build.R (v01, c.2); 00_run_all.R (v02, c.15); consolidación paso 33 + archivado de stub (v06, c.36); alias regenerar_motor (v13, c.65) |
| Validación / integridad | 4 | 5 | Check 6.5 de partición territorial (v13, c.66); auditoría de cifras publicadas por doble cálculo, protocolo 4.5 (v14, c.68); spot-check parametrizado a múltiples celdas ancla, DT-spot-check-cobertura (v15, c.71); certificación de ausencia simétrica en el spot-check, DT-spot-check-ausencia (v16, c.80) |
| Documentación (en producto) | 2 | 3 | Panel de notas metodológicas (v05, c.29); alineación con fuente oficial (v08, c.43) |
| Migración y publicación / DevOps | 5 | 6 | Recuperación de la sesión 10 en Git (v11, c.55); higiene de Git, ignore de reporte regenerable + snapshot del escáner (v14, c.69); commit de snapshots del escáner con poda de retención 2 (v16, c.76); commit de snapshots del escáner con poda de retención 2 (v17, c.82); commit de snapshots del escáner con poda de retención 2 (v18, c.85) |
| Calidad de código / pipeline | 2 | 3 | Warning de readLines silenciado de raíz (v13, c.64); retiro de código muerto de matrícula por grado en el motor (v16, c.79) |

(Nota de conteo: el detalle cronológico es la fuente de verdad y tiene 86 entradas
(1-86). La tabla temática suma 86, cuadrando con el cronológico, con asignación por
intención primaria verificada entrada por entrada. La categoría líder, "Diseño UI —
Motor base y diseño", queda en 15% (13/86), bajo el umbral de subdivisión del 25%.
El v19 suma una entrada: "Documentación de proyecto" (10→11, actualización de la suite
de documentación c.86). Sin categorías nuevas.
El v18 suma tres entradas: una a "Pipeline R" (5→6, internalización de React/ReactDOM
inline c.83), una a "Documentación de proyecto" (9→10, consolidación del backlog 81-82
c.84) y una a "Migración y publicación / DevOps" (4→5, snapshots del escáner c.85). La
entrada 83 se imputa a "Pipeline R" por intención primaria (cambio del paso 33 en lo que
inyecta al producto), consistente con c.81. Sin categorías nuevas.
El v17 suma dos entradas: una a "Pipeline R" (4→5, desacople de matrícula por grado del
JSON embebido c.81) y una a "Migración y publicación / DevOps" (3→4, snapshots del
escáner c.82). La entrada 81 se imputa a "Pipeline R" por intención primaria (cambio del
generador del producto y su serialización JSON), distinta de c.79 ("Calidad de código /
pipeline", retiro de código muerto en el motor cliente). Sin categorías nuevas.
El v16 suma siete entradas: cuatro a "Diseño UI — Modo establecimiento" (8→12, es la
ficha del EE: eliminación del grado c.74, rediseño D2 c.75, encabezado de columnas
c.77, eliminación del sufijo redundante c.78), una a "Migración y publicación / DevOps"
(2→3, snapshots del escáner c.76), una a "Calidad de código / pipeline" (1→2, retiro de
código muerto del grado c.79) y una a "Validación / integridad" (3→4, ausencia simétrica
en el spot-check c.80). Sin categorías nuevas: las entradas de UI de la ficha se imputan
a "Modo establecimiento" (no a una categoría "Interfaz" nueva) y el retiro de código
muerto a "Calidad de código / pipeline", reusando la taxonomía existente para no
introducir categorías bajo el umbral de absorción del 2%. Se mantienen los criterios de
v14: "Scaffold inicial" (v10) y la inicialización de v04 unificadas bajo "Scaffold e
inicialización" (12); las entradas de naturaleza de orquestación del scaffold (c.2, stub)
imputadas a "Orquestación" por intención primaria. No se reescribe ni renumera ninguna
entrada del detalle cronológico.)

## Resumen estadístico por sesión

| Sesión | Traspasos | N cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 11 | (v01) | Scaffold y diseño |
| 2 | v02 | 4 | Opus 4.8 | Pipeline R 30-32 + orquestador |
| 3 | v03 | 6 | Opus 4.8 | Motor HTML (paso 33) + iteraciones UI |
| 4 | v04 | 6 | Opus 4.8 | Migración a GitHub + Pages |
| 5 | v05 | 8 | Opus 4.8 | Hoja comparativa + notas + pulido visual |
| 6 | v06 | 3 | Opus 4.8 | Orquestación + decisiones + trayectoria EE |
| 7 | v07 | 4 | Opus 4.8 | Comentario tope + bucket sin-medición + botón limpiar + taxonomía |
| 8 | v08 | 2 | Opus 4.8 | Alineación panel con fuente oficial + decisión taxonomía-meta |
| 9 | v09 | 4 | Opus 4.8 | Matrícula por tipo de enseñanza en la ficha |
| 10 | v10 | 6 | Opus 4.8 | Matrícula en tarjetas/comparador/ficha + panel a dos líneas + tipografía por tokens |
| 11 | v11 | 4 | Opus 4.8 | Recuperación Git + materialización backlog + cobertura 2016-2025 |
| 12 | v12 | 4 | Opus 4.8 | Convivencia matrícula 2025 + grano de grado + narrativa territorial (parcial) |
| 13 | v13 | 4 | Opus 4.8 | D21 resuelto (referencia UI) + warning + alias + check 6.5 |
| 14 | v14 | 3 | Opus 4.8 | Backlog consolidado in extenso + auditoría de cifras (4.5) + higiene Git |
| 15 | v15 | 4 | Opus 4.8 | Cierre P1-P3 (backlog 67-73 + spot-check multi-celda + nota README) + suite de documentación (suitedoc) |
| 16 | v16 | 7 | Opus 4.8 | Rediseño D2 de la ficha de establecimiento (sin grado, encabezado de columnas, sin redundancia) + retiro de código muerto + ausencia simétrica en spot-check |
| 17 | v17 | 2 | Opus 4.8 | Desacople de matrícula por grado del JSON embebido (2.80→1.72 MB) + snapshots del escáner |
| 18 | v18 | 3 | Opus 4.8 | Internalización de React/ReactDOM inline (alcance A; Babel queda en CDN, 1.72→1.82 MB) + consolidación backlog 81-82 + snapshots del escáner |
| 19 | v19 | 1 | Opus 4.8 | Actualización de la suite de documentación (stack runtime real + terminología institucional) para revisión externa |
| **Total** | | **86** | | |

## Detalle cronológico

### Sesión 1 (cambios 1-11) — Scaffold y diseño

1. **Scaffold de estructura canónica** (política §1.1, §8.2 Rama A). Carpetas por
   decenas con `.gitkeep` en vacías. Verificado: árbol calza con la política.
2. **`00_build.R` stub** adaptado: orquestador con pasos comentados (se descomentan
   al construirse), producto final nombrado `motor_categoria.html`.
3. **`10_utils/10_utils.R` propio**: NO se copió el del proyecto madre (era
   específico de `agregar_ponderado()`/GSE, inaplicable aquí). Solo bootstrapping
   (`instalar_si_falta`, `log_msg`). La lógica de conteo categórico no es ponderada;
   migrar la del madre habría arrastrado código muerto.
4. **`00_escanear_proyecto.R`**: copiado del madre, adaptada solo la identidad
   (header, referencia a la sección 7 de la política, fecha). Motor de poda
   (retención 2), árbol y escritura atómica idénticos.
5. **`.gitignore` Rama A**: estándar sin bloque de datos (datos públicos
   versionados); ignora `motor_categoria.html` y parquets intermedios (regenerables).
6. **`.Rproj`, `README.md`, `CLAUDE.md`** creados. `CLAUDE.md` documenta las tres
   rupturas con el madre y el modelo de visualización.
7. **Protocolo copiado** a `50_documentacion/activa/` (POLÍTICA + SETTINGS).
8. **Dos decisiones** en `decisiones/`: `20260611_decision_sin_gse.md`,
   `20260611_decision_nombres_establecimientos.md`.
9. **Git local + remoto**: dos commits (`scaffold inicial` → `primer escaneo`),
   remoto configurado, push a `main` verificado por el usuario.
10. **Inspección de datos**: 7 xlsx + directorio. Resolución del esquema y de la
    llave del dato.
11. **Diseño de visualización cerrado**: dos grillas apiladas (Opción B), validado
    con boceto.

### Sesión 2 (cambios 12-15) — Pipeline R 30-32 + orquestador

12. **`30_construir_auxiliares.R` (nuevo)** — pipeline/auxiliares. Adaptación del
    molde madre: construye `comunas_chile`, `sleps_chile` y
    `establecimientos_chile` desde el directorio oficial y el listado SLEP.
    Verificado: Costa Central reporta sus 4 comunas exactas; RBD llave única en
    establecimientos; 10 SLEP prospectivos 2026 incluidos. Se eliminaron los bloques
    SIMCE/IVE del madre (no aplican); se agregó `cod_reg_rbd` (P3 agrega por región)
    y `COD_DEPE` a la validación de columnas.
13. **`31_leer_normalizar.R` (nuevo)** — pipeline/dato nuclear. Lee los 7 xlsx por
    header (`clean_names` resuelve esquemas A/B), normaliza categoría a 5 valores,
    cruza con directorio, emite `categoria_rbd.parquet` (llave rbd x nivel x año).
    Verificado: 5 categorías limpias; llave única; 0 NAs críticos;
    `motivo_sin_categoria` coherente; 41.244 filas = suma de los 7 archivos. No se
    arrastraron las anomalías del madre (territorio sale del directorio por RBD, no
    de las columnas del cdb).
14. **`32_agregar_territorial.R` (nuevo)** — pipeline/agregación. Conteo de EE por
    entidad (comuna/slep/region/nacional) x nivel x año x categoría, formato largo;
    emite `categoria_territorial.parquet` y `categoria_sin_vigente.parquet`. 4
    validaciones en verde (4 categorías por celda; pct suma 1; n_ee <= categorizados;
    nacional cuadra dif = 0). Función `contar_territorial()` genérica reutilizada en
    los 4 niveles.
15. **`00_run_all.R` (nuevo) + archivo de `00_build.R`** — orquestación. Orquestador
    canónico (protocolo 4.1): `PASOS` con id/etiqueta/ruta, `run_all(from/to/only/
    skip)`, validación de rutas, raíz vía `rprojroot`, duración por paso, resumen. El
    stub `00_build.R` se archivó. Verificado: `run_all()` corre 1-3 de cero en 0,8 s.

### Sesión 3 (cambios 16-21) — Motor HTML (paso 33) + iteraciones UI

16. **`33_generar_html.R` (nuevo)** — generador del producto final. Lee los 6
    parquets, construye `meta` (años, `anio_vigente`=2019, categorías en orden
    semántico, colores, labels, motivos, depe_labels), catálogos y tres bloques
    columnares (territorial 10.780, sin_vigente 1.985, rbd 41.244). Serializa con
    jsonlite (auto_unbox, columnar), comprime gzip+base64, reemplaza los 3
    placeholders, escribe `motor_categoria.html` en UTF-8. Clave: strings no-ASCII
    con `\uXXXX` (bug locale C); `sub(..., fixed=TRUE)` en los 3 placeholders.
17. **`33_motor_template.html` (nuevo, base)** — template React/D3 reescrito sobre el
    shell del madre. Capa `CatData` (conteo sin ponderación ni GSE): índices
    territorial, sin_vigente y por-EE; `getDistribucion`, `getSinVigente`,
    `getEstablecimientos`. Vista de 4 columnas en orden Insuficiente → Alto, filas de
    EE con trayectoria, sección sin categoría vigente. Se portó contenedor, no
    contenido (el componente visual del madre es SIMCE de líneas/GSE). Verificado:
    JSX compila con Babel; lógica de `CatData` probada en Node contra parquets reales
    (Costa Central básica 2019 = 56; nacional media = 2837).
18. **Iteración UI tanda 1** — paleta inicial corregida; chips de trayectoria con año
    completo; comuna agregada a la ficha; más espacio entre EE.
19. **Iteración UI tanda 2 (paleta azul institucional)** — Alto = `#0062A0` (azul
    institucional); Medio = `#2A8FD9` (azul claro). Resuelve el choque rojo/coral.
20. **Iteración UI tanda 3 (trayectoria rediseñada + filtro comuna + fix pct)** —
    trayectoria rediseñada (año como rótulo arriba, marca cuadrada abajo); orden
    reciente → antiguo; año vigente con anillo; filtro de comuna multi-select. El
    header de columna pasa a usar el pct autoritativo del territorial (resuelve el
    "0,0%").
21. **Iteración UI tanda 4 (selector EE + filtro dependencia + leyenda)** — eliminada
    la categoría "nacional" del selector; agregada "establecimiento" (búsqueda por
    nombre/RBD). Eliminados los atajos "Todas/Ninguna". Filtro de dependencia.
    Leyenda de trayectoria agrandada. Header de distribución calculado desde los EE
    visibles (refleja filtros); `distribucionDesdeEE` nuevo en `CatData`.

### Sesión 4 (cambios 22-27) — Migración a GitHub + Pages

22. **Auditoría de seguridad pre-migración** — script
    `diagnostico_migracion_github.R` adaptado a Rama A (reporta info sensible, no
    expulsa datos públicos): RUT, tokens, rutas absolutas con usuario, OneDrive,
    correos, naming fuera de norma. Corrió sobre 63 archivos; 24 hallazgos MEDIA, 0
    críticos/altos, revisados con el titular y clasificados como benignos. El reporte
    se archivó como evidencia en `decisiones/20260612_auditoria_migracion_github.md`.
23. **`gobernanza_datos.md` (Rama A ligera)** — nota que documenta qué datos maneja
    el proyecto, por qué son públicos, la base heredada (la prohibición de
    identificar EE aplica a bases por estudiante, no a agregados públicos por RBD), el
    marco normativo de referencia y el procedimiento de reclasificación a Rama B.
    Versión ligera por prudencia (repo público que nombra establecimientos).
24. **`LICENSE` (MIT con cláusula de datos)** — licencia MIT a nombre de Tomás
    Ignacio González Cifuentes — SLEP Costa Central, con nota explícita de que cubre
    el código y NO los datos. Se eligió MIT sobre Apache para alinear con el LICENSE
    ya decidido y mantener una sola licencia en los proyectos gemelos. El header del
    generador se alineó a MIT (antes declaraba Apache 2.0 por remanente de plantilla).
25. **Workflow de CI de seguridad** — `.github/workflows/validacion_seguridad.yml`.
    Tres jobs en push y PR a main: detectar tokens (ghp_/github_pat_/AKIA), detectar
    RUT, verificar que no haya .parquet/.rds/.feather fuera de `20_insumos/` o
    `40_salidas/`. Matiz del protocolo 4.3 para GitHub Free (sin branch protection en
    repos públicos sin plan): el workflow sustituye con validación automática.
26. **Publicación en Pages (modelo B, `docs/` + copia automática)** —
    `33_generar_html.R` copia el HTML a `docs/index.html`; Pages sirve desde `main` /
    `/docs`. El producto canónico sigue en `40_salidas/` (fuente de verdad); `docs/`
    es copia derivada. Modelo B sobre A por simplicidad (archivo único standalone,
    sin build). Sitio respondió HTTP 200 tras el push.
27. **README de migración** — README reescrito conforme a la política sección 10 (qué
    hace, cómo correr el pipeline, estructura, datos, publicación Pages, licencia).

### Sesión 5 (cambios 28-35) — Hoja comparativa + notas + pulido visual

28. **Hoja comparativa "Comparar territorios"** — segunda hoja conmutable por pestaña
    (`Segmented` "Vista"). Tabla con filas = 4 categorías (orden semántico) y
    columnas = entidades elegidas (tipo mixto comuna/SLEP/región); cada celda n y %;
    filas "Total categorizados" y "Sin categoría vigente" al pie. Componentes
    `ComparativaSheet`, `CmpDepFilter`, `distEntidadComparativa`. El % se calcula desde
    los EE visibles (respeta el 🔒 de no recalcular el territorial en cliente sin
    filtro; excepción legítima cuando sí lo hay).
29. **Panel de notas metodológicas** — componente `NotasMetodologicas` colapsable al
    pie de ambas hojas, con 6 notas (categoría y sus 4 niveles; SLEP y dependencia;
    conteo sin ponderación; sin GSE por diseño; categoría vigente y denominador;
    cobertura temporal) más línea de fuente. Reusa estilos `.notes-*` del scaffold.
    Salvedad: las definiciones de las 4 categorías se redactaron con criterio general,
    no copiadas de la glosa oficial (pendiente P-glosa-oficial, resuelto en c.43).
30. **Multi-selección con checkboxes en el selector de la comparativa** —
    `EntityModal` gana prop `multiple` (con `yaElegidas` y `limite`): en modo múltiple
    muestra checkboxes, acumula selección entre pestañas, respeta el tope, marca en
    gris las ya presentes, confirma con "Agregar (N)". CSS nuevo `.check-box`,
    `.check-row.is-checked`, etc.
31. **Límite de territorios a 7** — `LIMITE` y default del modal de 4 a 7; los tres
    textos de límite parametrizados para leer la constante (sin números mágicos).
32. **Límite de territorios a 10** — `LIMITE` y default de 7 a 10 (segunda solicitud);
    `overflow-x: auto` evita ruptura de layout con 10 columnas.
33. **Lote visual 1 de la tabla comparativa (seis ajustes)** — (a) separación de
    columnas; (b) hover cruz que resalta fila y columna; (c) heatmap en fila
    Insuficiente; (d) territorios centrados, columna Categoría a la derecha; (e)
    eliminación GLOBAL de ALLCAPS (6 `text-transform: uppercase` removidos de todo el
    sitio); (f) agrandado de textos pequeños y separación de los años de trayectoria.
34. **Formato "% (n)", menos negrita, tabla como tarjeta** — en las 4 filas de
    categoría, orden invertido a porcentaje primero (negro, peso medio) y n entre
    paréntesis (gris oscuro, sin negrita). Reducción de negrita general. La tabla pasa
    a tarjeta con fondo papel propio, borde y sombra, separada del crema del sitio.
35. **Heatmap por categoría, renombre de encabezado, hover gris** — (a) heatmap
    extendido a las 4 filas, cada una con el color de su categoría (`hexToRgba` sobre
    `CAT_COLORS`, intensidad normalizada al máximo de la fila); (b) encabezado
    "Categoría" → "Categoría de desempeño"; (c) hover cruz de azul a gris translúcido
    vía `box-shadow inset`. Cambio de significado declarado: la intensidad ya no
    expresa gravedad sino concentración de cada categoría en el territorio.

### Sesión 6 (cambios 36-38) — Orquestación + decisiones + trayectoria EE

36. **Orquestación del paso 33** — IDs de `PASOS` en `00_run_all.R` de `1-4` a
    `30/31/32/33` (coinciden con el prefijo del script); comentarios stale limpiados;
    `00_build.R` archivado. El síntoma `run_all(only = 33)` provenía del desacople
    id/prefijo, no de un paso ausente. Verificado: `run_all()` ejecuta 30,31,32,33.
37. **Documentación de 5 decisiones pendientes** — cinco archivos en `decisiones/`
    replicando el molde de `sin_gse`: `cobertura_temporal`, `paleta_categorias`
    (origen v03); `visibilidad_repo`, `modelo_pages`, `licencia` (origen v04). Cada
    uno con Contexto, Decisión, Justificación, Alternativas, Implicancia. La rationale
    de `visibilidad_repo` y `modelo_pages` se reconstruyó desde el contexto disponible.
38. **Rediseño del modo EE: trayectoria detallada + lista sin-vigente** — R: `rbd_lst`
    gana `motivo` (NA→null) para exponer el motivo por año. Template: índice
    `RBD_MOTIVO`; componente único `EeRow` (fila clickeable que despliega trayectoria
    en texto: "2019: Medio · 2018: Sin categoría · Baja matrícula · …"); `CatColumn`
    consume `EeRow` (elimina la fila inline duplicada); `SinVigente` conserva el
    conteo oficial del parquet y lista los EE con su trayectoria. Se extrajo `EeRow`
    para que columnas y lista sin-vigente compartan la misma fila (evita bug por
    lógica duplicada).

### Sesión 7 (cambios 39-42) — Comentario tope + bucket sin-medición + botón limpiar + taxonomía

39. **Corrección del comentario stale "tope de 4"** — `33_motor_template.html` L1655
    y L2015: `// respeta el tope de 4` → `// respeta el tope de 10`. El comentario
    aparecía en DOS ubicaciones, no solo la registrada por v06 (auditoría de caso
    general). Cero cambio de lógica.
40. **Bucket de establecimientos sin medición 2019** — solo template. `App`: nuevo
    `sinMedicionEE = eeVisibles.filter(ee => ee.vigente === null)`, pasado a
    `SinVigente`, que renderiza un segundo bloque-lista "Sin categoría de desempeño en
    {ANIO_VIGENTE}", reusando `EeRow`. No suma al conteo oficial del parquet. Hallazgo:
    el dato `null` YA viajaba al cliente (L1555); no requirió columna nueva en R.
    Extiende la regla de tres buckets distintos: categoría real, "s/i", `null`.
41. **Botón "Limpiar" en la hoja comparativa** — botón tras "+ Agregar", visible solo
    con `entidades.length > 0`, que ejecuta `setEntidades([])`. CSS nuevo
    `.cmp-clear-btn` (secundario, contorno, para no competir con el primario azul).
    Reusa el estado existente; sin lógica nueva.
42. **Reconciliación de la taxonomía del backlog** — "Diseño UI / motor" (15, ~39%)
    se subdivide por subsistema en "Motor base y diseño", "Hoja comparativa" y "Modo
    establecimiento"; se absorbe el descuadre heredado de v05 (sumaba 34 declarando
    35). La reclasificación vive solo en la tabla temática; no se reescriben entradas
    del cronológico.

### Sesión 8 (cambios 43-44) — Alineación panel con fuente oficial + decisión taxonomía-meta

43. **Alineación del panel metodológico con la caracterización oficial** — solo
    template, componente `NotasMetodologicas`. 4 definiciones reescritas: de un fraseo
    que aplanaba Insuficiente y Medio-Bajo al fraseo oficial por grado (Insuficiente
    "muy por debajo", Medio-Bajo "por debajo", Medio "similares", Alto "sobresalen").
    Párrafo de ponderación agregado (67% Estándares de Aprendizaje + 33% resto). Nota
    "Conteo" afinada (el no-ponderar como elección deliberada). Nota "Cobertura
    temporal" precisada (2019 sin consecuencias / 2020-2021 sin categorización / 2022
    no usado). Scope creep evitado: no se agregaron base legal ni IDPS detallados.
44. **Decisión P-taxonomía-meta: no se crea "Meta / backlog"** — una categoría con 1
    entrada (~2%) viola el umbral de absorción de la política. Crear la categoría
    sería sobre-ingeniería de taxonomía. Reevaluar si las entradas meta llegan a 2-3.

### Sesión 9 (cambios 45-48) — Matrícula por tipo de enseñanza en la ficha

45. **Insumo agregado de matrícula por tipo de enseñanza** — se generó
    `matricula_rbd_ense.parquet` (grano rbd x año x cod_ense2, 2016-2019) en el
    proyecto hermano `slep_analisis_matricula` y se depositó en `20_insumos/`.
    Esquema: `rbd` (chr), `anio` (int), `cod_ense2` (chr), `matricula` (int, COUNT(*)),
    `matricula_total_ee` (int, suma de todos los cod_ense2 del EE ese año). 5
    validaciones en verde; matrícula = COUNT(*) (estándar MINEDUC), sin filtro por
    `estado_estab`; `normalize_names=true` + `all_varchar=true` en DuckDB resuelve la
    inconsistencia mayúsculas/minúsculas entre años y mantiene llaves como texto.
46. **Integración de matrícula en el generador (bloque JSON propio)** —
    `33_generar_html.R` carga el parquet con guard de existencia; diccionarios
    `ENSE2_LABELS` (8 tipos) y `ENSE2_A_NIVEL` (mapa cod_ense2 → nivel); bloque
    columnar `matricula_lst` agregado al JSON; validaciones `stopifnot` (filas calzan,
    cod_ense2 en dominio, total constante por rbd x año). La matrícula viaja como
    bloque separado (grano cod_ense2 distinto al de categoría) y el cliente la cruza,
    manteniendo cada cifra rastreable a un único nivel.
47. **Cifra de matrícula vigente en la fila colapsada de la ficha** — índice `MAT_IX`
    y helpers `matriculaNivel` (media = suma de cod_ense2 5 y 7), `matriculaTotalEE`,
    `matriculaDesglose`. El objeto `ee` gana `nivel`, `mat_nivel_vig`,
    `mat_total_vig`. En `ee-row-meta`: "Matrícula 2019: N" con total del EE entre
    paréntesis solo si difiere del nivel (evita repetir en EE de nivel único, 76,7%).
48. **Panel expandido enriquecido con desglose por tipo de enseñanza** — rediseño del
    panel del click. Por año descendente: encabezado (categoría del nivel + "N
    matriculados en Educación Básica/Media"); bloque "Matrícula por tipo de
    enseñanza" (cada cod_ense2 con su matrícula; básica/media resaltadas, resto como
    contexto tenue); cierre "Total establecimiento". Tensión resuelta: media HC (5) y
    TP (7) son dos cod_ense2 pero una sola categoría de media (se suman 5+7).

### Sesión 10 (cambios 49-54) — Matrícula en tarjetas/comparador/ficha + tipografía por tokens

49. **Estudiantes por categoría + % en las tarjetas de modo territorio** —
    `distribucionDesdeEE` devuelve `matTotalNivel`; `CatColumn` suma `mat_nivel_vig` y
    calcula `matPct = matNivel/matTotal`, con denominador de categorizados para que
    coincida con el universo del % de EE y los 4 % sumen 100 (D15).
50. **"N EE" + tooltip de estudiantes y % en cada celda del comparador** —
    `distEntidadComparativa` acumula `cats[c].mat` y `matTotalNivel`; celda
    "XX,X% · n EE"; `<td>` con `title` "M estudiantes en N establecimientos · XX,X% de
    la matrícula de [nivel]"; tooltip nativo sin estado.
51. **Evolución de matrícula del nivel 2016-2019 en el panel expandido** — helper
    `matriculaSerieNivel(rbd, nivel)`; bloque "Evolución de la matrícula en [nivel]"
    con cifra por año + variación primer→último año con dato; se oculta con <2 años
    con dato; diseño textual, no SVG (D16).
52. **Reformateo del panel expandido** — encabezado del año en dos líneas (categoría
    arriba, matrícula del nivel debajo como bloque indentado `.ee-detail-matnivel`);
    desglose por tipo de enseñanza con dos puntos y "estudiantes" solo en la primera
    fila; "Total establecimiento:" con dos puntos.
53. **Aclaración del texto de matrícula en la fila colapsada** — "Matrícula 2019: 58
    (68)" → "Matrícula 2019: 58 en Educación Básica · 68 en total", con el total
    condicionado a `mat_total_vig !== mat_nivel_vig`.
54. **Estandarización tipográfica por tokens** — 19 tamaños literales 9-30px → 8
    tokens `--fs-*` (piso 11px en minúsculas, 10px solo en overlines mayúscula); 6
    pesos 400-900 → 4 tokens `--fw-*`; 3 familias → 2 (`--font-display`/`--font-body`
    unificadas en `--font-sans` como alias, `--font-mono` intacta); cero literales
    salvo un `0.92em` relativo intencional (D17, A15).

### Sesión 11 (cambios 55-58) — Recuperación Git + materialización backlog + cobertura 2016-2025

55. **Recuperación de la sesión 10 en Git (5 commits + push)** — la sesión 10 cerró
    con falla de herramienta dejando todo en el working tree. Se recuperó en commits
    temáticos: motor + `docs/index.html` (c.49-54, feat); alcance de grado + decisión
    de procedencia (docs); traspaso v10 (docs); snapshots del escáner (chore). Push a
    main (edbf86c→9822fe0). Pages servía una versión previa a los cambios 49-54.
56. **Materialización del backlog acumulativo del v10** — el §5 del traspaso v10
    estaba en placeholder. Se materializó: backlog de v09 íntegro (1-48) + las 6
    entradas 49-54, con tabla temática y estadístico recalculados sobre 54. Commit
    `e16d19a` + push. El backlog es la única fuente de verdad del conteo histórico.
57. **Ampliación de la cobertura del insumo de matrícula a 2016-2025** —
    `slep_analisis_matricula/03_…R`: `ANIOS_OBJETIVO <- 2016:2019` → `2016:2025`. El
    resto del pipeline ya era agnóstico al año. Parquet regenerado:
    85.594→211.391 filas; 2025 con 10.949 RBD / 10.945 funcionando / 3.541.840
    matrículas, sin duplicados. P-matrícula-actual estaba marcado "bloqueado por dato
    2025" cuando el dato YA estaba (CSV en disco); el bloqueo real era el parquet
    desactualizado + la constante hardcodeada (A16).
58. **Regeneración del motor con el insumo 2016-2025** — `run_all()` corrió los 4
    pasos; el motor levantó 211.391 filas, años 2016-2025. JSON 8.0→11.0 MB; HTML
    1313→1713 KB. Los 6 invariantes del paso 32 intactos. El motor carga los 10 años
    pero `ANIO_VIGENTE` sigue en 2019; el dato 2025 NO se expone aún (esperado).

### Sesión 12 (cambios 59-62) — Convivencia matrícula 2025 + grano de grado + narrativa territorial (parcial)

59. **Convivencia de año de matrícula (D19): `anio_matricula_vigente`** —
    `33_generar_html.R` + template. Se agregó a `meta` el campo
    `anio_matricula_vigente = max(años de matrícula)` (=2025), separado de
    `anio_vigente` (=2019). En el template, `ANIO_MAT_VIGENTE` (fallback
    `|| anio_vigente`) gobierna SOLO la tarjeta de tamaño de la fila de EE.
    Trayectoria, detalle por año y serie de evolución siguen con `ANIO_VIGENTE`.
    Hallazgo: el v11 afirmaba `ANIO_VIGENTE` hardcodeado; falso, era `max(años_disp)`
    derivado (refuerza A16/B.1).
60. **Script 04: parquet de matrícula a grano de grado** —
    `slep_analisis_matricula/04_…R` (creado): réplica fiel del 03 (DuckDB perezoso,
    `all_varchar`, control COUNT(*) vs DISTINCT mrun, llaves character) con `cod_grado`
    en el GROUP BY. Salida `matricula_rbd_grado.parquet` (rbd x año x cod_ense2 x
    cod_grado, 2016-2025), 913.499 filas, sin `matricula_total_ee`. Validación 5.3:
    reconstruye el agregado por ense2 desde el grano de grado y verifica que cuadre.
    El alcance afirmaba `cod_grado` confirmado por el script 02; el 03 no lo lee, hubo
    que perfilar el CSV (A16).
61. **Desglose por grado en el motor** — `33_generar_html.R`: carga de
    `matricula_rbd_grado.parquet` filtrada a ense2 2/5/7, `GRADO_LABELS` en meta,
    bloque columnar `matricula_grado_lst`, validación de dominio y de consistencia
    (suma de grados == matrícula por ense2). Template: índice `MATG_IX`, helper
    `matriculaPorGrado`, componente `EnseItem` (cada tipo de enseñanza es un
    sub-componente con estado de colapso; toggle si tiene grado, colapsado por
    defecto). CSS para la sub-lista anidada.
62. **(PARCIAL/INESTABLE) Bloque narrativo y rediseño de cabecera territorial** —
    función `narrativaTerritorial(entity, nivel, dist, porCat)` que arma un párrafo de
    resumen por composición para la vista por territorio, reemplazando el subtítulo
    "N establecimientos categorizados…". Frases: cuántos EE categorizados;
    distribución por categoría (omite las de 0); matrícula por desempeño (contraste
    Medio+Alto vs solo Insuficiente, anclado a matrícula 2025); cierre de transición.
    El CONTENIDO fue aprobado; el LAYOUT NO convergió tras ~8 iteraciones y quedó en
    estado no confiable (causa: iterar parámetros CSS sin criterio observable, A18).
    Resuelto en c.63.

### Sesión 13 (cambios 63-66) — D21 resuelto (referencia UI) + warning + alias + check 6.5

63. **D21 resuelto: template regenerado desde la referencia UI aprobada** — se tomó el
    archivo de referencia UI aprobado por el titular (con DATA inyectado, 2.8 MB) y se
    reconstruyó el template por ingeniería inversa, restaurando vía regex los 3
    placeholders (`__D3_INLINE__`, `__PAKO_INLINE__`, `__JSON_DATA__`). El cuerpo (CSS
    + JSX) quedó idéntico a la referencia. Cambios de layout: `.app-header`,
    `.brand-eyebrow-row` nuevo, `.terr-narrativa` a ancho de grilla con line-height
    2.0, `.sin-vigente-ul` en grilla 3/2/1 col, separación de filtros 44px, `.ee-row`
    apilada con separador punteado, leyenda a la derecha. Copy: "Agencia de Calidad" →
    "Sistema de Aseguramiento de la Calidad de la Educación". La referencia ES el
    criterio observable: no se itera, se reproduce (A19).
64. **Warning de `readLines` silenciado de raíz** — `33_generar_html.R` L491-493: las
    3 lecturas pasan a `readLines(..., encoding = "UTF-8", warn = FALSE)`. El warning
    "incomplete final line" se dispara cuando un insumo no termina en newline.
    `warn = FALSE` corrige el caso general (cualquier insumo sin newline final), no
    solo el template de hoy. Alternativa descartada: reescribir el template con
    newline final (resolvería el síntoma, no el caso general).
65. **Alias de conveniencia `regenerar_motor()` en el orquestador** — nueva función
    `regenerar_motor()` que llama a `run_all(only = 33L)`, con su roxygen y ejemplo. El
    default de `run_all()` NO se tocó. Cambiar el default a `only = 33` habría violado
    la política del orquestador (reproducibilidad, 5.6 #2). Tensión conveniencia (DX)
    vs reproducibilidad resuelta a favor de la política, dando el atajo por vía
    paralela (D22).
66. **Check 6.5 de partición territorial en el paso 32** — `32_agregar_territorial.R`,
    tras el 6.4: toma `n_categorizados` distinto por celda comunal, lo suma por nivel
    x año, y lo compara contra el total nacional (`control_nac`). Alerta SOLO si la
    suma comunal EXCEDE el nacional (`exceso > 0`); la suma menor es válida (las
    comunas son partición parcial). `distinct` antes de `sum` para no multiplicar por
    las 4 categorías; reúso de `df_comuna` y `control_nac` ya en memoria.

### Sesión 14 (cambios 67-69) — Backlog consolidado in extenso + auditoría de cifras (4.5) + higiene Git

67. **Backlog consolidado 1-66 in extenso (DT-backlog-documental)** —
    `50_documentacion/activa/backlog_consolidado_1-66.md` (nuevo). Se materializó el
    detalle cronológico completo 1-66 como entradas autónomas, reconstruidas desde el
    registro detallado (sección 4) de cada traspaso de origen (1-11 del v01 como lista
    sin numeración individual, conservada así; 12-66 individuales). Incluye objetivo
    del proyecto, nota metodológica, tabla temática (12 categorías) y estadístico por
    sesión. El detalle se arrastraba por referencia ("copiar íntegro 1-54/1-58/1-62")
    desde el v11; el backlog es la única fuente de verdad del conteo (política 2.2.5) y
    en estado referenciado no cumplía esa función. Verificación: numeración continua
    1-66 sin huecos ni duplicados; tabla temática suma 66 entrada por entrada. Hallazgo
    corregido a la raíz: la tabla heredada sumaba mal (un borrador dio 61); se recontó
    por intención primaria desde el cronológico, no desde la tabla heredada (A22).
    Commit `998cfd3`.
68. **Auditoría de cifras publicadas (protocolo 4.5, patrón de 3 scripts)** — `tests/`
    (3 archivos nuevos). `auditar_cifras_helpers.R`: camino B independiente que
    recalcula la distribución territorial y el sin-vigente desde el crudo
    (`categoria_rbd.parquet`) SIN reusar `contar_territorial()` del paso 32 (usa
    `summarise` + `tidyr::complete` en vez de `crossing` + `left_join`), con
    tolerancias nombradas (`AUD_TOL_CONTEO=0L`, `AUD_TOL_PCT=1e-9`).
    `auditar_cifras.R`: orquestador de 4 familias en `tryCatch` (F1 distribución, F2
    sin vigente, F3 cierre por-EE, F4 invariante de referencia), reporte sellado +
    alias. `spot_check_publicado.R`: cierra el tramo parquet→JSON→HTML descomprimiendo
    el `atob(...)` embebido en `docs/index.html` contra el crudo. Verificación: 4
    familias OK (0 discrepancias), spot-check OK (Costa Central/básica/2019/MEDIO: 26
    de 56). La auditoría vive en `tests/`, no en el pipeline (D23); el camino B debe ser
    código distinto al de producción para que el doble cálculo tenga valor (A21).
    Commit `729dbf0`.
69. **Higiene de Git: ignorar reporte regenerable + snapshot del escáner** — (a)
    `.gitignore` +1 regla `tests/reportes/` (salida regenerable, como
    `motor_categoria.html`); (b) commit del snapshot del escáner generado en la sesión
    (poda de retención 2 aplicada). Mantener fuera de Git lo regenerable (defensa
    contra ruido en el historial); versionar el snapshot del escáner es la convención
    del proyecto. Verificación: `git status --short` vacío al cierre. Commits `2a5d0c0`
    (escáner) y `b6e0634` (ignore).

### Sesión 15 (cambios 70-73) — Cierre P1-P3 (backlog + spot-check + nota README) + suite de documentación

70. **Consolidación del backlog 67-69 + renombre sin rango (DT-backlog-renombre)** —
    se agregaron las entradas 67-69 al backlog in extenso y se renombró
    `backlog_consolidado_1-66.md` → `backlog_consolidado.md` (sin rango en el nombre,
    para crecer por delta sin renombrar cada sesión). Tabla temática y estadístico
    recalculados sobre 69. El nombre con rango obligaba a renombrar en cada
    consolidación; el documento vivo estable lo evita. Verificación: numeración
    continua 1-69 sin huecos, tabla temática suma 69. Commits `d2d8ecc` (consolidación
    67-69) y `28f500c` (eliminación del archivo con rango).
71. **Spot-check parametrizado a múltiples celdas ancla (DT-spot-check-cobertura)** —
    `tests/spot_check_publicado.R`: `SPOT_CELDAS` pasa de una celda única a una lista
    de 6 celdas ancla (ambos niveles, extremos del rango temporal, varias categorías),
    cada una evaluada de extremo a extremo (crudo vs JSON embebido en
    `docs/index.html`) sobre una sola descompresión. Cierra el tramo JSON→HTML en
    varios puntos, complementando la auditoría F1-F4 a nivel parquet. Corrección: la
    celda media/2016/INSUFICIENTE no existe en el territorial publicado (media no tiene
    2016) y hacía fallar el script; se reemplazó por media/2019/INSUFICIENTE.
    Verificación: 6/6 celdas OK. Commit `56b308b`.
72. **Nota de verificación de cifras en el README (D23)** — `README.md`: nueva sección
    "Verificación de cifras antes de publicar", entre "Cómo correr el pipeline" y
    "Estructura". Documenta el doble cálculo (`auditar_cifras.R` +
    `spot_check_publicado.R`), recomienda correrlo tras cada regeneración del motor y
    antes de `git push`, y aclara que NO es parte de `run_all()` por diseño. Mitiga el
    riesgo de que la auditoría no se corra antes de publicar sin contradecir D23 (cierra
    la nota menor DT-auditoria-no-integrada del v14). Commit `8432417`.
73. **Suite de documentación generada con suitedoc (4 HTML + documentar.R)** —
    `documentar.R` (raíz, nuevo) construye la `cfg` del proyecto desde cero (sin partir
    de `cfg_ejemplo()`, para garantizar cero residuos del proyecto hermano) y llama a
    `suitedoc::generar_suite(verificar = TRUE)`, generando 4 HTML en
    `50_documentacion/suite/` + el tema (CSS, fonts, assets). Documentación autónoma:
    arquitectura técnica, manual del proyecto, arquitectura general y guía general, con
    contenido anclado en las decisiones y los scripts reales del pipeline. Las
    decisiones del `cfg` van sin numeración (id vacío) para no referenciar números
    inexistentes en `decisiones/`. Verificación: genera sin abortar (verificar=TRUE),
    cero residuos, tildes UTF-8 correctas y `<meta charset>` presente. Commit `51b5159`.

### Sesión 16 (cambios 74-80) — Rediseño D2 de la ficha + retiro de código muerto + ausencia en spot-check

74. **Eliminación del detalle por grado en la ficha de establecimiento** —
    `30_procesamiento/33_motor_template.html`: el componente `EnseItem` se simplificó a
    una fila simple (etiqueta de enseñanza + matrícula), retirando el estado `abierto`
    (`useState`), la invocación `CatData.matriculaPorGrado`, la variable `tieneGrado`, el
    botón `ee-ense-toggle` y el `<ul ee-grado-list>` con sus filas de grado; el call site
    queda sin las props `rbd`/`anio`. CSS de grado eliminado. Decisión del titular: el
    detalle por grado (1°-8°) es un nivel de detalle que no corresponde a una vista de
    categorías de desempeño (las categorías no son por curso). Verificación: JSX
    transpila con Babel sin error; placeholders=3; sin `ee-grado`/`ee-ense-toggle` en el
    template. Commit `0e74548`.
75. **Rediseño D2 de la trayectoria por año a filas a todo el ancho** —
    `33_motor_template.html`: el `<li>` por año de `EeRow` apila como hijos directos de
    `.ee-detail-row` la cabecera (año + marca + categoría, sin dos puntos), el subtítulo
    "N matriculados en {NIVEL}", la lista de enseñanza a todo el ancho y la fila "Total
    establecimiento" destacada (condición independiente). CSS: se quitó el `margin-left:
    100px` del subtítulo y se eliminaron `.ee-detail-ense` y `.ee-detail-ense-title` (el
    wrapper y el mini-título "Matrícula por tipo de enseñanza" ya no se renderizan). La
    organización en columna estrecha desaprovechaba el ancho; el modelo de filas escala a
    establecimientos con 5+ tipos de enseñanza (donde un layout de columnas por enseñanza
    no cabe). Verificación: JSX válido; placeholders=3; sin clases residuales; revisión
    visual del titular aprobada (D25). Commit `1535110`.
76. **Commit de snapshots del escáner (poda de retención 2)** —
    `50_documentacion/estructura/`: se versionaron los snapshots generados durante la
    sesión; la poda de retención=2 (política 7.4) eliminó el snapshot `133903` y conservó
    `143652` + aliases (Git lo registró como rename). Se versiona aparte del rediseño de
    UI (un cambio conceptual por commit). Commit `599b3df`.
77. **Encabezado de columnas por año en la ficha** — `33_motor_template.html`: se agregó
    un encabezado sutil, uno por bloque-año, entre el subtítulo y la lista de enseñanza:
    "Nivel" (izquierda) y "N° de estudiantes" (derecha), bajo la condición
    `desglose.length > 0`, con CSS nuevo `.ee-detail-ense-head` (flex `space-between`,
    atenuado, borde inferior fino). Las filas de enseñanza quedaban sin rotular tras D2;
    el encabezado da contexto a las dos columnas, por año porque cada año es un bloque
    independiente. Token de tamaño `var(--fs-xs)` (no `--fs-overline`, reservado a
    mayúsculas); sin `text-transform: uppercase`. Verificación: JSX válido;
    placeholders=3; spot-check 6/6 OK; header presente en `docs/index.html`. Commit
    `b4b5596`.
78. **Eliminación del sufijo redundante "estudiantes" en la ficha** —
    `33_motor_template.html`: la cifra de `EnseItem` dejó de llevar el sufijo condicional
    del primer ítem (`{di === 0 ? " estudiantes" : ""}`); como `di` quedó sin uso, se
    eliminó en cascada de la firma (`{ d, di }` → `{ d }`), del `map` y del call site.
    Tras agregar el encabezado "N° de estudiantes" (c.77), la primera fila repetía la
    palabra ("36 estudiantes"); el rótulo ya da el contexto. Verificación: JSX válido;
    `di` ya no aparece en el archivo; placeholders=3. Commit `1ed0524`.
79. **Retiro de código muerto de matrícula por grado en el motor** —
    `33_motor_template.html`: se retiraron del motor el índice `MATG` y `MATG_IX` (con el
    `for` que lo poblaba), la función `matriculaPorGrado` completa, la entrada
    `matriculaPorGrado` del objeto `CatData` y `GRADO_LABELS` (cuya única referencia viva
    estaba dentro de `matriculaPorGrado`). SOLO el motor: NO se tocó el pipeline ni el
    JSON; `DATA.matricula_grado` sigue embebido y el motor solo deja de consumirlo (el
    desacople del JSON es un cambio de pipeline aparte, queda como pendiente). Al eliminar
    la expansión por grado (c.74) ese código quedó sin uso. Verificación: grep de control
    vacío (`matriculaPorGrado|MATG|MATG_IX|ee-grado`); JSX válido; placeholders=3;
    spot-check 6/6 OK. Commit `2d6e570`.
80. **Certificación de ausencia simétrica en el spot-check (DT-spot-check-ausencia)** —
    `tests/spot_check_publicado.R`: nueva lista `SPOT_AUSENCIAS` (combinaciones
    tipo/nom/nivel/anio que la fuente no publica, sin `categoria`), dos funciones nuevas
    (`spot_esperado_ausencia_slep` cuenta filas en crudo sin filtrar categoría;
    `spot_publicado_ausencia_slep` cuenta filas en el territorial publicado sin filtrar
    categoría y SIN `stop()` ante 0) y un Paso 1-bis que recorre `SPOT_AUSENCIAS` (PASS si
    crudo==0 && pub==0; FALLA acumulada en el mismo vector `fallas`), con el veredicto
    agregado ajustado a presencia + ausencia. El spot-check solo verificaba presencia y
    reventaba ante una celda ausente (A24); el modo de ausencia cierra la verificación por
    ambos lados y certifica como correcta la ausencia legítima (media/2016). Verificación:
    ejecución real, 6 presencia OK + 1 ausencia OK, veredicto final OK; el script ya no
    aborta ante media/2016. Commit `87c9a7c`.

### Sesión 17 (cambios 81-82) — Saneamiento de pendientes de pipeline y administrativos

81. **Desacople de `matricula_grado` y `grado_labels` del JSON embebido** —
    `30_procesamiento/33_generar_html.R`: se retiró todo lo que solo servía al desglose
    por grado: la constante `GRADO_LABELS`, la carga de `matricula_rbd_grado.parquet`
    (ruta + `stop` + `read_parquet` + filtro 2/5/7 + `message`), `meta$grado_labels`, el
    bloque columnar `df_mat_grado_ord` + `matricula_grado_lst`, su validación de
    integridad (`stopifnot` del bloque grado + el cruce `chk_grado` de suma de grados vs
    ense2), la clave `matricula_grado` de `json_root` y el `message` "Matric.grado" del
    resumen. El motor había dejado de consumir el desglose en el v16 (c.79, retiro de
    código muerto), pero el generador lo seguía embebiendo: ~1 MB de dato inerte en el
    HTML. Este desacople (cambio de pipeline) cierra el ciclo que c.79 dejó abierto. El
    parquet permanece en `20_insumos/` como insumo externo de `slep_analisis_matricula`,
    read-only; desacoplar significa dejar de leerlo y embeberlo, no borrarlo (A28,
    inmutabilidad de la fuente 5.2.1). Verificación: grep de control sobre el template
    vacío (`grado_labels|matricula_grado|GRADO_LABELS|matriculaPorGrado|MATG`);
    `regenerar_motor()` OK; JSON sin comprimir 11.0 MB → motor 1.72 MB (era 2.80);
    auditoría F1-F4 OK; spot-check 6/6 + 1 ausencia OK. Commits `22e317f` (generador) +
    `1108c60` (motor regenerado).
82. **Commit de snapshots del escáner (poda de retención 2)** —
    `50_documentacion/estructura/`: se versionaron los snapshots generados durante la
    sesión; la poda de retención=2 (política 7.4) conservó los 2 timestamps más recientes
    + aliases y eliminó los anteriores (Git lo registró como rename). El escáner se corrió
    al abrir y al cerrar; se versiona aparte del cambio de pipeline (un cambio conceptual
    por commit). Commit `e0ee56e`.

### Sesión 18 (cambios 83-85) — Internalización de dependencias (alcance A) y administrativos

83. **Internalización de React y ReactDOM inline (alcance A; Babel queda en CDN)** —
    `30_procesamiento/33_motor_template.html` + `33_generar_html.R` + `10_utils/`: en el
    template, los dos `<script src>` de React y ReactDOM (unpkg, con SRI) se reemplazaron
    por los placeholders `__REACT_INLINE__` y `__REACTDOM_INLINE__`; el bloque de Babel
    quedó intacto (CDN + SRI). En el generador: rutas `react_path`/`reactdom_path` a
    `10_utils/`, validación de existencia con instrucción curl en el `stop`, lectura del
    código, los dos placeholders agregados al `for` de validación (ahora 5) y a la
    inyección (5 `sub()`), y `react_code`/`reactdom_code` liberados en el `rm()`. Dos `.js`
    nuevos bajados de unpkg a `10_utils/` (React 18.3.1, ReactDOM 18.3.1, versionados). El
    motor cargaba React, ReactDOM y Babel desde unpkg en runtime (única violación viva de
    5.5): internalizar React/ReactDOM elimina dos de las tres dependencias de red con costo
    de peso marginal. Babel se dejó en CDN porque su build standalone (~3 MB) inflaría el
    motor deshaciendo la ganancia del v17 (decisión de alcance A, D28; la eliminación de
    Babel vía C3 queda diferida, D29). El SRI no se conserva en los inline (A30: protege la
    descarga por red, que ya no ocurre). Verificación: template con 5 placeholders
    presentes (grep); único `unpkg` en `<script src>` es Babel; `regenerar_motor()` OK
    (React 10 KB, ReactDOM 129 KB; motor 1.72→1.82 MB); auditoría F1-F4 OK, 0
    discrepancias; spot-check 6/6 + 1 ausencia OK; F4 sin drift. Cifras idénticas. Commits
    `d935805` (template + generador + 2 .js) y `98b127c` (motor regenerado).
84. **Consolidación del backlog 81-82 sobre 82** — `backlog_consolidado.md`: se agregaron
    las entradas 81 (desacople `matricula_grado`, "Pipeline R") y 82 (snapshots escáner,
    "Migración y publicación / DevOps") al detalle cronológico (nueva subsección "Sesión
    17"); la fila de la sesión 17 (v17, N=2) a la tabla por sesión; las filas "Pipeline R"
    (4→5) y "Migración y publicación / DevOps" (3→4) en la tabla temática; la nota de
    conteo recalculada sobre 82; y un bloque "Delta v17 (80→82)". El v17 dejó la
    consolidación 81-82 como pendiente administrativo explícito de la sesión 18; el backlog
    es la fuente de verdad del conteo (política 2.2.5). Verificación: suma de la tabla
    temática = 82; suma de la tabla por sesión = 82; última entrada del cronológico = 82
    (A22: verificado contra el cronológico, no contra la tabla heredada). Commit `7a94b2d`.
85. **Commit de snapshots del escáner (poda de retención 2)** —
    `50_documentacion/estructura/`: el escáner se corrió al abrir (`082134`) y al cerrar
    (`094448`); la poda de retención=2 conservó los 2 timestamps más recientes + aliases.
    El commit `bdb9e3c` versionó el snapshot de apertura; el de cierre (`094448`) quedó
    pendiente al cierre del chat y se commiteó al abrir la sesión 19 (orden natural: el
    chat se cierra tras el último escáner). El escáner se versiona aparte del cambio de
    código (un cambio conceptual por commit). Commit `bdb9e3c` (apertura) + el commit de
    cierre del snapshot en la s19.

### Sesión 19 (cambio 86) — Actualización de la suite de documentación para revisión externa

86. **Actualización de la suite de documentación (stack runtime real + terminología
    institucional)** — `documentar.R` + los 4 HTML de `50_documentacion/suite/` +
    `README.md`: se reflejó el stack de runtime real del motor (React 18.3.1, ReactDOM
    18.3.1, D3 v7 y pako inline en `10_utils/`, con Babel 7.29.0 como única dependencia de
    red por CDN) en los dos documentos técnicos (etapa 5 del diagrama de arquitectura
    técnica, `prosa$doc_pipeline` del manual y `pie_extra$arq_tec` con nota de que la
    eliminación de Babel vía C3 está planificada); los generales no llevan stack. En
    paralelo se reemplazó "colegio"/"colegios" por "establecimiento educacional"/
    "establecimientos educacionales" como sustantivo genérico en toda la cfg (40
    sustituciones), respetando las excepciones (voz coloquial del lector en FAQ, "Localiza
    tu colegio" como nombre propio de la Agencia, notación técnica "EE"/"n_EE"). README
    actualizado a la línea de runtime real. El titular envía el proyecto a revisión externa
    y la documentación debía reflejar lo que está funcionando en Pages tras el v18 (el
    README mencionaba solo d3/pako). Se actualizó el `documentar.R` vivo con un delta
    acotado, preservando la prosa de comunidad ya afinada (D30), en vez de regenerar la cfg
    desde cero. La terminología institucional quedó como regla 4.6.3.6 del protocolo
    (trabajo de BIBLIOTECA, no contabilizado aquí); tras revisar los HTML se detectó que el
    reemplazo estricto recargaba la prosa de comunidad y se afinó el criterio de "primera
    mención completa por párrafo, luego abreviado" (A33, D31), sin regenerar la suite ya
    publicada (D32: el ajuste de fluidez se aplicará en la próxima generación, para no
    derrochar tokens). Verificación: Claude Code contrastó el stack contra el filesystem (4
    .js en `10_utils/`, versiones correctas; 5 placeholders en el template; único `<script
    src>` es Babel) sin discrepancias; `generar_suite(verificar = TRUE)` no abortó; 0
    ocurrencias de "colegio" genérico en los 4 HTML; stack presente en arquitectura técnica
    y en el manual, ausente en los generales; cobertura 2016-2019 intacta. Cero cambios de
    pipeline, cálculo o motor. Commit `b36b960` (documentar.R + 4 HTML + README).

## Delta del backlog

**Consolidación v13 → documento in extenso (v14, cierre de DT-backlog-documental).**
Materializó el detalle cronológico completo 1-66 como entradas autónomas. Antes, las
entradas 1-48 se arrastraban como resumen de una línea por sesión y 49-66 vivían
dispersas en sus traspasos de origen; ahora quedan reproducidas en un solo lugar.
Refinamiento de taxonomía: se unificaron "Scaffold inicial" (v10) y la inicialización
de v04 bajo "Scaffold e inicialización", y se incorporaron las tres categorías nuevas
de v13. Cero reclasificaciones de entradas individuales; cero renumeraciones.

**Delta v14 (66 → 69).** Tres entradas nuevas de la sesión 14: 67 (backlog
consolidado, "Documentación de proyecto"), 68 (auditoría de cifras, "Validación /
integridad"), 69 (higiene de Git, "Migración y publicación / DevOps"). Sin categorías
nuevas: "Documentación de proyecto" 5→6, "Validación / integridad" 1→2, "Migración y
publicación / DevOps" 1→2. La categoría líder baja a 19% (13/69), bajo el umbral de
subdivisión. El documento pasó a nombre sin rango (`backlog_consolidado.md`,
DT-backlog-renombre) para crecer por delta sin renombrarse. Tabla temática reverificada:
suma 69, cuadra con el cronológico.

**Delta v15 (69 → 73).** Cuatro entradas nuevas de la sesión 15: 70 (consolidación
67-69 + renombre del backlog, "Documentación de proyecto"), 71 (spot-check multi-celda,
"Validación / integridad"), 72 (nota de verificación en README, "Documentación de
proyecto"), 73 (suite de documentación con suitedoc, "Documentación de proyecto"). Sin
categorías nuevas: "Documentación de proyecto" 6→9, "Validación / integridad" 2→3. La
categoría líder baja a 18% (13/73), bajo el umbral de subdivisión. Tabla temática
reverificada: suma 73, cuadra con el cronológico.

**Delta v16 (73 → 80).** Siete entradas nuevas de la sesión 16: 74 (eliminación del
detalle por grado, "Diseño UI — Modo establecimiento"), 75 (rediseño D2, "Diseño UI —
Modo establecimiento"), 76 (snapshots del escáner, "Migración y publicación / DevOps"),
77 (encabezado de columnas, "Diseño UI — Modo establecimiento"), 78 (eliminación del
sufijo redundante, "Diseño UI — Modo establecimiento"), 79 (retiro de código muerto del
grado, "Calidad de código / pipeline"), 80 (ausencia simétrica en el spot-check,
"Validación / integridad"). Sin categorías nuevas: "Diseño UI — Modo establecimiento"
8→12, "Validación / integridad" 3→4, "Migración y publicación / DevOps" 2→3, "Calidad de
código / pipeline" 1→2. Las cuatro entradas de UI de la ficha se imputan a "Modo
establecimiento" (no a una categoría "Interfaz" nueva) y el retiro de código muerto a
"Calidad de código / pipeline", reusando la taxonomía existente para no introducir
categorías bajo el umbral de absorción del 2%. La categoría líder baja a 16% (13/80),
bajo el umbral de subdivisión; "Modo establecimiento" sube a 15% (12/80), también bajo el
umbral. Tabla temática reverificada: suma 80, cuadra con el cronológico.

**Delta v17 (80 → 82).** Dos entradas nuevas de la sesión 17: 81 (desacople de
`matricula_grado`/`grado_labels` del JSON embebido, "Pipeline R"), 82 (commit de
snapshots del escáner con poda de retención 2, "Migración y publicación / DevOps"). Sin
categorías nuevas: "Pipeline R" 4→5, "Migración y publicación / DevOps" 3→4. La entrada
81 se imputa a "Pipeline R" (no a "Calidad de código / pipeline" donde quedó c.79, el
retiro de código muerto en el motor): aquí la intención primaria es el cambio del
generador del producto y su serialización JSON, no la limpieza de código del cliente. La
categoría líder baja a 16% (13/82), bajo el umbral de subdivisión. Tabla temática
reverificada: suma 82, cuadra con el cronológico.

**Delta v18 (82 → 85).** Tres entradas nuevas de la sesión 18: 83 (internalización de
React/ReactDOM inline, alcance A, "Pipeline R"), 84 (consolidación del backlog 81-82,
"Documentación de proyecto"), 85 (snapshots del escáner, "Migración y publicación /
DevOps"). Sin categorías nuevas: "Pipeline R" 5→6, "Documentación de proyecto" 9→10,
"Migración y publicación / DevOps" 4→5. La entrada 83 se imputa a "Pipeline R" por
intención primaria (cambio del paso 33 en lo que inyecta al producto), consistente con la
imputación de c.81; el c.84 es el acto de consolidación propio de la s18 (no confundir con
las entradas 81-82, que son contenido de la s17 que el c.84 absorbió). La categoría líder
baja a 15% (13/85), bajo el umbral de subdivisión. Tabla temática reverificada: suma 85,
cuadra con el cronológico.

**Delta v19 (85 → 86).** Una entrada nueva de la sesión 19: 86 (actualización de la suite
de documentación —stack runtime real + terminología institucional— para revisión externa,
"Documentación de proyecto"). Sin categorías nuevas: "Documentación de proyecto" 10→11. El
c.86 es un único cambio de proyecto distinguible del titular; la regla 4.6.3.6 de
terminología es trabajo de protocolo (BIBLIOTECA) y no se contabiliza, y los
administrativos de la sesión (commit del traspaso v18, consolidación 83-85, commits de
snapshots, push) son acciones de implementación, no cambios. El único porcentaje que se
mueve por el recálculo sobre 86 es "Diseño UI — Hoja comparativa" (11%→10%, sin cambio de
N). La categoría líder baja a 15% (13/86), bajo el umbral de subdivisión. Tabla temática
reverificada: suma 86, cuadra con el cronológico.
