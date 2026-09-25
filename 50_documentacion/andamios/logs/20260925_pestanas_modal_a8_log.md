# Log — Pestañas del modal en pantallas angostas, y despliegue (a8)

- **Fecha:** 2026-09-25
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_categoria_pestanas_modal_a8.md`
- **Proyecto:** `slep_categoria_desempeno`
- **Ejecutor:** Claude Code (Opus 5.5, sesión única, sin subagentes)
- **Punto de retorno (`<inicio>`):** `aeeee7a` (padre `484c9f1`)
- **Privacidad:** este log no lleva RBD con número ni nombres de establecimiento; los estados se identifican por índice o por hash corto, los mismos del a6 y el a7.

## J. Juicio (lo rellena FASE L)

1. **Meta y resultado:** que las cuatro pestañas del modal de territorio se vean completas en pantallas angostas, con una sola fila a 390 px, y desplegar. Resultado: C4 corregido, verificado y publicado; con esto quedan publicados C1 a C6.
2. **Estado por tarea:** FASE 0 completa; T1 COMPLETADA; T2 COMPLETADA (despliegue); FASE R sin bloqueo; FASE L completa.
3. **Commits:** `aeeee7a` encargo y registro de errores · `59946c8` T1 · `69c32b4` despliegue · (este) `docs(log)`.
4. **Auditoría:** 23 filas; 0 BLOQUEA, 0 REPARA, 1 ADVIERTE (R-23 proceso); 0 ciclos; control positivo presente.
5. **Invariantes:** 🔒1 a 🔒9 PASAN (🔒7 por `textContent` y por `innerText`).
6. **Cifras críticas:** SHA `d9895a78…0442` en la base, en t1, t2 y R, y desde `git show` de `69c32b4` y `aeeee7a`; F1–F4 y spot-check en verde con renv activo; contraste 0 y 0 en los 19 estados y en N4a–N4d; `docs/index.html` `2e408857…`; a 390, «Establecimiento» termina en 337,3 px contra el borde en 370.
7. **Decisiones autónomas de mayor riesgo:** ninguna fuera de §1.
8. **Desviaciones:** ninguna (renv activo en toda corrida R; scripts en archivo; sin heredocs, sin `node -e` y sin `rm`).
9. **Dudas abiertas:** ninguna de este encargo.
10. **Errores propios:** 2 (verificador de corte por píxeles recalibrado antes de registrar; verificador del LOG que apuntaba al LOG del a7, corregido antes de registrar).
11. **Qué debe verificar el revisor:** en el sitio publicado, el modal de territorio en un teléfono: las cuatro pestañas completas, en una fila a 390 px o más y en dos filas en pantallas más angostas, y el cambio de pestaña con el subrayado.
12. **No publicado / queda al usuario:** nada del motor.
13. **Ejecución:** Opus 5.5, una sesión, 0 subagentes (el encargo no los admite), Babel 8.0.6 en `/tmp/cat_a8_babel`, Puppeteer con Chrome del sistema, renv activo (`RENV_PROJECT` impreso), instrumentos en `/tmp/cat_a8_*`.

## Esqueleto

- FASE 0 — M1, M2, M3, M-DERIVA, M4
- T1 — C4 (pestañas)
- T2 — despliegue
- FASE R — auditoría propia
- FASE L — cierre

### FASE 0

#### M1 — porcelain antes y después del primer commit; stash; archivos del commit

esperado: antes, el registro modificado y el encargo; después, vacío o el LOG; stash vacío; commit = los dos
obtenido:
```
antes:    M 50_documentacion/andamios/20260925_errores_asistente_sesion31.md (2 filas agregadas, 0 quitadas)
         ?? 50_documentacion/activa/encargos/encargo_claude_code_categoria_pestanas_modal_a8.md
aeeee7a chore(encargo): pestañas del modal a8
después: (vacío) · stash: [] · locks en .git: 0
archivos del commit: 50_documentacion/activa/encargos/encargo_claude_code_categoria_pestanas_modal_a8.md, 50_documentacion/andamios/20260925_errores_asistente_sesion31.md
```

#### M2 — fetch; HEAD~1; HEAD..origin/main; origin/main..HEAD

esperado: `HEAD~1` = `484c9f1` = `origin/main`; 0; 1
obtenido:
```
fetch exit=0 (antes del commit: HEAD=484c9f1 origin/main=484c9f1, 0 y 0)
HEAD~1=484c9f1 origin/main=484c9f1 HEAD..origin/main=0 origin/main..HEAD=1
```

#### M3 — md5 de `docs/index.html`; SHA con calibración; PRUEBAS d

Instrumentos copiados de `/tmp/cat_a7_*` a `/tmp/cat_a8_*` con `/tmp/cat_a8_copiar.sh` (36 archivos; 0 referencias a `cat_a7_` en los copiados); Babel copiado a `/tmp/cat_a8_babel` (8.0.6). Recalibraciones: `/tmp/cat_a8_inv.sh` usa el 🔒4 del a8 (incluye `33_app.jsx`); los resúmenes que en el a7 corrían con `node -e` pasan a `/tmp/cat_a8_res_corto.js`; `/tmp/cat_a8_t1.js` agrega `scrollHeight − clientHeight` y la separación mínima entre pestañas vecinas de la misma fila. Toda corrida R arranca en la raíz e imprime `RENV_PROJECT`.

esperado: `d58d2f2c…`; `d9895a78…0442`; fecha alterada → igual; cifra plantada → distinto; PRUEBAS d en verde con renv activo
obtenido:
```
md5 docs d58d2f2c9fbc5469228cdee6be05bb61 | template 4672fde32f09bc489440aaaf9b72c931 | 33_app.jsx 07066acf9bbc0ae827b49d111b3d9066
SHA:            d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
fecha alterada: d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
cifra plantada: 162ff49ef78211c17126c4291b7d2f0f48d875743ec71a4798f1b77d83a15cd8
auditar exit=0 RENV_PROJECT=/Users/tomgc/Projects/slep_categoria_desempeno
  [F1] OK Distribucion territorial (n_ee, n_categorizados, pct) (0 discrepancias)
  [F2] OK Sin categoria vigente (n_ee por motivo) (0 discrepancias)
  [F3] OK Cierre por-EE: nacional = EE distintos del crudo (0 discrepancias)
  [F4] OK Invariante de referencia (Costa Central / basica) (0 discrepancias)
=== AUDITORIA: TODAS LAS FAMILIAS EN VERDE ===
spot exit=0 RENV_PROJECT=/Users/tomgc/Projects/slep_categoria_desempeno
=== SPOT-CHECK OK: 6 celdas de presencia + 1 de ausencia verificadas. ===
```

#### M-DERIVA — retranspilación frente al bloque

esperado: idéntica
obtenido:
```
template 84d079b74d35d93e0412f457020fc066 1614 líneas | retrans 84d079b74d35d93e0412f457020fc066 1614 líneas | distintas: 0
```

#### M4 — Línea base del build de `HEAD` (19 estados y 11 N), con determinismo; C4 como en el a7 M5

esperado: igual entre corridas; motor `d58d2f2c…`; «Establecimiento» cortada en los cuatro anchos; 44/43
obtenido:
```
PRUEBAS a [base]: exit=0; warnings=0; RENV_PROJECT=/Users/tomgc/Projects/slep_categoria_desempeno · motor d58d2f2c9fbc5469228cdee6be05bb61 (= publicado) · PRUEBAS c d9895a78…0442 · docs restaurado d58d2f2c…
cat_a8_base vs cat_a8_base2: capturas AE=0 19/19 · textContent 19/19 · sin detalle 19/19 · bloques 19/19 · contexto 19/19 · errores 0 y 0
cat_a8_baseN vs cat_a8_base2N: capturas AE=0 11/11 · textContent 11/11 · sin detalle 11/11 · bloques 11/11 · contexto 11/11 · errores 0 y 0
candado t0 (base contra base2): 🔒7 30/30 · bloques 887/887 · 🔒9 .traj 885/885, .ee-detail-list 2/2
contraste 19 estados: texto 13722, fallas activas 0 · gráficos exigidos 3009, fallidos 0 (deshabilitados 4 pares y 1 gráfico, exentos) · N4a, N4b, N4c, N4d: texto 1675 c/u, 0 fallas · gráficos 256 c/u, 0 fallidos
C4 (/tmp/cat_a8_t1.js sobre la base), en los cuatro anchos: completas 3/4 · filas 1 · Comuna 42–106.3 | SLEP 130.3–169.4 | Región 193.4–245.7 | Establecimiento 269.7–391.3 (borde 300, 340, 355, 370: cortada) · scrollWidth 371 > clientWidth 280/320/335/350 · scrollHeight − clientHeight = 44 − 43 = 1 · overflow visible/visible · separación mínima en fila 24
N6 (C6, publicado): foco en BUTTON.cmp-add-btn tras clic y tras Enter · errores 0
```

**Cierre FASE 0:** sin reglas de detención activas.

### T1 — C4 (pestañas)

Implementación según §1: tras `.modal-tab.is-active`, el comentario `a8-C4: las pestañas pasan a una segunda fila solo cuando no caben` y `@media (max-width: 560px) { .modal-tabs { padding: 0 16px; flex-wrap: wrap; } .modal-tab { margin-right: 8px; } }`, sin `overflow`. Solo CSS: el bloque de la app no cambia (retranspilación idéntica, 0 hunks en el bloque). Instrumento `/tmp/cat_a8_t1.js`: N4 a 320, 360, 375 y 390 px, cada pestaña activada por clic, subrayado por captura 2×, separación entre pestañas vecinas de la misma fila medida entre rectángulos.

esperado: en los cuatro anchos y con cada pestaña activa, 4 pestañas completas dentro de `.modal-tabs`; `scrollWidth` ≤ `clientWidth`; `scrollHeight − clientHeight` = 1; `overflow` visible en los dos ejes; a 390, una sola fila con cualquier activa; a 375, 360 y 320, 2 filas; subrayado de 2 px en las cuatro; el clic cambia la activa; separación ≥ 8 px; a 1280, capturas de los 19 estados idénticas a la base; 🔒7; 🔒8 en N4a a N4d; 🔒1 a 🔒6
obtenido:
```
build t1: PRUEBAS a exit=0 warnings=0 (renv activo) · motor 2e408857208db6aa8eec094e8f10e5aa (docs del build igual: 🔒5 en el build) · PRUEBAS c d9895a78…0442 (motor y docs) · PRUEBAS d F1–F4 OK, SPOT-CHECK OK 6 + 1 · docs restaurado d58d2f2c…
retranspilación: 84d079b74d35d93e0412f457020fc066 = template (distintas: 0) · template: 1 hunk CSS, 0 en el bloque
320: completas 4/4 · filas 2 (Comuna 36–100.3 | SLEP 108.3–147.4 | Región 155.4–207.7 en la fila 1; Establecimiento 36–157.5 en la fila 2) · sw/cw 280/280 · sh−ch 87−86 = 1 · visible/visible · separación 8
360: completas 4/4 · filas 2 (ídem) · sw/cw 320/320 · sh−ch 1 · visible/visible · separación 8
375: completas 4/4 · filas 2 (ídem) · sw/cw 335/335 · sh−ch 1 · visible/visible · separación 8
390: completas 4/4 · filas 1 (Comuna 36–100.3 | SLEP 108.3–147.4 | Región 155.4–207.7 | Establecimiento 215.7–337.3, borde 370) · sw/cw 350/350 · sh−ch 44−43 = 1 · visible/visible · separación 8
por pestaña activada (Comuna, SLEP, Región, Establecimiento), en los cuatro anchos: el clic deja activa la pestaña pulsada 4/4 · filas 1 a 390 y 2 en los demás con cualquier activa · completas 4/4 · sh−ch 1 · separación 8 · subrayado 4 filas de dispositivo = 2 px en las cuatro
1280: base contra t1, capturas AE=0 19/19, textContent 19/19 · N: textContent 11/11; capturas distintas solo en N4a–N4d (la corrección)
🔒7 [t0] contra la base (= publicado d58d2f2c…): 30/30 · bloques 887/887 · 🔒9 885/885 y 2/2
🔒8 19 estados: texto 0 de 13722, gráficos 0 de 3009 · N4a, N4b, N4c, N4d: texto 0 de 1675 c/u, gráficos 0 de 256 c/u
🔒3 git diff aeeee7a..HEAD -U0 | grep '^+' | grep -ciE '#[0-9a-f]{3,8}\b' → 0 · 🔒4 (con 33_app.jsx) → 0 · 🔒6 idéntica
errores de consola/pageerror: 0 (19 estados y 11 N)
capturas 2× del modal: /tmp/cat_a8_tabs_t1_390.png (1 fila), _375 y _320 (2 filas; el subrayado de una activa de la fila 1 queda entre filas, como documentó el a7)
```
Commit: `59946c8`.

### T2 — Despliegue

Corre porque T1 terminó en verde.

esperado: PRUEBAS a; PRUEBAS c y d sobre `docs/index.html`; 🔒5; por `file://`: 0 errores, las verificaciones de T1 repetidas y 🔒9; C5 y C6 sin cambio frente al publicado; `git status --short` = `M docs/index.html`
obtenido:
```
publicado (HEAD:docs antes del despliegue) md5 d58d2f2c9fbc5469228cdee6be05bb61
PRUEBAS a [t2]: exit=0; warnings=0; RENV_PROJECT=/Users/tomgc/Projects/slep_categoria_desempeno
PRUEBAS c: d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442 (motor) | d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442 (docs)
PRUEBAS d (docs nuevo, renv activo): F1–F4 OK (0 discrepancias), TODAS LAS FAMILIAS EN VERDE; SPOT-CHECK OK 6 + 1
🔒5: docs 2e408857208db6aa8eec094e8f10e5aa = motor 2e408857208db6aa8eec094e8f10e5aa
docs por file://: 19 estados errores 0 · 11 N errores 0 · capturas y textContent idénticos al build t1 (19/19 y 11/11)
T1 repetida sobre docs (/tmp/cat_a8_t1.js + /tmp/cat_a8_t1_chk.js): 320, 360, 375 → 2 filas; 390 → 1 fila; con cada pestaña activa: completas 4/4, sw ≤ cw, sh−ch 1, visible/visible, separación 8, subrayado 2 px, el clic cambia la activa → criterios cumplidos en los cuatro anchos
🔒7 [t0] contra el publicado: 30/30 · bloques 887/887 · 🔒9 885/885 y 2/2
C5 (/tmp/cat_a8_t2.js, SLEP en 5 anchos y EE en 3, layout y píxeles): salida idéntica entre publicado y desplegado · EE 320 146.9×36, 1 línea, puntos suspensivos · SLEP 145×36, ▾ 122.7/15
C6: clic en Limpiar → BUTTON.cmp-add-btn · Enter → BUTTON.cmp-add-btn · a1-F04 ✕ 1/2 y "+ Agregar" (igual que el publicado)
git status --short: " M docs/index.html", "?? <LOG>"
```
Commit: `69c32b4` (`deploy(motor): publica las pestañas del modal en pantallas angostas (a8)`); `git show HEAD:docs/index.html` md5 `2e408857…`, SHA `d9895a78…0442`.

### FASE R — Auditoría propia y reparación

#### R.1 Inventario (anexado antes de auditar)

| id | afirmación | origen |
|---|---|---|
| R-01 | M1/M2: punto de partida; `HEAD~1` = `origin/main` = `484c9f1` | FASE 0 |
| R-02 | M3: SHA `d9895a78…0442`, calibración, PRUEBAS d con renv | FASE 0 |
| R-03 | M-DERIVA: cadena idéntica | FASE 0 |
| R-04 | M4: línea base determinista, motor `d58d2f2c…`, C4 cortada, 44/43 | FASE 0 |
| R-05 | C4 a 390: una sola fila con cualquier pestaña activa | T1 |
| R-06 | C4 a 375, 360 y 320: dos filas; 4/4 completas en los cuatro anchos | T1 |
| R-07 | C4: subrayado de 2 px; `scrollHeight − clientHeight` = 1; `overflow` visible | T1 |
| R-08 | C4: separación ≥ 8 px entre pestañas de la misma fila; el clic cambia la activa | T1 |
| R-09 | Solo CSS: el bloque de la app no cambia | T1 |
| R-10 | Despliegue: `docs/index.html` = build de `HEAD`; C5 y C6 sin cambio | T2 |
| R-11 | 🔒1 | §3 |
| R-12 | 🔒2 | §3 |
| R-13 | 🔒3 | §3 |
| R-14 | 🔒4 | §3 |
| R-15 | 🔒5 | §3 |
| R-16 | 🔒6 | §3 |
| R-17 | 🔒7 | §3 |
| R-18 | 🔒8 | §3 |
| R-19 | 🔒9 | §3 |
| R-20 | Alcance global | FASE R |
| R-21 | Regresión PRUEBAS a–d (y b) | FASE R |
| R-22 | Control positivo: `docs/index.html` de `aeeee7a` corta «Establecimiento» en los cuatro anchos | FASE R |
| R-23 | Proceso: errores propios | propio |

#### R.2–R.6 Re-derivación por caminos distintos, invariantes, alcance, regresión y control positivo

Caminos distintos:
- Filas por bandas de tinta en capturas 2× con cada pestaña activada en los cuatro anchos: `/tmp/cat_a8_rR_capturas.js` y `/tmp/cat_a8_rR_filas.sh`, sobre `/tmp/cat_a8_rR_tabs.js`.
- Subrayado por filas de dispositivo de su color.
- Corte por tinta junto al borde derecho del modal: `/tmp/cat_a8_rR_borde.js`. La primera versión miraba 4 columnas de dispositivo y no veía el corte del control a 360 px, porque cae entre dos letras; se recalibró a 12 columnas (6 px CSS) antes de registrar.
- 🔒7 por `innerText` frente al publicado.
- 🔒1 desde `git show` en node y en Python.
- 🔒9 por coordenada.
- C5 por píxeles y C6 por `focusin` (`/tmp/cat_a8_rR2.js`).

Ningún script en línea.

esperado: filas por píxeles = 1 a 390 y 2 a 375, 360 y 320 con cualquier activa; subrayado de 2 px; 🔒7 por `innerText` 30/30; 🔒1 a 🔒9 con su comando; alcance = template y `docs/index.html` (el encargo y el registro en `<inicio>`; el LOG en `docs(log)`); PRUEBAS a–d en verde y b con 0 errores; `docs/index.html` de `aeeee7a` corta «Establecimiento» en los cuatro anchos
obtenido:
```
── filas y subrayado por píxeles (16 capturas 2× por motor: 4 anchos × 4 pestañas activas)
  desplegado: 320, 360, 375 → 2 filas de pestañas con Comuna, SLEP, Región o Establecimiento activa · 390 → 1 fila con cualquiera · subrayado 4 filas de dispositivo (2 px) en las 16
  control (docs de aeeee7a): 1 fila en los cuatro anchos · subrayado 4 filas de dispositivo en las 16
── corte por tinta en las 12 columnas de dispositivo del borde derecho del modal (Comuna y Establecimiento activas)
  control: SÍ (cortada) a 320, 360, 375 y 390 · desplegado: no en los cuatro anchos (última tinta 370–373 de 559/639/669 a 320–375; 633–636 de 699 a 390)
── 🔒7 por innerText (publicado → desplegado): 30/30 iguales; ningún estado con conteo distinto
── 🔒1
  69c32b4:docs/index.html md5 2e408857208db6aa8eec094e8f10e5aa SHA d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
  aeeee7a:docs/index.html md5 d58d2f2c9fbc5469228cdee6be05bb61 SHA d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
  Python (69c32b4 contra aeeee7a): payload igual salvo la fecha: True · claves de primer nivel distintas: []
── 🔒2 PRUEBAS d [R] (renv activo): F1–F4 OK (0 discrepancias), TODAS LAS FAMILIAS EN VERDE; SPOT-CHECK OK 6 + 1 (también en T1 y T2)
── 🔒3 git diff aeeee7a..HEAD -U0 | grep '^+' | grep -ciE '#[0-9a-f]{3,8}\b' → 0
── 🔒4 git diff aeeee7a..HEAD -- 30_procesamiento/30_* 30_procesamiento/31_* 30_procesamiento/32_* 30_procesamiento/33_generar_html.R 30_procesamiento/34_* 30_procesamiento/33_app.jsx 20_insumos 10_utils tests | wc -l → 0
── 🔒5 docs/index.html 2e408857208db6aa8eec094e8f10e5aa = 40_salidas/motor_categoria.html 2e408857208db6aa8eec094e8f10e5aa (builds t2 y R)
── 🔒6 template 84d079b74d35d93e0412f457020fc066 1614 líneas | retrans 84d079b74d35d93e0412f457020fc066 1614 líneas | distintas: 0
── 🔒7 textContent: T1 contra la base 30/30 · desplegado contra el publicado 30/30
── 🔒8 desplegado: 19 estados texto 0 de 13722, gráficos 0 de 3009 · N4a, N4b, N4c, N4d: texto 0 de 1675 c/u, gráficos 0 de 256 c/u
── 🔒9 por coordenada (docs): S01 62, S05 11, S10 1, S11 5 .traj 2016→2019 con el anillo en 3 de 4 · S03 .ee-detail-list 2019,2018,2017,2016 vigente en 0 de 4 · errores 0
── C5 y C6 (desplegado): SLEP 320 145×36 sin puntos · EE 320 147×36 y EE 390 217×36 en 1 línea con puntos, barra 241 · focusin: clic en Limpiar → [cmp-clear-btn, cmp-add-btn]; Enter → [cmp-add-btn]; a1-F04 igual
── alcance: git diff --name-only aeeee7a..HEAD → 30_procesamiento/33_motor_template.html, docs/index.html · con el commit de inicio (aeeee7a^..HEAD) → + el encargo y 50_documentacion/andamios/20260925_errores_asistente_sesion31.md · el LOG entra con docs(log)
── regresión: PRUEBAS a [R] exit=0, warnings=0 (renv activo), motor 2e408857… = docs de HEAD (reproducible; git restore deja 2e408857…) · c d9895a78…0442 · d en verde · b: 0 errores en 19 + 11 estados del desplegado
── porcelain: solo el LOG · stash: []
```

#### R.7 Tabla de auditoría

| id | afirmación | comando | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | M1/M2 | `git log`; `rev-parse` | `aeeee7a^` = `484c9f1` = `origin/main` | igual | PASA | — | `aeeee7a` | — |
| R-02 | M3 | tres plantas; PRUEBAS d con `RENV_PROJECT` | igual/igual/distinto; verde | igual | PASA | — | — | — |
| R-03 | M-DERIVA | retranspilación | idéntica | idéntica | PASA | — | — | — |
| R-04 | M4 | dos corridas; md5; control por píxeles | iguales; `d58d2f2c…`; cortada | 19/19 y 11/11; `d58d2f2c…`; cortada en 4 anchos | PASA | — | — | — |
| R-05 | 390 una fila | bandas de tinta, 4 activas | 1 | 1 | PASA | — | `59946c8` | — |
| R-06 | 2 filas y 4/4 | bandas de tinta; tinta en el borde | 2 a 320–375; sin corte | 2; sin corte en 4 anchos | PASA | — | `59946c8` | — |
| R-07 | subrayado, sh−ch, overflow | filas de dispositivo; `cat_a8_t1_chk.js` | 2 px; 1; visible | 2 px en 16 capturas; 1; visible | PASA | — | `59946c8` | — |
| R-08 | separación y clic | `cat_a8_t1_chk.js` | ≥ 8; la activa cambia | 8; 4/4 | PASA | — | `59946c8` | — |
| R-09 | solo CSS | hunks; retranspilación | 0 en el bloque | 0; idéntica | PASA | — | — | — |
| R-10 | despliegue fiel; C5 y C6 | `git show` + md5; `cat_a8_t2.js`; `focusin` | = build; sin cambio | igual; salida idéntica; igual | PASA | — | `69c32b4` | — |
| R-11 | 🔒1 | node y Python sobre `git show` | `d9895a78…`; igual salvo fecha | igual; True | PASA | — | — | — |
| R-12 | 🔒2 | PRUEBAS d [R] | verde | verde | PASA | — | — | — |
| R-13 | 🔒3 | comando de §3 | 0 | 0 | PASA | — | — | — |
| R-14 | 🔒4 | comando de §3 | 0 | 0 | PASA | — | — | — |
| R-15 | 🔒5 | md5 | docs = motor | igual | PASA | — | — | — |
| R-16 | 🔒6 | retranspilación | idéntica | idéntica | PASA | — | — | — |
| R-17 | 🔒7 | `textContent` e `innerText` | 30/30 | 30/30 y 30/30 | PASA | — | — | — |
| R-18 | 🔒8 | instrumento del a3 | 0 y 0 | 0 y 0 | PASA | — | — | — |
| R-19 | 🔒9 | nodos y coordenada | ascendente / descendente | 885/885, 2/2; igual | PASA | — | — | — |
| R-20 | alcance | `git diff --name-only` | template, docs (+ encargo y registro en inicio; LOG) | igual | PASA | — | — | — |
| R-21 | regresión | PRUEBAS a–d y b | verde; 0 | verde; 0 | PASA | — | — | — |
| R-22 | control positivo | píxeles y rectángulos sobre docs de `aeeee7a` | cortada en 4 anchos | cortada en 4 anchos | PASA | — | — | — |
| R-23 | proceso | revisión propia | — | el verificador de corte por píxeles se recalibró (4 → 12 columnas de dispositivo) antes de registrar, porque a 360 px el corte del control cae entre dos letras; el verificador del LOG copiado del a7 apuntaba al LOG del a7 y se corrigió antes de registrar; sin `node -e` en línea, sin heredocs y sin `rm` en este encargo | ADVIERTE | declarado | — | — |

**Ciclos de reparación:** 0. **Veredicto FASE R: SIN BLOQUEO** (0 BLOQUEA, 0 REPARA, 1 ADVIERTE: R-23). No hace falta revertir el despliegue.

### FASE L — Cierre

#### Resumen

C4 quedó corregido y publicado con la forma aprobada: `padding: 0 16px`, `flex-wrap: wrap` y `margin-right: 8px`, en pantallas de hasta 560 px. A 390 px las cuatro pestañas caben en una sola fila con cualquiera activa; a 375, 360 y 320 «Establecimiento» pasa a una segunda fila, y en todos los anchos se ven completas, con 8 px de separación y el subrayado de 2 px. Solo cambió CSS: el bloque de la app, el payload, las cifras y el texto quedaron idénticos. C5 y C6 siguen como estaban publicados. Con este despliegue quedan publicados los seis defectos del pendiente #1 del traspaso v30 (C1 a C6).

#### Commits

`aeeee7a` encargo y registro de errores · `59946c8` T1 · `69c32b4` despliegue · (este) `docs(log)`.

#### Invariantes

🔒1 a 🔒9 PASAN (🔒7 por `textContent` y por `innerText`).

#### md5 de `docs/index.html` desplegado

`2e408857208db6aa8eec094e8f10e5aa` (= `40_salidas/motor_categoria.html` de los builds t2 y R; SHA del payload `d9895a78…0442`).

#### Pestañas por ancho (posición en px CSS, filas y separación)

| ancho | antes (publicado `d58d2f2c…`) | después (desplegado `2e408857…`) |
|---|---|---|
| 320 | 1 fila: Comuna 42–106,3 · SLEP 130,3–169,4 · Región 193,4–245,7 · Establecimiento 269,7–391,3 (borde 300: cortada) · separación 24 | 2 filas: Comuna 36–100,3 · SLEP 108,3–147,4 · Región 155,4–207,7 / Establecimiento 36–157,5 · separación 8 · completas 4/4 |
| 360 | 1 fila, ídem (borde 340: cortada) | 2 filas, ídem 320 |
| 375 | 1 fila, ídem (borde 355: cortada) | 2 filas, ídem 320 |
| 390 | 1 fila, ídem (borde 370: cortada) | 1 fila: Comuna 36–100,3 · SLEP 108,3–147,4 · Región 155,4–207,7 · Establecimiento 215,7–337,3 · separación 8 · completas 4/4 |

En todos los anchos, antes y después: `scrollHeight − clientHeight` = 1, `overflow` visible/visible y subrayado de 2 px. Con cada pestaña activa las filas no cambian.

#### Dudas con pregunta cerrada

Ninguna abierta por este encargo.

#### Errores propios

1. El primer verificador de corte por píxeles (4 columnas de dispositivo) no veía el corte del control a 360 px, porque cae entre dos letras. Se recalibró a 12 columnas antes de registrar; ninguna cifra salió de la primera versión.
2. `/tmp/cat_a8_verificar_log.sh`, copiado del a7, seguía apuntando al LOG del a7: la ruta no lleva el prefijo `cat_a7_` y la copia no la reescribió. Su primera corrida verificó el LOG equivocado; se corrigió la ruta y se repitió sobre este LOG antes de registrar.

#### Privacidad

`/tmp/cat_a8_priv.sh`. Control: una copia del LOG con tres plantas ficticias (`/tmp/cat_a8_priv_control.md`) da RUT 1, RBD+n 1 y nombre EE 1, es decir, detecta. LOG: RUT 0, RBD+n 0, nombre EE 0 (vacío).

#### Lo que falló o sorprendió

- Nada falló en la corrección: el cálculo del encargo (311,2 contra 318 px a 390) se cumplió tal cual, con «Establecimiento» terminando en 337,3 px.
- Sorpresa menor en la auditoría: el primer verificador de corte por píxeles no veía un corte que cae entre dos letras (R-23).
- Con dos filas, el subrayado de una pestaña activa de la primera fila queda entre las filas y no sobre el separador. Ya estaba en la evidencia del a7 que respaldó Q-C4b y no cambia ningún criterio.

#### Verificación del archivo

`grep -c '^esperado:'` → 8 · `grep -c '^obtenido:'` → 8 (iguales) · `grep -c '^## J'` → 1 · hex en el LOG (`grep -ciE '#[0-9a-f]{3,8}\b'`) → 0 · privacidad 0 / 0 / 0 (control plantado: 1 / 1 / 1).

#### Estado de cierre

T1 COMPLETADA · T2 COMPLETADA (despliegue `69c32b4`) · FASE R SIN BLOQUEO · push según autorización tras este commit · sin shells en segundo plano.
