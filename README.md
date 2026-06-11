# slep_categoria_desempeno

Motor de comparación interactivo (React 18 + D3 v7, HTML autocontenido) de la
**Categoría de Desempeño** de los establecimientos educacionales
(Alto / Medio / Medio-Bajo / Insuficiente), clasificación integral de la Agencia
de Calidad de la Educación. Compara territorios (comuna, SLEP, región, Chile,
grupos personalizados) y establecimientos del SLEP Costa Central a lo largo del
tiempo. Publicado en GitHub Pages.

Proyecto hermano de [`slep_simce_adecuado`](https://github.com/tomgc/slep_simce_adecuado).

## Qué lo distingue del proyecto madre

Donde el madre mide un porcentaje continuo ponderado por estudiantes y segmentado
por GSE, este proyecto trabaja una **etiqueta categórica por establecimiento**:

- **Unidad = establecimiento** (una categoría por RBD por año), no un porcentaje.
- **Agregación por conteo**: la vista territorial es la distribución de
  establecimientos por categoría, no un promedio.
- **Sin segmentación GSE**: la categoría ya integra el contexto socioeconómico
  en su construcción (decisión metodológica documentada en
  `50_documentacion/activa/decisiones/`).

## Estructura

Estructura canónica por decenas según
[`POLITICA_PROYECTO.md`](50_documentacion/activa/POLITICA_PROYECTO.md):

```
00_build.R                 Orquestador del pipeline
00_escanear_proyecto.R     Escáner de estructura (auto-poda: retiene 2 sellos)
10_utils/                  Funciones transversales (bootstrapping)
20_insumos/                Datos crudos (CDB20XX.xlsx) y auxiliares — públicos
30_procesamiento/          Lectura, normalización, conteo territorial, motor HTML
40_salidas/                Parquets intermedios y producto final HTML
50_documentacion/          Activa, traspasos, andamios, estructura
tests/                     Tests (testthat)
```

## Cómo correr el pipeline

```r
source("00_build.R")
```

(Pendiente: el pipeline está en scaffold; los pasos se agregan por sesión.)

## Datos

Todos los datos son **públicos** (Agencia de Calidad de la Educación) y se
versionan en el repo. La Categoría de Desempeño por establecimiento es pública
por diseño (portal "Localiza tu colegio"). Este repositorio no contiene datos
personales ni por estudiante.

## Fuente

Bases de Categoría de Desempeño (CDB), Agencia de Calidad de la Educación, Chile.
