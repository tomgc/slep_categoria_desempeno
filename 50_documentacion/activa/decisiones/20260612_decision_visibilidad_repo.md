# Decisión: visibilidad pública del repositorio

**Fecha:** 2026-06-12
**Sesión:** 6 (documentación retroactiva de una decisión tomada en la sesión 4, v04)
**Tipo:** decisión de gobernanza
**Estado:** vigente

## Contexto

La política de proyectos (sección 4.3) fija el repositorio **privado** por
defecto, porque el caso típico maneja datos sensibles. Este proyecto trabaja
exclusivamente con bases **públicas** de la Agencia de Calidad (Categoría de
Desempeño por establecimiento), sin RUT, sin nombres de estudiantes y sin datos
nominales de funcionarios.

## Decisión

`slep_categoria_desempeno` usa un repositorio **público**.

## Justificación

1. **Sin datos sensibles:** la auditoría de seguridad pre-migración (sesión 4)
   no halló datos personales ni rutas con información identificable. Los insumos
   son bases públicas versionadas en el propio repo (Rama A).
2. **GitHub Pages:** la publicación del motor desde `docs/` requiere repo público
   en el plan Free; la publicación web es un objetivo del proyecto.
3. **Límite explícito por licencia:** la cláusula de datos del `LICENSE` deja
   claro que la licencia cubre el código y no los datos.

Es la **contraparte coherente** del default privado de la política: la regla
existe para proteger datos sensibles; en ausencia de estos, el repo público es
correcto.

## Alternativas consideradas

- **Privado + Pages de pago.** Descartada: no hay dato sensible que justifique el
  costo ni la fricción.
- **Privado sin Pages.** Descartada: renuncia a la publicación web, que es parte
  del objetivo del motor.

## Implicancia

El `.gitignore` omite el bloque de datos sensibles (Rama A) pero conserva el
blindaje contra outputs accidentales. El workflow de CI valida en cada push la
ausencia de patrones RUT y de extensiones de datos prohibidas. Si en el futuro
entrara cualquier dato nominal, subir de público a sensible **no es trivial**:
exige limpiar el historial de Git y migrar a privado antes de incorporar el dato.
