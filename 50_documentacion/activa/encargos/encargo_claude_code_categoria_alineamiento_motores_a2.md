# Encargo autónomo: sincronizar la fuente JSX e implementar el plan de alineamiento de motores (a2)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (edición en serie de una misma fuente, un build y un push; `encargo_autonomo_claude_code_v1.md` §2.12, fila 5).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_categoria_desempeno`, macOS.
- **INSUMOS (en disco):** `50_documentacion/andamios/20260925_plan_alineamiento_motores.md` (**fuente de verdad de cada ficha**: §1 da la forma adaptada, §3.2 el orden); `50_documentacion/andamios/logs/20260925_alineamiento_motores_a1_log.md` (recetas de los instrumentos M3 a M6, línea base, errores de instrumento ya corregidos que no deben repetirse); `50_documentacion/activa/encargos/encargo_claude_code_categoria_alineamiento_motores_a1.md` (§1 "adaptar, no copiar" y §3 invariantes, que este encargo hereda); `30_procesamiento/33_app.jsx`; `30_procesamiento/33_motor_template.html`; `30_procesamiento/33_generar_html.R`; `00_run_all.R`; `tests/auditar_cifras.R`; `tests/spot_check_publicado.R`; `50_documentacion/activa/decisiones/` (en especial `20260612_decision_paleta_categorias.md`, `20260611_decision_nombres_establecimientos.md`, `20260612_decision_cobertura_temporal.md` y `20260619_reconstruccion_app_jsx.md`); `50_documentacion/activa/backlog_acumulativo.md`.
- **Referencia de `slep_idps`:** solo si una ficha lo exige para precisar su forma; lecturas con `GIT_OPTIONAL_LOCKS=0` y sin git que escriba. No se escribe nada allí.
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_categoria_desempeno`; ningún comando asume `cd`. `bash` explícito (bash 3.2). `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`). Babel solo como herramienta de desarrollo, en `/tmp/cat_a2_babel`, con la receta de la cabecera de `33_app.jsx` (`@babel/preset-react`, `runtime: "classic"`). Instrumentos en `/tmp/cat_a2_*`: si existen los de `/tmp/cat_a1_*` (payload, M5, capturas) se copian y se **recalibran** antes de usarlos; si no existen, se reconstruyen con la receta del LOG a1. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Ningún shell en segundo plano queda corriendo al terminar. Localiza el código por marcadores, no por número de línea.
- **LOG:** `50_documentacion/andamios/logs/20260925_alineamiento_motores_a2_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): alineamiento de motores a2` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_categoria_desempeno"); source("00_run_all.R"); run_all(only = 33)'` con exit 0 y 0 warnings (con `renv` activo; ver M0); (b) 0 errores de consola y 0 `pageerror` en las 9 pantallas de M6 del LOG a1, a 1280 y a 390; (c) **payload intacto:** SHA-256 del JSON embebido, descomprimido y con `fecha_generacion` normalizada = `0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8` (fuente: LOG a1, M3 y FASE R); (d) `tests/auditar_cifras.R` y `tests/spot_check_publicado.R` en verde, corridos mientras `docs/index.html` tiene el build nuevo y antes de restaurarlo.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria. Un push denegado no se reintenta por otra vía.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`; **ningún color hex nuevo**; en código R, `here::here()`; el LOG no lleva RBD con número ni nombres de establecimiento (nombres de comuna, SLEP y región sí). **Regla nueva (origen: bug de `91ff8ed` que M4 del a1 detectó): el bloque de la app del template nunca se edita a mano. Toda edición de lógica o JSX se hace en `33_app.jsx` y llega al template solo por retranspilación completa del archivo, reemplazando el bloque entero.** El CSS sí se edita en el template.

## 1. Decisiones del titular que este encargo ejecuta (sesión 30 del chat, 2026-09-25)

| Duda del plan | Resolución | Efecto en a2 |
|---|---|---|
| D-M4 | Sí: sincronizar `33_app.jsx` con el template | T0 |
| Q-PUSH (a1) | Sí; ya ejecutado por el titular (`3afd23a..51447ce`) | ninguno |
| Q-F11 | **B:** `--ink` como tinta del texto en las cabeceras de columna de Insuficiente, Medio-Bajo y Medio; Insuficiente queda en ≈ 4,46:1 como **excepción escrita**. El % máximo del comparador, el delta negativo de la ficha y la ✕ del chip al pasar el cursor **quedan como están** | T2.1 y la decisión de T3 |
| Q-F09 | **B:** el comparador conserva su cifra y la fila pasa a llamarse "Sin categoría en {año vigente} (incluye sin medición)". Resuelve también D-13 | T2.2 |
| Q-F18 | **No:** los nombres se muestran con las mayúsculas del dato | se cierra en el plan (T3) |
| Q-D08 | Se **mantiene** la exclusión de la entidad nacional del modal (c.21) | se cierra en el plan (T3) |
| Q-D22 | Abierta (depende de la Agencia) | ninguno |
| D-03, frase 1 | Incluir la corrección de la frase 1 cuando el sujeto es un establecimiento (plan §2, segunda observación) | T2.3 |

Todo lo demás del plan se ejecuta tal como está escrito: las 10 fichas de §3.2 (F02, F08 adoptar; F01, F03, F04, F05, F07, F12, F14, D-03 adaptar), con la forma adaptada del punto 5 de cada ficha.

**Límites heredados del a1 §1, sin excepción:** nada que cambie una cifra, el payload o la metodología (sin GSE; conteo de EE sin ponderación; básica y media nunca combinadas; "sin categoría" con motivo y fuera del denominador); ningún color nuevo; nada que cree exportación, entidad nacional en el modal, marca de preliminar o segmentación; nada en el generador, en el pipeline 30 a 32, en `34_*` ni en `tests/`.

## 2. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `51447ce` (fuente: `git rev-parse --short HEAD` y `refs/remotes/origin/main`, sesión 30 del chat, tras el push del titular `3afd23a..51447ce`).
- `git status --porcelain` = `?? 40_salidas/categoria_rbd_contrato.parquet` (preexistente; no se toca ni se agrega) más este encargo sin versionar (fuente: `git status --short`, sesión 30 del chat).
- md5: plantilla `9e9640ca05205d345e713b489ee3e98d`; `33_app.jsx` `428448d63765d5be7a9558bd3c62e926`; `docs/index.html` `45e612f1c9909a2dd1115d9e8628cde0`; `40_salidas/motor_categoria.html` `8785476deeff0bc759934a1b9711e118` (reconstruido en FASE R del a1; difiere de `docs/` solo en `fecha_generacion`) (fuente: `md5sum`, sesión 30 del chat).
- `33_app.jsx` tiene **una** ocurrencia de `fs-base`: `fontSize: "var(--fs-base)"` en el buscador de `EntityModal` (fuente: `grep -n fs-base`, sesión 30 del chat); el template dice `var(--fs-body)` en el mismo punto (fuente: LOG a1, M4).
- `renv`: en el a1 la librería del proyecto estaba incompleta y `Rscript` caía por falta de `dplyr` (fuente: LOG a1, M3). Se indicó al titular correr `renv::restore()` antes de este encargo; que lo haya hecho es hipótesis (verificar con M0).
- `narrativaTerritorial` en `33_app.jsx`: sujeto `"El establecimiento "` para `kind === "establecimiento"`; frase 1 "tiene N establecimiento(s) con <nivel> categorizado(s) al año <año>, el año más reciente para el cual existe una clasificación."; caso vacío "no tiene establecimientos con <nivel> categorizados al año <año> para la selección actual."; frase 2 "Todos están en nivel de desempeño X." cuando hay una sola categoría presente (fuente: lectura de la función, sesión 30 del chat).
- Fila del comparador: `tr.cmp-row-sv`, primera celda (`td.cmp-cat-cell`, cursiva) con el literal "Sin categoría vigente" (fuente: lectura de `33_app.jsx`, sesión 30 del chat).
- Cabeceras de columna: `.cat-col-head { color: #fff; }`, `.cat-col-stat { opacity: 0.92; }`, `.cat-col-mat { opacity: 0.82; }`; el fondo lo pone `CatColumn` en línea con `CatData.CAT_COLORS[categoria]` (fuente: lectura del template y de `CatColumn`, sesión 30 del chat).

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** PRUEBAS c.
2. **Cifras intactas:** PRUEBAS d.
3. **Sin hex nuevo:** hex en líneas agregadas del diff `-U0 <inicio>..HEAD` de la plantilla y de `33_app.jsx`: **0**; el bloque `:root` con el mismo md5 que en FASE 0.
4. **Generador, pipeline y pruebas intactos:** `git diff <inicio>..HEAD -- 30_procesamiento/30_* 30_procesamiento/31_* 30_procesamiento/32_* 30_procesamiento/33_generar_html.R 30_procesamiento/34_* 20_insumos 10_utils tests | wc -l` → `0`.
5. **`docs/` publicado intacto:** al cerrar, `docs/index.html` con md5 `45e612f1…` y `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **La fuente y el transpilado no divergen:** después de T0, el bloque del template y la retranspilación de `33_app.jsx` dan **render idéntico** (las 7 diferencias cosméticas de cadena del LOG a1, M4, se aceptan). **Desde T1**, como el bloque se reemplaza siempre por la retranspilación completa, el invariante es **cadena idéntica**.
7. **Lo no tocado no cambia:** capturas a 1280 y 390 de las pantallas que M-DECL declara **fuera** de los cambios, idénticas píxel a píxel antes y después; `textContent` de `#root` idéntico salvo las cadenas que M-DECL enumera.

## 4. Grafo de tareas y ALCANCE

- **T0** (D-M4: sincronizar la fuente) · ALCANCE: `30_procesamiento/33_app.jsx` (una línea).
- **T1** (las 10 fichas del plan §3.2, en su orden) · ALCANCE: `30_procesamiento/33_app.jsx` y `30_procesamiento/33_motor_template.html`. Requiere T0.
- **T2** (resoluciones del titular: T2.1 F11-B, T2.2 F09-B, T2.3 D-03 frase 1) · ALCANCE: los mismos dos archivos. Requiere T1.
- **T3** (documentos) · ALCANCE: `50_documentacion/activa/decisiones/20260925_decision_contraste_texto_categorias.md` (nuevo) y `50_documentacion/andamios/20260925_plan_alineamiento_motores.md` (solo se **anexa** una §6; §0 a §5 no se reescriben). Corre siempre: las resoluciones son del titular y no dependen de que T1 o T2 se hayan implementado; el estado por ficha refleja lo que ocurrió.
- **T4** (build y verificación) · ALCANCE: ninguna ruta versionada (el motor está ignorado; `docs/index.html` se restaura). Requiere T2.
- Orden: T0 → T1 → T2 → T3 → T4. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, `?? 40_salidas/categoria_rbd_contrato.parquet`, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. T0 no logra render idéntico (🔒6) → congela T1, T2 y T4; T3 corre.
4. PRUEBAS c o d fallan en cualquier build → congela T1, T2 y T4 desde ese punto.
5. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
6. Un cambio que exige tocar fuera del ALCANCE, un color nuevo o contradecir una decisión escrita del proyecto → ese ítem pasa a duda; la tarea sigue con los demás.
7. **M0 en falla (renv):** **no detiene.** Todas las corridas R usan `RENV_ACTIVATE_PROJECT=FALSE`, igual que en el a1, declarado como desviación y como duda. No se instala ni se restaura nada.
8. **Residual:** cualquier estado, conteo o resultado no enumerado → congela ESE ítem o tarea, regístralo como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con lo independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo (`chore(encargo): alineamiento de motores a2`).
- `npm install` en `/tmp/cat_a2_babel` de `@babel/cli`, `@babel/core` y `@babel/preset-react` (versiones registradas en el LOG). Si `/tmp/cat_a1_babel` existe con las versiones del LOG a1, puede copiarse en lugar de instalar.
- `git commit` de T0, de cada grupo de T1, de T2 y de T3, cada uno tras su verificación.
- Después de **cada** build: `git restore docs/index.html`, verificando luego md5 = `45e612f1…` (el despliegue lo decide el titular tras la revisión en pantalla).
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` = `?? 40_salidas/categoria_rbd_contrato.parquet` y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/cat_a2_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular ni `rm`, `reset`, `checkout --`, `rebase`, ni commit de `docs/index.html`, ni `renv::restore()` o instalación de paquetes R, ni escritura alguna en `slep_idps`.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit autorizado. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` escrito en el LOG **antes** de su comando y `obtenido:` literal después.

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M0 | `Rscript -e 'setwd("/Users/tomgc/Projects/slep_categoria_desempeno"); library(dplyr); library(arrow)'` con `renv` activo | exit 0 | regla 7 |
| M1 | porcelain tras el primer commit; stash; archivos del primer commit | el parquet preexistente y el LOG; vacío; el encargo | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `51447ce` = `origin/main`; `0`; `1` | regla 2 |
| M3 | md5 de §2; SHA del payload normalizado con instrumento recalibrado (fecha alterada → igual; una cifra plantada → distinto); PRUEBAS d | los de §2; `0ffd9899…2ad8`; calibración correcta; verde | regla 4 |
| M4 | Deriva de la fuente **antes** de T0: retranspilar `33_app.jsx` y comparar con el bloque del template | igual al LOG a1: 8 líneas distintas, 1 sustantiva (`--fs-base`) | registrar; si aparece otra diferencia sustantiva, regla 8 |
| M5 | Re-medición, con el instrumento del a1, de los huecos de las 10 fichas de §3.2, más F11 (cabeceras), F09 (fila del comparador) y la frase 1 de D-03 | los valores del LOG a1, M5 (por ejemplo: F02 0/345 filas; F08 14 nombres partidos que cabrían a 1280; F14 539 px a 320; F12 1,21 y 1,19; F01 93 pares; F11 Insuficiente 4,11/3,67/3,16, Medio-Bajo 2,62/2,44/2,23, Medio 3,48/3,19/2,85, Alto 6,45/5,72/4,89) | se registra; la verificación de cada ficha usa el valor nuevo |
| M-NIV | Valores de `CatData.NIVELES` y claves de `CatData.CAT_COLORS` en el payload | etiquetas de nivel con forma "Educación Básica" / "Educación Media"; claves `INSUFICIENTE`, `MEDIO-BAJO`, `MEDIO`, `ALTO` | lo que difiera condiciona T2.1 o T2.3 (regla 8) |
| M6 | Capturas y `textContent` de `#root` de línea base de las 9 pantallas del LOG a1 (M6) a 1280 × 800 y 390 × 800, con determinismo (dos corridas) | registradas; 9/9 AE = 0 entre corridas | sin acción |
| M-DECL | Lista, escrita en el LOG **antes** de T1, de las pantallas y las cadenas de `textContent` que T1 y T2 cambian, derivada del plan §3.2 y de §1 de este encargo | declarada | sin acción |

Último acto: anexar la sección `### FASE 0`.

## 6. Tareas

### T0: sincronizar la fuente (D-M4)

1. En `33_app.jsx`, buscador de `EntityModal`: `fontSize: "var(--fs-base)"` → `fontSize: "var(--fs-body)"`. Nada más.
2. Verificación (`esperado:` antes): `grep -c fs-base 30_procesamiento/33_app.jsx` = 0; retranspilar con la receta; el bloque retranspilado difiere del template **solo** en las 7 líneas cosméticas del LOG a1 (M4); motor de prueba en `/tmp` con el bloque retranspilado contra el motor actual: 9/9 AE = 0 y `textContent` igual a 1280 y a 390 (🔒6 de T0). El template **no** se toca en T0.
3. Commit `fix(fuente): sincroniza 33_app.jsx con el template (--fs-base a --fs-body, a2 T0)`.

### T1: las 10 fichas del plan

1. En el orden del plan §3.2, en cuatro grupos: **modal y foco** (F02, F03, F04, F05, F07), **ancho** (F08, F14), **textos** (F01, D-03), **anillo** (F12). Cada ficha con la forma del punto 5 de su ficha en el plan; donde el plan deja una elección abierta, la resuelve el estilo del archivo y se registra en el LOG.
2. Lógica y JSX en `33_app.jsx`; CSS en el template. Cada cambio lleva un comentario breve que cite la ficha (por ejemplo `a1-F02: filas del modal operables con teclado`). Tras cada grupo: retranspilar `33_app.jsx` completo y **reemplazar el bloque entero** del template por el resultado (regla canónica de §0).
3. Verificación por ficha (`esperado:` antes), con **la misma medición de M5**: el hueco desaparece según el criterio de verificación de la ficha en el plan; además 🔒1, 🔒3, 🔒6 (cadena idéntica) y 🔒7; PRUEBAS b. En F02, verificar el riesgo que el plan declara (`.comuna-checklist` deja de ser parada propia). En F12, contraste máximo anillo contra lo que hay debajo ≥ 3 en los siete controles de M5. Una ficha que no pasa se revierte en la fuente (edición inversa, no `checkout`) y pasa a duda.
4. Un commit por grupo: `feat(motor): alineamiento a2, <grupo> (<fichas>)`.

### T2: resoluciones del titular

**T2.1 · F11-B (tinta de las cabeceras de columna).**
1. `CatColumn`: la cabecera de Insuficiente, Medio-Bajo y Medio recibe una clase modificadora (por ejemplo `cat-col-head is-tinta`, con las claves que M-NIV confirme); Alto queda sin cambio.
2. Template: `.cat-col-head.is-tinta { color: var(--ink); }` y, dentro de ella, `.cat-col-stat` y `.cat-col-mat` con `opacity: 1` (la opacidad bajaría el contraste medido; la jerarquía entre las tres líneas queda por tamaño y peso).
3. Verificación: contraste de cada línea (título, stat, mat) con el instrumento de M5: Insuficiente ≥ 4,46 (esperado ≈ 4,46), Medio-Bajo ≥ 4,5 (≈ 7,01), Medio ≥ 4,5 (≈ 5,27), Alto sin cambio. Si alguna línea de Insuficiente queda bajo 4,46, duda. El % máximo del comparador, el delta negativo y la ✕ del chip **no se tocan**.

**T2.2 · F09-B (rótulo de la fila del comparador).**
1. Primera celda de `tr.cmp-row-sv`: `Sin categoría en {CatData.ANIO_VIGENTE} (incluye sin medición)`, con la constante y nunca con el año literal (la decisión de cobertura temporal recalcula el vigente al entrar 2025). Se conserva la cursiva.
2. Si otra superficie **del comparador** rotula esta misma cifra (s/i más sin medición), recibe el mismo rótulo; toda superficie que muestre el conteo oficial (la caja "Sin categoría vigente" de la vista por territorio, que dice "(conteo oficial)") **no se toca**. Lo encontrado se registra.
3. Verificación: las celdas de cifras de la fila con `textContent` idéntico al de M6; solo cambia el rótulo.

**T2.3 · D-03, frase 1 con un establecimiento como sujeto.**
1. `narrativaTerritorial`, solo cuando `entity.kind === "establecimiento"`:
   - frase 1: `El establecimiento <nombre> tiene <nivel> categorizada al año <año>, el año más reciente para el cual existe una clasificación.`
   - caso vacío: `El establecimiento <nombre> no tiene <nivel> categorizada al año <año> para la selección actual.`
   - `<nombre>` con la variante de F14 (`bNom`); `<año>` con `b(anioCat)`; `<nivel>` = `nivelLbl`. La frase 2 es la que deja D-03 en T1 ("Está en nivel de desempeño X."). Las demás entidades no cambian.
2. Si M-NIV muestra que `nivelLbl` no concuerda en femenino singular con "categorizada", duda con pregunta cerrada; no se improvisa otra redacción.
3. Verificación: narrativa con un establecimiento como entidad, con y sin categoría en el nivel: texto exacto esperado; la narrativa de una comuna y de un SLEP, `textContent` idéntico a M6.

Commit de T2: `feat(motor): resoluciones del titular sobre el plan de alineamiento (a2 T2: F11-B, F09-B, D-03 frase 1)`.

### T3: documentos

1. `50_documentacion/activa/decisiones/20260925_decision_contraste_texto_categorias.md`, en el formato de las decisiones existentes del directorio: contexto (valores de M5); decisión (B, con la fecha y el origen: a1 Q-F11, sesión 30); **excepción escrita**: la cabecera de Insuficiente queda en el valor medido en T2.1, bajo 4,5:1, porque ninguna tinta existente lo alcanza y crear tokens de texto enmendaría la paleta; **precisión** a `20260612_decision_paleta_categorias.md`: su "Contraste AA" vale para los colores como relleno sobre crema, no como fondo de texto (ese archivo no se edita; la nueva decisión lo referencia); superficies que siguen bajo 4,5:1 y por qué quedan así (% máximo del comparador, delta negativo 3,97, ✕ del chip al pasar el cursor 4,11), con las cifras remedidas en este encargo.
2. Plan: anexar `## 6. Resoluciones del titular y estado de implementación (a2)`: la tabla de §1 de este encargo y, por ficha, implementada / congelada / diferida, con commit y medición antes y después.
3. Verificación: privacidad (0 RBD con número, 0 nombres de establecimiento); §0 a §5 del plan sin cambios (`git diff` del plan solo con líneas agregadas al final).
4. Commit `docs(alineamiento): decisión de contraste y resoluciones del titular (a2 T3)`.

### T4: build y verificación

1. Build con PRUEBAS a; PRUEBAS c y d con `docs/index.html` recién escrito; luego `git restore docs/index.html` y md5 = `45e612f1…`.
2. md5 del motor nuevo en `40_salidas/` registrado; capturas para la revisión del titular en `/tmp/cat_a2_gate/` (una por ficha o resolución implementada, antes y después).

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del LOG y del plan: cada ficha y resolución con su estado, cada verificación, cada 🔒, M3 a M6 y el alcance. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** cada ítem implementado, medido con un comando distinto (otro recorrido de teclado, otra métrica de ancho, el árbol de accesibilidad de Chrome, otro cálculo de contraste). **Segunda lectura de cada ficha implementada:** ¿se coló algo de la lógica de `slep_idps` sin razón (un término, un universo, una unidad, una pantalla que aquí no existe)? Si lo hay, es hallazgo REPARA.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal. 🔒6 debe dar **cadena idéntica**.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD`; `git status --porcelain`.
5. **Regresión completa:** PRUEBAS a a d.
6. **Control positivo:** el motor publicado (`45e612f1…`) vuelve a mostrar los huecos de M5 con el mismo instrumento.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, cifra alterada: no se repara); **REPARA** (defecto propio dentro del ALCANCE); **ADVIERTE** (sin efecto sobre la meta). "0 hallazgos" solo junto al control positivo.
8. **Ciclo de reparación (máximo 2)**, con commit `fix(auditoria): R-NN …`, rebuild y restauración de `docs/index.html`.
9. **Prohibido:** ajustar criterio o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita; reclasificar una ficha para que pase.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → el parquet preexistente y el LOG. Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits; estado por ficha y resolución; tabla de auditoría; invariantes; md5 del motor nuevo; dudas con pregunta cerrada; errores propios; observaciones fuera de alcance (abajo); estado de cierre.
3. Bloque J: trece campos, una línea cada uno (meta y resultado; estado por tarea; commits; auditoría; invariantes; cifras críticas; decisiones autónomas de mayor riesgo; desviaciones; dudas abiertas; errores propios; qué debe verificar el revisor; no publicado / queda al usuario; ejecución).
4. Privacidad: grep de RUT con script (`/tmp/cat_a2_priv.sh`) → vacío, con control plantado; ningún RBD con número ni nombre de establecimiento en el LOG, el plan ni la decisión nueva.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): alineamiento de motores a2"`; luego el push según la autorización.

**Observaciones fuera de alcance (se registran en el LOG, no se implementan):** frase 3 de la narrativa vacía cuando la matrícula del nivel está solo en Medio-Bajo ("Considerando la matrícula 2025, .", plan §2); frase 3 con un establecimiento como sujeto ("a un establecimiento de desempeño…" hablando de sí mismo); `el**Simce 2022**` sin espacio en la nota de cobertura temporal; CSS muerto heredado de `slep_simce_adecuado` (pendiente #2 del traspaso v29).

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: tabla por ficha y resolución (`ficha | estado | commit | medición antes → después`); para cada ficha *adaptar* y cada resolución, qué quedó distinto de la forma de `slep_idps` y por qué, si cambió respecto del plan; resultado de M0 (renv); salida del push; md5 del motor nuevo; lo que queda al titular para la revisión en pantalla (abrir `40_salidas/motor_categoria.html`: los dos modales solo con teclado, un nombre largo en el modal, la narrativa con un establecimiento a 320 px, las cabeceras de Insuficiente, Medio-Bajo y Medio, la fila renombrada del comparador); "lo que falló o sorprendió; si nada, decirlo".
