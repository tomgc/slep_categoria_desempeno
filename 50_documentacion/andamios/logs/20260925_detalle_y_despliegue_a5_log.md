# Log — Detalle por año del vigente al más antiguo, y despliegue de a2 a a5 (a5)

- **Fecha:** 2026-09-25
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_categoria_detalle_y_despliegue_a5.md`
- **Proyecto:** `slep_categoria_desempeno`
- **Ejecutor:** Claude Code (Opus 5.5, sesión única, sin subagentes)
- **Punto de retorno (`<inicio>`):** `f7fc4c5` (padre `a6a997a`)
- **Privacidad:** este log no lleva RBD con número ni nombres de establecimiento.

## J. Juicio (lo rellena FASE L)

1. **Meta y resultado:** revertir O2 del a4 y desplegar a2–a5; resultado: detalle 2019→2016 con el vigente primero, trayectoria 2016→2019 intacta, motor publicado en `docs/index.html`.
2. **Estado por tarea:** T1 y T2 completadas; FASE R sin bloqueo; FASE L completa.
3. **Commits:** `f7fc4c5` encargo, `22826e9` T1, `56f6629` despliegue y el de este LOG (`docs(log)`).
4. **Auditoría:** 19 filas; 0 BLOQUEA, 0 REPARA, 0 ADVIERTE; control positivo (motor del a4, detalle ascendente) presente.
5. **Invariantes:** 🔒1 a 🔒8 PASAN.
6. **Cifras críticas:** SHA payload `d9895a78…0442` antes y después del despliegue; F1–F4 y spot-check en verde; contraste 0 y 0; `docs/index.html` = `788d5026…`.
7. **Decisiones autónomas de mayor riesgo:** ninguna fuera de §1.
8. **Desviaciones:** ninguna.
9. **Dudas abiertas:** ninguna de este encargo.
10. **Errores propios:** ninguno.
11. **Qué debe verificar el revisor:** en el sitio publicado, las cabeceras, una trayectoria (2019 a la derecha), el detalle de un establecimiento (2019 arriba) y el comparador.
12. **No publicado / queda al usuario:** nada del motor; la entrada del backlog sobre el orden (c.20) la escribe el cierre de la sesión.
13. **Ejecución:** Opus 5.5, una sesión, 0 subagentes, Babel 8.0.6 copiado a `/tmp/cat_a5_babel`, Puppeteer con Chrome del sistema, `renv` activo, instrumentos en `/tmp/cat_a5_*`.

## Esqueleto

- FASE 0 — M1, M2, M3, M-DERIVA, M5, M6
- T1 — revertir O2 (R1)
- T2 — despliegue
- FASE R — auditoría propia
- FASE L — cierre

### FASE 0

#### M1 — porcelain tras el primer commit; stash; archivos del primer commit

esperado: el parquet preexistente y el LOG; stash vacío; primer commit = solo el encargo
obtenido:
```
?? 40_salidas/categoria_rbd_contrato.parquet
?? 50_documentacion/andamios/logs/20260925_detalle_y_despliegue_a5_log.md
stash: []
f7fc4c5 chore(encargo): detalle y despliegue a5

50_documentacion/activa/encargos/encargo_claude_code_categoria_detalle_y_despliegue_a5.md
```

#### M2 — fetch; HEAD~1; HEAD..origin/main; origin/main..HEAD

esperado: `HEAD~1` = `a6a997a` = `origin/main`; 0; 1
obtenido:
```
HEAD~1=a6a997a origin/main=a6a997a HEAD..origin/main=0 origin/main..HEAD=1
```

#### M3 — md5 de §2; SHA del payload (fecha normalizada) del motor del a4; PRUEBAS d

Instrumentos copiados de `/tmp/cat_a4_*` a `/tmp/cat_a5_*` (rutas reescritas; 0 referencias a `cat_a4_`); Babel copiado de `/tmp/cat_a4_babel`. Recalibración del recorrido: el texto de 🔒7 (i) quita **solo** `.ee-detail-list` (en el a4 quitaba también `.traj`). Copia del motor del a4 en `/tmp/cat_a5_motor_a4.html` para el control positivo.

esperado: motor `dbbf5722…`; docs `45e612f1…`; SHA `d9895a78…0442`; fecha alterada → igual; cifra plantada → distinto; PRUEBAS d en verde
obtenido:
```
md5 motor dbbf572202d2de1a7bb5cbf97f397793 | docs 45e612f1c9909a2dd1115d9e8628cde0
SHA:            d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
fecha alterada: d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
cifra plantada: 162ff49ef78211c17126c4291b7d2f0f48d875743ec71a4798f1b77d83a15cd8
auditar_cifras.R exit=0, TODAS LAS FAMILIAS EN VERDE; spot_check_publicado.R exit=0, 6 + 1 OK
```

#### M-DERIVA

esperado: cadena idéntica
obtenido:
```
template 46024c67b4a51df3cb7987f3f5dcca58 1602 líneas | retrans 46024c67b4a51df3cb7987f3f5dcca58 1602 líneas | distintas: 0
```

#### M5 — orden en el motor del a4 (`/tmp/cat_a5_orden.js`, orden de nodos)

esperado: `.traj` ascendente; `.ee-detail-list` ascendente con el vigente al final; `.ee-evol-list` ascendente
obtenido:
```
S01: 62 .traj 2016,2017,2018,2019, anillo en 3 de 4 · S05: 11 · S10: 1 · S11: 5 (ídem)
S03: 62 .traj (ídem) · .ee-detail-list 2016,2017,2018,2019, vigente en 3 de 4 · .ee-evol-list 2016,2017,2018,2019 · delta «2016→2019: -1 (-1,7%)»
errores 0
```

#### M6 — línea base de los 19 estados, con determinismo

esperado: 19/19 igual entre corridas
obtenido:
```
/tmp/cat_a5_base y /tmp/cat_a5_base2: textContent 19/19; texto sin .ee-detail-list y bloques de años 19/19; capturas 19/19 AE=0; errores 0 y 0
```

**Cierre FASE 0:** sin reglas de detención activas.

### T1 — Revertir O2 (R1)

Implementación en `33_app.jsx`, `EeRow`: `serieAsc` (ascendente) → `serieDesc` con `b.anio - a.anio` y su único uso; comentario `a5: el detalle vertical va del vigente al más antiguo; la trayectoria horizontal (Trayectoria) sigue ascendente`. `Trayectoria` no se tocó. Retranspilación completa y reemplazo del bloque entero.

esperado: 🔒7 completo en los 19 estados, por nodos y por coordenada: (i) texto sin `.ee-detail-list` igual; (ii) cada `.ee-detail-list` con pares iguales, descendente, vigente en el índice 0; (iii) cada `.traj` ascendente con el anillo en el último año; (iv) `.ee-evol-list` y delta sin cambio; `grep -c serieAsc` = 0; `grep -c 'b.anio - a.anio'` = 1; PRUEBAS a, c y d; 🔒3, 🔒4, 🔒6, 🔒8; 0 errores
obtenido:
```
grep -c serieAsc 33_app.jsx → 0 ; grep -c 'b.anio - a.anio' → 1 (línea 1003, EeRow); Trayectoria sigue con a.anio - b.anio (línea 948)
/tmp/cat_a5_reemplazar.sh: template b3e5650f6576a1a570d7e42b23012a9d 1603 | retrans b3e5650f6576a1a570d7e42b23012a9d 1603 | distintas: 0
PRUEBAS a [t1]: exit=0; warnings=0 | motor 788d5026562a67a73af43abffd97034e
PRUEBAS c: d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
PRUEBAS d: F1–F4 OK (0 discrepancias); spot 6 + 1 OK; docs restaurado 45e612f1c9909a2dd1115d9e8628cde0
🔒7 (/tmp/cat_a5_candado7.js): (i) 19/19 · (ii) detalle: pares iguales 2/2, descendente con 2019 primero 2/2 · (iii) trayectoria: pares iguales 631/631, ascendente con 2019 al final 631/631
   control del instrumento (a4 contra a4): (ii) descendente 0/2 (discrimina)
orden por nodos y por coordenada (idénticos): S01 62, S05 11, S10 1, S11 5 .traj 2016→2019 con anillo en 3 de 4; S03 .ee-detail-list 2019,2018,2017,2016 con vigente en 0 de 4; .ee-evol-list 2016,2017,2018,2019; delta «2016→2019: -1 (-1,7%)» (iv sin cambio)
🔒8: texto 0 fallas de 13.725; gráficos exigidos 0 de 3.009; resumen idéntico a la base
🔒3 hunks del template fuera del bloque: 0; hex en líneas agregadas: 0 · 🔒4 0 · 🔒6 cadena idéntica
errores 0
```
Commit: `22826e9`.

### T2 — Despliegue

esperado: PRUEBAS a exit 0 y 0 warnings; `docs/index.html` con el build nuevo (no se restaura); PRUEBAS c sobre `docs/index.html` = `d9895a78…0442`; PRUEBAS d en verde; 🔒5 md5 `docs/index.html` = md5 `40_salidas/motor_categoria.html`; `docs/index.html` por `file://`: 0 errores en los 19 estados, `meta.cat_colors` = {"INSUFICIENTE":"#D0112D","MEDIO-BAJO":"#E05D2F","MEDIO":"#2A8FD9","ALTO":"#0062A0"}, `.traj` ascendentes y `.ee-detail-list` descendentes; `git status --short` = ` M docs/index.html` más el parquet (y el LOG)
obtenido:
```
PRUEBAS a: exit=0; warnings=0
🔒5 md5 docs/index.html 788d5026562a67a73af43abffd97034e = md5 40_salidas/motor_categoria.html 788d5026562a67a73af43abffd97034e
PRUEBAS c (docs/index.html): d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
meta.cat_colors (docs): {"INSUFICIENTE":"#D0112D","MEDIO-BAJO":"#E05D2F","MEDIO":"#2A8FD9","ALTO":"#0062A0"}
PRUEBAS d (docs nuevo): F1–F4 OK (0 discrepancias); spot 6 + 1 OK
docs/index.html por file://: 19 estados, errores 0; 🔒7 (i) 19/19, (ii) 2/2 y 2/2, (iii) 631/631 y 631/631; S01 .traj 2016→2019 anillo en 3 de 4; S03 .ee-detail-list 2019→2016 vigente en 0 de 4
git status --short: " M docs/index.html", "?? 40_salidas/categoria_rbd_contrato.parquet", "?? <LOG>"
```
Commit: `56f6629`.

### FASE R — Auditoría propia y reparación

#### R.1 Inventario (anexado antes de auditar)

| id | afirmación | origen |
|---|---|---|
| R-01 | M1/M2 punto de partida | FASE 0 |
| R-02 | M3 SHA de referencia y calibración | FASE 0 |
| R-03 | M-DERIVA | FASE 0 |
| R-04 | M5/M6 | FASE 0 |
| R-05 | R1: detalle descendente con el vigente primero; `serieAsc` 0; un solo `b.anio - a.anio` | T1 |
| R-06 | `.traj` sigue ascendente con el anillo al final | T1 |
| R-07 | `.ee-evol-list` y delta sin cambio | T1 |
| R-08 | Despliegue: `docs/index.html` = build de `HEAD` | T2 |
| R-09 | 🔒1 (antes y después del despliegue) | §3 |
| R-10 | 🔒2 | §3 |
| R-11 | 🔒3 | §3 |
| R-12 | 🔒4 | §3 |
| R-13 | 🔒5 | §3 |
| R-14 | 🔒6 | §3 |
| R-15 | 🔒7 | §3 |
| R-16 | 🔒8 | §3 |
| R-17 | Alcance global | FASE R |
| R-18 | Regresión PRUEBAS a–d | FASE R |
| R-19 | Control positivo sobre el motor del a4 | FASE R |

#### R.2–R.6 Re-derivación, invariantes, alcance, regresión y control positivo

esperado: el payload del `docs/index.html` del commit de despliegue (`git show 56f6629:docs/index.html`) igual al del a4; orden por coordenada coherente con T1; 🔒1–🔒8 PASAN; alcance = `33_app.jsx`, template y `docs/index.html` (más el LOG); PRUEBAS a–d en verde; el motor del a4 sigue mostrando el detalle ascendente
obtenido:
```
git show 56f6629:docs/index.html → md5 788d5026562a67a73af43abffd97034e; node SHA d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442; Python: payload == payload del a4 sin la fecha → True
docs del commit, orden por coordenada: S01 62, S05 11, S10 1, S11 5 .traj 2016→2019 con anillo en 3 de 4; S03 .ee-detail-list 2019,2018,2017,2016 vigente en 0 de 4; evolución 2016→2019; delta «2016→2019: -1 (-1,7%)»; errores 0
control positivo (motor del a4, por nodos y por coordenada): S03 .ee-detail-list 2016,2017,2018,2019, vigente en 3 de 4
regresión: PRUEBAS a [R] exit=0, warnings=0; el build reescribe docs/index.html idéntico al commit (788d5026… en docs, 40_salidas y commit; porcelain sin cambios); PRUEBAS c d9895a78…0442; d F1–F4 OK y spot 6 + 1 OK
🔒1 c = d9895a78…0442 antes (T1) y después (T2, docs) del despliegue · 🔒2 verde · 🔒3 hunks fuera del bloque 0, hex agregados 0 · 🔒4 0
🔒5 md5 docs/index.html = md5 40_salidas/motor_categoria.html = 788d5026562a67a73af43abffd97034e · 🔒6 cadena idéntica (b3e5650f…)
🔒7 (docs): (i) 19/19; (ii) 2/2 y 2/2; (iii) 631/631 y 631/631 · 🔒8 (docs): texto 0 de 13.725, gráficos 0 de 3.009
alcance: 30_procesamiento/33_app.jsx, 30_procesamiento/33_motor_template.html, docs/index.html; porcelain: parquet + LOG; stash 0
```

#### R.7 Tabla de auditoría

| id | afirmación | comando | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | M1/M2 | `git log -1 f7fc4c5^` | `a6a997a` | `a6a997a` | — | — | — | — |
| R-02 | M3 | tres plantas | igual/igual/distinto | sí | — | — | — | — |
| R-03 | M-DERIVA | retranspilación | idéntica | idéntica | — | — | — | — |
| R-04 | M5/M6 | control positivo; segunda corrida | ascendente; 19/19 | sí | — | — | — | — |
| R-05 | R1 detalle | orden por coordenada; greps | 2019 primero; 0; 1 | sí; 0; 1 | PASA | — | `22826e9` | — |
| R-06 | trayectoria sin cambio | orden por coordenada | ascendente, anillo al final | sí | PASA | — | — | — |
| R-07 | evolución y delta | orden por coordenada | sin cambio | sin cambio | PASA | — | — | — |
| R-08 | despliegue fiel | `git show` + md5 | = build de HEAD | 788d5026… = 788d5026… | PASA | — | `56f6629` | — |
| R-09 | 🔒1 | node y Python sobre el commit | `d9895a78…` | igual | PASA | — | — | — |
| R-10 | 🔒2 | PRUEBAS d | verde | verde | PASA | — | — | — |
| R-11 | 🔒3 | hunks y hex | 0; 0 | 0; 0 | PASA | — | — | — |
| R-12 | 🔒4 | diff | 0 | 0 | PASA | — | — | — |
| R-13 | 🔒5 | md5 | iguales | iguales | PASA | — | — | — |
| R-14 | 🔒6 | retranspilación | idéntica | idéntica | PASA | — | — | — |
| R-15 | 🔒7 | `/tmp/cat_a5_candado7.js` sobre docs | 19/19; 2/2; 631/631 | igual | PASA | — | — | — |
| R-16 | 🔒8 | instrumento del a3 sobre docs | 0 y 0 | 0 y 0 | PASA | — | — | — |
| R-17 | alcance | `git diff --name-only` | 3 rutas | 3 rutas | PASA | — | — | — |
| R-18 | regresión | PRUEBAS a–d | verde | verde | PASA | — | — | — |
| R-19 | control positivo | orden en el motor del a4 | detalle ascendente | ascendente | PASA | — | — | — |

**Ciclos de reparación:** 0. **Veredicto FASE R: SIN BLOQUEO** (0 BLOQUEA, 0 REPARA, 0 ADVIERTE); no hace falta revertir el despliegue.

### FASE L — Cierre

#### Resumen

El detalle "Trayectoria y matrícula por año" vuelve a empezar en el año vigente (2019 → 2016); la trayectoria horizontal sigue ascendente con el vigente a la derecha, y la evolución de la matrícula no cambia. Luego se publicó en `docs/index.html` el motor con a2, a3, a4 y esta reversión: payload idéntico al del a4, pruebas del dato en verde, 0 errores y 0 fallas de contraste en los 19 estados del archivo publicado.

#### Commits

`f7fc4c5` encargo · `22826e9` T1 · `56f6629` despliegue · (este) `docs(log)`.

#### Invariantes

🔒1 a 🔒8 PASAN.

#### md5 de `docs/index.html` publicado

`788d5026562a67a73af43abffd97034e` (igual a `40_salidas/motor_categoria.html`).

#### Dudas con pregunta cerrada

Ninguna abierta por este encargo.

#### Errores propios

Ninguno.

#### Privacidad

`/tmp/cat_a5_priv.sh` con control plantado (tres plantas ficticias en una copia del LOG: detecta 1/1/1); LOG: 0 / 0 / 0.

#### Estado de cierre

T1 y T2 COMPLETADAS · FASE R SIN BLOQUEO · `docs/index.html` desplegado en `56f6629` · push según autorización tras este commit · sin shells en segundo plano.
