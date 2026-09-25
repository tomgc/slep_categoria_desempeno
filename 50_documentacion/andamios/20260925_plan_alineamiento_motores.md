# Plan de adaptación: patrones de usabilidad de `slep_idps` al motor de Categoría (a1, T1)

- **Fecha:** 2026-09-25
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_categoria_alineamiento_motores_a1.md` (T1)
- **LOG:** `50_documentacion/andamios/logs/20260925_alineamiento_motores_a1_log.md` (mediciones M1–M6)
- **Insumo de referencia (solo lectura):** matriz `slep_idps/50_documentacion/andamios/20260924_matriz_patrones_motores.md` (§1, §3.2, §4.3, §7) y plantilla `slep_idps/30_procesamiento/35_motor_template.html` (en `d935299`).
- **Privacidad:** sin RBD con número ni nombres de establecimiento.

## 0. Estado de ejecución que condiciona este plan

**M4 falló** (deriva de la fuente): retranspilar `33_app.jsx` no reproduce el bloque de la app del template ni como cadena ni como render. La única diferencia de render es el `fontSize` en línea del buscador de `EntityModal`: el template dice `var(--fs-body)` y `33_app.jsx` dice `var(--fs-base)`, token que `91ff8ed` (v29, migración tipográfica) eliminó de `:root` editando el transpilado sin tocar la fuente JSX. Retranspilado tal cual, el buscador de los dos modales cambia de tamaño (AE de 5.064 a 16.036 píxeles en las 5 pantallas con modal; 0 en las otras 4). Por la regla de detención 3 del encargo, **T2 y T3 quedan congeladas**: este plan se entrega completo, pero nada de su §3 se implementa en a1. La condición para descongelar es la duda **D-M4** (§4).

Las fichas usan la numeración de la matriz: `F01`…`F19` = fila de §1; `D-nn` = duda de §7. "M5" = medición propia de este encargo (LOG, FASE 0), nunca la cifra de la matriz.

## 1. Fichas

### F02 · Modal: filas operables con Tab, Enter y Espacio

1. **Problema de uso aquí.** `EntityModal` es la única vía para cambiar de territorio (vista por territorio, botón "Territorio ▾") y para agregar territorios al comparador ("+ Agregar"). Sus filas (`div.check-row`) solo tienen `onClick`: quien usa teclado no puede elegir nada.
2. **¿Existe?** Sí. M5: 0 de 345 filas con `tabIndex`; 30 Tab desde el buscador → 0 filas alcanzadas en los dos modales; Flecha + Enter desde el buscador no elige.
3. **Decisión propia que lo toca.** Ninguna. La c.30 del backlog (multiselección con casillas) no regula el teclado.
4. **Qué de `slep_idps` depende de su lógica.** Nada de fondo: allí la fila también confirma al clic en modo simple y alterna en modo múltiple. Su `dis` (fila deshabilitada) equivale aquí a `bloqueado`.
5. **Forma adaptada.** `30_procesamiento/33_app.jsx`, `EntityModal`, en el `div.check-row`: `tabIndex={bloqueado ? -1 : 0}`, `role={multiple ? "checkbox" : "button"}`, `aria-checked={multiple ? marcado || yaEsta : undefined}`, `aria-disabled={bloqueado || undefined}` y `onKeyDown` que, con Enter o Espacio (`preventDefault`), ejecuta el mismo cuerpo que `onClick` (extraído a una función local `activar()`). CSS en el template: `.check-row:focus-visible { outline: 2px solid var(--ocean); outline-offset: -2px; }` (ver F12; `--ocean` sobre `--ocean-20` de la fila marcada ≈ 4,97:1).

- **Clase: Adoptar.** Mismo problema y misma solución; solo cambian nombres (`bloqueado` por `dis`, `--ocean` por `--foco`, que en `slep_idps` es el mismo `#0062A0`).
- **Riesgo.** En la pestaña Comuna sin búsqueda hay 345 paradas de Tab (igual que en `slep_idps` con su lista); el buscador sigue siendo el atajo. El contenedor `.comuna-checklist` deja de ser parada propia (Chrome solo enfoca el desplazable cuando no tiene hijos enfocables): verificarlo.
- **Verificación.** Repetir M5-A: filas con `tabIndex` = filas no bloqueadas; Tab desde el buscador alcanza la primera fila; Espacio marca ("marcados: 0" → "1"), Enter marca otra ("1" → "2"); en modo simple Enter elige y cierra.

### F03 · Modal: foco retenido en ciclo y vuelta al origen al cerrar

1. **Problema.** Con el modal abierto, Tab sale a la página que está detrás (oscurecida y sin respuesta al clic); Escape no cierra; al cerrar, el foco cae en `BODY` y quien usa teclado pierde su lugar.
2. **¿Existe?** Sí. M5: Tab sale del modal a `BODY` y luego a los controles de la página, en los dos modales; sin `role="dialog"`; Escape no cierra; Cancelar → `BODY`.
3. **Decisión propia.** Ninguna.
4. **Dependencia de la lógica de `slep_idps`.** Allí, en modo múltiple, cada clic alterna la entidad **en el comparador** al instante (no hay selección local), así que cerrar nunca pierde nada. Aquí el modal múltiple acumula una selección **local** (`sel`) que solo se confirma con "Agregar (N)"; el fondo y "Cancelar" ya la descartan. Por eso Escape debe ser **Cancelar** (descartar), no "Listo".
5. **Forma adaptada.** `EntityModal`: `role="dialog"`, `aria-modal="true"`, `aria-label` = el título visible ("Seleccionar territorio" / "Agregar territorios"); `ref` en `.modal`; origen leído en el primer render (`React.useState(() => document.activeElement)`); efecto de `keydown` para Escape → `onCancel`; efecto de `keydown` para Tab que cierra el ciclo sobre los enfocables visibles del modal (misma receta que `_enfocablesModal` de `slep_idps`, reescrita en el estilo de este archivo); efecto de desmontaje que devuelve el foco al origen si sigue en el documento y no está deshabilitado (si no, F04). Se conserva el trago de autorrepetición de Enter/Espacio sobre el destino (R-11 de `slep_idps`): aquí el disparador del modal simple es un botón que se reabriría con la repetición.

- **Clase: Adaptar** (Escape = Cancelar por la selección local; el resto, igual).
- **Riesgo.** Doble manejador de Escape si en el futuro hay dos modales apilados (hoy no ocurre: uno a la vez).
- **Verificación.** M5-A: 30 Tab dentro del modal → ninguna parada fuera de `[modal]`; Shift+Tab desde el primero → último; Escape cierra; al cerrar por Cancelar, Escape o fondo, el foco vuelve a "Territorio ▾" o a "+ Agregar".

### F04 · Modal: destino de respaldo si el origen desaparece

1. **Problema.** Al agregar el décimo territorio, "+ Agregar" queda deshabilitado; el foco no puede volver a un botón deshabilitado y cae en `BODY`.
2. **¿Existe?** Sí, en un recorrido: M5, tope + "Agregar (10)" con Enter → `BODY`. El segundo recorrido de la matriz (elegir un establecimiento) **no** es aquí un caso de respaldo: el botón "Territorio ▾" sigue montado tras elegir, así que F03 lo resuelve (hoy cae en `BODY` solo porque no hay vuelta al origen). Fuera del modal, M5 halló el mismo síntoma al quitar un chip con Enter sobre su ✕ (→ `BODY`).
3. **Decisión propia.** Ninguna.
4. **Dependencia de la lógica de `slep_idps`.** Allí el disparador **se desmonta**; aquí queda montado y **deshabilitado** (`disabled={entidades.length >= LIMITE}`), así que la condición debe mirar también `disabled`. El respaldo de `slep_idps` es su rótulo de la barra del comparador (`span.cmp-cl` con `tabIndex={-1}`, precedido por su botón de agregar si existe); aquí el equivalente inerte es el rótulo `.cmp-picker-label`.
5. **Forma adaptada.** Prop `focoRespaldo` (función) en `EntityModal`; `ComparativaSheet` la pasa apuntando a `.cmp-picker-label` ("Territorios a comparar"), que recibe `tabIndex={-1}` (enfocable por programa, no parada de Tab). Para el chip: tras `removeEntity`, el foco va a la ✕ del chip siguiente, o a "+ Agregar" si era el último (efecto en `ComparativaSheet`).

- **Clase: Adaptar** (la condición mira `disabled` porque aquí el disparador no se desmonta; el destino es el rótulo propio, como en `slep_idps`; el caso del chip es la misma falla fuera del modal).
- **Riesgo.** `tabIndex={-1}` en un `span` no cambia el orden de Tab; verificar que el lector anuncia el rótulo.
- **Verificación.** M5-A: tope + Agregar con Enter → foco en `SPAN.cmp-picker-label`; Enter sobre la ✕ de un chip → foco en la ✕ siguiente.

### F05 · Modal: botón ✕ de cierre con nombre accesible

1. **Problema.** No hay cierre en el encabezado; el único cierre visible es "Cancelar" al pie (con nombre por su texto) y Escape no cierra. En pantallas bajas el pie puede quedar lejos del foco visual.
2. **¿Existe?** En parte. M5: 0 botones en `.modal-header`; "Cancelar" existe y tiene nombre. Lo que falta es la convención de los hermanos (✕ arriba) y Escape (F03).
3. **Decisión propia.** Ninguna.
4. **Dependencia de la lógica de `slep_idps`.** Allí la ✕ del modo múltiple equivale a "Listo" (no pierde lo elegido, porque no hay selección local). Aquí la ✕ equivale a **Cancelar** en los dos modos, igual que el fondo, por la misma razón que F03.
5. **Forma adaptada.** `EntityModal`, dentro de `.modal-header`, tras el `h2`: `<button type="button" className="icon-btn" aria-label="Cerrar" title="Cerrar" onClick={onCancel}>✕</button>`. La clase `.icon-btn` ya existe en el template (hoy sin uso) y `.modal-header` ya es `justify-content: space-between`: no hace falta CSS nuevo.

- **Clase: Adaptar.**
- **Riesgo.** Ninguno de dato. Visual: el encabezado gana un botón (gate del titular).
- **Verificación.** Árbol de accesibilidad de Chrome: botón con nombre "Cerrar"; clic y Enter cierran sin agregar; el foco vuelve al origen (F03).

### F07 · Modal: con el tope alcanzado, quitar desde el modal

1. **Problema.** En el modal múltiple, al llegar al cupo se bloquean las filas no marcadas (bien), pero (a) desmarcar solo se puede con clic, (b) el aviso sigue diciendo "Selecciona hasta 10 territorios más · marcados: 10" (cuenta el cupo, no lo que resta), y (c) lo marcado en otra pestaña no se ve.
2. **¿Existe?** Sí. M5: con 10 marcadas, 335 filas bloqueadas, 0 marcadas visibles en la pestaña SLEP, sin franja, y el aviso incoherente citado. A diferencia de `slep_idps`, aquí siempre se puede volver a la pestaña de origen (cambiar de pestaña borra la búsqueda) y desmarcar allí: el problema de "no hay cómo quitar" no existe; sí el de no saber qué está marcado ni cuánto resta.
3. **Decisión propia.** c.30–c.32 del backlog (multiselección, tope 10, textos que leen la constante): se respetan.
4. **Dependencia de la lógica de `slep_idps`.** Su franja nace de un selector de dependencia por entidad que oculta filas marcadas; aquí no existe ese selector (la dependencia del comparador es un filtro global, `CmpDepFilter`).
5. **Forma adaptada.** (a) Queda resuelta por F02 (Espacio/Enter sobre una fila marcada). (b) `EntityModal`: el aviso usa lo que resta (`cupo - sel.length`), con plural por ternario en línea: "Selecciona hasta N territorios más · marcados: M"; con `cupo - sel.length === 0`: "Llegaste al máximo de 10 territorios. Desmarca uno para elegir otro." (c) **No se implementa la franja** (queda como idea, ver §2): basta con que el aviso diga cuántos hay marcados.

- **Clase: Adaptar** (teclado + aviso; la franja, inspirarse).
- **Riesgo.** Cambia un texto visible del modal múltiple (enumerado para 🔒7).
- **Verificación.** Con 10 marcadas: aviso = "Llegaste al máximo…"; Espacio sobre una marcada la desmarca y el aviso vuelve a "Selecciona hasta 1 territorio más · marcados: 9".

### F08 · Modal: las filas caben; el texto secundario cede ancho

1. **Problema.** En la pestaña Establecimiento el nombre (`.check-name`, `flex: 1`) y el secundario ("comuna · RBD", `.check-region`, sin `flex`) compiten; el secundario no cede y parte nombres que cabrían en una línea.
2. **¿Existe?** Sí. M5 (búsqueda "liceo", 60 filas): 1280 → 15 nombres partidos, 14 cabrían; 390 → 57 partidos, 37 cabrían; 320 → 59 partidos, 12 cabrían y 2 filas desbordan su caja. La página no desborda.
3. **Decisión propia.** Ninguna.
4. **Dependencia de la lógica de `slep_idps`.** Ninguna: mismas clases, mismo contenido secundario (lugar + código).
5. **Forma adaptada.** Template, CSS: `.check-name { … flex: 0 1 auto; min-width: 0; }` y `.check-region { flex: 1 1 0; text-align: right; }` (se conservan los tamaños y colores de este motor).

- **Clase: Adoptar.**
- **Riesgo.** El secundario pasa a alinearse a la derecha en todas las pestañas (Comuna muestra la región; SLEP, "Traspaso AAAA"; Región, "N comunas"): cambio visual en los dos modales, para el gate.
- **Verificación.** M5-B: nombres partidos que cabrían = 0 a 1280 (o solo los que no caben con el secundario mínimo), filas desbordadas = 0 a 320.

### F01 · Todo conteo visible con plural concordante

1. **Problema.** Tres textos escriben el plural a mano: la caja "Sin categoría vigente" ("1 establecimientos sin categoría en 2019"), la ficha del establecimiento ("1 matriculados en Educación Básica") y la cabecera de columna ("1 estudiantes"). El resto de los conteos ya concuerda con ternarios en línea (cabecera "establecimiento/s", narrativa, tooltip del comparador, aviso del modal).
2. **¿Existe?** Sí. M5: "1 establecimientos sin categoría" en 93 de 794 pares entidad × nivel (visto en la interfaz para la comuna de Alhué, básica); "1 matriculados" en 281 pares establecimiento × año; "1 estudiantes" en 0 casos con el dato actual (latente, pero depende de filtros y del dato futuro).
3. **Decisión propia.** Ninguna.
4. **Dependencia de la lógica de `slep_idps`.** `slep_idps` centraliza en ayudantes (`nEE`, `nCom`) porque su texto tiene decenas de conteos. Aquí son tres sitios y el estilo del archivo es el ternario en línea: se corrigen los tres con ternario, sin importar un ayudante.
5. **Forma adaptada.** `33_app.jsx`: `SinVigente` → `{fmtInt(total)} {total === 1 ? "establecimiento" : "establecimientos"} sin categoría en …`; `EeRow` (detalle) → `" " + (matNivel === 1 ? "matriculado" : "matriculados") + " en "`; `CatColumn` → `{matNivel === 1 ? " estudiante" : " estudiantes"}`.

- **Clase: Adaptar** (ternarios del estilo propio, no ayudante).
- **Riesgo.** Ninguno de dato.
- **Verificación.** M5-E en la interfaz: la comuna de Alhué (básica) dice "1 establecimiento sin categoría en 2019"; un EE × año con matrícula 1 dice "1 matriculado".

### D-03 · "Todos están en nivel de desempeño X" con un solo establecimiento

1. **Problema.** La narrativa usa "Todos están…" cuando hay una sola categoría presente, también si el total categorizado es 1 (una comuna con un EE, o un establecimiento elegido como entidad).
2. **¿Existe?** Sí. M5: 8.512 pares EE × nivel categorizados producen, con el EE como entidad, "…tiene 1 establecimiento con … categorizado…" seguido de "Todos están en nivel de desempeño X."
3. **Decisión propia.** Ninguna (la c.62 del backlog, sesión 12, creó la narrativa; no fija este caso).
4. **Dependencia de `slep_idps`.** Ninguna; es concordancia de número en el texto propio.
5. **Forma adaptada.** `narrativaTerritorial`, frase 2: si `total === 1`, "Está en nivel de desempeño X." (en vez de "Todos están…"). La redacción de la frase 1 con un EE como sujeto ("El establecimiento X tiene 1 establecimiento…") es tautológica, pero reescribirla es contenido nuevo: queda como observación en §2.

- **Clase: Adaptar.**
- **Riesgo.** Texto visible de la narrativa (enumerado para 🔒7).
- **Verificación.** Narrativa con un EE como entidad: "Está en nivel de desempeño …".

### F14 · Ninguna pantalla desplaza la página hacia el lado en 320–425 px

1. **Problema.** Con un establecimiento como entidad, su nombre va en la narrativa dentro de `.dato-destacado` (`white-space: nowrap`) y empuja la página hacia el lado en móvil.
2. **¿Existe?** Sí. M5: EE de nombre más ancho → 539 px de desborde a 320 y 469 a 390; muestra de 40 EE → 18 desbordan a 320 y 8 a 390. Apertura, modales y comparador con 10: 0 en los tres anchos (F13 presente).
3. **Decisión propia.** Ninguna.
4. **Dependencia de `slep_idps`.** Su corrección fue otra (la barra de pantallas); aquí la causa es el `nowrap` de la píldora de dato, que para cifras es deseable (no partir "6.277" ni "3,6%") y para un nombre largo no.
5. **Forma adaptada.** `narrativaTerritorial`: el ayudante `b()` recibe una variante para nombres (`bNom`) que agrega la clase `dato-nombre`; template: `.dato-destacado.dato-nombre { white-space: normal; overflow-wrap: anywhere; }`. Las cifras siguen sin partirse. Se aplica al nombre de la entidad en las frases 1 (y en la frase vacía).

- **Clase: Adaptar.**
- **Riesgo.** Una píldora con borde que se parte en dos líneas (el borde se dibuja por línea): gate visual a 320.
- **Verificación.** M5-B: `scrollWidth − clientWidth` = 0 a 320 y 390 con el EE de nombre más ancho y con la muestra de 40.

### F12 · Anillo de foco visible en todos los controles, ≥ 3:1

1. **Problema.** El motor no define anillo para botones: queda el automático de Chrome, que sobre los controles rellenos de `--ocean` se confunde con el relleno.
2. **¿Existe?** Sí, acotado. M5: "+ Agregar" 1,21:1 y chip de filtro activo 1,19:1 (los dos rellenos de `--ocean`); chip inactivo 5,98; segmentado activo 5,98; "Limpiar" 5,56; ✕ del chip 5,98.
3. **Decisión propia.** Ninguna de paleta: el motor ya tiene su propia regla de anillo, `.select:focus, .input:focus { outline: 2px solid var(--ocean); outline-offset: 1px; }`, que hoy no alcanza a ningún control vivo.
4. **Dependencia de `slep_idps`.** Su token `--foco` es el mismo `#0062A0` que aquí es `--ocean`; su anillo crema de la ficha responde a una barra oscura que aquí no existe.
5. **Forma adaptada.** Template: extender la regla propia a `:focus-visible` de `button`, `[role="button"]`, `[tabindex]` y `.check-row` con `outline: 2px solid var(--ocean); outline-offset: 2px;` (con separación de 2 px el anillo queda sobre crema o papel, ≈ 6:1, y no sobre el relleno). Filas del modal: `outline-offset: -2px` (F02). Sin color nuevo.

- **Clase: Adaptar** (token y regla propios).
- **Riesgo.** Cambia el aspecto del foco en todos los controles (solo con teclado).
- **Verificación.** M5-D: contraste máximo anillo vs debajo ≥ 3 en los siete controles, incluidos los dos rellenos de `--ocean`.

### F11 · Contraste de los textos de estado

1. **Problema.** Textos que llevan estado usan los colores de relleno de la paleta ordinal: blanco (con opacidad 0,92/0,82) sobre la cabecera de cada categoría, el % máximo del comparador en `--ocean` sobre su tinte, el delta negativo de la matrícula en `#EE2D49` y la ✕ del chip en blanco sobre `#EE2D49` al pasar el cursor.
2. **¿Existe?** Sí. M5: cabeceras (título/stat/mat) Insuficiente 4,11/3,67/3,16, Medio-Bajo 2,62/2,44/2,23, Medio 3,48/3,19/2,85, Alto 6,45/5,72/4,89; % máximo 2,07–3,51 (n = 4); delta negativo 3,97; ✕ al pasar 4,11.
3. **Decisión propia.** `20260612_decision_paleta_categorias.md` fija los cuatro hex y afirma "Contraste AA" sobre crema (validado como relleno, no como fondo de texto).
4. **Dependencia de `slep_idps`.** Su solución son **tokens `-txt` nuevos** (hex nuevos, más oscuros) para su paleta de estado de tres valores; aquí la paleta es ordinal de cuatro y el encargo prohíbe colores nuevos.
5. **Forma adaptada (evaluada, no implementable sin decisión).** Con tintas existentes: `--ink` sobre Insuficiente da 4,46:1 (bajo 4,5), sobre Medio-Bajo 7,01, sobre Medio 5,27; blanco sin opacidad sobre Insuficiente 4,11. **Ninguna tinta existente lleva la cabecera de Insuficiente a 4,5:1**; el % máximo y el delta solo se resuelven quitando el color que codifica el estado (pasar a `--ink` con peso), que es un cambio de codificación visual sobre una UI aprobada.

- **Clase: Diferir** (requiere color nuevo o cambiar la codificación; toca una decisión escrita). Pregunta en §4 (Q-F11).

### F09 · Cada cifra nombra su universo

1. **Problema.** "Sin categoría vigente" es, en la vista por territorio, el conteo oficial de s/i (con motivo) y, en el comparador, s/i **más** los sin medición en 2019, con el mismo rótulo. La fila Región del modal dice "N comunas" (catálogo).
2. **¿Existe?** La primera parte sí: M5, 29 de 72 pares SLEP × nivel con cifras distintas (190 de 794 pares entidad × nivel). La segunda **no**: un clic después no aparece otra cifra de comunas (los chips del filtro no son un número; además coinciden en básica en 16 de 16 regiones).
3. **Decisión propia.** Nota v07 y c.40 del backlog: tres grupos distintos (categoría real, s/i, sin medición) y el conteo oficial **no** suma los sin medición. El comparador los suma; cambiar su cifra o su universo es metodológico y el encargo lo excluye ("nada que cambie una cifra").
4. **Dependencia de `slep_idps`.** "En el directorio" es su universo; aquí el universo es el conteo oficial de la Agencia o el catálogo territorial.
5. **Forma adaptada.** Ninguna sin decisión: alinear la cifra cambia un número publicado; renombrar la fila fija un universo.

- **Clase: Diferir** (primera parte); **No aplica** (fila Región). Pregunta en §4 (Q-F09).

### F18 · Mayúsculas sostenidas solo en siglas

1. **Problema.** Los nombres de establecimientos y de comunas se muestran en mayúsculas, tal como vienen del dato, en el modal, las filas, los chips y la narrativa.
2. **¿Existe?** Sí. M5: 9.040 de 9.040 nombres de EE y 345 de 345 comunas en mayúsculas; regiones y SLEP no. En los nombres de EE hay 1.371 formas distintas con aspecto de sigla o abreviatura (con punto, con guion y número, o cortas en mayúscula).
3. **Decisión propia.** `20260611_decision_nombres_establecimientos.md` habilita mostrar el `Nombre Establecimiento` publicado por la Agencia; no regula la caja. La c.33(e) del backlog retiró las mayúsculas **del CSS** (rótulos), no las del dato.
4. **Dependencia de `slep_idps`.** Su `tc()` usa una lista corta de siglas propia de su dominio (`SLEP`, `GSE`, `RBD`, `IDPS`…). Aquí la lista tendría que cubrir abreviaturas de nombres de escuelas (letra-número, "E.", "C.E.I.A.", números romanos) y partículas de comuna ("del", "de la"); además, los nombres de región del dato vienen sin tildes, algo que un paso a formato título no arregla.
5. **Forma adaptada.** Ninguna sin decisión: transformar la forma de un nombre oficial y fijar la regla de siglas es de producto.

- **Clase: Diferir.** Pregunta en §4 (Q-F18).

### F19 · Hash del payload con fecha normalizada como invariante de build

1. **Problema.** Saber, tras un build que no debía tocar datos, que el payload no cambió.
2. **¿Existe?** Resuelto de otra forma: `tests/auditar_cifras.R` (F1–F4, dos caminos, todo el parquet) y `tests/spot_check_publicado.R` (celdas ancla del HTML publicado contra el crudo), versionados. Falta la comparación de **todo** el JSON embebido entre builds.
3. **Decisión propia.** Protocolo 4.5 del proyecto (auditoría por valor).
4. **Dependencia de `slep_idps`.** Allí es una convención manual; aquí ya hay pruebas versionadas del dato.
5. **Idea.** Este encargo construyó y calibró el instrumento (`/tmp/cat_a1_payload.js`: fecha alterada → mismo SHA; una cifra plantada → otro). Podría versionarse como `tests/hash_payload.R` que escriba el SHA-256 normalizado en el reporte. `tests/` está fuera del alcance de a1 (🔒4).

- **Clase: Inspirarse.**

### D-08 · ¿El modal debe ofrecer la entidad nacional?

1. **Problema.** El payload trae el agregado nacional y la nota metodológica lo menciona, pero el modal no lo ofrece.
2. **¿Existe?** No como falla de uso hoy: la opción se retiró a propósito.
3. **Decisión propia.** Backlog, nota v03 y c.21: "eliminada la categoría 'nacional' del selector" (por el volumen de establecimientos a listar). El patrón F06 (pestaña Nacional sin buscador) contradice esa decisión escrita.
4. **Dependencia de `slep_idps`.** Su pestaña Nacional no lista establecimientos; aquí la vista por territorio sí lista todos los EE de la entidad, que es la razón de c.21.
5. **Forma adaptada.** Ninguna; el encargo excluye crear la entidad nacional en el modal.

- **Clase: Diferir** (contradice c.21). Pregunta en §4 (Q-D08).

### D-13 · ¿Nombrar el nulo por su motivo en toda superficie?

1. **Problema.** El nulo tiene dos orígenes (s/i con motivo; sin medición). La trayectoria (`title` de cada marca), la ficha ("Sin categoría · motivo" / "Sin medición") y la caja "Sin categoría vigente" (conteo por motivo) ya lo nombran; la leyenda y la fila del comparador usan una glosa común.
2. **¿Existe?** En la fila del comparador, y es el mismo problema de F09.
3. **Decisión propia.** c.40 del backlog (tres grupos).
4. **Dependencia de `slep_idps`.** Su nulo es "sin comparación válida" frente al GSE; aquí es "sin categoría" publicada por la Agencia.
5. **Forma adaptada.** Depende de Q-F09.

- **Clase: Diferir** (se resuelve junto con Q-F09).

### D-22 · ¿La Categoría tiene fase preliminar?

1. **Problema.** Si la categorización con Simce 2025 llega como preliminar, el motor no tiene cómo marcarla.
2. **¿Existe?** No hoy: 2016–2019 es definitiva y el payload no trae marca.
3. **Decisión propia.** `20260612_decision_cobertura_temporal.md` (el vigente se recalcula solo al entrar 2025).
4. **Dependencia de `slep_idps`.** Su `anios_preliminar` es propio de su fuente.
5. **Forma adaptada.** Ninguna: el encargo excluye crear marca de preliminar.

- **Clase: Diferir** (hecho que solo el titular puede confirmar). Pregunta en §4 (Q-D22).

### D-24 · ¿Verificación parcial por celdas ancla, o comparar todo el payload?

1. **Problema.** El tramo parquet → JSON → HTML se comprueba en 7 celdas ancla; el resto del JSON no se compara entre builds.
2. **¿Existe?** Sí, acotado: la auditoría F1–F4 cubre todas las cifras a nivel parquet; el hueco es el JSON completo.
3. **Decisión propia.** Protocolo 4.5.
4. **Dependencia de `slep_idps`.** Ninguna.
5. **Idea.** La misma de F19: versionar el SHA normalizado junto al spot-check.

- **Clase: Inspirarse.**

## 2. Observaciones fuera del inventario (no se implementan en a1)

- La franja de lo elegido de `slep_idps` (F07) podría servir si el modal múltiple crece; hoy basta el aviso.
- Narrativa con un EE como sujeto: "El establecimiento X tiene 1 establecimiento con … categorizado…" es tautológica (D-03 corrige solo "Todos están").
- Narrativa: con matrícula del nivel solo en Medio-Bajo, la frase 3 queda "Considerando la matrícula 2025, ." (hallazgo de la matriz §6; no re-medido aquí).
- Nota metodológica "Cobertura temporal": "y el**Simce 2022**" sin espacio (la fuente JSX y el template lo tienen igual).
- Los nombres de región del payload vienen sin tildes (generador: fuera de alcance).
- La decisión de paleta afirma "Contraste AA" sobre crema; Medio-Bajo como relleno da menos de 3:1 contra crema (matriz §6; no re-medido aquí). Conviene enmendar la afirmación cuando se decida Q-F11.

## 3. Resumen

### 3.1 Fichas por clase

| Clase | Fichas |
|---|---|
| Adoptar (2) | F02, F08 |
| Adaptar (8) | F01, F03, F04, F05, F07, F12, F14, D-03 |
| Inspirarse (2) | F19, D-24 |
| No aplica (0 fichas; 1 parte) | la fila Región de F09 |
| Diferir (6) | F09, F11, F18, D-08, D-13, D-22 |

Ninguna ficha *adoptar* o *adaptar* cambia una cifra, el payload o la metodología, agrega un color (todas usan `--ocean`, `.icon-btn` y clases existentes), crea exportación, entidad nacional, marca de preliminar o segmentación, ni toca el generador o el pipeline 30–32.

### 3.2 Lo que T2 implementará cuando se descongele (orden)

Precondición: resolver D-M4 (sincronizar `33_app.jsx` con el template: `var(--fs-base)` → `var(--fs-body)`) y volver a medir M4 hasta render idéntico.

1. Modal y foco: F02 → F03 → F04 → F05 → F07.
2. Ancho: F08 → F14.
3. Textos: F01 → D-03.
4. Anillo: F12.

Pantallas que cambian (fuera del 🔒7): los dos modales (02, 03, 04, 07, 08) y la narrativa con un EE (05). Pantallas que no deben cambiar: 01 (apertura), 06 (comparador vacío), 09 (comparador con 10), salvo el anillo, que solo se ve con foco de teclado. Cadenas nuevas o cambiadas en `textContent`: "Cerrar" (✕), el aviso del modal múltiple, "establecimiento/matriculado/estudiante" en singular, "Está en nivel de desempeño".

### 3.3 Dudas con pregunta cerrada

Se listan en §4.

## 4. Dudas

| Id | Contexto | Pregunta cerrada | Qué queda bloqueado |
|---|---|---|---|
| D-M4 | `33_app.jsx` diverge del template desde `91ff8ed` (buscador del modal: `--fs-base` inexistente) | ¿Autoriza un encargo que corrija en `33_app.jsx` `fontSize: "var(--fs-base)"` → `"var(--fs-body)"`, verifique M4 = render idéntico y recién entonces ejecute T2/T3 de este plan? Sí / No | T2 y T3 completas |
| Q-F11 | Ninguna tinta existente lleva la cabecera de Insuficiente a 4,5:1 (`--ink` 4,46; blanco 4,11) | ¿(A) se crean tokens de texto por categoría (hex nuevos, enmienda a la decisión de paleta), (B) se acepta `--ink` sobre Insuficiente, Medio-Bajo y Medio con 4,46:1 en Insuficiente como excepción escrita, o (C) se deja como está? | F11 |
| Q-F09 | "Sin categoría vigente" = s/i oficial en la vista por territorio y s/i + sin medición en el comparador (29/72 SLEP × nivel distintos) | ¿(A) el comparador cuenta solo los s/i oficiales, (B) conserva su cifra y la fila pasa a llamarse "Sin categoría en 2019 (incluye sin medición)", o (C) muestra dos filas separadas? | F09, D-13 |
| Q-F18 | Nombres de EE y comunas en mayúsculas del dato; 1.371 formas tipo sigla | ¿Se muestran los nombres en formato título con una lista de siglas y partículas escrita en una decisión propia? Sí / No | F18 |
| Q-D08 | c.21 retiró "nacional" del selector | ¿Se mantiene la exclusión de la entidad nacional en el modal? Sí / No | D-08 |
| Q-D22 | Categoría con Simce 2025 | ¿La Agencia publicará la próxima categorización primero como preliminar? Sí / No | D-22 (futuro) |

## 5. Lo que este motor hace mejor (para `slep_idps`; sin cambios aquí)

- **Pruebas del dato versionadas y por dos caminos**: `tests/auditar_cifras.R` recalcula cada cifra publicada desde el crudo con código distinto al del pipeline (F1–F4) y `tests/spot_check_publicado.R` descomprime el HTML publicado y lo coteja con el crudo. `slep_idps` mide a mano con instrumentos en `/tmp`.
- **Motor sin red**, con React y ReactDOM en línea y JS ya transpilado, y la fuente JSX versionada con equivalencia verificada por AST (aunque este encargo mostró que la equivalencia debe re-medirse en cada encargo: la migración tipográfica de v29 la rompió).
- **El nulo con motivo y en grupos separados** (s/i con motivo publicado; sin medición aparte; ambos fuera del denominador), visibles en la trayectoria (`title` con motivo), la ficha y la caja de sin categoría.
- **Conteo de EE declarado como elección** en las notas, con la pregunta que responde y la que no.

## 6. Resoluciones del titular y estado de implementación (a2)

Encargo `encargo_claude_code_categoria_alineamiento_motores_a2.md`; LOG `50_documentacion/andamios/logs/20260925_alineamiento_motores_a2_log.md`. Resoluciones de la sesión 30 del chat (2026-09-25):

| Duda del plan | Resolución | Efecto en a2 |
|---|---|---|
| D-M4 | Sí: sincronizar `33_app.jsx` con el template | T0 |
| Q-PUSH (a1) | Sí; ejecutado por el titular (`3afd23a..51447ce`) | ninguno |
| Q-F11 | B: `--ink` en las cabeceras de Insuficiente, Medio-Bajo y Medio; Insuficiente ≈ 4,46:1 como excepción escrita; % máximo, delta negativo y ✕ del chip quedan como están | T2.1 y `decisiones/20260925_decision_contraste_texto_categorias.md` |
| Q-F09 | B: el comparador conserva su cifra; la fila pasa a "Sin categoría en {año vigente} (incluye sin medición)"; resuelve también D-13 | T2.2 |
| Q-F18 | No: los nombres se muestran con las mayúsculas del dato | cerrada |
| Q-D08 | Se mantiene la exclusión de la entidad nacional del modal (c.21) | cerrada |
| Q-D22 | Abierta (depende de la Agencia) | ninguno |
| D-03, frase 1 | Corregir la frase 1 cuando el sujeto es un establecimiento | T2.3 |

Estado por ficha (mediciones del LOG a2: antes = M5 de FASE 0; después = verificación del grupo):

| Ficha | Estado | Commit | Medición antes → después |
|---|---|---|---|
| D-M4 | implementada | `b19d0f0` | retranspilación vs template: render distinto en 5 pantallas con modal → render idéntico (9/9 AE=0 a 1280 y 390) |
| F02 | implementada | `f46ed48` | filas con tabIndex 0/345 → 345/345; filas alcanzadas por Tab 0 → sí; Espacio/Enter marcan |
| F03 | implementada | `f46ed48` | Tab sale del modal → 0 paradas fuera en 400 Tab; Escape no cierra → cierra; foco tras cerrar BODY → botón de origen |
| F04 | implementada | `f46ed48` | tope → BODY → rótulo "Territorios a comparar"; quitar chip → BODY → ✕ siguiente o "+ Agregar" |
| F05 | implementada | `f46ed48` | 0 botones en el encabezado → ✕ con nombre "Cerrar" |
| F07 | implementada | `f46ed48` | aviso con 10 "Selecciona hasta 10 territorios más · marcados: 10" → "Llegaste al máximo de 10 territorios. Desmarca uno para elegir otro."; desmarcar con Espacio |
| F08 | implementada | `a222203` | nombres partidos que cabrían con el secundario mínimo: 11 / 12 / 2 (1280 / 390 / 320) → 0 / 0 / 0; filas desbordadas a 320: 2 → 0 |
| F14 | implementada | `a222203` | desborde con el EE de nombre más ancho: 539 / 469 px (320 / 390) → 0 / 0; muestra de 40: 18 / 8 → 0 / 0 |
| F01 | implementada (ampliada al verbo "No entra/No entran" de la misma frase) | `c94971f` | "1 establecimientos sin categoría" en 93 pares → "1 establecimiento … No entra …"; "1 matriculados" → "1 matriculado"; "1 estudiantes" latente con ternario |
| D-03 | implementada | `c94971f` | "Todos están…" con un EE → "Está en nivel de desempeño …" |
| F12 | implementada | `26ca8cd` | anillo sobre rellenos de `--ocean`: 1,21 / 1,19 → 5,99 / 5,99; los siete controles ≥ 5,99 |
| F11 (Q-F11 B) | implementada | `3848cfc` | cabeceras Insuficiente 4,11/3,67/3,16 → 4,46; Medio-Bajo 2,62/2,44/2,23 → 7,01; Medio 3,48/3,19/2,85 → 5,27; Alto sin cambio |
| F09 y D-13 (Q-F09 B) | implementada | `3848cfc` | rótulo "Sin categoría vigente" → "Sin categoría en 2019 (incluye sin medición)"; cifras idénticas |
| D-03 frase 1 | implementada | `3848cfc` | "El establecimiento … tiene 1 establecimiento con … categorizado…" → "El establecimiento … tiene Educación Básica categorizada al año 2019…" (y el caso vacío) |
| F18 | cerrada (Q-F18 No) | — | sin cambio |
| D-08 | cerrada (Q-D08: se mantiene c.21) | — | sin cambio |
| D-22 | diferida (Q-D22 abierta) | — | sin cambio |
| F19, D-24 | inspirarse (sin cambio) | — | sin cambio |
