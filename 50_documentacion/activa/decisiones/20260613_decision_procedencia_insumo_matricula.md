# Procedencia del insumo `matricula_rbd_ense.parquet`

- **Fecha:** 2026-06-13
- **Tipo:** decisión de procedencia / trazabilidad de insumo
- **Sesión que la origina:** 10 (cierra la deuda técnica documental anotada en el
  traspaso v09, §11)

---

## Qué documenta

`20_insumos/matricula_rbd_ense.parquet` es un insumo **versionado** en este repo
pero **generado fuera de él**. Esta nota deja rastreable su origen, esquema y
reglas de construcción desde el propio proyecto, sin obligar a abrir el proyecto
hermano para entenderlo.

## Origen

- **Generado en:** proyecto hermano `slep_analisis_matricula` (proyecto de
  análisis, separado del proyecto de producto; ver A12 del traspaso v09).
- **Script generador:** `03_generar_matricula_rbd_ense.R` (vive en
  `slep_analisis_matricula`, **NO** en este repo).
- **Fuente primaria:** 10 CSV nacionales de matrícula del MINEDUC
  (~5,4 GB en total), leídos UNA sola vez con DuckDB. Esos CSV **no** entran a
  este proyecto: aquí solo vive el agregado liviano (402 KB).
- **Informe del escaneo:** `50_documentacion/activa/decisiones/informe_escaneo_matricula.docx`
  (perfilado de los CSV nacionales que fundamentó, contra datos reales, la
  granularidad de presentación de la matrícula en la ficha).

## Esquema del parquet

| Columna | Tipo | Descripción |
|---|---|---|
| `rbd` | character | Rol Base de Datos del establecimiento (llave) |
| `anio` | integer | Año de la matrícula |
| `cod_ense2` | character | Tipo de enseñanza, `"1"`..`"8"` (Anexo III) |
| `matricula` | integer | `COUNT(*)` por grano `rbd × anio × cod_ense2` |
| `matricula_total_ee` | integer | Suma de TODOS los `cod_ense2` del EE ese año (desnormalizado, repetido por `rbd × anio`) |

- **Grano:** `rbd × anio × cod_ense2`.
- **Cobertura temporal:** 2016–2019 (`ANIOS_OBJETIVO = 2016:2019`). Una sola foto
  histórica inmutable.
- **Dimensiones:** 85.594 filas, 11.988 RBD, 402 KB.

## Reglas de construcción (decisiones de lectura)

- **Matrícula = `COUNT(*)`**, no `COUNT(DISTINCT mrun)` (D14 del traspaso v09):
  cada fila del CSV es una matrícula; es la cifra estándar MINEDUC. A grano
  `rbd × cod_ense2` no hay duplicados (verificado por control `COUNT(*)` vs
  `DISTINCT mrun`).
- **Sin filtro por `estado_estab`** (D14): la matrícula es hecho histórico del
  año; el universo final lo define el join contra RBD con categoría, no el estado
  de funcionamiento actual del establecimiento.
- **`normalize_names = true` + `all_varchar = true`** en DuckDB: los nombres de
  columna vienen en minúsculas en 2016–2017 y en MAYÚSCULAS en 2018–2019;
  `normalize_names` los homologa. `all_varchar` mantiene las llaves como texto
  (consistencia de tipo entre años).

## Reglas de corte nivel ↔ tipo de enseñanza

Mapeo de `cod_ense2` a los niveles del motor (constantes `ENSE2_A_NIVEL` en
`33_generar_html.R`; helper `matriculaNivel` en `33_motor_template.html`):

- **Básica:** `cod_ense2 == "2"` (`BASICA_ENSE2 = 2`).
- **Media:** `cod_ense2 ∈ {"5", "7"}` sumados (`MEDIA_ENSE2 = c(5, 7)`). Media HC
  (5) y TP (7) son dos tipos de enseñanza pero **una sola** categoría de media
  (la Agencia categoriza media como nivel único); se suman, nunca se desglosan
  como categorías separadas (D13 del traspaso v09).
- El resto de `cod_ense2` (parvularia, adultos, especial) son niveles **sin**
  categoría de desempeño: se muestran solo como contexto en el panel expandido.

## Validaciones que pasó al generarse

5 checks en el generador (`03_generar_matricula_rbd_ense.R`), todos en verde:

1. Llave única (`rbd × anio × cod_ense2` sin repetición).
2. `matricula_total_ee` constante dentro de `rbd × anio`.
3. Suma de los `cod_ense2` del EE == `matricula_total_ee`.
4. Sin NAs en columnas clave.
5. Cobertura 2016–2019 completa.

Las matrículas anuales calzan al dígito con el escaneo del informe:
3.550.949 (2016) / 3.558.394 (2017) / 3.582.448 (2018) / 3.624.343 (2019).

## Consumo en este proyecto

`30_procesamiento/33_generar_html.R` carga el parquet (con guard de existencia
que apunta al script generador si falta), expone los diccionarios `ENSE2_LABELS`
y `ENSE2_A_NIVEL` en `meta`, y lo embarca como bloque columnar `matricula_lst`
en el JSON. La matrícula viaja como **bloque JSON separado** de la categoría
(grano distinto) y se cruza en el cliente, nunca se fusiona en R (A13 del
traspaso v09).

## Invariante asociado

La matrícula es **dato de contexto del establecimiento**: informa tamaño, no
pondera la categoría. La agregación de categoría es y sigue siendo **conteo de
establecimientos**, jamás ponderación por matrícula, jamás GSE. Básica y media
nunca se mezclan en una cifra: la matrícula del nivel es monovalente.

## Para regenerar el insumo

Si en el futuro se necesita otro grano (p. ej. por `cod_grado`), se regenera en
`slep_analisis_matricula` cambiando el `GROUP BY` de
`03_generar_matricula_rbd_ense.R`, y se copia el parquet resultante a
`20_insumos/` de este repo a mano. **Nunca** se releen los CSV nacionales en
este proyecto.
