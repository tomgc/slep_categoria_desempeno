# Log — Trayectoria en orden cronológico, de izquierda a derecha (a4)

- **Fecha:** 2026-09-25
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_categoria_orden_trayectoria_a4.md`
- **Proyecto:** `slep_categoria_desempeno`
- **Ejecutor:** Claude Code (Opus 5.5, sesión única, sin subagentes)
- **Punto de retorno (`<inicio>`):** `8556323` (padre `118cf25`)
- **Privacidad:** este log no lleva RBD con número ni nombres de establecimiento.

## J. Juicio (lo rellena FASE L)

1. **Meta y resultado:** trayectoria y detalle por año en orden cronológico ascendente; resultado: 633/633 bloques ascendentes en los 19 estados, anillo del vigente al final.
2. **Estado por tarea:** T1, T2 y T3 completadas; FASE R sin bloqueo; FASE L completa.
3. **Commits:** `8556323` encargo, `787ed9c` T1 y el de este LOG (`docs(log)`).
4. **Auditoría:** 19 filas; 0 BLOQUEA, 0 REPARA, 0 ADVIERTE; control positivo (motor del a3 descendente) presente.
5. **Invariantes:** 🔒1 a 🔒8 PASAN.
6. **Cifras críticas:** SHA payload `d9895a78…0442` igual al del a3; F1–F4 y spot-check en verde; contraste 0 y 0; motor `dbbf5722…`; `docs/` `45e612f1…`.
7. **Decisiones autónomas de mayor riesgo:** ninguna fuera de §1 (comentarios redactados para decir lo que hace el código).
8. **Desviaciones:** ninguna.
9. **Dudas abiertas:** Q-DEPLOY.
10. **Errores propios:** ninguno con efecto.
11. **Qué debe verificar el revisor:** trayectorias en básica y media (2016 a la izquierda, 2019 con anillo a la derecha) y el detalle de un establecimiento (2019 al final).
12. **No publicado / queda al usuario:** despliegue conjunto de a2, a3 y a4 a `docs/` (Q-DEPLOY); la entrada del backlog que deja sin efecto el orden de la c.20 la escribe el cierre de la sesión.
13. **Ejecución:** Opus 5.5, una sesión, 0 subagentes, Babel 8.0.6 copiado a `/tmp/cat_a4_babel`, Puppeteer con Chrome del sistema, `renv` activo, instrumentos en `/tmp/cat_a4_*`.

## Esqueleto

- FASE 0 — M1, M2, M3, M-DERIVA, M5, M6
- T1 — orden ascendente (O1, O2)
- T2 — contraste sin regresión
- T3 — build final
- FASE R — auditoría propia
- FASE L — cierre

### FASE 0

#### M1 — porcelain tras el primer commit; stash; archivos del primer commit

esperado: el parquet preexistente y el LOG; stash vacío; primer commit = solo el encargo
obtenido:
```
?? 40_salidas/categoria_rbd_contrato.parquet
?? 50_documentacion/andamios/logs/20260925_orden_trayectoria_a4_log.md
stash: []
8556323 chore(encargo): orden de la trayectoria a4

50_documentacion/activa/encargos/encargo_claude_code_categoria_orden_trayectoria_a4.md
```

#### M2 — fetch; HEAD~1; HEAD..origin/main; origin/main..HEAD

esperado: `HEAD~1` = `118cf25` = `origin/main`; 0; 1
obtenido:
```
HEAD~1=118cf25 origin/main=118cf25 HEAD..origin/main=0 origin/main..HEAD=1
```

#### M3 — md5 de §2; SHA del payload (fecha normalizada) del motor del a3; PRUEBAS d

Instrumentos copiados de `/tmp/cat_a3_*` a `/tmp/cat_a4_*` (rutas reescritas; quedan menciones viejas solo en comentarios); el de payload es el del a2 (solo normaliza la fecha), como pide PRUEBAS c. Babel copiado de `/tmp/cat_a3_babel`.

esperado: motor `9a4e845c…`; docs `45e612f1…`; SHA registrado como referencia; fecha alterada → igual; cifra plantada → distinto; PRUEBAS d en verde
obtenido:
```
md5 motor 9a4e845c41a803ac40fb299c77b54511 | docs 45e612f1c9909a2dd1115d9e8628cde0
SHA referencia (motor del a3): d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
fecha alterada:                d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
cifra plantada:                162ff49ef78211c17126c4291b7d2f0f48d875743ec71a4798f1b77d83a15cd8
auditar_cifras.R exit=0, TODAS LAS FAMILIAS EN VERDE; spot_check_publicado.R exit=0, 6 + 1 OK
```

#### M-DERIVA — bloque del template vs retranspilación

esperado: cadena idéntica
obtenido:
```
template d1419c39dcb5e2f3fd7af098ad634832 1602 líneas | retrans d1419c39dcb5e2f3fd7af098ad634832 1602 líneas | distintas: 0
```

#### M5 — orden de los años en el motor del a3 (`/tmp/cat_a4_orden.js`, modo orden de nodos)

esperado: `.traj` y `.ee-detail-list` descendentes (2019, 2018, 2017, 2016); `.ee-evol-list` ascendente
obtenido:
```
S01: 62 .traj, todas 2019,2018,2017,2016; anillo (rótulo/marca) en el índice 0 de 4
S03: 62 .traj 2019,2018,2017,2016 (anillo en 0) · .ee-detail-list 2019,2018,2017,2016, fila vigente en el índice 0 de 4 · .ee-evol-list 2016,2017,2018,2019 · delta «2016→2019: -1 (-1,7%)»
S05: 11 .traj 2019,2018,2017,2016 (anillo en 0) · S10: 1 .traj (ídem) · S11: 5 .traj (ídem)
errores 0
```
`.ee-evol-list` es ascendente: la hipótesis de §2 se confirma (no se toca).

#### M6 — línea base de los 19 estados (capturas y `textContent`), con determinismo

El recorrido del a3 se amplió para guardar, por estado, el `textContent` de `#root` sin `.traj` ni `.ee-detail-list` y, por bloque, la secuencia de años y el multiconjunto de pares (año | `title` de la marca; texto de la fila del detalle), que usa 🔒7.

esperado: 19/19 texto igual entre corridas
obtenido:
```
/tmp/cat_a4_base y /tmp/cat_a4_base2: texto 19/19 iguales; capturas 19/19 AE=0; errores 0 y 0
contraste de la línea base (referencia de 🔒8): texto 0 fallas activas de 13.725; gráficos exigidos 0 fallidos de 3.009; 4 pares en deshabilitados (exentos)
```

**Cierre FASE 0:** sin reglas de detención activas.

### T1 — Orden ascendente (O1, O2)

Implementación en `33_app.jsx`: `Trayectoria` ordena con `a.anio - b.anio` (comentario del encabezado del bloque: "antiguo -> reciente"; el de la línea: "a4-O1: orden cronológico ascendente: el año más antiguo primero, el vigente al final."); `EeRow`: `serieDesc` → `serieAsc` (declaración y su único uso) con orden ascendente. Retranspilación completa y reemplazo del bloque entero; el CSS no se tocó.

esperado: en S01, S05, S10 y S11 toda `.traj` en 2016, 2017, 2018, 2019 con el anillo (rótulo y marca) en el último año; en S03 `.ee-detail-list` ascendente con la fila vigente al final; `.ee-evol-list` y el delta iguales a M5; `grep -c serieDesc` = 0; PRUEBAS a, c (SHA `d9895a78…0442`) y d; 🔒3 a 🔒7; 0 errores
obtenido:
```
grep -c serieDesc 33_app.jsx → 0
/tmp/cat_a4_reemplazar.sh: template 46024c67b4a51df3cb7987f3f5dcca58 1602 | retrans 46024c67b4a51df3cb7987f3f5dcca58 1602 | distintas: 0
PRUEBAS a [t1]: exit=0; warnings=0 | motor dbbf572202d2de1a7bb5cbf97f397793
PRUEBAS c: d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442 (= referencia de M3)
PRUEBAS d: F1–F4 OK (0 discrepancias); spot 6 + 1 OK; docs restaurado 45e612f1c9909a2dd1115d9e8628cde0
S01: 62 .traj 2016,2017,2018,2019, anillo en el índice 3 de 4 · S05: 11 .traj (ídem) · S10: 1 (ídem) · S11: 5 (ídem)
S03: 62 .traj (ídem) · .ee-detail-list 2016,2017,2018,2019, fila vigente en el índice 3 de 4 · .ee-evol-list 2016,2017,2018,2019 · delta «2016→2019: -1 (-1,7%)» (sin cambio)
🔒3 hunks del template fuera del bloque de la app: 0; hex en líneas agregadas: 0
🔒4 0 · 🔒5 docs 45e612f1c9909a2dd1115d9e8628cde0, 0 rutas de docs en el diff · 🔒6 cadena idéntica
🔒7 (/tmp/cat_a4_candado7.js, 19 estados): (i) texto sin trayectoria/detalle igual 19/19; (ii) pares por bloque iguales 19/19; bloques con años estrictamente ascendentes 633/633 (base S01: 0 de 62)
errores de consola/pageerror: 0
```
Commit: `787ed9c`.

### T2 — Contraste sin regresión (🔒8)

esperado: instrumento de contraste del a3 en los 19 estados del build de T1: 0 fallas de texto y 0 gráficas exigidas en controles activos
obtenido:
```
texto 13.725 mediciones, 0 fallas activas, 0 pares; 4 pares en deshabilitados (exentos); gráficos exigidos 3.009, 0 fallidos
resumen completo (T1–T10, G1–G6, cabeceras) idéntico al de la línea base del a4: true
```
Sin commit (no cambia archivos versionados).

### T3 — Build final

esperado: PRUEBAS a exit 0 y 0 warnings; c `d9895a78…0442`; d en verde con `docs/` nuevo; `docs/` restaurado a `45e612f1…`; md5 del motor nuevo; capturas antes/después de S01, S03 y S05
obtenido:
```
PRUEBAS a [t3]: exit=0; warnings=0 | motor nuevo 40_salidas/motor_categoria.html dbbf572202d2de1a7bb5cbf97f397793 (igual al build t1)
PRUEBAS c: d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
PRUEBAS d: F1–F4 OK (0 discrepancias); spot 6 + 1 OK; docs restaurado 45e612f1c9909a2dd1115d9e8628cde0
19 estados sobre el motor final: errores 0; 🔒7 (i) 19/19, (ii) 19/19, ascendentes 633/633
gate: /tmp/cat_a4_gate/S01, S03, S05 _antes/_despues.png
```

### FASE R — Auditoría propia y reparación

#### R.1 Inventario (anexado antes de auditar)

| id | afirmación | origen |
|---|---|---|
| R-01 | M1/M2 punto de partida | FASE 0 |
| R-02 | M3 SHA de referencia y calibración | FASE 0 |
| R-03 | M-DERIVA cadena idéntica | FASE 0 |
| R-04 | M5 orden descendente en `.traj` y `.ee-detail-list`; `.ee-evol-list` ascendente | FASE 0 |
| R-05 | M6 línea base determinista | FASE 0 |
| R-06 | O1 `.traj` ascendente con el anillo en el último año | T1 |
| R-07 | O2 `.ee-detail-list` ascendente con la fila vigente al final; `serieDesc` → `serieAsc` | T1 |
| R-08 | `.ee-evol-list` y delta sin cambio | T1 |
| R-09 | 🔒1 | §3 |
| R-10 | 🔒2 | §3 |
| R-11 | 🔒3 | §3 |
| R-12 | 🔒4 | §3 |
| R-13 | 🔒5 | §3 |
| R-14 | 🔒6 | §3 |
| R-15 | 🔒7 | §3 |
| R-16 | 🔒8 | T2 |
| R-17 | Alcance global | FASE R |
| R-18 | Regresión PRUEBAS a–d | FASE R |
| R-19 | Control positivo sobre el motor del a3 | FASE R |

#### R.2–R.6 Re-derivación, invariantes, alcance, regresión y control positivo

Camino distinto: `/tmp/cat_a4_orden.js` en modo `geo` ordena los años por coordenada (`getBoundingClientRect().left` en cada `.traj`, `top` en cada `.ee-detail-list`) en vez del orden de nodos.

esperado: motor nuevo ascendente con el anillo al final (también por coordenada); 🔒1–🔒8 PASAN; alcance = `33_app.jsx` y template (más el LOG); PRUEBAS a–d en verde; el motor del a3 sigue descendente con el mismo instrumento
obtenido:
```
nuevo (geo): S01 62 .traj 2016,2017,2018,2019 anillo 3/3 de 4 · S03 detalle 2016,2017,2018,2019 vigente en 3 de 4, evolución 2016,2017,2018,2019, delta «2016→2019: -1 (-1,7%)» · S05 11, S10 1, S11 5 .traj ascendentes con el anillo en 3; errores 0
control positivo (motor del a3 9a4e845c…, geo): todas las .traj 2019,2018,2017,2016 con el anillo en 0; detalle 2019,2018,2017,2016 vigente en 0; evolución 2016,2017,2018,2019 (igual que M5)
regresión: PRUEBAS a [R] exit=0, warnings=0, motor dbbf572202d2de1a7bb5cbf97f397793; c d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442; d F1–F4 OK y spot 6 + 1 OK; docs restaurado 45e612f1…
🔒1 SHA = referencia de M3 · 🔒2 verde
🔒3 hunks del template fuera del bloque de la app (antes de la línea 1558): 0 de 4; hex en líneas agregadas: 0
🔒4 0 · 🔒5 45e612f1c9909a2dd1115d9e8628cde0, docs en el diff 0 · 🔒6 template 46024c67b4a51df3cb7987f3f5dcca58 = retrans (distintas: 0)
🔒7 (i) 19/19; (ii) 19/19; 633/633 bloques ascendentes · 🔒8 texto 0 y gráficos 0 fallas activas (resumen idéntico a la base)
alcance: 30_procesamiento/33_app.jsx, 30_procesamiento/33_motor_template.html; porcelain: parquet + LOG; stash 0
```

#### R.7 Tabla de auditoría

| id | afirmación | comando | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | M1/M2 | `git log -1 8556323^` | `118cf25` | `118cf25` | — | — | — | — |
| R-02 | M3 | tres plantas | igual/igual/distinto | sí | — | — | — | — |
| R-03 | M-DERIVA | retranspilación | idéntica | idéntica | — | — | — | — |
| R-04 | M5 | control positivo en modo geo | descendente; evolución ascendente | sí | — | — | — | — |
| R-05 | M6 | segunda corrida | 19/19 | 19/19 | — | — | — | — |
| R-06 | O1 | orden por coordenada horizontal | ascendente, anillo al final | 2016→2019, anillo en 3 de 4 | PASA | — | `787ed9c` | — |
| R-07 | O2 | orden por coordenada vertical; `grep serieDesc` | ascendente, vigente al final; 0 | sí; 0 | PASA | — | `787ed9c` | — |
| R-08 | evolución y delta sin cambio | geo | igual a M5 | igual | PASA | — | — | — |
| R-09 | 🔒1 | PRUEBAS c | `d9895a78…` | igual | PASA | — | — | — |
| R-10 | 🔒2 | PRUEBAS d | verde | verde | PASA | — | — | — |
| R-11 | 🔒3 | hunks y hex | 0; 0 | 0; 0 | PASA | — | — | — |
| R-12 | 🔒4 | diff | 0 | 0 | PASA | — | — | — |
| R-13 | 🔒5 | md5 + diff | `45e612f1…`; 0 | igual; 0 | PASA | — | — | — |
| R-14 | 🔒6 | retranspilación | idéntica | idéntica | PASA | — | — | — |
| R-15 | 🔒7 | `/tmp/cat_a4_candado7.js` | 19/19, 19/19, todos ascendentes | 19/19, 19/19, 633/633 | PASA | — | — | — |
| R-16 | 🔒8 | instrumento del a3 | 0 y 0 | 0 y 0 | PASA | — | — | — |
| R-17 | alcance | `git diff --name-only` | 33_app.jsx y template | sí | PASA | — | — | — |
| R-18 | regresión | PRUEBAS a–d | verde | verde | PASA | — | — | — |
| R-19 | control positivo | modo geo en el motor del a3 | descendente | descendente | PASA | — | — | — |

**Ciclos de reparación:** 0. **Veredicto FASE R: SIN BLOQUEO** (0 BLOQUEA, 0 REPARA, 0 ADVIERTE; control positivo presente).

### FASE L — Cierre

#### Resumen

La trayectoria de categoría y el detalle "Trayectoria y matrícula por año" pasan a orden cronológico ascendente (2016 → 2019), con el anillo del año vigente al final. Cambio solo en `33_app.jsx` (dos `sort`, un renombre y dos comentarios), llevado al template por retranspilación completa; sin CSS ni color. Payload idéntico al del a3, pruebas del dato en verde, texto sin otro cambio que el orden, contraste sin regresión, `docs/` restaurado.

#### Commits

`8556323` encargo · `787ed9c` T1 · (este) `docs(log)`.

#### Invariantes

🔒1 a 🔒8 PASAN.

#### md5 del motor nuevo

`40_salidas/motor_categoria.html`: `dbbf572202d2de1a7bb5cbf97f397793`. `docs/index.html`: `45e612f1c9909a2dd1115d9e8628cde0` (restaurado; no se despliega).

#### Dudas con pregunta cerrada

- **Q-DEPLOY:** ¿Se despliega el motor nuevo (a2 + a3 + a4) a `docs/index.html` tras la revisión en pantalla? Sí / No.

#### Errores propios

Ninguno con efecto en cifras o archivos. Nota de instrumento: los scripts copiados del a3 conservan menciones a `cat_a1`/`cat_a2`/`cat_a3` solo en comentarios de cabecera.

#### Privacidad

`/tmp/cat_a4_priv.sh` con control plantado (tres plantas ficticias en una copia del LOG: detecta 1/1/1); LOG: 0 / 0 / 0.

#### Estado de cierre

T1, T2 y T3 COMPLETADAS · FASE R SIN BLOQUEO · `docs/index.html` restaurado · push según autorización tras este commit · sin shells en segundo plano.
