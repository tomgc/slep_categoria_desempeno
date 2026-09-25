---
slug: slep_categoria_desempeno
nombre_real: Motor de comparación interactivo de la Categoría de Desempeño de los establecimientos educacionales del país
categoria: activo
semaforo: activo
sesion_actual: v29
ultima_actividad: 2026-09-25
maneja_sensibles: true
tipo_pendiente: deuda_heredada
ventana_insumos: ./20_insumos
---
## En que vamos
Sesión v29: se cerró la migración de la escala tipográfica del motor a variables CSS con nomenclatura estándar `slep_*` (8 niveles, piso subido de 10px a 12px, 130 usos remapeados por rol contra el JSX real), con QA visual aprobada y motor regenerado. Se versionó la deuda de git heredada de v28 (log de saneamiento PII, rotación de snapshots del escáner, traspasos v27-v28). Repo sincronizado con origin, sin fallas funcionales.

## Proximo paso
1. Re-clonar cualquier clon previo del repositorio, ya que el historial fue reescrito en v27 (acción manual del titular, una sola vez).
2. Limpiar el CSS muerto heredado de `slep_simce_adecuado` (~7 bloques: `.supergrid`, `.tt-*`, `.data-table`, `.gse-filter`, sueltos); baja prioridad, encargo aparte a Claude Code.
3. Decidir si la migración tipográfica amerita entrada nueva en `backlog_acumulativo.md` (baja prioridad).

## Bloqueantes
Ninguno.
