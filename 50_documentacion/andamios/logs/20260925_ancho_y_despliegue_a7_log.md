# Log — Pestañas del modal y botón de territorio en pantallas angostas, y despliegue (a7)

- **Fecha:** 2026-09-25
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_categoria_ancho_y_despliegue_a7.md`
- **Proyecto:** `slep_categoria_desempeno`
- **Ejecutor:** Claude Code (Opus 5.5, sesión única, sin subagentes)
- **Punto de retorno (`<inicio>`):** `b8d9d46` (padre `099101a`)
- **Privacidad:** este log no lleva RBD con número ni nombres de establecimiento; los estados se identifican por índice o por hash corto (sha256, 8 caracteres), los mismos del a6.

## J. Juicio (lo rellena FASE L)

1. **Meta y resultado:** resolver C4 y C5 con el replanteo del titular y desplegar lo que estuviera en verde. Resultado: C5 corregido y verificado; C4 congelado por la regla 5 (a 390 px dos filas; `scrollHeight` ≤ `clientHeight` inalcanzable por construcción); publicados C1, C2, C3, C5 y C6.
2. **Estado por tarea:** FASE 0 completa; T1 CONGELADA (regla 5, sin commit); T2 COMPLETADA; T3 COMPLETADA (despliegue); FASE R sin bloqueo; FASE L completa.
3. **Commits:** `b8d9d46` encargo y registro de errores · `2c779fb` T2 · `1d9b9d9` despliegue · (este) `docs(log)`.
4. **Auditoría:** 24 filas; 0 BLOQUEA, 0 REPARA, 3 ADVIERTE (R-06 T1 congelada; R-18 `innerText` del botón; R-24 proceso); 0 ciclos; control positivo presente.
5. **Invariantes:** 🔒1 a 🔒9 PASAN (🔒7 por `textContent`; por `innerText`, única diferencia el salto de línea del botón, declarada).
6. **Cifras críticas:** SHA `d9895a78…0442` en la base, en t1, t2, t3 y R, y desde `git show` de `1d9b9d9` y `b8d9d46`; F1–F4 y spot-check en verde con renv activo; contraste 0 y 0 en los 19 estados y en N4a–N4d y N5; `docs/index.html` `d58d2f2c…`; SLEP 145×36 con el ▾ a 122,7 px (base 122,6).
7. **Decisiones autónomas de mayor riesgo:** congelar C4 aunque resolvía el corte en los cuatro anchos, porque a 390 px deja dos filas; clasificar ADVIERTE (no REPARA) la diferencia de `innerText` del botón, porque no es una cadena nueva y el nombre accesible no cambia.
8. **Desviaciones:** ninguna de entorno (renv activo en toda corrida R; sin heredocs en zsh; sin `rm`). Mensaje de despliegue ajustado a lo publicado (T3.3). Las alternativas de C4 se midieron inyectando CSS solo en el navegador, sin tocar fuentes.
9. **Dudas abiertas:** Q-C4b y Q-SH (pregunta cerrada en FASE L).
10. **Errores propios:** 2 (`Write` sin lectura previa, sin efecto en las cifras; `node -e` en línea en vez de scripts en archivo).
11. **Qué debe verificar el revisor:** en el sitio publicado, la narrativa de un EE (frase 3), la nota de cobertura ("el Simce 2022"), "Limpiar" en el comparador (foco en "+ Agregar"), el botón de territorio con un nombre largo en un teléfono (una línea con puntos suspensivos; nombre completo al mantener el cursor) y el SLEP por defecto sin recorte. El modal en un teléfono sigue con «Establecimiento» cortada (C4 no publicado).
12. **No publicado / queda al usuario:** C4 (Q-C4b, Q-SH).
13. **Ejecución:** Opus 5.5, una sesión, 0 subagentes (la sesión estaba en modo ultracode, pero el encargo no los admite), Babel 8.0.6 en `/tmp/cat_a7_babel`, Puppeteer con Chrome del sistema, renv activo en toda corrida R (`RENV_PROJECT` impreso), instrumentos en `/tmp/cat_a7_*`.

## Esqueleto

- FASE 0 — M1, M2, M3, M-DERIVA, M4, M5
- T1 — C4 (pestañas)
- T2 — C5 (botón de territorio)
- T3 — despliegue
- FASE R — auditoría propia
- FASE L — cierre

### FASE 0

#### M1 — porcelain antes y después del primer commit; stash; archivos del primer commit

esperado: antes, el encargo y el registro de errores; después, vacío o el LOG; stash vacío; commit = los dos archivos
obtenido:
```
antes:   ?? 50_documentacion/activa/encargos/encargo_claude_code_categoria_ancho_y_despliegue_a7.md
         ?? 50_documentacion/andamios/20260925_errores_asistente_sesion31.md
b8d9d46 chore(encargo): ancho y despliegue a7
después: (vacío) · stash: [] · locks en .git: 0
archivos del commit: 50_documentacion/activa/encargos/encargo_claude_code_categoria_ancho_y_despliegue_a7.md, 50_documentacion/andamios/20260925_errores_asistente_sesion31.md
```

#### M2 — fetch; HEAD~1; HEAD..origin/main; origin/main..HEAD

esperado: `HEAD~1` = `099101a` = `origin/main`; 0; 1
obtenido:
```
fetch exit=0 (antes del commit: HEAD=099101a origin/main=099101a, 0 y 0)
HEAD~1=099101a origin/main=099101a HEAD..origin/main=0 origin/main..HEAD=1
```

#### M3 — md5 de `docs/index.html`; SHA del payload con calibración; PRUEBAS d

Instrumentos copiados de `/tmp/cat_a6_*` a `/tmp/cat_a7_*` con `/tmp/cat_a7_copiar.sh` (rutas reescritas; 0 referencias a `cat_a6_` en los copiados); Babel copiado de `/tmp/cat_a6_babel` (8.0.6 / 8.0.6 / 8.0.1). Candidato del a6 presente: `/tmp/cat_a6_t2_candidato.patch`, md5 `05904b58aeb54192977146fb7889f705` (premisa verificada; C5 se implementa igual desde §1, que es la fuente). Toda corrida R arranca en la raíz e imprime `RENV_PROJECT`.

esperado: `788d5026…`; `d9895a78…0442`; fecha alterada → igual; cifra plantada → distinto; PRUEBAS d en verde con renv activo
obtenido:
```
md5 docs 788d5026562a67a73af43abffd97034e | template bc1f97844fbddcbb0d9335a5fb335ed6 | 33_app.jsx 7c7bc7f88a577c06f41a7d4539d040b5
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

#### M-DERIVA — bloque del template vs retranspilación de `33_app.jsx`

esperado: cadena idéntica
obtenido:
```
template 328d625b2cd7d2409e21d26afd37a395 1611 líneas | retrans 328d625b2cd7d2409e21d26afd37a395 1611 líneas | distintas: 0
```

#### M4 — Línea base: build de `HEAD` sin cambios, 19 estados y estados nuevos, con determinismo

Recorrido `/tmp/cat_a7_nuevos.js`, recalibrado del a6: N4 también a 360 × 740 (N4c) y 375 × 667 (N4d); filas de pestañas (`top` distintos), `scrollHeight`, `clientHeight` y `overflow` computado; líneas del botón como `top` distintos del primer nodo de texto (con `text-overflow` Chrome da dos rectángulos por línea); `scrollWidth` y `clientWidth` del nombre; posición del ▾ por un rango sobre el carácter; el SLEP por defecto también a 360 y 375. Contraste en N4a a N4d y N5. Los estados N son los del a6 (`/tmp/cat_a7_estados.json` = el del a6), ahora 11: N1, N2, N3, N4a, N4b, N4c, N4d, N5, N5m, N5d y N6.

esperado: igual entre corridas; motor md5 `6871dcb0…`
obtenido:
```
PRUEBAS a [base]: exit=0; warnings=0; RENV_PROJECT=/Users/tomgc/Projects/slep_categoria_desempeno
md5 motor 6871dcb039da5b05144f4819e973aa8e | PRUEBAS c d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442 | docs restaurado 788d5026562a67a73af43abffd97034e
cat_a7_base vs cat_a7_base2: capturas AE=0 19/19 · textContent 19/19 · sin detalle 19/19 · bloques 19/19 · contexto 19/19 · errores 0 y 0
cat_a7_baseN vs cat_a7_base2N: capturas AE=0 11/11 · textContent 11/11 · sin detalle 11/11 · bloques 11/11 · contexto 11/11 · errores 0 y 0 · defectos.json idéntico
candado t0 (base contra base2): 🔒7 30/30 · bloques 887/887 · 🔒9 .traj 885/885, .ee-detail-list 2/2
contraste 19 estados: texto 13722, fallas activas 0 · gráficos exigidos 3009, fallidos 0 · deshabilitados 4 pares y 1 gráfico (exentos)
contraste N4a, N4b, N4c, N4d, N5: texto 6789, fallas activas 0 · gráficos exigidos 1035, fallidos 0
```

#### M5 — Reproducción en la línea base

esperado: C4 cortada a 320, 360 y 375; a 390, cortada según el a6; C5 como en el a6 (N5 a 320: 9 líneas, barra 385; SLEP 145×36)
obtenido:
```
C4 N4b 320: .modal-tabs [20, 300] padding 22/22 margen 24 nowrap · clientWidth 280 scrollWidth 371 · clientHeight 43 scrollHeight 44 · overflow visible/visible · filas 1 · Comuna 42–106.3 | SLEP 130.3–169.4 | Región 193.4–245.7 | Establecimiento 269.7–391.3 CORTADA
   N4c 360: .modal-tabs [20, 340] · clientWidth 320 scrollWidth 371 · clientHeight 43 scrollHeight 44 · filas 1 · Establecimiento 269.7–391.3 CORTADA
   N4d 375: .modal-tabs [20, 355] · clientWidth 335 scrollWidth 371 · clientHeight 43 scrollHeight 44 · filas 1 · Establecimiento 269.7–391.3 CORTADA
   N4a 390: .modal-tabs [20, 370] · clientWidth 350 scrollWidth 371 · clientHeight 43 scrollHeight 44 · filas 1 · Establecimiento 269.7–391.3 CORTADA
C5 N5 320: EE botón 147.7×180, gap 8px, 9 líneas, barra 385 (0.678), desborde 0 || SLEP 145×36, ▾ a 122.6 px del borde izquierdo y 15 del derecho, 1 línea, barra 241
   N5m 390: EE 216.9×108, 5 líneas, barra 313 · N5d 1280: EE 834.5×36, 1 línea, barra 205 · SLEP 145×36 a 320, 360, 375, 390 y 1280 (▾ a 122.6 del borde izquierdo en todos)
C1–C3 y C6 ya en HEAD: N1 sin frase 3; N2 y N3 con la variante; N6 foco en BUTTON.cmp-add-btn tras clic y tras Enter
errores 0
```
Nota: en la base, `.modal-tabs` ya tiene `scrollHeight` 44 contra `clientHeight` 43 en los cuatro anchos. Es el `margin-bottom: -1px` de `.modal-tab`, que hace que el subrayado activo de 2 px pise el separador.

**Cierre FASE 0:** sin reglas de detención activas.

### T1 — C4 (pestañas) — CONGELADA (regla 5)

Implementación según §1: tras `.modal-tab.is-active`, `@media (max-width: 560px) { .modal-tabs { padding: 0 16px; flex-wrap: wrap; } .modal-tab { margin-right: 16px; } }` (sin `overflow`), con el comentario `a7-C4: …`. Solo CSS: el bloque de la app no cambia (retranspilación idéntica). Instrumento `/tmp/cat_a7_t1.js`: N4 a 320, 360, 375 y 390 px, cada pestaña activada por clic, subrayado por captura 2× (filas de dispositivo del color del borde inferior computado de la activa en el 60 % central de su ancho).

esperado: en los cuatro anchos, las 4 pestañas completas dentro de `.modal-tabs` con `scrollWidth` ≤ `clientWidth` y `scrollHeight` ≤ `clientHeight`; `overflow` computado `visible` en los dos ejes; a 390, una sola fila; a 320, filas informadas; subrayado activo de 2 px en las cuatro pestañas; el clic cambia la activa; a 1280, capturas de los 19 estados idénticas a la base; 🔒7 sin cadenas nuevas; 🔒8 en N4; 🔒1 a 🔒6
obtenido:
```
build t1: PRUEBAS a exit=0 warnings=0 (renv activo) · motor 7c78bec72394323a8171929a37014da3 · PRUEBAS c d9895a78…0442 (motor y docs) · PRUEBAS d F1–F4 OK, SPOT-CHECK OK 6 + 1 · docs restaurado 788d5026…
retranspilación idéntica (328d625b…); template: 1 hunk CSS, 0 en el bloque
320: completas 4/4 · filas 2 (Comuna, SLEP y Región arriba; Establecimiento 36–157.5 abajo) · scrollWidth 280 ≤ 280 ✓ · scrollHeight 87 ≤ clientHeight 86 ✗ · overflow visible/visible ✓
360: completas 4/4 · filas 2 · scrollWidth 320 ≤ 320 ✓ · scrollHeight 87 / clientHeight 86 ✗ · visible/visible ✓
375: completas 4/4 · filas 2 · scrollWidth 335 ≤ 335 ✓ · scrollHeight 87 / clientHeight 86 ✗ · visible/visible ✓
390: completas 4/4 · filas 2 ✗ (una sola fila exigida) · scrollWidth 350 ≤ 350 ✓ · scrollHeight 87 / clientHeight 86 ✗ · visible/visible ✓
por pestaña activada (los cuatro anchos): el clic cambia la activa 4/4 ✓ · subrayado 4 filas de dispositivo = 2 px ✓ en las 4 · filas 2 con cualquier activa
suma de anchos de las pestañas a 390 (la activa en negrita): 277.3 (Comuna) · 276.7 (SLEP) · 277.1 (Región) · 279.2 (Establecimiento); clientWidth 350
línea base (sin C4): scrollHeight 44 / clientHeight 43 en los cuatro anchos; subrayado 4 filas de dispositivo (2 px)
1280: base contra t1, capturas AE=0 19/19, textContent 19/19 ✓ · 🔒7 [t0] 30/30 ✓ · 🔒9 885/885 y 2/2 ✓ · 🔒8 N4a a N4d y N5: texto 0 de 6789, gráficos 0 de 1035 ✓ · errores 0
captura del candidato a 390 (2×): /tmp/cat_a7_tabs_t1_390.png (Establecimiento en la segunda fila)
```
**Dictamen.** Dos criterios de T1 no se alcanzan dentro de la lista cerrada, que tiene una sola forma (no hay un segundo intento distinto posible):
1. **A 390 px, dos filas.** En la partición de filas, cada pestaña ocupa su ancho más `margin-right` (también la última). Con `padding: 0 16px` y `margin-right: 16px`, eso da 279,2 + 4 × 16 = 343,2 px contra 350 − 32 = 318 px de ancho interior, y «Establecimiento» baja a la segunda fila.
2. **`scrollHeight` ≤ `clientHeight`.** Es inalcanzable por construcción, junto con el criterio del subrayado de 2 px: el `margin-bottom: -1px` de `.modal-tab` (preexistente; la base da 44/43) hace que el segundo píxel del subrayado pise el separador, y ese píxel es el que excede `clientHeight`.

**Regla 5:** la edición se revierte a mano, `git diff HEAD` = 0 en las dos fuentes, T1 queda congelada (duda Q-C4b) y se sigue con T2. Para decidir, el cálculo de una sola fila a 390 px exige 279,2 + 4 × M ≤ 350 − 2 × P (P = relleno horizontal, M = `margin-right`). Cumplen, por ejemplo, P = 16 y M = 8 (311,2 ≤ 318) o P = 12 y M = 10 (319,2 ≤ 326); P = 12 y M = 12 no alcanza (327,2 > 326).

esperado: `git diff HEAD` = 0 en `33_app.jsx` y el template; retranspilación idéntica; docs `788d5026…`
obtenido:
```
git diff HEAD en las dos fuentes: 0 líneas · template bc1f97844fbddcbb0d9335a5fb335ed6 = HEAD bc1f97844fbddcbb0d9335a5fb335ed6
template 328d625b2cd7d2409e21d26afd37a395 1611 líneas | retrans 328d625b2cd7d2409e21d26afd37a395 1611 líneas | distintas: 0
docs 788d5026562a67a73af43abffd97034e · porcelain: solo el LOG
```
Sin commit de T1.

### T2 — C5 (botón de territorio)

Implementación según §1. En `33_app.jsx`: `title={entity.nom}` y `<span className="entity-select-nom">{entity.nom}</span> ▾`, con el comentario `a7-C5: …`. En el template: `.entity-select-btn` con `gap: 4px` (antes 8px) y `max-width: 100%; min-width: 0;`; regla nueva `.entity-select-nom`; regla nueva `.controls-bar .control-group { min-width: 0; max-width: 100%; }`. Retranspilación completa y reemplazo del bloque entero. Instrumento `/tmp/cat_a7_t2.js`: medición por layout y por captura 1× (caja por píxeles del borde, líneas como bandas de tinta, puntos suspensivos como cola de tinta solo en la franja baja, columna del ▾).

esperado: N5 a 320 con el botón en una línea, borde derecho dentro del viewport y `.controls-bar` a lo más tan alta como con el SLEP; `title` = nombre completo; SLEP a 320, 360, 375, 390 y 1280 sin recorte (`scrollWidth` ≤ `clientWidth` del nombre y sin puntos suspensivos en la captura); botón del SLEP a 1280 dentro de ±1 px de 145 y ▾ dentro de ±1 px de la base; desborde de `#root` 0 a 320, 390 y 1280; 🔒7 sin cadenas nuevas; 🔒8 en N5; 🔒1 a 🔒6
obtenido:
```
/tmp/cat_a7_reemplazar.sh: template 84d079b74d35d93e0412f457020fc066 1614 | retrans 84d079b74d35d93e0412f457020fc066 1614 | distintas: 0 · template: 4 hunks CSS, 2 en el bloque
build t2: PRUEBAS a exit=0 warnings=0 (renv activo) · motor d58d2f2c9fbc5469228cdee6be05bb61 · PRUEBAS c d9895a78…0442 (motor y docs) · PRUEBAS d F1–F4 OK, SPOT-CHECK OK 6 + 1 · docs restaurado 788d5026…
               base (antes)                                            →  t2 (después)
EE 320:   147.7×180, 9 líneas, barra 385, ▾ a 124.6/15.6             →  146.9×36 [133.1, 280], 1 línea, barra 241, nombre 793/106 con puntos (captura: sí), title = nombre ✓
EE 390:   216.9×108, 5 líneas, barra 313                              →  216.9×36, 1 línea, barra 241, puntos (captura: sí)
EE 1280:  834.5×36, 1 línea, barra 205                                →  834.6×36, 1 línea, barra 205, nombre completo 793/793
SLEP 320: 145×36, ▾ a 122.6 del borde izq. y 15 del der. (píxeles 125/16) → 145×36, ▾ 122.7/15 (píxeles 125/16), nombre 104/104, sin puntos ✓
SLEP 360, 375, 390: igual que 320 en base y en t2 (145×36; nombre 104/104; sin puntos) ✓
SLEP 1280: 145×36 [533.8, 678.8], ▾ 122.6/15 (píxeles 124/17)       →  145×36 [533.8, 678.9], ▾ 122.7/15 (píxeles 124/17) ✓ (±1)
desborde #root: 0 a 320, 390 y 1280 (EE y SLEP) ✓ · barra con el EE ≤ barra con el SLEP a 320 (241 ≤ 241) ✓
🔒7 [t0] contra la base (motor de 099101a): 30/30 · bloques 887/887 · 🔒9 885/885 y 2/2
🔒8 19 estados: texto 0 de 13722, gráficos 0 de 3009 · N4a–N4d y N5: 0 de 6789 y 0 de 1035 (N5: 0 de 113)
capturas base contra t2: textContent 19/19 y 11/11 iguales; píxeles distintos en S01–S11 (a 1280, 2 a 56 px: el ▾ se corre 0,1 px) y en N1, N3, N5, N5m (el botón con otros nombres; N5 y N5m son la corrección)
N6 (C6, ya en HEAD): foco en BUTTON.cmp-add-btn tras clic y tras Enter; a1-F04 intacto · errores 0
🔒3 git diff b8d9d46..HEAD -U0 | grep '^+' | grep -ciE '#[0-9a-f]{3,8}\b' → 0 · 🔒4 → 0 · 🔒6 84d079b7… = retrans (distintas: 0)
```
Commit: `2c779fb`.

### T3 — Despliegue

Corre porque FASE 0 pasó. Publica lo commiteado en verde: C1, C2 y C3 (`3bc0c57`), C6 (`eabf8ad`) y C5 (`2c779fb`). C4 queda fuera (T1 congelada), así que el mensaje nombra solo lo publicado.

esperado: PRUEBAS a; PRUEBAS c sobre `docs/index.html` = `d9895a78…0442`; PRUEBAS d en verde; 🔒5; en `docs/index.html` por `file://`: 0 errores, 🔒7 frente al publicado (solo C1 a C3, con los conteos del a6), C6, las verificaciones de T2 y 🔒9; `git status --short` = `M docs/index.html`
obtenido:
```
publicado (HEAD:docs antes del despliegue) md5 788d5026562a67a73af43abffd97034e
PRUEBAS a [t3]: exit=0; warnings=0; RENV_PROJECT=/Users/tomgc/Projects/slep_categoria_desempeno
PRUEBAS c: d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442 (motor) | d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442 (docs)
PRUEBAS d (docs nuevo, renv activo): F1–F4 OK (0 discrepancias), TODAS LAS FAMILIAS EN VERDE; SPOT-CHECK OK 6 + 1
🔒5: docs d58d2f2c9fbc5469228cdee6be05bb61 = motor d58d2f2c9fbc5469228cdee6be05bb61
docs por file://: 19 estados errores 0 · 11 estados N errores 0 · capturas y textContent idénticos al build t2 (19/19 y 11/11)
🔒7 [t1] contra el publicado: 30/30 · bloques 887/887; estados con cambio: S04 (elSimce 2022 1→0, el Simce 2022 0→1) · S10 («a un establecimiento de» 1→0, variante 0→1) · N1 (frase vacía 1→0) · N2 (frase vacía 1→0, variante 0→1) · N3 («a uno de» 1→0, variante 0→1) = los del a6
  totales: frase vacía 2→0 · «a uno de» 16→15 · «a un establecimiento de» 17→16 · variante 0→3 · elSimce 2022 1→0 · el Simce 2022 0→1 (los totales de «a uno de» y «a un establecimiento de» suman 2 más que en el a6: son N4c y N4d, estados nuevos con la narrativa del SLEP, sin cambio)
C1–C3: N1 sin frase 3; N2 «…tiene 281 estudiantes en el nivel.»; N3 «…tiene 121 estudiantes en el nivel.»
C6: clic en Limpiar → BUTTON.cmp-add-btn · Enter en Limpiar → BUTTON.cmp-add-btn · a1-F04: ✕ 1/2 y "+ Agregar" (publicado: BODY y BODY)
C5 (T2 repetido sobre docs): EE 320 146.9×36, 1 línea, dentro, barra 241, puntos suspensivos; SLEP 320 y 1280 145×36, nombre 104/104, sin puntos, ▾ 122.7/15; desborde 0
🔒9: 885/885 y 2/2
git status --short: " M docs/index.html", "?? <LOG>"
```
Commit: `1d9b9d9` (`deploy(motor): publica narrativa, foco y botón de territorio corregidos (a6 y a7)`); `git show HEAD:docs/index.html` md5 `d58d2f2c…`, SHA `d9895a78…0442`.

### FASE R — Auditoría propia y reparación

#### R.1 Inventario (anexado antes de auditar)

| id | afirmación | origen |
|---|---|---|
| R-01 | M1/M2: punto de partida; `HEAD~1` = `origin/main` = `099101a` | FASE 0 |
| R-02 | M3: SHA `d9895a78…0442`, calibración, PRUEBAS d con renv | FASE 0 |
| R-03 | M-DERIVA: cadena idéntica | FASE 0 |
| R-04 | M4: línea base determinista, motor `6871dcb0…` | FASE 0 |
| R-05 | M5: C4 cortada a 320, 360, 375 y 390; C5 como en el a6 | FASE 0 |
| R-06 | T1 congelada: a 390 px dos filas; `scrollHeight` > `clientHeight` por el margen de −1 px (preexistente) | T1 |
| R-07 | T1 revertida exacta, sin commit | T1 |
| R-08 | C5: EE a 320 en una línea, dentro del viewport, barra ≤ SLEP; `title` = nombre | T2 |
| R-09 | C5: SLEP sin recorte a 320, 360, 375, 390 y 1280; ancho y ▾ a ±1 px de la base a 1280 | T2 |
| R-10 | C5: desborde de `#root` 0 a 320, 390 y 1280 | T2 |
| R-11 | T3: `docs/index.html` = build de `HEAD`; publicados C1, C2, C3, C5 y C6 | T3 |
| R-12 | 🔒1 | §3 |
| R-13 | 🔒2 | §3 |
| R-14 | 🔒3 | §3 |
| R-15 | 🔒4 | §3 |
| R-16 | 🔒5 | §3 |
| R-17 | 🔒6 | §3 |
| R-18 | 🔒7 | §3 |
| R-19 | 🔒8 | §3 |
| R-20 | 🔒9 | §3 |
| R-21 | Alcance global | FASE R |
| R-22 | Regresión PRUEBAS a–d (y b) | FASE R |
| R-23 | Control positivo: `docs/index.html` de `b8d9d46` reproduce C1 a C6 | FASE R |
| R-24 | Proceso: errores propios y recalibraciones de instrumentos | propio |

#### R.2–R.6 Re-derivación por caminos distintos, invariantes, alcance, regresión y control positivo

Caminos distintos:
- C4 por captura 2× y píxeles (`/tmp/cat_a7_rR_tabs.js`: bandas de tinta = filas de pestañas; filas del color del subrayado frente a las del separador).
- C5 por píxeles (`/tmp/cat_a7_rR2.js`: caja por el borde, líneas como bandas de tinta, puntos suspensivos).
- C6 por `focusin`.
- C1 a C3 por `innerText`.
- 🔒9 por coordenada.
- 🔒1 desde `git show` en node y en Python.

Además se midió el nombre accesible del botón (`/tmp/cat_a7_nombre_acc.js`), porque `innerText` mostró una diferencia. La evidencia para Q-C4b se obtuvo inyectando CSS solo en el navegador (`/tmp/cat_a7_alternativas_c4.js`), sin tocar las fuentes.

esperado: C4 congelada con los hechos de T1 re-derivados; C5 y C6 re-derivan igual que T2 y T3; C1 a C3 con las cadenas declaradas; 🔒1 a 🔒9 con su comando; alcance = `33_app.jsx`, template y `docs/index.html` (el LOG entra con `docs(log)`); PRUEBAS a–d en verde y b con 0 errores; `docs/index.html` de `b8d9d46` reproduce C1 a C6
obtenido:
```
── C4 (T1 congelada) por píxeles, captura 2× del encabezado y las pestañas del modal
  publicado 390 y 320: 3 bandas de tinta (borde superior, título, 1 fila de pestañas); subrayado (4 filas de disp.) pisa las 2 filas del separador inferior: sí
  candidato t1 390 y 320: 4 bandas (2 filas de pestañas); subrayado de la 1.ª fila sin pisar el separador (queda entre filas)
  → a 390 hay dos filas; el píxel que excede clientHeight es el segundo del subrayado (preexistente)
  docs desplegado (C4 no publicado): 390 y 320 con tinta en el borde derecho del modal (Establecimiento cortada), como el publicado
  alternativas inyectadas (evidencia para Q-C4b): P16 M16 → 390: 2 filas (reproduce t1) · P16 M8 → 390: 1 fila; 320, 360, 375: 2 filas; 4/4 completas; sw ≤ cw · P12 M10 → igual que P16 M8
── C5 por píxeles (docs desplegado)
  SLEP 320: caja 145×36, dentro, 1 línea, barra 241, sin puntos suspensivos · EE 320: 147×36, dentro, 1 línea, barra 241, con puntos · EE 390: 217×36, 1 línea, barra 241, con puntos
  control (docs de b8d9d46): EE 320 148×180, 9 líneas, barra 385 · EE 390 217×108, 5 líneas, barra 313
── C6 por focusin (docs desplegado): clic en Limpiar → [BUTTON.cmp-clear-btn, BUTTON.cmp-add-btn] · Enter → [BUTTON.cmp-add-btn] · a1-F04 [✕ 1/2] y [BUTTON.cmp-add-btn]
   control: clic → [BUTTON.cmp-clear-btn] (nada después: BODY) · Enter → []
── C1 a C3 por innerText (publicado → desplegado)
  🔒7 por innerText: 7/30 iguales con las cadenas declaradas; los 23 que difieren tienen UNA sola diferencia, la misma en todos:
    la línea «<nombre> ▾» del botón de territorio pasa a «<nombre>» + salto + «▾» (el span es un ítem flex y innerText lo trata como bloque)
  cadenas declaradas: S04 [elSimce 2022 1→0, el Simce 2022 0→1] · S10 [«a un establecimiento de» 1→0, variante 0→1] · N1 [frase vacía 1→0] · N2 [frase vacía 1→0, variante 0→1] · N3 [«a uno de» 1→0, variante 0→1]
  control del candado (publicado contra sí mismo): 25/30 · FALLAN: S04, S10, N1, N2, N3 (discrimina)
  nombre accesible del botón (árbol de accesibilidad): publicado «Costa Central ▾» = desplegado «Costa Central ▾»; con el EE, nombre + « ▾» en los dos; nuevo: descripción accesible = nombre completo (por el title de C5)
── 🔒9 por coordenada (docs desplegado): S01 62, S05 11, S10 1, S11 5 .traj 2016→2019 con el anillo en 3 de 4 · S03 .ee-detail-list 2019,2018,2017,2016 vigente en 0 de 4 · delta «2016→2019: -1 (-1,7%)» · errores 0
── 🔒1
  1d9b9d9:docs/index.html md5 d58d2f2c9fbc5469228cdee6be05bb61 SHA d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
  b8d9d46:docs/index.html md5 788d5026562a67a73af43abffd97034e SHA d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
  Python (1d9b9d9 contra b8d9d46): payload igual salvo la fecha: True · claves de primer nivel distintas: []
── 🔒2 PRUEBAS d [R] (renv activo): F1–F4 OK (0 discrepancias), TODAS LAS FAMILIAS EN VERDE; SPOT-CHECK OK 6 + 1 (y en T3 sobre el docs desplegado)
── 🔒3 git diff b8d9d46..HEAD -U0 | grep '^+' | grep -ciE '#[0-9a-f]{3,8}\b' → 0
── 🔒4 git diff b8d9d46..HEAD -- 30_procesamiento/30_* 30_procesamiento/31_* 30_procesamiento/32_* 30_procesamiento/33_generar_html.R 30_procesamiento/34_* 20_insumos 10_utils tests | wc -l → 0
── 🔒5 docs/index.html d58d2f2c9fbc5469228cdee6be05bb61 = 40_salidas/motor_categoria.html d58d2f2c9fbc5469228cdee6be05bb61 (build t3 y build R)
── 🔒6 template 84d079b74d35d93e0412f457020fc066 1614 líneas | retrans 84d079b74d35d93e0412f457020fc066 1614 líneas | distintas: 0
── 🔒7 textContent: T2 contra la base de 099101a 30/30 (sin cadenas nuevas) · T3 contra el publicado 30/30 (solo C1–C3, estados y conteos del a6)
── 🔒8 docs desplegado: 19 estados texto 0 de 13722, gráficos 0 de 3009 · N4a–N4d y N5: 0 de 6789, 0 de 1035
── alcance: git diff --name-only b8d9d46..HEAD → 30_procesamiento/33_app.jsx, 30_procesamiento/33_motor_template.html, docs/index.html (el LOG entra con docs(log))
── regresión: PRUEBAS a [R] exit=0, warnings=0 (renv activo), motor d58d2f2c… = docs de HEAD (reproducible; git restore deja d58d2f2c…) · c d9895a78…0442 · d en verde · b: 0 errores en 19 + 11 estados (desplegado)
── control positivo (docs de b8d9d46, mismos instrumentos): N1 y N2 «Considerando la matrícula 2025, .» · N3 «…121 asisten a uno de desempeño Insuficiente (100,0%).» · S04 «elSimce 2022» ×1 · N4 cortada a 320, 360, 375 y 390 · N5 9 líneas, barra 385 · N6 foco BODY tras clic y tras Enter
── porcelain: solo el LOG · stash: []
```

#### R.7 Tabla de auditoría

| id | afirmación | comando | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | M1/M2 | `git log`; `rev-parse` | `b8d9d46^` = `099101a` = `origin/main` | igual | PASA | — | `b8d9d46` | — |
| R-02 | M3 | tres plantas; PRUEBAS d con `RENV_PROJECT` | igual/igual/distinto; verde | igual | PASA | — | — | — |
| R-03 | M-DERIVA | retranspilación | idéntica | idéntica | PASA | — | — | — |
| R-04 | M4 | dos corridas; md5 | iguales; `6871dcb0…` | 19/19 y 11/11; `6871dcb0…` | PASA | — | — | — |
| R-05 | M5 | control positivo por píxeles | C4 cortada; C5 9 líneas | igual | PASA | — | — | — |
| R-06 | T1 congelada | bandas de tinta; subrayado contra separador; alternativas inyectadas | 390 en dos filas; píxel extra = subrayado | 2 filas (t1); el subrayado pisa el separador (publicado); P16 M8 y P12 M10 dan 1 fila a 390 | ADVIERTE | congelada (regla 5); Q-C4b y Q-SH al titular | — | — |
| R-07 | T1 revertida | `git diff HEAD`; md5 | 0; igual | 0; igual | PASA | — | — | — |
| R-08 | C5 en N5 | píxeles | 1 línea, dentro, barra ≤ SLEP | 147×36, 1 línea, dentro, 241 = 241 | PASA | — | `2c779fb` | — |
| R-09 | C5 SLEP | píxeles (puntos suspensivos; columna del ▾) | sin recorte; ±1 px | sin puntos en 5 anchos; ▾ 125/16 (320) y 124/17 (1280) = base | PASA | — | `2c779fb` | — |
| R-10 | C5 desborde | `#root` | 0 | 0 a 320, 390 y 1280 | PASA | — | `2c779fb` | — |
| R-11 | despliegue | `git show` + md5 | = build de HEAD | `d58d2f2c…` = `d58d2f2c…` | PASA | — | `1d9b9d9` | — |
| R-12 | 🔒1 | node y Python sobre `git show` | `d9895a78…`; igual salvo fecha | igual; True | PASA | — | — | — |
| R-13 | 🔒2 | PRUEBAS d [R] | verde | verde | PASA | — | — | — |
| R-14 | 🔒3 | comando de §3 | 0 | 0 | PASA | — | — | — |
| R-15 | 🔒4 | comando de §3 | 0 | 0 | PASA | — | — | — |
| R-16 | 🔒5 | md5 | docs = motor | igual | PASA | — | — | — |
| R-17 | 🔒6 | retranspilación | idéntica | idéntica | PASA | — | — | — |
| R-18 | 🔒7 | `textContent`; `innerText`; nombre accesible | solo C1–C3 | `textContent` 30/30; `innerText` 7/30, porque la única diferencia de los 23 restantes es el salto de línea del botón (ítem flex); el nombre accesible es igual | ADVIERTE | declarado: no es una cadena nueva ni cambia lo visible ni el nombre accesible | — | — |
| R-19 | 🔒8 | instrumento del a3 sobre docs | 0 y 0 | 0 y 0 | PASA | — | — | — |
| R-20 | 🔒9 | nodos y coordenada | ascendente / descendente | 885/885, 2/2; por coordenada igual | PASA | — | — | — |
| R-21 | alcance | `git diff --name-only` | 3 rutas + LOG | 3 rutas (+ LOG en docs(log)) | PASA | — | — | — |
| R-22 | regresión | PRUEBAS a–d y b | verde; 0 | verde; 0 | PASA | — | — | — |
| R-23 | control positivo | mismos instrumentos sobre docs de `b8d9d46` | C1–C6 | C1–C6 | PASA | — | — | — |
| R-24 | proceso | revisión propia | — | (a) un `Write` sobre `/tmp/cat_a7_nuevos.js` falló porque el archivo copiado no se había leído, y la primera verificación de sintaxis corrió sobre la copia vieja; se reescribió antes de medir; (b) se usaron scripts de `node -e` en línea dentro de `bash -c` para resúmenes y para leer dos colores computados (no son heredocs y no crearon archivos; porcelain verificado); (c) ningún `rm`; los temporales quedan en `/tmp/cat_a7_*` | ADVIERTE | declarado | — | — |

**Ciclos de reparación:** 0 (sin REPARA). **Veredicto FASE R: SIN BLOQUEO** (0 BLOQUEA, 0 REPARA, 3 ADVIERTE: R-06, R-18, R-24). No hace falta revertir el despliegue.

### FASE L — Cierre

#### Resumen

C5 quedó corregido, verificado y publicado. En un teléfono, el botón de territorio muestra un nombre largo en una sola línea con puntos suspensivos (el nombre completo va en `title`). La barra fija no crece, no hay desborde, y el SLEP por defecto se ve igual que antes gracias al `gap: 4px`. C4 se implementó tal como lo pide §1 y resuelve el corte en los cuatro anchos, pero se congeló por la regla 5: a 390 px la lista cerrada deja «Establecimiento» en una segunda fila, y `scrollHeight` ≤ `clientHeight` no se puede cumplir junto con el subrayado de 2 px. T3 publicó lo que estaba en verde: C1, C2 y C3 (narrativa y nota de cobertura), C6 (foco tras "Limpiar") y C5. El payload quedó idéntico, las pruebas del dato siguen en verde con renv activo y frente al publicado solo cambian las cadenas de C1 a C3, con los estados y conteos del a6.

#### Commits

`b8d9d46` encargo y registro de errores · `2c779fb` T2 · `1d9b9d9` despliegue · (este) `docs(log)`. Sin commit de T1.

#### Invariantes

🔒1 PASA · 🔒2 PASA · 🔒3 PASA · 🔒4 PASA · 🔒5 PASA · 🔒6 PASA · 🔒7 PASA por `textContent` (por `innerText`, única diferencia: el salto de línea del botón; ADVIERTE R-18) · 🔒8 PASA · 🔒9 PASA.

#### md5 de `docs/index.html` desplegado

`d58d2f2c9fbc5469228cdee6be05bb61` (= `40_salidas/motor_categoria.html` de los builds t3 y R; SHA del payload `d9895a78…0442`).

#### C4 — filas por pestaña en cada ancho (T1 congelada; no publicado)

| ancho | base (publicado): Comuna / SLEP / Región / Establecimiento | candidato t1 (lista cerrada): Comuna / SLEP / Región / Establecimiento | filas base → t1 |
|---|---|---|---|
| 320 | 42–106,3 / 130,3–169,4 / 193,4–245,7 / 269,7–391,3 cortada (borde 300) | 36–100,3 / 116,3–155,4 / 171,4–223,7 en la fila 1 · 36–157,5 en la fila 2 | 1 → 2 |
| 360 | ídem, cortada (borde 340) | ídem t1 320 | 1 → 2 |
| 375 | ídem, cortada (borde 355) | ídem t1 320 | 1 → 2 |
| 390 | ídem, cortada (borde 370) | ídem t1 320 | 1 → 2 (exigido: 1) |

Subrayado activo: 2 px en las cuatro pestañas, en base y en t1. `scrollHeight`/`clientHeight`: base 44/43, t1 87/86. Evidencia para Q-C4b (CSS inyectado solo en el navegador): P16 M8 y P12 M10 dejan 1 fila a 390 y 2 filas a 320, 360 y 375, con 4/4 completas.

#### C5 — ancho del botón y posición del ▾

| entidad y ancho | base (publicado) | desplegado |
|---|---|---|
| SLEP 320, 360, 375, 390 | 145×36; ▾ a 122,6 px del borde izquierdo y 15 del derecho | 145×36; ▾ a 122,7 y 15; nombre 104/104, sin puntos suspensivos |
| SLEP 1280 | 145×36 [533,8, 678,8]; ▾ 122,6 / 15 | 145×36 [533,8, 678,9]; ▾ 122,7 / 15 (±1 ✓) |
| EE 320 | 147,7×180, 9 líneas, barra 385 | 146,9×36, 1 línea, barra 241, puntos suspensivos, `title` = nombre |
| EE 390 | 216,9×108, 5 líneas, barra 313 | 216,9×36, 1 línea, barra 241 |
| EE 1280 | 834,5×36, barra 205 | 834,6×36, barra 205, nombre completo |

#### Dudas con pregunta cerrada

- **Q-C4b:** con la lista cerrada (`padding: 0 16px`, `margin-right: 16px` y `flex-wrap: wrap`), a 390 px «Establecimiento» pasa a una segunda fila: necesita 279,2 + 4 × 16 = 343,2 px y hay 318. Con `margin-right: 8px` (lo demás igual), medido por inyección, queda una fila a 390 con cualquier pestaña activa, dos filas a 320, 360 y 375, y 4/4 completas. ¿Se aplica C4 con `margin-right: 8px`? Sí / No.
- **Q-SH:** `scrollHeight` ≤ `clientHeight` en `.modal-tabs` no es alcanzable junto con el subrayado completo de 2 px. El `margin-bottom: -1px` de `.modal-tab` (preexistente: el publicado da 44/43) hace que el segundo píxel del subrayado pise el separador, y ese píxel es el que excede. ¿Se reemplaza ese criterio por «`scrollHeight` − `clientHeight` igual al de la base (1 px)»? Sí / No.

#### Errores propios

1. Un `Write` sobre `/tmp/cat_a7_nuevos.js` falló porque el archivo copiado no se había leído, y la primera verificación de sintaxis corrió sobre la copia vieja. Se leyó, se reescribió y se verificó antes de medir; ninguna cifra salió de la versión vieja.
2. Scripts de `node -e` en línea dentro de `bash -c`, para resúmenes y para leer dos colores computados. No son heredocs ni crearon archivos (porcelain verificado), pero el encargo pide scripts en archivo: queda declarado.

#### Privacidad

`/tmp/cat_a7_priv.sh` busca RUT con DV, la sigla del rol seguida de número y nombres típicos de establecimiento. Control: una copia del LOG con tres plantas ficticias (`/tmp/cat_a7_priv_control.md`) da RUT 1, RBD+n 1 y nombre EE 1, es decir, detecta. LOG: RUT 0, RBD+n 0, nombre EE 0 (vacío).

#### Lo que falló o sorprendió

- La lista cerrada de C4 tampoco alcanza su esperado a 390 px. En la partición de filas de flexbox, el `margin-right` de la última pestaña cuenta, y con 16 px sobran 25 px.
- `scrollHeight` ≤ `clientHeight` ya fallaba en el publicado (44/43), por el diseño del subrayado que pisa el separador.
- La re-derivación por `innerText` encontró una diferencia que `textContent` no ve. El `span` del botón es un ítem flex, así que `innerText` separa el nombre y el ▾ con un salto de línea. No cambia lo visible ni el nombre accesible.

#### Verificación del archivo

`grep -c '^esperado:'` → 11 · `grep -c '^obtenido:'` → 11 (iguales) · `grep -c '^## J'` → 1 · hex en el LOG (`grep -ciE '#[0-9a-f]{3,8}\b'`) → 0 · privacidad 0 / 0 / 0 (control plantado: 1 / 1 / 1).

#### Estado de cierre

T1 CONGELADA (regla 5) · T2 COMPLETADA · T3 COMPLETADA (despliegue `1d9b9d9`) · FASE R SIN BLOQUEO · push según autorización tras este commit · sin shells en segundo plano.
