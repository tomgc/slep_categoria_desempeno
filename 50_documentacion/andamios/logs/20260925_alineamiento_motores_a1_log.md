# Log — Alineamiento del motor de Categoría con los patrones de usabilidad de `slep_idps` (a1)

- **Fecha:** 2026-09-25
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_categoria_alineamiento_motores_a1.md`
- **Proyecto:** `slep_categoria_desempeno`
- **Ejecutor:** Claude Code (Opus 5.5, sesión única, sin subagentes)
- **Punto de retorno (`<inicio>`):** `9d4e120` — `chore(encargo): alineamiento de motores a1` (padre `3afd23a`)
- **Privacidad:** este log no lleva RBD con número ni nombres de establecimiento.

## J. Juicio (lo rellena FASE L)

1. **Meta y resultado:** alinear el motor con los patrones de `slep_idps`, adaptados; resultado parcial: plan completo (18 fichas re-medidas), implementación congelada por deriva de la fuente (M4).
2. **Estado por tarea:** T1 completada; T2 congelada (regla 3); T3 congelada (regla 3); FASE R BLOQUEADO (🔒6 heredado); FASE L completa.
3. **Commits:** `9d4e120` encargo; `5160d22` plan (T1); el de este LOG (`docs(log)`); sin `feat(motor)` ni `fix(auditoria)`.
4. **Auditoría:** 22 filas; 0 REPARA, 3 ADVIERTE (R-08, R-21, R-22), 1 BLOQUEA (R-16, 🔒6); 0 ciclos de reparación; control positivo presente.
5. **Invariantes:** 🔒1, 🔒2, 🔒3, 🔒4, 🔒5 y 🔒7 PASAN; 🔒6 FALLA heredada de `91ff8ed` (no producida ni empeorada por el encargo).
6. **Cifras críticas:** SHA payload normalizado `0ffd9899…2ad8` antes y después; F1–F4 y spot-check en verde; `docs/index.html` `45e612f1…`; motor reconstruido `8785476d…` (solo cambia la fecha).
7. **Decisiones autónomas de mayor riesgo:** tratar 🔒6 heredado como BLOQUEA (y no pushear); correr R con `RENV_ACTIVATE_PROJECT=FALSE`; clasificar D-08, D-13 y D-22 como diferir.
8. **Desviaciones:** R fuera de `renv` (librería del proyecto incompleta); PRUEBAS a–d corridas en FASE R sobre fuentes intactas porque T3 quedó congelada.
9. **Dudas abiertas:** D-M4, Q-F11, Q-F09, Q-F18, Q-D08, Q-D22, Q-PUSH (todas con pregunta cerrada en FASE L).
10. **Errores propios:** 4, todos corregidos antes de registrar la cifra afectada (instrumentos de `textContent`, zlib y foco; tres lecturas del plan).
11. **Qué debe verificar el revisor:** la causa de M4 (`git show 91ff8ed` frente a `33_app.jsx`, buscador de `EntityModal`), las clases del plan (§3.1) y que el veredicto BLOQUEADO por un 🔒 heredado es la lectura que quiere del contrato.
12. **No publicado / queda al usuario:** push de 3 commits (Q-PUSH); decisión D-M4 para descongelar T2/T3; gate visual inexistente (no hay motor nuevo con cambios).
13. **Ejecución:** Opus 5.5, una sesión, 0 subagentes, Babel 8.0.6 en `/tmp/cat_a1_babel`, Puppeteer con Chrome del sistema, instrumentos en `/tmp/cat_a1_*`.

## Esqueleto

- FASE 0 — apertura y mediciones M1–M6
- T1 — plan de adaptación
- T2 — implementación
- T3 — build y verificación
- FASE R — auditoría propia y reparación
- FASE L — cierre

### FASE 0

#### M1 — porcelain tras el primer commit; stash; archivos del primer commit

esperado: `?? 40_salidas/categoria_rbd_contrato.parquet` y `?? 50_documentacion/andamios/logs/` (el LOG); stash vacío; primer commit = solo el encargo
obtenido:
```
?? 40_salidas/categoria_rbd_contrato.parquet
?? 50_documentacion/andamios/logs/20260925_alineamiento_motores_a1_log.md
stash: []
9d4e120 chore(encargo): alineamiento de motores a1

50_documentacion/activa/encargos/encargo_claude_code_categoria_alineamiento_motores_a1.md
```

#### M2 — fetch; HEAD~1; HEAD..origin/main; origin/main..HEAD

esperado: `HEAD~1` = `3afd23a` = `origin/main`; `HEAD..origin/main` = 0; `origin/main..HEAD` = 1
obtenido:
```
HEAD~1=3afd23a origin/main=3afd23a HEAD..origin/main=0 origin/main..HEAD=1
```

#### M3 — md5 de plantilla, `33_app.jsx`, motor y `docs/`; SHA-256 del payload normalizado (con calibración); PRUEBAS d

esperado: plantilla `9e9640ca05205d345e713b489ee3e98d`; `33_app.jsx` `428448d63765d5be7a9558bd3c62e926`; motor = docs = `45e612f1c9909a2dd1115d9e8628cde0`; instrumento `/tmp/cat_a1_payload.js`: fecha alterada → mismo SHA, cifra plantada → SHA distinto; `auditar_cifras.R` F1–F4 OK y `spot_check_publicado.R` OK
obtenido:
```
MD5(30_procesamiento/33_motor_template.html)= 9e9640ca05205d345e713b489ee3e98d
MD5(30_procesamiento/33_app.jsx)= 428448d63765d5be7a9558bd3c62e926
MD5(40_salidas/motor_categoria.html)= 45e612f1c9909a2dd1115d9e8628cde0
MD5(docs/index.html)= 45e612f1c9909a2dd1115d9e8628cde0
payload normal:         0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8
payload fecha alterada: 0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8
payload cifra plantada: d593e1b34e99a9e55aad24e05a307a5e97d76a36c2f6d11c948bfc2f6bd435cc
auditar_cifras.R: F1 OK, F2 OK, F3 OK, F4 OK (0 discrepancias c/u); exit=0
spot_check_publicado.R: 6 celdas de presencia + 1 de ausencia OK; exit=0
```
Nota de entorno (desviación declarada): con `renv` activo `Rscript` falla (`no hay paquete llamado 'dplyr'`: la librería `renv/library/macos/R-4.5` solo tiene fs, here, renv, rprojroot). Todas las corridas R de este encargo usan `RENV_ACTIVATE_PROJECT=FALSE` (librería del sistema R 4.5, donde están arrow, dplyr, jsonlite, here, fs). No se instala ni restaura nada (no autorizado). El instrumento usa `zlib.unzipSync` porque `memCompress(type="gzip")` de R emite cabecera zlib, no gzip.

#### M4 — Deriva de la fuente: retranspilar `33_app.jsx` y comparar con el bloque del template

esperado: bloque retranspilado (desde `"use strict";`) igual al bloque del template como cadena, o, si difiere, render idéntico (AE=0 y `textContent` de `#root` igual) en las 9 pantallas de PRUEBAS b a 1280×800
obtenido:
```
Babel en /tmp/cat_a1_babel: @babel/cli 8.0.6, @babel/core 8.0.6, @babel/preset-react 8.0.1; config {"presets":[["@babel/preset-react",{"runtime":"classic"}]]}
bloque template: 1462 líneas, md5 000ac7723f2cdd44f8cae3840302f9da
bloque retrans.: 1462 líneas, md5 6dcac8c01e711fc6a19aea268ab6e036  → CADENA DISTINTA (8 líneas)
  7 líneas cosméticas conocidas (fragmentación de text-nodes " ", 0.10 vs 0.1; ver 20260619_reconstruccion_app_jsx.md)
  1 línea sustantiva: template L590 fontSize: "var(--fs-body)"  |  retrans. fontSize: "var(--fs-base)"  (input de búsqueda de EntityModal)
render (motor de prueba /tmp/cat_a1_m4_motor.html vs motor actual, 1280×800):
01_apertura AE=0 · 02_modal_simple AE=10623 · 03_modal_simple_busqueda AE=5064 · 04_modal_simple_estab AE=16036
05_narrativa_estab AE=0 · 06_comparador_vacio AE=0 · 07_modal_multiple AE=9591 · 08_modal_multiple_10 AE=7080 · 09_comparador_10 AE=0
textContent #root: 9/9 IGUAL; errores consola/pageerror: 0
diagnóstico (solo /tmp): retrans. con --fs-base→--fs-body sustituido: 9/9 AE=0, 9/9 texto igual → la única deriva de render es esa línea
control de determinismo: motor actual vs motor actual, dos corridas: 9/9 AE=0
causa: 91ff8ed (2026-07-02, "style(motor): migra escala tipografica…") editó el transpilado del template (--fs-base→--fs-body; --fs-base dejó de existir en :root) sin tocar 33_app.jsx (versionado antes, en 120813e)
```
**Veredicto M4: FALLA (ni cadena ni render idéntico) → regla de detención 3: T2 y T3 CONGELADAS; T1 sigue.** Se registra como duda D-M4.

#### M5 — Re-medición propia de cada hueco de §3.2 sobre este motor

Instrumento propio: `/tmp/cat_a1_m5.js` (Puppeteer, Chrome del sistema, `file://`, teclado real); salida cruda en `/tmp/cat_a1_m5_base.json` y `/tmp/cat_a1_m5_base_CE.json` (la sección D se re-midió tras corregir el recorte de captura con desplazamiento; la primera corrida daba 0 píxeles cambiados en controles desplazados, artefacto del instrumento).

esperado: cada hueco de §3.2 (filas 1, 2, 3, 4, 5, 7, 8, 9, 11, 12, 14, 18, 19) queda registrado como confirmado, corregido o inexistente con cifra propia
obtenido:
```
F2  teclado en filas: modal simple 0/345 filas con tabIndex; 30 Tab desde el buscador → 0 filas alcanzadas (paradas: DIV.comuna-checklist, Cancelar, BODY, controles de la página…); modal múltiple 0 filas alcanzadas; Flecha+Enter desde el buscador no elige → CONFIRMADO (ausente)
F3  ciclo/Escape/origen: Tab sale del modal (a BODY) en ambos; role="dialog" ausente; Escape no cierra (ambos); Cancelar → foco en BODY → CONFIRMADO (ausente)
F4  respaldo: al tope (10) "+ Agregar" queda disabled y el foco tras "Agregar (10)" con Enter cae en BODY; elegir un EE en el modal simple → BODY; quitar un chip con Enter sobre su ✕ → BODY → CONFIRMADO (ausente; más el caso del chip, fuera de modal)
F5  ✕ de cierre: 0 botones en .modal-header; cierre visible = "Cancelar" (pie, con nombre por texto); Escape no cierra → CONFIRMADO (divergente)
F7  tope en el modal: con 10 marcadas, 335 filas bloqueadas; marcadas en otra pestaña (SLEP) visibles: 0; sin franja de lo elegido; aviso con 10 marcadas: "Selecciona hasta 10 territorios más · marcados: 10" (incoherente) → CONFIRMADO (divergente) + hallazgo del aviso confirmado
F8  filas del modal (Establecimiento, búsqueda "liceo", 60 filas): 1280 → 15 nombres partidos, 14 cabrían en una línea; 390 → 57 partidos, 37 cabrían; 320 → 59 partidos, 12 cabrían, 2 filas desbordadas; página sin desborde en los tres → CONFIRMADO (divergente)
F14 desborde de página (scrollWidth−clientWidth): apertura 0/0/0; modal comuna 0/0/0; modal EE 0/0/0; comparador 10 → 0/0/0; narrativa con el EE de nombre más ancho → 539 px a 320, 469 px a 390, 0 a 1280; muestra determinista de 40 EE: desbordan 18/40 a 320 y 8/40 a 390 → CONFIRMADO (divergente)
F11 contraste de textos de estado: cabeceras de columna (título/stat/mat, blanco con opacidad sobre relleno): Insuficiente 4,11/3,67/3,16; Medio-Bajo 2,62/2,44/2,23; Medio 3,48/3,19/2,85; Alto 6,45/5,72/4,89; % máximo del comparador (--ocean sobre su tinte) n=4 min 2,07 max 3,51 (los no máximos: min 8,07); delta negativo de la ficha (#EE2D49 sobre su fondo) 3,97; hover de la ✕ del chip (blanco sobre #EE2D49) 4,11; chip de filtro activo (blanco sobre --ocean) 6,45 → CONFIRMADO (ausente); corrección: delta negativo 3,97 (la matriz dice 4,11, medido contra blanco)
F12 anillo de foco (captura antes/después, contraste máx. píxel anillo vs debajo): "+ Agregar" (relleno --ocean) 1,21; chip activo (relleno --ocean) 1,19; chip inactivo 5,98; segmented activo 5,98; "Limpiar" 5,56; ✕ de chip 5,98 → CONFIRMADO (divergente: solo los controles rellenos de --ocean)
F1  conteos "1 + plural": "1 establecimientos sin categoría en 2019" en 93 de 794 pares entidad×nivel (visible confirmado en la interfaz: comuna ALHUÉ, básica: «1 establecimientos sin categoría en 2019 (conteo oficial)…»); "1 matriculados en …" en 281 pares EE×año (ficha); "1 estudiantes" en cabecera de columna: 0 casos con el dato actual (latente); EE como entidad: 8.512 pares EE×nivel categorizados producen "tiene 1 establecimiento con … categorizado" → CONFIRMADO (divergente); corrección: "1 estudiantes" no ocurre con el dato actual
F9  "Sin categoría vigente": vista por territorio (conteo oficial s/i) ≠ comparador (s/i + sin medición) en 29 de 72 pares SLEP×nivel (190 de 794 pares entidad×nivel en total) → CONFIRMADO; fila Región del modal ("N comunas", catálogo) vs comunas con EE un clic después (chips del filtro, que no son una cifra): básica 0/16 distintas, media 7/16 → la segunda cifra no existe como número → parte Región INEXISTENTE como problema de "dos cifras"
F18 mayúsculas del dato: nombres de EE en mayúsculas 9.040/9.040; comunas 345/345; regiones 0/16; SLEP 0/36; 1.371 tokens distintos con forma de sigla/abreviatura en nombres de EE → CONFIRMADO (divergente)
F19 sin hash del payload en el proyecto; el instrumento de M3 (fecha normalizada) funciona sobre este motor → CONFIRMADO (divergente; ya existe verificación por valor)
errores de consola/pageerror durante M5: 0
```

#### M6 — Capturas y `textContent` de línea base (🔒7)

esperado: 9 pantallas de PRUEBAS b a 1280×800 y a 390×800, con PNG y `textContent` de `#root`, 0 errores
obtenido:
```
/tmp/cat_a1_base/1280: 9 PNG + 9 TXT + errores.txt (vacío) — errores=0
/tmp/cat_a1_base/390:  9 PNG + 9 TXT + errores.txt (vacío) — errores=0
pantallas: 01_apertura, 02_modal_simple, 03_modal_simple_busqueda, 04_modal_simple_estab, 05_narrativa_estab, 06_comparador_vacio, 07_modal_multiple, 08_modal_multiple_10, 09_comparador_10
determinismo (dos corridas a 1280 del mismo motor): 9/9 AE=0, 9/9 texto igual
```

**Cierre FASE 0.** M1, M2 y M3 pasan. **M4 falla → regla 3: T2 y T3 congeladas; T1 sigue.** M5 y M6 registradas. Entorno: R con `RENV_ACTIVATE_PROJECT=FALSE` (desviación declarada en M3).

### T1 — Plan de adaptación

Lecturas, en orden: decisiones del proyecto (sin GSE, nombres de EE, paleta, cobertura temporal, C3, reconstrucción JSX), backlog (notas v03/v07, c.21, c.30–c.33, c.40, c.62, c.88), traspaso v29 (confirma que la migración tipográfica editó solo el transpilado), matriz §1, §3.2, §4.3, §6 y §7, y la plantilla de `slep_idps` en `d935299` (EntityModal L1636–1760, CSS L222–231 y L550, `tc()`/`SIGLAS`, `nEE`, `--foco`, `.cmp-cl`), con `GIT_OPTIONAL_LOCKS=0` y sin escritura.

Documento: `50_documentacion/andamios/20260925_plan_alineamiento_motores.md`. Correcciones propias antes del commit: contrastes recalculados con 3 decimales (`--ink`/Insuficiente 4,46, no 4,49; `--ink`/Medio-Bajo 7,01; `--ink`/Medio 5,27; `--ocean`/`--ocean-20` 4,97); el respaldo de `slep_idps` es el rótulo `span.cmp-cl` con `tabIndex=-1` (la primera redacción lo llamaba "botón de limpiar", error de lectura corregido); la narrativa nace en la c.62, no en la c.45.

esperado: 18 fichas (13 filas de §3.2 + D-03, D-08, D-13, D-22, D-24), cada una con clase y razón; ninguna adoptar/adaptar cruza los límites de §1; toda diferir con pregunta cerrada; 0 RBD con número y 0 nombres de establecimiento
obtenido:
```
fichas con clase: 18
Adoptar=2 Adaptar=8 Inspirarse=2 NoAplica(fichas)=0 Diferir=6
preguntas cerradas en §4: 6 (Q-F09 cubre F09 y D-13)
RBD con número: 0; nombres de EE (LICEO|ESCUELA|COLEGIO|INSTITUTO): 0
límites: adoptar/adaptar usan solo --ocean, .icon-btn y clases existentes; ninguna toca payload, cifra, generador, pipeline; 0 hex en el plan fuera de citas de la paleta vigente: #0062A0 #EE2D49 
```
Commit: `5160d22` — `docs(alineamiento): plan de adaptación de los patrones de slep_idps (a1 T1)`.

### T2 — Implementación

**CONGELADA** por la regla de detención 3 (M4 en FALLA). No se editó `33_app.jsx` ni el template; no hay commit `feat(motor)`. Lo que T2 implementará al descongelarse está en §3.2 del plan (10 fichas: F02, F08 adoptar; F01, F03, F04, F05, F07, F12, F14, D-03 adaptar), con la precondición D-M4.

### T3 — Build y verificación

**CONGELADA** por la regla de detención 3. No hay motor nuevo que verificar ni capturas de gate "después" en `/tmp/cat_a1_gate/`. La regresión de las fuentes intactas (PRUEBAS a–d) se corre en FASE R, paso 5.

### FASE R — Auditoría propia y reparación

#### R.1 Inventario (anexado antes de auditar)

| id | afirmación a auditar | origen |
|---|---|---|
| R-01 | M1: porcelain, stash vacío y primer commit solo con el encargo | FASE 0 |
| R-02 | M2: `HEAD~1` = `origin/main` = `3afd23a` al inicio | FASE 0 |
| R-03 | M3: md5 de partida y SHA del payload `0ffd9899…2ad8`; instrumento calibrado; PRUEBAS d en verde | FASE 0 |
| R-04 | M4: FALLA; única deriva de render = `--fs-base` en el buscador de `EntityModal` | FASE 0 |
| R-05 | M5: los 13 huecos re-medidos (confirmados salvo la parte Región de F09) | FASE 0 |
| R-06 | M6: línea base de 9 pantallas a 1280 y 390, determinista | FASE 0 |
| R-07 | Plan: 18 fichas con clase y razón (2 adoptar, 8 adaptar, 2 inspirarse, 6 diferir) y 6 preguntas cerradas | T1 |
| R-08 | Segunda lectura de las fichas *adoptar* (F02, F08): nada de la lógica de `slep_idps` coló sin razón | T1 |
| R-09 | Privacidad del plan: 0 RBD con número, 0 nombres de establecimiento | T1 |
| R-10 | T2 y T3 congeladas: 0 cambios en `33_app.jsx` y en el template | T2/T3 |
| R-11 | 🔒1 payload intacto | §3 |
| R-12 | 🔒2 cifras intactas | §3 |
| R-13 | 🔒3 sin hex nuevo; `:root` con el mismo md5 | §3 |
| R-14 | 🔒4 generador y pipeline intactos | §3 |
| R-15 | 🔒5 `docs/` publicado intacto | §3 |
| R-16 | 🔒6 fuente y transpilado no divergen | §3 |
| R-17 | 🔒7 lo no tocado no cambia | §3 |
| R-18 | Alcance global: solo el plan (y el LOG) cambian respecto de `<inicio>` | §4 |
| R-19 | Regresión PRUEBAS a–d sobre las fuentes intactas | §7.5 |
| R-20 | Control positivo: el motor anterior (`45e612f1…`) muestra los huecos de M5 con el mismo instrumento | §7.6 |

#### R.2–R.6 Re-derivación, invariantes, alcance, regresión y control positivo

esperado: PRUEBAS a exit 0 y 0 warnings; PRUEBAS c SHA normalizado = `0ffd9899…2ad8` (y, por Python, objetos iguales sin la fecha); PRUEBAS d F1–F4 OK y spot-check OK con `docs/index.html` recién escrito; tras `git restore docs/index.html`, md5 = `45e612f1…`; PRUEBAS b 0 errores; 🔒7 9/9 AE=0 y texto igual a 1280 y 390
obtenido:
```
PRUEBAS a: run_all(only = 33) exit=0; líneas con warning/advertencia en la salida: 0; motor nuevo 40_salidas/motor_categoria.html md5 8785476deeff0bc759934a1b9711e118 (docs idéntico antes de restaurar)
PRUEBAS c: node  nuevo 0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8 / anterior 0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8
           python: objetos iguales sin fecha = True | fechas 2026-09-25 2026-07-02 ; HTML fuera del payload: diff 0 líneas
PRUEBAS d: auditar_cifras.R exit=0, F1–F4 OK (0 discrepancias), "TODAS LAS FAMILIAS EN VERDE"; spot_check_publicado.R exit=0, "SPOT-CHECK OK: 6 celdas de presencia + 1 de ausencia"
git restore docs/index.html → md5 45e612f1c9909a2dd1115d9e8628cde0
PRUEBAS b + 🔒7: 1280 → 9/9 AE=0, 9/9 texto IGUAL, errores=0; 390 → 9/9 AE=0, 9/9 texto IGUAL, errores=0
```

esperado: re-derivación con comandos distintos reproduce M4 y M5; invariantes 🔒1–🔒5 y 🔒7 PASAN; 🔒6 en el estado de M4; alcance = solo el plan; control positivo: el motor anterior muestra los mismos huecos
obtenido:
```
R-04 (getComputedStyle del buscador): motor 16px, motor retranspilado 18px; grep 'fs-base': 33_app.jsx 1, template 0
R-05 (árbol de accesibilidad de Chrome, modal simple): nodos role=dialog 0; filas enfocables 0; botones "Cerrar" 0
R-05 (otra métrica de ancho, 320 px, EE de nombre más largo por caracteres): body 320 / innerWidth 320; borde derecho máximo de .dato-destacado = 859 px (539 px fuera)
R-05 (innerText, comuna Alhué, básica): coincidencias de "1 establecimientos" = 1
🔒3 hex en líneas agregadas (template + 33_app.jsx, diff -U0 <inicio>..HEAD): 0; :root md5 <inicio> 1851160a… = HEAD 1851160a… = disco 1851160a… (102 líneas)
🔒4 git diff <inicio>..HEAD -- 30_* 31_* 32_* 33_generar_html.R 20_insumos 10_utils tests | wc -l → 0
🔒5 md5 docs/index.html 45e612f1c9909a2dd1115d9e8628cde0; git diff --name-only <inicio>..HEAD -- docs | wc -l → 0
🔒6 retranspilación de 33_app.jsx en HEAD: bloque template 000ac772… vs retrans. 6dcac8c0…; 8 líneas distintas (igual que M4); render distinto en 5 pantallas con modal (M4)
alcance: git diff --name-only <inicio>..HEAD → 50_documentacion/andamios/20260925_plan_alineamiento_motores.md ; porcelain → ?? parquet preexistente + ?? LOG ; stash 0
control positivo (motor anterior 45e612f1, /tmp/cat_a1_m5.js SEC=AE): filas alcanzadas 0/0, Tab sale del modal true, Escape no cierra, Cancelar → BODY, aviso con 10 "Selecciona hasta 10 territorios más · marcados: 10", tope → BODY, "1 establecimientos" 93 pares, sin categoría 4≠6 en 29 pares SLEP, nombres en mayúsculas 9.040 — idénticos a M5
```

#### R.7 Tabla de auditoría

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | M1 | `git show --stat 9d4e120`; `git stash list \| wc -l` | solo el encargo; 0 | solo el encargo; 0 | — | ninguna | — | — |
| R-02 | M2 | `git log -1 9d4e120^` | `3afd23a` | `3afd23a` | — | ninguna | — | — |
| R-03 | M3 | SHA por Python (igualdad de objetos) + `md5 -q` | iguales | iguales | — | ninguna | — | — |
| R-04 | M4 FALLA por `--fs-base` | `getComputedStyle` del buscador | 16px vs otro | 16px vs 18px | — (hallazgo de entrada) | T2/T3 congeladas (regla 3) | — | — |
| R-05 | huecos de M5 | árbol de accesibilidad, borde derecho, `innerText` | reproducen M5 | reproducen M5 | — | ninguna | — | — |
| R-06 | M6 determinista | segunda corrida | 9/9 AE=0 | 9/9 AE=0 | — | ninguna | — | — |
| R-07 | 18 fichas con clase | `grep -c '^- \*\*Clase:'` | 18 | 18 | — | ninguna | — | — |
| R-08 | *adoptar* sin lógica ajena | relectura de F02 y F08 | nada colado | F02: `role`/`aria-checked` según el modo de este modal (checkbox en múltiple), no el de `slep_idps`; F08: la alineación a la derecha del secundario viene de `slep_idps` y se declaró como riesgo visual | ADVIERTE | queda al gate del titular | — | — |
| R-09 | privacidad del plan | `grep -E 'RBD ?[0-9]'`; nombres | 0; 0 | 0; 0 | — | ninguna | — | — |
| R-10 | T2/T3 sin cambios | `git diff <inicio>..HEAD -- 30_procesamiento \| wc -l` | 0 | 0 | — | ninguna | — | — |
| R-11 | 🔒1 | PRUEBAS c | igual | igual | PASA | — | — | — |
| R-12 | 🔒2 | PRUEBAS d | verde | verde | PASA | — | — | — |
| R-13 | 🔒3 | diff -U0 + md5 `:root` | 0; igual | 0; igual | PASA | — | — | — |
| R-14 | 🔒4 | diff generador/pipeline | 0 | 0 | PASA | — | — | — |
| R-15 | 🔒5 | md5 docs + diff | `45e612f1…`; 0 | `45e612f1…`; 0 | PASA | — | — | — |
| R-16 | 🔒6 | retranspilación en HEAD | sin divergencia | 8 líneas; render distinto (heredado de `91ff8ed`, igual a M4; el encargo no lo produjo ni lo empeoró) | **BLOQUEA** (🔒 en FALLA) | no se repara (prohibido); duda D-M4 | — | — |
| R-17 | 🔒7 | recorrido 1280 y 390 | 18/18 AE=0 | 18/18 AE=0, texto igual | PASA | — | — | — |
| R-18 | alcance | `git diff --name-only`; porcelain | plan (+LOG) | plan; LOG sin versionar aún | PASA | — | — | — |
| R-19 | regresión a–d | PRUEBAS a–d | verde | verde | PASA | — | — | — |
| R-20 | control positivo | M5 sobre `45e612f1` | huecos presentes | presentes, idénticos | PASA | — | — | — |
| R-21 | entorno R | `renv::status()` | — | librería `renv` incompleta; corridas con `RENV_ACTIVATE_PROJECT=FALSE` | ADVIERTE | declarado; no se instala nada | — | — |
| R-22 | instrumentos propios | revisión de M5-D y del plan | — | M5-D primera corrida con recorte mal desplazado (0 píxeles); plan con dos errores de lectura corregidos antes del commit | ADVIERTE | corregidos antes de usar la cifra | — | — |

**Ciclos de reparación:** 0 (no hay hallazgos REPARA).

**Veredicto FASE R: BLOQUEADO** por R-16 (🔒6 en FALLA, heredado). No se ejecuta el push (la autorización lo excluye con FASE R en `BLOQUEADO`).

### FASE L — Cierre

#### Resumen

Se abrió el encargo (`9d4e120`) y se midió el punto de partida: repo en `origin/main`, md5 de partida confirmados, payload con SHA normalizado calibrado y pruebas del dato en verde. La medición M4 mostró que la fuente `33_app.jsx` no reproduce el motor: la migración tipográfica de v29 (`91ff8ed`) cambió `--fs-base` por `--fs-body` en el transpilado del template sin tocar la fuente; retranspilar cambiaría el tamaño del buscador de los dos modales. Por la regla 3, T2 y T3 se congelaron. T1 se completó: plan con 18 fichas re-medidas sobre este motor (2 adoptar, 8 adaptar, 2 inspirarse, 6 diferir) y 6 preguntas cerradas. FASE R: regresión a–d en verde, payload idéntico, capturas idénticas, `docs/` restaurado; 🔒6 en FALLA (heredado) → veredicto BLOQUEADO, sin push.

#### Commits

- `9d4e120` — `chore(encargo): alineamiento de motores a1`
- `5160d22` — `docs(alineamiento): plan de adaptación de los patrones de slep_idps (a1 T1)`
- (este) — `docs(log): alineamiento de motores a1`

#### Fichas por clase

Adoptar 2 (F02, F08) · Adaptar 8 (F01, F03, F04, F05, F07, F12, F14, D-03) · Inspirarse 2 (F19, D-24) · No aplica 0 fichas (la parte Región de F09) · Diferir 6 (F09, F11, F18, D-08, D-13, D-22).

#### Tabla de auditoría

Ver R.7 (22 filas; 0 REPARA; 3 ADVIERTE: R-08, R-21, R-22; 1 BLOQUEA: R-16).

#### Invariantes

🔒1 PASA · 🔒2 PASA · 🔒3 PASA · 🔒4 PASA · 🔒5 PASA · 🔒6 FALLA (heredada de `91ff8ed`; la detectó M4; el encargo no la produjo ni la empeoró) · 🔒7 PASA.

#### md5 del motor

`40_salidas/motor_categoria.html` reconstruido en FASE R (fuentes intactas): `8785476deeff0bc759934a1b9711e118` (difiere de `45e612f1…` solo en `fecha_generacion`: payload normalizado idéntico y HTML fuera del payload idéntico). `docs/index.html`: `45e612f1c9909a2dd1115d9e8628cde0` (restaurado).

#### Dudas con pregunta cerrada

- **D-M4:** ¿Autoriza un encargo que corrija en `33_app.jsx` `fontSize: "var(--fs-base)"` → `"var(--fs-body)"`, verifique M4 = render idéntico y recién entonces ejecute T2/T3 del plan? Sí / No.
- **Q-F11:** ¿(A) tokens de texto por categoría (hex nuevos, enmienda a la paleta), (B) `--ink` sobre Insuficiente/Medio-Bajo/Medio con 4,46:1 en Insuficiente como excepción escrita, o (C) dejar como está?
- **Q-F09:** ¿El comparador (A) cuenta solo los s/i oficiales, (B) conserva su cifra y renombra la fila "Sin categoría en 2019 (incluye sin medición)", o (C) muestra dos filas?
- **Q-F18:** ¿Nombres en formato título con lista de siglas y partículas escrita en una decisión propia? Sí / No.
- **Q-D08:** ¿Se mantiene fuera del modal la entidad nacional (c.21)? Sí / No.
- **Q-D22:** ¿La próxima categorización (Simce 2025) se publicará primero como preliminar? Sí / No.
- **Q-PUSH:** FASE R terminó en BLOQUEADO por 🔒6 heredado; ¿autoriza igualmente `git push origin main` de estos 3 commits documentales (encargo, plan, log)? Sí / No.

#### Errores propios

1. Instrumento de `textContent` sobre `document.body` (incluía el texto de los `<script>`): corregido a `#root` antes de registrar M4.
2. Instrumento de payload con `gunzipSync` (el payload es zlib): corregido a `unzipSync` antes de registrar M3.
3. M5-D, primera corrida: recorte de captura sin desplazamiento (0 píxeles cambiados en controles desplazados): corregido y re-medido; solo se registró la segunda.
4. Plan, primera redacción: contrastes a 2 decimales redondeados mal (4,49 por 4,46), `.cmp-cl` descrito como "botón de limpiar" (es un rótulo con `tabIndex=-1`) y la narrativa atribuida a la c.45 (es la c.62): corregidos antes del commit de T1.

#### Privacidad

`/tmp/cat_a1_priv.sh` (RUT con DV, "RBD" + número, nombres típicos de EE), con control plantado: una copia del LOG con tres plantas ficticias (un RUT con puntos y DV, la sigla del rol seguida de cuatro dígitos y un nombre ficticio que empieza por la palabra de liceo en mayúsculas) da RUT 1, RBD+n 1, nombre EE 2 (detecta). LOG: RUT 0, RBD+n 0, nombre EE 2 falsos positivos (las dos líneas que citan el propio patrón de búsqueda `LICEO|ESCUELA|…`; ningún nombre de establecimiento). Plan: 0, 0, 0.

#### Estado de cierre

T1 COMPLETADA · T2 CONGELADA (regla 3) · T3 CONGELADA (regla 3) · FASE R BLOQUEADO (R-16) · push NO ejecutado · `docs/index.html` restaurado (`45e612f1…`) · sin shells en segundo plano.
