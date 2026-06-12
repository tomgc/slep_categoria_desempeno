# Diagnostico de migracion a GitHub — slep_categoria_desempeno

- **Fecha:** 2026-06-12 09:37:38
- **Raiz auditada:** /Users/tomgc/Projects/slep_categoria_desempeno
- **Rama:** A (proyecto 100% publico; datos versionados en el repo).
- **Alcance:** datos personales hardcodeados, credenciales/tokens, rutas absolutas con informacion de usuario, referencias a OneDrive, correos, nombres de archivo fuera de norma.
- **Naturaleza Rama A:** los .xlsx/.parquet de datos son publicos (Agencia de Calidad) y DEBEN versionarse; no se reportan como hallazgo.

## Resumen

| Severidad | N |
|---|---|
| MEDIA | 24 |

**Total de hallazgos:** 24

## Hallazgos detallados

| Severidad | Tipo | Archivo | Linea | Norma | Extracto |
|---|---|---|---|---|---|
| MEDIA | Referencia a OneDrive | `50_documentacion/activa/POLITICA_PROYECTO.md` | 11 | C.7 / gobernanza datos | `> arquitectura de dos raíces (código en Git / datos en OneDrive) pasa a ser` |
| MEDIA | Referencia a OneDrive | `50_documentacion/activa/POLITICA_PROYECTO.md` | 94 | C.7 / gobernanza datos | `viven FUERA del repo, en la raíz de datos de OneDrive (sección 6.2). El` |
| MEDIA | Referencia a OneDrive | `50_documentacion/activa/POLITICA_PROYECTO.md` | 356 | C.7 / gobernanza datos | `- **Raíz de código:** repo Git privado, fuera de OneDrive (típicamente` |
| MEDIA | Referencia a OneDrive | `50_documentacion/activa/POLITICA_PROYECTO.md` | 360 | C.7 / gobernanza datos | `- **Raíz de datos:** carpeta en OneDrive institucional` |
| MEDIA | Referencia a OneDrive | `50_documentacion/activa/POLITICA_PROYECTO.md` | 361 | C.7 / gobernanza datos | `(`.../OneDrive-SLEP/Proyectos/<nombre_proyecto>/`) con `20_insumos/`` |
| MEDIA | Referencia a OneDrive | `50_documentacion/activa/POLITICA_PROYECTO.md` | 474 | C.7 / gobernanza datos | `- **Jamás escanea la raíz de datos en OneDrive.** El snapshot se` |
| MEDIA | Referencia a OneDrive | `50_documentacion/activa/POLITICA_PROYECTO.md` | 545 | C.7 / gobernanza datos | `2. **Raíz de datos** en OneDrive institucional:` |
| MEDIA | Referencia a OneDrive | `50_documentacion/activa/POLITICA_PROYECTO.md` | 654 | C.7 / gobernanza datos | `sección 6.2 (repo Git / OneDrive institucional).` |
| MEDIA | Referencia a OneDrive | `50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md` | 474 | C.7 / gobernanza datos | `(OneDrive). Visibilidad: privado, no negociable sin justificación.` |
| MEDIA | Referencia a OneDrive | `50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md` | 483 | C.7 / gobernanza datos | `(OneDrive, `Users/<nombre>/`); archivos de datos en carpetas` |
| MEDIA | Referencia a OneDrive | `50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md` | 492 | C.7 / gobernanza datos | `no mover**; verificar que OneDrive terminó de sincronizar antes de` |
| MEDIA | Referencia a OneDrive | `50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md` | 522 | C.7 / gobernanza datos | `2. Verificar que OneDrive institucional esté sincronizado y localizar` |
| MEDIA | Ruta absoluta con usuario | `50_documentacion/estructura/20260612_092801_estructura.md` | 3 | C.7 portabilidad | `- **Raiz:** `/Users/tomgc/Projects/slep_categoria_desempeno`` |
| MEDIA | Ruta absoluta con usuario | `50_documentacion/estructura/20260612_092801_estructura.txt` | 2 | C.7 portabilidad | `Raiz   : /Users/tomgc/Projects/slep_categoria_desempeno` |
| MEDIA | Ruta absoluta con usuario | `50_documentacion/estructura/20260612_092909_estructura.md` | 3 | C.7 portabilidad | `- **Raiz:** `/Users/tomgc/Projects/slep_categoria_desempeno`` |
| MEDIA | Ruta absoluta con usuario | `50_documentacion/estructura/20260612_092909_estructura.txt` | 2 | C.7 portabilidad | `Raiz   : /Users/tomgc/Projects/slep_categoria_desempeno` |
| MEDIA | Ruta absoluta con usuario | `50_documentacion/estructura/estructura_actual.md` | 3 | C.7 portabilidad | `- **Raiz:** `/Users/tomgc/Projects/slep_categoria_desempeno`` |
| MEDIA | Ruta absoluta con usuario | `50_documentacion/estructura/estructura_actual.txt` | 2 | C.7 portabilidad | `Raiz   : /Users/tomgc/Projects/slep_categoria_desempeno` |
| MEDIA | Referencia a OneDrive | `diagnostico_migracion_github.R` | 55 | C.7 / gobernanza datos | `# Ruta OneDrive institucional.` |
| MEDIA | Referencia a OneDrive | `diagnostico_migracion_github.R` | 56 | C.7 / gobernanza datos | `RX_ONEDRIVE <- "OneDrive[A-Za-z0-9 ._-]*"` |
| MEDIA | Referencia a OneDrive | `diagnostico_migracion_github.R` | 77 | C.7 / gobernanza datos | `if (str_detect(texto, RX_ONEDRIVE)) agrega("Referencia a OneDrive", "MEDIA", "C.7 / gobernanza datos")` |
| MEDIA | Referencia a OneDrive | `diagnostico_migracion_github.R` | 148 | C.7 / gobernanza datos | `"absolutas con informacion de usuario, referencias a OneDrive, correos, ",` |
| MEDIA | Referencia a OneDrive | `diagnostico_migracion_github.R` | 194 | C.7 / gobernanza datos | `wl("- **MEDIA (rutas absolutas / OneDrive / naming):** rutas con `/Users/<nombre>/` ",` |
| MEDIA | Referencia a OneDrive | `diagnostico_migracion_github.R` | 195 | C.7 / gobernanza datos | `"violan portabilidad (C.7); referencias a OneDrive no deben viajar al repo ",` |

## Interpretacion y recomendaciones

- **CRITICA (credenciales):** detener la migracion. Rotar el secreto y purgar del historial antes de cualquier push.
- **ALTA (RUT):** un RUT en codigo o datos versionados de un proyecto publico es un incidente. Verificar si el dato es realmente publico; si no, removerlo y reescribir el historial.
- **MEDIA (rutas absolutas / OneDrive / naming):** rutas con `/Users/<nombre>/` violan portabilidad (C.7); referencias a OneDrive no deben viajar al repo publico; nombres con tilde/n/espacio se renombran (politica seccion 2).
- **BAJA (correos):** revisar caso a caso. Un correo institucional de contacto puede ser intencional; uno personal en codigo, no.

> Compuerta de gobernanza (protocolo 4.3, Fase 1): este reporte se revisa con el titular ANTES del primer push. La auditoria no decide sola: reporta.
