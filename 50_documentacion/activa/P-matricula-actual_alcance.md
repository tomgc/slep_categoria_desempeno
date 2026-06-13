# P-matricula-actual — Alcance

> Pendiente bloqueado por dato. Documento de alcance (no de implementación).
> Hermano de `P-matricula-grado_alcance.md`. Origen: traspaso v10 (§11, D16, A14).

## Qué es

Mostrar la matrícula **actual** (2025) de cada establecimiento como medida de
tamaño vigente, en lugar de (o junto a) la matrícula 2019 que hoy es el último
año con dato en el insumo. Afecta tres vistas que ya consumen matrícula como
contexto: tarjetas de modo territorio, tooltip del comparador y ficha del
establecimiento (fila colapsada y panel expandido).

## Por qué está bloqueado

El insumo de matrícula vigente (`matricula_rbd_ense.parquet`) llega hasta 2019
con grano `cod_ense2` a nivel nacional. La matrícula 2025 **no existe en este
proyecto** y no puede fabricarse aquí.

La base de rendimiento 2025 disponible localmente se evaluó como proxy y se
**descartó** (A14): cobertura local (73 EE de 10.945), grano sin nivel (mezclaría
básica y media, violando un invariante 🔒) y procedencia de otro proyecto. Un
proxy que no cumple la definición del dato (matrícula = `COUNT(*)` por
`cod_ense2`, nacional) produce cifras engañosas.

## Qué se necesita para desbloquearlo

1. Regenerar `matricula_rbd_ense.parquet` **con 2025 incluido**, en el proyecto
   `slep_analisis_matricula` (NO en este repo: ⚠️ no re-leer los CSV nacionales
   aquí). Mismo esquema actual: una fila por `[rbd, cod_ense2, anio]` con el
   conteo de matrícula del nivel.
2. Copiar el parquet regenerado a `20_insumos/` a mano (tarea manual del
   titular; no script).
3. Verificar que el nuevo año entre por el pipeline existente sin cambios de
   lógica: `31_leer_normalizar.R` y `32_agregar_territorial.R` ya tratan el año
   como dimensión; el `ANIO_VIGENTE` del motor pasaría de 2019 a 2025.

## Decisión de diseño pendiente (al desbloquear)

Definir si 2025 **reemplaza** a 2019 como año vigente de matrícula, o si ambos
conviven (2019 como histórico, 2025 como tamaño actual). El v10 (D16) implementó
la evolución 2016-2019 justamente como entrega verificable mientras 2025 no
existe; al llegar 2025, esa serie se extendería y `ANIO_VIGENTE` se movería.

**Recomendación:** reemplazar 2019 por 2025 como `ANIO_VIGENTE` y extender la
serie de evolución hasta 2025 — el tamaño "actual" debe ser el más reciente, y
la serie ya está construida para absorber años nuevos (`matriculaSerieNivel`
recorre todos los `YEARS`).

## Invariantes que se mantienen

- 🔒 La matrícula es **contexto aditivo**, nunca pondera ni entra en
  agregaciones de categoría (la agregación sigue siendo conteo de EE).
- 🔒 Básica y media **nunca se mezclan**: la cifra por categoría/nivel usa la
  matrícula del NIVEL (`cod_ense2`), nunca el total del EE.
- 🔒 El % de matrícula usa denominador de categorizados (los 4 % suman 100, D15).

## Criterio de éxito (al implementar)

Build limpio con `ANIO_VIGENTE` actualizado; las tres vistas muestran la cifra
2025; la serie de evolución incluye 2025; invariantes de build intactos (conteo
de EE, no mezcla de niveles, 4 % suman 100). Verificación visual del titular.
