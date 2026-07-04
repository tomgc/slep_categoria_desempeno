# Contrato público — Categoría de Desempeño por establecimiento (v1)

## Archivo

- **Nombre:** `categoria_rbd_contrato.parquet`
- **Ruta:** `40_salidas/categoria_rbd_contrato.parquet`
- **Generado por:** `30_procesamiento/34_exportar_contrato_categoria.R`
- **Origen:** `40_salidas/intermedios/categoria_rbd.parquet` (interno, producido
  por `31_leer_normalizar.R`), con selección de columnas, sin filtrado de filas.

## Columnas

| Columna | Tipo | Dominio de valores |
|---|---|---|
| `rbd` | character | Rol Base de Datos: identificador único del establecimiento. |
| `nivel` | character | `"basica"` \| `"media"`. Nunca se mezclan. |
| `anio` | integer | 2016–2019. |
| `categoria` | character | `"ALTO"`, `"MEDIO"`, `"MEDIO-BAJO"`, `"INSUFICIENTE"`, `"s/i"`. **`"s/i"` es un valor de categoría válido** (sin categoría vigente ese año), **no un `NA`**. |
| `motivo_sin_categoria` | character | `"baja_matricula"` \| `"falta_informacion"` \| `NA`. **Poblado únicamente cuando `categoria == "s/i"`**; `NA` en el resto de las filas. |

Columnas excluidas del contrato (presentes en el intermedio de origen, no
expuestas aquí por ser redundantes para un consumidor que ya mantiene su
propio catálogo territorial, p. ej. vía `slep_minuta_asistencia`): `nom_rbd`,
`cod_com_rbd`, `cod_reg_rbd`, `cod_depe2`.

## Grano

Una fila por **rbd × nivel × año** (41.244 filas en la versión actual). Sin
duplicados dentro de esa llave.

## Cobertura temporal

**2016–2019.** Educación básica cubre los cuatro años; educación media va de
2017 a 2019 (la fuente no publica categoría de media para 2016). El motor
público expone `anio_vigente = 2019` (el año más reciente disponible); este
contrato no filtra por año vigente, expone la serie histórica completa.

## Gobernanza

Dato **público**, publicado por la Agencia de Calidad de la Educación
(clasificación Alto / Medio / Medio-Bajo / Insuficiente, difundida
nominalmente en su portal "Localiza tu colegio"). **Sin restricción** de uso
o redistribución más allá de las condiciones de uso generales de la Agencia.
No contiene datos por estudiante, RUT ni información personal de terceros.

## Advertencia de uso

**Esto es CONTEXTO, no un indicador "positivo" evaluable; no aplica el gate
de criterio positivo de `slep_minuta_buenas_senales`.** La Categoría de
Desempeño es una clasificación de la Agencia de Calidad que ya integra el
contexto socioeconómico del establecimiento en su propia metodología; no es
una señal binaria de "bien/mal" que un consumidor externo deba evaluar como
positiva o negativa bajo un gate propio. Un consumidor que necesite juzgar
"desempeño positivo" debe tratar esta columna como dato descriptivo de
entrada, no como el resultado de esa evaluación.

## Versionado

- **v1** (2026-07-04): primera versión del contrato. 5 columnas: `rbd`,
  `nivel`, `anio`, `categoria`, `motivo_sin_categoria`.
