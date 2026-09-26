# Datos versionados autorizados (slep_categoria_desempeno)

> Requerido por la regla R1 de `githooks/pre-push` del kit y por I8 de
> `plantillas/95_verificar_cierre.R`, que leen las entradas del **primer bloque
> cercado** de este archivo y descartan lo que va tras la almohadilla.
>
> Escrito el 2026-09-26 (encargo a11b), cuando el primer push de la rama
> `ordenacion/20260925` se detuvo en el hook: el proyecto versiona desde su
> origen insumos públicos de la Agencia de Calidad y catálogos territoriales,
> y no tenía esta lista.
>
> **Esta lista no relaja la gobernanza.** Autoriza la extensión de las rutas
> enumeradas, una por una y sin comodines, no su contenido. R2 (credenciales) y
> R3 (patrón de RUT) siguen corriendo sobre todo lo que viaja en cada push. La
> base de la decisión está en `gobernanza_datos.md`: producto público,
> agregados por establecimiento, sin datos por estudiante, y un directorio
> depurado sin `MRUN` ni `RUT_SOSTENEDOR`.

## Entradas

```
20_insumos/auxiliares/202602_Listado_SLEP_2026_vf.xlsx    # listado oficial de SLEP 2026, público; 0 coincidencias del patrón de RUT de R3 en 4690 celdas y 0 columnas con nombre MRUN, RUN o RUT, medido en R (readxl, todas las hojas) en el a11b, 2026-09-26, con control positivo
20_insumos/auxiliares/caracterizacion_establecimientos.xlsx    # caracterización pública de los establecimientos del SLEP (la columna DV es el dígito del RBD); 0 coincidencias en 592 celdas y 0 columnas MRUN, RUN o RUT, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/auxiliares/diccionario_territorios.xlsx    # catálogo territorial público; 0 coincidencias en 1392 celdas y 0 columnas MRUN, RUN o RUT, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/auxiliares/directorio_oficial_ee_publico.csv    # directorio oficial depurado sin MRUN ni RUT_SOSTENEDOR (gobernanza_datos.md); 0 líneas con el patrón de RUT en 16769 líneas y 0 columnas MRUN, RUN o RUT, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/cdb_2016.xlsx    # Categoría de Desempeño básica 2016, Agencia de Calidad, pública; 0 coincidencias en 58121 celdas y 0 columnas MRUN, RUN o RUT, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/cdb_2017.xlsx    # Categoría de Desempeño básica 2017, pública; 0 coincidencias en 57540 celdas, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/cdb_2018.xlsx    # Categoría de Desempeño básica 2018, pública; 0 coincidencias en 56168 celdas, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/cdb_2019.xlsx    # Categoría de Desempeño básica 2019, pública; 0 coincidencias en 55402 celdas, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/cdm_2017.xlsx    # Categoría de Desempeño media 2017, pública; 0 coincidencias en 20405 celdas, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/cdm_2018.xlsx    # Categoría de Desempeño media 2018, pública; 0 coincidencias en 20559 celdas, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/cdm_2019.xlsx    # Categoría de Desempeño media 2019, pública; 0 coincidencias en 20559 celdas, medido en R en el a11b, 2026-09-26, con control positivo
20_insumos/matricula_rbd_ense.parquet    # matrícula agregada por RBD y tipo de enseñanza, sin datos por estudiante; 0 coincidencias en 1056955 valores y 0 columnas MRUN, RUN o RUT, medido en R (arrow) en el a11b, 2026-09-26, con control positivo
20_insumos/matricula_rbd_grado.parquet    # matrícula agregada por RBD y grado, sin datos por estudiante; 0 coincidencias en 4567495 valores y 0 columnas MRUN, RUN o RUT, medido en R (arrow) en el a11b, 2026-09-26, con control positivo
renv/settings.json    # configuración de renv, no es dato; 0 líneas con el patrón de RUT en 19 líneas, medido en R en el a11b, 2026-09-26
```

## Lo que esta lista NO autoriza

- El crudo `20_insumos/auxiliares/directorio_oficial_ee.csv`, con `MRUN` y
  `RUT_SOSTENEDOR`: sigue fuera de Git por `.gitignore` (ver
  `gobernanza_datos.md`, «Incidente de PII»).
- Ninguna ruta nueva con extensión de datos, aunque viva en `20_insumos/`.
- Comodines: cada ruta entra con su nombre exacto.

## Cómo se amplía

Una ruta nueva con extensión de datos entra solo con una entrada propia, su ruta
exacta y su justificación en la misma línea. La justificación dice cómo se supo
que la ruta está limpia (comando o medición, con control positivo), no solo que
lo está.
