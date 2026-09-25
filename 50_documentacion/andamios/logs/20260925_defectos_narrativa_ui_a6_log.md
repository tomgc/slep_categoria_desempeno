# Log — Seis defectos visibles de narrativa y UI, y despliegue (a6)

- **Fecha:** 2026-09-25
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_categoria_defectos_narrativa_ui_a6.md`
- **Proyecto:** `slep_categoria_desempeno`
- **Ejecutor:** Claude Code (Opus 5.5, sesión única, sin subagentes)
- **Punto de retorno (`<inicio>`):** `968530c` (padre `0396c2a`)
- **Privacidad:** este log no lleva RBD con número ni nombres de establecimiento; los estados se identifican por índice o por hash corto (sha256, 8 caracteres).

## J. Juicio (lo rellena FASE L)

1. **Meta y resultado:** corregir los seis defectos del pendiente #1 del traspaso v30 y desplegar si todo terminaba en verde. Resultado: C1, C2, C3 y C6 corregidos y verificados (antes → después); C4 y C5 congelados por la regla 7, porque la lista cerrada produce resultados no enumerados; sin despliegue.
2. **Estado por tarea:** FASE 0 completa; T1 COMPLETADA; T2 CONGELADA (C4 y C5, sin commit); T3 COMPLETADA; T4 NO CORRE (regla 7); FASE R sin bloqueo; FASE L completa.
3. **Commits:** `968530c` encargo · `3bc0c57` T1 · `eabf8ad` T3 · (este) `docs(log)`. Sin commit de T2 ni de despliegue.
4. **Auditoría:** 27 filas; 0 BLOQUEA, 0 REPARA, 3 ADVIERTE (R-10 T2 congelada; R-26 proceso; R-27 entorno); 0 ciclos; control positivo presente.
5. **Invariantes:** 🔒1, 🔒2, 🔒3, 🔒4, 🔒6, 🔒7, 🔒8 y 🔒9 PASAN; 🔒5 sin despliegue (docs = publicado; en cada build, docs = motor).
6. **Cifras críticas:** SHA del payload `d9895a78…0442` en la base, en t1, t2a, t2b, t3 y R, y desde `git show`; F1–F4 y spot-check en verde con renv activo; contraste 0 de 13.722 (texto) y 0 de 3.009 (gráficos) en los 19 estados y 0 y 0 en N4 y N5; `docs/index.html` `788d5026…` (sin cambio); motor de `HEAD` `6871dcb0…`.
7. **Decisiones autónomas de mayor riesgo:** congelar C4 y C5 (y con eso no desplegar) por la regla 7, en vez de leer "sin scroll" como "sin necesidad de desplazar" y aceptar el recorte del SLEP; C6 y T1 se commitearon igual por ser independientes.
8. **Desviaciones:** `/tmp/cat_a6_build.sh` arranca R en la raíz para que renv quede activo (el del a5 no lo hacía en PRUEBAS d); `CLAUDE.md` local creado por la instrucción global (ignorado por git); dos archivos vacíos creados por error en la raíz y movidos a `/tmp` con `mv`.
9. **Dudas abiertas:** Q-C4, Q-C5, Q-DEPLOY y Q-CLAUDEMD (pregunta cerrada en FASE L).
10. **Errores propios:** 5 (heredoc que creó dos archivos en la raíz; `rm -rf` sin efecto sobre un temporal; primera PRUEBAS d sin renv; instrumentos corregidos antes de registrar; un heredoc con comillas que no se ejecutó).
11. **Qué debe verificar el revisor:** en un build local (no publicado), la narrativa de un EE (frase 3 nueva), la nota de cobertura ("el Simce 2022") y "Limpiar" en el comparador (el foco queda en "+ Agregar"); y, para decidir Q-C4 y Q-C5, las capturas del candidato: `/tmp/cat_a6_tabs_cmp390.png`, `/tmp/cat_a6_tabs_cmp320.png` y `/tmp/cat_a6_bot_cmp320.png`.
12. **No publicado / queda al usuario:** el despliegue de T1 y T3 (Q-DEPLOY); C4 y C5 (Q-C4, Q-C5); el candidato de T2 queda en `/tmp/cat_a6_t2_candidato.patch`.
13. **Ejecución:** Opus 5.5, una sesión, 0 subagentes (el encargo no los admite, aunque la sesión corría en modo ultracode), Babel 8.0.6 copiado a `/tmp/cat_a6_babel`, Puppeteer con Chrome del sistema, renv activo en toda corrida R (verificado por `RENV_PROJECT`), instrumentos en `/tmp/cat_a6_*`.

## Esqueleto

- FASE 0 — M0, M1, M2, M3, M-DERIVA, M4, M5, M6
- T1 — textos (C1, C2, C3)
- T2 — ancho (C4, C5)
- T3 — foco (C6)
- T4 — despliegue
- FASE R — auditoría propia
- FASE L — cierre

### FASE 0

#### M0 — `renv::status()` en la raíz (salida literal)

esperado: informa desfase atribuible solo a `suitedoc` (usado y no registrado); ninguna versión distinta
obtenido:
```
- The project is out-of-sync -- use `renv::status()` for details.
The following package(s) are used in this project, but are not installed:
- suitedoc

See `?renv::status` for advice on resolving these issues.
exit=0
```
`grep -c suitedoc renv.lock` → `0` (no registrado). El único paquete informado es `suitedoc`, y no aparece ninguna versión distinta. No se actúa sobre renv.

#### M1 — porcelain tras el primer commit; stash; archivos del primer commit

esperado: el LOG o vacío; stash vacío; primer commit = el encargo
obtenido:
```
antes del primer commit: ?? 50_documentacion/activa/encargos/encargo_claude_code_categoria_defectos_narrativa_ui_a6.md
968530c chore(encargo): defectos de narrativa y UI a6
porcelain tras el commit: (vacío)
stash: []
archivos del commit: 50_documentacion/activa/encargos/encargo_claude_code_categoria_defectos_narrativa_ui_a6.md
```

#### M2 — fetch; HEAD~1; HEAD..origin/main; origin/main..HEAD

esperado: `HEAD~1` = `0396c2a` = `origin/main`; 0; 1
obtenido:
```
fetch exit=0 (antes del commit: HEAD=0396c2a origin/main=0396c2a HEAD..origin/main=0 origin/main..HEAD=0)
HEAD~1=0396c2a origin/main=0396c2a HEAD..origin/main=0 origin/main..HEAD=1
```

#### M3 — md5 de `docs/index.html`; SHA del payload normalizado (instrumento recalibrado); PRUEBAS d

Instrumentos copiados de `/tmp/cat_a5_*` a `/tmp/cat_a6_*` (rutas reescritas; 0 referencias a `cat_a5_` fuera de comentarios); Babel copiado de `/tmp/cat_a5_babel` (8.0.6 / 8.0.6 / 8.0.1, runtime classic). **Recalibración del build (hallazgo):** el `cat_a5_build.sh` corría PRUEBAS d con `cd /tmp`, y desde ahí R no lee el `.Rprofile` del proyecto, así que **renv no quedaba activo** en PRUEBAS d del a5 (medido: desde `/tmp`, `RENV_PROJECT` vacío y la biblioteca del sistema; desde la raíz, `RENV_PROJECT` = el proyecto y `renv/library/…`). `/tmp/cat_a6_build.sh` arranca toda corrida R en la raíz (subshell con `cd` explícito) e imprime `RENV_PROJECT` en cada una. La primera corrida de PRUEBAS d de este M3 salió también desde `/tmp` (verde, sin renv); se repitió con renv activo y es la que vale.

esperado: md5 `788d5026…`; SHA `d9895a78…0442`; fecha alterada → igual; cifra plantada → distinto; PRUEBAS d en verde (renv activo)
obtenido:
```
md5 docs 788d5026562a67a73af43abffd97034e | motor 40_salidas 788d5026562a67a73af43abffd97034e | template 26324152f6d9a13b579d7122aeb61221 | 33_app.jsx b8eb54f6d0820dc70f5a0b2a45b23a41
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
template b3e5650f6576a1a570d7e42b23012a9d 1603 líneas | retrans b3e5650f6576a1a570d7e42b23012a9d 1603 líneas | distintas: 0
```

#### M4 — Estados nuevos, elegidos por programa desde el payload

Instrumento `/tmp/cat_a6_elegir.js` (en la página, con `CatData` del motor; la elección completa queda solo en `/tmp/cat_a6_estados.json`). N1: la misma suma de la frase 3 sobre `getEstablecimientos` sin filtros (App reinicia los filtros al cambiar de entidad), recorriendo comunas, SLEP y regiones, básica antes que media; se toma el primero. N2 y N3: RBD en orden numérico, básica antes que media, vigente en la categoría y matrícula del nivel > 0. N5: nombre de mayor ancho en canvas con la fuente computada de `.entity-select-btn` (600 16px, pila `system-ui`). Viewports: N1, N2, N3 y N6 a 1280 × 900; N4 a 390 × 844 y a 320 × 568; N5 a 320 × 568 (y, para el desborde, a 390 × 844 y 1280 × 900).

esperado: cuatro estados definidos (N1 puede declararse vacío)
obtenido:
```
N1 candidatos: 34 (por tipo y nivel: {"comuna/media":28,"comuna/basica":5,"slep/media":1})
N1: comuna h2cb7446c nivel media · EE categorizados 1 · matrícula del nivel 341 (Medio/Alto 0, Insuficiente 0, Medio-Bajo 341)
N2: establecimiento h4fc82b26 nivel basica · matrícula del nivel 281 · candidatos 1979
N3: establecimiento h4a44dc15 nivel basica · matrícula del nivel 121 · candidatos 489
N4: modal de territorio (SLEP por defecto) a 390 × 844 (N4a) y a 320 × 568 (N4b)
N5: establecimiento ha0a73bb4 · ancho del nombre en canvas 793.2 px (86 caracteres) de 9040 EE · SLEP por defecto 103.6 px
N6: comparador con los 2 primeros SLEP de la pestaña SLEP; clic en "Limpiar" y, tras volver a agregar 2, Enter sobre "Limpiar"
errores 0
```
Seis estados definidos (N1 no está vacío). El hash corto es sha256 del código de la comuna o del RBD.

#### M5 — Reproducción de cada defecto en `docs/index.html`

Instrumentos: `/tmp/cat_a6_nuevos.js` (N1 a N6) y `/tmp/cat_a6_m5.js` (19 estados). Primera corrida de `nuevos.js` fallida (la búsqueda del modal por RBD corta en 60 resultados y el EE de N2 quedaba fuera): la receta pasó a escribir el nombre y elegir la fila por RBD exacto antes de registrar.

esperado: los seis se reproducen: C1 en N1 y N2; C2 en N3 y N2; C3 con conteo; C4 en N4; C5 en N5 frente al SLEP; C6 en N6
obtenido:
```
C1  N1 frase 3: «Considerando la matrícula 2025, .» · «Considerando la matrícula 2025, .» ×1
    N2 frase 3: «Considerando la matrícula 2025, .» ×1
C2  N3 frase 3: «Considerando la matrícula 2025, 121 asisten a uno de desempeño Insuficiente (100,0%).» · «a uno de desempeño» ×1
    N2: el EE es el sujeto y la frase 3 es la versión con tramos (vacía, ver C1)
    S10 (EE Medio/Alto de los 19 estados): «Considerando la matrícula 2025, 693 estudiantes asisten a un establecimiento de desempeño Medio o Alto (100,0% de la matrícula del nivel).»
C3  S04 (notas abiertas): «elSimce 2022» ×1 · «el Simce 2022» ×0; en los otros 18 estados y en N1 a N6: 0 y 0
C4  N4a (390 px): .modal-tabs [20, 370] padding 22px/22px margen 24px clientWidth 350 scrollWidth 371 overflow-x visible · .modal [20, 370] · pestañas Comuna 42–106.3 | SLEP 130.3–169.4 | Región 193.4–245.7 | Establecimiento 269.7–391.3 CORTADA
    N4b (320 px): .modal-tabs [20, 300] clientWidth 280 scrollWidth 371 overflow-x visible · .modal [20, 300] · Comuna 42–106.3 | SLEP 130.3–169.4 | Región 193.4–245.7 | Establecimiento 269.7–391.3 CORTADA
C5  N5 (320×568): EE botón 147.7×180 [133.1, 280.8] líneas 9 · .controls-bar alto 385 (0.678 del alto) · desborde #root 0
    SLEP (320×568): botón 145×36 [133.1, 278.1] líneas 1 · .controls-bar alto 241 (0.424 del alto) · desborde #root 0
    N5m (390×844): EE botón 216.9×108 líneas 5 · barra 313 (0.371) || SLEP 145×36, barra 241 (0.286)
    N5d (1280×900): EE botón 834.5×36 líneas 1 · barra 205 (0.228) || SLEP 145×36, barra 77 (0.086)
C6  N6: chips 2 → clic en Limpiar → foco BODY (chips 0) · chips 2 → Enter en Limpiar → foco BODY (chips 0)
    a1-F04 con 3: quitar el del medio → BUTTON.cmp-chip-x 1/2; quitar el último → BUTTON.cmp-add-btn
errores de consola/pageerror: 0
```
Los seis defectos se reproducen; la regla 5 no se activa.

#### M6 — Línea base de los 19 estados y N1 a N6, con determinismo

Medición común `/tmp/cat_a6_medir.js` (recalibrada del recorrido a5): el instrumento §7 del a3 tal cual con su auxiliar, captura, `textContent` de `#root`, texto sin `.ee-detail-list`, bloques de años **con el índice del vigente** (nuevo, para 🔒9) y **contexto de la narrativa** (nuevo, para 🔒7: EE como sujeto, nivel activo y matrícula del nivel tomada del payload con el RBD elegido). Las recetas de los 19 estados son las del a5, más una sola lectura: el RBD de la fila antes de elegir el EE de S10. `/tmp/cat_a6_candado.js`: 🔒7 compara el `textContent` nuevo con la base a la que se le aplican **solo** las cadenas de §1 (C3 literal; frase 3 de un EE con matrícula > 0 → variante C2 con N del payload; frase 3 vacía → se omite) e informa el conteo por estado; también compara los pares por bloque y verifica 🔒9.

esperado: igual entre corridas; contraste de base 0 y 0 (a5); el candado discrimina una planta
obtenido:
```
cat_a6_base vs cat_a6_base2: capturas AE=0 19/19 · textContent 19/19 · sin detalle 19/19 · bloques 19/19 · contexto 19/19 · errores 0 y 0
cat_a6_baseN vs cat_a6_base2N: capturas AE=0 9/9 · textContent 9/9 · sin detalle 9/9 · bloques 9/9 · contexto 9/9 · errores 0 y 0 (N1, N2, N3, N4a, N4b, N5, N5m, N5d, N6); defectos.json idéntico
contraste 19 estados: texto 13725 mediciones, fallas activas 0, pares 0 · gráficos exigidos 3009, fallidos 0 · deshabilitados: 4 pares de texto y 1 gráfico (exentos, los del a3)
contraste N4a, N4b, N5: texto 3439 mediciones, fallas activas 0 · gráficos exigidos 523, fallidos 0
candado t0 (base contra base2): 🔒7 28/28 · bloques 763/763 · 🔒9 .traj 761/761, .ee-detail-list 2/2
control del candado (copia con dos plantas: una letra en S01 y el detalle de S03 invertido): 🔒7 27/28, 🔒9 det 1/2 → FALLAN: S01 (texto), S03 (🔒9 det 2)
S10: EE con matrícula del nivel 693 (contexto resuelto; nombre coincide con el del payload)
```

**Cierre FASE 0:** sin reglas de detención activas.

### T1 — Textos (C1, C2, C3)

Implementación en `33_app.jsx`, `narrativaTerritorial`, bloque "Frase 3": primero C2 (`if (matTotalNivel > 0 && entity.kind === "establecimiento")` arma la variante de §1 tal cual, con el comentario `a6-C2: …`), luego la rama de tramos (`else if (matTotalNivel > 0)`), que termina en `frase3 = tramos.length === 0 ? null : segs;` con el comentario `a6-C1: …`. En `NotasMetodologicas`: `pandemia, y el{" "}<b>Simce 2022</b>`. Retranspilación completa y reemplazo del bloque entero (`/tmp/cat_a6_reemplazar.sh`); el template no cambia fuera del bloque.

esperado: N1 sin frase 3 y sin `Considerando la matrícula 2025, .`; N2 y N3 con la variante C2, sin `a uno de desempeño` ni `a un establecimiento de desempeño`; en todo el motor `elSimce` 0 y `el Simce 2022` 1; 🔒7 solo con C1 a C3; 🔒1 a 🔒6; 🔒9; PRUEBAS a, c, d; 0 errores
obtenido:
```
/tmp/cat_a6_reemplazar.sh: template f247bf39821fa1c35be9dbd29142e7b0 1607 | retrans f247bf39821fa1c35be9dbd29142e7b0 1607 | distintas: 0
PRUEBAS a [t1]: exit=0; warnings=0; RENV_PROJECT=/Users/tomgc/Projects/slep_categoria_desempeno
md5 motor 56e7e5d23f77fc63476cd7d4180b3ac7 | docs antes de restaurar 56e7e5d23f77fc63476cd7d4180b3ac7 (🔒5 en el build)
PRUEBAS c: d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442 (motor y docs del build)
PRUEBAS d (renv activo, docs del build): F1–F4 OK (0 discrepancias), TODAS LAS FAMILIAS EN VERDE; SPOT-CHECK OK 6 + 1
docs restaurado: 788d5026562a67a73af43abffd97034e
N1 frase 3: (sin frase 3) · párrafos 3 · «Considerando la matrícula 2025, .» ×0
N2 frase 3: «Considerando la matrícula 2025, el establecimiento tiene 281 estudiantes en el nivel.» · «a uno de desempeño» ×0 · «a un establecimiento de desempeño» ×0
N3 frase 3: «Considerando la matrícula 2025, el establecimiento tiene 121 estudiantes en el nivel.» · «a uno de desempeño» ×0 · «a un establecimiento de desempeño» ×0
todo el motor (19 estados + N1 a N6): elSimce 0 · el Simce 2022 1 (S04)
🔒7 [t1] textContent = base con las cadenas declaradas: 28/28 · bloques con pares iguales 763/763
  conteo (base→nuevo): S04 C3 «elSimce 2022» 1→0, «el Simce 2022» 0→1 · S10 C2 «a un establecimiento de desempeño» 1→0, variante 0→1 · N1 C1 1→0 · N2 C1 1→0, variante 0→1 · N3 «a uno de desempeño» 1→0, variante 0→1
  S01–S09, S11, N4a, N4b: «a uno de desempeño» y «a un establecimiento de desempeño» sin cambio (sujeto territorial: la frase de tramos es correcta y no se toca)
  totales: C1 2→0 · «a uno de desempeño» 14→13 · «a un establecimiento de desempeño» 15→14 · variante C2 0→3 · «elSimce 2022» 1→0 · «el Simce 2022» 0→1
🔒9 .traj ascendente con 2019 al final y anillo en el último: 761/761 · .ee-detail-list descendente con 2019 y el vigente en el índice 0: 2/2
C4, C5, C6 sin cambio (N4a/N4b CORTADA; N5 9 líneas; N6 BODY), como corresponde a T1
contraste (informativo): texto 13722 mediciones (3 nodos menos en la frase 3 de S10), fallas 0 · gráficos exigidos 3009, fallidos 0
🔒3 git diff 968530c..HEAD -U0 | grep '^+' | grep -ciE '#[0-9a-f]{3,8}\b' → 0
🔒4 → 0 · 🔒6 f247bf39… = retrans (distintas: 0) · template: hunks fuera del bloque 0, dentro 3
errores de consola/pageerror: 0 (19 estados) y 0 (N1 a N6)
```
Commit: `3bc0c57`.

### T2 — Ancho (C4, C5) — CONGELADA (regla 7)

Implementación del candidato, según §1: template con `@media (max-width: 560px) { .modal-tabs { padding: 0 16px; } .modal-tab { margin-right: 16px; } }` tras `.modal-tab.is-active` (forma A); `.entity-select-btn` con `max-width: 100%; min-width: 0;` y la regla nueva `.entity-select-nom`; en `33_app.jsx`, `title={entity.nom}` y `<span className="entity-select-nom">{entity.nom}</span> ▾`. Build `t2a` (forma A, sin la regla opcional) y, porque la medición lo exigió, build `t2b` (forma B y regla opcional `.controls-bar .control-group { min-width: 0; max-width: 100%; }`). Instrumentos agregados: medida vertical de `.modal-tabs` (`scrollHeight` contra `clientHeight`), capturas 2× por elemento (`/tmp/cat_a6_tabs_png.js`, `/tmp/cat_a6_boton_png.js`) y líneas contadas como `top` distintos (con `text-overflow`, Chrome devuelve dos rectángulos por línea: el primer conteo de t2b decía 2 líneas y era una sola).

esperado: N4 a 390 px, las 4 pestañas completas dentro de `.modal-tabs` sin scroll; a 320 px completas o alcanzables por scroll horizontal (forma declarada); N5 con el botón en una línea, borde derecho dentro del viewport, `.controls-bar` a lo más tan alta como con el SLEP y `title` = nombre completo; desborde de `#root` 0 a 320, 390 y 1280; 🔒7 sin cadenas nuevas; 🔒8 en N4 y N5; 🔒1 a 🔒6
obtenido:
```
t2a (forma A; sin regla opcional): PRUEBAS a exit=0 warnings=0 (renv activo) · motor d475a0ead0135baeca91e231f82b75ff · PRUEBAS c d9895a78…0442 · docs restaurado 788d5026…
  N4a 390: .modal-tabs [20, 370] padding 16/16 margen 16 clientWidth 350 scrollWidth 350 · Comuna 36–100.3 | SLEP 116.3–155.4 | Región 171.4–223.7 | Establecimiento 239.7–361.3 (completas, sin scroll)
  N4b 320: .modal-tabs [20, 300] clientWidth 280 scrollWidth 341 · Establecimiento 239.7–361.3 CORTADA → exige la forma B
  N5 320: botón 838.6×36, 1 línea, [133.1, 971.7] fuera del viewport · desborde #root 652 (390: 582) → exige la regla opcional
t2b (forma B + regla opcional): PRUEBAS a exit=0 warnings=0 (renv activo) · motor 3f3a6e6c4847f9825cedd43d2c743288 · PRUEBAS c d9895a78…0442 · docs restaurado 788d5026…
  N4b 320: overflow-x auto · clientWidth 280 scrollWidth 373 · tras desplazar al final: Establecimiento 146.7–268.3 dentro (alcanzable) ✓
  N4a 390: pestañas completas en la posición inicial (Establecimiento 239.7–361.3 ≤ 370), PERO overflow-x auto · clientWidth 350 scrollWidth 373 (23 px desplazables: margen final 16 + relleno final 16 entran al área desplazable) y vertical clientHeight 43 scrollHeight 44 (overflow-y auto por arrastre; margin-bottom -1px de la pestaña); tras desplazar al final, Comuna 13–77.3 CORTADA ✗ "sin scroll"
  captura 2× t2a vs t2b a 390: 128×2 px distintos = el píxel inferior del subrayado activo, recortado por overflow (el separador queda visible bajo el subrayado)
  N4b 320×568: la fila de pestañas baja de 44 a 37 px de alto (con overflow ≠ visible, el mínimo automático del ítem flex pasa a 0 y el modal, limitado en alto, la encoge)
  N5 320: botón 146.9×36, 1 línea (tops distintos), [133.1, 280] dentro · .controls-bar 241 = SLEP 241 · title = nombre completo · desborde #root 0 a 320, 390 y 1280 ✓
  SLEP por defecto a 320: nombre 104 px visible en 102 px → «Costa Cent…» (captura 2×); a 360, 375 y 390 cabe. Causa: con el span, el nombre y « ▾» son dos ítems flex y el gap de 8 px reemplaza al espacio (botón 145 → 149 px); con la regla opcional el grupo queda en 240 px
  a 1280: 13 de 19 capturas cambian (S01–S11: el ▾ se corre ~4 px); textContent 19/19 igual
  🔒7 [t2] 28/28 (sin cadenas nuevas) · 🔒9 761/761 y 2/2 · 🔒8 19 estados: texto 0 de 13722, gráficos 0 de 3009 · N4a, N4b, N5: texto 0 de 3439, gráficos 0 de 523 · errores 0
```
**Dictamen.** C4: dentro de la lista cerrada no hay forma que cumpla los dos criterios: la forma A deja cortada la pestaña a 320 px, y la forma B, en la misma media query, vuelve desplazable la fila a 390 px (contra "sin scroll") y además recorta 1 px del subrayado activo y encoge la fila en viewports bajos (resultados no enumerados). C5: cumple todos sus criterios, pero produce un resultado no enumerado en la vista por defecto: el SLEP se lee «Costa Cent…» a 320 px. **Regla 7:** C4 y C5 se congelan (dudas Q-C4 y Q-C5 en FASE L), se sigue con lo independiente (T3) y **T4 no corre**. El candidato completo queda en `/tmp/cat_a6_t2_candidato.patch` (64 líneas, md5 `05904b58aeb54192977146fb7889f705`). Las ediciones se revirtieron a mano (mismas líneas en sentido inverso, sin `git checkout`) y se retranspiló.

esperado: árbol de trabajo idéntico a `3bc0c57` (T1) en `33_app.jsx` y el template; bloque = retranspilación
obtenido:
```
git diff HEAD -- 33_app.jsx 33_motor_template.html → 0 líneas · md5 template e63d5bb6750e354df1753e89f3a0712a = git show HEAD:… e63d5bb6750e354df1753e89f3a0712a
/tmp/cat_a6_reemplazar.sh: template f247bf39821fa1c35be9dbd29142e7b0 1607 | retrans f247bf39821fa1c35be9dbd29142e7b0 1607 | distintas: 0
porcelain: solo el LOG
```
Sin commit de T2.

### T3 — Foco (C6)

Implementación en `33_app.jsx`, `ComparativaSheet`: el `onClick` de `.cmp-clear-btn` pasa a `() => { focoTrasQuitar.current = entidades.length; setEntidades([]); }` con el comentario `a6-C6: …`; reutiliza el efecto a1-F04 (no hay `.cmp-chip-x` en ese índice → `.cmp-add-btn`). Retranspilación completa y reemplazo del bloque entero. T3 es independiente de T2 (otro componente, sin CSS).

esperado: en N6, tras el clic y tras Enter sobre "Limpiar", `document.activeElement` = `BUTTON.cmp-add-btn`; quitar un chip como en a1-F04 (3 territorios: el del medio → ✕ en su lugar; el último → "+ Agregar"); 🔒7 sin cadenas nuevas; 🔒1 a 🔒6; PRUEBAS a, c, d; 0 errores
obtenido:
```
/tmp/cat_a6_reemplazar.sh: template 328d625b2cd7d2409e21d26afd37a395 1611 | retrans 328d625b2cd7d2409e21d26afd37a395 1611 | distintas: 0
PRUEBAS a [t3]: exit=0; warnings=0; RENV_PROJECT=/Users/tomgc/Projects/slep_categoria_desempeno
md5 motor 6871dcb039da5b05144f4819e973aa8e | docs antes de restaurar 6871dcb039da5b05144f4819e973aa8e (🔒5 en el build)
PRUEBAS c: d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442 (motor y docs del build)
PRUEBAS d (renv activo, docs del build): F1–F4 OK (0 discrepancias), TODAS LAS FAMILIAS EN VERDE; SPOT-CHECK OK 6 + 1
docs restaurado: 788d5026562a67a73af43abffd97034e
N6: chips 2 → clic en Limpiar → foco BUTTON.cmp-add-btn (chips 0) · chips 2 → Enter en Limpiar → foco BUTTON.cmp-add-btn (chips 0)
a1-F04 con 3: quitar el del medio → BUTTON.cmp-chip-x 1/2; quitar el último → BUTTON.cmp-add-btn (igual que la base)
🔒7 [t3] 28/28 (solo las cadenas de T1) · t1 contra t3: capturas AE=0 19/19 y 9/9, textContent 19/19 y 9/9
🔒9 761/761 y 2/2 · contraste (informativo): 19 estados texto 0 de 13722, gráficos 0 de 3009; N4a, N4b, N5 texto 0 de 3439, gráficos 0 de 523
🔒3 git diff 968530c..HEAD -U0 | grep '^+' | grep -ciE '#[0-9a-f]{3,8}\b' → 0 · 🔒4 → 0 · 🔒6 328d625b… = retrans (distintas: 0) · template: hunks fuera del bloque 0
errores de consola/pageerror: 0 (19 estados) y 0 (N1 a N6)
```
Commit: `eabf8ad`.

### T4 — Despliegue — NO CORRE

esperado: T4 corre solo si T1 a T3 terminaron en verde
obtenido:
```
T1 verde (3bc0c57) · T2 CONGELADA por regla 7 (C4 y C5, sin commit) · T3 verde (eabf8ad)
→ T4 no corre (regla 7: el residual afecta a T2); docs/index.html queda en 788d5026562a67a73af43abffd97034e (el publicado), sin commit de despliegue
```

### FASE R — Auditoría propia y reparación

#### R.1 Inventario (anexado antes de auditar)

| id | afirmación | origen |
|---|---|---|
| R-01 | M1/M2: punto de partida limpio; `HEAD~1` = `origin/main` = `0396c2a` | FASE 0 |
| R-02 | M3: SHA de referencia `d9895a78…0442`, calibración y PRUEBAS d con renv activo | FASE 0 |
| R-03 | M-DERIVA: cadena idéntica | FASE 0 |
| R-04 | M4: N1 a N6 elegidos por programa | FASE 0 |
| R-05 | M5: los seis defectos se reproducen | FASE 0 |
| R-06 | M6: línea base determinista; candado calibrado | FASE 0 |
| R-07 | C1: N1 sin frase 3 | T1 |
| R-08 | C2: N2, N3 y S10 con la variante; sin «a uno de desempeño» ni «a un establecimiento de desempeño» con un EE como sujeto | T1 |
| R-09 | C3: `elSimce` 0 y `el Simce 2022` 1 | T1 |
| R-10 | T2 congelada: C4 sin forma que cumpla 390 y 320 dentro de la lista cerrada; C5 recorta el SLEP por defecto a 320 | T2 |
| R-11 | T2: árbol revertido exacto a T1, sin commit | T2 |
| R-12 | C6: foco en "+ Agregar" tras clic y tras Enter en "Limpiar"; a1-F04 intacto | T3 |
| R-13 | T4 no corre; `docs/index.html` = publicado | T4 |
| R-14 | 🔒1 | §3 |
| R-15 | 🔒2 | §3 |
| R-16 | 🔒3 | §3 |
| R-17 | 🔒4 | §3 |
| R-18 | 🔒5 | §3 |
| R-19 | 🔒6 | §3 |
| R-20 | 🔒7 | §3 |
| R-21 | 🔒8 | §3 |
| R-22 | 🔒9 | §3 |
| R-23 | Alcance global | FASE R |
| R-24 | Regresión PRUEBAS a–d (y b) | FASE R |
| R-25 | Control positivo: `docs/index.html` de `968530c` reproduce los seis defectos | FASE R |
| R-26 | Proceso: errores propios (heredoc que creó dos archivos en la raíz; `rm -rf` sin efecto; primera PRUEBAS d sin renv; instrumentos) | propio |
| R-27 | Entorno: `CLAUDE.md` local creado (ignorado por git); hallazgo sobre renv en PRUEBAS d del a5 | propio |

#### R.2–R.6 Re-derivación por caminos distintos, invariantes, alcance, regresión y control positivo

Caminos distintos: cadenas por `innerText` (antes `textContent`; `/tmp/cat_a6_candado_inner.js`); ancho y alto por captura y conteo de píxeles (antes `getBoundingClientRect`; `/tmp/cat_a6_rR2.js`: tinta de la fila de pestañas en el borde derecho del modal; caja del botón por los píxeles de su borde, con bordes verticales como columnas con ≥ 60 % de la altura; líneas como bandas de tinta; puntos suspensivos como cola de tinta solo en la franja baja; alto de la barra por sus filas de borde en una captura de página completa); foco por el evento `focusin` (antes `activeElement`); SHA del payload desde `git show <hash>:docs/index.html` y en Python; orden de años por coordenada (antes por nodos). Build de regresión `R` sobre `HEAD` (`eabf8ad`). Dos corridas del instrumento de píxeles salieron mal y se corrigieron antes de registrar: la primera tomaba la caja del botón por columnas con ≥ 6 píxeles de borde (se contaminaba con otros controles de la barra: 8 líneas donde hay 5) y la segunda perdía los bordes verticales por las esquinas redondeadas (6 px menos de ancho y "caja cerrada" falsa).

esperado: C1 a C3 y C6 re-derivan igual que T1 y T3; C4 y C5 siguen en el estado publicado en `HEAD` (T2 congelada) y los hallazgos del candidato se re-derivan; 🔒1 a 🔒9 con su comando; alcance = `33_app.jsx` y template (sin `docs/index.html` porque T4 no corrió; el encargo en `968530c`; el LOG en `docs(log)`); PRUEBAS a–d en verde y b con 0 errores; `docs/index.html` de `968530c` reproduce los seis defectos
obtenido:
```
── C1 a C3 por innerText (control = docs de 968530c; nuevo = build R)
🔒7 por innerText: 28/28 iguales a la base con las cadenas declaradas
  estados con conteo distinto: S04 [elSimce 2022 1→0, el Simce 2022 0→1] · S10 [«a un establecimiento de» 1→0, variante 0→1] · N1 [frase vacía 1→0] · N2 [frase vacía 1→0, variante 0→1] · N3 [«a uno de» 1→0, variante 0→1]
  totales: frase vacía 2→0 · «a uno de» 14→13 · «a un establecimiento de» 15→14 · variante 0→3 · elSimce 2022 1→0 · el Simce 2022 0→1
  control del candado (control contra sí mismo con las transformaciones): 23/28 · FALLAN: S04, S10, N1, N2, N3 (discrimina)
── C4 por píxeles (tinta en el borde derecho del modal)
  control y R: 390 SÍ cortada (última columna de tinta 349 de 350) · 320 SÍ cortada (279 de 280) · no desplazable
  candidato t2a: 390 no (340 de 350) · 320 SÍ (279 de 280)
  candidato t2b: 390 no (340 de 350), desplazable: al final la tinta corre 23 px (340 → 317) y la 1.ª pestaña queda cortada por la izquierda · 320 SÍ al inicio, alcanzable al final (última 247 de 280)
── C5 por píxeles (caja del borde, bandas de tinta, filas de borde de la barra)
  control y R: SLEP 320 145×36, 1 línea, barra 241 · EE 320 148×180, 9 líneas, barra 385 · EE 390 217×108, 5 líneas, barra 313
  candidato t2a: SLEP 320 149×36 · EE 320 y 390 caja abierta (sale del viewport), 1 línea, barra 241
  candidato t2b: EE 320 147×36 dentro, 1 línea, barra 241, puntos suspensivos sí · SLEP 320 147×36, puntos suspensivos SÍ (el recorte del SLEP se re-deriva) · EE 390 217×36, 1 línea
── C6 por focusin (destinos tras cada acción)
  R:        clic en Limpiar → [BUTTON.cmp-clear-btn, BUTTON.cmp-add-btn] · Enter en Limpiar → [BUTTON.cmp-add-btn] · quitar el del medio → [BUTTON.cmp-chip-x 1/2] · quitar el último → [BUTTON.cmp-add-btn]
  control:  clic → [BUTTON.cmp-clear-btn] (nada después: cae en BODY) · Enter → [] · quitar el del medio → [BUTTON.cmp-chip-x 1/2] · quitar el último → [BUTTON.cmp-add-btn]
── 🔒9 por coordenada (build R, /tmp/cat_a6_orden.js geo)
  S01 62, S05 11, S10 1, S11 5 .traj 2016→2019 con el anillo en 3 de 4 · S03 62 .traj (ídem) · .ee-detail-list 2019,2018,2017,2016 vigente en 0 de 4 · evolución 2016→2019 · delta «2016→2019: -1 (-1,7%)» · errores 0
── 🔒1
  968530c:docs/index.html md5 788d5026562a67a73af43abffd97034e SHA d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
  HEAD:docs/index.html    md5 788d5026562a67a73af43abffd97034e SHA d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
  build R (HEAD)          SHA d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442
  Python (build R contra docs de 968530c): payload igual salvo la fecha: True · claves de primer nivel distintas: []
── 🔒2 PRUEBAS d [R] (renv activo, docs del build): F1–F4 OK (0 discrepancias), TODAS LAS FAMILIAS EN VERDE; SPOT-CHECK OK 6 + 1
── 🔒3 git diff 968530c..HEAD -U0 | grep '^+' | grep -ciE '#[0-9a-f]{3,8}\b' → 0
── 🔒4 git diff 968530c..HEAD -- 30_procesamiento/30_* 30_procesamiento/31_* 30_procesamiento/32_* 30_procesamiento/33_generar_html.R 30_procesamiento/34_* 20_insumos 10_utils tests | wc -l → 0
── 🔒5 sin despliegue (T4 no corrió): en el build R, docs = motor = 6871dcb039da5b05144f4819e973aa8e antes de restaurar; docs restaurado 788d5026562a67a73af43abffd97034e (= publicado)
── 🔒6 template 328d625b2cd7d2409e21d26afd37a395 1611 líneas | retrans 328d625b2cd7d2409e21d26afd37a395 1611 líneas | distintas: 0
── 🔒7 (textContent, build R) 28/28 · bloques 763/763
── 🔒8 (build R) 19 estados: texto 13722 mediciones, 0 fallas activas, 0 pares · gráficos exigidos 3009, 0 fallidos (deshabilitados: 4 pares y 1 gráfico, exentos) · N4a, N4b, N5: texto 3439, 0 · gráficos 523, 0
── alcance: git diff --name-only 968530c..HEAD → 30_procesamiento/33_app.jsx, 30_procesamiento/33_motor_template.html; con el encargo (968530c^..HEAD) → + 50_documentacion/activa/encargos/encargo_claude_code_categoria_defectos_narrativa_ui_a6.md; docs/index.html no está (T4 no corrió); el LOG entra con docs(log)
── regresión: PRUEBAS a [R] exit=0, warnings=0 (renv activo), motor 6871dcb0… = build t3 (reproducible) · c d9895a78…0442 · d en verde · b: 0 errores en 19 + 9 estados (R) · t3 contra R: capturas AE=0 19/19 y 9/9, textContent 19/19 y 9/9
── control positivo (docs de 968530c, mismos instrumentos): base contra control AE=0 19/19 y 9/9, textContent 19/19 y 9/9 · N1 y N2 «Considerando la matrícula 2025, .» ×1 · N3 «a uno de desempeño» ×1 · S04 «elSimce 2022» ×1 · N4a y N4b Establecimiento CORTADA · N5 9 líneas, barra 385 · N6 foco BODY tras clic y tras Enter
── porcelain: solo el LOG · stash: []
```

#### R.7 Tabla de auditoría

| id | afirmación | comando | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | M1/M2 | `git log --oneline 968530c^..HEAD`; `rev-parse` | `968530c^` = `0396c2a` = `origin/main` | igual | PASA | — | `968530c` | — |
| R-02 | M3 | tres plantas; PRUEBAS d con `RENV_PROJECT` | igual/igual/distinto; verde con renv | igual/igual/distinto; verde con renv | PASA | — | — | — |
| R-03 | M-DERIVA | retranspilación | idéntica | idéntica | PASA | — | — | — |
| R-04 | M4 | `/tmp/cat_a6_elegir.js` | 6 estados | 6 (N1 no vacío) | PASA | — | — | — |
| R-05 | M5 | control positivo con los mismos instrumentos | seis defectos | seis defectos | PASA | — | — | — |
| R-06 | M6 | dos corridas; candado con plantas | iguales; discrimina | 19/19 y 9/9; 27/28 y 1/2 | PASA | — | — | — |
| R-07 | C1 | `innerText` | N1 sin la frase vacía | N1 1→0 | PASA | — | `3bc0c57` | — |
| R-08 | C2 | `innerText` | variante en N2, N3, S10; sin «a uno de» ni «a un establecimiento de» con EE | variante 0→3; «a uno de» N3 1→0; «a un establecimiento de» S10 1→0 | PASA | — | `3bc0c57` | — |
| R-09 | C3 | `innerText` | `elSimce` 0; `el Simce 2022` 1 | 0; 1 | PASA | — | `3bc0c57` | — |
| R-10 | T2 congelada | píxeles en t2a/t2b | sin forma que cumpla 390 y 320; SLEP recortado a 320 con C5 | forma A: 320 cortada; forma B: 390 desplazable 23 px; C5: SLEP con puntos suspensivos | ADVIERTE | congelada (regla 7); Q-C4 y Q-C5 al titular | — | — |
| R-11 | árbol revertido | `git diff HEAD`; md5 | 0; igual | 0; igual | PASA | — | — | — |
| R-12 | C6 | `focusin` | "+ Agregar" tras clic y Enter; a1-F04 igual | sí; sí | PASA | — | `eabf8ad` | — |
| R-13 | T4 no corre | md5 de docs; `git log` | `788d5026…`; sin commit de despliegue | igual; sin commit | PASA | — | — | — |
| R-14 | 🔒1 | `git show` + node; Python | `d9895a78…`; igual salvo fecha | igual; True | PASA | — | — | — |
| R-15 | 🔒2 | PRUEBAS d [R] | verde | verde | PASA | — | — | — |
| R-16 | 🔒3 | comando de §3 | 0 | 0 | PASA | — | — | — |
| R-17 | 🔒4 | comando de §3 | 0 | 0 | PASA | — | — | — |
| R-18 | 🔒5 | md5 | sin despliegue: docs = publicado; en el build docs = motor | `788d5026…`; `6871dcb0…` = `6871dcb0…` | PASA | — | — | — |
| R-19 | 🔒6 | retranspilación | idéntica | idéntica | PASA | — | — | — |
| R-20 | 🔒7 | `textContent` e `innerText` | 28/28 | 28/28 y 28/28 | PASA | — | — | — |
| R-21 | 🔒8 | instrumento del a3 sobre R | 0 y 0 | 0 y 0 | PASA | — | — | — |
| R-22 | 🔒9 | nodos y coordenada | ascendente / descendente | 761/761, 2/2; por coordenada igual | PASA | — | — | — |
| R-23 | alcance | `git diff --name-only` | `33_app.jsx`, template (docs no, sin T4) | igual | PASA | — | — | — |
| R-24 | regresión | PRUEBAS a–d y b | verde; 0 errores | verde; 0 | PASA | — | — | — |
| R-25 | control positivo | mismos instrumentos sobre docs de `968530c` | seis defectos | seis defectos | PASA | — | — | — |
| R-26 | proceso | revisión propia | — | (a) un heredoc de Python en zsh creó dos archivos vacíos en la raíz del repo; se movieron con `mv` a `/tmp/cat_a6_basura/` (sin `rm`); porcelain volvió a vacío; (b) se ejecutó `rm -rf /tmp/cat_a6_ctrl7` sobre un directorio temporal que aún no existía (sin efecto; `rm` no está en la lista de autorizaciones); (c) la primera PRUEBAS d de M3 corrió sin renv y se repitió; (d) instrumentos corregidos antes de registrar (búsqueda por RBD, conteo de líneas, caja por píxeles, `awk` y un heredoc con comillas que no llegó a ejecutarse; el resumen de `nuevos.js` cuenta `errores.txt` como estado) | ADVIERTE | declarado | — | — |
| R-27 | entorno | `git check-ignore`; build a5 | — | `CLAUDE.md` local creado por la instrucción global (ignorado por git: no toca porcelain ni el alcance); en el a5, PRUEBAS d corrió sin renv (desde `/tmp`) | ADVIERTE | Q-CLAUDEMD al titular; hallazgo informado | — | — |

**Ciclos de reparación:** 0 (sin hallazgos REPARA). **Veredicto FASE R: SIN BLOQUEO** (0 BLOQUEA, 0 REPARA, 3 ADVIERTE: R-10, R-26, R-27). No hay commit de despliegue que revertir.

### FASE L — Cierre

#### Resumen

Se corrigieron y verificaron cuatro de los seis defectos. T1 corrige la frase 3 de la narrativa: se omite cuando la matrícula del nivel está solo en Medio-Bajo (C1) y, con un establecimiento como sujeto, dice cuántos estudiantes tiene en el nivel (C2); además repone el espacio de "el Simce 2022" (C3). T3 deja el foco en "+ Agregar" tras "Limpiar" (C6). En ambos casos el payload quedó idéntico, las pruebas del dato siguen en verde con renv activo y solo cambiaron las cadenas declaradas. T2 (C4 y C5) se implementó y midió como candidato, pero se congeló por la regla 7. En C4, dentro de la lista cerrada ninguna forma cumple a la vez "390 sin scroll" y "320 completas o alcanzables". En C5, el SLEP por defecto queda recortado a 320 px. Se revirtió a mano y el candidato quedó en `/tmp`. Como el residual afecta a T2, T4 no corrió y `docs/index.html` sigue siendo el publicado.

#### Commits

`968530c` encargo · `3bc0c57` T1 · `eabf8ad` T3 · (este) `docs(log)`.

#### Medición por defecto (antes → después)

- **C1** (N1, comuna h2cb7446c, media): «Considerando la matrícula 2025, .» ×1 → ×0; párrafos 4 → 3. N2: ×1 → ×0 (pasa a la variante C2).
- **C2** (N3, EE h4a44dc15): «…121 asisten a uno de desempeño Insuficiente (100,0%).» → «Considerando la matrícula 2025, el establecimiento tiene 121 estudiantes en el nivel.»; N2 (EE h4fc82b26): frase vacía → «…tiene 281 estudiantes en el nivel.»; S10: «…693 estudiantes asisten a un establecimiento de desempeño Medio o Alto (100,0% de la matrícula del nivel).» → «…tiene 693 estudiantes en el nivel.».
- **C3** (S04): «elSimce 2022» 1 → 0; «el Simce 2022» 0 → 1.
- **C4** (N4, congelado; `HEAD` sin cambio): 390 y 320 «Establecimiento» CORTADA (269,7–391,3 contra 370 y 300). Candidato A: 390 sin corte ni scroll; 320 cortada. Candidato A+B: 390 sin corte pero desplazable 23 px; 320 alcanzable.
- **C5** (N5, EE ha0a73bb4, congelado; `HEAD` sin cambio): 320 botón 147,7×180 (9 líneas), barra 385 px (0,678 del alto) contra el SLEP 145×36 y 241 px. Candidato con regla opcional: 146,9×36, 1 línea, barra 241, desborde 0, `title` = nombre, pero el SLEP a 320 queda en «Costa Cent…».
- **C6** (N6): foco tras clic en "Limpiar" BODY → `BUTTON.cmp-add-btn`; tras Enter BODY → `BUTTON.cmp-add-btn`; a1-F04 sin cambio (✕ 1/2 y "+ Agregar").

#### Invariantes

🔒1 PASA · 🔒2 PASA · 🔒3 PASA · 🔒4 PASA · 🔒5 sin despliegue (docs = publicado; en cada build docs = motor) · 🔒6 PASA · 🔒7 PASA (28/28 por `textContent` y por `innerText`) · 🔒8 PASA · 🔒9 PASA.

#### md5 de `docs/index.html`

`788d5026562a67a73af43abffd97034e`, sin despliegue: es el mismo que ya estaba publicado. Motor de `HEAD` (`40_salidas/motor_categoria.html`, no versionado): `6871dcb039da5b05144f4819e973aa8e` (builds t3 y R idénticos).

#### Forma de C4 y regla opcional de C5

Ninguna quedó aplicada (T2 congelada). En el candidato, la medición exigió la **forma B** de C4 (con la A, «Establecimiento» seguía cortada a 320) y la **regla opcional** de C5 (sin ella, el botón desbordaba 652 px a 320 y 582 a 390).

#### Salida literal de M0

```
- The project is out-of-sync -- use `renv::status()` for details.
The following package(s) are used in this project, but are not installed:
- suitedoc

See `?renv::status` for advice on resolving these issues.
exit=0
```
Es el desfase atribuible solo a `suitedoc` (usado, no instalado y no registrado en `renv.lock`); no aparece ninguna versión distinta. No se actuó sobre renv.

#### Dudas con pregunta cerrada

- **Q-C4:** con la lista cerrada, la forma A deja «Establecimiento» cortada a 320 px, y la forma B, en la misma media query, vuelve desplazable la fila de pestañas a 390 px (23 px en horizontal y 1 px en vertical), recorta el píxel del subrayado activo que pisa el separador y, en viewports bajos, baja la fila de 44 a 37 px. ¿Se acepta la forma B con esos efectos? Sí (se aplica A + B tal cual) / No (se replantea C4 en otro encargo).
- **Q-C5:** con C5 tal cual y la regla opcional que exigió la medición, a 320 px el SLEP por defecto se lee «Costa Cent…» (2 px de recorte: con el span, el gap de 8 px reemplaza al espacio antes de ▾), y en todos los anchos el ▾ se corre unos 4 px. ¿Se acepta? Sí (se aplica tal cual) / No (se replantea C5 en otro encargo).
- **Q-DEPLOY:** ¿se despliegan ya T1 y T3 (C1, C2, C3 y C6, verificados), sin esperar a C4 y C5? Sí / No.
- **Q-CLAUDEMD:** para cumplir la instrucción global, se creó un `CLAUDE.md` local en la raíz, ignorado por git (no entra al repositorio ni al alcance). ¿Se conserva? Sí / No (si No, lo borra el titular).

#### Errores propios

1. Un heredoc de Python lanzado por zsh con comillas anidadas no se ejecutó, pero zsh interpretó fragmentos como redirecciones y creó dos archivos vacíos en la raíz del repo. Se detectaron en el porcelain y se movieron con `mv` a `/tmp/cat_a6_basura/` (el encargo no autoriza `rm`). Desde ahí, los scripts se escribieron como archivos.
2. `rm -rf /tmp/cat_a6_ctrl7` sobre un directorio temporal que aún no existía. No tuvo efecto, pero `rm` no está en la lista de autorizaciones y la instrucción global lo reserva a aprobación individual.
3. La primera corrida de PRUEBAS d de M3 salió desde `/tmp`, sin renv. Se repitió con renv activo, y esa es la registrada.
4. Instrumentos corregidos antes de registrar cifras: elegir el EE por RBD en el modal (la búsqueda corta en 60), el conteo de líneas por rectángulos (con `text-overflow`, dos por línea), la caja del botón por píxeles (contaminada por otros controles y por las esquinas redondeadas), un `awk` en línea con comillas rotas y el resumen de `nuevos.js`, que cuenta `errores.txt` como estado (son 9 estados, no 10).
5. Un bloque del LOG con una comilla sobrante que zsh rechazó sin ejecutar nada (verificado: LOG y porcelain sin cambios).

#### Privacidad

`/tmp/cat_a6_priv.sh` busca RUT con DV, la sigla del rol seguida de número y nombres típicos de establecimiento. Control: una copia del LOG con tres plantas ficticias (`/tmp/cat_a6_priv_control.md`) da RUT 1, RBD+n 1 y nombre EE 1, es decir, detecta. LOG: RUT 0, RBD+n 0, nombre EE 0 (vacío). Los estados se nombran por índice o por hash corto.

#### Lo que falló o sorprendió

- La lista cerrada de C4 y la de C5 tienen efectos que el encargo no anticipó y que solo se ven midiendo en Chrome. `overflow-x: auto` suma al área desplazable el margen de la última pestaña y el relleno final (23 px a 390), arrastra `overflow-y` a `auto` (recorta el subrayado que se superpone al separador) y deja que el modal encoja la fila. El `span` convierte « ▾» en un ítem flex aparte, así que el gap de 8 px reemplaza al espacio y el SLEP deja de caber a 320.
- En el a5, PRUEBAS d se corrió desde `/tmp`, sin renv. Este encargo las corrió con renv activo sobre el mismo payload, y siguen en verde.
- La frase de tramos con sujeto territorial («a uno de desempeño», «a un establecimiento de desempeño») sigue en 13 y 14 estados, y es correcta: C2 solo cambia el caso con un establecimiento como sujeto.

#### Verificación del archivo

`grep -c '^esperado:'` → 14 · `grep -c '^obtenido:'` → 14 (iguales) · `grep -c '^## J'` → 1 · hex en el LOG (`grep -ciE '#[0-9a-f]{3,8}\b'`) → 0 · privacidad 0 / 0 / 0.

#### Estado de cierre

T1 y T3 COMPLETADAS · T2 CONGELADA (regla 7) · T4 NO CORRE · FASE R SIN BLOQUEO · `docs/index.html` sin cambio (`788d5026…`) · push según autorización tras este commit · sin shells en segundo plano.
