# Decisión: ampliación de la cobertura del insumo de matrícula a 2016-2025

**Fecha:** 2026-06-13
**Proyecto:** slep_categoria_desempeno
**Ámbito:** insumo `matricula_rbd_ense.parquet` (producido en `slep_analisis_matricula`, consumido por el motor)

## Contexto

Hasta hoy el insumo de matrícula cubría 2016-2019 (los cuatro años del motor de
categoría). El script productor `03_generar_matricula_rbd_ense.R` en
`slep_analisis_matricula` tenía la cobertura hardcodeada en `ANIOS_OBJETIVO <-
2016:2019`. Los CSV nacionales del Centro de Estudios MINEDUC ya disponían de la
serie completa 2016-2025 (diez archivos `matricula_cem_AAAA.csv`), pero el script
los ignoraba por diseño.

Esto bloqueaba dos pendientes documentados:
- **P-matricula-actual:** mostrar la matrícula 2025 como tamaño vigente del EE.
- **P-matricula-grado:** desglose por `cod_grado` (pendiente independiente, no
  resuelto aquí: requiere cambio de grano, no de cobertura temporal).

## Decisión

Ampliar la cobertura del insumo de 2016-2019 a **2016-2025**, modificando una
única constante (`ANIOS_OBJETIVO <- 2016:2025`) en el script productor. El resto
del pipeline ya era agnóstico al año (localización de CSV, normalización de
nombres, agregación DuckDB, validaciones y escritura derivan todos de esa
constante).

## Verificación (build del 2026-06-13)

El parquet regenerado pasó las cinco validaciones de integridad del script:
llave `rbd × anio × cod_ense2` única; `matricula_total_ee` constante dentro de
`rbd × anio`; suma de `cod_ense2` igual al total del EE; sin NAs en llaves ni
matrícula; cobertura 2016-2025 completa.

- Filas: 85.594 → 211.391 (seis años nuevos).
- Año 2025: 10.949 RBD distintos, 10.945 funcionando, 3.541.840 matrículas.
  El conteo de EE funcionando coincide exactamente con el universo del motor.
- Sin avisos de duplicados a grano `rbd × cod_ense2` en ningún año (`COUNT(*)`
  igual a `COUNT(DISTINCT mrun)` en los diez años).

## Implicancia para el motor (no ejecutada aún)

El motor `slep_categoria_desempeno` sigue con `ANIO_VIGENTE = 2019` en
`33_generar_html.R`. Con el insumo ampliado, regenerar el motor cambia el
comportamiento de tres vistas que la sesión 10 construyó asumiendo 2016-2019:

1. La matrícula "vigente" de tarjetas, comparador y ficha podría pasar a 2025.
2. La evolución de matrícula (cambio 51) extendería su serie a 2025
   automáticamente (`matriculaSerieNivel` recorre `YEARS`).
3. Requiere una decisión de dominio previa: ¿2025 **reemplaza** a 2019 como año
   vigente, o ambos conviven (2019 histórico, 2025 tamaño actual)?

Esa decisión y su implementación son trabajo de una sesión enfocada de
`slep_categoria_desempeno`, no de la regeneración del insumo.

## Invariantes que se mantienen

- La matrícula sigue siendo **contexto aditivo**, nunca pondera ni entra en
  agregaciones de categoría (la agregación es conteo de EE).
- Básica y media no se mezclan: las cifras por categoría/nivel usan la matrícula
  del nivel (`cod_ense2`), nunca el total del EE.
- La categoría de desempeño mantiene su propia cobertura temporal; los años
  2020-2025 del insumo de matrícula son contexto de tamaño, no de categoría.

## Alternativa considerada

Esperar a publicación de un año más reciente (se evaluó si el bloqueo era de dato
externo). Descartada: la serie 2016-2025 ya estaba completa en disco; el bloqueo
era un parquet desactualizado y una constante hardcodeada, no falta de dato.

## Nota sobre el productor

`slep_analisis_matricula` es un proyecto one-off de análisis, sin repositorio
Git, alojado en OneDrive. Su versionado es el historial de OneDrive. El cambio de
cobertura quedó reflejado en el header del script `03` y en este documento del
proyecto consumidor.
