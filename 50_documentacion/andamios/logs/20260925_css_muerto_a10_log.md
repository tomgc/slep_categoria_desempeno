# Log — Limpieza del CSS muerto del motor, y despliegue (a10)

- **Fecha:** 2026-09-25
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_categoria_css_muerto_a10.md`
- **Proyecto:** `slep_categoria_desempeno`
- **Ejecutor:** Claude Code (Opus 5.5, sesión única, sin subagentes)
- **Punto de retorno (`<inicio>`):** `845fbcd` (padre `047bf4e`)
- **Privacidad:** este log no lleva RBD con número, nombres de establecimiento ni hex.

## J. Juicio (lo rellena FASE L)

1. **Meta y resultado:** retirar el CSS muerto heredado (pendiente #3 del traspaso v30) sin cambiar nada visible, y desplegar. Resultado: 196 reglas y 1 `@media` borrados, 2 listas recortadas, 157 clases fuera; render idéntico en los 30 estados; motor publicado 23.385 bytes más liviano.
2. **Estado por tarea:** FASE 0 completa; T1 COMPLETADA; T2 COMPLETADA (despliegue); FASE R sin bloqueo; FASE L completa.
3. **Commits:** `845fbcd` encargo · `596d1fb` T1 · `812aab1` despliegue · (este) `docs(log)`.
4. **Auditoría:** 22 filas; 0 BLOQUEA, 0 REPARA, 1 ADVIERTE (R-22 proceso); 0 ciclos; control positivo presente.
5. **Invariantes:** 🔒1 a 🔒9 PASAN.
6. **Cifras críticas:** SHA `d9895a78…0442` en la base, en t1, t2 y R, y desde `git show` de `812aab1` y `845fbcd`; F1–F4 y spot-check en verde con renv; contraste 0 y 0; template 134.601 → 111.216 bytes; motor 1.912.775 → 1.889.390 bytes; `docs/index.html` `587f4233…`.
7. **Decisiones autónomas de mayor riesgo:** borrar solo líneas completas (el plan en seco verificó 0 líneas compartidas con contenido que se conserva), y dejar que el comentario interno de `.chart-cell` se fuera con su regla.
8. **Desviaciones:** ninguna (renv activo; scripts en archivo; sin heredocs ni `rm`), salvo las dos de R-22.
9. **Dudas abiertas:** ninguna de este encargo.
10. **Errores propios:** 2 (primera corrida de M3 con el script copiado que usaba `Rscript -e` de varios pasos, repetida; un `node -p` en línea para una versión).
11. **Qué debe verificar el revisor:** una pasada visual por el sitio publicado (territorio, establecimiento, modal y comparador): nada debería verse distinto.
12. **No publicado / queda al usuario:** los 11 comentarios huérfanos del `<style>`, candidatos para una pasada futura.
13. **Ejecución:** Opus 5.5, una sesión, 0 subagentes (el encargo no los admite), `postcss` 8.5.28 local en `/tmp/cat_a10_css`, Babel 8.0.6 en `/tmp/cat_a10_babel`, Puppeteer con Chrome del sistema, renv activo (`RENV_PROJECT` impreso), instrumentos en `/tmp/cat_a10_*`.

## Esqueleto

- FASE 0 — M1, M2, M3, M-DERIVA, M4, M5
- T1 — C1 y C2
- T2 — despliegue
- FASE R — auditoría propia
- FASE L — cierre

### FASE 0

#### M1 — porcelain antes y después del primer commit; stash; archivos del commit

esperado: antes, el encargo; después, vacío o el LOG; stash vacío; commit = el encargo
obtenido:
```
antes:   ?? 50_documentacion/activa/encargos/encargo_claude_code_categoria_css_muerto_a10.md
845fbcd chore(encargo): CSS muerto a10
después: (vacío) · stash: []
archivos del commit: 50_documentacion/activa/encargos/encargo_claude_code_categoria_css_muerto_a10.md
```

#### M2 — fetch; HEAD~1; HEAD..origin/main; origin/main..HEAD

esperado: `HEAD~1` = `047bf4e` = `origin/main`; 0; 1
obtenido:
```
fetch exit=0 (antes del commit: HEAD=047bf4e origin/main=047bf4e, 0 y 0)
HEAD~1=047bf4e origin/main=047bf4e HEAD..origin/main=0 origin/main..HEAD=1
```

#### M3 — md5 del template y de `docs/index.html`; SHA con calibración; PRUEBAS d

Instrumentos copiados de `/tmp/cat_a8_*` a `/tmp/cat_a10_*` con `/tmp/cat_a10_copiar.sh` (41 archivos; 0 referencias a `cat_a8_`). El verificador del LOG seguía apuntando al LOG del a8 y se corrigió en la copia. Las corridas R van en archivos `.R` (`/tmp/cat_a10_build.R`, `_auditar.R`, `_spot.R`), arrancan en la raíz con renv activo e imprimen `RENV_PROJECT`. La primera corrida de M3 salió con el `m3.sh` copiado del a8, que usaba `Rscript -e` de varios pasos (la reescritura había fallado porque el archivo no se había leído). Se reescribió y se repitió, y esa repetición es la que vale.

esperado: `b72f73d9…`; `2e408857…`; `d9895a78…0442`; fecha alterada → igual; cifra plantada → distinto; PRUEBAS d en verde con renv
obtenido:
```
md5 template b72f73d99a0b23a9d8b832feb52ad141 (134601 bytes) | docs 2e408857208db6aa8eec094e8f10e5aa | 33_app.jsx 07066acf9bbc0ae827b49d111b3d9066
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

#### M4 — Lista de clases muertas recalculada (`/tmp/cat_a10_m4.js`, `postcss` 8.5.28 en `/tmp/cat_a10_css`)

Método de §1: clases = tokens `.<clase>` en los selectores de las reglas del `<style>` (postcss; sin comentarios, sin el contenido de `[…]`). Viva = palabra completa (sin `[A-Za-z0-9_-]` pegado) en `33_app.jsx`, en el template fuera del `<style>` (HTML y todos los `<script>`, incluido el transpilado) o en `33_generar_html.R`. La lista del encargo se leyó del propio archivo del encargo, sin transcribirla.

esperado: 317 clases; 157 muertas; la misma lista, clase por clase; 196 reglas completas y 2 mixtas
obtenido:
```
<style> en las líneas 8 a 1535 del template
clases distintas en el CSS: 317 · muertas: 157 · vivas: 160
reglas: 432 · completas (todos los selectores con clase muerta): 196 · mixtas: 2
  mixta (líneas 250–266): «.select, .input» · selectores con clase muerta: .select
  mixta (líneas 267–271): «.select:focus, .input:focus» · selectores con clase muerta: .select:focus
lista del encargo: 157 clases · de más en el cálculo: [] · de menos: [] · MISMA LISTA, clase por clase
reglas por padre (/tmp/cat_a10_m4b.js): raíz 418 · @media 8 · @keyframes 6 (0%, 100% · 50% · from · to · from · to, en pulse, fadeIn y lift)
```
El total de 432 reglas frente a los 429 de §1 se explica por cómo se cuentan los `@keyframes`: postcss cuenta cada selector de fotograma como regla (6), y §1 cuenta cada `@keyframes` como una (3); 418 + 8 + 3 = 429. Ninguna clase interviene, y 196 y 2 coinciden. La regla 4 no se activa (la lista es la misma).

#### M5 — Línea base del build de `HEAD` (19 estados y 11 N), con determinismo

La medición común (`/tmp/cat_a10_medir.js`) agrega, para 🔒7, los estilos computados de las 28 propiedades del encargo en cada elemento visible de `document.body`, en orden de documento (`<estado>.estilos.json`). Comparador: `/tmp/cat_a10_cmp7.js` (AE con ImageMagick, `textContent` y estilos, estado por estado).

esperado: igual entre corridas; motor `2e408857…`
obtenido:
```
PRUEBAS a [base]: exit=0; warnings=0; RENV_PROJECT=… · motor 2e408857208db6aa8eec094e8f10e5aa (1912775 bytes) · PRUEBAS c d9895a78…0442 · docs restaurado 2e408857…
TOTAL cat_a10_base vs cat_a10_base2: capturas AE=0 19/19 · textContent 19/19 · estilos computados 19/19
TOTAL cat_a10_baseN vs cat_a10_base2N: capturas AE=0 11/11 · textContent 11/11 · estilos computados 11/11
elementos visibles medidos: S01 1679 · S02 1604 · S02b 1604 · S03 1782 · S04 1846 · S05 389 · S06 2729 · S06b 2729 · S07 1802 · S08 1742 · S09 1874 · S10 124 · S11 238 · S12 51 · S13 1448 · S14 232 · S15 283 · S15b 283 · S16 283 · N1 122 · N2 124 · N3 124 · N4a–N4d 2729 c/u · N5, N5m, N5d 123 c/u · N6 51
candado t0: 🔒7 textContent 30/30 · bloques 887/887 · 🔒9 .traj 885/885, .ee-detail-list 2/2
contraste 19 estados: texto 13722, 0 fallas activas · gráficos exigidos 3009, 0 fallidos · N4a–N4d: 1675 y 256 c/u, 0 y 0
errores 0 en las cuatro corridas
```

**Cierre FASE 0:** sin reglas de detención activas.

### T1 — C1 y C2

Script `/tmp/cat_a10_t1_borrar.js` (postcss para ubicar reglas; se borran líneas completas y se preserva byte a byte el resto).

1. Toma la lista de M4.
2. Marca como unidad de borrado cada regla con todos sus selectores con una clase muerta. Un `@media` cuyas reglas son todas muertas se borra entero.
3. Verifica que ninguna línea a borrar tenga contenido que se conserva.
4. Aplica C2 por reemplazo exacto de su línea.

En modo seco reportó 0 conflictos antes de escribir.

esperado: reglas borradas 196, listas recortadas 2 y `@media` vacíos borrados (cantidad informada); 0 de las 157 en el CSS y las 160 vivas presentes; 🔒3 (2 líneas agregadas, todas dentro del `<style>` de la base); bytes antes → después; 🔒6, 🔒7 estado por estado, 🔒8, 🔒9, 🔒1, 🔒2 y 🔒4; comentarios huérfanos listados
obtenido:
```
unidades de borrado: 196 (reglas sueltas 195, @media vaciados 1: «@media (max-width: 900px) { .heat-legend … }», línea 756) · reglas borradas: 196 · listas recortadas (C2): 2
  C2 línea 250: «.select, .input {» → «.input {»
  C2 línea 267: «.select:focus, .input:focus {» → «.input:focus {»
líneas borradas: 595 · conflictos: 0
template: 134601 → 111216 bytes (−23385) · 3184 → 2589 líneas · md5 b72f73d9… → fce2d439d4571f3bdd37fd85ecab8d47 · <style> ahora en 8–940
template nuevo (/tmp/cat_a10_clases_nuevo.js): reglas 236 (= 432 − 196) · @media 6 (antes 7) · clases en el CSS 160 · muertas que siguen: 0 · vivas (160) que faltan: 0 · clases nuevas: 0
🔒3 (/tmp/cat_a10_candado3.sh): líneas agregadas 2 · borradas 597 · hunks 29 · líneas de la base tocadas entre 155 y 1533 · hunks fuera del <style> de la base (8–1535): 0
🔒6: template 84d079b74d35d93e0412f457020fc066 1614 líneas | retrans 84d079b74d35d93e0412f457020fc066 1614 líneas | distintas: 0 · bloque transpilado antes = después (84d079b7…)
build t1: PRUEBAS a exit=0 warnings=0 (renv) · motor 587f4233baf7561f332235780a04805a · motor 1912775 → 1889390 bytes (−23385) · PRUEBAS c d9895a78…0442 (motor y docs) · PRUEBAS d F1–F4 OK, SPOT-CHECK OK 6 + 1 · docs restaurado 2e408857…
🔒7 (/tmp/cat_a10_cmp7.js, base contra t1, estado por estado; los 30 con AE 0, textContent igual y 0 elementos con estilos distintos):
  S01 1679 elem. · S02 1604 · S02b 1604 · S03 1782 · S04 1846 · S05 389 · S06 2729 · S06b 2729 · S07 1802 · S08 1742 · S09 1874 · S10 124 · S11 238 · S12 51 · S13 1448 · S14 232 · S15 283 · S15b 283 · S16 283
  N1 122 · N2 124 · N3 124 · N4a 2729 · N4b 2729 · N4c 2729 · N4d 2729 · N5 123 · N5d 123 · N5m 123 · N6 51
  TOTAL: capturas AE=0 19/19 y 11/11 · textContent 19/19 y 11/11 · estilos computados 19/19 y 11/11
🔒8: 19 estados texto 0 de 13722, gráficos 0 de 3009 · N4a–N4d: 0 de 1675 y 0 de 256 c/u
🔒9: .traj 885/885 ascendentes con el anillo al final · .ee-detail-list 2/2 descendentes con el vigente primero
🔒4 git diff 845fbcd..HEAD -- 30_procesamiento/33_app.jsx 30_procesamiento/33_generar_html.R 30_procesamiento/30_* 30_procesamiento/31_* 30_procesamiento/32_* 30_procesamiento/34_* 20_insumos 10_utils tests renv.lock renv 50_documentacion/suite | wc -l → 0
errores de consola/pageerror: 0 (19 estados y 11 N)
comentario dentro de una regla borrada (se va con ella): línea 510, dentro de .chart-cell: /* Un estilo inline sobrescribe el borde completo con el color de la entidad (1px), rodeando la ficha para identificar la columna. */
comentarios huérfanos (no se tocan; quedan sin regla debajo): 11
  línea 301 /* Entities */ · línea 399 /* Results */ · línea 414 /* Fila única bajo el título: controles a la izquierda, leyenda a la derecha (mockup)… */
  línea 424 /* La cabecera de la tabla conserva el layout horizontal (título a la izquierda, controles a …) */ · línea 624 /* Tabla */ · línea 1012 /* Filtro GSE */
  línea 1482 /* Foco año en tabla */ · línea 1488 /* Celda vacía GSE: sin recuadro, fondo transparente */ · línea 1495 /* Heatmap fijo */
  línea 1501 /* Entities-bar: selector nueva estructura */ · línea 1526 /* Estab popup trigger en entidad chip */
  (números de línea de la base)
```
Commit: `596d1fb`.

### T2 — Despliegue

Corre porque T1 terminó en verde.

esperado: PRUEBAS c y d sobre `docs/index.html`; 🔒5; por `file://`: 0 errores y 🔒7 repetido frente al publicado (`2e408857…`); `git status --short` = `M docs/index.html`
obtenido:
```
publicado (HEAD:docs antes del despliegue) 2e408857208db6aa8eec094e8f10e5aa = motor de la base de M5 (misma fuente de las mediciones "base")
PRUEBAS a [t2]: exit=0; warnings=0; RENV_PROJECT=/Users/tomgc/Projects/slep_categoria_desempeno · motor 587f4233baf7561f332235780a04805a (1889390 bytes)
PRUEBAS c: d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442 (motor y docs)
PRUEBAS d (docs nuevo, renv): F1–F4 OK (0 discrepancias), TODAS LAS FAMILIAS EN VERDE; SPOT-CHECK OK 6 + 1
🔒5: docs 587f4233baf7561f332235780a04805a = motor 587f4233baf7561f332235780a04805a
docs por file://: 19 estados errores 0 · 11 N errores 0
🔒7 (publicado contra desplegado): capturas AE=0 19/19 y 11/11 · textContent 19/19 y 11/11 · estilos computados 19/19 y 11/11 · candado textContent 30/30 · 🔒9 885/885 y 2/2
git status --short: " M docs/index.html", "?? <LOG>"
```
Commit: `812aab1` (`deploy(motor): publica el motor sin CSS muerto (a10)`); `git show HEAD:docs/index.html` md5 `587f4233…`, SHA `d9895a78…0442`; `docs/index.html` en el commit: 2 líneas agregadas y 597 borradas (el mismo CSS que el template).

### FASE R — Auditoría propia y reparación

#### R.1 Inventario (anexado antes de auditar)

| id | afirmación | origen |
|---|---|---|
| R-01 | M1/M2: punto de partida; `HEAD~1` = `origin/main` = `047bf4e` | FASE 0 |
| R-02 | M3: md5, SHA `d9895a78…0442`, calibración, PRUEBAS d con renv | FASE 0 |
| R-03 | M-DERIVA: cadena idéntica | FASE 0 |
| R-04 | M4: 317 clases, 157 muertas (la lista de §1), 196 completas y 2 mixtas | FASE 0 |
| R-05 | M5: línea base determinista con estilos computados | FASE 0 |
| R-06 | C1: 196 reglas y 1 `@media` vaciado borrados; C2: 2 listas recortadas | T1 |
| R-07 | Template nuevo: 0 de las 157 en el CSS; las 160 vivas presentes | T1 |
| R-08 | Render idéntico en los 30 estados (capturas, texto y estilos) | T1 y T2 |
| R-09 | Despliegue: `docs/index.html` = build de `HEAD` | T2 |
| R-10 | 🔒1 | §3 |
| R-11 | 🔒2 | §3 |
| R-12 | 🔒3 | §3 |
| R-13 | 🔒4 | §3 |
| R-14 | 🔒5 | §3 |
| R-15 | 🔒6 | §3 |
| R-16 | 🔒7 | §3 |
| R-17 | 🔒8 | §3 |
| R-18 | 🔒9 | §3 |
| R-19 | Alcance global | FASE R |
| R-20 | Regresión PRUEBAS a–d (y b) | FASE R |
| R-21 | Control positivo: la herramienta de 🔒7 detecta el borrado de una regla viva en una copia | FASE R |
| R-22 | Proceso: errores propios | propio |

#### R.2–R.6 Re-derivación por caminos distintos, invariantes, alcance, regresión y control positivo

Caminos distintos:
- Lista de clases muertas por `document.styleSheets` y uso en el DOM con `document.querySelectorAll('.<clase>')` en los 19 estados y los 11 N (medición con `CAT_A10_CLASES=1`, resumen `/tmp/cat_a10_rR_clases.js`).
- Render por diferencia de píxeles con otra herramienta: `/tmp/cat_a10_pxdiff.py`, un decodificador PNG propio en Python (solo `zlib`). Se validó antes contra ImageMagick: bytes idénticos en una captura de 1280 × 900 y otra de 390 × 844, y detecta 49.010 píxeles distintos entre S01 y S05.
- SHA desde `git show` en node y en Python.

esperado: la lista de muertas coincide por el segundo método y ninguna se usa en el DOM; píxeles idénticos con la otra herramienta; 🔒1 a 🔒9 con su comando; alcance = template, `docs/index.html`, el encargo (en `<inicio>`) y el LOG (en `docs(log)`); PRUEBAS a–d en verde; el control positivo detecta el borrado de una regla viva
obtenido:
```
── clases por document.styleSheets y uso en el DOM (30 estados)
  publicado (base): clases en document.styleSheets 317 (en cada estado) · de ellas de la lista de muertas 157 · conjunto = las 317 de M4 · uso en el DOM de las 157: 0 casos
  desplegado:       clases en document.styleSheets 160 (en cada estado) · de la lista de muertas 0 · conjunto = las 160 vivas · uso en el DOM de las 157: 0 casos
── píxeles con el decodificador propio (sin ImageMagick), publicado contra desplegado: 19/19 y 11/11 estados con 0 píxeles distintos
── control positivo (/tmp/cat_a10_control.py: copia del desplegado sin «.entity-select-btn { … }», 8 líneas)
  herramienta de 🔒7: capturas AE=0 6/19 y 1/11 · textContent 19/19 y 11/11 · estilos computados 6/19 y 1/11 → detecta los 13 + 10 estados con el botón de territorio
  decodificador propio: 6/19 estados con 0 píxeles distintos (detecta los mismos 13)
── 🔒1
  812aab1:docs/index.html md5 587f4233baf7561f332235780a04805a SHA d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
  845fbcd:docs/index.html md5 2e408857208db6aa8eec094e8f10e5aa SHA d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
  Python (812aab1 contra 845fbcd): payload igual salvo la fecha: True · claves de primer nivel distintas: []
── 🔒2 PRUEBAS d [R] (renv activo): F1–F4 OK (0 discrepancias), TODAS LAS FAMILIAS EN VERDE; SPOT-CHECK OK 6 + 1 (también en T1 y T2)
── 🔒3 (/tmp/cat_a10_candado3.sh 845fbcd HEAD): líneas agregadas 2 · borradas 597 · hunks 29 · líneas de la base tocadas entre 155 y 1533 · hunks fuera del <style> de la base (8–1535): 0
── 🔒4 git diff 845fbcd..HEAD -- 30_procesamiento/33_app.jsx 30_procesamiento/33_generar_html.R 30_procesamiento/30_* 30_procesamiento/31_* 30_procesamiento/32_* 30_procesamiento/34_* 20_insumos 10_utils tests renv.lock renv 50_documentacion/suite | wc -l → 0
── 🔒5 docs/index.html 587f4233baf7561f332235780a04805a = 40_salidas/motor_categoria.html 587f4233baf7561f332235780a04805a (builds t2 y R)
── 🔒6 template 84d079b74d35d93e0412f457020fc066 1614 líneas | retrans 84d079b74d35d93e0412f457020fc066 1614 líneas | distintas: 0 (idéntico antes y después)
── 🔒7 T1 y T2: capturas AE=0, textContent y estilos computados 19/19 y 11/11 frente a la base (= publicado); por el decodificador propio, 19/19 y 11/11
── 🔒8 desplegado = t1 (mismo motor): 19 estados texto 0 de 13722, gráficos 0 de 3009 · N4a–N4d 0 de 1675 y 0 de 256 c/u
── 🔒9 885/885 .traj y 2/2 .ee-detail-list
── alcance: git diff --name-only 845fbcd..HEAD → 30_procesamiento/33_motor_template.html, docs/index.html · con el commit de inicio (845fbcd^..HEAD) → + el encargo · el LOG entra con docs(log)
── regresión: PRUEBAS a [R] exit=0, warnings=0 (renv), motor 587f4233… = docs de HEAD (reproducible; git restore deja 587f4233…) · c d9895a78…0442 · d en verde · b: 0 errores en 30 estados (desplegado y en las corridas con el segundo método)
── porcelain: solo el LOG · stash: []
```

#### R.7 Tabla de auditoría

| id | afirmación | comando | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | M1/M2 | `git log`; `rev-parse` | `845fbcd^` = `047bf4e` = `origin/main` | igual | PASA | — | `845fbcd` | — |
| R-02 | M3 | tres plantas; PRUEBAS d con `RENV_PROJECT` | igual/igual/distinto; verde | igual | PASA | — | — | — |
| R-03 | M-DERIVA | retranspilación | idéntica | idéntica | PASA | — | — | — |
| R-04 | M4 | `document.styleSheets` y `querySelectorAll` en 30 estados | 317 / 157 / sin uso | 317; 157; 0 usos | PASA | — | — | — |
| R-05 | M5 | dos corridas | iguales | 19/19 y 11/11 | PASA | — | — | — |
| R-06 | C1 y C2 | script en seco y aplicado; `postcss` sobre el nuevo | 196; 2; `@media` informado | 196; 2; 1 `@media`; 236 reglas | PASA | — | `596d1fb` | — |
| R-07 | clases del CSS nuevo | `document.styleSheets` en el desplegado | 0 muertas; 160 vivas | 0; las 160 | PASA | — | `596d1fb` | — |
| R-08 | render idéntico | decodificador PNG propio | 0 píxeles distintos | 19/19 y 11/11 | PASA | — | `596d1fb` | — |
| R-09 | despliegue fiel | `git show` + md5 | = build de HEAD | `587f4233…` = `587f4233…` | PASA | — | `812aab1` | — |
| R-10 | 🔒1 | node y Python sobre `git show` | `d9895a78…`; igual salvo fecha | igual; True | PASA | — | — | — |
| R-11 | 🔒2 | PRUEBAS d [R] | verde | verde | PASA | — | — | — |
| R-12 | 🔒3 | `/tmp/cat_a10_candado3.sh` | 2 agregadas; todo en 8–1535 | 2; 0 hunks fuera | PASA | — | — | — |
| R-13 | 🔒4 | comando de §3 | 0 | 0 | PASA | — | — | — |
| R-14 | 🔒5 | md5 | docs = motor | igual | PASA | — | — | — |
| R-15 | 🔒6 | retranspilación | idéntica | idéntica | PASA | — | — | — |
| R-16 | 🔒7 | cmp7 y decodificador propio | 30/30 | 30/30 por los dos caminos | PASA | — | — | — |
| R-17 | 🔒8 | instrumento del a3 | 0 y 0 | 0 y 0 | PASA | — | — | — |
| R-18 | 🔒9 | candado | ascendente / descendente | 885/885, 2/2 | PASA | — | — | — |
| R-19 | alcance | `git diff --name-only` | template, docs (+ encargo en inicio; LOG) | igual | PASA | — | — | — |
| R-20 | regresión | PRUEBAS a–d y b | verde; 0 | verde; 0 | PASA | — | — | — |
| R-21 | control positivo | copia sin `.entity-select-btn` | la herramienta detecta | 13/19 y 10/11 distintos | PASA | — | — | — |
| R-22 | proceso | revisión propia | — | (a) la primera corrida de M3 usó el `m3.sh` copiado del a8, con `Rscript -e` de varios pasos, porque la reescritura falló por no haber leído el archivo; se reescribió y se repitió; (b) un `node -p` en línea de una sola expresión para imprimir la versión de `postcss`; (c) sin heredocs ni `rm` | ADVIERTE | declarado | — | — |

**Ciclos de reparación:** 0. **Veredicto FASE R: SIN BLOQUEO** (0 BLOQUEA, 0 REPARA, 1 ADVIERTE: R-22). No hace falta revertir el despliegue.

### FASE L — Cierre

#### Resumen

Se retiró el CSS muerto heredado de `slep_simce_adecuado`. Salieron 196 reglas cuyas clases no usa nadie (157 clases), un `@media` que quedó vacío, y el selector `.select` en dos listas mixtas. Solo hubo borrado de líneas completas y dos recortes, todos dentro del `<style>`. El bloque de la app, el payload, las cifras y el render quedaron idénticos en los 30 estados medidos (capturas, texto y 28 propiedades computadas por elemento). El motor publicado baja 23.385 bytes.

#### Commits

`845fbcd` encargo · `596d1fb` T1 · `812aab1` despliegue · (este) `docs(log)`.

#### Invariantes

🔒1 a 🔒9 PASAN.

#### md5 de `docs/index.html` desplegado

`587f4233baf7561f332235780a04805a` (= `40_salidas/motor_categoria.html` de los builds t1, t2 y R; SHA del payload `d9895a78…0442`).

#### Bytes antes → después

Template `33_motor_template.html`: 134.601 → 111.216 bytes (−23.385; 3.184 → 2.589 líneas; `<style>` de 8–1535 a 8–940). Motor (`docs/index.html`): 1.912.775 → 1.889.390 bytes (−23.385).

#### Clases retiradas por familia (prefijo)

41 familias, 157 clases: heat-* 18 · entity-* 14 · tt-* 14 · td-* 10 · entities-* 9 · estab-* 8 · table-* 7 · btn-* 6 · chart-* 6 · results-* 6 · hint-* 5 · th-* 5 · field-* 4 · sg-* 4 · is-* 3 · sub-* 3 · supergrid-* 3 · app-* 2 · color-* 2 · empty-* 2 · ent-* 2 · gse-* 2 · icon-* 2 · loading-* 2 · section-* 2 · badge-* 1 · bars-* 1 · brand-* 1 · controls-* 1 · data-* 1 · form-* 1 · formula-* 1 · has-* 1 · multiselect-* 1 · note-* 1 · prelim-* 1 · row-* 1 · select-* 1 · slep-* 1 · sparkline-* 1 · terr-* 1.

#### Comentarios huérfanos (no se tocaron; candidatos para una pasada futura)

11, con su línea en la base:

- 301 «Entities»
- 399 «Results»
- 414 «Fila única bajo el título: controles a la izquierda, leyenda a la derecha…»
- 424 «La cabecera de la tabla conserva el layout horizontal…»
- 624 «Tabla»
- 1012 «Filtro GSE»
- 1482 «Foco año en tabla»
- 1488 «Celda vacía GSE: sin recuadro, fondo transparente»
- 1495 «Heatmap fijo»
- 1501 «Entities-bar: selector nueva estructura»
- 1526 «Estab popup trigger en entidad chip»

Aparte, un comentario estaba dentro de una regla borrada (`.chart-cell`, línea 510) y se fue con ella.

#### Dudas con pregunta cerrada

Ninguna abierta por este encargo.

#### Errores propios

1. La primera corrida de M3 usó el `m3.sh` copiado del a8, con `Rscript -e` de varios pasos: la reescritura falló porque el archivo copiado no se había leído. Se reescribió con `.R` y se repitió; la repetición es la registrada.
2. Un `node -p` en línea (una expresión) para imprimir la versión de `postcss`.

#### Privacidad

`/tmp/cat_a10_priv.sh`. Control: una copia del LOG con tres plantas ficticias (`/tmp/cat_a10_priv_control.md`) da RUT 1, RBD+n 1 y nombre EE 1, es decir, detecta. LOG: RUT 0, RBD+n 0, nombre EE 0 (vacío). Hex en el LOG: 0.

#### Lo que falló o sorprendió

- Nada falló en las tareas.
- La lista de §1 coincidió clase por clase. Todas las reglas muertas ocupaban líneas propias, así que el borrado pudo ser solo de líneas completas y 🔒3 quedó exacto (2 agregadas).
- El único desajuste fue de conteo: 432 reglas según postcss contra 429 en §1, porque postcss cuenta cada fotograma de `@keyframes` como una regla. No toca ninguna clase.

#### Verificación del archivo

`grep -c '^esperado:'` → 9 · `grep -c '^obtenido:'` → 9 (iguales) · `grep -c '^## J'` → 1 · hex en el LOG → 0 · privacidad 0 / 0 / 0 (control plantado: 1 / 1 / 1).

#### Estado de cierre

T1 COMPLETADA · T2 COMPLETADA (despliegue `812aab1`) · FASE R SIN BLOQUEO · push según autorización tras este commit · sin shells en segundo plano.
