# Decisión: cobertura temporal y año vigente

**Fecha:** 2026-06-12
**Sesión:** 6 (documentación retroactiva de una decisión tomada en la sesión 3, v03)
**Tipo:** decisión metodológica
**Estado:** vigente

## Contexto

La Agencia de Calidad publica la Categoría de Desempeño por año. El motor debe
definir qué años incorpora, cuál considera "vigente" (el que gobierna la vista
por defecto y los conteos territoriales) y cómo trata la trayectoria multianual
de cada establecimiento.

Las bases disponibles en `20_insumos/` son siete archivos: básica 2016-2019
(`cdb_*`) y media 2017-2019 (`cdm_*`). La media no tiene 2016 en la fuente.

## Decisión

`slep_categoria_desempeno` cubre **2016-2019**, con **año vigente = 2019**. La
básica cubre 2016-2019 y la media 2017-2019; cada nivel se grafica por los años
realmente disponibles para ese nivel.

## Justificación

1. **Disponibilidad:** son los años con archivos CDB/CDM en la fuente. No se
   inventan años faltantes ni se imputan.
2. **Año vigente = el más reciente disponible:** 2019 es el último publicado
   antes de la suspensión por pandemia. No existe categorización 2020.
3. **Sin hueco visible de pandemia:** el corte pandemia caería en 2020 y
   siguientes, fuera del rango actual; por eso la trayectoria 2016-2019 es
   continua y no necesita una marca de hueco (a diferencia de proyectos que sí
   abarcan 2019-2021).

## Alternativas consideradas

- **Mostrar solo el año vigente.** Descartada: la trayectoria multianual (cómo
  evoluciona la categoría de un establecimiento) es valor central del motor.
- **Esperar a la entrada de SIMCE 2025 para publicar.** Descartada: el histórico
  2016-2019 ya es útil para el equipo. La próxima incorporación con SIMCE 2025
  está prevista y se sumará sin rehacer el diseño.

## Implicancia

El año vigente se resuelve dinámicamente como `max(anios_disp)` en
`33_generar_html.R`, no se hardcodea: cuando entre 2025, el vigente se recalcula
solo. La media sin 2016 se maneja por año disponible por nivel, sin forzar una
celda vacía. Si en el futuro se incorpora un rango que cruce 2019-2021, habrá que
añadir la marca explícita de hueco de pandemia (hoy innecesaria).
