# slep_categoria_desempeno

Motor de comparación interactivo de la **Categoría de Desempeño** de los
establecimientos educacionales (clasificación de la Agencia de Calidad de la
Educación: Alto / Medio / Medio-Bajo / Insuficiente), entre comunas, SLEPs,
regiones y el nivel nacional, separando educación básica y media.

Producto final: un archivo HTML autocontenido publicado en GitHub Pages.

**Sitio publicado:** https://tomgc.github.io/slep_categoria_desempeno/

Proyecto del Área de Monitoreo y Seguimiento del Servicio Local de Educación
Pública Costa Central (Región de Valparaíso). Proyecto hermano de
`slep_simce_adecuado`: comparte arquitectura y patrones de UI.

## Qué hace

Lee los archivos de Categoría de Desempeño publicados por la Agencia de Calidad,
los normaliza y agrega a nivel territorial (comuna, SLEP, región, nacional), y
genera un motor visual interactivo que muestra la distribución de
establecimientos por categoría, con la trayectoria histórica de cada
establecimiento.

Decisiones metodológicas que gobiernan el diseño:

- **Unidad = establecimiento**, dato categórico (una etiqueta por RBD por año).
- **Agregación = conteo de establecimientos** por categoría. No hay ponderación
  por matrícula ni promedio de porcentajes.
- **Sin segmentación por GSE:** la Categoría de Desempeño ya integra el contexto
  socioeconómico en su construcción.
- **Básica y media nunca se mezclan** en una cifra agregada.

## Cómo correr el pipeline

Requiere R 4.5.x. El orquestador ejecuta el pipeline completo de principio a fin:

```r
source("00_run_all.R")
run_all()
```

Etapas (carpeta `30_procesamiento/`):

1. `30_construir_auxiliares.R` — catálogos territoriales y de establecimientos.
2. `31_leer_normalizar.R` — lectura multi-año y normalización de la categoría.
3. `32_agregar_territorial.R` — agregación territorial (conteo de EE).
4. `33_generar_html.R` — construye `40_salidas/motor_categoria.html` y copia a
   `docs/index.html` para publicación.

El motor HTML embebe **inline** React 18.3.1, ReactDOM 18.3.1, D3 v7 y pako (los
cuatro versionados en `10_utils/`). La única dependencia de red en runtime es
Babel 7.29.0 (CDN unpkg, con SRI).

## Verificación de cifras antes de publicar

Las cifras que muestra el motor se certifican por doble cálculo. Un set de
scripts en `tests/` recalcula cada conteo de forma independiente del pipeline y
lo contrasta contra lo que efectivamente viaja dentro del HTML publicado, de
modo que ninguna cifra llegue a Pages sin haber sido verificada.

Para certificar, corre:

```r
source(here::here("tests", "auditar_cifras.R"))
source(here::here("tests", "spot_check_publicado.R"))
```

Conviene que los corras tras cada regeneración del motor (`run_all()` o
`regenerar_motor()`) y antes de `git push`. Estos scripts **no** son parte de
`run_all()` por diseño: la auditoría es un camino independiente del de
producción, para que la verificación no dependa del mismo código que genera las
cifras.

## Estructura

Sigue la convención canónica de carpetas numeradas por flujo de ejecución
(`10_utils`, `20_insumos`, `30_procesamiento`, `40_salidas`, `50_documentacion`),
documentada en `50_documentacion/activa/POLITICA_PROYECTO.md`.

## Datos

Los datos provienen de la **Agencia de Calidad de la Educación** de Chile
(archivos `CDB`/`CDM` de Categoría de Desempeño, directorio oficial de
establecimientos). Son información **pública** y se versionan directamente en
este repositorio (`20_insumos/`).

Este proyecto **no** maneja, en ningún punto, datos por estudiante, RUT ni
información personal de terceros. Ver `50_documentacion/activa/gobernanza_datos.md`
para la base de esta clasificación.

## Publicación (GitHub Pages)

El sitio se sirve desde la carpeta `docs/` en la rama `main` (modelo de archivo
único). `docs/index.html` es una copia derivada de `40_salidas/motor_categoria.html`,
regenerada automáticamente en cada corrida del paso 33. La fuente de verdad es
`40_salidas/`; `docs/` no se edita a mano.

Para activar Pages: Settings → Pages → Source: Deploy from a branch → Branch:
`main` / carpeta `/docs`.

## Licencia

Código bajo licencia **MIT** (ver `LICENSE`). La licencia cubre el código del
repositorio; **no** cubre los datos, que se rigen por las condiciones de uso de
la Agencia de Calidad de la Educación.

<!-- portabilidad-cross-os: bloque generado, no editar a mano -->

## Portabilidad cross-OS

Este proyecto se clona, configura y ejecuta igual en macOS y en Windows. El contrato completo está en `herramientas_dev/gobernanza/portabilidad_os/protocolo_portabilidad_cross_os.md`.

### Configuración de una máquina nueva

1. Instalar Git, R y Positron.
2. Clonar el repositorio **fuera de OneDrive** (por ejemplo `~/Projects/slep_categoria_desempeno`).
3. Copiar `.Renviron.example` a `~/.Renviron` y declarar la raíz de datos. Basta **una línea**:

   ```text
   WORKSPACE_DATA_ROOT=<carpeta de proyectos en el OneDrive institucional>
   ```

   El proyecto se resuelve como `<WORKSPACE_DATA_ROOT>/slep_categoria_desempeno`. Si necesita otra ubicación, declarar `SLEP_CATEGORIA_DESEMPENO_DATA_ROOT`, que gana sobre la global. Reiniciar R después de editar.
4. Verificar que la raíz de datos esté sincronizada y accesible.
5. Restaurar el entorno de paquetes:

   ```r
   renv::restore()
   ```

   `renv.lock` es la única fuente de verdad de paquetes y versiones. No instalar con `install.packages()` a mano.

### Validación del entorno

Antes de ejecutar nada, con la sesión de R abierta en la raíz del repo:

```r
source(here::here("10_utils", "10_validar_portabilidad.R"))
validar_portabilidad()
```

Debe quedar sin fallas críticas. Comprueba el ancla de `here`, la locale UTF-8, `renv.lock`, que `.Renviron` no esté versionado, que `.Renviron.example` exista, y que la raíz de datos resuelva y sea escribible. Para comprobar que el propio verificador detecta violaciones: `validar_portabilidad_autotest()`.

### Ejecutar el proyecto

```r
source(here::here("00_run_all.R"))
```

### Matriz de dependencias de sistema

Lo que `renv` no resuelve se instala en la máquina antes de ejecutar el pipeline.

| Dependencia | macOS | Windows | Necesaria |
|---|---|---|---|
| Git | sí | sí | sí |
| R (4.2 o superior) | sí | sí | sí |
| Positron | sí | sí | recomendado |
| OneDrive institucional | sí | sí | sí (raíz de datos) |

Si el proyecto necesita binarios externos (ODBC, Java, Ghostscript, LibreOffice, Quarto, Typst), declararlos en esta tabla con su versión: el protocolo prohíbe depender de que un comando esté "casualmente" en el `PATH`.

