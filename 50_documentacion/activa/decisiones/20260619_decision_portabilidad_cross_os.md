# Decisión: portabilidad cross-OS (normalización de fin de línea)

- **Fecha:** 2026-06-19
- **Sesión:** 24
- **Estado:** vigente
- **Ámbito:** infraestructura del repositorio (no afecta el pipeline ni el producto)

## Contexto

El proyecto debe poder clonarse y ejecutarse indistintamente en macOS
(entorno de desarrollo actual) y en Windows (otras máquinas del equipo). Se
auditó el código en busca de los puntos donde la portabilidad cross-OS se
juega habitualmente en proyectos R.

## Hallazgo de la auditoría

El código ya era agnóstico al sistema operativo en todos los puntos
materiales:

- **Rutas:** `here::here()` y `file.path()` en todos los scripts; cero rutas
  absolutas, cero `setwd`, cero separadores literales.
- **Encoding:** UTF-8 explícito en cada lectura (`readLines(encoding = "UTF-8")`,
  `readr::locale(encoding = "UTF-8")`) y escritura.
- **Literales no-ASCII:** escritos como `\uXXXX` en el generador del motor, para
  no depender del locale del sistema (un locale C en Windows rompería los
  literales con tilde o ñ al serializar el JSON).
- **Escritura del HTML:** binaria (`file(open = "wb")` + `charToRaw(enc2utf8())`),
  lo que evita la conversión automática de fin de línea de Windows en el
  producto.
- **Sin llamadas a shell** (`system`, `system2`, `shell`) que pudieran depender
  del intérprete del sistema operativo.

No se requirió ningún cambio de código.

## Decisión

Se agrega un `.gitattributes` en la raíz del repositorio que fija fin de línea
**LF** para todo archivo de texto y marca como binarios los formatos de datos,
fuentes e imágenes:

```
* text=auto eol=lf
```

más declaración explícita por extensión (texto: `.R`, `.js`, `.jsx`, `.html`,
`.css`, `.md`, `.json`, `.yml`, `.csv`, etc.; binario: `.parquet`, `.xlsx`,
`.pdf`, `.otf`, `.png`, etc.). Tras crearlo se renormalizó el repositorio
(`git add --renormalize`) para que el contenido ya versionado quede en LF.

## Alternativas consideradas

- **(A) No hacer nada y confiar en la configuración local de cada clon.**
  Descartada: sin `.gitattributes`, el comportamiento depende de
  `core.autocrlf` de cada máquina, que varía. Un clon en Windows con la
  configuración por defecto materializaría CRLF.
- **(B) Marcar los `.min.js` como binarios** (`-text`) para congelarlos byte a
  byte. Descartada como innecesaria: el `.gitattributes` con `eol=lf` los
  normaliza sin efecto adverso (no se editan a mano), y el generador del motor
  reescribe el HTML en binario de todos modos.

## Por qué importa en este proyecto en particular

Tres puntos donde un CRLF filtrado causaría daño real:

1. **Motor ensamblado.** `33_generar_html.R` lee `33_motor_template.html` y los
   `.js` de `10_utils/`, los ensambla y reescribe el HTML. Un template clonado
   con CRLF metería caracteres `\r` en el producto servido.
2. **Verificación por AST de la fuente JSX (A37).** La fidelidad de `33_app.jsx`
   se verifica retranspilando y comparando contra el `React.createElement` del
   template. Un `.jsx` con CRLF introduciría diferencias de formato que
   complican esa comparación.
3. **Snapshots versionados.** El escáner y la auditoría escriben con
   `writeLines(useBytes = TRUE)`, que respeta el fin de línea de la plataforma.
   Sin normalización Git, los snapshots alternarían LF/CRLF entre máquinas,
   produciendo diffs espurios.

## Implicancia

- El repositorio es portable macOS ↔ Windows sin cambios de código.
- Regla operativa: el `.gitattributes` se mantiene en la raíz; cualquier nueva
  extensión de texto que se incorpore al proyecto se declara ahí.
- No afecta al pipeline, a las cifras ni al producto publicado.
