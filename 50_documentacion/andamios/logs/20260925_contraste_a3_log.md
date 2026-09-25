# Log — Contraste figura-fondo completo del motor (a3)

- **Fecha:** 2026-09-25
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_categoria_contraste_a3.md`
- **Proyecto:** `slep_categoria_desempeno`
- **Ejecutor:** Claude Code (Opus 5.5, sesión única, sin subagentes)
- **Punto de retorno (`<inicio>`):** `cb2e6a9` (padre `2238930`)
- **Privacidad:** este log no lleva RBD con número ni nombres de establecimiento.

## J. Juicio (lo rellena FASE L)

1. **Meta y resultado:** contraste figura-fondo completo del motor según la opción A más P11; resultado: 0 fallas de texto y 0 gráficas exigidas en controles activos en los 19 estados (antes 2.103 y 8 familias).
2. **Estado por tarea:** T1, T2, T3, T4 y T5 completadas; FASE R sin bloqueo; FASE L completa.
3. **Commits:** `cb2e6a9`, `b567586`, `1ebe2c0`, `2c48837`, `7e256e4` y el de este LOG (`docs(log)`).
4. **Auditoría:** 27 filas; 0 BLOQUEA, 0 REPARA, 2 ADVIERTE (R-16 dos cambios fuera de la letra de §1, declarados; R-27 proceso); control positivo idéntico a M5.
5. **Invariantes:** 🔒1 a 🔒7 PASAN.
6. **Cifras críticas:** SHA del payload con la paleta anterior restituida `0ffd9899…2ad8`; `cat_colors` nuevo `#D0112D`/`#E05D2F`/`#2A8FD9`/`#0062A0`; F1–F4 y spot-check en verde; cabeceras 6,97/4,99/5,00/9,48; motor `9a4e845c…`; `docs/` `45e612f1…`.
7. **Decisiones autónomas de mayor riesgo:** quitar la opacidad del separador como parte de P1; escribir el blanco de la ✕ como `var(--paper)`; clasificar `.cmp-table-wrap` y `.cmp-empty` como decorativos (a `--line-strong`).
8. **Desviaciones:** ninguna de entorno (renv activo); los dos cambios de R-16.
9. **Dudas abiertas:** Q-DEPLOY y Q-SEP (pregunta cerrada en FASE L).
10. **Errores propios:** 3 (comentario con hex viejos; `#fff` en una línea tocada; instrumentos), todos corregidos antes de commitear o registrar.
11. **Qué debe verificar el revisor:** las cabeceras en básica y media frente a la maqueta; Medio-Bajo y "sin categoría" en las trayectorias; el % máximo con marco en el comparador de 10; los segmentados activos en azul; las casillas del modal múltiple.
12. **No publicado / queda al usuario:** despliegue a `docs/` (Q-DEPLOY); los hex viejos en documentos históricos no se tocaron por diseño.
13. **Ejecución:** Opus 5.5, una sesión, 0 subagentes, Babel 8.0.6 copiado a `/tmp/cat_a3_babel`, Puppeteer con Chrome del sistema, `renv` activo, instrumento §7 tal cual en `/tmp/cat_a3_contraste.js`.

## Esqueleto

- FASE 0 — M1, M2, M3, M-DERIVA, M5, M6
- T1 — CSS (P1, P2, P3, P6, P8, P9, P10)
- T2 — paleta (P4, P5, P7)
- T3 — cabeceras (P11)
- T4 — documentos
- T5 — build final y auditoría completa
- FASE R — auditoría propia
- FASE L — cierre

### FASE 0

#### M1 — porcelain tras el primer commit; stash; archivos del primer commit

esperado: el parquet preexistente y el LOG; stash vacío; primer commit = encargo, auditoría y PNG
obtenido:
```
?? 40_salidas/categoria_rbd_contrato.parquet
?? 50_documentacion/andamios/logs/20260925_contraste_a3_log.md
stash: []
cb2e6a9 chore(encargo): contraste del motor a3

50_documentacion/activa/encargos/encargo_claude_code_categoria_contraste_a3.md
50_documentacion/andamios/20260925_auditoria_contraste_motor.md
50_documentacion/andamios/20260925_cabeceras_variante.png
```

#### M2 — fetch; HEAD~1; HEAD..origin/main; origin/main..HEAD

esperado: `HEAD~1` = `2238930` = `origin/main`; 0; 1
obtenido:
```
HEAD~1=2238930 origin/main=2238930 HEAD..origin/main=0 origin/main..HEAD=1
```

#### M3 — md5 de §2; SHA del payload (instrumento recalibrado); PRUEBAS d

Instrumento nuevo `/tmp/cat_a3_payload.js`: normaliza `fecha_generacion` **y restituye** `meta.cat_colors.INSUFICIENTE` = `#EE2D49` y `meta.cat_colors["MEDIO-BAJO"]` = `#E88663` antes del SHA; imprime además el `cat_colors` real. Instrumentos auxiliares copiados de `/tmp/cat_a2_*` a `/tmp/cat_a3_*` (rutas reescritas); Babel copiado de `/tmp/cat_a2_babel` (8.0.6 / 8.0.6 / 8.0.1).

esperado: motor `91570b62…`; docs `45e612f1…`; SHA `0ffd9899…2ad8`; fecha alterada → igual; cifra plantada → distinto; `cat_colors` alterado a la paleta nueva → igual tras restituir; PRUEBAS d en verde (renv activo)
obtenido:
```
md5 motor 91570b620f1de44ea84ca7c7ae33f8bc | docs 45e612f1c9909a2dd1115d9e8628cde0 | template 46e0a69b1ecc165a5b8453ba699f0d82 | 33_app.jsx 872535a06bd493e0f05f546aaf4760a1 | 33_generar_html.R d227fa8e81e9354dea6ca1c427aaeda8
[normal]           0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8 {"INSUFICIENTE":"#EE2D49","MEDIO-BAJO":"#E88663","MEDIO":"#2A8FD9","ALTO":"#0062A0"}
[fecha alterada]   0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8
[cifra plantada]   d593e1b34e99a9e55aad24e05a307a5e97d76a36c2f6d11c948bfc2f6bd435cc
[colores nuevos]   0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8 {"INSUFICIENTE":"#D0112D","MEDIO-BAJO":"#E05D2F","MEDIO":"#2A8FD9","ALTO":"#0062A0"}
docs:              0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8
auditar_cifras.R exit=0, F1–F4 OK (0 discrepancias); spot_check_publicado.R exit=0, 6 + 1 OK
```

#### M-DERIVA — bloque del template vs retranspilación de `33_app.jsx`

esperado: cadena idéntica
obtenido:
```
template 77a94648b269fde3707b5d67dbaa144d 1597 líneas | retrans 77a94648b269fde3707b5d67dbaa144d 1597 líneas | distintas: 0
```

#### M5 — contraste de línea base (instrumento §7, 19 estados, motor `91570b62…`)

Instrumento: `/tmp/cat_a3_contraste.js` = la función de §7 copiada tal cual (diff con el bloque del encargo: solo el salto de línea final); recorrido `/tmp/cat_a3_m5.js` (1280 × 900, transiciones y animaciones desactivadas por el arnés antes de medir, cursor en (1,1) salvo en S02b, S06b y S15b); auxiliar paralelo que replica el orden de recorrido del instrumento para marcar deshabilitados, exigidos (§7), `is-max`, "sin categoría" y cabecera (se verifica que las longitudes coinciden en cada estado); resumen `/tmp/cat_a3_resumen.js`.

esperado: los valores de la auditoría §2 a §4: 19 pares de texto fallidos en controles activos, 2.103 mediciones fallidas de 13.725, 4 pares en deshabilitados; 8 familias gráficas exigidas fallidas (G1 a G5); T1 4,34; T2 3,87; T3 3,60; T4 1,95; T5 2,67; T6 4,44; T7 4,46; T8 3,97; T9 4,11; T10 2,07 a 3,51; G1 2,62; G2 1,87; G3 1,87; G4 1,81; G5 1,21; G6 1,28 a 1,87
obtenido:
```
texto: 13725 mediciones; fallas activas 2103; pares fallidos activos 19; pares fallidos en deshabilitados 4
gráficos exigidos: 3009 mediciones, 1715 fallidas, 8 familias: segmented-btn activo 1,21; traj-legend-sw MB 2,62; traj-legend-sw [si] 1,87; traj-mark MB 2,62; traj-mark [si] 1,87; input-search 1,87; check-box 1,81; cmp-cat-dot MB 2,62 (en deshabilitados: 1 par, check-box)
T1 4,34 (n=53) · T2 3,87 (1) · T3 3,60 (10) · T4 1,95 (1893) · T5 2,67 (19) · T6 4,44 (19) · T7 4,46 (91) · T8 3,97 (2) · T9 4,11 (la ✕ con cursor; las otras 4,52) · T10 2,07–3,51 (14)
cabeceras: Insuficiente ink/#EE2D49 4,46 · Medio-Bajo ink/#E88663 7,01 · Medio ink/#2A8FD9 5,27 · Alto blanco 6,45 / 5,72 (op 0,92) / 4,89 (op 0,82)
G1 Medio-Bajo sobre blanco 2,62 (n=1025; en los estados no hay marcas sobre crema) · Insuficiente 3,97–4,11 · Medio 3,48
G2 1,87 (borde, n=300) · G3 1,87 · G4 1,81 (marcada 4,97) · G5 1,21 (texto 12,58) · G6 botón de territorio 1,87, Notas 1,74, Limpiar 1,74, Cancelar 1,28
errores de consola/pageerror: 0
```
Reproduce la auditoría en T1, T7, T10, G1 y G3 (y en el resto).

#### M6 — línea base de capturas y `textContent` (19 estados, 1280 × 900, dos corridas)

esperado: 19/19 texto igual entre corridas
obtenido:
```
/tmp/cat_a3_base y /tmp/cat_a3_base2: texto 19/19 iguales; capturas 19/19 AE=0; errores 0 en las dos corridas
```

**Cierre FASE 0:** sin reglas de detención activas.

### T1 — CSS (P1, P2, P3, P6, P8, P9, P10)

#### Clasificación de los 20 usos de `var(--border-2)` (antes de editar)

Evidencia: `bash /tmp/cat_a3_clases.sh <clase>` = apariciones de la clase como palabra completa dentro de `className` en `33_app.jsx` (0 = CSS muerto heredado, pendiente #2 del traspaso v29).

| # | Línea del template | Selector | Apariciones en `33_app.jsx` | Clase | Acción |
|---|---|---|---|---|---|
| 1 | 244 | `.select, .input` | 0 / 0 | muerto | no se toca |
| 2 | 315 | `.entity-chip` | 0 | muerto | no se toca |
| 3 | 366 | `.btn-ghost` | 0 | muerto | no se toca |
| 4 | 393 | `.empty-board` | 0 | muerto | no se toca |
| 5 | 420 | `.icon-export` | 0 | muerto | no se toca |
| 6 | 542 | `.tooltip` | 0 | muerto | no se toca |
| 7 | 603 | `.tt-estab-link` | 0 | muerto | no se toca |
| 8 | 648 | `.data-table thead th` | 0 | muerto | no se toca |
| 9 | 712 | `.data-table tbody tr.row-ent-start td` | 0 | muerto | no se toca |
| 10 | 722 | `.td-empty` | 0 | muerto | no se toca |
| 11 | 785 | `.notes-toggle` | 1 (botón) | control vivo | queda `--border-2` |
| 12 | 926 | `.check-box` | 1 (casilla) | control vivo | queda `--border-2` |
| 13 | 971 | `.estab-popup` (no `.estab-popup-btn`) | 0 | muerto | no se toca |
| 14 | 1007 | `.gse-filter select` | 0 | muerto | no se toca |
| 15 | 1268 | `.entity-select-btn` | 1 (botón) | control vivo | queda `--border-2` |
| 16 | 1290 | `.filter-chip` | 3 (botón) | control vivo | queda `--border-2` |
| 17 | 1341 | `.cmp-clear-btn` | 1 (botón) | control vivo | queda `--border-2` |
| 18 | 1352 | `.cmp-table-wrap` | 1 (contenedor de la tabla) | decorativo vivo | pasa a `var(--line-strong)` |
| 19 | 1439 | `.cmp-empty` | 1 (caja punteada del comparador vacío) | decorativo vivo | pasa a `var(--line-strong)` |
| 20 | `33_app.jsx` (en línea; en el template, dentro del bloque transpilado) | `input.input-search` | 1 (campo) | control vivo | queda `--border-2` |

Además, las tres reglas de "sin categoría" (`.traj-mark.is-si`, `.traj-legend-sw.is-si`, `.ee-detail-mark[data-si="1"]`) pasan de `var(--line-strong)` a `var(--border-2)`, y `.estab-popup-btn` pasa de `var(--border-1)` a `var(--border-2)` (P10).

**Lectura de P1 respecto de T4 (registrada):** el separador "·" de las tarjetas (`.ee-row-sep`) es `--fg-3` con `opacity: 0.5`. La auditoría (§3, T4: "`--fg-3` sin opacidad" → 6,48; §5, P1: "T1 a T4") incluye quitar esa opacidad dentro de P1, y el esperado de T1 del encargo (6,48) solo se alcanza así. Se implementa como parte de P1 (sin hex nuevo).

Implementación: P1 (`--fg-3: #5E5E5E` y `.ee-row-sep` sin opacidad), P2 (`--border-2: #8A7F68`; usos 18 y 19 a `--line-strong`; las tres reglas de "sin categoría" a `--border-2`), P3 (`--fg-on-dark-muted: #A9B7BB` en `:root`; `.brand-eyebrow-muted` y `.brand-divider` con ese color y `opacity: 1`), P6 (sin `opacity` en `.cat-col-stat` y `.cat-col-mat`), P8 (reglas de §1 tal cual), P9 (reglas de §1 tal cual, agregadas tras la regla existente de `.segmented-btn.is-active`), P10 (`.estab-popup-btn` con `--border-2`). Solo CSS; el bloque de la app no cambia.

esperado: T1 6,02; T2 5,36; T3 4,99; T4 6,48; T5 5,74; T6 5,74; T10 ≥ 4,5 (la auditoría da 5,47 a 8,38 con la paleta nueva, que llega en T2); G2 3,95; G3 3,95; G4 3,82; G5 5,34; G6 3,67 a 3,95; PRUEBAS c `0ffd9899…2ad8` con `cat_colors` sin cambio; 🔒3 solo hex de la lista; 🔒6 cadena idéntica; 🔒7 19/19 texto igual; 0 errores
obtenido:
```
PRUEBAS a [t1]: exit=0; warnings=0 | motor aabfe3e101c655e4a2c5028df7487923 | PRUEBAS c 0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8 {"INSUFICIENTE":"#EE2D49","MEDIO-BAJO":"#E88663","MEDIO":"#2A8FD9","ALTO":"#0062A0"} | docs restaurado 45e612f1c9909a2dd1115d9e8628cde0
texto: fallas activas 2103 → 94; pares fallidos 19 → 6 (los de T2 y T3: cabecera Insuficiente ×4, delta negativo, ✕ del chip)
T1 4,34 → 6,02 · T2 3,87 → 5,36 · T3 3,60 → 4,99 · T4 1,95 → 6,48 · T5 2,67 → 5,74 · T6 4,44 → 5,74 · T10 2,07–3,51 → 5,90–9,97 (texto del mapa de calor: 14 → 0 fallas)
cabecera Alto sin opacidad: 6,45 / 6,45 / 6,45 (antes 6,45 / 5,72 / 4,89)
G2 1,87 → 3,95 · G3 1,87 → 3,95 · G4 1,81 → 3,82 · G5 1,21 → 5,34 (texto 6,45) · G6 botón de territorio 3,95, Notas 3,67, Limpiar 3,67, Cancelar 3,82
familias gráficas exigidas fallidas: 8 → 3 (solo Medio-Bajo 2,62: traj-mark, traj-legend-sw, cmp-cat-dot; se resuelven en T2)
🔒3 hex en líneas agregadas: [#5E5E5E #8A7F68 #A9B7BB] fuera de la lista: []; :root cambia/agrega: --fg-3, --fg-on-dark-muted, --border-2
🔒6 template 77a94648b269fde3707b5d67dbaa144d = retrans (distintas: 0)
🔒7 textContent igual a la base: 19/19; errores 0
```
Commit: `b567586`.

### T2 — Paleta (P4, P5, P7)

Implementación: `33_generar_html.R`, bloque `CAT_COLORS`: `#D0112D` y `#E05D2F`, con el comentario que cita la recalibración y la decisión nueva; template: `--cat-insuf: #D0112D;` en `:root` y los dos respaldos `var(--cat-insuf, #D0112D)`.

**Dos correcciones propias antes del commit (registradas):** (1) la primera redacción del comentario del generador repetía los hex viejos ("antes mark-red #EE2D49") en líneas agregadas, que 🔒3 habría contado fuera de la lista; se dejaron solo los nombres de los tokens. (2) La línea de `.cmp-chip-x:hover`, que P4 obliga a tocar por su respaldo, lleva `color: #fff` preexistente: al quedar como línea agregada, 🔒3 lo contaba (`#FFF` fuera de la lista, build t2). Se escribió ese mismo blanco como `var(--paper)` (`--paper: #FFFFFF`), sin cambio de color ni de criterio (build t2b; toda la medición de abajo es de t2b).

esperado: G1 Insuficiente 5,53 y Medio-Bajo 3,64 sobre blanco (3,38 sobre crema); T8 5,34; T9 5,53; texto del mapa de calor sin fallas; PRUEBAS c `0ffd9899…2ad8` y `cat_colors` = {"INSUFICIENTE":"#D0112D","MEDIO-BAJO":"#E05D2F","MEDIO":"#2A8FD9","ALTO":"#0062A0"}; PRUEBAS d en verde; 🔒3 solo hex de la lista; 🔒4 generador solo en el bloque `CAT_COLORS`; 🔒7 19/19
obtenido:
```
PRUEBAS a [t2b]: exit=0; warnings=0 | motor 80a6367c7934bb0c1f78d98da6082823
PRUEBAS c: 0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8 {"INSUFICIENTE":"#D0112D","MEDIO-BAJO":"#E05D2F","MEDIO":"#2A8FD9","ALTO":"#0062A0"}
PRUEBAS d: auditar exit=0, F1–F4 OK (0 discrepancias); spot exit=0, 6 + 1 OK; docs restaurado 45e612f1c9909a2dd1115d9e8628cde0
G1 Medio-Bajo 2,62 → 3,64 sobre blanco (n=1025; sin marcas sobre crema en los 19 estados; por fórmula: 3,38 sobre crema) · Insuficiente 3,97–4,11 → 5,34–5,53 · Medio 3,48 (sin cambio)
T8 3,97 → 5,34 · T9 4,11 → 5,53 · T10 5,49–8,39 (mapa de calor con la paleta nueva; fallas de texto 0)
familias gráficas exigidas fallidas: 3 → 0 (1 par en deshabilitados, exento)
transitorio: la cabecera de Insuficiente, aún con --ink de a2, baja a 3,32 sobre el rojo nuevo (4 pares); la corrige T3 (P11)
🔒3 hex en líneas agregadas: [#5E5E5E #8A7F68 #A9B7BB #D0112D #E05D2F] fuera de la lista: [] (build t2: [#FFF] fuera, corregido en t2b)
🔒3 :root cambia/agrega: --fg-3, --fg-on-dark-muted, --cat-insuf, --border-2
🔒4 pipeline 0 líneas; 33_generar_html.R: hunks @@ -60,2 +60,3 @@ (comentario del bloque) y @@ -63,2 +64,2 @@ (dos entradas de CAT_COLORS)
🔒6 cadena idéntica (distintas: 0) · 🔒7 textContent 19/19 igual; errores 0
```
Commit: `1ebe2c0`.

### T3 — Cabeceras (P11)

Implementación: `33_app.jsx`, `CatColumn`: el fondo de `.cat-col-head` sale del mapa `CAT_CABECERA_FONDO` (categoría → `var(--cat-*-cab)`); se retiran `CAT_CABECERA_TINTA`, la clase `is-tinta` y la constante local `color` (solo alimentaba ese fondo). Template: `--cat-insuf-cab`, `--cat-mbajo-cab`, `--cat-medio-cab`, `--cat-alto-cab` en `:root` y retiro de las dos reglas `.cat-col-head.is-tinta` (con su comentario). Retranspilación completa y reemplazo del bloque entero.

esperado: texto blanco en las cuatro cabeceras (título, conteo, matrícula) con 6,97 / 4,99 / 5,00 / 9,48 en básica y en media; `grep -c "is-tinta\|CAT_CABECERA_TINTA"` = 0 en `33_app.jsx` y en el template; captura de la región leyenda + cabeceras con la misma disposición y colores que la maqueta; PRUEBAS c y d; 🔒3; 🔒6 cadena idéntica; 🔒7 19/19; 0 fallas de texto activas y 0 gráficas exigidas en los 19 estados
obtenido:
```
/tmp/cat_a3_reemplazar.sh: template d1419c39dcb5e2f3fd7af098ad634832 1602 | retrans d1419c39dcb5e2f3fd7af098ad634832 1602 | distintas: 0
grep is-tinta|CAT_CABECERA_TINTA: 33_app.jsx 0; template 0
PRUEBAS a [t3]: exit=0; warnings=0 | motor 9a4e845c41a803ac40fb299c77b54511 | PRUEBAS c 0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8 {"INSUFICIENTE":"#D0112D","MEDIO-BAJO":"#E05D2F","MEDIO":"#2A8FD9","ALTO":"#0062A0"}
PRUEBAS d: F1–F4 OK; spot 6 + 1 OK; docs restaurado 45e612f1c9909a2dd1115d9e8628cde0
cabeceras S01 (básica) y S05 (media), título / conteo (strong y stat) / matrícula: Insuficiente #FFFFFF/#B30F27 6,97 · Medio-Bajo #FFFFFF/#C1481D 4,99 · Medio #FFFFFF/#2074B2 5,00 · Alto #FFFFFF/#004976 9,48 (idénticos en las cuatro líneas y en los dos niveles)
T7 4,46 (a2) → 3,32 (transitorio de T2) → 6,97
19 estados: texto fallas activas 0 de 13.725; pares 0; gráficos exigidos fallidos 0 de 3.009; quedan 4 pares de texto y 1 gráfico en deshabilitados (exentos)
captura /tmp/cat_a3_cab_t3.png (y _media) vs 20260925_cabeceras_variante.png (panel "VARIANTE"): misma leyenda, mismos cuatro rellenos oscuros con texto blanco en título, conteo y matrícula, misma disposición
🔒3 hex en líneas agregadas: [#004976 #2074B2 #5E5E5E #8A7F68 #A9B7BB #B30F27 #C1481D #D0112D #E05D2F] fuera de la lista: []; :root: --fg-3, --fg-on-dark-muted, --cat-insuf, --cat-insuf-cab, --cat-mbajo-cab, --cat-medio-cab, --cat-alto-cab, --border-2
🔒6 cadena idéntica · 🔒7 textContent 19/19 igual; errores 0
```
Commit: `2c48837`.

### T4 — Documentos

Decisión nueva `20260925_decision_paleta_categorias_v2.md` (formato del directorio: contexto con los valores de la auditoría, decisión con la tabla de marca y cabecera por categoría y las variables de texto y borde, qué reemplaza, qué conserva, alternativas, implicancia). En las dos decisiones anteriores cambia solo la línea `**Estado:**` (línea 6). Auditoría: se anexa `## 9. Implementación (a3)`.

esperado: `git diff --numstat` de cada decisión anterior = 1 agregada y 1 quitada; auditoría con 0 líneas quitadas; privacidad 0/0/0 en la decisión nueva y en la auditoría
obtenido:
```
1	1	50_documentacion/activa/decisiones/20260612_decision_paleta_categorias.md
1	1	50_documentacion/activa/decisiones/20260925_decision_contraste_texto_categorias.md
31	0	50_documentacion/andamios/20260925_auditoria_contraste_motor.md
/tmp/cat_a3_priv.sh: decisión v2 RUT 0 | RBD+n 0 | nombre EE 0 ; auditoría RUT 0 | RBD+n 0 | nombre EE 0
```
Commit: `7e256e4`.

### T5 — Build final y auditoría completa

esperado: PRUEBAS a exit 0 y 0 warnings; PRUEBAS c `0ffd9899…2ad8` y `cat_colors` nuevo; PRUEBAS d en verde con `docs/` del build nuevo; `docs/` restaurado a `45e612f1…`; en los 19 estados, 0 pares de texto fallidos y 0 fallas no textuales exigidas en controles activos; solo quedan las 4 fallas de controles deshabilitados de la auditoría; 🔒3, 🔒6, 🔒7
obtenido:
```
PRUEBAS a [t5]: exit=0; warnings=0 | motor nuevo 40_salidas/motor_categoria.html 9a4e845c41a803ac40fb299c77b54511 (igual al build t3: mismas fuentes y fecha)
PRUEBAS c: 0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8 {"INSUFICIENTE":"#D0112D","MEDIO-BAJO":"#E05D2F","MEDIO":"#2A8FD9","ALTO":"#0062A0"}
PRUEBAS d: auditar exit=0, F1–F4 OK (0 discrepancias); spot exit=0, 6 + 1 OK; docs restaurado 45e612f1c9909a2dd1115d9e8628cde0
19 estados (errores 0): texto 13.725 mediciones, 0 fallas activas, 0 pares; gráficos exigidos 3.009, 0 fallidos
fallas restantes, todas en deshabilitados: texto "Agregar" del modal sin selección 1,94; nombre y secundario de filas bloqueadas 2,96 y 2,00; "+ Agregar" al tope 1,96 (4 pares, los de la auditoría §2); gráfico: casilla de fila bloqueada 1,69 (exenta)
T1 6,02 · T2 5,36 · T3 4,99 · T4 6,48 · T5 5,74 · T6 5,74 · T7 6,97 · T8 5,34 · T9 5,53 · T10 5,49–8,39 · G1 3,64 · G2 3,95 · G3 3,95 · G4 3,82 · G5 5,34 · G6 3,67–3,95
cabeceras: 6,97 / 4,99 / 5,00 / 9,48
🔒3 [#004976 #2074B2 #5E5E5E #8A7F68 #A9B7BB #B30F27 #C1481D #D0112D #E05D2F] fuera: []; 🔒6 cadena idéntica; 🔒7 19/19
gate: /tmp/cat_a3_gate/ con S01, S03, S05, S06, S14, S15 antes y después y las cabeceras en básica y media (14 PNG)
```

### FASE R — Auditoría propia y reparación

#### R.1 Inventario (anexado antes de auditar)

| id | afirmación | origen |
|---|---|---|
| R-01 | M1/M2 punto de partida | FASE 0 |
| R-02 | M3 instrumento de payload calibrado (fecha, cifra, paleta) | FASE 0 |
| R-03 | M-DERIVA cadena idéntica | FASE 0 |
| R-04 | M5 reproduce la auditoría; M6 determinista | FASE 0 |
| R-05 | P1 `--fg-3` y separador sin opacidad: T1 a T4 | T1 |
| R-06 | P2 `--border-2` y clasificación de 20 usos: G2, G3, G4, G6 | T1 |
| R-07 | P3 tinta clara del encabezado: T5, T6 | T1 |
| R-08 | P6 sin opacidad en las cabeceras | T1 |
| R-09 | P8 % máximo: T10 | T1 |
| R-10 | P9 segmentado activo: G5 | T1 |
| R-11 | P10 botón "Cancelar" | T1 |
| R-12 | P4/P5 paleta: G1 | T2 |
| R-13 | P7 delta y ✕ del chip: T8, T9 | T2 |
| R-14 | P11 cabeceras: T7 y las cuatro cabeceras | T3 |
| R-15 | T4 documentos (Estado de las decisiones, anexo sin quitar líneas) | T4 |
| R-16 | Lectura del diff: todo hex, opacidad y selector cambiado está en §1 | T1–T3 |
| R-17 | 🔒1 | §3 |
| R-18 | 🔒2 | §3 |
| R-19 | 🔒3 | §3 |
| R-20 | 🔒4 | §3 |
| R-21 | 🔒5 | §3 |
| R-22 | 🔒6 | §3 |
| R-23 | 🔒7 | §3 |
| R-24 | Alcance global | §4 |
| R-25 | Regresión PRUEBAS a–d | §8.5 |
| R-26 | Control positivo sobre el motor del a2 (`91570b62…`) | §8.6 |
| R-27 | Proceso: correcciones antes de commit (comentario con hex viejos; `#fff` → `var(--paper)`); `.ee-row-sep` leído como parte de P1 | propio |

#### R.2–R.6 Re-derivación, lectura del diff, invariantes, alcance, regresión y control positivo

Camino independiente (`/tmp/cat_a3_rR.js`): color computado por `getComputedStyle` del elemento contra el primer fondo opaco de sus ancestros (o del padre, para bordes), con la fórmula WCAG calculada en Node; y muestreo del píxel del relleno en la captura (cabeceras y marca de Medio-Bajo). Primera corrida del muestreo con coordenadas de ventana en vez de documento (salía el mismo píxel en todo: 1,08): corregido antes de registrar.

esperado: la re-derivación reproduce los valores de T5; el diff solo contiene cambios de §1 (y los dos declarados); 🔒1–🔒7 PASAN; alcance = template, `33_app.jsx`, `33_generar_html.R`, decisión nueva, dos líneas `Estado:`, auditoría; PRUEBAS a–d en verde; el motor del a2 muestra las fallas de M5
obtenido:
```
motor nuevo (camino independiente): T1 6,02 · T2 5,36 · T3 4,99 · T4 6,48 · T5 5,74 · T6 5,74 · T8 5,34 · T9 5,53 · T10 5,49, 5,90, 7,99, 8,39 (marco is-max: solid 2px rgb(28,18,18) −2px)
  cabeceras computado (título y matrícula): 6,97 · 4,99 · 5,00 · 9,48; píxel del relleno vs blanco: 6,97 · 4,99 · 5,00 · 9,48
  G1 píxel de la muestra Medio-Bajo (224,93,47) vs blanco 3,64 · G2 borde vs fondo del padre 3,95 · G3 3,95 · G4 3,95 (borde vs relleno blanco de la casilla; el instrumento, contra el fondo de la lista, 3,82) · G5 relleno vs contenedor 5,34, texto 6,45; errores 0
motor del a2 (mismo camino): T1 4,34 · T2 3,87 · T3 3,60 · T8 3,97 · T9 4,11 · T10 2,07–3,51 · G3 1,87 · G4 1,87 · G5 1,21 · cabecera Insuficiente 4,46
lectura del diff (template fuera del bloque, 33_app.jsx, generador): todos los cambios son de §1 (P1 a P11), salvo dos declarados: `.ee-row-sep { opacity: 1; }` (lectura de P1 según la auditoría §3 T4) y `color: var(--paper)` en `.cmp-chip-x:hover` (el mismo blanco, como token); ningún otro hex, opacidad ni selector
🔒1 PRUEBAS c 0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8; cat_colors = {"INSUFICIENTE":"#D0112D","MEDIO-BAJO":"#E05D2F","MEDIO":"#2A8FD9","ALTO":"#0062A0"}; Python: único bloque distinto de primer nivel 'meta', única clave de meta distinta 'cat_colors' (fecha excluida)
🔒2 PRUEBAS d: F1–F4 OK (0 discrepancias); spot 6 + 1 OK
🔒3 hex en líneas agregadas [#004976 #2074B2 #5E5E5E #8A7F68 #A9B7BB #B30F27 #C1481D #D0112D #E05D2F], fuera de la lista []; :root: --fg-3, --fg-on-dark-muted, --cat-insuf, --cat-insuf-cab, --cat-mbajo-cab, --cat-medio-cab, --cat-alto-cab, --border-2
🔒4 pipeline 0 líneas; generador: hunks @@ -60,2 +60,3 @@ y @@ -63,2 +64,2 @@ (comentario y entradas de CAT_COLORS)
🔒5 docs 45e612f1c9909a2dd1115d9e8628cde0; docs en el diff: 0
🔒6 template d1419c39dcb5e2f3fd7af098ad634832 = retrans (distintas: 0)
🔒7 textContent 19/19 igual a la base (T5)
alcance: 30_procesamiento/33_app.jsx, 33_generar_html.R, 33_motor_template.html; decisiones 20260612_decision_paleta_categorias.md, 20260925_decision_contraste_texto_categorias.md, 20260925_decision_paleta_categorias_v2.md; andamios/20260925_auditoria_contraste_motor.md · porcelain: parquet + LOG · stash 0
regresión: PRUEBAS a [R] exit=0, warnings=0, motor 9a4e845c41a803ac40fb299c77b54511; c y d como arriba; docs restaurado 45e612f1…
control positivo (motor del a2, 91570b62…, /tmp/cat_a3_m5.js): 2103 de 13725 fallas de texto, 19 pares, 8 familias gráficas; resumen idéntico al de M5
```

#### R.7 Tabla de auditoría

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | M1/M2 | `git log -1 cb2e6a9^` | `2238930` | `2238930` | — | — | — | — |
| R-02 | M3 calibración | tres plantas | igual/distinto/igual | igual/distinto/igual | — | — | — | — |
| R-03 | M-DERIVA | retranspilación | idéntica | idéntica | — | — | — | — |
| R-04 | M5/M6 | control positivo | reproduce | idéntico | — | — | — | — |
| R-05 | P1 (T1–T4) | computado + WCAG en Node | 6,02 / 5,36 / 4,99 / 6,48 | iguales | PASA | — | `b567586` | — |
| R-06 | P2 (G2–G4, G6) | borde computado vs fondo | ≥ 3 | 3,95 / 3,95 / 3,82–3,95 | PASA | — | `b567586` | — |
| R-07 | P3 (T5, T6) | computado | 5,74 | 5,74 | PASA | — | `b567586` | — |
| R-08 | P6 | opacidad computada de la matrícula de Alto | 1 | 1 (a2: 0,82) | PASA | — | `b567586` | — |
| R-09 | P8 (T10) | texto vs rgba compuesto en Node | ≥ 4,5 | 5,49–8,39 | PASA | — | `b567586` | — |
| R-10 | P9 (G5) | relleno vs contenedor | ≥ 3 | 5,34 | PASA | — | `b567586` | — |
| R-11 | P10 | borde de "Cancelar" (instrumento) | ≥ 3 | 3,82 | PASA | — | `b567586` | — |
| R-12 | P4/P5 (G1) | píxel de la marca | 3,64 | 3,64 | PASA | — | `1ebe2c0` | — |
| R-13 | P7 (T8, T9) | computado | 5,34 / 5,53 | iguales | PASA | — | `1ebe2c0` | — |
| R-14 | P11 | computado y píxel del relleno | 6,97 / 4,99 / 5,00 / 9,48 | iguales | PASA | — | `2c48837` | — |
| R-15 | T4 documentos | `git diff --numstat` | 1/1, 1/1, n/0 | 1/1, 1/1, 31/0 | PASA | — | `7e256e4` | — |
| R-16 | diff solo §1 | lectura del diff | solo §1 | §1 + 2 declarados (opacidad del separador; `var(--paper)` en la ✕) | ADVIERTE | al revisor: son lectura de P1 y cambio de forma de un color existente | — | — |
| R-17 | 🔒1 | PRUEBAS c + Python | igual salvo paleta | igual salvo paleta | PASA | — | — | — |
| R-18 | 🔒2 | PRUEBAS d | verde | verde | PASA | — | — | — |
| R-19 | 🔒3 | diff -U0 + `:root` | ⊆ lista | ⊆ lista | PASA | — | — | — |
| R-20 | 🔒4 | diff | 0; solo CAT_COLORS | 0; solo CAT_COLORS | PASA | — | — | — |
| R-21 | 🔒5 | md5 + diff | `45e612f1…`; 0 | igual; 0 | PASA | — | — | — |
| R-22 | 🔒6 | retranspilación | cadena idéntica | idéntica | PASA | — | — | — |
| R-23 | 🔒7 | textContent 19 estados | 19/19 | 19/19 | PASA | — | — | — |
| R-24 | alcance | `git diff --name-only` | rutas de §4 | rutas de §4 | PASA | — | — | — |
| R-25 | regresión | PRUEBAS a–d | verde | verde | PASA | — | — | — |
| R-26 | control positivo | instrumento en el motor del a2 | fallas de M5 | idénticas | PASA | — | — | — |
| R-27 | proceso | revisión propia | — | dos correcciones antes del commit de T2 (comentario con hex viejos; `#fff` → `var(--paper)`); transitorio de 3,32 en la cabecera de Insuficiente entre T2 y T3 (nunca publicado, corregido en T3) | ADVIERTE | declarado | — | — |

**Ciclos de reparación:** 0. **Veredicto FASE R: SIN BLOQUEO** (0 BLOQUEA, 0 REPARA, 2 ADVIERTE; control positivo presente).

### FASE L — Cierre

#### Resumen

Se implementó la opción A de la auditoría de contraste más la variante P11. T1 cambió solo CSS (gris de texto, borde de controles, tinta clara del encabezado, cabeceras sin opacidad, % máximo con tinta y marco, segmentado activo en azul, borde de "Cancelar"). T2 recalibró Insuficiente y Medio-Bajo en `CAT_COLORS` y en `--cat-insuf`. T3 dio a las cuatro cabeceras un tono oscuro propio con texto blanco, desde `33_app.jsx` y retranspilación completa. T4 escribió la decisión de paleta v2, marcó como reemplazadas las dos decisiones anteriores (solo su línea `Estado:`) y anexó la §9 a la auditoría. En los 19 estados quedan 0 fallas de texto y 0 gráficas exigidas en controles activos; el payload cambió solo en `meta.cat_colors`; las pruebas del dato siguen en verde; ningún texto visible cambió; `docs/` quedó restaurado.

#### Commits

`cb2e6a9` encargo · `b567586` T1 · `1ebe2c0` T2 · `2c48837` T3 · `7e256e4` T4 · (este) `docs(log)`.

#### Tabla por falla (antes → después)

T1 4,34 → 6,02 · T2 3,87 → 5,36 · T3 3,60 → 4,99 · T4 1,95 → 6,48 · T5 2,67 → 5,74 · T6 4,44 → 5,74 · T7 4,46 → 6,97 · T8 3,97 → 5,34 · T9 4,11 → 5,53 · T10 2,07–3,51 → 5,49–8,39 · G1 2,62 → 3,64 · G2 1,87 → 3,95 · G3 1,87 → 3,95 · G4 1,81 → 3,82 · G5 1,21 → 5,34 · G6 1,28–1,87 → 3,67–3,95. Cabeceras: 6,97 / 4,99 / 5,00 / 9,48. Global: 2.103 → 0 mediciones fallidas de texto (19 → 0 pares); 8 → 0 familias gráficas.

#### Auditoría

Ver R.7 (27 filas; 0 BLOQUEA, 0 REPARA, 2 ADVIERTE: R-16, R-27).

#### Invariantes

🔒1 a 🔒7 PASAN.

#### md5 del motor nuevo

`40_salidas/motor_categoria.html`: `9a4e845c41a803ac40fb299c77b54511` (builds t3, t5 y R idénticos). `docs/index.html`: `45e612f1c9909a2dd1115d9e8628cde0` (restaurado; no se despliega).

#### Dudas con pregunta cerrada

- **Q-DEPLOY:** ¿Se despliega el motor nuevo (a2 + a3) a `docs/index.html` tras la revisión en pantalla? Sí / No.
- **Q-SEP:** ¿Se acepta que quitar la opacidad del separador "·" (`.ee-row-sep`) forme parte de P1, como lo lee la auditoría (§3 T4)? Sí / No (si No: se revierte esa línea y T4 vuelve a fallar).

#### Errores propios

1. Comentario del generador, primera redacción, con los hex viejos en líneas agregadas (lo habría contado 🔒3); corregido antes de construir.
2. `color: #fff` preexistente en la línea de la ✕ que P4 obligaba a tocar: 🔒3 lo contó en el build t2; se escribió como `var(--paper)` (build t2b) antes del commit.
3. Instrumentos: primer script de 🔒3 con un `case` que bash 3.2 no acepta dentro de `$(...)`; muestreo de píxeles con coordenadas de ventana (1,08 en todo); captura de cabeceras con recorte mal ubicado. Todos corregidos antes de registrar cifras.

#### Privacidad

`/tmp/cat_a3_priv.sh` (RUT con DV, la sigla del rol seguida de número, nombres típicos de establecimiento). Control: una copia del LOG con tres plantas ficticias da RUT 1, RBD+n 1, nombre EE 1 (detecta). LOG, decisión nueva y auditoría: 0 / 0 / 0.

#### Estado de cierre

T1, T2, T3, T4 y T5 COMPLETADAS · FASE R SIN BLOQUEO · `docs/index.html` restaurado · push según autorización tras este commit · sin shells en segundo plano.
