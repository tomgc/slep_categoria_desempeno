# Motor de comparación interactivo de la Categoría de Desempeño de los establecimientos educacionales del país

> Versión elegida — Tipo 1 (Snippet): [PENDIENTE: a definir por editor]
> Versión elegida — Tipo 2 (Síntesis): [PENDIENTE: a definir por editor]
> Versión elegida — Tipo 3 (Reseña extensa): [PENDIENTE: a definir por editor]

---

## Tipo 1 — Snippet

**Variante A · ángulo problema**
La Categoría de Desempeño resume en una sola clasificación el estado de cada establecimiento, pero comparar cómo se distribuye entre comunas, regiones o el país exige reunir planillas de varios años. Construimos un motor interactivo que lo resuelve en una sola vista.

**Variante B · ángulo producto**
Construimos un motor interactivo que compara la Categoría de Desempeño que la Agencia de Calidad de la Educación asigna a los establecimientos educacionales del país, mostrando su distribución por comuna, Servicio Local, región y nivel nacional, y la trayectoria de cada establecimiento en el tiempo.

**Variante C · ángulo aporte institucional**
Reunimos en una sola herramienta navegable la Categoría de Desempeño de los establecimientos de todo el país: integramos varios años de clasificaciones de la Agencia de Calidad de la Educación para comparar territorios y seguir la evolución de cada establecimiento.

**Recomendación: Variante B** (nombra la fuente, el alcance nacional y las dos lecturas que ofrece —distribución y trayectoria— de un vistazo; la A enfatiza el problema y la C, el aporte).

---

## Tipo 2 — Síntesis

**Variante A · enfoque en el producto**
Desarrollamos un motor de comparación interactivo de la Categoría de Desempeño, la clasificación que la Agencia de Calidad de la Educación asigna a cada establecimiento educacional considerando sus resultados y su contexto. La herramienta organiza esa información para todo el país y permite recorrerla por comuna, Servicio Local de Educación, región y nivel nacional, distinguiendo la educación básica de la media.

Para cada territorio, el motor muestra cómo se distribuyen los establecimientos entre las distintas categorías, y para cada establecimiento, su trayectoria a lo largo de los años disponibles. Producido en el Área de Monitoreo y Seguimiento de Procesos y Resultados Educativos, reemplaza la consolidación manual de planillas dispersas por una consulta directa y reproducible.

**Variante B · enfoque en el aporte y el alcance**
La Categoría de Desempeño es una de las clasificaciones más sintéticas del sistema escolar, pero se publica en planillas anuales de formato cambiante que dificultan su lectura comparada. Construimos un motor interactivo que integra varios años de esas clasificaciones y las vuelve navegables para todo el país, desde el nivel nacional hasta cada comuna y establecimiento.

Su aporte es ofrecer, en una sola herramienta, dos lecturas complementarias: la distribución de los establecimientos por categoría en cada territorio y la evolución de cada establecimiento en el tiempo. Como la Categoría de Desempeño ya incorpora el contexto socioeconómico en su construcción, el motor presenta las clasificaciones tal como las publica la Agencia de Calidad de la Educación, sin segmentaciones adicionales.

**Recomendación: Variante B** (cubre objetivo, aporte y una decisión de diseño relevante —no añadir segmentación socioeconómica—; la A es algo más descriptiva del recorrido del producto).

---

## Tipo 3 — Reseña extensa

**Variante A · recorrido producto → fuentes → flujo**

En el Área de Monitoreo y Seguimiento de Procesos y Resultados Educativos del SLEP Costa Central desarrollamos un motor de comparación interactivo de la Categoría de Desempeño de los establecimientos educacionales del país. La Categoría de Desempeño es la clasificación que la Agencia de Calidad de la Educación asigna a cada establecimiento —en categorías que van desde el desempeño Alto hasta el Insuficiente— a partir de un conjunto integral de indicadores que considera tanto resultados como contexto.

El motor ordena esa clasificación para todo el país y la hace navegable. Permite explorar el panorama desde el nivel nacional hacia la región, el Servicio Local de Educación, la comuna y el establecimiento, manteniendo separadas la educación básica y la media, que se evalúan de forma independiente.

Para cada nivel territorial, el producto ofrece la distribución de los establecimientos entre las categorías de desempeño, es decir, cuántos se ubican en cada una; y para cada establecimiento, su trayectoria a lo largo de los años disponibles. De este modo, una misma herramienta sirve tanto a una mirada de conjunto sobre un territorio como al seguimiento de la evolución de un establecimiento en particular.

La fuente de información es la propia Categoría de Desempeño que publica la Agencia de Calidad de la Educación, un dato público referido al establecimiento —no a estudiantes— para distintos años y niveles de enseñanza. A ella sumamos catálogos territoriales que permiten ubicar cada establecimiento en su comuna, Servicio Local y región, y así construir las agrupaciones.

El flujo de procesamiento, a nivel conceptual, integra las clasificaciones de los distintos años homologando los formatos y las etiquetas de categoría, cuenta los establecimientos por categoría en cada nivel territorial —sin ponderar por matrícula, ya que se trata de una clasificación cualitativa por establecimiento— y empaqueta esos resultados en una aplicación web autocontenida, publicada de forma abierta. Al trabajar exclusivamente con datos públicos agregados por establecimiento, el proyecto no involucra información personal.

**Variante B · recorrido aporte institucional → gobernanza → flujo**

Este proyecto nace de una dificultad práctica: la Categoría de Desempeño, pese a ser una de las clasificaciones más relevantes del sistema escolar, se publica en planillas anuales dispersas y de formato variable, lo que vuelve trabajoso compararla entre territorios o seguirla en el tiempo. Desde el Área de Monitoreo y Seguimiento de Procesos y Resultados Educativos construimos un motor interactivo que resuelve esa fragmentación para todo el país.

El aporte del proyecto es transformar un dato disperso en una herramienta de consulta inmediata. Por una parte, ofrece la distribución de los establecimientos por categoría en cada comuna, Servicio Local, región y a nivel nacional; por otra, permite seguir la trayectoria de cada establecimiento a lo largo de los años. Todo ello queda disponible en una aplicación reproducible, que sustituye el trabajo manual de consolidación.

En materia de gobernanza, el proyecto opera enteramente con información pública. La Categoría de Desempeño es un dato que la Agencia de Calidad de la Educación difunde por establecimiento y que no contiene información de estudiantes, de modo que su tratamiento y publicación abierta no comprometen datos personales. Una definición de diseño relevante es que el motor no agrega una segmentación socioeconómica propia: la Categoría de Desempeño ya integra el contexto en su construcción, por lo que la presentamos tal como la publica la Agencia.

En cuanto a las fuentes y su procesamiento conceptual, el motor combina las planillas de Categoría de Desempeño de los distintos años con catálogos territoriales que ubican a cada establecimiento en su comuna, Servicio Local y región. El procesamiento homologa formatos y etiquetas, unifica las marcas de los establecimientos sin clasificación y consolida los conteos por categoría en cada nivel territorial.

Finalmente, esos resultados se empaquetan en una aplicación web autocontenida que se publica de forma abierta, de manera que la consulta es directa y no requiere infraestructura adicional. El proceso es reproducible de extremo a extremo, lo que asegura que cada actualización conserve la trazabilidad y la consistencia de las cifras presentadas.

**Recomendación: Variante B** (explicita el aporte, la naturaleza pública del dato y la decisión de no segmentar por contexto socioeconómico, además del flujo; la A ofrece un recorrido más detallado del producto y de la noción de Categoría de Desempeño).
