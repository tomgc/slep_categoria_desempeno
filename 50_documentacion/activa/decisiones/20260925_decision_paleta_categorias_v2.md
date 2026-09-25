# Decisión: paleta de categorías v2 (recalibrada por contraste)

**Fecha:** 2026-09-25
**Sesión:** 30 (aprobación del titular de la opción A más la variante P11 de la auditoría de contraste; ejecutada en el encargo a3)
**Tipo:** decisión de diseño y accesibilidad. Cambia colores; no cambia ninguna cifra.
**Estado:** vigente

## Contexto

La auditoría de contraste figura-fondo del motor
(`50_documentacion/andamios/20260925_auditoria_contraste_motor.md`) midió el motor del
encargo a2 en 19 estados, con el render real (1280 × 900, transiciones desactivadas),
contra WCAG 2.1 AA: 4,5:1 para texto (3:1 para texto grande) y 3:1 para gráficos y
controles cuyo color o borde es la única forma de leerlos.

Resultado sobre el motor anterior: **19 pares texto-fondo fallidos** en controles activos
(2.103 de 13.725 mediciones) y **8 familias gráficas** bajo 3:1. Las fallas que tocan la
paleta de categorías:

| Falla | Qué | Antes |
|---|---|---|
| G1 | Marcas de Medio-Bajo (`#E88663`) sobre blanco / crema | 2,62 / 2,43 |
| T7 | Cabecera de Insuficiente (`--ink` sobre `#EE2D49`), excepción de la decisión de contraste del mismo día | 4,46 |
| T8 | Delta negativo de matrícula (`#EE2D49` sobre `#FFFBEF`) | 3,97 |
| T9 | ✕ del chip al pasar el cursor (blanco sobre `#EE2D49`) | 4,11 |
| T10 | % máximo del comparador (`--ocean` sobre el tinte de su categoría) | 2,07 a 3,51 |

Y las que tocan el texto y los bordes neutros: gris de texto secundario `--fg-3`
(`--slate`, 4,34 sobre crema), textos atenuados del encabezado (2,67 y 4,44), separador
"·" de las tarjetas (1,95), borde de campos y casillas (`--line-strong`, 1,81 a 1,87),
marcas de "sin categoría" (1,87) y estado activo de los selectores segmentados (1,21).

## Decisión

### Paleta de categorías

| Categoría | Color de marca (`CAT_COLORS`) | Marca sobre blanco / crema | Color de cabecera | Texto blanco sobre la cabecera |
|---|---|---|---|---|
| Insuficiente | `#D0112D` (antes `#EE2D49`) | 5,53 / 5,13 | `#B30F27` (`--cat-insuf-cab`) | 6,97 |
| Medio-Bajo | `#E05D2F` (antes `#E88663`) | 3,64 / 3,38 | `#C1481D` (`--cat-mbajo-cab`) | 4,99 |
| Medio | `#2A8FD9` (sin cambio) | 3,48 / 3,24 | `#2074B2` (`--cat-medio-cab`) | 5,00 |
| Alto | `#0062A0` (sin cambio) | 6,45 / 5,99 | `#004976` (`--cat-alto-cab`) | 9,48 |

- El color de **marca** (trayectorias, leyenda, puntos y mapa de calor del comparador,
  marcas del detalle) sigue viviendo en `CAT_COLORS` de `33_generar_html.R`, que viaja en
  `meta.cat_colors`. `--cat-insuf: #D0112D` en `:root` alimenta el delta negativo y la ✕
  del chip al pasar el cursor (5,34 y 5,53).
- El color de **cabecera** es un tono más oscuro de cada categoría, definido en `:root`
  del template y aplicado por `CatColumn` (`33_app.jsx`, `CAT_CABECERA_FONDO`), con
  **texto blanco en las cuatro** y sin opacidad en sus líneas secundarias.

### Texto y bordes neutros

| Variable | Valor | Uso | Contraste |
|---|---|---|---|
| `--fg-3` | `#5E5E5E` (antes `var(--slate)`, `#747474`) | texto secundario gris | 6,02 sobre crema |
| `--border-2` | `#8A7F68` (antes `var(--line-strong)`) | borde de controles vivos (campo, casillas, botones, chips) y de las marcas de "sin categoría" | 3,95 sobre blanco |
| `--fg-on-dark-muted` | `#A9B7BB` (nueva) | textos atenuados del encabezado oscuro, sin opacidad | 5,74 |

`--line-strong` (`#C8BDA0`) queda para las líneas decorativas vivas (contenedor de la
tabla del comparador y caja del comparador vacío). El % máximo del comparador pasa a
`--ink` en peso 800 con un marco interior `--ink` de 2 px, y el estado activo de los
selectores segmentados pasa a `--ocean` con texto `--paper`.

Resultado medido en el encargo a3 (19 estados): **0 pares de texto fallidos y 0 fallas
gráficas exigidas en controles activos**; quedan solo controles deshabilitados, exentos.

## Qué reemplaza

- Los dos hex de Insuficiente y Medio-Bajo de `20260612_decision_paleta_categorias.md`.
- La excepción escrita de `20260925_decision_contraste_texto_categorias.md` (Insuficiente a
  4,46:1 con `--ink`): desaparece, porque las cabeceras pasan a tonos oscuros propios con
  texto blanco (Insuficiente 6,97). También quedan resueltas las tres superficies que esa
  decisión dejaba bajo 4,5:1 (% máximo, delta negativo y ✕ del chip).

## Qué conserva

- El orden perceptual rojo → naranjo → azul medio → azul oscuro, sin verde; la distancia
  entre Insuficiente y Medio-Bajo casi no cambia (contraste entre ambos 1,52; antes 1,57).
- Medio y Alto sin cambio de color de marca.
- `CAT_COLORS` como fuente única de los colores de marca, que el motor recibe en el payload.
- `--slate` (`#747474`) y `--coral` (`#E88663`) siguen en `:root` como colores de marca
  institucional; el motor deja de usarlos para texto gris y para Medio-Bajo.

## Alternativas consideradas

- **Opción B de la auditoría (sin tocar la paleta):** solo tintas y bordes. Descartada:
  no resuelve G1 (Medio-Bajo como marca, 2,62) ni el delta negativo y la ✕ del chip.
- **Oscurecer toda la paleta, no solo las cabeceras:** descartada (auditoría §5). Los
  tonos de cabecera aplicados a las marcas bajarían la distinción entre categorías vecinas
  y oscurecerían el mapa de calor del comparador, que se lee por intensidad.
- **Texto oscuro en tres cabeceras** (la propuesta inicial, P4 y P5 con `--ink`):
  reemplazada por la variante P11 (maqueta `50_documentacion/andamios/20260925_cabeceras_variante.png`),
  que da texto blanco uniforme en las cuatro.

## Implicancia

- El payload cambia solo en `meta.cat_colors`; las cifras no (`tests/auditar_cifras.R` y
  `tests/spot_check_publicado.R` en verde; SHA del JSON con la fecha normalizada y la
  paleta anterior restituida, idéntico al del build anterior).
- Cambiar un color de categoría obliga a volver a medir la tabla de arriba, en particular
  Medio-Bajo, que queda con menos holgura (3,38 sobre crema).
