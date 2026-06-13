# Decisión: paleta fija de categorías

**Fecha:** 2026-06-12
**Sesión:** 6 (documentación retroactiva de una decisión tomada en la sesión 3, v03)
**Tipo:** decisión de diseño
**Estado:** vigente

## Contexto

Las cuatro categorías (Insuficiente, Medio-Bajo, Medio, Alto) aparecen en todo el
motor: chips de trayectoria, leyenda, heatmap de la hoja comparativa y barras.
Necesitan un color consistente y único por categoría en todas esas vistas, con
contraste legible sobre el fondo crema del sitio.

## Decisión

Paleta fija de cuatro colores, reutilizando tokens ya presentes en el head del
template, en orden semántico Insuficiente → Alto:

| Categoría | Hex | Token |
|---|---|---|
| Insuficiente | `#EE2D49` | mark-red |
| Medio-Bajo | `#E88663` | coral |
| Medio | `#2A8FD9` | mark-blue |
| Alto | `#0062A0` | ocean (azul institucional SLEP) |

## Justificación

1. **Contraste AA:** los cuatro colores se validaron sobre el fondo crema del
   sitio.
2. **Gradiente perceptual rojo → azul** que mapea peor → mejor sin recurrir a la
   rampa verde-rojo, evitando ambigüedad para daltonismo y manteniendo la
   identidad institucional (el azul SLEP queda en la categoría Alto).
3. **Reutilización de tokens del head:** no introduce familias de color nuevas;
   el resto del motor ya usaba mark-red, coral, mark-blue y ocean.

## Alternativas consideradas

- **Rampa verde → rojo clásica de "bueno a malo".** Descartada: problemática para
  daltonismo y rompe la paleta institucional al introducir verde.
- **Escala monocroma por intensidad.** Descartada: no distingue las cuatro
  categorías de un vistazo en la leyenda ni en los chips.

## Implicancia

`CAT_COLORS` en `33_generar_html.R` es la fuente única de la paleta; viaja al
template dentro del `meta` del JSON. El heatmap de la hoja comparativa deriva el
`rgba` desde cada hex con el helper `hexToRgba` (alfa proporcional a la
concentración). Cambiar un color se hace en un solo lugar y se propaga a todo el
motor en la próxima regeneración.
