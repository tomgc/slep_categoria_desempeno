# Decisión: ausencia de segmentación por GSE

**Fecha:** 2026-06-11
**Sesión:** 1 (scaffold)
**Tipo:** decisión metodológica
**Estado:** vigente

## Contexto

El proyecto madre `slep_simce_adecuado` tiene como invariante inviolable la
segmentación por Grupo Socioeconómico (GSE): toda vista de resultados aparece
desagregada por GSE, nunca colapsada. La razón es que el % de estudiantes en
nivel Adecuado no es comparable entre territorios sin controlar por composición
socioeconómica.

Este proyecto trabaja la **Categoría de Desempeño**, una clasificación distinta.

## Decisión

`slep_categoria_desempeno` **no segmenta por GSE en ninguna vista.**

## Justificación

La Categoría de Desempeño es una clasificación **integral** que la Agencia de
Calidad construye incorporando el contexto socioeconómico del establecimiento
dentro de su propia metodología. Comparar establecimientos por su categoría ya
está, por diseño de la fuente, ajustado por características del grupo de
estudiantes. Añadir una segmentación GSE encima sería:

1. **Redundante:** el ajuste socioeconómico ya está incorporado en la categoría.
2. **Metodológicamente incorrecto:** sugeriría que la categoría es comparable
   "en bruto" entre GSE, cuando la propia categoría es el resultado del ajuste.

Por tanto, la ausencia de GSE aquí es la **contraparte explícita** del "GSE
inviolable" del madre: en ambos casos la decisión persigue comparabilidad
metodológicamente correcta, pero la fuente la resuelve en lugares distintos
(en el madre, segmentando; aquí, integrada en la categoría).

## Alternativas consideradas

- **Segmentar igual que el madre, por consistencia visual entre proyectos
  hermanos.** Descartada: la consistencia de UI no puede imponer una segmentación
  metodológicamente injustificada. La forma sigue al dato, no al revés.
- **Ofrecer GSE como filtro opcional.** Descartada: invitaría a una lectura
  errónea de la categoría como magnitud comparable entre GSE.

## Implicancia

El esquema de datos (`categoria_rbd`, `categoria_territorial`) no incluye
`cod_grupo` como dimensión. La UI no tiene control de GSE. Si en el futuro se
quisiera cruzar categoría con GSE con fines exploratorios, sería un análisis
separado y declarado como tal, no una vista del motor.
