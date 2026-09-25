# Traspaso de cierre v04 — slep_categoria_desempeno

## 1. Identificacion

- **Proyecto:** slep_categoria_desempeno
- **Version del traspaso:** v04
- **Fecha:** 2026-06-12
- **Sesion:** 4, foco unico: migracion del proyecto a GitHub (Rama A, protocolo 4.3) y publicacion en GitHub Pages.
- **Entorno:** R 4.5.2 en Positron (macOS aarch64). Todo el trabajo se hizo por terminal y consola R (sin Claude Code esta sesion).
- **Modelo:** Claude Opus 4.8.
- **Archivos principales modificados/creados:**
  - `LICENSE` (nuevo, raiz; MIT con clausula de datos)
  - `50_documentacion/activa/gobernanza_datos.md` (nuevo; gobernanza ligera Rama A)
  - `50_documentacion/activa/decisiones/20260612_auditoria_migracion_github.md` (nuevo; evidencia de la auditoria)
  - `.github/workflows/validacion_seguridad.yml` (nuevo; CI de seguridad)
  - `30_procesamiento/33_generar_html.R` (modificado; header MIT + copia automatica a docs/)
  - `docs/index.html` (nuevo; copia publicada por Pages)
  - `README.md` (reescrito; seccion 10 de la politica)
  - `~/herramientas_dev/scripts/diagnostico_migracion_github.R` (nuevo; instrumental, FUERA del repo)

---

## 2. Resumen ejecutivo

Se completo la migracion del proyecto a GitHub y su publicacion en GitHub Pages,
unico foco de la sesion. El repo ya existia (creado en el scaffold de la sesion
1) y tenia 2 commits sin pushear, por lo que el protocolo 4.3 se reordeno: no
fue migracion desde cero sino auditoria + gobernanza + publicacion sobre un repo
preexistente. Se confirmo visibilidad PUBLIC (coherente con Rama A: datos
publicos de la Agencia + destino Pages). Se corrio la auditoria de seguridad
pre-migracion (`diagnostico_migracion_github.R` adaptado a Rama A): 24 hallazgos,
todos MEDIA, ninguno critico ni alto (menciones documentales de "OneDrive" en la
politica, auto-referencias del propio script, y rutas `/Users/tomgc/` en
snapshots del escaner que coinciden con el usuario publico de GitHub); ningun
bloqueo. Se decidio el modelo de publicacion B (HTML servido desde `docs/`,
archivo unico, alineado con el madre) y se parcheo el generador para copiar
automaticamente a `docs/index.html` en cada corrida. Se genero `gobernanza_datos.md`
(ligero, Rama A), `LICENSE` (MIT con clausula de datos) y un workflow de CI que
valida ausencia de tokens, RUT y datos fuera de carpeta en cada push. Se armaron
cuatro commits tematicos, se pusheo (6 commits totales al remoto), el CI paso en
verde a la primera, se activo Pages via `gh api` y el sitio respondio HTTP 200 en
`https://tomgc.github.io/slep_categoria_desempeno/`.

---

## 3. Estado al cierre

### Funciona (ultima ejecucion exitosa: 2026-06-12)
- Pipeline R completo 30 -> 31 -> 32 -> 33 (heredado, sin cambios de logica).
- `33_generar_html.R` parcheado: genera `40_salidas/motor_categoria.html` (928 KB)
  y copia automaticamente a `docs/index.html`. Verificado: cierra con
  `OK: docs/index.html (copia para GitHub Pages)`.
- Repo en GitHub (`github.com/tomgc/slep_categoria_desempeno`, PUBLIC) con 6
  commits; working tree limpio; `origin/main` al dia.
- CI `validacion-seguridad`: paso en verde (7s) en su primera ejecucion.
- GitHub Pages activo (source `main` / `/docs`, HTTPS forzado); sitio responde
  HTTP 200 en `https://tomgc.github.io/slep_categoria_desempeno/`.

### No funciona / no existe aun
- Pendientes de UI/pipeline sin abordar (diferidos desde v03): P-ee-trayectoria,
  P-metodologia, P-ficha-datos, P-filtro-riesgo, P-vista-ee.
- P-decisiones (v03): los dos archivos de decision de la sesion 3
  (cobertura temporal, paleta) siguen sin crearse. No se abordaron esta sesion
  por foco unico en la migracion.

### Delta respecto a v03
- Proyecto publicado en GitHub Pages (antes solo local).
- Nuevos: `LICENSE`, `gobernanza_datos.md`, auditoria en `decisiones/`, workflow
  de CI, carpeta `docs/`.
- `33_generar_html.R`: header Apache -> MIT; copia automatica a `docs/`.
- `README.md` reescrito completo.

---

## 4. Registro detallado de cambios

### Cambio 22 — Auditoria de seguridad pre-migracion
- **Categoria:** Scaffold e inicializacion.
- **Que:** script `diagnostico_migracion_github.R` adaptado a Rama A (reporta
  info sensible, NO expulsa datos publicos). Escanea RUT, tokens, rutas absolutas
  con usuario, referencias a OneDrive, correos y naming fuera de norma. Output
  `diagnostico_migracion_github.md` con severidad y norma por hallazgo.
- **Por que (C.11):** compuerta de gobernanza obligatoria del protocolo 4.3 antes
  del primer push; los 2 commits pendientes (motor + traspaso v03) nunca habian
  pasado auditoria.
- **Como se verifico (B.4):** corrio sobre 63 archivos (30 de texto); 24
  hallazgos MEDIA, 0 criticos/altos; revisados uno a uno con el titular y
  clasificados como benignos.
- **Destino:** el reporte se archivo como evidencia en
  `decisiones/20260612_auditoria_migracion_github.md`; el script se movio a
  `~/herramientas_dev/scripts/` (instrumental reutilizable, fuera del repo).

### Cambio 23 — gobernanza_datos.md (Rama A ligera)
- **Categoria:** Scaffold e inicializacion.
- **Que:** nota de gobernanza que documenta que datos maneja el proyecto, por que
  son publicos, la base heredada de la decision B2 del madre (la prohibicion de
  identificar EE aplica a bases por estudiante, no a agregados publicos por RBD),
  el marco normativo de referencia y el procedimiento si en el futuro entra un
  dato sensible (reclasificar a Rama B).
- **Por que (C.11):** `gobernanza_datos.md` es obligatorio solo en Rama B; aqui
  se genero una version ligera por prudencia, al ser repo publico que nombra
  establecimientos. Deja registro de la decision.
- **Como se verifico (B.4):** presente en `50_documentacion/activa/`, versionado.

### Cambio 24 — LICENSE (MIT con clausula de datos)
- **Categoria:** Scaffold e inicializacion.
- **Que:** licencia MIT a nombre de Tomas Ignacio Gonzalez Cifuentes — SLEP Costa
  Central, con nota explicita de que cubre el codigo y NO los datos (Agencia de
  Calidad).
- **Por que (C.11):** politica seccion 10; MIT por defecto. Se eligio MIT sobre
  Apache para alinear con el LICENSE ya decidido y mantener una sola licencia en
  los proyectos gemelos.
- **Como se verifico (B.4):** en la raiz; el header del generador se alineo a MIT
  (antes declaraba Apache 2.0 por remanente de plantilla).

### Cambio 25 — Workflow de CI de seguridad
- **Categoria:** Scaffold e inicializacion.
- **Que:** `.github/workflows/validacion_seguridad.yml`. Tres jobs en push y PR a
  main: detectar tokens (ghp_/github_pat_/AKIA), detectar RUT en codigo, verificar
  que no haya .parquet/.rds/.feather fuera de 20_insumos/ o 40_salidas/. Excluye
  10_utils/ y .git de los escaneos de tokens.
- **Por que (C.11):** matiz del protocolo 4.3 para GitHub Free (sin branch
  protection en repos publicos sin plan): el workflow sustituye con validacion
  automatica en cada push.
- **Como se verifico (B.4):** `gh run list` mostro `validacion-seguridad` en
  verde (7s) tras el push.

### Cambio 26 — Publicacion en Pages (modelo B, docs/ + copia automatica)
- **Categoria:** Diseno UI / motor.
- **Que:** `33_generar_html.R` copia el HTML generado a `docs/index.html` (Bloque
  7); Pages sirve desde `main` / `/docs`. El producto canonico sigue en
  `40_salidas/` (fuente de verdad); `docs/` es copia derivada.
- **Por que (C.11):** modelo B elegido sobre A (rama gh-pages) por simplicidad
  (archivo unico standalone, sin build) y consistencia con el madre.
- **Como se verifico (B.4):** corrida del generador cierra con
  `OK: docs/index.html`; tras el push y `gh api` de activacion, el sitio respondio
  HTTP 200.

### Cambio 27 — README de migracion
- **Categoria:** Scaffold e inicializacion.
- **Que:** README reescrito conforme a la politica seccion 10 (que hace, como
  correr el pipeline, estructura, datos, publicacion Pages, licencia).
- **Por que (C.11):** el README previo era el stub del scaffold; la publicacion
  publica exige un README que explique el proyecto a un tercero.
- **Como se verifico (B.4):** versionado; coherente con el sitio publicado.

---

## 5. Backlog acumulativo

### Objetivo del proyecto
slep_categoria_desempeno es un motor interactivo (R + HTML autocontenido) que
compara la distribucion de establecimientos por Categoria de Desempeno (Alto /
Medio / Medio-Bajo / Insuficiente) de la Agencia de Calidad, entre comunas,
SLEPs, regiones y el nivel nacional, separando basica y media. Pipeline en R
(xlsx -> parquet -> JSON embebido -> HTML), publicado en GitHub Pages. Para el
equipo de Monitoreo del SLEP Costa Central, desde 2026. Datos publicos.

(Nota v03: la opcion "nacional" del selector se elimino en la sesion 3 por
volumen de EE; se agrego seleccion de establecimiento individual. El objetivo
permanente del proyecto no cambia.)

(Nota v04: el proyecto quedo publicado en GitHub Pages en
`https://tomgc.github.io/slep_categoria_desempeno/`. El objetivo permanente no
cambia.)

### Nota metodologica del conteo
Un "cambio" es una solicitud distinguible del titular, no las acciones tecnicas
que la implementan. No cuentan los errores del asistente corregidos de
inmediato; si cuentan los bugfixes reportados por el titular. Clasificacion por
intencion primaria. Fuentes: registro de la sesion.

### Clasificacion tematica (refinada en sesion 2; sin cambios de taxonomia en sesiones 3-4)
| Categoria | N | % | Descripcion |
|---|---|---|---|
| Scaffold e inicializacion | 14 | 52 | Estructura, scaffold, decisiones v01, migracion GitHub (v04) |
| Diseno UI / motor | 7 | 26 | Diseno de grillas (v01); motor HTML + iteraciones (v03); publicacion Pages (v04) |
| Pipeline R | 3 | 11 | Pasos 30-32 de procesamiento |
| Orquestacion | 1 | 4 | 00_run_all.R |
| Datos y normalizacion | 1 | 4 | Esquema xlsx, normalizacion categoria |

(En sesion 4 "Scaffold e inicializacion" crecio de 9 a 14 por los cinco cambios
de migracion/gobernanza/CI/README, y paso a 52% del backlog: supera con holgura
el umbral de subdivision del 25%. Candidato firme a desdoblar en la proxima
sesion en "Scaffold inicial" vs "Migracion y publicacion / DevOps".
"Diseno UI / motor" sigue sobre el umbral, 26%.)

### Resumen estadistico por sesion
| Sesion | Traspasos | N cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 11 | (v01) | Scaffold y diseno |
| 2 | v02 | 4 | Opus 4.8 | Pipeline R 30-32 + orquestador |
| 3 | v03 | 6 | Opus 4.8 | Motor HTML (paso 33) + iteraciones UI |
| 4 | v04 | 6 | Opus 4.8 | Migracion a GitHub + Pages |
| **Total** | | **27** | | |

### Detalle cronologico
- **Sesion 1 (cambios 1-11):** ver traspaso v01 (scaffold, repo, diseno de
  datos y UI, decisiones 1-3).
- **Sesion 2 (cambios 12-15):** 12 auxiliares; 13 leer/normalizar; 14
  agregacion territorial; 15 orquestador + archivo de stub.
- **Sesion 3 (cambios 16-21):** 16 generador `33_generar_html.R`; 17 template
  base `33_motor_template.html`; 18 iteracion UI tanda 1 (paleta inicial, año
  completo, comuna en ficha); 19 tanda 2 (azul institucional); 20 tanda 3
  (trayectoria rediseñada, filtro comuna, fix pct 0,0%); 21 tanda 4 (selector
  EE, filtro dependencia, leyenda agrandada, distribucion desde EE).
- **Sesion 4 (cambios 22-27):** 22 auditoria de seguridad pre-migracion;
  23 `gobernanza_datos.md` (Rama A ligera); 24 `LICENSE` (MIT con clausula de
  datos) + alineacion del header del generador; 25 workflow de CI de seguridad;
  26 publicacion en Pages (modelo B, docs/ + copia automatica en el generador);
  27 README de migracion.

### Delta del backlog
6 entradas nuevas (22-27). Sin cambios de taxonomia. "Scaffold e inicializacion"
salto a 52% (subdivision recomendada la proxima sesion). Total 21 -> 27.

---

## 6. Bugs de la sesion

No aplica en esta sesion: la migracion no produjo bugs. Hubo dos incidentes
operativos menores resueltos en el momento (no son bugs de codigo del proyecto):
(a) la carpeta del workflow se creo como `.github/workflow/` singular y se
renombro a `workflows/` plural antes del commit, requisito de GitHub Actions;
(b) el `LICENSE` quedo duplicado en `50_documentacion/activa/` por un arrastre
de archivo y se elimino, conservando solo el de la raiz. Ambos detectados por el
escaner antes del push.

---

## 7. Aprendizajes y restricciones descubiertas

### A8 — Auditar el estado real del repo antes de aplicar el protocolo 4.3
El protocolo 4.3 asume migracion desde cero, pero el repo ya existia con commits
sin pushear. Verificar `git remote -v`, `git log origin/main..HEAD` y la
visibilidad real (`gh repo view --json visibility`) ANTES de ejecutar pasos
reordena la secuencia: aqui se salto la creacion de repo y la Fase 2 de
separacion de raices (innecesaria en Rama A). Contexto si se viola: ejecutar
pasos redundantes o, peor, recrear un repo existente.

### A9 — En Rama A la auditoria reporta, no expulsa datos
El script de auditoria del 4.3 esta pensado para Rama B (expulsar datos del
repo). En Rama A los datos publicos DEBEN versionarse: el script se adapta para
reportar solo info que no deba ser publica (tokens, RUT, rutas personales),
nunca para marcar los .xlsx/.parquet como hallazgo. Ejemplo: 24 hallazgos, todos
benignos; ningun dato publico reportado.

### A10 — `.github/workflows/` es plural y exacto
GitHub Actions solo reconoce la carpeta `.github/workflows/` (plural). Un
singular `.github/workflow/` se sube sin error pero el workflow nunca corre.
Verificar el nombre exacto en el escaner antes del push. Ejemplo: corregido esta
sesion antes de commitear.

### A11 — El instrumental reutilizable no vive en el repo del proyecto
El `diagnostico_migracion_github.R` es una herramienta de proceso (sirve a
cualquier migracion), no codigo del proyecto. Va a `herramientas_dev/`, no al
repo. Dejarlo en la raiz lo versiona y ensucia, ademas de auto-detectarse en su
propia auditoria. Ejemplo: 6 de los 24 hallazgos eran auto-referencias del
script cuando aun estaba en la raiz.

---

## 8. Decisiones de diseno

### D-visibilidad-repo — Repo publico
- **Decision:** el repo es PUBLIC.
- **Alternativa:** privado (default del protocolo 4.3). Descartada: los datos ya
  son publicos (Agencia de Calidad), el destino es GitHub Pages, y Pages sobre
  repo privado exige plan de pago.
- **Implicancia:** sin branch protection en GitHub Free; se sustituye con el
  workflow de CI + autodisciplina de commits.
- **Confirmada por el titular en la sesion 4.**

### D-modelo-pages — Modelo B (docs/ con copia automatica)
- **Decision:** Pages sirve `docs/index.html`, copia derivada del canonico
  `40_salidas/motor_categoria.html`, regenerada por el generador en cada corrida.
- **Alternativa:** modelo A (rama `gh-pages` con paso de publicacion). Descartada:
  maquinaria desproporcionada para un archivo unico standalone sin build; modelo
  B es mas simple y consistente con el madre.
- **Implicancia:** `40_salidas/` es la fuente de verdad; `docs/` no se edita a
  mano; el generador mantiene ambos sincronizados.
- **Confirmada por el titular en la sesion 4.**

### D-licencia — MIT sobre Apache 2.0
- **Decision:** MIT para el codigo, con clausula de que no cubre datos.
- **Alternativa:** Apache 2.0 (estaba en el header del generador por remanente de
  plantilla). Descartada: MIT alinea con el LICENSE ya decidido, es el estandar
  para visualizacion publica y mantiene una sola licencia en proyectos gemelos.
- **Implicancia:** el header de `33_generar_html.R` se cambio de Apache a MIT.
- **Confirmada por el titular en la sesion 4.**

---

## 9. Constantes y parametros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| CAT_ORDEN | INSUFICIENTE, MEDIO-BAJO, MEDIO, ALTO | 33_generar_html.R | orden semantico |
| CAT_COLORS.ALTO | #0062A0 | 33_generar_html.R | azul institucional |
| CAT_COLORS.MEDIO | #2A8FD9 | 33_generar_html.R | azul claro |
| CAT_COLORS.MEDIO-BAJO | #E88663 | 33_generar_html.R | coral |
| CAT_COLORS.INSUFICIENTE | #EE2D49 | 33_generar_html.R | rojo |
| DEPE_LABELS | 1..5 -> Municipal/Part.Subv./Part.Pagado/CAD/SLEP | 33_generar_html.R | |
| PCT_DIGITS | 4 | 33_generar_html.R | redondeo de pct en JSON |
| anio_vigente | 2019 | meta (derivado de max(anios)) | decision D-cobertura |
| Pages source | main / /docs | config remota GitHub | decision D-modelo-pages (v04) |
| Licencia | MIT | LICENSE + header generador | decision D-licencia (v04) |
| Repo visibilidad | PUBLIC | config remota GitHub | decision D-visibilidad-repo (v04) |

---

## 10. Arquitectura de archivos

Referencia al escaner al cierre: `estructura_actual.md` re-ejecutado al cierre de
la sesion 4 (incluye `LICENSE`, `docs/index.html`, `.github/workflows/`,
`gobernanza_datos.md`, la auditoria en `decisiones/`). La estructura respeta la
politica: `docs/` es la carpeta de publicacion de Pages (no es una decena del
flujo, es destino de despliegue); `.github/workflows/` sigue la convencion de
GitHub. Sin desviaciones nuevas en las decenas del pipeline.

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**P-ee-trayectoria — Click en EE abre seccion de trayectoria detallada**
- **Tipo:** funcionalidad.
- **Contexto:** al hacer click en un establecimiento, abrir abajo una seccion que
  muestre su trayectoria por las categorias en los años disponibles. Reutilizar
  el espacio que hoy ocupa "Sin categoria vigente"; mover ese bloque a un lugar
  mas sutil.
- **Complejidad:** Media-Alta.
- **Principios:** B.2, C.6.
- **Criterio de exito:** click en una fila de EE despliega su trayectoria
  detallada; el bloque "sin categoria vigente" se reubica sin perder informacion.

**P-metodologia — Seccion de metodologia**
- **Tipo:** documentacion / UI.
- **Contexto:** agregar seccion de metodologia en el estilo del motor
  `slep_simce_adecuado`.
- **Complejidad:** Baja-Media.
- **Criterio de exito:** seccion presente, coherente con el estilo del hermano,
  explicando conteo de EE, sin ponderacion, sin GSE, cobertura 2016-2019.

**P-ficha-datos — Matricula y emplazamiento en la ficha de EE**
- **Tipo:** funcionalidad / pipeline.
- **Contexto:** agregar a la ficha de cada EE matricula actual y emplazamiento
  (rural/urbano). NINGUNO esta en los parquets actuales: la matricula la aporta
  el titular; el emplazamiento esta en el directorio oficial de EE y hay que
  traerlo aguas arriba en el pipeline R (31/32 o un join contra el directorio).
- **Complejidad:** Media (toca pipeline R, no solo UI).
- **Criterio de exito:** ficha muestra comuna (ya), dependencia (ya), matricula y
  emplazamiento; los datos viajan en el bloque `rbd` del JSON.

**P-filtro-riesgo — Filtro de establecimientos en riesgo (bajo el de comuna)**
- **Tipo:** funcionalidad.
- **Contexto:** filtro con dos pills: "Todos los establecimientos" y
  "Establecimientos en riesgo". La definicion de "en riesgo" la dara el titular al
  abordar el pendiente (input de dominio requerido, NO resolver autonomamente).
- **Complejidad:** Baja-Media (depende de la definicion).
- **Criterio de exito:** dos pills operativas que filtran la grilla; "en riesgo"
  segun la definicion del titular.

**P-vista-ee — Vista dedicada para establecimiento individual (opcional)**
- **Tipo:** mejora visual.
- **Contexto:** al elegir un EE individual, la grilla de 4 columnas con una sola
  poblada es subaprovechada; podria ser una ficha ampliada con su trayectoria.
  Encaja con P-ee-trayectoria.
- **Complejidad:** Media.
- **Criterio de exito:** modo EE muestra una vista util (no 3 columnas vacias).

**P-decisiones — Documentar decisiones de la sesion 3**
- **Tipo:** documentacion.
- **Contexto:** crear `decisiones/20260612_decision_cobertura_temporal.md` y
  `decisiones/20260612_decision_paleta_categorias.md` (decisiones D-cobertura-
  temporal y D-paleta-categorias del v03, aun sin materializar). Las decisiones
  de la sesion 4 (D-visibilidad-repo, D-modelo-pages, D-licencia) tambien
  ameritan archivo propio si se quiere replicar como evidencia arquitectonica.
- **Complejidad:** Baja.
- **Criterio de exito:** archivos de decision en `50_documentacion/activa/decisiones/`.

### Evaluacion de deuda tecnica
- Sin deuda tecnica nueva de codigo. El motor y el pipeline no se tocaron salvo
  la copia a docs/ (aditiva).
- Deuda documental: las decisiones de diseno del v03 y v04 siguen solo en
  traspasos, no como archivos en `decisiones/` (P-decisiones).
- Backlog: "Scaffold e inicializacion" en 52% exige subdivision taxonomica la
  proxima sesion.

### Auditoria de cierre (politica 5.6, preguntas "Cierre")
- **5. Cada transformacion critica con check de validacion?** Si — heredado del
  generador (validacion C.8); la copia a docs/ valida `file.copy` con stop si falla.
- **6. Outputs reproducibles e idempotentes?** Si — `run_all()` regenera HTML y
  copia a docs/ identico.
- **7. Decisiones metodologicas como constantes nombradas?** Si — sin cambios.
- **8. Nombres sin tildes/ñ/espacios?** Si — verificado por la auditoria de
  seguridad y el escaner.
- Sin respuestas "no": no se agrega deuda nueva por auditoria de cierre.

### Ruta sugerida para la sesion 5
1. **P-decisiones** (cierre barato y saldar deuda documental acumulada): crear
   los archivos de decision pendientes del v03 (cobertura, paleta) y, si se
   quiere, del v04 (visibilidad, Pages, licencia). Criterio: archivos en
   `decisiones/`.
2. **P-metodologia** (baja-media, no requiere input de dominio): seccion de
   metodologia en el motor, estilo del hermano. Buen primer bloque de UI.
3. **P-ee-trayectoria + P-vista-ee** (relacionadas): rediseño del modo EE con
   trayectoria detallada. Media-alta; abordar con criterio observable definido
   antes de iterar (A7).
- **Diferir / requiere input del titular:** P-filtro-riesgo (definicion de "en
  riesgo") y P-ficha-datos (matricula la aporta el titular; emplazamiento exige
  tocar el pipeline R aguas arriba).
- **Antes de construir UI nueva:** evaluar subdividir la categoria "Scaffold e
  inicializacion" del backlog (52%, sobre umbral).

---

## 12. Instrucciones especificas para la proxima sesion

- 🔒 **Basica y media nunca se mezclan** en una cifra agregada (invariante del
  proyecto desde v01).
- 🔒 **Agregacion = conteo de EE.** Jamas ponderacion por matricula, jamas GSE.
- 🔒 **El pct mostrado en la UI es el autoritativo del territorial** (calculado
  en R). NO recalcular cifras en el cliente (Bug 1 del v03).
- 🔒 **`40_salidas/motor_categoria.html` es la fuente de verdad; `docs/index.html`
  es copia derivada.** NO editar `docs/` a mano: lo regenera el paso 33.
- ✅ ANTES de tocar `CatData`, recordar que `nom_rbd` puede venir null: blindar
  cualquier operacion de texto (Bug 2 del v03).
- ✅ ANTES de cualquier push, `git status` revisado; el CI valida tokens/RUT/datos
  pero la primera barrera es el escaner local.
- ⚠️ NO definir "establecimiento en riesgo" de forma autonoma: requiere input de
  dominio del titular (P-filtro-riesgo).
- ⚠️ NO agregar matricula/emplazamiento sin traerlos aguas arriba en el pipeline
  R: no estan en los parquets actuales (P-ficha-datos).
- ⚠️ NO regenerar el HTML asumiendo que `d3.min.js`/`pako.min.js` existen: el
  generador falla con mensaje claro si faltan (versionados en `10_utils/`).

---

## 13. Fragmentos de codigo de referencia

### Copia automatica a docs/ para Pages (Bloque 7 del generador)
```r
# docs/ es la carpeta servida por Pages (modelo B). El canonico vive en
# 40_salidas/; docs/index.html es copia derivada, regenerada en cada corrida.
dir_docs <- here::here("docs")
if (!dir.exists(dir_docs)) dir.create(dir_docs, recursive = TRUE)
ruta_pages <- file.path(dir_docs, "index.html")
ok_copia <- file.copy(ruta_salida, ruta_pages, overwrite = TRUE)
if (!ok_copia) stop("No se pudo copiar el HTML a docs/index.html")
```

### Verificacion de Pages tras activar (terminal)
```
gh api -X POST repos/tomgc/slep_categoria_desempeno/pages \
  -f "source[branch]=main" -f "source[path]=/docs"
sleep 90 && curl -s -o /dev/null -w "%{http_code}\n" \
  https://tomgc.github.io/slep_categoria_desempeno/
```

### Estructura del .gitignore para Rama A (clave: HTML canonico ignorado, docs/ no)
```
# El canonico es regenerable y se ignora; la copia en docs/ SI se versiona
# (es lo que publica Pages). docs/ nunca estuvo en el .gitignore.
40_salidas/intermedios/*.parquet
40_salidas/motor_categoria.html
```

---

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 5 (Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del Project;
> leelo desde ahi. Retomamos slep_categoria_desempeno en sesion 5. El proyecto
> ya esta publicado en GitHub Pages; el foco vuelve a UI/documentacion (ver ruta
> sugerida del v04: P-decisiones, P-metodologia, P-ee-trayectoria). Adjunto el
> traspaso v04 y el escaner actual.

### Documentos para la proxima sesion

**1. Protocolo en knowledge base (NO se adjuntan; verificar que esten al dia):**
- `POLITICA_PROYECTO.md`
- `SETTINGS_Y_PROMPTS_OPERACIONALES.md`

**2. Opcionales segun el foco (UI/documentacion):**
- `CLAUDE.md` (si la sesion correra en Claude Code; copiar a la raiz).
- `30_procesamiento/33_motor_template.html` (si se aborda P-metodologia,
  P-ee-trayectoria o P-vista-ee: es el archivo del componente JS).
- `30_procesamiento/33_generar_html.R` (si P-ficha-datos toca el JSON aguas
  arriba).

**3. Especificos de la sesion (SI se adjuntan):**
- `traspaso_cierre_v04.md` (este documento).
- `estructura_actual.md` (re-ejecutar el escaner ANTES de adjuntar).

### Nota final
Re-ejecutar `00_escanear_proyecto.R` antes de abrir la sesion 5. Si algun archivo
listado cambio entre sesiones, adjuntar la version mas reciente y avisarlo en el
mensaje de apertura.
