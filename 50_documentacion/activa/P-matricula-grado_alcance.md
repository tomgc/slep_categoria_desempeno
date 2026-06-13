# P-matricula-grado — alcance resuelto (pendiente de dato)

- **Fecha:** 2026-06-13 (sesión 10)
- **Estado:** BLOQUEADO por dato. El insumo `matricula_rbd_ense.parquet` tiene
  grano `rbd × año × cod_ense2` (tipo de enseñanza), sin `cod_grado`. La
  implementación requiere regenerar el insumo a grano más fino en el proyecto
  hermano.
- **Tipo:** funcionalidad (UI + generador), dependiente del proyecto hermano.

---

## Objetivo

Añadir, dentro del panel expandido de la ficha, un sub-desglose de matrícula por
**grado** (`cod_grado`) dentro de cada tipo de enseñanza / nivel, para un detalle
mayor que el actual (que llega a tipo de enseñanza).

## Estado actual (lo que ya existe, sesión 10)

El panel expandido ya muestra, por año, la matrícula desglosada por tipo de
enseñanza (`matriculaDesglose(rbd, anio)` → lista de `cod_ense2` con su cifra).
P-matricula-grado agrega un nivel más de profundidad: dentro de cada `cod_ense2`,
el reparto por grado.

Anclaje en el código (`33_motor_template.html`):

- El desglose por tipo de enseñanza vive en `matriculaDesglose` y se renderiza en
  el bloque `.ee-detail-ense` del panel. El grado sería un sub-nivel anidado bajo
  cada item de ese desglose.
- `MAT_IX` indexa `rbd → año → {porEnse2: Map(cod→mat), total}`. Para grado, el
  índice ganaría un nivel: `porEnse2: Map(cod → {total, porGrado: Map(grado→mat)})`,
  o un índice paralelo `MAT_GRADO_IX`. Decisión de implementación a tomar al
  momento, según el esquema real del insumo regenerado.

## Decisión de alcance (resuelta)

1. **Dónde se muestra:** sub-lista anidada dentro de cada item de
   `.ee-detail-ense-list` (el desglose por tipo de enseñanza que ya existe). NO
   una sección nueva: es profundidad añadida al desglose actual.
2. **Qué cifra:** matrícula por `cod_grado` dentro de cada `cod_ense2`, por año.
   La suma de los grados de un `cod_ense2` debe cuadrar con la cifra de ese
   `cod_ense2` (invariante de consistencia, verificable).
3. **Nivel de detalle por defecto:** colapsado. El panel ya es rico; el grado es
   detalle opcional que el usuario expande si lo quiere, para no saturar la
   vista. (Patrón a definir: acordeón por tipo de enseñanza, o mostrar grado solo
   en el año vigente.)
4. **Respeto de invariantes:** el grado NO cambia ninguna agregación de
   categoría (sigue siendo conteo de EE). Básica y media siguen sin mezclarse: el
   grado vive dentro de su `cod_ense2`, que ya está mapeado a un nivel. La
   matrícula por grado es contexto del EE, como el resto de la matrícula.
5. **Comparador y modo territorio:** NO se tocan. El grado es solo de la ficha
   individual, en el panel expandido.
6. **Ausencia de dato:** si un `cod_ense2` no tiene desglose por grado ese año
   (dato faltante), se muestra solo la cifra agregada del tipo de enseñanza, sin
   sub-lista (no "0" por grado).

## Prerrequisito (proyecto hermano `slep_analisis_matricula`)

Regenerar `matricula_rbd_ense.parquet` (o un insumo paralelo) a grano
`rbd × año × cod_ense2 × cod_grado`:

1. Cambiar el `GROUP BY` de `03_generar_matricula_rbd_ense.R` para incluir
   `cod_grado`. El insumo crece (más filas); evaluar si conviene un parquet
   separado (`matricula_rbd_grado.parquet`) para no engrosar el actual, dado que
   el desglose por grado es detalle opcional.
2. Confirmar el dominio de `cod_grado` y su glosa (etiquetas legibles por grado,
   análogas a `ENSE2_LABELS`).
3. Validar consistencia: suma de grados por `cod_ense2` == matrícula del
   `cod_ense2` (los 5 checks actuales más este).
4. Copiar el parquet a `20_insumos/` a mano. No se releen los CSV nacionales en
   este proyecto.

## Implementación una vez que el dato exista

- **`33_generar_html.R`:** cargar el insumo de grado (o la columna nueva);
  diccionario `GRADO_LABELS` expuesto en `meta`; bloque columnar de grado en el
  JSON (separado si es parquet aparte). Validaciones de dominio y consistencia
  grado→tipo de enseñanza.
- **`33_motor_template.html`:** extender `MAT_IX` o añadir `MAT_GRADO_IX`; helper
  `matriculaPorGrado(rbd, cod_ense2, anio)`; sub-lista colapsable en
  `.ee-detail-ense-list`; CSS para el nivel anidado. Respetar A1 (transpilar
  antes de regenerar) y A2 (marcadores).

## Criterio de éxito (B.4)

- El panel expandido muestra, bajo cada tipo de enseñanza, el reparto por grado
  (colapsado por defecto), con la suma de grados cuadrando con la cifra del tipo
  de enseñanza.
- Ninguna agregación de categoría cambia; básica y media siguen separadas.
- Un tipo de enseñanza sin dato de grado muestra solo su cifra agregada.

## Relación con los otros pendientes de matrícula

P-matricula-actual (matrícula 2025 como tamaño actual) y P-matricula-grado son
independientes: el primero agrega un año, el segundo agrega profundidad de grano.
Ambos requieren regenerar el insumo en el proyecto hermano, pero por motivos
distintos. Pueden priorizarse por separado.
