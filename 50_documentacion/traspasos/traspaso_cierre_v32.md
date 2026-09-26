# Traspaso de cierre: slep_categoria_desempeno v32

## 1. Identificación

- **Proyecto:** slep_categoria_desempeno
- **Versión:** v32
- **Fecha:** 2026-09-26
- **Sesión:** 32, CONTINUATION. Foco: ordenar el repositorio según la política v5.5 (#4), retirar los comentarios huérfanos del CSS, instalar la guarda de locale UTF-8 (#5) y dar a la trayectoria una segunda señal además del color (#7), con cada cambio verificado y publicado.
- **Entorno:** chat (Cowork, con la carpeta del repo conectada: 0bis a mano, mediciones, decisiones y redacción de encargos) + Claude Code (seis encargos autónomos: a11, a11b, a12, a13, a14, y la ordenación en rama con PR). Modelo configurado en el chat: `claude-opus-5-5`; los encargos declaran Opus 5.5.
- **Normativos usados:** `POLITICA_PROYECTO.md` con encabezado `> **Versión 5.8 — vigente.**`; `SETTINGS_Y_PROMPTS_OPERACIONALES.md` con encabezado `> **Versión 38.**` (las mismas que citó el traspaso v31).
- **Archivos principales modificados:** `00_escanear_proyecto.R`, `00_run_all.R`, `10_utils/10_locale.R` (nuevo), `10_utils/10_configuracion.R` (nuevo), los cinco scripts de `30_procesamiento/30_*` a `34_*` (una línea cada uno), `30_procesamiento/33_app.jsx`, `30_procesamiento/33_motor_template.html`, `docs/index.html` (dos despliegues); marcadores nuevos en `50_documentacion/activa/` (`50_ordenacion_repositorio.md`, `50_datos_versionados_autorizados.md`, `50_locale_utf8.md`); decisión `50_documentacion/activa/decisiones/20260926_decision_segunda_senal_trayectoria.md`; cinco encargos en `activa/encargos/`, cinco LOG en `andamios/logs/` y `andamios/20260925_errores_asistente_sesion32.md`.

## 2. Resumen ejecutivo

La sesión abrió con el 0bis corrido a mano (5/5) y `/apertura` en `52b8dab`. El pendiente #4 se cerró en dos encargos: el a11 ordenó el repositorio en la rama `ordenacion/20260925` (3 obsoletos a `_archivo/20260925/`, un renombre con prefijo `50_`, escáner corregido), pero su push lo rechazó el hook `pre-push` porque el repo versiona 14 archivos de datos públicos sin lista de autorización; el a11b escribió esa lista ruta por ruta, publicó la rama, abrió el PR #3 y dejó el marcador, y el titular hizo el merge (`568b418`). El a12 retiró los 11 comentarios huérfanos del `<style>` con CSS y render idénticos. El a13 instaló la guarda de locale UTF-8 con el esquema A′ (arranque común `10_utils/10_configuracion.R`, cargado por el orquestador y por cada script de `30_procesamiento/`), la vio fallar y dejó la constancia. El a14 implementó la opción B de #7: la altura de la marca de cada año codifica la categoría (7, 13, 19 y 25 px; 7 para «sin categoría»), medida en 820 marcas, y la publicó. Cifras y payload sin cambio en toda la sesión. Se registraron 11 errores del asistente (cuatro del patrón esperado falso por construcción) y se resolvieron las dudas D1 a D9. Queda abierto poco en este repo: re-clonar (#6), la duda D-22 (#10) y trabajo de BIBLIOTECA para el kit.

## 3. Estado al cierre

**Funciona:** motor publicado en GitHub Pages con md5 `a89e47e09499022a2d2ac121b63796fd`, idéntico a `docs/index.html` del commit `cc10295` (fuente: `curl` del sitio y `md5sum`, sesión 32). Payload con `fecha_generacion` normalizada: SHA `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`, sin cambio en toda la sesión (fuente: LOG a11 a a14). `tests/auditar_cifras.R` (F1 a F4) y `tests/spot_check_publicado.R` en verde con renv activo en cada build (fuente: LOG a12 a a14). Guarda de locale instalada: `validar_portabilidad()` con 0 críticas y 4 advertencias preexistentes; el pipeline completo reproduce el contenido de `40_salidas/` (9 de 9) (fuente: LOG a13). I8 del verificador de cierre pasa con 14 de 14 rutas autorizadas (fuente: LOG a11b). `main` en `beb6efb` (previo al commit de cierre), igual a `origin/main`, 0/0, árbol limpio salvo el registro de errores de la sesión, que viaja con el cierre (fuente: `git rev-parse`, `git rev-list --left-right --count` y `git status --short`, sesión 32).

**No funciona / pendiente:** ninguna falla funcional. La revisión visual de la segunda señal por el titular queda como duda registrada (§11).

**Delta respecto a v31:** cerrados #4, #5, #7 y #8, y los comentarios huérfanos del CSS. Siguen abiertos #6, #9, #10 y #11; se suman #12 y #13 (§11). 26 commits propios entre `52b8dab` y `beb6efb`, más el merge del PR #3.

## 4. Registro detallado de cambios

### 4.1 Ordenación del repositorio (a11) y publicación con PR (a11b)

- **Qué:** bloque 2, tres obsoletos versionados a `_archivo/20260925/` con `git mv` (`509a056`): `P-matricula-actual_alcance.md`, `P-matricula-grado_alcance.md` y `20_insumos/auxiliares/prompt_nuevo_proyecto_categoria_desempeno.md`; bloque 3, `resena_slep_categoria_desempeno.md` → `50_resena_slep_categoria_desempeno.md` (`e12a089`); bloque 4, `00_escanear_proyecto.R` excluye dependencias de terceros y deja de versionar la ruta absoluta (`24bb5f3`); marcador `50_ordenacion_repositorio.md` y escáner final (`86892ad`). PR #3, merge del titular `568b418`.
- **Categoría:** Migración y publicación / DevOps.
- **Por qué:** pendiente #4 del traspaso v31 (gatillo 4bis encendido).
- **Cómo se verificó:** hashes de origen y destino iguales en los movidos; grep de referencias vivas por candidato; SHA del payload y md5 del motor sin cambio; FASE R re-derivó con `shasum`, `git show --stat`, `find` y Python (fuente: LOG a11 y a11b).

### 4.2 Autorización de los 14 archivos de datos versionados (a11b)

- **Qué:** `50_documentacion/activa/50_datos_versionados_autorizados.md`, 14 rutas exactas sin comodines, con la justificación desde `gobernanza_datos.md` (producto público, agregados por establecimiento, directorio depurado). Commit `bdf18aa`.
- **Categoría:** Gobernanza de datos.
- **Por qué:** el primer push de una rama nueva hace que el hook `pre-push` evalúe el árbol completo, y R1 rechazaba los 14 archivos por extensión (D4 = A, aprobada por el titular).
- **Cómo se verificó:** 0 coincidencias del patrón de RUT y 0 columnas MRUN, RUN o RUT en las 14 rutas; I8 de FALLA a PASA; controles positivos (1 línea plantada da 1; 1 entrada quitada da 1 `R1`) (fuente: LOG a11b).

### 4.3 Comentarios huérfanos del CSS (a12)

- **Qué:** template, `<style>`: 26 líneas borradas (13 de comentario y 13 vacías). Commits `c0aa5aa` y despliegue `bbabda6`.
- **Categoría:** Calidad de código / pipeline.
- **Por qué:** residuo del retiro de CSS muerto del a10 (listado en su LOG), incluido en #4.
- **Cómo se verificó:** CSSOM 232 = 232 (Chrome y `postcss`); capturas de ventana con AE 0; motor 1889390 → 1888877 bytes (`587f4233…` → `018f6365…`); controles positivos (una `}` de más y una regla viva borrada se detectan) (fuente: LOG a12).

### 4.4 Guarda de locale UTF-8 (a13)

- **Qué:** `10_utils/10_locale.R` (copia idéntica de la plantilla del kit), `10_utils/10_configuracion.R` (arranque común: `source()` de la guarda, `asegurar_locale_utf8("10_configuracion")` y accesor `ruta_insumos()`), una línea de carga en `00_run_all.R` y en cada script `30_*` a `34_*`. Commits `2d6ea89` (8 rutas, solo agregados) y constancia `50_locale_utf8.md` (`22f9e1d`).
- **Categoría:** Validación / integridad.
- **Por qué:** pendiente #5 (gatillo 4ter). Esquema A′ aprobado por el titular, el mismo de `slep_simce_adecuado` y `slep_reportes_modelo_resguardo_asistencia`, tras revisar cómo lo resuelven esos proyectos.
- **Cómo se verificó:** guarda vista fallar (V2 a V4 dan FALLO con la rotura); corrida desde locale C con `--no-environ` corrige y deja el motor byte a byte igual (`018f6365…`); pipeline completo con 9 de 9 salidas iguales; `validar_portabilidad()` 0 críticas (fuente: LOG a13).

### 4.5 Segunda señal en la trayectoria (a14)

- **Qué:** `33_app.jsx`: constantes `TRAJ_ALTURA_BASE = 7` y `TRAJ_ALTURA_PASO = 6`, función `alturaTrayectoria(categoria)`, marca envuelta en `<span className="traj-bar">` con alto en línea, y la leyenda igual; template: `.traj-bar { height: 25px; display: inline-flex; align-items: flex-end; }`, `.traj-mark` de 16 px de ancho y `.traj-legend-sw` de 14 px. Bloque de la app retranspilado completo (1614 → 1635 líneas). Commits `730a7b6` y despliegue `cc10295`.
- **Categoría:** Accesibilidad y usabilidad.
- **Por qué:** pendiente #7 (WCAG 2.1, criterio 1.4.1: la categoría se comunicaba solo por color). Opción B elegida por el titular sobre una maqueta en color y en escala de grises; decisión en `activa/decisiones/20260926_decision_segunda_senal_trayectoria.md`.
- **Cómo se verificó:** 820 marcas en tres estados con el alto del mapa (81, 255, 250, 38 y 196 por etiqueta) y 0 fuera de tolerancia; leyenda 7, 13, 19, 25 y 7; 205 vigentes con el mismo anillo; 0 colores cambiados; CSSOM 232 → 233 solo en las reglas previstas; alturas re-derivadas desde los píxeles de las capturas; controles positivos (paso en 0 y un color alterado fallan); M-DERIVA `96e583b2…` idéntico; motor +1083 bytes (fuente: LOG a14).

## 5. Backlog acumulativo

Cinco entradas nuevas (numeración provisional c.104 a c.108; el ejecutor renumera desde disco). Sin categorías nuevas ni reclasificaciones. "Gobernanza de datos" recibe su segunda entrada.

## 6. Bugs de la sesión

No aplica en esta sesión como bug de código del pipeline o del motor: lo corregido venía inventariado como pendiente (#4, #5, #7) y no hubo fallas nuevas. Los tropiezos fueron de redacción de encargos y de entorno de ejecución, y están en §15.

## 7. Aprendizajes y restricciones

- **El primer push de una rama nueva lo evalúa el hook sobre el árbol completo.** Antes de autorizar un push de rama nueva en un encargo, medir el hook con el simulacro en FASE 0. Ejemplo: el a11 quedó con T4 congelada por los 14 archivos de datos.
- **Un invariante que cuenta el LOG se mide en FASE L, después del commit del LOG (B.4).** Si se ubica en FASE R, es falso por construcción. Ejemplo: 🔒3 del a11b y 🔒8 del a12.
- **«Bajo locale C» en esta estación exige `--no-environ`:** `env LC_ALL= LC_CTYPE= LANG=C Rscript --no-environ`, porque R lee `~/.Renviron`, que fija `LANG`. Ejemplo: la receta literal del a13 no arrancaba en C.
- **Capturas para comparar por AE: de ventana y de ventana estirada al alto del documento, nunca `fullPage`,** que no es determinista (D6). Además, la barra de controles da ruido de texto al subpíxel entre corridas: el AE exacto se aplica a regiones sin esa barra, más el modal y la trayectoria (D9).
- **El OK de los actos externos viaja en el bloque de lanzamiento** (D5): el encargo los lista y el mensaje con que se lanza trae el OK del titular, con el simulacro del hook en exit 0 y sin `--no-verify` ni `--force`.
- **Un encargo transmite el estado de las dudas del titular ya resueltas,** no solo la decisión de diseño que lo motiva. Ejemplo: el LOG a14 declaró abiertas D1 a D3, D7 y D8, ya resueltas (§15, fila 11).
- **En la estación, `git fetch` corre con `-c maintenance.auto=false` y las lecturas con `GIT_OPTIONAL_LOCKS=0`;** un `fetch` desde el shell del computador dejó un `maintenance.lock` (§15, fila 4).
- **No escribir en archivos versionados cadenas literales con forma de RUT** (el hook R3 las rechaza), ni `echo` con cadenas de `=` en zsh.
- **`device_commit_files` puede escribir una versión en caché:** copiar el archivo a una ruta nueva antes de entregarlo y verificar el md5 en el equipo.

## 8. Decisiones de diseño

| Id | Decisión | Alternativa descartada | Implicancia |
|---|---|---|---|
| D1 | Las 4 librerías `.js` quedan en `10_utils/` | moverlas a `30_procesamiento/vendor/` | excepción declarada a la ordenación |
| D2 | Los reportes con sello de `tests/reportes/` se conservan | archivarlos y dejar solo el alias | excepción declarada |
| D3 | Los encargos de `activa/encargos/` no llevan prefijo `50_` | renombrarlos | excepción declarada; su nombre es contrato con los LOG |
| D4 | Lista de datos versionados autorizados (opción A) | push con `--no-verify` | R1 del hook e I8 pasan sin relajar R2 ni R3 |
| D5 | El OK de actos externos va en el bloque de lanzamiento (a) | pedirlo en cada push | encargos sin pausas |
| D6 | Capturas de ventana y de ventana alta, nunca `fullPage` | `fullPage` | AE determinista |
| D7 | Receta bajo C con `--no-environ` | receta literal sin esa opción | la corrida arranca de verdad en C |
| D8 | El titular declara `LC_CTYPE` en `~/.Renviron` de esta estación | aceptar el aviso de rama 1 en cada proceso | guarda silenciosa aquí; la otra estación queda por medir (§11) |
| D9 | El criterio de AE exacto excluye la barra de controles; se aplica a regiones sin ella, al modal y a la trayectoria | mantener la captura completa con advertencia | encargos de UI sin falsas advertencias |
| #8 | `CLAUDE.md` no se versiona (cierre del pendiente) | versionarlo | la copia local ignorada se mantiene a mano |
| #5 | Arranque A′: `10_configuracion.R` común, cargado por orquestador y scripts | guarda solo en el orquestador | cada script protegido también en corridas sueltas |
| #7 | Opción B: altura por categoría | A (patrón) y C (texto) | archivo `activa/decisiones/20260926_decision_segunda_senal_trayectoria.md` |

## 9. Constantes y parámetros

| Constante | Valor anterior | Valor nuevo | Archivo | Motivo |
|---|---|---|---|---|
| `TRAJ_ALTURA_BASE` | (no existía) | `7` px | `33_app.jsx` | #7, Insuficiente y «sin categoría» |
| `TRAJ_ALTURA_PASO` | (no existía) | `6` px | `33_app.jsx` | #7, paso entre categorías consecutivas |
| `.traj-mark` | 18 × 18 px | 16 px de ancho; alto por categoría | template `<style>` y `33_app.jsx` | #7 |
| `.traj-bar` | (no existía) | `height: 25px; display: inline-flex; align-items: flex-end` | template `<style>` | #7, bases alineadas |
| `.traj-legend-sw` | 16 × 16 px | 14 px de ancho; alto por categoría | template `<style>` y `33_app.jsx` | #7 |

Las demás constantes siguen vigentes en `33_generar_html.R` (`CAT_COLORS`) y en el `:root` del template. `10_utils/10_configuracion.R` es desde esta sesión el arranque común (guarda y `ruta_insumos()`).

## 10. Arquitectura de archivos

Escáner regenerado por el ejecutor del cierre. Cambios de estructura: `10_utils/10_locale.R` y `10_utils/10_configuracion.R` nuevos; `_archivo/20260925/` con 3 obsoletos; `50_resena_slep_categoria_desempeno.md` renombrado; tres marcadores nuevos en `activa/`; una decisión nueva; cinco encargos en `activa/encargos/` (a11, a11b, a12, a13, a14); cinco LOG en `andamios/logs/`; `andamios/20260925_errores_asistente_sesion32.md`. Deuda heredada: ninguna nueva; los gatillos 4bis y 4ter quedan apagados por sus marcadores. Excepciones declaradas por D1 a D3.

## 11. Pendientes y ruta sugerida

### Inventario

| # | Descripción | Tipo | Impacto | Dependencias | Complejidad | Precauciones y enfoque | Criterio de éxito sugerido |
|---|---|---|---|---|---|---|---|
| 6 | Re-clonar clones previos (historial reescrito en v27) | deuda heredada, administrativa manual | bajo | acceso a cada estación | baja | tarea del titular; no se hace por encargo | ningún clon con hashes previos a v27 |
| 9 | Hermanos (`slep_idps`, `slep_simce_adecuado`): medir si comparten `--fg-3` #747474 y `--border-2` #C8BDA0 | observación para otros proyectos | fuera de este repo | sesiones de esos repos | baja | no abrir desde esta sesión | medido en esas sesiones |
| 10 | D-22: ¿la categorización con Simce 2025 llegará como preliminar? | duda del titular, dato externo | futuro | publicación de la Agencia | n/a | no actuar hasta tener el dato | respuesta del titular |
| 11 | Llevar la propuesta PAT-14 (esperado falso por construcción) al catálogo de patrones | gobernanza, sesión BIBLIOTECA | medio | kit `herramientas_dev` | baja | evidencia: 1 caso en la sesión 30, 2 en la 31 y 4 en la 32 (§15) | entrada PAT-14 en el catálogo vigente |
| 12 | `10_locale.R` desfasado respecto de la plantilla del kit en `slep_aprendizajes_ep`, `slep_idps` y `slep_minuta_asistencia` (md5 `0f7b5dbf…` contra `dc900c1b…`, medido en la sesión 32 al revisar esos proyectos) | deuda del kit, sesión BIBLIOTECA | medio | kit y tres repos | baja | re-medir los md5 antes de actuar; copiar idéntico desde la plantilla, nunca editar | los tres con md5 igual a la plantilla vigente |
| 13 | Actualizar la copia local ignorada de `CLAUDE.md` con las lecciones de la sesión 32 (§7) | documentación local | bajo | ninguna | baja | archivo ignorado por git: se edita en la estación, no viaja | `CLAUDE.md` local con las recetas de §7 |

### Evaluación de deuda técnica

Zona frágil principal: el bloque transpilado del template (M-DERIVA sin deriva en toda la sesión). La guarda de locale agrega un punto de arranque común que todo script nuevo de `30_procesamiento/` debe cargar. Oportunidad: versionar como prueba en R el SHA normalizado del payload (F19 y D-24 del plan de v30).

### Auditoría de cierre (POLITICA 5.6, preguntas de cierre)

- 2. ¿El pipeline corre de cero sin intervención manual? → Sí: el a13 corrió el pipeline completo con la guarda y reprodujo 9 de 9 salidas.
- 5. ¿Cada transformación crítica tiene check? → Sí: `auditar_cifras.R` y `spot_check_publicado.R` en verde en cada build.
- 6. ¿Outputs reproducibles e idempotentes? → Sí: motor byte a byte igual entre corridas y desde locale C (a13).
- 7. ¿Decisiones como constantes nombradas? → Sí: `TRAJ_ALTURA_BASE` y `TRAJ_ALTURA_PASO`.
- 8. ¿Nombres sin tildes, ñ ni espacios? → Sí en todos los archivos nuevos.
- 9. ¿Guarda `asegurar_locale_utf8()` instalada y vista fallar? → Sí (a13, constancia `50_locale_utf8.md`).

### Compuerta de dudas

| supuesto | predicado | medicion | destino |
|---|---|---|---|
| La segunda señal se lee en Safari de iPhone y en escritorio igual que en Chrome | leyenda con 5 alturas y una fila de cada categoría con Insuficiente abajo, Alto arriba, anillo del vigente y «sin categoría» crema con borde punteado | revisión del titular en el sitio publicado, en iPhone y en escritorio | **registrada** |
| La otra estación no imprime el aviso de rama 1 de la guarda | `Rscript -e 'source(here::here("10_utils", "10_configuracion.R"))'` desde la raíz no imprime «Se exportaron LANG y LC_CTYPE» | ese comando en la otra estación | **registrada** |
| La suite se puede regenerar desde la otra estación (heredada del v31) | `packageVersion("suitedoc")` sin renv devuelve 0.3.0 | `RENV_ACTIVATE_PROJECT=FALSE Rscript -e 'packageVersion("suitedoc")'` en esa máquina | **registrada** |
| Los 70 avisos de codificación de `suitedoc` no afectan a otros proyectos (heredada del v31) | `generar_suite()` con `options(warn = 1)` da 0 avisos "cannot be translated" | corrida con avisos visibles en `herramientas_dev` | **registrada** (alcance del kit) |

### Ruta sugerida

1. #6, re-clonar los clones previos: deuda heredada y única acción ejecutable en este repo; la hace el titular.
2. La revisión visual de la segunda señal, si no se hizo (compuerta de dudas, fila 1).
3. #11 y #12 en una sesión BIBLIOTECA del kit, juntos: ambos tocan el instrumental.
4. Diferir #10 hasta que haya dato, #9 a las sesiones de los hermanos y #13 al próximo uso de Claude Code en este repo.

## 12. Instrucciones específicas para la próxima sesión

- ⚠️ NO editar el bloque transpilado del template sin pasar por `33_app.jsx` y retranspilar.
- ⚠️ NO medir colores sin desactivar transiciones y animaciones.
- ⚠️ NO correr `git` de lectura desde el shell del computador sin `GIT_OPTIONAL_LOCKS=0`, ni `git fetch` sin `-c maintenance.auto=false`.
- ⚠️ NO ubicar en FASE R un invariante que cuente el LOG: se mide en FASE L, después de su commit.
- ⚠️ NO usar capturas `fullPage` para AE, ni exigir AE exacto sobre la barra de controles (D6, D9).
- ⚠️ NO lanzar un encargo con actos externos sin el OK en el bloque de lanzamiento (D5).
- ✅ ANTES de cualquier encargo sobre el motor, medir M-DERIVA (retranspilación = bloque del template).
- ✅ ANTES de desplegar, verificar el SHA normalizado del payload y las pruebas del dato.
- ✅ ANTES de responder a un reporte de Claude Code, leer el LOG completo del encargo.
- ✅ ANTES de redactar un encargo, incluir el estado de las dudas del titular ya resueltas (D1 a D9 en §8).
- ✅ ANTES de una corrida «bajo locale C», usar `env LC_ALL= LC_CTYPE= LANG=C Rscript --no-environ` (D7).
- ✅ ANTES de regenerar la suite, correr sin renv (`RENV_ACTIVATE_PROJECT=FALSE`) y comprobar `suitedoc` 0.3.0 en esa estación.
- 🔒 Payload y cifras: ningún cambio visual altera el payload salvo `meta.cat_colors` por decisión escrita.
- 🔒 Orden temporal: trayectoria ascendente, detalle vigente primero.
- 🔒 Segunda señal: alturas 7, 13, 19 y 25 px por categoría, 7 para «sin categoría»; colores sin cambio.
- 🔒 Todo script ejecutable nuevo de `30_procesamiento/` carga `10_utils/10_configuracion.R` después de `library(here)`.

## 13. Fragmentos de código de referencia

Patrón nuevo en R, el arranque común (`10_utils/10_configuracion.R`), ejecutable tal cual:

```r
# Arranque comun del proyecto: guarda de locale UTF-8 (POLITICA 5.2bis) y accesor de insumos.
source(here::here("10_utils", "10_locale.R"))
asegurar_locale_utf8("10_configuracion")

# Los insumos viven en el propio repositorio (raiz unificada).
ruta_insumos <- function(...) here::here("20_insumos", ...)
```

Carga en cada script de `30_procesamiento/`, después de `library(here)`:

```r
source(here::here("10_utils", "10_configuracion.R"))  # guarda de locale UTF-8 (POLITICA 5.2bis)
```

Las recetas de verificación de la sesión (alturas desde píxeles, CSSOM con `postcss`, SHA con Python, simulacro del hook) viven en los LOG `20260925_ordenacion_repositorio_a11` y `20260926_*` de `50_documentacion/andamios/logs/`.

## 14. Reapertura

**Mensaje de apertura pre-armado:**

> Sesión 33, CONTINUATION: slep_categoria_desempeno. El protocolo (POLITICA_PROYECTO.md + SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del proyecto; léelo desde ahí. La carpeta del repo está conectada: lee el traspaso vigente completo desde 50_documentacion/traspasos/traspaso_cierre_v32.md y ejecuta tú el control de apertura 0bis (SETTINGS §1.2.2) sobre el disco, con GIT_OPTIONAL_LOCKS=0 en todo git de lectura; si no pego eco de /apertura, decláralo en el acuse. Todo lo que no midas en esta sesión es hipótesis. Estado: repositorio ordenado (PR #3 integrado), guarda de locale UTF-8 instalada, trayectoria con segunda señal publicada; cifras y payload sin cambio; repo limpio. Foco propuesto: pendiente #6 (re-clonar clones previos) y revisión visual de la segunda señal; #11 y #12 van a una sesión BIBLIOTECA. Espero el acuse en pantalla con el 0bis medido y la ruta de la Fase C con recomendación explícita.

**Documentos para la próxima sesión:**

1. *Protocolo en knowledge base* (no se adjuntan): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
2. *Opcionales según foco:* `CLAUDE.md` si correrá en Claude Code (copia local, ignorada por git).
3. *Específicos:* ninguno que adjuntar; el traspaso v32 se lee desde la carpeta conectada.

**Nota final obligatoria:** si algún archivo listado cambió entre sesiones, adjuntar la versión más actualizada al abrir y avisarlo en el mensaje de apertura.

## 15. Errores del asistente

Las filas 1 a 3 son errores de la sesión 31 detectados después de su cierre; las filas 4 a 11 son de la sesión 32. Copia del registro `50_documentacion/andamios/20260925_errores_asistente_sesion32.md`, hecho en el momento de cada error.

| momento | disparador | que_paso | regla_violada | causa_raiz | salvaguarda_presente | patron | gatillo_observable | intentos_previos | costo |
|---|---|---|---|---|---|---|---|---|---|
| Traspaso v31 §2 (paquete de cierre de la sesión 31) | usuario lo corrigió (detectado por el ejecutor del cierre, advertencia b del eco) | §2 dice «tres de ellos del mismo patrón» cuando la §15 del v31 tiene dos filas con `PAT-NUEVO-esperado-falso-por-construccion` | SETTINGS §1.2.6, marcador de fuente S-01 (toda cifra comunicada con recuento programático del mismo turno) | la cifra se corrigió en §11 y §15, donde se detectó, sin buscar sus otras apariciones en el mismo documento | SETTINGS; userPreferences (marcador de fuente) | PAT-01, cifra sin recuento | cifras-datos: la §15 estaba en el mismo paquete y un `grep` de «tres» sobre §2 mostraba la cifra | 1 (§15 fila 6 del v31: la misma cifra dicha de memoria; corregida en §11 y §15, no en §2) | 1 advertencia del cierre; 1 corrección en el traspaso v32 |
| Traspaso v31 §14, mensaje de reapertura pre-armado | usuario lo corrigió (detectado por el ejecutor del cierre, advertencia c del eco) | el mensaje de reapertura trae la ruta absoluta del repo con el nombre de usuario, copiada del mensaje de apertura de la sesión 31 | SETTINGS §2.1, declaración de insumos (jamás rutas absolutas, POLITICA §7.2); SETTINGS §4.3 Fase 1 (ruta absoluta con información personal es hallazgo de seguridad) | el texto de la apertura de la sesión 31 se reutilizó sin filtrarlo contra la restricción de rutas | SETTINGS; POLITICA | PAT-07, restricción de rutas no propagada | restriccion-no-propagada: la línea copiada contenía una ruta de usuario y el traspaso es un archivo versionado | 0 | ruta con nombre de usuario versionada en el commit `0493919`; 1 advertencia del cierre |
| Entrega de la reapertura tras el cierre v31 | usuario lo corrigió | el asistente pidió al titular armar la apertura de la sesión 32 pegando dos partes (mensaje de reapertura y eco del cierre) | preferencia del titular registrada en el Project: el mensaje de apertura se entrega como un solo bloque autosuficiente, sin collage | se siguió la mecánica de §2.2.14 (reapertura del traspaso más líneas de estado del eco) sin fundirla en un bloque según la preferencia | memoria del Project (preferencias del titular) | PAT-06, entrega con forma no canónica | otro: la entrega obligaba al titular a ensamblar dos piezas | 0 | 1 armado manual del titular en la apertura de la sesión 32 |
| Control 0bis de la apertura de la sesión 32 | asistente lo señaló espontáneamente | el `git fetch` del 0bis, corrido desde el shell del computador, disparó el mantenimiento automático de git y dejó `.git/objects/maintenance.lock` sin poder borrarlo (ese shell no tenía permiso de borrado) | SETTINGS §1.2.6, «Ningún comando asume el entorno» | `GIT_OPTIONAL_LOCKS=0` se aplicó a la lectura, pero no se previó que `fetch` escribe en `.git` y que ese shell no puede retirar lo que crea | SETTINGS; traspaso v31 §12 | PAT-03, supuesto sobre el entorno de ejecución ajeno | comando-entorno: shell sin permiso de borrado; `git -c maintenance.auto=false fetch` lo evitaba | 0 | 1 aprobación de borrado pedida al titular; archivo de 0 bytes borrado en el mismo turno, árbol limpio después |
| Redacción del encargo a11, FASE 0 y T4 (push de la rama) | asistente lo señaló espontáneamente al leer el LOG a11 | el encargo autorizó el primer push de una rama nueva sin medir antes el hook global `pre-push`, que en ese caso evalúa el árbol completo y rechaza los 14 archivos con extensión de datos versionados sin `50_datos_versionados_autorizados.md` | SETTINGS §1.2.6, «Ningún comando asume el entorno»; `encargo_autonomo_claude_code_v1.md` §2.2 (conducta esperada de una herramienta es premisa y se mide en FASE 0) | el eco de `/apertura` declaraba `core.hooksPath global → kit` y el acuse dejó como hipótesis que I8 pasara con datos versionados, pero ninguna de las dos señales se convirtió en una medición de FASE 0 del push de la rama | SETTINGS; encargo_autonomo_claude_code_v1.md | PAT-07, restricción leída no propagada al diseño del encargo | encargos-premisas: el eco decía `hooks: core.hooksPath global → kit` y `git ls-files` mostraba 14 rutas con extensión de datos | 0 | T4 congelada; sin PR ni marcador; 1 encargo adicional (a11b) y repetición de T5 |
| Redacción del encargo a11, T4, control de C4b | asistente lo señaló espontáneamente al leer el LOG a11 | la contraprueba `grep -cF "$HOME"` ≥ 1 sobre el escáner viejo no podía dispararse: la POSICIÓN del mismo encargo ponía las copias en `/tmp`, fuera de `$HOME` | SETTINGS §1.2.6, «Generar, verificar, consumar»; `encargo_autonomo_claude_code_v1.md` §2.6 (el criterio se calibra: dispara sobre un caso malo conocido) | el control se escribió contra la raíz real y se ejecutó sobre la copia sin revisar que la ubicación de la copia anulaba la condición | SETTINGS; encargo_autonomo_claude_code_v1.md | PAT-NUEVO-esperado-falso-por-construccion, primera ocurrencia en la sesión 32 (la propuesta PAT-14 sigue fuera del catálogo vigente) | encargos-premisas: POSICIÓN fijaba `/tmp/cat_a11_copia*` y el control exigía `$HOME` en el snapshot de la copia | 0 | ninguno (el ejecutor trasladó el chequeo a la raíz real en T5 y declaró la desviación) |
| Redacción del encargo a11b, encabezado y Autorizaciones | asistente lo señaló espontáneamente al leer el LOG a11b | el encargo se declaró «autónomo, todo en este turno» con pushes y PR en su lista cerrada, sin prever que la capa de permisos de Claude Code y la instrucción global del titular exigen un OK individual para cada `git push`; el primer push se denegó y el titular tuvo que autorizar en el turno | SETTINGS §1.2.6, «Ningún comando asume el entorno» | la lista de Autorizaciones del encargo se trató como suficiente para los actos externos, sin llevar el OK del titular al mensaje de lanzamiento | SETTINGS; instrucción global del titular en Claude Code | PAT-03, supuesto sobre el entorno de ejecución ajeno | comando-entorno: el encargo autorizaba 4 pushes y 1 PR y el mensaje de lanzamiento no traía el OK del titular | 0 | 1 pausa del encargo y 1 intervención del titular |
| Redacción del encargo a11b, 🔒3 | asistente lo señaló espontáneamente al leer el LOG a11b | el 🔒3 exigía que `main` tuviera los 4 archivos, incluido el LOG, pero FASE R lo mide antes de que FASE L commitee y empuje ese LOG: no podía pasar en FASE R | SETTINGS §1.2.6, «Generar, verificar, consumar»; `encargo_autonomo_claude_code_v1.md` §2.6 (criterio calibrado) | el invariante se escribió sobre el estado final del encargo sin ubicarlo en la fase que lo mide | SETTINGS; encargo_autonomo_claude_code_v1.md | PAT-NUEVO-esperado-falso-por-construccion, segunda ocurrencia en la sesión 32 (la propuesta PAT-14 sigue fuera del catálogo vigente) | encargos-premisas: el 🔒3 contaba el LOG y FASE R precede a FASE L | 0 | ninguno (el ejecutor lo declaró 3 de 4 por diseño y lo re-verificó tras el push) |
| Redacción del encargo a12, 🔒8 | asistente lo señaló espontáneamente al leer el LOG a12 | el 🔒8 exigía que el alcance incluyera el LOG, pero FASE R lo mide antes de que FASE L lo commitee: no podía pasar en FASE R, el mismo defecto de la fila 8, repetido una hora después de registrarlo | SETTINGS §1.2.6, «Generar, verificar, consumar»; `encargo_autonomo_claude_code_v1.md` §2.6 (criterio calibrado); esta misma tabla, fila 8 | el invariante de alcance se copió del a11b sin aplicar la corrección que la fila 8 ya describía | SETTINGS; encargo_autonomo_claude_code_v1.md; esta tabla | PAT-NUEVO-esperado-falso-por-construccion, tercera ocurrencia en la sesión 32 (la propuesta PAT-14 sigue fuera del catálogo vigente) | encargos-premisas: el 🔒8 contaba el LOG y la fila 8 ya registraba el mismo defecto | 1 (fila 8: 🔒3 del a11b, mismo defecto) | ninguno (el ejecutor lo declaró 2 de 3 por diseño y lo re-verificó tras el push) |
| Redacción del encargo a13, POSICIÓN y 🔒4 | asistente lo señaló espontáneamente al leer el LOG a13 | la receta «bajo locale C» (`env LC_ALL= LC_CTYPE= LANG=C Rscript`) no arranca en C en la estación, porque R lee el `~/.Renviron` que fija `LANG`; el 🔒4 exigía un aviso de corrección desde C que esa receta no podía producir | SETTINGS §1.2.6, «Ningún comando asume el entorno»; `encargo_autonomo_claude_code_v1.md` §2.6 (criterio calibrado) | el asistente leyó el arnés del kit (V3 usa `--vanilla`, que incluye `--no-environ`) y copió solo sus variables de entorno, sin la opción que las hace efectivas | SETTINGS; encargo_autonomo_claude_code_v1.md; `90_verificar_locale.R` leído en la sesión | PAT-NUEVO-esperado-falso-por-construccion, cuarta ocurrencia en la sesión 32 (con PAT-07 como mecanismo: restricción leída no propagada) | encargos-premisas: el código del arnés leído en la sesión mostraba `--vanilla` junto a `LANG=C` | 3 (filas 6, 8 y 9 de esta tabla: el mismo patrón en la sesión) | ninguno en resultados (el ejecutor lo midió en FASE 0 y usó `--no-environ`); 1 duda nueva (D7) |
| Redacción del encargo a14, INSUMOS y dudas heredadas | asistente lo señaló espontáneamente al leer el LOG a14 | el encargo transmitió solo la resolución de D6 y omitió las de D1, D2 y D3 (= no) y D7 y D8 (= sí), ya dadas por el titular; el LOG a14, versionado y empujado, las declara «siguen abiertas» | SETTINGS §1.2.6, «Ningún comando asume el entorno»; `encargo_autonomo_claude_code_v1.md` §2.2 (premisas del encargo) | el encargo se redactó con la decisión de diseño como insumo y sin un bloque de estado de dudas del titular | SETTINGS; encargo_autonomo_claude_code_v1.md | PAT-07, decisión leída no propagada al encargo | encargos-premisas: el titular respondió D1 a D3 y D7 y D8 en esta sesión, antes de redactar el a14 | 0 | ninguno en resultados; 1 afirmación falsa en un LOG versionado (se corrige en el traspaso v32 y en el próximo encargo, no reescribiendo el LOG) |

**Corrección al traspaso v31 §2 (el v31 no se reescribe):** los errores del patrón esperado falso por construcción en la sesión 31 son dos (§15 del v31, filas 1 y 3), no tres.

**Propuesta de entrada de catálogo (por el `PAT-NUEVO`):** se reitera: `PAT-14 · Esperado falso por construcción`: un paso de verificación exige un estado que la propia forma del encargo vuelve imposible (un esperado incompatible con el cambio que el mismo bloque aplica, ubicado en una fase anterior al acto que lo haría verdadero, o no derivado de las medidas disponibles). Salvaguarda sugerida: todo esperado se acompaña de la fase en que es alcanzable y de su cuenta con las cifras del LOG anterior. Evidencia: 1 caso en la sesión 30, 2 en la 31 y 4 en la 32 (filas 6, 8, 9 y 10).

**Fricciones:**

- friccion: el titular no entendía por qué hacía falta una segunda señal en la trayectoria → se explicó el criterio WCAG 1.4.1 con una maqueta en color y en grises antes de decidir.
- friccion: el titular señaló respuestas demasiado verbosas al cierre de la sesión → respuestas en la forma corta del tope de SETTINGS §1.2.6.
