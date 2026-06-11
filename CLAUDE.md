# CLAUDE.md — slep_categoria_desempeno

## Descripción

Motor de comparación interactivo de la **Categoría de Desempeño** de los
establecimientos (clasificación de la Agencia de Calidad: Alto / Medio /
Medio-Bajo / Insuficiente). Producto final: `motor_categoria.html` standalone
con JSON embebido, publicado en GitHub Pages
(`https://tomgc.github.io/slep_categoria_desempeno/`).

Proyecto **hermano** de `slep_simce_adecuado`: comparte arquitectura, catálogos
de entidades y patrones de UI, pero rompe tres invariantes del madre por diseño
(ver más abajo).

## Stack tecnológico

**Pipeline de datos (R)**
- R en Positron.
- Paquetes: `readxl`, `arrow`, `dplyr`, `tidyr`, `purrr`, `here`, `jsonlite`.
- Rutas relativas con `here::here()`. Cero rutas absolutas.

**Frontend (HTML standalone)**
- React 18 + Babel Standalone (CDN — requiere internet solo en primera carga).
- D3.js v7 inlineado en el HTML (offline tras primera carga).
- Sin bundler, sin servidor: un único archivo `.html` autocontenido.
- JSON de datos embebido y comprimido (gzip + pako), como el madre.

## Diferencias clave con el proyecto madre (decisiones metodológicas)

El madre mide un **porcentaje continuo ponderado por estudiantes, segmentado por
GSE**. Este proyecto mide una **etiqueta categórica por establecimiento**. De ahí
tres rupturas que gobiernan todo el diseño:

1. **Unidad = establecimiento, dato categórico.** Una etiqueta por RBD por año
   (Alto / Medio / Medio-Bajo / Insuficiente), no un porcentaje.
2. **Sin ponderación por `nalu`.** No se promedia: se **cuenta** EE por categoría.
   La agregación a comuna/SLEP/región/Chile es la **distribución de
   establecimientos por categoría**, con su total.
3. **Sin segmentación GSE.** La Categoría de Desempeño ya integra el contexto
   socioeconómico en su construcción. Es la contraparte explícita del "GSE
   inviolable" del madre. Documentado en `decisiones/`.

## Modelo de visualización

- **Vista general (por territorio):** cuatro columnas, una por categoría, en
  orden semántico **Insuficiente → Medio-Bajo → Medio → Alto**. Cada columna:
  (a) encabezado de categoría; (b) descriptivos (n de EE, % del territorio);
  (c) lista de establecimientos en esa categoría.
- **Fila de establecimiento:** categoría actual (= categoría del **último año
  disponible**) + señalética de **trayectoria histórica** a la derecha (chips de
  color por año, estilo "Last 5"). Año sin medición → chip gris "s/i", sin romper
  la continuidad temporal (hueco de pandemia explícito).
- EE sin categoría en el último año → sección **"Sin categoría vigente"** aparte
  (no se fuerza dentro de las cuatro columnas).

## Convenciones del proyecto

- snake_case en todo.
- IDs numéricos (rbd, cod_com, cod_grupo) como `character`.
- Mensajes de commit y comentarios de código en español.
- Paleta fija de 4 categorías, orden semántico Insuficiente → Alto.
- Convenciones numéricas chilenas en la UI: coma decimal, punto de miles.
- HTML final standalone (JSON embebido y comprimido).
- `dplyr::` prefijado en todo (sin `library(dplyr)`). Ídem demás paquetes.
- `here::here()` para todas las rutas dentro de scripts.

## Esquema de la fuente

Un archivo `CDB20XX.xlsx` por año (una fila por establecimiento-año). Columnas:
RBD, Matrícula, Comuna, Dependencia (texto), Región, Nombre Establecimiento,
**Categoría Desempeño** (ALTO / MEDIO / MEDIO-BAJO / INSUFICIENTE).

Implicancias del pipeline (a confirmar en la inspección):
- `Dependencia` viene como texto → homologar a `cod_depe2` del madre.
- Falta `cod_com_rbd` → cruzar por RBD contra el directorio oficial del madre.
- Régimen: básica desde 2016, media desde 2017.

## Sensibilidad de datos

Rama A (público). La Categoría de Desempeño por RBD es información pública
(portal Agencia de Calidad, "Localiza tu colegio"). Raíz unificada, datos
versionados en el repo, `.gitignore` estándar sin bloque de datos, sin data root
externo. Gobernanza heredada de la decisión B2 del madre (la prohibición de
identificar EE aplica a bases por estudiante, no a agregados públicos por RBD);
documentada en `decisiones/`.

## Estado

**Sesión 1 (scaffold):** Paso 0 completado — estructura canónica, stubs, git
local, repo remoto privado, primer escaneo. Pipeline aún sin pasos.

## Pendientes inmediatos

| # | Título | Tipo |
|---|--------|------|
| 1 | Inspección del esquema real contra CDB20XX.xlsx | Pipeline |
| 2 | Pipeline: lectura multi-año → normalización → conteo territorial | Pipeline |
| 3 | Motor HTML: grilla de 4 columnas + filas de EE con trayectoria | UI |
| 4 | Publicación en GitHub Pages | Despliegue |
