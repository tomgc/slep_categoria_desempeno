# Encargo autónomo: alinear el motor de Categoría con los patrones de usabilidad de `slep_idps`, adaptándolos a su lógica (a1)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (edición en serie de una misma fuente, un build y un push; `encargo_autonomo_claude_code_v1.md` §2.12, fila 5).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_categoria_desempeno`, macOS.
- **INSUMOS de este proyecto (en disco):** `30_procesamiento/33_app.jsx` (**fuente de verdad de la interfaz**, en JSX); `30_procesamiento/33_motor_template.html` (CSS y el bloque de la app ya transpilado); `30_procesamiento/33_generar_html.R`; `00_run_all.R`; `tests/auditar_cifras.R` y `tests/spot_check_publicado.R`; todas las decisiones de `50_documentacion/activa/decisiones/` (en especial `20260611_decision_sin_gse.md`, `20260611_decision_nombres_establecimientos.md`, `20260612_decision_paleta_categorias.md`, `20260612_decision_cobertura_temporal.md`, `20260618_decision_plan_c3_eliminar_babel.md` y `20260619_reconstruccion_app_jsx.md`); `50_documentacion/activa/backlog_acumulativo.md`; `50_documentacion/activa/ESTADO.md`; el último traspaso en `50_documentacion/traspasos/`.
- **INSUMOS de referencia, del proyecto `slep_idps` (solo lectura; no se escribe nada allí):** `/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/20260924_matriz_patrones_motores.md` (la matriz: §1, §3.2 y §4.3 son las de este motor; §7, sus dudas); la plantilla `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html` como **implementación de referencia** de cada patrón; y sus decisiones `…/50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md` (tokens `-txt`) y `20260925_decision_base_pequena.md` (solo como ejemplo de cómo se razona una marca).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_categoria_desempeno`; ningún comando asume `cd`. `bash` explícito (bash 3.2; expresiones con `{m,n}` dentro de un script en `/tmp/cat_a1_*`). `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`). Babel se usa **solo como herramienta de desarrollo**, instalado en `/tmp/cat_a1_babel` (fuera del repositorio), con la receta de la cabecera de `33_app.jsx` (`@babel/preset-react`, `runtime: "classic"`). Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. En `slep_idps`, lecturas con `GIT_OPTIONAL_LOCKS=0` y sin git que escriba. Ningún shell en segundo plano queda corriendo al terminar. Localiza el código por marcadores, no por número de línea (las referencias `C:n` de la matriz son de `b709400` y pueden haberse corrido).
- **LOG:** `50_documentacion/andamios/logs/20260925_alineamiento_motores_a1_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): alineamiento de motores a1` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_categoria_desempeno"); source("00_run_all.R"); run_all(only = 33)'` con exit 0 y 0 warnings; (b) 0 errores de consola y 0 `pageerror` abriendo `40_salidas/motor_categoria.html` con los dos modales, la vista por territorio, el comparador con 10 territorios y una narrativa con un establecimiento como entidad; (c) **payload intacto:** el JSON embebido, descomprimido y con `fecha_generacion` igualada, con el mismo SHA-256 que en FASE 0; (d) `tests/auditar_cifras.R` y `tests/spot_check_publicado.R` en verde (corridos mientras `docs/index.html` tiene el build nuevo, antes de restaurarlo; ver Autorizaciones).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria. Un push denegado no se reintenta por otra vía.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`; **ningún color hex nuevo**; en código R, `here::here()`; el log no lleva RBD con número ni nombres de establecimiento (el proyecto maneja datos sensibles; nombres de comuna, SLEP y región sí).

## 1. Cómo leer el estándar: adaptar, no copiar (vinculante para todo el encargo)

La matriz describe 20 patrones que `slep_idps` fijó para su propio motor. **No es una lista de cambios para este proyecto.** Cada patrón resuelve un *problema de uso*; lo que se traslada es la solución a ese problema, y solo cuando el problema existe aquí. La forma concreta que tomó en `slep_idps` (sus clases, sus textos, sus unidades, sus pantallas) es un ejemplo, no una especificación.

Para cada hueco, antes de tocar código, responde por escrito en el plan (T1):

1. **¿Cuál es el problema de uso, dicho en los términos de este motor?** Qué pantalla, qué control, qué usuario, qué falla observable (con medición propia, no la de la matriz).
2. **¿Existe aquí ese problema?** Si no, el patrón no aplica aunque la forma falte. Razona por el problema, nunca por la ausencia de la forma.
3. **¿Qué decisión propia de este proyecto lo toca?** Las decisiones de `50_documentacion/activa/decisiones/` y el backlog **prevalecen** sobre cualquier patrón de `slep_idps`. Si un patrón contradice una decisión escrita aquí, no se implementa: se registra como duda.
4. **¿Qué de la solución de `slep_idps` depende de su lógica y no de la de este motor?** Por ejemplo: el GSE (aquí no existe por decisión), el estado frente al GSE (aquí la unidad es la categoría publicada), la paleta de estado de tres valores (aquí es ordinal de cuatro), el comparador por filas (aquí está traspuesto), la exportación (aquí no hay), la entidad nacional en el modal (aquí no se ofrece), "en el directorio" (aquí el universo de algunas cifras es el catálogo territorial, no el directorio).
5. **¿Cuál es la forma adaptada?** Con los nombres, clases, textos, unidades y universos de este motor, escrita en su estilo de código (por ejemplo, si aquí los plurales se resuelven con ternarios en línea, se decide si basta corregir los que faltan o si conviene un ayudante; no se importa `nEE` porque sí).

Cada hueco termina en **una** de estas clases:

| Clase | Cuándo | Qué se hace en este encargo |
|---|---|---|
| **Adoptar** | El problema existe igual y la solución de `slep_idps` encaja sin cambios de fondo (solo nombres) | Se implementa (T2) |
| **Adaptar** | El problema existe, pero la solución debe tomar otra forma por la lógica de este motor | Se implementa la forma adaptada (T2), con la razón de cada diferencia |
| **Inspirarse** | El problema existe de otra manera; sirve el principio, no la solución | Se describe la idea y queda propuesta; no se implementa |
| **No aplica** | El problema no existe aquí | Se razona y se cierra |
| **Diferir** | Hace falta una decisión del titular (metodológica, de paleta, de producto) o contradice una decisión escrita | Se registra como duda con pregunta cerrada; no se implementa |

**Límites que ningún patrón cruza aquí:** nada que cambie una cifra, el payload o la metodología (sin GSE; conteo de EE sin ponderación; básica y media nunca combinadas; "sin categoría" con motivo y fuera del denominador); nada que agregue colores; nada que cree exportación, entidad nacional en el modal, marca de preliminar o segmentación nueva; nada en el generador ni en el pipeline 30–32.

## 2. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `3afd23a` (fuente: `git rev-parse --short origin/main` tras `git fetch`, sesión 30 del chat, 2026-09-25; corrige el `b709400` de la redacción original, que quedó 3 commits documentales atrás por el cierre v29). `git status --porcelain` = `?? 40_salidas/categoria_rbd_contrato.parquet` (preexistente; no se toca ni se agrega) más este encargo sin versionar (fuente: `git status --short`, sesión 30 del chat).
- md5: plantilla `9e9640ca05205d345e713b489ee3e98d`; `33_app.jsx` `428448d63765d5be7a9558bd3c62e926`; `40_salidas/motor_categoria.html` = `docs/index.html` = `45e612f1c9909a2dd1115d9e8628cde0` (fuente: `openssl md5` del redactor).
- `33_app.jsx` es la fuente editable; el template lleva su transpilado entre el comentario "Aplicación React (...)" y el cierre `</script>`; la retranspilación es un paso manual con `npx babel` y `runtime: "classic"` (fuente: cabecera de `33_app.jsx` y `20260619_reconstruccion_app_jsx.md`). El CSS vive en el template.
- `33_generar_html.R` escribe `40_salidas/motor_categoria.html` (ignorado por git) **y lo copia a `docs/index.html`** (versionado): todo build publica en el árbol (fuente: `sed` del redactor sobre el generador, bloque "Publicación").
- Huecos de este motor según la matriz (§3.2): filas 1, 2, 3, 4, 5, 7, 8, 9, 11, 12, 14, 18 y 19; no aplican 6, 15, 16 y 17; presentes 10, 13 y 20. Idiosincrasias (§4.3): sin GSE; conteo de EE; dos años vigentes (categoría 2019, matrícula 2025); paleta ordinal de cuatro; "sin categoría" con motivo; SLEP con su serie completa y "Traspaso AAAA"; comparador traspuesto; básica y media separadas; sin exportación (fuente: la matriz, medida sobre `b709400`; se re-mide en FASE 0).
- Lectura previa del redactor, **como hipótesis que T1 debe confirmar o corregir, no como instrucción:** modal y foco (2, 3, 4, 5, 7) y ancho (8, 14) parecen *adoptar o adaptar*; plurales (1) y la fila Región (9, parte del catálogo) parecen *adaptar*; "sin categoría vigente" 4 frente a 6 (9, segunda parte) parece *diferir* (metodológica); contraste del texto sobre los rellenos ordinales (11) y anillo sobre `--ocean` (12) dependen de si se resuelven con colores existentes (si no, *diferir*); mayúsculas del dato (18) depende de lo que diga `20260611_decision_nombres_establecimientos.md` y de cómo se trate una sigla; 19 parece *inspirarse* (este proyecto ya tiene verificación versionada por valor).

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** PRUEBAS c.
2. **Cifras intactas:** PRUEBAS d.
3. **Sin hex nuevo:** hex en líneas agregadas del diff `-U0` de la plantilla y de `33_app.jsx`: **0**; el bloque de variables CSS (`:root`) con el mismo md5 que en FASE 0.
4. **Generador y pipeline intactos:** `git diff <inicio>..HEAD -- 30_procesamiento/30_* 30_procesamiento/31_* 30_procesamiento/32_* 30_procesamiento/33_generar_html.R 20_insumos 10_utils tests | wc -l` → `0`.
5. **`docs/` publicado intacto:** al cerrar, `docs/index.html` con md5 `45e612f1…` y `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **La fuente y el transpilado no divergen:** el bloque de la app en el template es el transpilado de `33_app.jsx` con la receta del proyecto (misma cadena, o, si la receta produce diferencias cosméticas, render idéntico: 🔒7 sobre las pantallas no tocadas).
7. **Lo no tocado no cambia:** capturas a 1280 × 800 de las pantallas que el plan declara **fuera** de sus cambios, idénticas píxel a píxel antes y después; `textContent` de la apertura idéntico salvo las cadenas que el plan enumera.

## 4. Grafo de tareas y ALCANCE

- **T1** (plan de adaptación) · ALCANCE: `50_documentacion/andamios/20260925_plan_alineamiento_motores.md`.
- **T2** (implementación de lo que T1 clasifica *adoptar* o *adaptar*) · ALCANCE: `30_procesamiento/33_app.jsx` y `30_procesamiento/33_motor_template.html`. Requiere T1 completada.
- **T3** (build y verificación) · ALCANCE: ninguna ruta versionada (el motor está ignorado; `docs/index.html` se restaura). Requiere T2.
- Orden: T1 → T2 → T3. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, `?? 40_salidas/categoria_rbd_contrato.parquet`, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. **Deriva de la fuente (M4):** retranspilar el `33_app.jsx` actual no reproduce el bloque del template (ni como cadena ni como render idéntico) → congela T2 y T3; T1 sigue (el plan se entrega igual).
4. PRUEBAS c o d fallan en cualquier build → congela T2 y T3.
5. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
6. Un cambio que exige tocar fuera del ALCANCE, un color nuevo o una decisión escrita del proyecto → ese ítem pasa a *diferir*; la tarea sigue con los demás.
7. **Residual:** cualquier estado, conteo o resultado no enumerado → congela ESTE ítem o tarea, regístralo como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con lo independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo (`chore(encargo): alineamiento de motores a1`).
- `npm install` en `/tmp/cat_a1_babel` de `@babel/cli`, `@babel/core` y `@babel/preset-react` (versiones registradas en el LOG).
- `git commit` del plan (T1) y de `33_app.jsx` + template (T2), cada uno tras su verificación.
- Después de **cada** build: `git restore docs/index.html`, verificando luego md5 = `45e612f1…` (el despliegue lo decide el titular tras el gate visual).
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` = `?? 40_salidas/categoria_rbd_contrato.parquet` y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/cat_a1_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular ni `rm`, `reset`, `checkout --`, `rebase`, ni commit de `docs/index.html`, ni escritura alguna en `slep_idps`.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit autorizado. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` escrito en el LOG **antes** de su comando y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash; archivos del primer commit | el parquet preexistente y el LOG; vacío; el encargo | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `3afd23a` = `origin/main`; `0`; `1` | regla 2 |
| M3 | md5 de plantilla, `33_app.jsx`, motor y `docs/`; SHA-256 del payload normalizado (instrumento nuevo en `/tmp/cat_a1_payload.js`, calibrado: fecha alterada → igual; una cifra plantada → distinto); PRUEBAS d | los de §2; calibración correcta; verde | regla 4 |
| M4 | **Deriva de la fuente:** retranspilar `33_app.jsx` con la receta y comparar con el bloque del template (cadena; si difiere, motor de prueba en `/tmp` con el bloque retranspilado: capturas y `textContent` de las pantallas de PRUEBAS b frente al motor actual) | igual como cadena o como render | regla 3 |
| M5 | **Re-medición propia de cada hueco de §3.2 sobre este motor** (no se copian las cifras de la matriz): recorridos de teclado en los dos modales; `scrollWidth`/`clientWidth` de filas y página a 320, 390 y 1280; contraste de cada texto de estado y del anillo de foco; conteos "1 …" en el texto visible | se registra cada hueco como confirmado, corregido o inexistente | lo corregido se usa en T1 |
| M6 | Capturas y `textContent` de línea base (🔒7) de las pantallas de PRUEBAS b a 1280 y 390 | registradas | — |

Último acto: anexar la sección `### FASE 0`.

## 6. Tareas

### T1: plan de adaptación

1. Lee, en este orden: las decisiones del proyecto, el backlog, el último traspaso, §3.2, §4.3 y §7 de la matriz, y, para cada hueco, el código de referencia en la plantilla de `slep_idps` (localizado por la evidencia `I:n` de la matriz o por `grep`).
2. Escribe `50_documentacion/andamios/20260925_plan_alineamiento_motores.md`: una ficha por hueco (las 13 filas de §3.2, más D-03, D-08, D-13, D-22 y D-24 de §7) con las cinco respuestas de §1, la clase, la medición de M5 que la funda, la forma adaptada (qué archivo, qué componente, qué texto, qué clase CSS de **este** motor), el riesgo y la verificación. Al final: una tabla resumen por clase, la lista de lo que T2 implementará y la de dudas con pregunta cerrada. Una sección breve con **lo que este motor hace mejor** y `slep_idps` podría aprender (por ejemplo, las pruebas versionadas del dato), sin proponer cambios aquí.
3. Verificación: toda ficha tiene clase y razón; ninguna ficha *adoptar* o *adaptar* choca con los límites de §1; toda ficha *diferir* tiene pregunta cerrada; privacidad del documento (sin RBD con número ni nombres de establecimiento).
4. Commit `docs(alineamiento): plan de adaptación de los patrones de slep_idps (a1 T1)`.

### T2: implementación

1. Solo los ítems *adoptar* y *adaptar* del plan, en el orden que el plan fije (sugerido: modal y foco; ancho; textos; contraste y anillo si caben sin color nuevo).
2. Edición en `33_app.jsx` (lógica y JSX) y en el template (CSS); después, retranspilar con la receta y reemplazar el bloque del template. Cada cambio lleva un comentario breve que cite la ficha del plan (por ejemplo `a1-F02: filas del modal operables con teclado`).
3. Verificación por ítem (`esperado:` antes), con la **misma medición de M5** repetida: el hueco desaparece; 🔒1, 🔒3, 🔒6 y 🔒7; PRUEBAS b. Un ítem que no pasa se revierte en la fuente (edición inversa, no `checkout`) y pasa a duda.
4. Commit `feat(motor): alineamiento de usabilidad con los patrones de slep_idps, adaptado (a1 T2)`, con la lista de fichas implementadas en el cuerpo.

### T3: build y verificación

1. Build con PRUEBAS a; PRUEBAS c y d (con `docs/index.html` recién escrito); luego `git restore docs/index.html` y md5 = `45e612f1…`.
2. md5 del motor nuevo en `40_salidas/` registrado; capturas para el gate del titular en `/tmp/cat_a1_gate/` (una por ítem implementado, antes y después).

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log y del plan: cada ficha con su clase, cada verificación, cada 🔒, M3, M4 y el alcance. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** cada ítem implementado, medido con un comando distinto (otro recorrido de teclado, otra métrica de ancho, el árbol de accesibilidad de Chrome); **y una segunda lectura de cada ficha *adoptar*: ¿hay algo de la lógica de `slep_idps` que se coló sin razón (un término, un universo, una unidad, una pantalla que aquí no existe)?** Si lo hay, es hallazgo REPARA.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD`; `git status --porcelain`.
5. **Regresión completa:** PRUEBAS a a d.
6. **Control positivo:** el motor anterior (`45e612f1…`) vuelve a mostrar los huecos de M5 con el mismo instrumento.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, cifra alterada: no se repara); **REPARA** (defecto propio dentro del ALCANCE); **ADVIERTE** (sin efecto sobre la meta). "0 hallazgos" solo junto al control positivo.
8. **Ciclo de reparación (máximo 2)**, con commit `fix(auditoria): R-NN …`, rebuild y restauración de `docs/index.html`.
9. **Prohibido:** ajustar criterio o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita; reclasificar una ficha para que pase.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → el parquet preexistente y el LOG. Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits; conteo de fichas por clase; tabla de auditoría; invariantes; md5 del motor nuevo; dudas con pregunta cerrada; errores propios; estado de cierre.
3. Bloque J: trece campos, una línea cada uno (meta y resultado; estado por tarea; commits; auditoría; invariantes; cifras críticas; decisiones autónomas de mayor riesgo; desviaciones; dudas abiertas; errores propios; qué debe verificar el revisor; no publicado / queda al usuario; ejecución).
4. Privacidad: grep de RUT con script (`/tmp/cat_a1_priv.sh`) → vacío, con control plantado; ningún RBD con número ni nombre de establecimiento en el LOG ni en el plan.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): alineamiento de motores a1"`; luego el push según la autorización.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: la tabla resumen del plan por clase (adoptar / adaptar / inspirarse / no aplica / diferir) con una línea por ficha; **para cada ficha *adaptar*, qué se cambió respecto de la forma de `slep_idps` y por qué**; salida del push; md5 del motor nuevo; lo que queda al titular para el gate visual (abrir `40_salidas/motor_categoria.html`: los dos modales con teclado, un nombre largo en el modal, la narrativa con un establecimiento a 320 px); "lo que falló o sorprendió; si nada, decirlo".
