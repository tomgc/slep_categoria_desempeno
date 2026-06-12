# Gobernanza de datos — slep_categoria_desempeno

> Proyecto **Rama A** (datos 100% públicos). Este documento es una nota de
> gobernanza ligera: deja constancia de qué datos maneja el proyecto, por qué
> son públicos y cuál es la base de esa clasificación. No sigue el formato
> completo exigido a proyectos con datos sensibles (Rama B), porque el proyecto
> no trata datos personales.

## Qué datos maneja el proyecto

- **Categoría de Desempeño por establecimiento (RBD)**, publicada por la
  Agencia de Calidad de la Educación: etiqueta categórica (Alto / Medio /
  Medio-Bajo / Insuficiente) por establecimiento y año, para básica
  (2016-2019) y media (2017-2019).
- **Catálogos territoriales y de establecimientos** (comunas, SLEPs, regiones,
  directorio oficial de EE): identificación administrativa pública.

Ninguna base contiene datos por estudiante, RUT, nombres de personas,
asistencia nominal ni resultados individuales.

## Por qué los datos son públicos

La Categoría de Desempeño por RBD es información de acceso público, difundida
por la Agencia de Calidad de la Educación a través del portal "Localiza tu
colegio" y publicaciones oficiales. Es un agregado a nivel de establecimiento,
no un dato por estudiante.

## Base de la decisión (heredada del proyecto madre)

El proyecto hermano `slep_simce_adecuado` estableció (decisión B2) que la
cláusula de las Condiciones de Uso de Bases de Datos de la Agencia de Calidad
que prohíbe identificar establecimientos por nombre aplica a las **bases por
estudiante** (SIMCE, IDPS individuales), no a los **agregados públicos por
RBD**. La Categoría de Desempeño es precisamente un agregado público por RBD:
identificar al establecimiento es inherente al dato y a su difusión oficial.

En consecuencia:

- El proyecto **sí** nombra establecimientos: es información pública y el
  producto carece de sentido sin ella.
- El proyecto **no** maneja, en ningún punto del pipeline, datos por estudiante
  ni información personal de terceros.

## Marco normativo de referencia

- **Chile:** Ley 19.628 (vida privada); Ley 21.719 (protección de datos,
  vigente desde diciembre 2026). Ninguna aplica como restricción operativa
  aquí, al no tratarse datos personales; se citan como marco general.
- **Agencia de Calidad (contractual):** Condiciones de Uso de Bases de Datos.
  La restricción de no-identificación rige las bases por estudiante; este
  proyecto no las usa.

## Almacenamiento

Datos versionados directamente en el repositorio público de GitHub
(`github.com/tomgc/slep_categoria_desempeno`), por ser información pública y
de tamaño moderado. No existe raíz de datos externa ni variable de entorno:
raíz unificada (política, sección 8.2).

## Procedimiento ante duda futura

Si en algún momento se incorpora una fuente que contenga datos por estudiante,
RUT o cualquier dato personal, el proyecto **deja de ser Rama A**: debe migrar
al modelo de dos raíces (política, sección 6), limpiar el historial de Git de
los datos sensibles y reclasificarse. Ante la duda, tratar como sensible.
