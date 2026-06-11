# Decisión: identificación de establecimientos en agregados públicos por RBD

**Fecha:** 2026-06-11
**Sesión:** 1 (scaffold)
**Tipo:** decisión de gobernanza de datos
**Estado:** vigente

## Contexto

Las Condiciones de Uso de Bases de Datos de la Agencia de Calidad prohíben
"identificar establecimientos por nombre en ningún output". La fuente de este
proyecto (`CDB20XX.xlsx`) trae la columna `Nombre Establecimiento`, y el producto
final (motor HTML) lista establecimientos individuales con su nombre.

## Decisión

Se mantiene el criterio ya resuelto en el proyecto madre `slep_simce_adecuado`
(sesión 13, decisión B2): **la prohibición de identificar establecimientos de las
Condiciones de Uso aplica a las bases por estudiante, no a los agregados públicos
por RBD.** La Categoría de Desempeño por establecimiento se puede mostrar con
nombre.

## Justificación

1. **La Categoría de Desempeño por establecimiento es información pública por
   diseño.** La Agencia de Calidad la publica nominalmente en su portal y en la
   herramienta "Localiza tu colegio". Cualquier persona puede consultar la
   categoría de un colegio identificado por su nombre.
2. **La restricción de las Condiciones de Uso protege datos por estudiante**
   (resultados individuales, datos nominales de menores), no clasificaciones
   institucionales que la propia Agencia difunde abiertamente.
3. **Consistencia con el proyecto madre**, que ya opera bajo este criterio para
   los popups de establecimientos.

## Alternativas consideradas

- **Mostrar solo RBD sin nombre.** Descartada: degradaría la usabilidad sin
  ganancia de protección, dado que la categoría nominal ya es pública en la
  fuente oficial.
- **Pedir confirmación legal antes de publicar.** Innecesario: el criterio ya
  fue establecido en el madre y la naturaleza pública de la fuente no cambió.

## Implicancia

El motor puede listar establecimientos con `Nombre Establecimiento`. No se
versiona ni publica ningún dato por estudiante (este proyecto no los procesa).
