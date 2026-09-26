# Decisión: segunda señal en la trayectoria (altura según la categoría)

**Fecha:** 2026-09-26
**Sesión:** 32 (aprobación del titular de la opción B; ejecutada en el encargo a14)
**Tipo:** decisión de diseño y accesibilidad. Cambia la forma de las marcas; no cambia ningún color ni ninguna cifra.
**Estado:** vigente

## Contexto

La trayectoria de cada establecimiento muestra una marca por año, y la categoría de
cada año se distinguía solo por el color de la marca. WCAG 2.1, criterio 1.4.1 (nivel A),
pide que ninguna información dependa solo del color. En escala de grises, las marcas de
Insuficiente y Medio-Bajo, y las de Medio-Bajo y Medio, casi no se distinguen. Lo mismo
les ocurre a las personas con daltonismo rojo-verde y a quien imprime en blanco y negro.
La información existía en texto (título al pasar el cursor y detalle al abrir la fila),
pero no en la lista, que es donde se recorren cientos de establecimientos de una vez.
Pendiente #7 del traspaso v31.

## Alternativas consideradas

| Opción | Qué | Por qué no / por qué sí |
|---|---|---|
| A | Sigla (I, MB, M, A) dentro de la marca, de 22 px | Texto de 9 px, al límite de lo legible; la «A» de Alto se puede confundir |
| **B** | **Altura de la marca según la categoría** | **Elegida.** La categoría es ordinal y la altura también: la segunda señal lleva el mismo orden que el dato, y la tendencia se ve sin leer nada |
| C | Sigla en texto bajo la marca | La más legible, pero agrega unos 18 px a cada fila de la lista |
| Cerrar #7 | Declarar el detalle en texto como alternativa | No resuelve la lectura de la lista |

## Decisión

La marca de cada año es una barra de 16 px de ancho que se apoya en la base de un
contenedor de altura fija. Su altura sigue el orden semántico de las categorías
(`CatData.CATEGORIAS`, de Insuficiente a Alto):

| Categoría | Altura |
|---|---|
| Insuficiente | 7 px |
| Medio-Bajo | 13 px |
| Medio | 19 px |
| Alto | 25 px |
| Sin categoría o sin medición | 7 px, con relleno crema y borde punteado (sin cambio de estilo) |

La altura se calcula en `33_app.jsx` con dos constantes nombradas
(`TRAJ_ALTURA_BASE = 7`, `TRAJ_ALTURA_PASO = 6`) sobre la posición de la categoría en
`CatData.CATEGORIAS`. La leyenda de la trayectoria usa las mismas alturas. El año
vigente conserva su anillo. Los colores (`CAT_COLORS`, paleta v2) no cambian.

## Consecuencias

- Sin color, la trayectoria se lee por la altura: Insuficiente abajo, Alto arriba.
- «Sin categoría» comparte la altura de Insuficiente; los distingue el relleno crema y
  el borde punteado.
- Cada fila de la lista gana unos 7 px de alto (el contenedor pasa de 18 a 25 px).
- El payload y las cifras no cambian.
