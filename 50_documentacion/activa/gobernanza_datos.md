# Gobernanza de datos — slep_categoria_desempeno

> **Producto público con incidente de PII saneado.** El producto del proyecto
> (Categoría de Desempeño por RBD y catálogos territoriales) es información
> pública. Sin embargo, el insumo auxiliar `directorio_oficial_ee.csv` (crudo del
> directorio oficial de Mineduc) contenía datos personales identificables
> (columnas `MRUN` y `RUT_SOSTENEDOR`), que estuvieron versionados y publicados en
> el historial de Git desde el 2026-06-11. El incidente se detectó y saneó el
> 2026-07-01 (ver "Incidente de PII" más abajo). Este documento deja constancia de
> los datos que maneja el proyecto, del incidente y del patrón vigente que evita su
> repetición. La clasificación previa ("Rama A, 100% público, sin datos personales")
> queda derogada por este incidente.

## Qué datos maneja el proyecto

- **Categoría de Desempeño por establecimiento (RBD)**, publicada por la
  Agencia de Calidad de la Educación: etiqueta categórica (Alto / Medio /
  Medio-Bajo / Insuficiente) por establecimiento y año, para básica
  (2016-2019) y media (2017-2019).
- **Catálogos territoriales y de establecimientos** (comunas, SLEPs, regiones,
  directorio oficial de EE): identificación administrativa pública.

El producto y los datos intermedios no contienen datos por estudiante, asistencia
nominal ni resultados individuales. **Excepción histórica (saneada):** el crudo del
directorio oficial (`directorio_oficial_ee.csv`) traía `MRUN` y `RUT_SOSTENEDOR`
(RUT del sostenedor, persona natural en sostenedores privados) poblados en las
16.768 filas. Desde el saneamiento del 2026-07-01 el crudo ya no se versiona: solo
se versiona su versión depurada `directorio_oficial_ee_publico.csv` (sin esas
columnas). Ver "Incidente de PII".

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

- **Chile:** Ley 19.628 (vida privada); Ley 21.719 (protección de datos). El
  `RUT_SOSTENEDOR` del crudo del directorio es dato personal de persona natural y
  quedó bajo el alcance de Ley 21.719; por eso el crudo se depura y no se versiona
  (ver "Incidente de PII"). El resto del proyecto (agregados por RBD) no trata
  datos personales.
- **Agencia de Calidad (contractual):** Condiciones de Uso de Bases de Datos.
  La restricción de no-identificación rige las bases por estudiante; este
  proyecto no las usa.

## Almacenamiento

Datos versionados directamente en el repositorio público de GitHub
(`github.com/tomgc/slep_categoria_desempeno`), por ser información pública y
de tamaño moderado. No existe raíz de datos externa ni variable de entorno:
raíz unificada (política, sección 8.2).

## Incidente de PII del directorio oficial (detección y saneamiento 2026-07-01)

- **Qué:** el crudo `20_insumos/auxiliares/directorio_oficial_ee.csv` (directorio
  oficial de establecimientos, Mineduc) contenía las columnas `MRUN` y
  `RUT_SOSTENEDOR` (datos personales identificables), pobladas en 16.768/16.768
  filas.
- **Exposición:** el archivo se versionó y publicó en `origin/main` (repositorio
  público) en el commit `4751373` (2026-06-11, "Sesion 2: pipeline R completo"),
  único commit que lo introdujo; permaneció en el historial hasta el saneamiento.
- **Detección:** 2026-07-01, auditoría de gobernanza (fase de solo lectura).
- **Saneamiento (2026-07-01):** (a) script `31_depurar_directorio_oficial.R` que
  produce la versión pública sin columnas sensibles; (b) repunte del pipeline
  (`30_construir_auxiliares.R`) a esa versión; (c) crudo agregado a `.gitignore` y
  removido del índice; (d) reescritura de **todo** el historial con `git-filter-repo`
  (`--path … --invert-paths`; 116 commits resultantes, blob del crudo eliminado de
  toda la historia); (e) publicación con `git push --force-with-lease`. Verificado:
  `git log --all --full-history` del crudo vacío y `origin/main` sin el archivo en
  ningún blob alcanzable.
- **Alcance:** la Categoría de Desempeño en sí sigue siendo dato público válido; el
  incidente fue exclusivamente el catálogo auxiliar crudo, no el producto.
- **Pendiente operativo:** los colaboradores con clones previos deben **re-clonar**
  el repositorio (el historial fue reescrito; los hashes anteriores ya no existen).

## Patrón vigente del directorio oficial

- El **crudo** `directorio_oficial_ee.csv` (con `MRUN`/`RUT_SOSTENEDOR`) está en
  `.gitignore` y **nunca** se versiona; se conserva solo en local.
- La versión pública `directorio_oficial_ee_publico.csv` (sin columnas sensibles;
  56 columnas, 16.768 filas) se genera con
  `20_insumos/auxiliares/31_depurar_directorio_oficial.R` y **es la única que se
  versiona**.
- El pipeline (`30_construir_auxiliares.R`) lee la versión pública.

## Procedimiento ante duda futura

Si en algún momento se incorpora una fuente que contenga datos por estudiante,
RUT o cualquier dato personal, el proyecto **deja de ser Rama A**: debe migrar
al modelo de dos raíces (política, sección 6), limpiar el historial de Git de
los datos sensibles y reclasificarse. Ante la duda, tratar como sensible.
