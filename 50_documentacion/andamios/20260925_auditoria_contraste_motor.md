# Auditoría de contraste figura-fondo del motor de Categoría y propuesta de corrección

- **Fecha:** 2026-09-25 (sesión 30)
- **Motor auditado:** `40_salidas/motor_categoria.html`, md5 `91570b620f1de44ea84ca7c7ae33f8bc` (build del encargo a2, aún no desplegado).
- **Estado:** propuesta. No se ha modificado ningún archivo del motor; la implementación espera la aprobación del titular.

## 1. Método

- **Render real:** Chromium sin interfaz, 1280 × 900, transiciones desactivadas (una primera corrida con transiciones activas midió colores intermedios y se descartó).
- **19 estados recorridos:** apertura en básica y media; chip de comuna apagado y con el cursor encima; detalle de un establecimiento con delta de matrícula negativo; notas metodológicas; modal simple en sus cuatro pestañas (con cursor sobre una fila y búsqueda); narrativa con un establecimiento; comuna con "sin categoría"; comparador vacío; modal múltiple con filas marcadas y con el tope alcanzado; comparador con 10 territorios en básica y media; ✕ de un chip con el cursor encima.
- **Texto (WCAG 2.1, 1.4.3):** cada nodo de texto visible, con su color y su fondo efectivos, componiendo transparencias y opacidades de toda la cadena de ancestros. Umbral 4,5:1; 3:1 si el texto es grande (≥ 24 px, o ≥ 18,66 px en negrita). 13.725 mediciones.
- **No textual (WCAG 2.1, 1.4.11):** relleno y borde de cada gráfico y control contra el fondo adyacente. Umbral 3:1. Se exige solo donde la norma lo exige: gráficos cuyo color es la única forma de leer el dato, bordes de campos y casillas, e indicadores de estado. Quedan fuera los contenedores decorativos (tarjetas, franjas), los botones con texto (el texto basta para identificarlos) y las celdas del mapa de calor (el valor va escrito en cada celda).
- **Exentos por norma:** controles deshabilitados.
- **Anillo de foco:** ya medido en el encargo a2 (≥ 5,34:1 en los siete controles); no se repite.
- **Propuesta:** simulada sobre el mismo motor inyectando las variables y colores nuevos, y medida con el mismo instrumento y los mismos 19 estados.

## 2. Resultado general

| | Motor actual | Propuesta |
|---|---|---|
| Pares texto-fondo distintos que fallan (controles activos) | 19 | **0** |
| Mediciones de texto que fallan (controles activos) | 2.103 de 13.725 | **0** |
| Gráficos y controles con contraste exigido que fallan | 8 familias | **0** |
| Fallas que quedan | ninguna activa | 4 pares en controles deshabilitados (exentos) |

## 3. Fallas de texto (motor actual → propuesta)

| # | Dónde | Texto / fondo actual | Actual | Propuesta | Con la propuesta |
|---|---|---|---|---|---|
| T1 | Rótulos grises sobre crema: "Filtra por comuna:", "Dependencia", "Territorios a comparar", pistas del comparador, metadatos del resumen | `--fg-3` #747474 / #FFF6E0 | 4,34 | `--fg-3` → #5E5E5E | 6,02 |
| T2 | Región o "Traspaso AAAA" en una fila del modal con el cursor encima | #747474 / #F4E9CC | 3,87 | igual que T1 | 5,36 |
| T3 | Región o "Traspaso AAAA" en una fila marcada del modal múltiple | #747474 / #D4E4F1 | 3,60 | igual que T1 | 4,99 |
| T4 | Separadores "·" de las tarjetas de establecimiento | #BABABA / blanco | 1,95 | `--fg-3` sin opacidad | 6,48 |
| T5 | Separador "·" del encabezado | #607C8A / #0A3A5C | 2,67 | #A9B7BB sin opacidad | 5,74 |
| T6 | "Motor de comparación" en el encabezado | #91A1A5 / #0A3A5C | 4,44 | #A9B7BB sin opacidad | 5,74 |
| T7 | Cabecera de columna Insuficiente (título, conteo, matrícula) | `--ink` / #EE2D49 | 4,46 | nuevo rojo #D0112D con texto blanco | 5,53 |
| T8 | Delta negativo de matrícula en el detalle del establecimiento | #EE2D49 / #FFFBEF | 3,97 | nuevo rojo #D0112D | 5,34 |
| T9 | ✕ del chip del comparador con el cursor encima | blanco / #EE2D49 | 4,11 | fondo #D0112D | 5,53 |
| T10 | % máximo de cada fila del comparador (texto azul sobre la celda teñida) | `--ocean` / tintes | 2,07 a 3,51 | texto `--ink` en peso 800 y marco `--ink` de 2 px dentro de la celda | 5,47 a 8,38 |

Las cabeceras de Medio-Bajo (5,05 con el nuevo naranja) y Medio (5,27) siguen con `--ink`; Alto sigue en blanco (6,45). La propuesta quita además la opacidad de las líneas secundarias de las cuatro cabeceras: con el rojo nuevo y texto blanco al 82 % la matrícula bajaría a ≈ 4,0.

## 4. Fallas no textuales (motor actual → propuesta)

| # | Elemento | Por qué se exige | Actual | Propuesta | Con la propuesta |
|---|---|---|---|---|---|
| G1 | Marcas de trayectoria, muestras de la leyenda, puntos de categoría del comparador y marcas del detalle, en **Medio-Bajo** | el color es la única forma de leer la categoría | 2,62 (blanco) · 2,43 (crema) | Medio-Bajo → #E05D2F | 3,64 · 3,38 |
| G2 | Las mismas marcas en **Sin categoría** (relleno crema, borde punteado) | ídem | 1,87 (borde) | borde punteado con el gris de control #8A7F68 | 3,95 |
| G3 | Campo "Buscar…" del modal | el borde es lo que identifica un campo | 1,87 | `--border-2` → #8A7F68 | 3,95 |
| G4 | Casilla sin marcar del modal múltiple | el borde es lo que identifica la casilla | 1,81 | igual que G3 | 3,82 |
| G5 | Estado activo de los selectores segmentados (Vista y Nivel) | el estado seleccionado debe distinguirse | 1,21 (píldora blanca sobre crema) | activo en `--ocean` con texto blanco, como los chips de comuna | 5,34 (texto 6,45) |
| G6 | Botón de territorio, "Notas metodológicas", "Limpiar", "Cancelar" | no lo exige la norma (tienen texto); se corrige por coherencia de controles | 1,28 a 1,87 | borde `--border-2` | 3,67 a 3,95 |

**Sin cambio y en regla:** Insuficiente como gráfico pasa de 4,11 a 5,53; Medio (#2A8FD9) queda en 3,48 sobre blanco y 3,24 sobre crema (en regla, pero sin holgura); Alto 6,45; casilla marcada 4,97; chips de comuna encendidos 5,99.

## 5. La propuesta, cambio por cambio

| Id | Cambio | Dónde vive | Tipo |
|---|---|---|---|
| P1 | `--fg-3`: `var(--slate)` (#747474) → **#5E5E5E** (T1 a T4) | `:root` del template | color nuevo (gris neutro) |
| P2 | `--border-2`: `var(--line-strong)` (#C8BDA0) → **#8A7F68**; `--line-strong` sigue igual para las líneas decorativas (G2, G3, G4, G6) | `:root` del template | color nuevo (gris cálido) |
| P3 | Tinta clara del encabezado **#A9B7BB** sin opacidad para "Motor de comparación" y el separador (T5, T6) | CSS del template | color nuevo |
| P4 | **Insuficiente #EE2D49 → #D0112D**, con texto blanco en su cabecera | `CAT_COLORS` en `33_generar_html.R`, `--cat-insuf` en `:root`, `CAT_CABECERA_TINTA` en `33_app.jsx` | cambio de paleta |
| P5 | **Medio-Bajo #E88663 → #E05D2F**, con `--ink` en su cabecera | `CAT_COLORS` en `33_generar_html.R` | cambio de paleta |
| P6 | Sin opacidad en las líneas secundarias de las cuatro cabeceras | CSS del template | ajuste |
| P7 | Delta negativo y ✕ del chip al pasar el cursor usan el rojo nuevo (T8, T9) | ya leen `--cat-insuf` | derivado de P4 |
| P8 | % máximo del comparador: texto `--ink` en peso 800 y marco interior `--ink` de 2 px (T10) | CSS del template | cambio de codificación: el máximo deja de marcarse con azul |
| P9 | Estado activo de los segmentados en `--ocean` con texto blanco (G5) | CSS del template | cambio visual |
| P10 | Botón "Cancelar" del modal con `--border-2` (G6) | CSS del template | ajuste |

Los dos nuevos colores de categoría conservan el tono de los actuales (rojo y naranjo) y el orden perceptual: rojo oscuro, naranjo medio, azul medio, azul oscuro. La diferencia de luminosidad entre Insuficiente y Medio-Bajo se mantiene (contraste entre ambos 1,52; hoy 1,57).

## 6. Lo que la propuesta implica

1. **Enmienda de la paleta de categorías:** `20260612_decision_paleta_categorias.md` queda superada en dos colores. Se escribe una decisión nueva que la reemplace, y `20260925_decision_contraste_texto_categorias.md` pierde su excepción, porque Insuficiente pasa a 5,53.
2. **El payload cambia, las cifras no.** `CAT_COLORS` viaja dentro del `meta` del JSON embebido, así que el SHA del payload normalizado cambiará. El invariante del encargo que lo implemente debe ser: payload idéntico **salvo `meta.cat_colors`**, y `auditar_cifras.R` y `spot_check_publicado.R` en verde.
3. **Se agregan cuatro colores nuevos** (#5E5E5E, #8A7F68, #A9B7BB y los dos de categoría), fuera de la paleta institucional de `10_configuracion.R`. `--slate` (#747474, `col_g`) y `--coral` (#E88663, `col_n`) no se tocan: siguen disponibles como marca, pero el motor deja de usarlos para texto gris y para Medio-Bajo.
4. **Los hermanos:** si `slep_idps` y `slep_simce_adecuado` comparten `--fg-3` y `--border-2`, arrastran las mismas fallas T1 y G3. Se registra como observación para esos proyectos; aquí no se propone nada sobre ellos.

## 7. Fuera de esta propuesta (observaciones)

- **Uso del color (WCAG 1.4.1):** las marcas de trayectoria comunican la categoría solo por color; el nombre aparece únicamente en el `title` al pasar el cursor. La leyenda ayuda, pero no reemplaza una segunda señal (letra, trama o forma). Es una decisión de diseño aparte.
- **Controles deshabilitados** (filas bloqueadas al tope, botones "Agregar" sin selección): quedan entre 1,94 y 2,96. La norma los exime; se pueden subir si se prefiere, pero no es necesario.
- **Medio (#2A8FD9)** cumple sin holgura sobre crema (3,24). No se toca para no mover una tercera categoría.

## 8. Verificación de la propuesta

Simulada sobre el motor actual (variables inyectadas y `CatData.CAT_COLORS` sustituido en tiempo de ejecución) en los mismos 19 estados: **0 fallas de texto en controles activos y 0 fallas no textuales exigidas**. Quedan 4 pares, todos en controles deshabilitados. Capturas comparativas antes y después de la vista por territorio, del comparador y del modal múltiple entregadas en el chat de la sesión 30.
