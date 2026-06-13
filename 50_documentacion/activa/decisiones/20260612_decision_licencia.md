# Decisión: licencia MIT con cláusula de datos

**Fecha:** 2026-06-12
**Sesión:** 6 (documentación retroactiva de una decisión tomada en la sesión 4, v04)
**Tipo:** decisión de gobernanza / legal
**Estado:** vigente

## Contexto

Al publicar el repositorio (público) hay que declarar la licencia del código. La
política (sección 10) admite MIT por defecto y Apache 2.0 cuando se requiera
concesión expresa de patentes o un archivo `NOTICE`. Además, los datos provienen
de la Agencia de Calidad, cuyas Condiciones de Uso de Bases de Datos prohíben
transferir las bases a terceros.

## Decisión

Licencia **MIT**, con una **cláusula explícita** de que cubre solo el código y
**no** los datos (Agencia de Calidad).

## Justificación

1. **MIT es permisiva y estándar** para herramientas de análisis reproducible;
   facilita la reutilización del código sin fricción.
2. **No se requiere Apache 2.0:** el proyecto no necesita concesión expresa de
   patentes ni archivo `NOTICE`. La política reserva Apache para publicación
   institucional con esos requisitos, que aquí no aplican.
3. **La cláusula de datos protege el límite contractual** con la Agencia: deja
   claro que la libertad de la licencia alcanza al código, no a las bases.

## Alternativas consideradas

- **Apache 2.0.** Descartada: añade concesión de patentes y `NOTICE` que este
  caso no necesita; mayor peso sin beneficio.
- **Sin licencia.** Descartada: sin licencia el código queda como "todos los
  derechos reservados" y no es legalmente reutilizable, lo que contradice el
  espíritu de publicarlo.

## Implicancia

`LICENSE` vive en la raíz del repo. Los scripts del pipeline llevan encabezado de
copyright más referencia a `LICENSE` (ver `33_generar_html.R`). La licencia no
habilita redistribuir los datos: quien clone el repo obtiene el código, pero debe
obtener las bases por su cuenta desde la fuente pública de la Agencia.
