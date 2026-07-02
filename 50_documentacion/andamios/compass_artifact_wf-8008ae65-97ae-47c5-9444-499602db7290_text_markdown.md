# Categorías de Desempeño del SAC (Chile): Caracterización técnica para un proyecto de visualización de datos

## TL;DR
- La Categoría de Desempeño es la clasificación oficial (Alto, Medio, Medio-Bajo, Insuficiente) que la Agencia de Calidad de la Educación asigna anualmente a cada establecimiento reconocido por el Estado, mediante una evaluación integral que pondera **67% Estándares/Niveles de Aprendizaje** y **33% repartido en partes iguales** entre Puntaje Simce, Tendencia Simce e Indicadores de Desarrollo Personal y Social (IDPS), corrigiendo luego por el contexto de los estudiantes y calculándose **por separado** para Básica, Media HC y Media TP.
- Para un proyecto de visualización, las claves metodológicas son: **nunca mezclar niveles educativos**, segmentar por GSE, ponderar por número de estudiantes evaluados, y **marcar explícitamente los vacíos temporales** (sin ordenación 2020-2021 por pandemia; Simce 2019 y 2022 no usados para ordenación).
- Las bases de datos descargables a nivel RBD están en el portal de Bases de Datos de la Agencia (informacionestadistica.agenciaeducacion.cl); el último proceso aplicado con consecuencias fue 2018/2019, y la próxima Categoría de Desempeño en régimen se calculará con Simce 2023-2024-2025 (previsiblemente reactivándose en 2026).

## Key Findings
1. **Definición.** La Categoría de Desempeño ordena a los establecimientos en cuatro niveles según si sus resultados "sobresalen" (Alto), son "similares" (Medio), están "por debajo" (Medio-Bajo) o "muy por debajo" (Insuficiente) de lo esperado, **considerando siempre el contexto social** de sus estudiantes.
2. **Base legal.** Nace de la Ley 20.529 de 2011 (SAC); la ordenación está mandatada en los artículos 17-31. La metodología vigente fue aprobada por **Decreto Supremo N°127 de 2023 del MINEDUC** (publicado el 11 de enero de 2024; BCN idNorma 1200020), reemplazando al Decreto 17 de 2014.
3. **Ponderación.** 67% Niveles de Aprendizaje + 33% repartido en partes iguales entre el resto de indicadores aplicables. No hay porcentajes fijos individuales distintos por nivel: lo que cambia es el conjunto de indicadores entre los que se divide el 33% (en TP se incluye Titulación Técnico-Profesional).
4. **Consecuencia más severa.** Un establecimiento que permanece en Insuficiente por cuatro años consecutivos (considerando solo el cumplimiento de estándares de aprendizaje) pierde de pleno derecho el reconocimiento oficial (art. 31, Ley 20.529).
5. **Vacíos de datos.** No hubo ordenación en 2020 ni 2021 (pandemia); el Simce 2019 no tuvo consecuencias y el Simce 2022 no se usó para ordenar.

## Details

### 1. Definición y naturaleza
La **Categoría de Desempeño** de los establecimientos educacionales reconocidos por el Estado es uno de los componentes del Sistema de Aseguramiento de la Calidad de la Educación (SAC), cuyo propósito es dar cumplimiento al deber del Estado de asegurar el derecho de todos los estudiantes a recibir una educación de calidad. Es el resultado de una **evaluación integral** que clasifica a los establecimientos en cuatro niveles. Sus objetivos oficiales son: (a) evaluar el aprendizaje de los estudiantes y el logro de los Otros Indicadores de Calidad; (b) informar a la comunidad escolar sobre la evaluación de los establecimientos; y (c) identificar necesidades de apoyo, en especial en establecimientos Medio-Bajo e Insuficiente.

**Definición de las cuatro categorías** (Agencia de Calidad / Ayuda MINEDUC):
- **Alto:** establecimientos cuyos estudiantes obtienen resultados que *sobresalen respecto de lo esperado*, considerando siempre el contexto social.
- **Medio:** resultados *similares a lo esperado*, considerando el contexto social.
- **Medio-Bajo:** resultados *por debajo de lo esperado*, considerando el contexto social.
- **Insuficiente:** resultados *muy por debajo de lo esperado*, considerando el contexto social.

**Diferencia con otros instrumentos del SAC.** La Categoría de Desempeño es un resultado **agregado y final** que combina varios insumos; no debe confundirse con sus componentes:
- **Estándares de Aprendizaje:** referentes que describen lo que los estudiantes saben y pueden hacer en las pruebas Simce, clasificándolos en niveles Adecuado, Elemental e Insuficiente. Son el *insumo más ponderado* de la Categoría.
- **IDPS (Indicadores de Desarrollo Personal y Social, denominados "Otros Indicadores de Calidad" en la ley):** índices que amplían la concepción de calidad más allá de lo cognitivo — Autoestima académica y motivación escolar; Clima de convivencia escolar; Participación y formación ciudadana; Hábitos de vida saludable; Asistencia escolar; Retención escolar; Equidad de género; y Titulación técnico-profesional. Definidos por el Decreto 381/2013 del MINEDUC.
- **Simce:** la prueba estandarizada en sí; entrega puntaje y tendencia, que son insumos de la Categoría.
- **Estándares Indicativos de Desempeño:** referentes de procesos de gestión escolar (Liderazgo, Gestión pedagógica, Formación y convivencia, Gestión de recursos), establecidos por DS 73/2014 y actualizados por DS 27/2020, que orientan las visitas evaluativas; son distintos de la ordenación.

**Niveles educativos y cálculo separado.** Por mandato legal (art. 18, modificado por publicación del 25/04/2019), los establecimientos que imparten educación básica y media se **ordenan por cada nivel en forma independiente**: Educación Básica, Educación Media Humanístico-Científica (HC) y Educación Media Técnico-Profesional (TP). Se calculan por separado porque evalúan grados distintos (4° y 8° básico vs. II medio), usan conjuntos de indicadores distintos (la Titulación TP solo aplica a la EMTP) y responden a currículos y trayectorias diferentes, lo que invalidaría una comparación conjunta.

### 2. Antecedentes y fundamentos de creación
La **Ley 20.529** (publicada el 27 de agosto de 2011) creó el Sistema Nacional de Aseguramiento de la Calidad de la Educación Parvularia, Básica y Media y su Fiscalización (SAC). El SAC se compone de cuatro organismos articulados:
- **MINEDUC:** órgano rector; propone políticas, estándares y presta apoyo técnico-pedagógico (Sistema Nacional de Apoyos).
- **Agencia de Calidad de la Educación:** evalúa logros de aprendizaje y OIC, **ordena** a los establecimientos y realiza visitas evaluativas y de orientación.
- **Superintendencia de Educación:** fiscaliza la normativa y el uso de recursos, atiende denuncias y reclamos.
- **Consejo Nacional de Educación (CNED):** aprueba los estándares e **informa la propuesta de Metodología de Ordenación** que formula la Agencia, así como sus ajustes y modificaciones.

**Fundamento técnico-político.** La Categoría de Desempeño materializa el principio de "mirada integral" de la calidad: busca superar la lógica de rankear escuelas solo por puntaje Simce, incorporando los IDPS (desarrollo personal y social) y ajustando por contexto socioeconómico, con el fin de responsabilizar (accountability) y orientar el apoyo del Estado. El problema que busca resolver es identificar dónde concentrar el apoyo (visitas, recursos) y entregar información comparable y "justa" a las comunidades.

**Evolución histórica.** Marcha blanca desde 2014-2015. Entró en régimen en **2016 para educación básica** y **2017 para educación media**, entregándose anualmente. En básica, el número de establecimientos Insuficiente cayó de **633 escuelas en 2016 (154.000 estudiantes) a 345 en 2019 (86.000 estudiantes)**; en media, de **338 en 2017 (95.000 estudiantes) a 169 en 2019 (39.000 estudiantes)** (Agencia de Calidad). El Simce 2019 (estallido social) se aplicó sin condiciones óptimas, por lo que se mantuvo la última categoría vigente sin consecuencias. En **2020 y 2021 (pandemia) no se aplicó Simce y se suspendió la ordenación** (Acta N°405 del Consejo de la Agencia; Contraloría). El Simce se retomó en **2022** (DS 48/2021), pero sus resultados **no se usaron para ordenar**. Según la Agencia, el Simce 2023 es el primer resultado válido, el 2024 el segundo y el 2025 el tercero para la próxima Categoría de Desempeño, que se calcularía con esas tres mediciones consecutivas.

### 3. Metodología de cálculo
El proceso, descrito en el "Informe Técnico Categorías de Desempeño" de la Agencia (que utiliza los datos considerados en la Categoría de Desempeño publicada el año 2017) y en la Guía oficial, tiene tres etapas:

**Etapa 1 — Índice de Resultados (sin corregir).** Para cada establecimiento se construye un índice (escala 1 a 100) que pondera:
- **67% — Estándares/Niveles de Aprendizaje:** distribución de los estudiantes en niveles Adecuado/Elemental/Insuficiente en las pruebas Simce de las últimas tres evaluaciones (4° y 8° básico) o las que correspondan al nivel.
- **33% — resto de indicadores, repartido en partes iguales** entre los aplicables: Puntaje Simce, Tendencia Simce (medida de progreso) e IDPS (Autoestima académica y motivación; Clima de convivencia; Participación y formación ciudadana; Hábitos de vida saludable; Asistencia; Retención; Equidad de género; y Titulación TP en EMTP). El Informe Técnico indica que el Puntaje Simce representa aproximadamente 3,3% del índice final, consistente con un reparto del 33% entre ~10 componentes.

**Diferencias por nivel.** La estructura mayor 67/33 es idéntica en Básica, Media HC y Media TP. Lo que cambia es el número de indicadores entre los que se divide el 33%:
- **Básica:** indicadores aplicables sin Titulación TP.
- **Media HC:** el 33% se reparte entre 9 de los 10 indicadores (no aplica Titulación TP).
- **Media TP:** el 33% se reparte entre los 10 indicadores, incluyendo **Titulación Técnico-Profesional** (≈3,3% cada uno).
- Indicadores que no aplican (p. ej. Equidad de género en colegios no mixtos) se excluyen y el 33% se redistribuye entre los restantes.

**Etapa 2 — Ajuste por contexto (Características de los Estudiantes).** El índice se corrige (mediante regresión) según variables que no dependen de la gestión del establecimiento. Según la Revista de Educación de la Agencia, estas son: **nivel de vulnerabilidad, escolaridad de la madre, ruralidad o aislamiento, entrada de alumnos con buen o mal desempeño académico, estudiantes con ascendencia indígena, con necesidades educativas permanentes y tasa de delitos de violencia intrafamiliar**. Se entrega mayor puntaje a establecimientos con características menos favorables, para una comparación justa. Esto incorpora el Grupo Socioeconómico (GSE) de manera implícita en la corrección.

**Etapa 3 — Clasificación.** Con el índice corregido final y los puntos de corte definidos en la metodología, se clasifica en una de las cuatro categorías. Se aplican además filtros que pueden cambiar de categoría a un pequeño porcentaje de establecimientos en casos extremos.

**Valor agregado / progreso.** La Tendencia Simce mide si los resultados de Lectura y Matemática aumentan, disminuyen o se mantienen en las últimas mediciones, funcionando como medida de progreso dentro del 33%.

**Mínimos, exclusiones y establecimientos pequeños/rurales.** La Ley 20.529 (art. 18) establece que cuando un establecimiento tiene un número insuficiente de alumnos que rinden las mediciones (que no permite resultados válidos), el MINEDUC define una metodología pertinente considerando **un mayor número de mediciones consecutivas**. Reglas técnicas mínimas para la Tendencia Simce: al menos 2 alumnos por año y suma ≥6 entre años. La regla general de agregación: **3 mediciones consecutivas válidas** si las pruebas son anuales, **2** si se aplican cada dos años o más. Los establecimientos nuevos no son ordenados, pero se consideran provisoriamente Medio-Bajo. Según Libertad y Desarrollo (María Paz Arzola, diciembre 2018): *"el porcentaje de la matrícula en escuelas pequeñas sin categoría de desempeño es muy bajo (3% en enseñanza básica y 1% en enseñanza media), se trata de 60 mil estudiantes y más de 2.300 establecimientos, en su mayoría rurales, que hoy están fuera del Sistema de Aseguramiento de la Calidad."*

### 4. Marco normativo y técnico
- **Ley 20.529 (2011):** art. 17 (categorías y mandato de ordenación), art. 18 (anualidad; tres/dos mediciones consecutivas válidas; ordenación por nivel independiente; establecimientos con matrícula insuficiente), arts. 22-27 (efectos: frecuencia de visitas evaluativas), arts. 28-31 (medidas especiales para Desempeño Insuficiente y pérdida de reconocimiento oficial). Texto en BCN/LeyChile, idNorma 1028635.
- **Decreto Supremo N°17 de 2014 (MINEDUC):** primera metodología de ordenación (BCN idNorma 1060182).
- **Decreto Supremo N°127 de 2023 (MINEDUC):** metodología vigente, publicado el 11 de enero de 2024 (BCN idNorma 1200020).
- **Decreto 381/2013:** define los Otros Indicadores de Calidad (IDPS).
- **Decretos 73/2014 y 27/2020:** Estándares Indicativos de Desempeño.
- El CNED informa la propuesta de metodología; debe aprobarse por decreto supremo del MINEDUC, previo informe del CNED, y actualizarse en un plazo no inferior a 4 ni superior a 8 años.
- **Documento técnico de referencia:** "Informe Técnico Categorías de Desempeño" de la Agencia (archivos.agenciaeducacion.cl).

### 5. Usos y consecuencias
- **Orientación del trabajo del SAC:** la categoría define la frecuencia de visitas evaluativas — Insuficiente al menos cada 2 años; Medio-Bajo al menos cada 4; Medio con frecuencia menor que ésta; Alto solo a solicitud del sostenedor — y la focalización del apoyo del MINEDUC, que debe priorizar a las categorías Medio-Bajo e Insuficiente, sectores con menor disponibilidad de apoyo técnico y establecimientos públicos y gratuitos.
- **Consecuencia severa (art. 31):** si tras cuatro años (desde la comunicación del art. 28) un establecimiento se mantiene en Insuficiente, considerando como único factor el cumplimiento de los estándares de aprendizaje, la Agencia certifica la circunstancia y el establecimiento **pierde de pleno derecho el reconocimiento oficial** al término del año escolar. Según La Tercera (12 dic. 2018), la Agencia identificó **396 colegios** cuyos dos niveles de enseñanza estaban en Insuficiente desde 2016, y el entonces secretario ejecutivo Carlos Henríquez advirtió que de no mejorar "se les quitará el reconocimiento oficial del Estado, por lo que no podrán funcionar en 2021". Esto ha generado fuerte debate y proyectos de ley (p. ej. moción de senadores Latorre, Provoste, Montes y Quintana) para frenar los cierres.
- **Comunicación:** la Agencia informa anualmente a sostenedores y establecimientos, e informa a padres y apoderados y al Consejo Escolar (art. 28); los resultados se publican y consultan en agenciaorienta.cl y en el buscador "Localiza tu colegio" (localizar.agenciaeducacion.cl).
- **Relación con PME y SEP:** los resultados de la Categoría deben incorporarse al Plan de Mejoramiento Educativo (PME) y al Plan Estratégico de calidad; existe vínculo con la Subvención Escolar Preferencial (la clasificación SEP histórica de Autónomos / Emergentes / En Recuperación se entiende equivalente a la ordenación del art. 17). La ausencia de puntaje (establecimientos sin categoría) puede impedir el cumplimiento de requisitos para acceder a recursos SEP y a la Subvención de Excelencia Académica.

### 6. Fortalezas, alcances y limitaciones
**Fortalezas declaradas:** mirada integral (incorpora IDPS más allá del puntaje Simce); ajuste por contexto socioeconómico para una comparación más justa; foco en identificar y apoyar a los establecimientos con mayores necesidades; articulación del ciclo de mejora del SAC (diagnóstico → PME → visitas → apoyo).

**Críticas y limitaciones:** dependencia fuerte del Simce (67% del índice); riesgo de estigmatización de comunidades en categorías bajas; la consecuencia de cierre por Insuficiente reiterado es objeto de fuerte debate académico (p. ej. Liderazgo Educativo UDP) y legislativo; tensión con la lógica de rankings y accountability; exclusión de establecimientos pequeños/rurales del sistema; cuestionamientos a la validez y confiabilidad, especialmente en contextos de baja matrícula; y la advertencia de que el retiro de alumnos de escuelas mal evaluadas puede sacarlas del registro de calidad sin saber si mejoran o empeoran.

### 7. Datos y bases de datos disponibles
- **Portal de Bases de Datos de la Agencia:** informacionestadistica.agenciaeducacion.cl — datasets descargables a nivel de establecimiento (RBD) con resultados Simce, IDPS y categorías.
- **Resultados para SLEP y sostenedores:** resultadossimce.agenciaeducacion.cl/login (acceso con credenciales) — resultados de 4°, 8° básico y II medio de IDPS y pruebas Simce a nivel nacional, regional y por establecimiento, con variación anual y comparación por GSE y dependencia.
- **Buscador público:** agenciaorienta.cl y "Localiza tu colegio" (localizar.agenciaeducacion.cl) — consulta por nombre/RBD, con categoría, niveles impartidos, tipo de educación (científico-humanista, artístico, técnico-profesional, escuela especial), GSE y SLEP.
- **Desagregación:** por RBD, comuna, región, dependencia, GSE, nivel educativo (Básica / Media HC / Media TP) y trayectoria entre años.
- **Cobertura temporal:** categorías desde 2016 (básica) y 2017 (media), hasta 2018/2019; vacío 2020-2021. Próxima entrega con datos 2023-2025.
- **Condiciones de uso:** los resultados tienen condiciones de uso que restringen ciertos fines (no pueden usarse para calificar ni decidir la promoción de estudiantes); conviene revisar las reglas de uso del portal y los resguardos de no identificación al publicar a nivel de establecimiento.

### 8. Aspectos relevantes para visualización de datos
- **Distribución típica nacional (referencia, proceso 2018 con datos a 2017):** en **básica**, ~54% Medio (3.086 establecimientos), ~15% Alto (844) y **430 establecimientos en Insuficiente** (186 menos que en 2017, cuando eran 616). En **media**: 52,9% Medio (1.490), 16,3% Alto (459), 22,7% Medio-Bajo (640) y 8,1% Insuficiente (229). En el proceso 2019 (datos a 2018), los Insuficiente bajaron a 345 en básica y 169 en media.
- **Representación oficial:** la Agencia reporta por categoría, nivel educativo, GSE, región y dependencia, con análisis de trayectoria (cuántos suben, bajan o se mantienen entre años).
- **Buenas prácticas:** no mezclar niveles educativos; segmentar/comparar por GSE; ponderar por número de estudiantes evaluados o matrícula; marcar visualmente los vacíos temporales (2019 sin consecuencias; 2020-2021 sin ordenación; 2022 no usado); diferenciar datos preliminares de definitivos; y explicitar que la categoría **ya está ajustada por contexto** (evitar doble corrección al cruzarla con GSE).
- **Advertencia:** la categoría es un resultado relativo a "lo esperado" según contexto, no una medida absoluta de puntaje; representar puntaje Simce y categoría como si fueran lo mismo es un error metodológico.

## Recommendations
1. **Estructura de datos:** modelar el dataset con clave **RBD + nivel educativo + año de proceso**, manteniendo Básica / Media HC / Media TP como series separadas y nunca agregadas.
2. **Segmentación obligatoria:** incluir filtros por GSE, dependencia, comuna/región y SLEP; para el SLEP Costa Central, filtrar por las comunas correspondientes de la región de Valparaíso y comparar siempre dentro del mismo nivel educativo y, cuando sea posible, dentro del mismo GSE.
3. **Marcar vacíos:** representar explícitamente 2019 (sin consecuencias), 2020-2021 (sin ordenación) y 2022 (no usado) como discontinuidades, no como ceros ni como datos faltantes ambiguos.
4. **Ponderación de agregados:** al agregar a nivel comunal/regional/SLEP, ponderar por matrícula o número de estudiantes evaluados, no por simple conteo de establecimientos; reportar aparte los establecimientos "sin categoría".
5. **Documentación metodológica:** descargar el "Informe Técnico Categorías de Desempeño" (archivos.agenciaeducacion.cl) y el Decreto 127/2023 (BCN idNorma 1200020) como diccionario metodológico; citar fuente y año de proceso en cada visualización.
6. **Benchmarks que cambiarían el enfoque:** cuando se publique la próxima Categoría de Desempeño (datos 2023-2025), actualizar series y **verificar cambios metodológicos del Decreto 127/2023 frente al Decreto 17/2014** (puntos de corte, indicadores, variables de ajuste), ya que podrían romper la comparabilidad con la serie 2016-2019.

## Caveats
- Las cifras de distribución nacional citadas corresponden a los procesos 2018 (datos a 2017) y 2019 (datos a 2018), las últimas disponibles con consecuencias; no reflejan la situación pospandemia.
- La metodología no asigna porcentajes nominales fijos a cada componente del 33%; opera por reparto proporcional, por lo que los pesos individuales (≈3,3% por componente) son aproximados.
- No se identificó un umbral numérico único de exclusión por matrícula en la metodología de ordenación (la regla legal es "mayor número de mediciones consecutivas"); el umbral de "20 alumnos" corresponde al contexto SEP/Simce, no a la ordenación.
- La fecha exacta del próximo proceso de ordenación no está publicada oficialmente; "2026" es una inferencia basada en la regla de tres mediciones válidas consecutivas (Simce 2023-2024-2025) y el calendario de entrega de resultados.
- El "Informe Técnico Categorías de Desempeño" disponible públicamente se basa en datos del proceso 2017; conviene contrastar sus cifras con la metodología del Decreto 127/2023 una vez que la Agencia publique documentación técnica actualizada.