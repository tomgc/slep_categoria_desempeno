# documentar.R — genera la suite de documentación de "slep_categoria_desempeno"
# ----------------------------------------------------------------------------
#   source(here::here("documentar.R"))   # en Positron, desde la raíz del repo
#
# Produce 4 HTML en 50_documentacion/suite/ (+ copia el tema: CSS, fonts, assets):
#   arquitectura_slep_categoria_desempeno.html       (esquema técnico)
#   documentacion_proyecto_slep_categoria_desempeno.html (manual del proyecto)
#   arquitectura_general_slep_categoria_desempeno.html   (línea de producción)
#   documentacion_general_slep_categoria_desempeno.html  (guía sin tecnicismos)
#
# La cfg se construye desde cero (no parte de cfg_ejemplo()) para garantizar
# cero residuos del proyecto hermano. generar_suite(verificar = TRUE) aborta si
# detecta huellas del ejemplo de fábrica; aquí no debería haber ninguna.
#
# Convención del proyecto: paquetes prefijados, here::here() para rutas.
# ----------------------------------------------------------------------------

cfg <- list(

  # ---- 1.1 Identidad del proyecto -------------------------------------------
  slug        = "slep_categoria_desempeno",
  institucion = "SLEP Costa Central",
  area        = "Área de Monitoreo y Seguimiento",
  fuente      = "Datos públicos de la Agencia de Calidad de la Educación",

  salida_dir  = ".",
  css_href    = "suite_estilos.css",
  logo_href   = "assets/logo-white-stacked.png",

  # Las cuatro comunas del SLEP Costa Central (franja de cierre).
  comunas = list(
    list(nombre = "Concón",      bg = "var(--mk-red)"),
    list(nombre = "Puchuncaví",  bg = "var(--mk-yellow)", fg = "var(--ink)"),
    list(nombre = "Quintero",    bg = "var(--mk-green)"),
    list(nombre = "Viña del Mar",bg = "var(--mk-blue)")
  ),

  # ---- 1.2 Textos de cabecera por documento ---------------------------------
  cab = list(
    arq_tec = list(
      eyebrow = "Esquema de arquitectura · Versión técnica",
      h1      = "Arquitectura del proyecto",
      mono    = "slep_categoria_desempeno",
      tagline = "Motor de comparación de la Categoría de Desempeño de los establecimientos (Alto · Medio · Medio-Bajo · Insuficiente). Agregación por <strong>conteo de establecimientos</strong>, sin ponderación por matrícula y sin segmentación por GSE. Pipeline R (Positron) &rarr; HTML autocontenido (React + D3) · datos públicos de la Agencia de Calidad · publicado en GitHub Pages.",
      metas   = list(
        list(c="var(--ocean)", k="Lenguaje", v="R"),
        list(c="var(--coral)", k="Salida",   v="HTML autocontenido"),
        list(c="var(--olive)", k="Cobertura",v="2016–2019"),
        list(c="var(--sand)",  k="Niveles",  v="Básica · Media")
      )
    ),
    doc_tec = list(
      eyebrow = "Documentación del proyecto · Versión técnica completa",
      h1      = "Manual del proyecto",
      mono    = "slep_categoria_desempeno",
      tagline = "Presentación de punta a punta: qué problema resuelve, qué conceptos usa, cómo se construye y qué decisiones metodológicas lo gobiernan. Pensado para que cualquier persona del equipo —o una sesión de IA— entienda el proyecto en su totalidad.",
      metas   = list(
        list(c="var(--ocean)", k="Área",   v="Monitoreo y Seguimiento"),
        list(c="var(--olive)", k="Datos",  v="Agencia de Calidad (públicos)"),
        list(c="var(--coral)", k="Salida", v="motor_categoria.html")
      )
    ),
    arq_gen = list(
      eyebrow = "Esquema de arquitectura · Visión general",
      h1      = "Cómo se construye la herramienta",
      mono    = NULL,
      tagline = "De las planillas dispersas de la Agencia de Calidad a un tablero que se abre en el navegador, explicado como una línea de producción. Sin nombres de programas ni tecnicismos: solo qué entra, qué pasa en cada paso y qué sale.",
      metas   = list(
        list(c="var(--coral)", k="Para",           v="directivos, equipos y comunidad"),
        list(c="var(--olive)", k="Versión técnica", v="arquitectura_slep_categoria_desempeno.html")
      )
    ),
    doc_gen = list(
      eyebrow = "Documentación del proyecto · Guía general",
      h1      = "Qué es la herramienta y cómo leerla",
      mono    = NULL,
      tagline = "Una guía breve y sin tecnicismos para entender qué muestra el comparador de Categoría de Desempeño, qué se puede ver en él y en qué conviene fijarse al interpretarlo.",
      metas   = list(
        list(c="var(--coral)", k="Para",            v="directivos, docentes, apoderados y comunidad"),
        list(c="var(--olive)", k="Detalle técnico", v="documentacion_proyecto_slep_categoria_desempeno.html")
      )
    )
  ),

  # ---- 1.3 Diagrama técnico: insumos, auxiliares, etapas ---------------------
  insumos = list(
    list(t='Categoría Desempeño · básica', badge='4 xlsx',
         d='Una etiqueta por RBD y año · 2016–2019<br><span class="code-sm">cdb_AAAA.xlsx</span><br>Categoría: Alto · Medio · Medio-Bajo · Insuficiente'),
    list(t='Categoría Desempeño · media', badge='3 xlsx',
         d='Una etiqueta por RBD y año · 2017–2019<br><span class="code-sm">cdm_AAAA.xlsx</span><br>Media no tiene 2016 en la fuente')
  ),
  auxiliares = list(
    list(t='diccionario_territorios.xlsx', badge='xlsx',
         d='Equivalencias comuna · SLEP · región<br>Catálogo de entidades territoriales'),
    list(t='caracterizacion_establecimientos.xlsx', badge='xlsx',
         d='Directorio oficial por RBD<br>nombre · comuna · región · dependencia'),
    list(t='Listado oficial de SLEP', badge='xlsx',
         d='<span class="code-sm">202602_Listado_SLEP_2026_vf.xlsx</span><br>Asignación de comunas a cada Servicio Local'),
    list(t='Matrícula por RBD', badge='2 parquet',
         d='<span class="code-sm">matricula_rbd_*.parquet</span><br>Contexto del establecimiento · <strong>no</strong> pondera la agregación')
  ),
  aux_uses = c(
    '↘ <code>30_construir_auxiliares.R</code> catálogos territoriales',
    '↘ <code>31_leer_normalizar.R</code> recuperación de territorio y dependencia por RBD',
    '↘ <code>establecimientos_chile.parquet</code> resolución de códigos de comuna y región'
  ),

  etapas = list(
    list(n=2, titulo='Construcción de auxiliares', sub='30_procesamiento/',
         head='<span class="code">30_construir_auxiliares.R</span> <span class="bg bg--r">R</span>',
         d='Lee diccionario de territorios, caracterización de establecimientos y listado oficial de SLEP<br>Construye catálogos de entidades: <strong>comuna · SLEP · región · establecimiento · Chile</strong><br>Genera <span class="code-sm">comunas_chile.parquet</span> · <span class="code-sm">sleps_chile.parquet</span> · <span class="code-sm">establecimientos_chile.parquet</span><br>IDs numéricos como <strong>character</strong> (preserva ceros a la izquierda)',
         flags=character(0), norm=list()),
    list(n=3, titulo='Lectura y normalización', sub='30_procesamiento/',
         head='<span class="code">31_leer_normalizar.R</span> <span class="bg bg--r">R</span>',
         d='Lee los 7 xlsx (básica + media) por <strong>header</strong>, jamás por posición<br>Normaliza la categoría a 5 valores (4 reales + <span class="code-sm">s/i</span>)<br>Cruza por RBD contra el directorio para recuperar comuna, región y dependencia<br>Una fila por <span class="code-sm">rbd × nivel × año</span><br>Escritura atómica &rarr; <strong>categoria_rbd.parquet</strong>',
         flags=c('Básica y media nunca se mezclan','Lectura por header, nunca por posición','RBD sin match: territorio NA, dato conservado'),
         norm=list(
           list(id='A1', tx='<strong>Dos órdenes de columnas:</strong> los archivos 2016–2018 (esquema A) y 2019 (esquema B) traen las columnas en distinto orden, pero todos con headers correctos. La lectura por nombre (<span class="code-sm">clean_names()</span> + selección) resuelve ambos sin renombrar por posición.'),
           list(id='A2', tx='<strong>“Medio-Bajo (Nuevo)”:</strong> categoría que distingue la antigüedad del establecimiento, no un nivel de desempeño distinto. Colapsa en <span class="code-sm">MEDIO-BAJO</span> al normalizar.'),
           list(id='A3', tx='<strong>Dos “Sin Categoría”:</strong> por baja matrícula y por falta de información se unifican en <span class="code-sm">s/i</span>; el motivo se preserva en la columna auxiliar <span class="code-sm">motivo_sin_categoria</span>.'),
           list(id='A4', tx='<strong>RBD sin match en el directorio</strong> (establecimiento cerrado al snapshot 2025): no se descarta. Se marca con territorio NA y se reporta; el dato de categoría se conserva.')
         )),
    list(n=4, titulo='Agregación territorial', sub='30_procesamiento/',
         head='<span class="code">32_agregar_territorial.R</span> <span class="bg bg--r">R</span>',
         d='Agrega <span class="code-sm">categoria_rbd</span> por <strong>conteo de establecimientos</strong> (jamás ponderación por matrícula)<br>Cuatro tipos de entidad: comuna · SLEP · región · nacional, en formato largo<br>Conteo y porcentajes sobre las <strong>4 categorías reales</strong>; los <span class="code-sm">s/i</span> van aparte<br>Escritura atómica &rarr; <strong>categoria_territorial.parquet</strong> + <strong>categoria_sin_vigente.parquet</strong>',
         flags=c('Agregación = conteo de EE (nunca matrícula ni GSE)','s/i contado aparte: no diluye las proporciones'),
         norm=list()),
    list(n=5, titulo='Generación del motor', sub='30_procesamiento/',
         head='<span class="code">33_generar_html.R</span> <span class="bg bg--r">R</span> + <span class="code">33_motor_template.html</span> <span class="bg bg--html">HTML</span>',
         d='Serializa <span class="code-sm">categoria_territorial</span> + <span class="code-sm">categoria_sin_vigente</span> + catálogos a <strong>JSON</strong> embebido (gzip + pako)<br>Embebe el JSON (claves ordenadas, indentación fija) y el <strong>runtime inline</strong> en el template: <strong>React 18.3.1</strong>, <strong>ReactDOM 18.3.1</strong>, <strong>D3 v7</strong> y <strong>pako</strong> van versionados en <span class="code-sm">10_utils/</span> y viajan dentro del HTML; el cuerpo del motor está <strong>pre-transpilado a <span class="code-sm">React.createElement</span></strong> (runtime clásico), por lo que el HTML tiene <strong>cero dependencias de red</strong><br>Escribe el HTML autocontenido &rarr; <strong>motor_categoria.html</strong><br>Copia el producto a <span class="code-sm">docs/index.html</span> para publicación en Pages',
         flags=c('JSON embebido y comprimido (portabilidad total)','Runtime 100% inline; JSX pre-transpilado a React.createElement, sin CDN','docs/index.html no se edita a mano'),
         norm=list())
  ),

  intermedios = list(
    list(t='categoria_rbd.parquet',         d='Una etiqueta por RBD<br>× nivel × año<br>+ territorio y dependencia'),
    list(t='categoria_territorial.parquet', d='Conteo de EE por categoría<br>comuna · SLEP · región · nacional<br>formato largo, con <span class="code-sm">pct</span>'),
    list(t='categoria_sin_vigente.parquet', d='EE sin categoría vigente<br>desglose por motivo<br>(baja matrícula / falta info)')
  ),

  # ---- 1.4 Diccionario de datos ---------------------------------------------
  dic_crudos = list(
    list(campo='RBD', tipo='character', d='Rol Base de Datos: identificador único del establecimiento a nivel nacional.'),
    list(campo='Categoría Desempeño', tipo='character', d='Etiqueta de la Agencia de Calidad: ALTO · MEDIO · MEDIO-BAJO · INSUFICIENTE. También “Sin Categoría” (dos motivos) y “Medio-Bajo (Nuevo)”.'),
    list(campo='Matrícula', tipo='integer', d='Matrícula del establecimiento. Dato de contexto: <b>no</b> pondera ninguna agregación.'),
    list(campo='Comuna', tipo='character', d='Comuna del establecimiento (texto en el crudo; el código se recupera por RBD desde el directorio).'),
    list(campo='Región', tipo='character', d='Región del establecimiento (texto en el crudo).'),
    list(campo='Dependencia', tipo='character', d='Dependencia administrativa en texto. Se homologa a <span class="code-sm">cod_depe2</span> vía directorio.'),
    list(campo='Nombre Establecimiento', tipo='character', d='Nombre del establecimiento. Información pública por RBD (ver decisión de gobernanza).')
  ),
  dic_intermedios = list(
    list(campo='categoria_rbd.parquet', tipo='parquet', d='Una fila por RBD × nivel × año, con categoría normalizada (5 valores), motivo de s/i, y territorio + dependencia recuperados del directorio.'),
    list(campo='categoria_territorial.parquet', tipo='parquet', d='Conteo de EE por categoría a nivel comuna · SLEP · región · nacional, en formato largo, con <code>n_ee</code>, <code>n_categorizados</code> y <code>pct</code>.'),
    list(campo='categoria_sin_vigente.parquet', tipo='parquet', d='EE sin categoría vigente en el último año, con desglose por motivo, para la sección “Sin categoría vigente” del motor.'),
    list(campo='comunas_chile.parquet', tipo='parquet', d='Catálogo de comunas con su código, nombre, SLEP y región.'),
    list(campo='sleps_chile.parquet', tipo='parquet', d='Catálogo de Servicios Locales con sus comunas asociadas.'),
    list(campo='establecimientos_chile.parquet', tipo='parquet', d='Directorio por RBD con nombre, comuna, región y dependencia (snapshot 2025).')
  ),

  # ---- 1.5 Decisiones metodológicas -----------------------------------------
  decisiones = list(
    list(id='', titulo='Agregación por conteo de establecimientos (nunca ponderación)',
         cuerpo='<p>La distribución de un territorio <strong>no</strong> promedia porcentajes ni pondera por matrícula: <strong>cuenta</strong> cuántos establecimientos hay en cada categoría.</p><pre>distribución(territorio) = n_EE por categoría / total de EE categorizados</pre>',
         por_que='<strong>Por qué.</strong> La unidad de análisis es el <em>establecimiento</em>, y el dato es una <em>etiqueta categórica</em>, no una magnitud continua. Ponderar por matrícula respondería otra pregunta (cuántos estudiantes asisten a EE de cada categoría); aquí la pregunta es cuántos <em>establecimientos</em> caen en cada categoría. Contar es la operación correcta para ese dato.'),
    list(id='', titulo='Sin segmentación por GSE',
         cuerpo='<p>Ningún resultado se desagrega por Grupo Socioeconómico.</p>',
         por_que='<strong>Por qué.</strong> La Categoría de Desempeño es una clasificación <strong>integral</strong>: la Agencia de Calidad ya incorpora el contexto socioeconómico del establecimiento dentro de su metodología. Segmentar por GSE encima sería redundante y sugeriría, erróneamente, que la categoría es comparable “en bruto” entre grupos. Es la contraparte explícita del “GSE inviolable” del proyecto hermano: en ambos casos se busca comparabilidad correcta, pero la fuente la resuelve en lugares distintos.'),
    list(id='', titulo='Básica y media nunca se mezclan',
         cuerpo='<p>Educación básica y educación media se cuentan y se muestran siempre por separado.</p>',
         por_que='<strong>Por qué.</strong> Son universos de establecimientos y procesos de clasificación distintos; combinarlos en una sola cifra produce un número sin interpretación posible. Cada nivel se grafica por los años realmente disponibles para ese nivel (básica 2016–2019, media 2017–2019).'),
    list(id='', titulo='Año vigente = el más reciente disponible',
         cuerpo='<p>El año vigente —el que gobierna la vista por defecto y los conteos territoriales— se resuelve dinámicamente como <span class="inl">max(años disponibles)</span>. Hoy es <strong>2019</strong>.</p>',
         por_que='<strong>Por qué.</strong> 2019 es el último año publicado antes de la suspensión por pandemia; no existe categorización 2020. La trayectoria 2016–2019 es continua y no necesita marca de hueco, porque el corte de pandemia cae fuera del rango actual. Cuando entren datos más recientes, el año vigente avanza solo, sin rehacer el diseño.'),
    list(id='', titulo='Sin categoría vigente, en sección aparte',
         cuerpo='<p>Los establecimientos sin categoría en el último año (s/i) no se fuerzan dentro de las cuatro columnas: van a una sección <strong>“Sin categoría vigente”</strong>, con su motivo (baja matrícula o falta de información).</p>',
         por_que='<strong>Por qué.</strong> El conteo y los porcentajes consideran solo las cuatro categorías reales. Si los s/i entraran en la mezcla, un territorio con muchos establecimientos sin clasificar diluiría las proporciones de las categorías reales y la lectura sería engañosa.'),
    list(id='', titulo='Establecimientos identificados por nombre (agregados públicos)',
         cuerpo='<p>El motor lista cada establecimiento con su <strong>nombre</strong>, no solo su RBD.</p>',
         por_que='<strong>Por qué.</strong> La Categoría de Desempeño por establecimiento es información <strong>pública por diseño</strong>: la Agencia de Calidad la difunde nominalmente en su portal y en “Localiza tu colegio”. La restricción de las Condiciones de Uso protege datos por estudiante, no clasificaciones institucionales abiertas. Mismo criterio que el proyecto hermano.'),
    list(id='', titulo='Portabilidad cross-OS (fin de línea normalizado)',
         cuerpo='<p>El repositorio fija fin de línea <strong>LF</strong> para todo archivo de texto vía <span class="inl">.gitattributes</span> (<span class="code-sm">* text=auto eol=lf</span>), y marca como binarios los formatos de datos, fuentes e imágenes. El proyecto se clona y se ejecuta igual en <strong>macOS y Windows</strong>.</p>',
         por_que='<strong>Por qué.</strong> El código ya era agnóstico al sistema operativo (rutas vía <span class="code-sm">here::here()</span> y <span class="code-sm">file.path()</span>, UTF-8 explícito en toda lectura y escritura, literales no-ASCII como <span class="code-sm">\\uXXXX</span> para no depender del locale, escritura binaria del HTML que evita la conversión de fin de línea). Faltaba blindar los fin de línea: sin <span class="inl">.gitattributes</span>, un clon en Windows podía materializar CRLF y ensuciar el motor ensamblado, romper la verificación por AST de la fuente JSX o generar diffs espurios en los snapshots versionados. La normalización a LF cierra ese único punto y completa la portabilidad.')
  ),

  # ---- 1.6 Anomalías de origen ----------------------------------------------
  anomalias = list(
    list(id='A1',
         largo='<strong>Dos órdenes de columnas (2016–2018 vs 2019).</strong> Los archivos traen las columnas en distinto orden según el año, pero todos con headers correctos. Se leen siempre <strong>por nombre</strong> (<span class="inl">clean_names()</span> + selección), nunca por posición.',
         corto='Los archivos cambian el orden de columnas entre años. Se leen por nombre, no por posición.'),
    list(id='A2',
         largo='<strong>“Medio-Bajo (Nuevo)”.</strong> Una variante de la categoría que marca la antigüedad del establecimiento, no un nivel de desempeño distinto. Se <strong>colapsa</strong> en <span class="inl">MEDIO-BAJO</span> al normalizar.',
         corto='“Medio-Bajo (Nuevo)” indica antigüedad del EE, no un nivel distinto. Se unifica con Medio-Bajo.'),
    list(id='A3',
         largo='<strong>Dos “Sin Categoría”.</strong> Por baja matrícula y por falta de información. Se unifican en una sola marca <span class="inl">s/i</span>, conservando el motivo en una columna auxiliar para la sección “Sin categoría vigente”.',
         corto='Hay dos motivos de “Sin Categoría”. Se unifican en s/i y se preserva el motivo.'),
    list(id='A4',
         largo='<strong>RBD sin match en el directorio.</strong> Establecimientos cerrados al snapshot 2025 no aparecen en el directorio oficial. No se descartan: se marcan con territorio NA y se reportan; el dato de categoría se conserva.',
         corto='Algunos RBD (EE cerrados) no están en el directorio actual. Se conservan con territorio desconocido.')
  ),

  # ---- 1.7 Glosarios --------------------------------------------------------
  glosario_tec = c(
    '<strong>RBD</strong> — Rol Base de Datos. Identificador único de cada establecimiento.',
    '<strong>Categoría de Desempeño</strong> — Clasificación de la Agencia de Calidad en cuatro niveles: Insuficiente, Medio-Bajo, Medio, Alto.',
    '<strong>s/i</strong> — Sin información: establecimiento sin categoría en ese año (por baja matrícula o falta de información).',
    '<strong>cod_depe2</strong> — Dependencia administrativa agrupada, homologada desde el texto de la fuente.',
    '<strong>SLEP</strong> — Servicio Local de Educación Pública; sostenedor estatal que reemplaza la gestión municipal.',
    '<strong>Conteo de EE</strong> — Operación de agregación del proyecto: cuántos establecimientos por categoría, sin ponderar.',
    '<strong>parquet</strong> — Formato columnar comprimido para datos intermedios.',
    '<strong>Escritura atómica</strong> — Escribir a un archivo temporal y renombrar al final, para no dejar salidas a medias.'
  ),
  glosario_doc = c(
    '<strong>Categoría de Desempeño</strong> — la etiqueta que la Agencia de Calidad asigna a cada establecimiento educacional: Alto, Medio, Medio-Bajo o Insuficiente.',
    '<strong>Trayectoria</strong> — la secuencia de categorías de un establecimiento educacional a lo largo de los años.',
    '<strong>RBD</strong> — identificador único de establecimiento.',
    '<strong>SLEP</strong> — Servicio Local de Educación Pública.',
    '<strong>Básica / Media</strong> — los dos niveles de enseñanza, que siempre se muestran por separado.',
    '<strong>Sin categoría vigente</strong> — establecimientos educacionales que en el último año no recibieron categoría.',
    '<strong>Pipeline</strong> — la secuencia de pasos automatizados que transforma las planillas crudas en el motor navegable.'
  ),

  # ---- 1.8 Entidades comparables --------------------------------------------
  entidades_tec = list(
    list(ct='Comuna', cd='Todos los establecimientos de una comuna.'),
    list(ct='SLEP', cd='Agrupación de las comunas de un Servicio Local.'),
    list(ct='Región', cd='Agrupación de todas las comunas de una región.'),
    list(ct='Nacional (“Chile”)', cd='El total país.'),
    list(ct='Establecimiento', cd='Un RBD individual, con su trayectoria histórica.')
  ),
  entidades_gen = list(
    list(ct='Una comuna', cd='Todos sus establecimientos educacionales juntos.'),
    list(ct='Un Servicio Local', cd='Las comunas de un SLEP.'),
    list(ct='Una región', cd='Todas las comunas de la región.'),
    list(ct='Todo el país', cd='El total nacional, “Chile”.'),
    list(ct='Un establecimiento educacional', cd='Un establecimiento en particular, con su historia de categorías.')
  ),

  # ---- 1.9 Línea de producción ----------------------------------------------
  estaciones = list(
    list(icon='boxes', color='var(--ocean)', paso='Paso 1 · Insumo', titulo='Llegan las materias primas',
         parrafos=c('Cada año, la Agencia de Calidad de la Educación publica la <strong>Categoría de Desempeño</strong> de cada establecimiento: una etiqueta —Alto, Medio, Medio-Bajo o Insuficiente— en planillas separadas por año y por nivel (básica y media). Son datos <strong>públicos</strong> y vienen organizados por establecimiento educacional.',
                    'El problema es que están <strong>dispersos</strong> y el formato cambia de un año a otro: el orden de las columnas se mueve, una misma categoría aparece con etiquetas distintas. Tal cual llegan, no se pueden comparar.'),
         chip_in=list(ico='download', tx='Entra: planillas de categoría 2016–2019'), chip_out=NULL),
    list(icon='shield-check', color='var(--olive)', paso='Paso 2 · Preparación', titulo='Control de calidad y limpieza',
         parrafos=c('Antes de contar nada, cada planilla pasa por revisión. Se homologan las etiquetas de categoría, se unifican las distintas formas de “Sin Categoría” y se lee siempre por el nombre de la columna, nunca por su posición, para que todos los años hablen el mismo idioma.',
                    'A cada establecimiento educacional se le recupera además su <strong>comuna, región y dependencia</strong>, cruzando por su identificador contra el directorio oficial.'),
         chip_in=list(ico='file-warning', tx='Datos crudos, con diferencias entre años'),
         chip_out=list(ico='check', tx='Categorías homologadas por establecimiento educacional')),
    list(icon='layers', color='var(--coral)', paso='Paso 3 · Preparación', titulo='Ensamblaje y conteo',
         parrafos=c('Con todo limpio, los establecimientos educacionales se <strong>agrupan por territorio</strong>: por comuna, por Servicio Local, por región y a nivel país. En cada territorio se <strong>cuentan</strong> cuántos establecimientos hay en cada categoría.',
                    'No se promedia ni se pondera por matrícula: <strong>cada establecimiento cuenta como uno</strong>. La pregunta es cuántos establecimientos educacionales caen en cada categoría, y para eso lo correcto es contar.'),
         chip_in=list(ico='check', tx='Categorías por establecimiento educacional'),
         chip_out=list(ico='hash', tx='Conteo de establecimientos educacionales por categoría')),
    list(icon='bar-chart-3', color='var(--plum-80)', paso='Paso 4 · Producto', titulo='Empaque: se arma el tablero',
         parrafos=c('Los conteos ya calculados se empaquetan dentro de una <strong>interfaz interactiva</strong>: las cuatro columnas de categorías, las trayectorias de cada establecimiento educacional, el buscador y los controles para elegir qué comparar. Todo queda dentro de un solo archivo.',
                    'Lo importante: ese archivo <strong>lleva los datos adentro</strong>. No necesita conexión ni programas especiales para funcionar.'),
         chip_in=list(ico='hash', tx='Conteos calculados'),
         chip_out=list(ico='file-code-2', tx='Un archivo navegable')),
    list(icon='monitor', color='var(--plum)', paso='Paso 5 · Producto terminado', titulo='La herramienta lista para usar',
         parrafos=c('El resultado es un <strong>tablero que se abre en cualquier navegador</strong>, sin instalar nada. Permite elegir una comuna, un Servicio Local, una región o un establecimiento educacional y ver la distribución de establecimientos por categoría, además de la trayectoria histórica de cada uno.',
                    'Está publicado en línea para consulta, y se actualiza cada vez que llega un año nuevo: basta con repetir la línea de producción completa.'),
         chip_in=NULL, chip_out=list(ico='globe', tx='Tablero publicado y consultable'))
  ),

  # ---- 1.10 Garantías -------------------------------------------------------
  garantias = list(
    list(icon='hash', titulo='Cada establecimiento educacional cuenta como uno', d='Al juntar establecimientos se cuentan, no se promedian ni se ponderan por matrícula. La pregunta es cuántos establecimientos educacionales hay en cada categoría, y contar es la respuesta honesta.'),
    list(icon='scale', titulo='La categoría ya considera el contexto', d='La Categoría de Desempeño integra el nivel socioeconómico del establecimiento educacional en su propia construcción. Por eso no se segmenta por grupo socioeconómico: ya viene ajustada de origen.'),
    list(icon='shapes', titulo='No mezclamos básica con media', d='Educación básica y media se cuentan y se muestran siempre por separado. Mezclarlas daría una cifra sin sentido.'),
    list(icon='git-commit', titulo='Mostramos la trayectoria completa', d='Para cada establecimiento educacional se ve su categoría año a año, no solo la última. Así se distingue una mejora sostenida de un resultado puntual.'),
    list(icon='inbox', titulo='Lo no clasificado va aparte', d='Los establecimientos educacionales sin categoría en el último año no se fuerzan dentro de las cuatro categorías: se muestran en una sección propia, para no distorsionar las proporciones.'),
    list(icon='info', titulo='Solo años con datos reales', d='Se muestran únicamente los años efectivamente publicados (2016–2019). No se inventan ni se imputan años faltantes.')
  ),

  # ---- 1.11 "En qué fijarte" ------------------------------------------------
  notas = list(
    list(icon='palette', tx='<strong>El color indica la categoría; el nombre y el borde indican el territorio.</strong> Cada categoría tiene siempre el mismo color en todas las vistas, en orden de Insuficiente a Alto, así que no hay que memorizar leyendas distintas.'),
    list(icon='hash', tx='<strong>Lo que ves es un conteo de establecimientos educacionales, no un promedio.</strong> Cada columna dice cuántos establecimientos hay en esa categoría. Un establecimiento educacional grande y uno pequeño pesan igual: cada uno es uno.'),
    list(icon='scale', tx='<strong>No verás segmentación por grupo socioeconómico.</strong> No es un olvido: la Categoría de Desempeño ya incorpora el contexto socioeconómico del establecimiento educacional en su construcción.'),
    list(icon='shapes', tx='<strong>Básica y media se ven por separado.</strong> Son universos distintos; el motor nunca los suma en una sola cifra.'),
    list(icon='git-commit', tx='<strong>Mira la trayectoria, no solo el último año.</strong> Los chips de color a la derecha de cada establecimiento educacional muestran su categoría en cada año disponible. Ahí se lee si mejoró, se mantuvo o retrocedió.')
  ),

  # ---- 1.12 Preguntas frecuentes --------------------------------------------
  faq = list(
    list(q='¿Qué es la Categoría de Desempeño?', a='Es una clasificación que la Agencia de Calidad asigna a cada establecimiento en cuatro niveles: Alto, Medio, Medio-Bajo e Insuficiente. Resume el desempeño del establecimiento educacional considerando varios indicadores, e incorpora el contexto socioeconómico de sus estudiantes dentro de su metodología.', abierta=TRUE),
    list(q='¿Por qué se cuentan establecimientos en vez de promediar resultados?', a='Porque el dato de cada establecimiento educacional es una etiqueta (su categoría), no un número que se pueda promediar. La pregunta que responde la herramienta es cuántos establecimientos hay en cada categoría dentro de un territorio, y para eso lo correcto es contar, no promediar ni ponderar por matrícula.', abierta=FALSE),
    list(q='¿Por qué no se separa por grupo socioeconómico?', a='Porque la Categoría de Desempeño ya considera el contexto socioeconómico del establecimiento educacional dentro de su propia construcción. Separar otra vez por grupo socioeconómico sería redundante y daría a entender, erróneamente, que la categoría se puede comparar “en bruto” entre grupos distintos.', abierta=FALSE),
    list(q='¿Qué años cubre la herramienta?', a='Cubre 2016 a 2019. Educación básica tiene los cuatro años; educación media va de 2017 a 2019, porque la fuente no publica 2016 para media. El año vigente —el que manda en la vista por defecto— es el más reciente disponible: 2019.', abierta=FALSE),
    list(q='¿Qué pasa con los establecimientos sin categoría?', a='Algunos establecimientos educacionales no reciben categoría en un año dado, por baja matrícula o por falta de información. No se fuerzan dentro de las cuatro categorías: aparecen en una sección aparte, “Sin categoría vigente”, para no distorsionar las proporciones.', abierta=FALSE),
    list(q='¿Necesito instalar algo para usarla?', a='No. Es un archivo que se abre en cualquier navegador y funciona sin conexión a internet. También está publicada en línea para consultarla directamente.', abierta=FALSE)
  ),

  # ---- 1.13 Prosa de los documentos de lectura ------------------------------
  prosa = list(
    doc_que = c(
      '<code class="inl">slep_categoria_desempeno</code> es una herramienta de análisis interno que permite <strong>comparar la Categoría de Desempeño de los establecimientos</strong> —la clasificación de la Agencia de Calidad en Alto, Medio, Medio-Bajo e Insuficiente— entre comunas, Servicios Locales, regiones y el nivel nacional, separando educación básica y media.',
      'El problema que resuelve es concreto: la categoría se publica por establecimiento, año y nivel, en planillas dispersas y con formatos que cambian de un año a otro. Responder algo tan simple como “¿cómo se distribuyen los establecimientos de mi comuna entre las cuatro categorías, y cómo evolucionó cada uno?” exige consolidar varios años de planillas, homologar etiquetas que cambiaron y recuperar el territorio de cada establecimiento educacional. Esta herramienta hace ese trabajo y entrega el resultado en un único archivo navegable.',
      'El producto final es un <strong>archivo HTML autónomo</strong> (<code class="inl">motor_categoria.html</code>): se abre en cualquier navegador, sin instalar nada, y permite explorar la distribución de categorías y la trayectoria de cada establecimiento. Está publicado para consulta en línea.'
    ),
    doc_pipeline = c(
      'Detrás del archivo navegable hay un <strong>pipeline en R</strong> de cuatro etapas, orquestado por un único script (<code class="inl">00_run_all.R</code>). Cada etapa lee el resultado de la anterior y escribe el suyo, de modo que el proceso completo es reproducible de principio a fin. El motor resultante es un HTML autocontenido que embebe <em>inline</em> React 18.3.1, ReactDOM 18.3.1, D3 v7 y pako (versionados en <code class="inl">10_utils/</code>); su cuerpo está pre-transpilado a <code class="inl">React.createElement</code> (runtime clásico), de modo que <strong>no tiene ninguna dependencia de red</strong>. En prosa, las etapas son:'
    ),
    gen_porque = c(
      'La Categoría de Desempeño se publica cada año en planillas separadas, con formatos que cambian y etiquetas que no siempre calzan entre un año y otro. Responder algo tan simple como <em>“¿cómo se reparten los establecimientos de mi comuna entre las categorías, y cómo cambió eso en el tiempo?”</em> normalmente exige horas de trabajo y conocimiento técnico.',
      'Esta herramienta hace ese trabajo una sola vez, con reglas claras, y entrega la respuesta lista para mirar. El objetivo es que la conversación sea sobre <strong>qué dicen los datos</strong>, no sobre cómo armarlos.'
    ),
    etapas_pipeline = '<h3>1 · Construir el mapa del territorio</h3><p>Se arman los catálogos que traducen un establecimiento (RBD) a su comuna, su SLEP y su región.</p><h3>2 · Leer y limpiar las planillas</h3><p>Se leen los 7 archivos por nombre de columna, se homologan las categorías, se unifican las marcas de “sin categoría” y se recupera el territorio de cada establecimiento educacional.</p><h3>3 · Contar por territorio</h3><p>En cada comuna, SLEP, región y a nivel país se cuentan los establecimientos por categoría, <strong>sin ponderar por matrícula</strong>.</p><h3>4 · Generar el motor navegable</h3><p>Los conteos se empaquetan dentro de un archivo HTML autónomo y se copian a <code class="inl">docs/index.html</code> para publicarlos.</p>'
  ),

  # ---- 1.14 Gobernanza ------------------------------------------------------
  gobernanza = "Datos públicos de la Agencia de Calidad",

  # ---- 1.15 Rótulos del diagrama técnico ------------------------------------
  rotulos = list(
    lbl_fuentes     = 'Fuentes de datos <span class="sub">20_insumos/</span>',
    lbl_auxiliares  = 'Tablas auxiliares <span class="sub">20_insumos/auxiliares/</span>',
    lbl_intermedios = 'Datos intermedios <span class="sub">40_salidas/intermedios/</span>',
    norm_titulo     = 'Normalizaciones de origen resueltas (datos crudos Agencia de Calidad)',
    exec = '<span class="cm"># Ejecución canónica del pipeline completo:</span><br><span class="fn">source</span>(<span class="str">"00_run_all.R"</span>); <span class="fn">run_all</span>()<br><br><span class="cm"># El paso 33 ya copia el producto a docs/index.html:</span><br><span class="cm"># solo resta git push para republicar en GitHub Pages.</span>'
  ),

  # ---- 1.16 Leyenda del diagrama técnico ------------------------------------
  leyenda = list(
    list(color="var(--ocean)", texto="Pipeline R"),
    list(color="var(--plum)",  texto="Auxiliares / Motor"),
    list(color="var(--sand)",  texto="Datos intermedios"),
    list(color="var(--amber)", texto="Decisión metodológica"),
    list(color="var(--olive)", texto="Normalización resuelta (A1–A4)")
  ),

  # ---- 1.17 Reglas de cálculo -----------------------------------------------
  reglas_calculo = list(
    list(titulo='Conteo de establecimientos',
         cuerpo='<pre>distribución(territorio) = n_EE por categoría / total de EE categorizados</pre><p>La distribución de un territorio nunca promedia porcentajes ni pondera por matrícula: cada establecimiento cuenta como uno.</p>'),
    list(titulo='Solo las cuatro categorías reales',
         cuerpo='<p>El conteo y los porcentajes consideran solo Insuficiente · Medio-Bajo · Medio · Alto. Los establecimientos <span class="inl">s/i</span> se cuentan aparte, en <span class="inl">categoria_sin_vigente.parquet</span>.</p>'),
    list(titulo='Básica y media separadas',
         cuerpo='<p>Los niveles nunca se combinan. Cada uno se cuenta por los años realmente disponibles: básica 2016–2019, media 2017–2019.</p>')
  ),

  # ---- 1.18 Pie por documento -----------------------------------------------
  pie_extra = list(
    arq_tec = "Normalizaciones A1–A4 documentadas en 50_documentacion/activa/decisiones/. Estado de dependencias de red vigente a esta versión: ninguna. La eliminación de Babel (reescritura de JSX a React.createElement, runtime clásico) fue ejecutada vía C3; el motor es 100% autocontenido, sin recursos de red. Ver 50_documentacion/activa/decisiones/20260618_decision_plan_c3_eliminar_babel.md. Portabilidad cross-OS: fin de línea normalizado a LF vía .gitattributes; el proyecto se clona y ejecuta igual en macOS y Windows. Ver 50_documentacion/activa/decisiones/20260619_decision_portabilidad_cross_os.md.",
    doc_tec = "",
    arq_gen = "¿Necesitas el detalle técnico? Abre arquitectura_slep_categoria_desempeno.html",
    doc_gen = ""
  ),

  # ---- 1.19 Textos de sección y hero-notes ----------------------------------
  textos = list(
    ref_intro        = 'El diagrama de arriba muestra <strong>cómo fluyen los datos</strong>. Las secciones siguientes documentan el proyecto al detalle, de modo que cualquier persona técnica (o una sesión de IA) pueda reconstruir el contexto completo sin material adicional.',
    dic_crudos_titulo= 'Datos crudos (xlsx por año y nivel)',
    dic_interm_titulo= 'Datos intermedios producidos',
    reglas_titulo    = 'Reglas de cálculo',
    anom_titulo      = 'Anomalías de origen A1–A4 (detalle)',
    anom_intro       = 'Particularidades de las planillas crudas que el pipeline resuelve de forma trazable <strong>antes</strong> de cualquier conteo. No son errores del proyecto.',
    doc_s2_intro     = 'El motor permite comparar la distribución de establecimientos por categoría entre distintas <strong>entidades</strong>:',
    doc_s2_cierre    = 'Para cualquier entidad se muestra la <strong>distribución por categoría</strong> del último año, el conteo de establecimientos y, para cada establecimiento educacional, su <strong>trayectoria histórica</strong> año a año. Todo dentro de un nivel fijo (básica o media).',
    doc_dec_intro    = 'Reglas que gobiernan todo conteo del proyecto. Cada una corrige una forma específica de leer mal los datos.',
    doc_s5_intro     = 'Todos los datos provienen de la <strong>Agencia de Calidad de la Educación</strong> y son <strong>públicos</strong>. Las planillas crudas traen particularidades de origen que el pipeline normaliza antes de cualquier conteo:',
    gen_hero         = 'Piensa en este proyecto como una <strong>pequeña fábrica de datos</strong>. Llegan materias primas —las planillas de Categoría de Desempeño—, pasan por una línea de producción que las limpia, las agrupa por territorio y las cuenta, y al final sale un <strong>producto terminado</strong>: una herramienta que cualquier persona puede abrir para ver cómo se distribuyen los establecimientos educacionales entre categorías.',
    gen_linea_titulo = 'La línea de producción',
    gen_guards_titulo= 'Las garantías de calidad de la fábrica',
    gen_guards_intro = 'Toda fábrica seria tiene reglas que nunca se saltan. Estas existen para que las comparaciones sean <strong>justas y honestas</strong>:',
    gen_frase_titulo = 'En una frase',
    gen_frase        = 'Una línea de producción que toma varios años de planillas de Categoría de Desempeño dispersas, las limpia, las agrupa por territorio contando establecimientos y las convierte en un <strong>tablero navegable</strong> para mirar cómo se clasifican los establecimientos educacionales de Costa Central.',
    doc_gen_hero          = 'Es una herramienta para <strong>ver cómo se distribuyen los establecimientos educacionales entre las cuatro categorías de desempeño</strong> —Alto, Medio, Medio-Bajo e Insuficiente— por comuna, por Servicio Local, por región, por establecimiento educacional o a nivel país.',
    doc_gen_porque_titulo = 'Por qué existe',
    doc_gen_hacer_titulo  = 'Qué puedes hacer con ella',
    doc_gen_hacer_intro   = 'Eliges <strong>qué quieres mirar</strong> y la herramienta te muestra cómo se reparten sus establecimientos educacionales entre categorías:',
    doc_gen_hacer_cierre  = 'Para lo que elijas, verás las <strong>cuatro categorías con su número de establecimientos educacionales</strong> y, para cada establecimiento, su <strong>trayectoria año a año</strong>.',
    doc_gen_fijarte_titulo= 'En qué fijarte al leerla',
    doc_gen_fijarte_intro = 'Cinco claves para interpretar la herramienta sin malentendidos:',
    doc_gen_datos_titulo  = 'De dónde vienen los datos',
    doc_gen_datos_cuerpo  = 'Todos los datos provienen de la <strong>Agencia de Calidad de la Educación</strong> y son <strong>públicos</strong>. La herramienta no contiene información de estudiantes individuales: trabaja con la categoría de cada establecimiento, que la propia Agencia difunde de forma nominal.',
    doc_gen_faq_titulo    = 'Preguntas frecuentes'
  )
)

# ---- Generación de los 4 HTML ---------------------------------------------
# verificar = TRUE: aborta si quedara algún residuo del ejemplo de fábrica.
# standalone = TRUE: embebe CSS, fuentes, logos e iconos; escribe los
# *_standalone.html offline y limpia los enlazados (§4.6.4). Requiere npm + red
# al generar (descarga lucide-static fijado); la suite resultante es 100% offline.
suitedoc::generar_suite(
  cfg,
  salida_dir  = here::here("50_documentacion", "suite"),
  copiar_tema = TRUE,
  verificar   = TRUE,
  standalone  = TRUE,
  verbose     = TRUE
)
