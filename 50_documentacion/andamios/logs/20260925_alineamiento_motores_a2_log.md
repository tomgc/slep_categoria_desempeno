# Log — Alineamiento de motores a2: sincronizar la fuente JSX e implementar el plan

- **Fecha:** 2026-09-25
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_categoria_alineamiento_motores_a2.md`
- **Proyecto:** `slep_categoria_desempeno`
- **Ejecutor:** Claude Code (Opus 5.5, sesión única, sin subagentes)
- **Punto de retorno (`<inicio>`):** `cc0bced` (padre `51447ce`)
- **Privacidad:** este log no lleva RBD con número ni nombres de establecimiento.

## J. Juicio (lo rellena FASE L)

1. **Meta y resultado:** sincronizar la fuente JSX e implementar el plan de alineamiento con las resoluciones del titular; resultado: 14 ítems implementados y verificados, motor nuevo sin cambio de payload ni de cifras.
2. **Estado por tarea:** T0, T1 (4 grupos), T2, T3 y T4 completadas; FASE R sin bloqueo; FASE L completa.
3. **Commits:** `cc0bced`, `b19d0f0`, `f46ed48`, `a222203`, `c94971f`, `26ca8cd`, `3848cfc`, `5d56109` y el de este LOG (`docs(log)`).
4. **Auditoría:** 34 filas; 0 BLOQUEA, 0 REPARA, 2 ADVIERTE (R-23 alineación del secundario a la derecha al gate; R-34 proceso); 0 ciclos; control positivo presente.
5. **Invariantes:** 🔒1 a 🔒7 PASAN (🔒6 con cadena idéntica desde T1).
6. **Cifras críticas:** SHA payload `0ffd9899…2ad8` en 7 builds; F1–F4 y spot-check en verde; motor nuevo `91570b62…`; `docs/` `45e612f1…`; cabeceras 4,46 / 7,01 / 5,27; anillos ≥ 5,34; desborde a 320 px 539 → 0.
7. **Decisiones autónomas de mayor riesgo:** ampliar F01 al verbo "No entra/No entran"; mantener `inline-block` en la píldora del nombre (F14); respaldo del foco al quitar un chip (✕ siguiente o "+ Agregar").
8. **Desviaciones:** ninguna de entorno (renv activo); descarga de prettier por `npx` fuera de autorización (sin uso); sección del grupo 1 anexada tras su commit.
9. **Dudas abiertas:** Q-D22, Q-DEPLOY, Q-NPX (pregunta cerrada en FASE L).
10. **Errores propios:** 4 (orden del LOG del grupo 1; `npx prettier`; instrumentos que fallaron y se corrigieron antes de registrar; F01 sin el verbo en su primera versión).
11. **Qué debe verificar el revisor:** los dos modales solo con teclado, la ✕ y Escape; la alineación a la derecha del secundario del modal; las cabeceras con `--ink` y la excepción de Insuficiente; el rótulo nuevo del comparador; la frase 1 con un EE.
12. **No publicado / queda al usuario:** despliegue del motor nuevo a `docs/` (Q-DEPLOY) tras la revisión en pantalla; borrar la caché de prettier (Q-NPX).
13. **Ejecución:** Opus 5.5, una sesión, 0 subagentes, Babel 8.0.6 copiado a `/tmp/cat_a2_babel`, Puppeteer con Chrome del sistema, `renv` activo, instrumentos en `/tmp/cat_a2_*`.

## Esqueleto

- FASE 0 — M0, M1–M6, M-NIV, M-DECL
- T0 — sincronizar la fuente
- T1 — las 10 fichas (modal y foco; ancho; textos; anillo)
- T2 — resoluciones del titular (F11-B, F09-B, D-03 frase 1)
- T3 — documentos
- T4 — build y verificación
- FASE R — auditoría
- FASE L — cierre

### FASE 0

#### M0 — renv activo: `library(dplyr); library(arrow)`

esperado: exit 0
obtenido:
```
- The project is out-of-sync -- use `renv::status()` for details.
Adjuntando el paquete: ‘dplyr’
The following objects are masked from ‘package:stats’:
    filter, lag
The following objects are masked from ‘package:base’:
    intersect, setdiff, setequal, union
Adjuntando el paquete: ‘arrow’
The following object is masked from ‘package:utils’:
exit=0
```

#### M1 — porcelain tras el primer commit; stash; archivos del primer commit

esperado: `?? 40_salidas/categoria_rbd_contrato.parquet` y el LOG; stash vacío; primer commit = solo el encargo a2
obtenido:
```
?? 40_salidas/categoria_rbd_contrato.parquet
?? 50_documentacion/andamios/logs/20260925_alineamiento_motores_a2_log.md
stash: []
cc0bced chore(encargo): alineamiento de motores a2

50_documentacion/activa/encargos/encargo_claude_code_categoria_alineamiento_motores_a2.md
```

#### M2 — fetch; HEAD~1; HEAD..origin/main; origin/main..HEAD

esperado: `HEAD~1` = `51447ce` = `origin/main`; 0; 1
obtenido:
```
HEAD~1=51447ce origin/main=51447ce HEAD..origin/main=0 origin/main..HEAD=1
```

M0: `renv` quedó restaurado por el titular: todas las corridas R de a2 usan `renv` activo (sin `RENV_ACTIVATE_PROJECT=FALSE`).

#### M3 — md5 de §2; SHA del payload normalizado (instrumento recalibrado); PRUEBAS d

esperado: plantilla `9e9640ca…`; `33_app.jsx` `428448d6…`; `docs/` `45e612f1…`; motor `8785476d…`; SHA `0ffd9899…2ad8` en `docs/` y en el motor; fecha alterada → igual; cifra plantada → distinto; F1–F4 OK y spot-check OK (con `renv` activo)
obtenido:
```
Instrumentos copiados de /tmp/cat_a1_* a /tmp/cat_a2_* (rutas internas reescritas; 0 referencias a cat_a1 tras la copia); Babel copiado de /tmp/cat_a1_babel (8.0.6 / 8.0.6 / 8.0.1, config runtime classic)
md5: plantilla 9e9640ca05205d345e713b489ee3e98d | 33_app.jsx 428448d63765d5be7a9558bd3c62e926 | docs 45e612f1c9909a2dd1115d9e8628cde0 | motor 8785476deeff0bc759934a1b9711e118
payload docs:           0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8
payload docs fecha alt: 0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8
payload docs cifra pl.: d593e1b34e99a9e55aad24e05a307a5e97d76a36c2f6d11c948bfc2f6bd435cc
payload motor 40_:      0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8
auditar_cifras.R exit=0, F1–F4 OK (0 discrepancias); spot_check_publicado.R exit=0, 6 presencia + 1 ausencia OK
```

#### M4 — deriva de la fuente antes de T0

esperado: igual al a1: 8 líneas distintas; 1 sustantiva (`--fs-base` vs `--fs-body`)
obtenido:
```
/tmp/cat_a2_retrans.sh: template 000ac7723f2cdd44f8cae3840302f9da 1462 líneas | retrans 6dcac8c01e711fc6a19aea268ab6e036 1462 líneas | distintas: 8
líneas: 472 590 1085 1258 1260 1262 1266 1268; tokens de fuente en el diff: fs-body (template) / fs-base (retrans.), solo en la 590
bloques byte a byte idénticos a los de M4 del a1 (cmp)
```

#### M-NIV — `CatData.NIVELES` y claves de `CAT_COLORS`

esperado: "Educación Básica" / "Educación Media"; claves INSUFICIENTE, MEDIO-BAJO, MEDIO, ALTO
obtenido:
```
NIVELES {"basica":"Educación Básica","media":"Educación Media"}
CAT_COLORS keys ["INSUFICIENTE","MEDIO-BAJO","MEDIO","ALTO"]; anio_vigente 2019
```
Consecuencia: "Educación Básica/Media" es femenino singular → "categorizada" concuerda (T2.3 sin duda).

#### M5 — re-medición de los huecos (instrumento del a1, recalibrado)

Recalibración de la sección D (foco): en el a1 el control "Notas metodológicas" daba `focus_visible:false` (el instrumento enfocaba "el enfocable previo" de una lista propia, que no coincide con el orden de Tab). En a2 se llega a cada control con **Tab real desde el inicio del documento**. Los seis controles que el a1 midió dan los mismos valores con la receta nueva; el séptimo ("Notas") queda medido.

esperado: los valores del a1, M5 (F02 0/345; F08 14 a 1280; F14 539 a 320; F12 1,21 y 1,19; F01 93; F11 4,11/3,67/3,16 · 2,62/2,44/2,23 · 3,48/3,19/2,85 · 6,45/5,72/4,89)
obtenido:
```
F02 filas 345, con tabIndex 0, alcanzadas por Tab 0 (simple) / 0 (múltiple)
F03 Tab sale del modal: sí; role=dialog: no; Escape cierra: no; Cancelar → BODY
F04 tope + Agregar → BODY; elegir EE → BODY; Enter en ✕ de chip → BODY
F05 botones en .modal-header: 0
F07 aviso con 10 marcadas: "Selecciona hasta 10 territorios más · marcados: 10"; marcadas visibles en otra pestaña: 0
F08 1280: 15 partidos / 14 cabrían; 390: 57/37; 320: 59/12, 2 filas desbordadas
F14 narrativa EE más ancho: 539 (320) / 469 (390) / 0 (1280); muestra 40: 18 (320) / 8 (390); resto de pantallas 0
F12 +Agregar 1,21; chip activo 1,19; chip inactivo 5,98; segmented 5,98; Limpiar 5,56; ✕ chip 5,98; Notas 5,56 (medido por primera vez)
F01 "1 establecimientos sin categoría" 93 pares (visible: «1 establecimientos sin categoría en 2019 (conteo oficial)…» en Alhué, básica); "1 matriculados" 281; "1 estudiantes" 0
F11 cabeceras 4,11/3,67/3,16 · 2,62/2,44/2,23 · 3,48/3,19/2,85 · 6,45/5,72/4,89; % máximo 2,07–3,51 (n=4); delta negativo 3,97; ✕ al pasar 4,11
F09 fila del comparador: rótulo "Sin categoría vigente", cursiva (italic); única superficie del comparador con "sin categoría"; SLEP 4≠6 en 29/72
D-03 EE como entidad, con categoría: «El establecimiento «NOMBRE» tiene 1 establecimiento con Educación Básica categorizado al año 2019, el año más reciente…» + «Todos están en nivel de desempeño Insuficiente.»
D-03 EE sin categoría en básica: «El establecimiento «NOMBRE» no tiene establecimientos con Educación Básica categorizados al año 2019 para la selección actual.»
errores de consola/pageerror: 0
```

#### M6 — línea base de 9 pantallas (1280 y 390), con determinismo

esperado: 9 PNG + 9 TXT por ancho; dos corridas 9/9 AE=0 y texto igual; 0 errores
obtenido:
```
/tmp/cat_a2_base/{1280,390} (motor = docs/index.html 45e612f1): errores=0 en las 4 corridas
determinismo 1280: 0 líneas distintas (9/9 AE=0, 9/9 texto igual); 390: 0 líneas distintas
```

#### M-DECL — pantallas y cadenas que T1 y T2 cambian (declarado antes de T1)

Pantallas de M6 (01 apertura, 02 modal simple, 03 modal simple con búsqueda, 04 modal EE, 05 narrativa EE, 06 comparador vacío, 07 modal múltiple, 08 modal múltiple con 10, 09 comparador con 10):

- **Cambian (fuera del 🔒7):** 01 (cabeceras de columna con `--ink`, T2.1); 02, 03, 04, 07, 08 (✕ en el encabezado F05; secundario a la derecha F08; aviso F07 en 07/08); 05 (narrativa EE: F14, D-03, T2.3; cabeceras T2.1); 09 (rótulo de la fila, T2.2). Con 06 el único cambio posible es el anillo de foco (F12), que no se ve sin foco de teclado.
- **Deben quedar idénticas (🔒7):** 06 a 1280 y a 390 (AE=0 y `textContent` igual). Para las demás, `textContent` de `#root` igual salvo las cadenas siguientes.
- **Cadenas de `textContent` que cambian:** "✕" en el encabezado de los dos modales (02, 03, 04, 07, 08); el aviso del modal múltiple (07: "Selecciona hasta 10 territorios más · marcados: 0" no cambia de forma; 08: pasa a "Llegaste al máximo de 10 territorios. Desmarca uno para elegir otro."); en 05, la frase 1, la frase 2 ("Está en nivel de desempeño …") y el caso vacío con EE; en 09, "Sin categoría vigente" → "Sin categoría en 2019 (incluye sin medición)"; singulares de F01 ("1 establecimiento sin categoría", "1 matriculado", "1 estudiante") donde aparezcan. Nada más.

**Cierre FASE 0:** M0–M6, M-NIV y M-DECL registrados; ninguna regla de detención activa.

### T0 — Sincronizar la fuente (D-M4)

esperado: `grep -c fs-base 33_app.jsx` = 0; bloque retranspilado distinto del template solo en las 7 líneas cosméticas de M4 del a1 (472, 1085, 1258, 1260, 1262, 1266, 1268); motor de prueba vs motor actual: 9/9 AE=0 y texto igual a 1280 y 390; template sin tocar
obtenido:
```
fs-base en 33_app.jsx: 0
template 000ac7723f2cdd44f8cae3840302f9da 1462 líneas | retrans 5978a112717b33fe7e13d1cc11ba0daa 1462 líneas | distintas: 7
líneas distintas: 472c472 1085c1085 1258c1258 1260c1260 1262c1262 1266c1266 1268c1268 
motor de prueba /tmp/cat_a2_t0_motor.html vs base: 1280 → 9/9 AE=0, 9/9 texto igual, errores 0; 390 → 9/9 AE=0, 9/9 texto igual, errores 0
git diff --stat:  1 file changed, 1 insertion(+), 1 deletion(-)
```
Commit: `b19d0f0`. 🔒6 de T0: render idéntico → PASA.
### T1 — Las 10 fichas del plan

Regla canónica aplicada en cada grupo: lógica y JSX en `33_app.jsx`; CSS en el template; luego `/tmp/cat_a2_reemplazar.sh` retranspila el archivo completo y reemplaza el bloque entero de la app. Cada build: `/tmp/cat_a2_build.sh` (PRUEBAS a + c + `git restore docs/index.html`).

#### Grupo 1 — modal y foco (F02, F03, F04, F05, F07)

Nota de orden: esta sección se anexó después del commit `f46ed48` (la cadena que la escribía se cortó por un `grep -c` sin coincidencias antes del `cat`; el commit iba en línea aparte). Las mediciones son previas al commit (salidas en `/tmp/cat_a2_g1_res.json` y `/tmp/cat_a2_g1/`); 🔒3 se midió tras el commit sobre el mismo árbol.

Elecciones abiertas del plan resueltas por el estilo del archivo: el ayudante de enfocables es una función de nivel superior `enfocablesModal` (como los demás ayudantes del archivo); el título del modal pasa a una constante `titulo` usada por el `h2` y el `aria-label`; el cuerpo del clic de la fila se extrae a `activar()` (lo nombra el plan); el foco tras quitar un chip se resuelve con un `useRef` + efecto sobre `entidades` en `ComparativaSheet`. CSS: solo `.check-row:focus-visible` (F02); la ✕ usa `.icon-btn` existente.

esperado: F02 filas con tabIndex 0 = filas no bloqueadas; Tab desde el buscador alcanza una fila; `.comuna-checklist` no es parada; Espacio "0→1", Enter "1→2"; en simple Enter elige y cierra · F03 0 paradas fuera del modal; Shift+Tab desde el primero → último; Escape cierra; foco al origen tras Cancelar, Escape, ✕ y elegir · F04 tope + Agregar → SPAN.cmp-picker-label; Enter en ✕ de chip → ✕ siguiente; último chip → "+ Agregar" · F05 un botón "✕" con aria-label "Cerrar" en el encabezado · F07 con 10 marcadas "Llegaste al máximo…"; Espacio sobre una marcada → "Selecciona hasta 1 territorio más · marcados: 9" · 🔒1 SHA igual; 🔒3 0 hex y :root igual; 🔒6 cadena idéntica; 🔒7 06 AE=0 y texto igual, y en el resto solo las cadenas de M-DECL; PRUEBAS b 0 errores
obtenido:
```
/tmp/cat_a2_reemplazar.sh: template b61dd33ab56ecbd858e469150226cde9 1575 líneas | retrans b61dd33ab56ecbd858e469150226cde9 1575 líneas | distintas: 0  (🔒6 cadena idéntica)
PRUEBAS a [g1]: exit=0; warnings=0 | motor 528b013e51c8f523bab6ee48bed90522 | PRUEBAS c 0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8 | docs restaurado 45e612f1c9909a2dd1115d9e8628cde0
F02 filas 345, tabIndex 0: 345 (modo simple, ninguna bloqueada); Tab desde el buscador → DIV.check-row [modal]; .comuna-checklist parada: false; múltiple: rol "checkbox", aria-checked "false"; Espacio → "…marcados: 1"; Tab+Enter → "…marcados: 2"; bloqueadas con tabIndex≠-1: 0; simple: Tab a fila + Enter → elige y cierra; Espacio → elige y NO reabre
F03 400 Tab con el modal abierto → 0 paradas fuera; Shift+Tab desde la ✕ (primero) → Cancelar (último); role/aria-modal/aria-label = dialog|true|Seleccionar territorio; Escape cierra → foco BUTTON.entity-select-btn; tras Cancelar, ✕ y elegir comuna o EE → BUTTON.entity-select-btn; múltiple: Escape descarta lo marcado (chips sin cambio) → foco BUTTON.cmp-add-btn
F04 tope (10) + "Agregar (10)" con Enter → "+ Agregar" disabled, foco SPAN.cmp-picker-label; Enter en la ✕ del 3.er chip → foco en la ✕ índice 2 de 9 (la que ocupó su lugar); Enter en la ✕ del último → BUTTON.cmp-add-btn
F05 .modal-header: ["✕|Cerrar"]; Enter sobre la ✕ cierra y devuelve el foco al origen
F07 aviso 0 marcadas "Selecciona hasta 10 territorios más · marcados: 0"; con 10 "Llegaste al máximo de 10 territorios. Desmarca uno para elegir otro."; Espacio sobre una marcada → "Selecciona hasta 1 territorio más · marcados: 9"
🔒3 hex en líneas agregadas (diff -U0 <inicio>): 0; :root md5 1851160a6f963379b2a63f427acfb6a5 (FASE 0: 1851160a6f963379b2a63f427acfb6a5)
🔒7/PRUEBAS b (/tmp/cat_a2_decl.sh): 1280 y 390 errores=0; AE 01=0, 05=0, 06=0, 09=0; 02/03/04/07 ≈20 px (la ✕), 08 ≈698 px (✕ + aviso); textContent: 02, 03, 04, 07 solo "✕" agregado tras el título; 08 "✕" + aviso "Selecciona hasta 10 territorios más · marcados: 10" → "Llegaste al máximo de 10 territorios. Desmarca uno para elegir otro."; 01, 05, 06, 09 idénticos
errores de consola/pageerror: 0
```

Commit: `f46ed48`.

#### Grupo 2 — ancho (F08, F14)

Elecciones: F14 con `display: inline-block` conservado (la píldora queda como un bloque de varias líneas con un solo borde, en vez del borde por línea que describía el riesgo del plan) y `overflow-wrap: anywhere`; el nombre usa `bNom` en la frase 1 y en el caso vacío (las dos apariciones de `b(entity.nom)`). F08: las dos reglas del plan, con los tamaños y colores de este motor.

esperado: F08 nombres partidos que cabrían dejando al secundario su ancho mínimo = 0 en 320, 390 y 1280, y filas desbordadas 0 a 320; F14 desborde 0 a 320 y 390 con el EE de nombre más ancho y con la muestra de 40; 🔒1, 🔒3, 🔒6 cadena idéntica, 🔒7 (06 AE=0; 04 cambia por F08; 05 sin cambio a 1280 y 390, porque su nombre cabe); PRUEBAS b 0 errores
obtenido:
```
/tmp/cat_a2_reemplazar.sh: template 07ff8ddaf6877318389646f35977d944 1581 | retrans 07ff8ddaf6877318389646f35977d944 1581 | distintas: 0
PRUEBAS a [g2]: exit=0; warnings=0 | motor 671f0be731eb45412f873102b4735237 | PRUEBAS c 0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8 | docs restaurado 45e612f1c9909a2dd1115d9e8628cde0
F08 (M5-B, "cabría" = cabe con toda la fila): 1280 15→4 partidos, 14→3 cabrían; 390 57→45, 37→25; 320 59→57, 12→10; filas desbordadas a 320: 2→0
F08 (criterio del plan, "cabría dejando al secundario su min-content", /tmp/cat_a2_f08.js): antes 1280 11, 390 12, 320 2 → después 0, 0, 0
F14 narrativa EE más ancho: 320 539→0; 390 469→0; 1280 0→0; muestra 40: 320 18→0; 390 8→0; apertura, modales y comparador: 0
🔒3 hex en líneas agregadas: 0; :root md5 1851160a6f963379b2a63f427acfb6a5
🔒7/PRUEBAS b: 1280 y 390 errores=0; AE 01=0, 05=0, 06=0, 09=0; 04 1280 15563 / 390 7992 (F08: secundario alineado a la derecha y nombres que dejan de partirse); 02/03/07/08 igual que el grupo 1 (la ✕ y el aviso); textContent: solo las cadenas del grupo 1
```
Commit: `a222203`.

#### Grupo 3 — textos (F01, D-03)

Elecciones: ternarios en línea en los tres sitios del plan (`SinVigente`, detalle de `EeRow`, `CatColumn`). **Ampliación dentro de F01, registrada:** la primera verificación mostró «1 establecimiento sin categoría en 2019 (conteo oficial). No entran en la distribución…»: el verbo de la frase siguiente concuerda con el mismo conteo, así que pasa a `total === 1 ? "No entra" : "No entran"` (misma ficha, mismo problema de uso; build g3b). D-03: frase 2 con `total === 1` → "Está en nivel de desempeño X."

esperado: F01 Alhué (básica) «1 establecimiento sin categoría en 2019 (conteo oficial)…» y 0 "1 + plural" en la pantalla; ficha de un EE × año con matrícula 1 → «1 matriculado en …»; "1 estudiantes" 0 (latente; el ternario se verifica por lectura); D-03 EE con categoría → «Está en nivel de desempeño …»; 🔒1, 🔒3, 🔒6 cadena idéntica, 🔒7 (01 texto igual; 05 solo cambia la frase 2); PRUEBAS b 0 errores
obtenido:
```
/tmp/cat_a2_reemplazar.sh (g3b): template 1aa97261f94e072d6ce18f86e92a0083 1584 | retrans 1aa97261f94e072d6ce18f86e92a0083 1584 | distintas: 0
PRUEBAS a [g3]: exit=0; warnings=0 | PRUEBAS c 0ffd9899…2ad8 | docs 45e612f1…  ;  PRUEBAS a [g3b]: exit=0; warnings=0 | motor 077748b6639689bc3749ff2d0640e792 | PRUEBAS c 0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8 | docs restaurado 45e612f1c9909a2dd1115d9e8628cde0
F01 antes: «1 establecimientos sin categoría en 2019 (conteo oficial). No entran…», "1 + plural" en pantalla 1; ficha «1 matriculados en Educación Media»
F01 g3:    «1 establecimiento sin categoría en 2019 (conteo oficial). No entran…» (verbo sin concordar → ampliación)
F01 g3b:   «1 establecimiento sin categoría en 2019 (conteo oficial). No entra en la distribución de las cuatro categorías.»; "1 + plural" en pantalla 0; ficha «1 matriculado en Educación Media» (los años con 44 y 40 siguen en plural)
M5-E (g3): texto visible sv «1 establecimiento sin categoría en 2019 …»
D-03 EE con categoría: frase 2 «Está en nivel de desempeño Insuficiente.» (antes «Todos están…»); la frase 1 sigue igual (la cambia T2.3)
🔒3 hex en líneas agregadas: 0; :root md5 1851160a6f963379b2a63f427acfb6a5
🔒7/PRUEBAS b: 1280 y 390 errores=0; AE 01=0, 06=0, 09=0; 05 1280 1105 / 390 0 (la frase 2 es más corta); textContent: 01, 06, 09 idénticos; 05 solo «Todos están» → «Está»; resto igual que el grupo 2
```
Commit: `c94971f`.

#### Grupo 4 — anillo (F12)

Elección: la regla propia se extiende con los selectores del plan (`button`, `[role="button"]`, `[tabindex]`) justo después de `.select:focus, .input:focus`, para que `.check-row:focus-visible` (grupo 1, `-2px`) la redefina por orden de fuente con igual especificidad. Solo CSS; el bloque de la app no cambia (retranspilación idéntica).

esperado: contraste máximo anillo vs debajo ≥ 3 en los siete controles de M5 (incluidos "+ Agregar" y chip activo, rellenos de --ocean); fila del modal con anillo hacia adentro; 🔒7: capturas sin foco idénticas a las del grupo 3; 🔒1, 🔒3, 🔒6
obtenido:
```
/tmp/cat_a2_reemplazar.sh: template 1aa97261f94e072d6ce18f86e92a0083 = retrans (distintas: 0; sin cambio de lógica)
PRUEBAS a [g4]: exit=0; warnings=0 | motor 39ebd73be415ca4bbb7ca73a87af63d3 | PRUEBAS c 0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8 | docs restaurado 45e612f1c9909a2dd1115d9e8628cde0
F12 (M5-D, Tab real): +Agregar 1,21→5,99; chip activo 1,19→5,99; chip inactivo 5,98→5,99; segmented activo 5,98→6,45; Limpiar 5,56→5,99; ✕ de chip 5,98→6,45; Notas 5,56→5,99
fila del modal enfocada: outline rgb(0, 98, 160), offset -2px (captura /tmp/cat_a2_f12_fila.png); fila de EE (role=button) con anillo visible dentro de su columna (captura /tmp/cat_a2_f12_eerow.png)
🔒3 hex en líneas agregadas: 0; :root md5 1851160a6f963379b2a63f427acfb6a5
🔒7/PRUEBAS b: errores=0 a 1280 y 390; g3 vs g4: 0 diferencias (9/9 AE=0 y texto igual en los dos anchos)
```
Commit: `26ca8cd`.

### T2 — Resoluciones del titular

Elecciones: T2.1 con un `Set` de nivel superior `CAT_CABECERA_TINTA` (claves confirmadas por M-NIV) y la clase `is-tinta`; T2.2 con `{CatData.ANIO_VIGENTE}` (sin año literal); T2.3 con `entity.kind === "establecimiento"` en el caso vacío y en la frase 1 (las demás entidades conservan su texto). Búsqueda de otras superficies del comparador que rotulen la misma cifra (recorrido de texto y `title` dentro de `.cmp-sheet`): solo la fila `tr.cmp-row-sv`; la caja "Sin categoría vigente" de la vista por territorio (conteo oficial) no se tocó.

esperado: T2.1 contraste título/stat/mat: Insuficiente ≥ 4,46 (≈ 4,46), Medio-Bajo ≥ 4,5 (≈ 7,01), Medio ≥ 4,5 (≈ 5,27), Alto sin cambio (6,45/5,72/4,89); % máximo, delta y ✕ del chip sin cambio · T2.2 rótulo «Sin categoría en 2019 (incluye sin medición)», cursiva, cifras de la fila idénticas a M6 · T2.3 EE con categoría «El establecimiento «NOMBRE» tiene Educación Básica categorizada al año 2019, el año más reciente para el cual existe una clasificación.»; EE sin categoría «El establecimiento «NOMBRE» no tiene Educación Básica categorizada al año 2019 para la selección actual.»; comuna y SLEP con textContent idéntico a M6 · 🔒1, 🔒3, 🔒6 cadena idéntica, 🔒7
obtenido:
```
/tmp/cat_a2_reemplazar.sh: template 77a94648b269fde3707b5d67dbaa144d 1597 | retrans 77a94648b269fde3707b5d67dbaa144d 1597 | distintas: 0
PRUEBAS a [t2]: exit=0; warnings=0 | motor 91570b620f1de44ea84ca7c7ae33f8bc | PRUEBAS c 0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8 | docs restaurado 45e612f1c9909a2dd1115d9e8628cde0
T2.1 (M5-C): Insuficiente 4,11/3,67/3,16 → 4,46/4,46/4,46; Medio-Bajo 2,62/2,44/2,23 → 7,01/7,01/7,01; Medio 3,48/3,19/2,85 → 5,27/5,27/5,27; Alto 6,45/5,72/4,89 → 6,45/5,72/4,89; % máximo 2,07–3,51 (sin cambio); delta 3,97 (sin cambio); ✕ al pasar 4,11 (sin cambio)
T2.2: rótulo "Sin categoría en 2019 (incluye sin medición)"; fontStyle italic; cifras de la fila [0, 1, 0] (M5: [0, 1, 0]); en 09 (10 territorios) la secuencia de cifras "010104136573" idéntica; superficies del comparador con "sin categoría": 1 (la fila)
T2.3 con categoría: «El establecimiento «NOMBRE» tiene Educación Básica categorizada al año 2019, el año más reciente para el cual existe una clasificación.» + «Está en nivel de desempeño Insuficiente.»
T2.3 sin categoría: «El establecimiento «NOMBRE» no tiene Educación Básica categorizada al año 2019 para la selección actual.»
🔒3 hex en líneas agregadas: 0; :root md5 1851160a6f963379b2a63f427acfb6a5
🔒7/PRUEBAS b: errores=0 a 1280 y 390; 01 AE=0 y texto igual (narrativa del SLEP intacta; las cabeceras caen bajo el pliegue de la captura 1280×800; su cambio se mide en T2.1 y se captura para el gate); 06 AE=0; 05 texto: solo «1 establecimiento con … categorizado» → «… categorizada» y «Todos están» → «Está»; 09 texto: solo el rótulo
```
Commit: `3848cfc`.

### T3 — Documentos

Decisión nueva `50_documentacion/activa/decisiones/20260925_decision_contraste_texto_categorias.md` (formato del directorio: fecha, sesión, tipo, estado; contexto, decisión, excepción escrita, precisión a la decisión de paleta, superficies que quedan, alternativas, implicancia). Contrastes de la paleta como relleno sobre crema calculados por fórmula WCAG con los hex del `:root`: Insuficiente 3,82, Medio-Bajo 2,43, Medio 3,24, Alto 5,99; `--ink` sobre Alto 2,84. Plan: se anexa `## 6` con las resoluciones y el estado por ficha.

esperado: privacidad 0/0/0 en el plan y en la decisión; `git diff` del plan con 0 líneas quitadas (solo agregadas al final)
obtenido:
```
/tmp/cat_a2_priv.sh plan: RUT 0 | RBD+n 0 | nombre EE 0 ; decisión: RUT 0 | RBD+n 0 | nombre EE 0
git diff --numstat plan: 38 agregadas, 0 quitadas; líneas quitadas: 0
```
Commit: `5d56109`.

### T4 — Build y verificación

esperado: PRUEBAS a exit 0 y 0 warnings (renv activo); PRUEBAS c `0ffd9899…2ad8`; PRUEBAS d en verde con `docs/index.html` recién escrito; `git restore docs/index.html` → `45e612f1…`; capturas antes/después por ficha en `/tmp/cat_a2_gate/`
obtenido:
```
PRUEBAS a [t4]: exit=0; warnings=0
md5 motor nuevo 40_salidas/motor_categoria.html: 91570b620f1de44ea84ca7c7ae33f8bc (igual al build t2: mismas fuentes y misma fecha → build reproducible)
PRUEBAS c: 0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8
PRUEBAS d: auditar exit=0, F1–F4 OK (0 discrepancias), TODAS LAS FAMILIAS EN VERDE; spot exit=0, SPOT-CHECK OK 6 + 1
docs restaurado: 45e612f1c9909a2dd1115d9e8628cde0
gate: 22 PNG (11 escenas × antes/después): F02_F05_F12 modal con fila enfocada; F03 foco al origen; F04 respaldo al tope; F07 modal múltiple al tope; F08 modal EE a 1280, 390 y 320; F09 fila del comparador; F11 cabeceras; F14_D03 narrativa con el EE de nombre más ancho a 320 y 390
```

### FASE R — Auditoría propia y reparación

#### R.1 Inventario (anexado antes de auditar)

| id | afirmación | origen |
|---|---|---|
| R-01 | M0: renv activo carga dplyr y arrow | FASE 0 |
| R-02 | M1/M2: punto de partida limpio, `HEAD~1` = `origin/main` = `51447ce` | FASE 0 |
| R-03 | M3: md5 de partida, SHA `0ffd9899…2ad8`, calibración, PRUEBAS d | FASE 0 |
| R-04 | M4: deriva idéntica a la del a1 antes de T0 | FASE 0 |
| R-05 | M5: huecos presentes con los valores del a1; recalibración de M5-D | FASE 0 |
| R-06 | M-NIV y M-DECL | FASE 0 |
| R-07 | M6: línea base determinista | FASE 0 |
| R-08 | T0: `--fs-base` → `--fs-body`; render idéntico | T0 |
| R-09 | F02 filas operables con teclado | T1 g1 |
| R-10 | F03 ciclo de Tab, Escape, vuelta al origen | T1 g1 |
| R-11 | F04 respaldo al tope y foco tras quitar un chip | T1 g1 |
| R-12 | F05 ✕ con nombre "Cerrar" | T1 g1 |
| R-13 | F07 aviso de lo que resta; desmarcar con teclado | T1 g1 |
| R-14 | F08 nombres que cabrían = 0; filas sin desborde | T1 g2 |
| R-15 | F14 sin desborde de página con un EE | T1 g2 |
| R-16 | F01 singulares (incluida la ampliación al verbo) | T1 g3 |
| R-17 | D-03 "Está en nivel…" | T1 g3 |
| R-18 | F12 anillo ≥ 3 en los siete controles | T1 g4 |
| R-19 | T2.1 tinta de cabeceras | T2 |
| R-20 | T2.2 rótulo de la fila del comparador | T2 |
| R-21 | T2.3 frase 1 y caso vacío con un EE | T2 |
| R-22 | T3 decisión nueva y §6 del plan (solo agregado) | T3 |
| R-23 | Segunda lectura de cada ficha implementada: nada de la lógica de `slep_idps` colado sin razón | T1/T2 |
| R-24 | 🔒1 | §3 |
| R-25 | 🔒2 | §3 |
| R-26 | 🔒3 | §3 |
| R-27 | 🔒4 | §3 |
| R-28 | 🔒5 | §3 |
| R-29 | 🔒6 (cadena idéntica) | §3 |
| R-30 | 🔒7 | §3 |
| R-31 | Alcance global | §4 |
| R-32 | Regresión PRUEBAS a–d | §7.5 |
| R-33 | Control positivo sobre el motor publicado `45e612f1…` | §7.6 |
| R-34 | Proceso: orden del LOG del grupo 1; uso de `npx prettier --version` | propio |

#### R.2–R.6 Re-derivación, invariantes, alcance, regresión y control positivo

Adaptación del instrumento M5-A (sin cambio de criterio): asumía que Escape no cierra y seguía usando el modal; en el motor nuevo Escape cierra, así que tras medir el cierre el instrumento reabre el modal y registra el foco (`simple_foco_tras_escape`, `multiple_foco_tras_escape`).

esperado: re-derivación con comandos distintos confirma cada ítem; 🔒1–🔒7 PASAN (🔒6 cadena idéntica); alcance = 33_app.jsx, template, decisión nueva y plan; PRUEBAS a–d en verde; el motor publicado muestra los huecos de M5
obtenido:
```
Re-derivación (/tmp/cat_a2_rR.js, /tmp/cat_a2_ax.js; motor nuevo):
  F02/F05 árbol de accesibilidad: dialog "Seleccionar territorio" 1; botones "Cerrar" 1; fila = role "button" con nombre "ALGARROBO Valparaiso" (publicado: role "generic", nombre "")
  F03 ciclo: Tab desde la ✕ vuelve a la ✕ tras 352 pulsaciones = 352 enfocables del modal (345 filas + ✕ + 4 pestañas + buscador + Cancelar); clic en el fondo cierra → foco entity-select-btn
  F04 con ratón (abrir por clic, marcar por clic, Agregar por clic) al tope → foco cmp-picker-label
  F07 con 2 territorios ya agregados y 8 marcados → "Llegaste al máximo de 10 territorios. Desmarca uno para elegir otro."
  F08 (canvas: ancho del nombre + palabra más larga del secundario), 320 px, búsqueda "escuela": 59 partidos, 0 cabrían
  F14 (borde derecho máximo de todo #root vs 320 px), muestra de 20 EE con paso distinto: 0 fuera (1 omitido: su RBD no quedó entre los 60 resultados)
  F12 (outline computado vs fondo computado del padre): chip activo solid 2px 5,99; segmented activo 5,34; botón de territorio 6,45
  F01 12 comunas con 1 s/i en básica: 12 correctas («1 establecimiento … No entra …»), 0 con plural a mano
  T2.1 (color computado vs backgroundColor computado, sin mezcla): 4,46/4,46/4,46 · 7,01/7,01/7,01 · 5,27/5,27/5,27 · Alto 6,45 con opacidades 0,92/0,82 intactas
  T2.2 en Educación Media: "Sin categoría en 2019 (incluye sin medición)"
  T2.3 en Educación Media con otro EE: «El establecimiento «NOMBRE» tiene Educación Media categorizada al año 2019, …» + «Está en nivel de desempeño Medio.»
  errores de consola/pageerror: 0
🔒1 PRUEBAS c 0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8; Python: payload nuevo == publicado sin la fecha → True
🔒2 PRUEBAS d: F1–F4 OK (0 discrepancias); spot-check 6 + 1 OK
🔒3 hex en líneas agregadas (diff -U0 <inicio>..HEAD, template + 33_app.jsx): 0; :root 1851160a… = 1851160a…
🔒4 git diff <inicio>..HEAD -- 30_* 31_* 32_* 33_generar_html.R 34_* 20_insumos 10_utils tests | wc -l → 0
🔒5 docs/index.html 45e612f1c9909a2dd1115d9e8628cde0; git diff --name-only <inicio>..HEAD -- docs → 0
🔒6 template 77a94648b269fde3707b5d67dbaa144d = retrans 77a94648b269fde3707b5d67dbaa144d (distintas: 0)
🔒7 (motor final, 1280 y 390): 06 AE=0 y texto igual; 01 AE=0 y texto igual; 02, 03, 04, 07: textContent = base + "✕" (comprobado quitando la ✕: igual); 05: «1 establecimiento con … categorizado» → «… categorizada», «Todos están» → «Está»; 08: ✕ + aviso; 09: solo el rótulo; nada fuera de M-DECL
alcance: 30_procesamiento/33_app.jsx, 30_procesamiento/33_motor_template.html, 50_documentacion/activa/decisiones/20260925_decision_contraste_texto_categorias.md, 50_documentacion/andamios/20260925_plan_alineamiento_motores.md; porcelain = parquet preexistente + LOG; stash 0
regresión: PRUEBAS a [R] exit=0, warnings=0, motor 91570b620f1de44ea84ca7c7ae33f8bc; c y d como arriba; docs restaurado 45e612f1…
control positivo (M5 SEC=ABE, mismo instrumento) — publicado 45e612f1 | nuevo:
  filas con tabIndex 0 | 345; alcanzadas por Tab 0/0 | 30/30; Tab sale del modal true | false; Escape cierra false | true (foco al origen)
  Cancelar → BODY | botón de origen; elegir EE → BODY | botón de origen; tope → BODY | SPAN.cmp-picker-label; quitar chip → BODY | BUTTON.cmp-chip-x
  botones en el encabezado 0 | 1; aviso con 10 "Selecciona hasta 10 territorios más · marcados: 10" | "Llegaste al máximo de 10 territorios. Desmarca uno para elegir otro."
  F08 (M5-B) 1280 15/14 | 4/3; 320 59/12, 2 desbordadas | 57/10, 0 desbordadas; F14 539/469/18/8 | 0/0/0/0
  texto s/i Alhué «1 establecimientos … No entran …» | «1 establecimiento … No entra …»
```

#### R.7 Tabla de auditoría

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | M0 | build y pruebas con `renv` activo | exit 0 | exit 0 en 7 builds y 3 pares de pruebas | — | — | — | — |
| R-02 | M1/M2 | `git log -1 cc0bced^` | `51447ce` | `51447ce` | — | — | — | — |
| R-03 | M3 | Python (igualdad de objetos) | igual | igual | — | — | — | — |
| R-04 | M4 | `cmp` de bloques contra los del a1 | idénticos | idénticos | — | — | — | — |
| R-05 | M5 | control positivo | huecos presentes | presentes | — | — | — | — |
| R-06 | M-NIV/M-DECL | lectura del payload; 🔒7 | concuerdan | concuerdan | — | — | — | — |
| R-07 | M6 | segunda corrida | 0 diferencias | 0 | — | — | — | — |
| R-08 | T0 | 🔒6 de T0 (render) y `grep fs-base` | 9/9 AE=0; 0 | 9/9 AE=0 (×2 anchos); 0 | PASA | — | `b19d0f0` | — |
| R-09 | F02 | árbol de accesibilidad | fila = button con nombre | sí | PASA | — | `f46ed48` | — |
| R-10 | F03 | ciclo completo de Tab; clic en el fondo | 352 = 352; origen | sí | PASA | — | `f46ed48` | — |
| R-11 | F04 | recorrido con ratón | cmp-picker-label | sí | PASA | — | `f46ed48` | — |
| R-12 | F05 | árbol de accesibilidad | 1 "Cerrar" | 1 | PASA | — | `f46ed48` | — |
| R-13 | F07 | otro reparto (2 ya + 8) | "Llegaste al máximo…" | sí | PASA | — | `f46ed48` | — |
| R-14 | F08 | canvas | 0 cabrían | 0 | PASA | — | `a222203` | — |
| R-15 | F14 | borde derecho de todo `#root`, otra muestra | 0 | 0 | PASA | — | `a222203` | — |
| R-16 | F01 | 12 comunas | 12 correctas | 12 | PASA | — | `c94971f` | — |
| R-17 | D-03 | EE en media | "Está en…" | sí | PASA | — | `c94971f` | — |
| R-18 | F12 | outline vs fondo del padre | ≥ 3 | 5,34–6,45 | PASA | — | `26ca8cd` | — |
| R-19 | T2.1 | color vs fondo computados | 4,46 / ≥4,5 / ≥4,5 / sin cambio | 4,46 / 7,01 / 5,27 / 6,45 | PASA | — | `3848cfc` | — |
| R-20 | T2.2 | en media | rótulo nuevo | sí | PASA | — | `3848cfc` | — |
| R-21 | T2.3 | EE en media | frase exacta | sí | PASA | — | `3848cfc` | — |
| R-22 | T3 | `git diff --numstat` del plan; privacidad | 0 quitadas; 0/0/0 | 0; 0/0/0 | PASA | — | `5d56109` | — |
| R-23 | segunda lectura | relectura de cada ficha contra `slep_idps` | nada colado sin razón | F03/F05: Escape y ✕ = Cancelar (no el "Listo" de `slep_idps`); F04: rótulo propio; F12: token propio; F08: la alineación a la derecha del secundario viene de `slep_idps` y el plan la declaró como riesgo visual | ADVIERTE | al gate del titular | — | — |
| R-24 | 🔒1 | PRUEBAS c + Python | igual | igual | PASA | — | — | — |
| R-25 | 🔒2 | PRUEBAS d | verde | verde | PASA | — | — | — |
| R-26 | 🔒3 | diff -U0 + `:root` | 0; igual | 0; igual | PASA | — | — | — |
| R-27 | 🔒4 | diff | 0 | 0 | PASA | — | — | — |
| R-28 | 🔒5 | md5 + diff | `45e612f1…`; 0 | igual; 0 | PASA | — | — | — |
| R-29 | 🔒6 | retranspilación | cadena idéntica | 0 líneas distintas | PASA | — | — | — |
| R-30 | 🔒7 | recorrido + diff de texto | solo M-DECL | solo M-DECL | PASA | — | — | — |
| R-31 | alcance | `git diff --name-only`; porcelain | 4 rutas + LOG | 4 rutas + LOG | PASA | — | — | — |
| R-32 | regresión | PRUEBAS a–d | verde | verde | PASA | — | — | — |
| R-33 | control positivo | M5 sobre `45e612f1` | huecos | huecos | PASA | — | — | — |
| R-34 | proceso | revisión propia | — | (a) la sección del grupo 1 se escribió después de su commit (cadena cortada por `grep -c`); (b) se ejecutó `npx --prefix /tmp/cat_a2_babel prettier --version`, que descargó `prettier` a la caché de npx del usuario (`~/.npm/_npx/b388654678d519d9`, 16:55), fuera de la lista de autorizaciones; no se usó ni se borró (`rm` no autorizado) | ADVIERTE | declarado | — | — |

**Ciclos de reparación:** 0 (sin hallazgos REPARA).

**Veredicto FASE R: SIN BLOQUEO** (0 BLOQUEA, 0 REPARA, 2 ADVIERTE; control positivo presente).

### FASE L — Cierre

#### Resumen

Con `renv` ya restaurado (M0 pasa), se sincronizó la fuente JSX (T0: `--fs-base` → `--fs-body`, render idéntico) y se implementaron las 10 fichas del plan en cuatro grupos (modal y foco; ancho; textos; anillo) y las tres resoluciones del titular (tinta de cabeceras, rótulo del comparador, frase 1 con un establecimiento). Toda edición de lógica pasó por `33_app.jsx` y llegó al template solo por retranspilación completa (cadena idéntica en cada grupo). El payload no cambió (SHA normalizado igual en 7 builds), las pruebas del dato siguen en verde y `docs/index.html` quedó restaurado. Se escribió la decisión de contraste con su excepción y se anexó la §6 al plan.

#### Commits

`cc0bced` encargo · `b19d0f0` T0 · `f46ed48` T1 modal y foco · `a222203` T1 ancho · `c94971f` T1 textos · `26ca8cd` T1 anillo · `3848cfc` T2 · `5d56109` T3 · (este) `docs(log)`.

#### Estado por ficha y resolución

Implementadas: D-M4, F02, F03, F04, F05, F07, F08, F14, F01 (con el verbo de la misma frase), D-03, F12, F11-B, F09-B (y D-13), D-03 frase 1. Cerradas sin cambio por resolución: F18 (No), D-08 (se mantiene c.21). Abierta: D-22. Sin cambio (inspirarse): F19, D-24. Congeladas: ninguna.

#### Tabla de auditoría

Ver R.7 (34 filas; 0 BLOQUEA, 0 REPARA, 2 ADVIERTE: R-23, R-34).

#### Invariantes

🔒1 PASA · 🔒2 PASA · 🔒3 PASA · 🔒4 PASA · 🔒5 PASA · 🔒6 PASA (cadena idéntica) · 🔒7 PASA.

#### md5 del motor nuevo

`40_salidas/motor_categoria.html`: `91570b620f1de44ea84ca7c7ae33f8bc` (builds t2, t4 y R idénticos). `docs/index.html`: `45e612f1c9909a2dd1115d9e8628cde0` (restaurado; el despliegue queda al titular).

#### Dudas con pregunta cerrada

- **Q-D22** (heredada): ¿La próxima categorización (Simce 2025) se publicará primero como preliminar? Sí / No.
- **Q-DEPLOY:** ¿Se despliega el motor nuevo a `docs/index.html` tras la revisión en pantalla? Sí / No.
- **Q-NPX:** `npx` descargó `prettier` a `~/.npm/_npx/b388654678d519d9` (fuera del proyecto, sin uso). ¿Lo borra el titular (`rm -rf ~/.npm/_npx/b388654678d519d9`)? Sí / No.

#### Errores propios

1. La sección del grupo 1 se anexó al LOG después de su commit: la cadena `&&` se cortó en un `grep -c` que devolvió 0 coincidencias (exit 1) antes del `cat`; el `git commit`, en línea aparte, sí corrió. Se reconstruyó con las salidas guardadas en `/tmp` y se marcó la nota de orden.
2. `npx --prefix /tmp/cat_a2_babel prettier --version` descargó prettier a la caché de npx (acción fuera de la lista de autorizaciones; sin efecto en el repo).
3. Instrumentos: la primera captura del anillo de la fila del modal falló (el script venía de un bucle de Tab que había salido del modal); la primera corrida del gate falló en el motor publicado (no se podía marcar con teclado: se pasó a marcar con clic en los dos motores); la primera re-derivación de F14 falló con un RBD que no quedaba entre los 60 resultados (se omite y se cuenta); M5-A asumía que Escape no cierra (se adaptó reabriendo el modal). Ninguna cifra registrada salió de una corrida fallida.
4. F01, primera versión: dejó «1 establecimiento … No entran …»; se detectó en la verificación y se corrigió antes del commit del grupo.

#### Observaciones fuera de alcance (no se implementan)

- Frase 3 de la narrativa vacía cuando la matrícula del nivel está solo en Medio-Bajo ("Considerando la matrícula 2025, .", plan §2).
- Frase 3 con un establecimiento como sujeto: «…asisten a uno de desempeño Insuficiente (100,0%)» habla del propio establecimiento como "uno de".
- `el**Simce 2022**` sin espacio en la nota de cobertura temporal.
- CSS muerto heredado de `slep_simce_adecuado` (pendiente #2 del traspaso v29).
- Vistas en este encargo: a 390 px la pestaña "Establecimiento" del modal queda cortada a la derecha; a 320 px, con un EE de nombre largo como entidad, el botón de territorio de la barra de controles (fija) ocupa gran parte de la pantalla; tras "Limpiar" en el comparador el foco cae en `BODY` (el botón desaparece).

#### Privacidad

`/tmp/cat_a2_priv.sh` (copia del a1: RUT con DV, la sigla del rol seguida de número, nombres típicos de establecimiento). Control: una copia del LOG con tres plantas ficticias da RUT 1, RBD+n 1, nombre EE 1 (detecta). LOG, plan y decisión nueva: RUT 0, RBD+n 0, nombre EE 0.

#### Estado de cierre

T0, T1, T2, T3 y T4 COMPLETADAS · FASE R SIN BLOQUEO · `docs/index.html` restaurado · push según autorización tras este commit · sin shells en segundo plano.
