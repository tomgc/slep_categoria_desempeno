# Decisión: tinta del texto sobre los colores de categoría

**Fecha:** 2026-09-25
**Sesión:** 30 (resolución del titular a la duda Q-F11 del plan a1; ejecutada en el encargo a2)
**Tipo:** decisión de presentación y accesibilidad. No afecta ninguna cifra ni la paleta.
**Estado:** reemplazada en su excepción por 20260925_decision_paleta_categorias_v2.md

## Contexto

Las cabeceras de las cuatro columnas de la vista por territorio llevan texto blanco
(título, conteo de establecimientos y matrícula; las dos últimas con opacidad 0,92 y
0,82) sobre el color de su categoría. El plan de alineamiento de motores
(`50_documentacion/andamios/20260925_plan_alineamiento_motores.md`, ficha F11) midió
esos textos contra el mínimo de WCAG 2.1 AA para texto normal (4,5:1). Valores del
encargo a2 (M5), título / conteo / matrícula:

| Categoría | Relleno | Blanco con opacidad (antes) | `--ink` (sin opacidad) |
|---|---|---|---|
| Insuficiente | `mark-red` | 4,11 / 3,67 / 3,16 | 4,46 |
| Medio-Bajo | `coral` | 2,62 / 2,44 / 2,23 | 7,01 |
| Medio | `mark-blue` | 3,48 / 3,19 / 2,85 | 5,27 |
| Alto | `ocean` | 6,45 / 5,72 / 4,89 | 2,84 |

Ninguna tinta existente en el `:root` lleva la cabecera de Insuficiente a 4,5:1: el
blanco da 4,11 y `--ink`, la tinta más oscura, 4,46. Llegar a 4,5 exigiría un token de
texto nuevo (un hex nuevo) o cambiar el rojo de la categoría, es decir, enmendar
`20260612_decision_paleta_categorias.md`.

## Decisión

Opción **B** de la duda Q-F11 (resolución del titular, sesión 30 del chat,
2026-09-25): las cabeceras de **Insuficiente, Medio-Bajo y Medio** usan `--ink` como
tinta del texto, sin opacidad en sus líneas secundarias (la jerarquía entre las tres
líneas queda por tamaño y peso). **Alto** conserva el texto blanco (6,45 / 5,72 / 4,89),
donde `--ink` daría 2,84.

Implementación: clase `is-tinta` en `CatColumn` (`30_procesamiento/33_app.jsx`,
constante `CAT_CABECERA_TINTA`) y reglas `.cat-col-head.is-tinta` en
`30_procesamiento/33_motor_template.html`. Medido tras el cambio (a2, T2.1):
Insuficiente 4,46 / 4,46 / 4,46; Medio-Bajo 7,01 / 7,01 / 7,01; Medio 5,27 / 5,27 /
5,27; Alto sin cambio.

## Excepción escrita

**La cabecera de Insuficiente queda en 4,46:1, bajo el mínimo de 4,5:1**, porque
ninguna tinta existente lo alcanza y crear tokens de texto por categoría enmendaría
la paleta. Es la mejor tinta disponible y mejora el valor anterior (3,16–4,11).

## Precisión a la decisión de paleta

`20260612_decision_paleta_categorias.md` afirma "Contraste AA" para los cuatro colores
sobre el fondo crema. Esa afirmación vale para los colores **como relleno** sobre crema
(componente gráfico, criterio de 3:1), y ni siquiera allí para todos: Medio-Bajo da
2,43:1 contra crema y Medio 3,24:1. No vale para los colores **como fondo de texto**,
que es lo que esta decisión regula. Ese archivo no se edita; esta decisión lo precisa.

## Superficies que siguen bajo 4,5:1 y por qué quedan así

Por resolución del titular (Q-F11, opción B), no se tocan:

| Superficie | Medido (a2, M5) | Por qué queda |
|---|---|---|
| % máximo de cada fila del comparador (`--ocean` en negrita sobre el tinte de su categoría) | 2,07 a 3,51 (4 celdas en la medición) | El color marca a la columna líder; quitarlo cambia la codificación visual del comparador. |
| Delta negativo de la matrícula en la ficha del establecimiento (`#EE2D49`) | 3,97 | El rojo codifica la dirección; el signo "−" también la lleva. |
| ✕ de un chip del comparador al pasar el cursor (blanco sobre `#EE2D49`) | 4,11 | Estado transitorio de cursor sobre un glifo; como componente gráfico supera 3:1. |

## Alternativas consideradas

- **A. Tokens de texto por categoría** (hex nuevos, más oscuros, como los tokens
  `-txt` de `slep_idps`). Descartada por ahora: enmienda la paleta y agrega colores.
- **C. Dejar las cabeceras como estaban.** Descartada: Medio-Bajo quedaba en 2,23:1.

## Implicancia

Si en el futuro se decide la opción A, esta excepción se retira y la tinta de las
cabeceras pasa a los tokens nuevos. Cambiar un color de categoría en
`33_generar_html.R` obliga a volver a medir esta tabla.
