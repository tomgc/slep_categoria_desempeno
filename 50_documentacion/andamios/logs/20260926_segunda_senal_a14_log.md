# LOG — segunda señal en la trayectoria (altura según la categoría), y despliegue (a14)

- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_categoria_segunda_senal_a14.md`
- **Ejecutor:** Claude Code, modo autónomo, todo en un turno, sin subagentes, esfuerzo `xhigh`, sobre el filesystem local de la estación (macOS).
- **Modo de la sesión (declarado por el encabezado de contrato):** la sesión corre con el modelo Opus 5.5 (1M) y el esfuerzo `ultracode` (`xhigh` más orquestación dinámica de workflows). Manda el encargo: orquestador el modelo de la sesión, 0 subagentes, 0 workflows, cadena en serie.
- **Acto externo autorizado en el lanzamiento (D5 = a):** un único `git push origin main` en FASE L, solo con el simulacro del hook en exit 0 y sin `--no-verify` ni `--force`. Cualquier otro acto externo se consulta.
- **Fecha:** 2026-09-26.
- **Punto de retorno `<inicio>`:** se fija en M3.
- **Rama:** `main`.
- **Convención de rutas:** `<RAIZ>` es la raíz del repositorio. Ninguna ruta absoluta de la estación entra a este LOG.

## Índice

- FASE 0
- T1: altura según la categoría
- T2: despliegue
- FASE R: auditoría propia y reparación
- FASE L: cierre del log
- J. Juicio

### FASE 0

Primer acto: LOG creado con encabezado, esqueleto y el slot vacío del bloque J, antes de cualquier comando git del turno. El primer script (`/tmp/cat_a14_m12.sh`) exporta `GIT_OPTIONAL_LOCKS=0` en su primera línea; su única llamada git anterior al `fetch` es `git rev-parse --show-toplevel`, que exige ENTORNO. El `fetch` corrió con `-c maintenance.auto=false`.

| # | Medición | esperado | obtenido |
|---|---|---|---|
| M1 | rama; porcelain; stash | `main`; las líneas de §2; vacío | `main`; ` M` del archivo de errores; `??` de la decisión, del encargo y del LOG (4 líneas); stash con 0 líneas. PASA |
| M2 | `fetch`; `HEAD`; `origin/main`; deltas; ENTORNO; filas; md5 de la decisión | exit 0; `eb18baa` = `origin/main`; 0 y 0; ENTORNO; 10 filas; `6f356181…` | fetch exit 0; `HEAD` = `origin/main` = `eb18baabc0fd4e081811cc24ad4dc540c02dda74`; 0 y 0; `slep_categoria_desempeno` y la URL de ENTORNO; 10 filas; decisión `6f356181f6013cd37d535a3334389b74`. PASA |
| M3 | commit de FASE 0; `<inicio>`; md5 de la app, del template y de `docs` | 3 archivos; `07066acf…`, `1b615464…`, `018f6365…` | commit `1f167d6cb727e9e1d464b24ff8165ce060ec3231` con exactamente la decisión, el encargo y el archivo de errores (privacidad previa: RUT 0 y `$HOME` 0 en los tres); `<inicio>` = `1f167d6`; `33_app.jsx` `07066acf9bbc0ae827b49d111b3d9066`, template `1b615464115cdaefb384c206c1a4f620`, `docs/index.html` `018f63657c227036899ae3194bf9c68e`. Líneas de referencia iguales a §1: `function Trayectoria` en la 956, su uso en la 1055, la leyenda en la 2013, `CATEGORIAS` en la 49, `.traj-mark` en la 581, `.traj-legend-sw` en la 906, `box-sizing: border-box` en la 125; 0 apariciones de `traj-bar`. PASA |
| M-DERIVA | retranspilación frente al bloque | idéntica, `84d079b7…`, 1614 líneas | Babel copiado de `/tmp/cat_a12_babel` a `/tmp/cat_a14_babel` con la configuración de la POSICIÓN; `template 84d079b74d35d93e0412f457020fc066 1614 lineas \| retrans 84d079b74d35d93e0412f457020fc066 1614 lineas \| distintas: 0`. PASA |
| M4 | base: build, copia, estados del 🔒4 y modal, dos corridas | dos corridas iguales; en la base, marcas de 18 × 18 | PRUEBAS a exit 0, 0 warnings; motor `018f6365…` (1888877 bytes) en `/tmp/cat_a14_base.html`; `docs` sin cambios. Estados: `s1280` (Costa Central, básica: 62 `.traj`, 248 marcas), `s390` (62 y 248), `sc1280` (elegido por programa: OVALLE; ver abajo) y `m390`; 0 errores de consola. Dos corridas: CSSOM igual (232 reglas); `textContent` igual en los 4 estados; marcas (título, alto, ancho, `bottom`, fondo, `box-shadow`, clases) y rótulos iguales en los 3; capturas con AE 0 en 8 de 10: `s1280` ventana y trayectoria, `s390` ventana, trayectoria y alta, `sc1280` trayectoria y alta, y `m390`. Las otras dos, `s1280` alta y `sc1280` ventana, dieron AE 183.6 y 141.0 (hallazgo registrado abajo). En la base, **820 de 820 marcas miden 18 × 18** y la leyenda tiene 5 muestras de 16 × 16. Se registra |
| M5 | PRUEBAS b y c sobre la base | verde; `d9895a78…0442` | `auditar_cifras.R` exit 0, F1 a F4 OK, 0 warnings; `spot_check_publicado.R` exit 0, 6 celdas y 1 ausencia; SHA `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442` (fecha alterada igual; cifra `162ff49e…`). PASA |

**Instrumentos:**
- `/tmp/cat_a14_medir.js` mide por `file://` con transiciones y animaciones desactivadas. Hace capturas de ventana, de ventana alta y de la trayectoria (ventana con la primera `.traj` centrada), nunca `fullPage` (D6 = sí). El CSSOM se toma antes de inyectar el estilo.
- `/tmp/cat_a14_cmp.js` compara en tres modos: determinismo, base, y candados 🔒4 a 🔒6.

**Tercer estado del 🔒4, elegido por programa desde el payload.** Para cada una de las comunas de `CatData.COMUNA_BY_COD` se cuentan, con `CatData.getEstablecimientos({kind: "comuna", cod}, "basica")`, los establecimientos con `vigente` igual a `"s/i"` o nulo. Se ordenan por ese conteo descendente y luego por código. Resultado: 303 comunas candidatas. La primera es OVALLE (38 de 81), seguida de CARAHUE (33 de 47) y QUELLÓN (29 de 42). La comuna se selecciona en el modal (pestaña «Comuna», búsqueda del nombre y clic en la fila con ese `.check-name` exacto). En ese estado hay 81 `.traj`, 324 marcas (142 «sin categoría») y 38 filas en las listas sin vigente. Las etiquetas de `CatData.CAT_LABELS`, en el orden de `CATEGORIAS`, son «Insuficiente», «Medio-Bajo», «Medio» y «Alto», las del mapa del 🔒4 (a).

**Hallazgo de M4 (se registra).** Las dos capturas con AE distinto de 0 entre corridas difieren solo en una franja de texto de la barra de controles (y 286 a 298, x 40 a 747: «Vista», «Por territorio», «Comparar territorios», «Territorio»). Son píxeles de borde de las letras (PAE 0.63), con el mismo texto a la vista: rasterización del texto con desplazamiento subpíxel distinto entre corridas, no las marcas. Ningún 🔒 depende de esas dos capturas: el 🔒4 mide la geometría por DOM y el 🔒6 usa el `textContent` y la captura del modal, y ambos son deterministas; también lo son las capturas de la trayectoria.

M1
esperado: `main`; porcelain con las líneas de §2 y el LOG; stash vacío
obtenido: `main`; esas 4 líneas; stash con 0 líneas. PASA

M2
esperado: fetch exit 0; `eb18baa` = `origin/main`; 0 y 0; ENTORNO; 10 filas; decisión `6f356181…`
obtenido: fetch exit 0; `eb18baa` = `origin/main`; 0 y 0; ENTORNO; 10 filas; `6f356181f6013cd37d535a3334389b74`. PASA

M3
esperado: commit = 3 archivos; `07066acf…`, `1b615464…` y `018f6365…`
obtenido: `1f167d6` con 3 archivos; los tres md5 iguales. PASA

M-DERIVA
esperado: bloque del template = retranspilación, `84d079b7…`, 1614 líneas
obtenido: `84d079b74d35d93e0412f457020fc066`, 1614 líneas, 0 distintas. PASA

M4
esperado: dos corridas iguales; en la base, todas las marcas de 18 × 18
obtenido: CSSOM, `textContent` y marcas iguales en las dos corridas; capturas con AE 0 en 8 de 10 (las 2 restantes, por la franja de texto de la barra de controles; registrado); 820 de 820 marcas de 18 × 18. Se registra

M5
esperado: PRUEBAS b en verde; SHA `d9895a78…0442` con calibración
obtenido: verde; `d9895a78…0442`, calibración correcta. PASA

**Cierre de FASE 0:** ninguna regla de detención activa.

### T1: altura según la categoría

- **ALCANCE:** `30_procesamiento/33_app.jsx` y `30_procesamiento/33_motor_template.html`.
- **Cambios en `33_app.jsx`** (con la herramienta de edición, sobre el JSX):
  - **J1:** antes de `function Trayectoria`, el comentario `a14-B`, `const TRAJ_ALTURA_BASE = 7;`, `const TRAJ_ALTURA_PASO = 6;` y `function alturaTrayectoria(categoria)`, con el cuerpo de §1.
  - **J2:** la marca va envuelta en `<span className="traj-bar">`, con `style` = `esSi ? { height: alturaTrayectoria(null) } : { background: color, height: alturaTrayectoria(p.categoria) }`. `className` y `title` sin cambio; solo se reindentan por el envoltorio.
  - **J3:** en la leyenda, cada `traj-legend-sw` va envuelto en `.traj-bar`; las categorías llevan `height: alturaTrayectoria(c)` y «Sin categoría», `style={{ height: alturaTrayectoria(null) }}`.
- **Cambios en el `<style>`:**
  - **C1:** el comentario `a14-B` y `.traj-bar { height: 25px; display: inline-flex; align-items: flex-end; }`, justo antes de `.traj-mark {`.
  - **C2:** `.traj-mark` pasa de `width: 18px; height: 18px;` a `width: 16px;`.
  - **C3:** `.traj-legend-sw` pasa de `width: 16px; height: 16px;` a `width: 14px;`.
- **T, retranspilación** (`/tmp/cat_a14_retranspilar.py`). Babel en `/tmp/cat_a14_babel` sobre el `33_app.jsx` completo; el bloque nuevo es su salida desde `"use strict";`, y reemplaza entero el bloque viejo, que iba entre el `  <script>` que sigue al comentario «Aplicación React (» y el `  </script>` siguiente. Bloque viejo: líneas 948 a 2561, 1614 líneas; bloque nuevo: 1635. Nada del bloque se editó a mano. Template resultante: `a1b5fe268366fc3b204af94a8371dcb7`, 111786 bytes, 2585 líneas. `33_app.jsx` resultante: `ac828eb65b82654b9eee5c1a1c7d4f1b`.

esperado: 🔒1 por archivo: en `33_app.jsx`, solo J1 a J3; en el `<style>`, solo C1 a C3; fuera del `<style>`, el template solo cambia en el bloque de la app
obtenido: `/tmp/cat_a14_candado1.py`: el prefijo hasta `<style>` (8 líneas), el tramo entre `</style>` y el bloque (32) y el sufijo (4) son iguales a `<inicio>`. El `<style>` tiene 3 cambios, exactamente C1 (inserción de 2 líneas, justo antes de `.traj-mark {`), C2 y C3; el comentario de C1 solo tiene el `*/` de cierre. `33_app.jsx` tiene 4 bloques de cambio, 0 fuera de J1 a J3, todas las piezas presentes y 3 `traj-bar`. Numstat: `33_app.jsx` `42	26`; template `32	9` (4 más y 2 menos en el `<style>`; 28 más y 7 menos en el bloque). PASA

esperado: 🔒2: el bloque de la app del template es idéntico a la retranspilación del `33_app.jsx` nuevo
obtenido: `M-DERIVA [t1]: template 96e583b258e65830da3f60fdf4326f7a 1635 lineas | retrans 96e583b258e65830da3f60fdf4326f7a 1635 lineas | distintas: 0`. PASA

esperado: PRUEBAS a: exit 0 y 0 warnings
obtenido: exit 0; 0 warnings; renv activo; `Paso 33 OK`; motor `a89e47e09499022a2d2ac121b63796fd`, 1889960 bytes (base 1888877; +1083). PASA

esperado: 🔒3: PRUEBAS b y c; payload sin cambio; `meta.cat_colors` igual
obtenido: SHA `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442` (fecha alterada igual; cifra `162ff49e…`); «payload igual salvo la fecha: True»; `meta.cat_colors` igual a la base (`INSUFICIENTE #D0112D`, `MEDIO-BAJO #E05D2F`, `MEDIO #2A8FD9`, `ALTO #0062A0`); `auditar_cifras.R` exit 0, F1 a F4 OK, 0 warnings; `spot_check_publicado.R` con `docs` = build de T1: exit 0, 6 celdas y 1 ausencia. PASA

esperado: 🔒4 (a) a (e) en `s1280`, `s390` y `sc1280`, contra el mapa de alturas y la base de M4
obtenido: con `/tmp/cat_a14_cmp.js candados`, 820 marcas, 0 desalineadas con la base.
- (a) Insuficiente: 81 marcas, todas de 7; Medio-Bajo: 255, todas de 13; Medio: 250, todas de 19; Alto: 38, todas de 25; «Sin categoría…»: 196, todas de 7. 0 fuera de tolerancia.
- (b) 0 `.traj` con rótulos o bases desalineados.
- (c) 0 marcas con ancho distinto de 16.
- (d) 205 vigentes, 0 con `box-shadow` distinto de la base.
- (e) leyenda: Insuficiente 14 × 7, Medio-Bajo 14 × 13, Medio 14 × 19, Alto 14 × 25, Sin categoría 14 × 7.

PASA

esperado: calibración del 🔒4: la copia del motor con `TRAJ_ALTURA_PASO` en 0, fuera del árbol, hace fallar el (a)
obtenido: `/tmp/cat_a14_t1_paso0.html` (1 aparición reemplazada): Medio-Bajo, Medio y Alto quedan en 7; (a) con `fuera de tolerancia 543 → FALLA`; (e) también `FALLA`. La calibración discrimina. PASA

esperado: 🔒5: colores de las marcas iguales a la base por etiqueta; CSSOM distinto solo en `.traj-bar` (nueva), `.traj-mark` y `.traj-legend-sw`
obtenido: 0 marcas de categoría con `background-color` distinto de la base; la leyenda tiene los mismos colores y textos. CSSOM: 232 → 233 reglas; solo en la base, `.traj-mark` y `.traj-legend-sw`; solo en la nueva, `.traj-bar`, `.traj-mark` y `.traj-legend-sw`; 0 selectores fuera de esos tres; el resto en el mismo orden. PASA

esperado: 🔒6: `textContent` idéntico en los estados medidos; modal a 390 × 844 con AE = 0; 0 errores de consola
obtenido: `textContent` igual en `s1280`, `s390`, `sc1280` y `m390`; modal con AE 0; 0 errores. Informativo: las capturas de ventana de `s1280` y `sc1280` difieren de la base por diseño (AE 1823, las marcas cambian); la de `s390` da AE 0, porque en la primera pantalla a 390 px no hay trayectorias. PASA

esperado: `git restore docs/index.html`
obtenido: restore exit 0; md5 `018f63657c227036899ae3194bf9c68e`; porcelain: ` M` de las dos rutas y el LOG. PASA

- **Commit** `feat(motor): la altura de la marca de la trayectoria codifica la categoría (a14 T1)` = `730a7b67e809e3726ba2242a04376ce231c52d04`, con las dos rutas (numstat `42	26` y `32	9`). RUT 0 y `$HOME` 0 en lo agregado.
- **T1: completada.**

### T2: despliegue

- Corre porque T1 terminó en verde. **ALCANCE:** `docs/index.html`. Build con PRUEBAS a (`/tmp/cat_a14_t2.sh`); `docs/index.html` queda con el build nuevo.

esperado: PRUEBAS a exit 0 y 0 warnings
obtenido: exit 0; 0 warnings; renv activo; `Paso 33 OK`. PASA

esperado: 🔒7: md5 de `docs/index.html` = md5 de `40_salidas/motor_categoria.html`
obtenido: `a89e47e09499022a2d2ac121b63796fd` = `a89e47e09499022a2d2ac121b63796fd`; `docs` idéntico al motor de T1; 1889960 bytes. PASA

esperado: PRUEBAS b y c sobre `docs/index.html`
obtenido: SHA `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442` (fecha igual; cifra `162ff49e…`); `auditar_cifras.R` exit 0, F1 a F4 OK, 0 warnings; `spot_check_publicado.R` exit 0, 6 celdas y 1 ausencia. PASA

esperado: por `file://`, 0 errores y el 🔒4 repetido
obtenido: sobre `<RAIZ>/docs/index.html`, 0 errores de consola. El 🔒4 da lo mismo que en T1: (a) 81, 255, 250, 38 y 196 marcas con 7, 13, 19, 25 y 7, y 0 fuera de tolerancia; (b) 0; (c) 0; (d) 205 vigentes y 0 distintas; (e) 7, 13, 19, 25 y 7. También pasan el 🔒5 (colores iguales; CSSOM distinto solo en las tres reglas) y el 🔒6 (`textContent` igual en los 4 estados; modal con AE 0). PASA

esperado: `git status --short` = ` M docs/index.html` (más el LOG)
obtenido: ` M docs/index.html` y `?? ...a14_log.md`. PASA

- **Commit** `deploy(motor): publica la trayectoria con segunda señal (a14)` = `cc102956061d8df2b705d5f0ed5984ff389cd7d0`, solo con `docs/index.html`. Numstat `32	9`, igual al del template, porque la línea del payload no cambió: misma fecha de generación. RUT 0 y `$HOME` 0 en lo agregado. `git show HEAD:docs/index.html` tiene md5 `a89e47e0…`.
- **T2: completada.**

### FASE R: auditoría propia y reparación

**1. Inventario R-01…R-22**, derivado del LOG anterior a esta auditoría y anexado antes de auditar:

| id | afirmación (LOG) |
|---|---|
| R-01 | M1: `main`; porcelain de 4 líneas; stash vacío |
| R-02 | M2: fetch exit 0; `HEAD` = `origin/main` = `eb18baa`; 0 y 0; ENTORNO; 10 filas; decisión `6f356181…` |
| R-03 | M3: commit `1f167d6` con 3 archivos; md5 de la app, del template y de `docs` iguales a §1; líneas de referencia |
| R-04 | M-DERIVA antes: `84d079b7…`, 1614 líneas, idéntico |
| R-05 | M4: base `018f6365…` (1888877 bytes); estados `s1280`, `s390`, `sc1280` (OVALLE, elegida por programa) y `m390`; 820 marcas de 18 × 18; leyenda de 16 × 16 |
| R-06 | M4: dos corridas con CSSOM, textos y marcas iguales; 8 de 10 capturas con AE 0 (2 con ruido de texto en la barra de controles) |
| R-07 | M5: PRUEBAS b y c en verde sobre la base |
| R-08 | T1: J1 a J3 y C1 a C3 aplicados; bloque retranspilado completo (1614 → 1635 líneas) |
| R-09 | T1: 🔒1 por archivo (C1 a C3 exactos; J1 a J3; fuera del `<style>` solo cambia el bloque) |
| R-10 | T1: 🔒2, M-DERIVA después `96e583b2…`, 1635 líneas, idéntico |
| R-11 | T1: build exit 0 y 0 warnings; motor `a89e47e0…`, 1889960 bytes |
| R-12 | T1: 🔒3, SHA `d9895a78…0442`, `meta.cat_colors` igual, PRUEBAS b en verde |
| R-13 | T1: 🔒4 (a) a (e) en 820 marcas; calibración con el paso en 0 que falla en (a) y (e) |
| R-14 | T1: 🔒5, colores iguales; CSSOM distinto solo en las tres reglas |
| R-15 | T1: 🔒6, `textContent` igual en 4 estados; modal con AE 0; 0 errores |
| R-16 | T1: `docs` restaurado; commit `730a7b6` con 2 rutas |
| R-17 | T2: 🔒7, `docs` = motor = `a89e47e0…` |
| R-18 | T2: PRUEBAS b y c sobre `docs`; 🔒4 repetido por `file://` con 0 errores |
| R-19 | T2: commit `cc10295` solo con `docs`; numstat `32	9` |
| R-20 | 🔒1 a 🔒8 sobre el estado final |
| R-21 | Alcance y porcelain |
| R-22 | Regresión y controles positivos |

**2. Re-derivación con otro comando** (estado final: `HEAD` = `cc10295`):

| id | comando de re-derivación (distinto del original) | resultado |
|---|---|---|
| R-13, R-18 | alturas leídas de las **capturas de ventana alta** (toda la página), sin leer alturas del DOM: componentes conexos de píxeles del color de relleno de cada categoría y del de «sin categoría» (`/tmp/cat_a14_r_pixeles.js`). Geometría del borde: sólido de 1 px con `border-box`, así que el relleno es 14 × (h − 2) en las marcas y 12 × (h − 2) en la leyenda; con el borde punteado de «sin categoría», el fondo asoma entre los trazos y el componente mide 14 × h o 13 × h | en `s1280`, `s390` y `sc1280`, todos los componentes de marca tienen el alto del mapa: relleno 5, 11, 17 y 23 (7, 13, 19 y 25 con el borde) y 7 para «sin categoría»; 0 de otro alto. Cada muestra de la leyenda aparece una vez y con su alto. Conteos: `s1280` y `s390`, 13, 6, 15, 2 y 20; `sc1280`, 3, 18, 11, 11 y 141. Son iguales a las marcas del DOM visibles por completo; las demás las recorta el scroll de `.cat-col-list` (`max-height: 620px; overflow-y: auto`) y no están en la imagen. Coincide |
| R-14 | CSSOM con `postcss` 8.5.28 (sin comentarios), sobre el `<style>` de los templates y de `docs` (`1f167d6` contra `HEAD`), en lugar de Chrome | templates: 245 → 246 reglas y at-reglas; comentarios 68 → 69; solo en `<inicio>`, `.traj-mark` y `.traj-legend-sw`; solo en `HEAD`, `.traj-bar`, `.traj-mark` y `.traj-legend-sw`; 0 fuera de las permitidas; resto en el mismo orden. `docs`: ídem. Coincide |
| R-03, R-11, R-17 | `openssl dgst -md5` y `stat -f %z` | template `1b615464…` (110703 bytes) → `a1b5fe26…` (111786); `docs` `018f6365…` (1888877) → `a89e47e0…` (1889960); `33_app.jsx` `07066acf…` → `ac828eb6…` (79627 bytes). Coincide |
| R-12, R-18 | SHA con el verificador Python, desde `git show` | `HEAD:docs` y `1f167d6:docs`: `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`; `meta.cat_colors` igual (Python, desde `git show`). Coincide |
| R-10 | M-DERIVA sobre el template de `HEAD` | `96e583b258e65830da3f60fdf4326f7a`, 1635 líneas, 0 distintas. Coincide |

Nota de instrumento: la primera versión del lector de píxeles comparaba con **todas** las marcas del DOM y dio conteos menores (por ejemplo, 13 de 36 Insuficiente en `s1280`), además de 7 en vez de 5 en «sin categoría». Las dos diferencias vienen del instrumento, no del trabajo:
- el scroll de `.cat-col-list` recorta las filas que no caben en 620 px;
- el borde punteado deja ver el fondo entre los trazos.

Al medidor se le agregó un campo de visibilidad por marca (`vis`: total, parcial u oculta), que no usa ningún candado, y el lector se ajustó a esa geometría. El mapa de alturas (el criterio) no cambió.

**3. Invariantes, con salida literal** (sobre `docs` de `HEAD`, antes del commit del LOG):

| 🔒 | comando | salida | veredicto |
|---|---|---|---|
| 1 | `git diff --name-only 1f167d6..HEAD`; `/tmp/cat_a14_candado1.py HEAD` | `30_procesamiento/33_app.jsx`, `30_procesamiento/33_motor_template.html`, `docs/index.html`; prefijo, tramo medio y sufijo iguales; `<style>: 3 cambios · = C1, C2 y C3 exactos: SI`; `33_app.jsx: 4 bloques de cambio · fuera de J1 a J3: 0`; `🔒1 (por archivo): PASA` | PASA (sin el LOG; forma completa en FASE L) |
| 2 | `/tmp/cat_a14_retrans.sh R` | `template 96e583b258e65830da3f60fdf4326f7a 1635 lineas \| retrans 96e583b258e65830da3f60fdf4326f7a 1635 lineas \| distintas: 0` | PASA |
| 3 | PRUEBAS b y c; `meta.cat_colors` de `1f167d6:docs` y `HEAD:docs` | F1 a F4 OK; `SPOT-CHECK OK: 6 celdas de presencia + 1 de ausencia`; SHA `d9895a78…0442`, calibración correcta; `meta.cat_colors: igual` | PASA |
| 4 | `/tmp/cat_a14_cmp.js candados` sobre `docs` de `HEAD` | (a) `fuera de tolerancia 0`; (b) `0`; (c) `0`; (d) `vigentes 205 … 0`; (e) `Insuficiente 14x7, Medio-Bajo 14x13, Medio 14x19, Alto 14x25, Sin categoría 14x7` | PASA |
| 5 | ídem | colores: `0` distintos, leyenda `NO` distinta; CSSOM: `232 → 233`, solo las tres reglas, `resto en el mismo orden: SI` | PASA |
| 6 | ídem | `textContent`: `s1280`, `s390`, `sc1280` y `m390` iguales; `modal 390 × 844 AE 0`; `errores de consola 0` | PASA |
| 7 | md5 de `docs` y del motor | `a89e47e09499022a2d2ac121b63796fd` = `a89e47e09499022a2d2ac121b63796fd` | PASA |
| 8 | `git log 1f167d6..HEAD --format=%B \| grep -ci co-authored`; `git diff 1f167d6..HEAD \| grep '^+' \| grep -cE` RUT; `grep -cF "$HOME"` | `0`; `0`; `0` | PASA |

**4. Alcance y porcelain:** `git diff --name-only 1f167d6..HEAD` = las dos rutas de T1 y `docs/index.html` (T2); el LOG entra en FASE L. `git status --porcelain` = solo `?? ...a14_log.md`. PASA.

**5. Regresión:**

esperado: PRUEBAS a exit 0 y 0 warnings; PRUEBAS b en verde; PRUEBA c = `d9895a78…0442` con calibración
obtenido: build exit 0, 0 warnings, renv activo, `Paso 33 OK`; motor `a89e47e0…` = `HEAD:docs`, así que `docs` no cambió y no hizo falta restore; F1 a F4 OK con 0 warnings; spot-check OK; SHA `d9895a78…0442`, fecha igual y cifra `162ff49e…`. PASA

**6. Control positivo:**

esperado: la calibración del 🔒4 (paso en 0), sobre el motor final, hace fallar el (a)
obtenido: `/tmp/cat_a14_R_paso0.html` (1 reemplazo): (a) con 543 marcas fuera de tolerancia → FALLA; (e) → FALLA. PASA

esperado: un color alterado en una copia del motor lo detecta el 🔒5
obtenido: en `/tmp/cat_a14_R_color.html` se reemplazó `const CAT_COLORS = M.cat_colors;` (1 aparición) por una versión que cambia solo `MEDIO` a `#2A8FDA`, 1 unidad en el azul. Resultado: 250 marcas de categoría con `background-color` distinto de la base y la leyenda distinta → FALLA. El (a) sigue en PASA: el control toca solo el color. PASA

**7 a 10. Veredicto por hallazgo:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-06 | dos corridas de la base iguales | dos corridas de `/tmp/cat_a14_medir.js`; `magick compare` | capturas con AE 0 | 8 de 10 con AE 0; `s1280` alta y `sc1280` ventana con AE 183.6 y 141.0 en una franja de texto de la barra de controles (y 286 a 298; rasterización subpíxel del texto); CSSOM, textos y marcas iguales | ADVIERTE | se registra; ningún 🔒 depende de esas capturas (el 🔒4 mide por DOM; el 🔒6 usa `textContent` y el modal, deterministas) | — | modal AE 0 en T1, T2 y FASE R |
| R-20 (🔒1) | alcance = 3 rutas más el LOG | `git diff --name-only 1f167d6..HEAD` | 4 rutas | 3 antes de FASE L | ADVIERTE (por diseño) | se mide completo en FASE L, después del commit del LOG | — | FASE L |
| resto | R-01 a R-05, R-07 a R-19, R-21 y R-22 | pasos 2 a 6 | lo que dice cada fila | igual a lo esperado | — | ninguna | — | — |

No hay hallazgos **BLOQUEA**: ningún 🔒 falla, el alcance se respeta, las cifras están intactas y ningún color cambió. Tampoco hay **REPARA**, ni ciclo de reparación ni `git revert`.

**Veredicto de FASE R: APROBADO CON ADVERTENCIAS** (R-06, instrumental, y el 🔒1 pendiente de FASE L por diseño).

### FASE L: cierre del log

**1. Porcelain.**

esperado: `git status --porcelain` = solo el LOG
obtenido: `?? 50_documentacion/andamios/logs/20260926_segunda_senal_a14_log.md`, en `main`. PASA

**2. Resumen.** El a14 implementó la opción B del pendiente #7: la altura de la marca de cada año codifica la categoría (Insuficiente 7, Medio-Bajo 13, Medio 19 y Alto 25 px; «sin categoría», 7).
- En `33_app.jsx` entraron J1 a J3 y, en el `<style>`, C1 a C3. El bloque de la app se retranspiló completo, sin tocar nada a mano, y M-DERIVA sigue idéntico.
- En Chrome, en tres estados (uno de ellos elegido por programa desde el payload: OVALLE), las 820 marcas miden lo que dice el mapa, con rótulos y bases alineados, 16 px de ancho, el anillo del vigente igual y la leyenda con 7, 13, 19, 25 y 7.
- Ningún color cambió. El CSSOM solo difiere en las tres reglas previstas. El `textContent`, el modal y las cifras están intactos.
- El motor se desplegó con 1083 bytes más.
- FASE R re-derivó las alturas desde los píxeles de las capturas, el CSSOM con `postcss`, los md5 con `openssl` y el SHA con Python. Los dos controles positivos discriminan. Veredicto: **APROBADO CON ADVERTENCIAS**.

**3. Commits** (`git log --oneline 1f167d6^..HEAD`; el `docs(log)` va encima y su hash queda en el reporte final):

| commit | mensaje |
|---|---|
| `1f167d6` | `chore(encargo): segunda señal de la trayectoria a14` (FASE 0, `<inicio>`) |
| `730a7b6` | `feat(motor): la altura de la marca de la trayectoria codifica la categoría (a14 T1)` |
| `cc10295` | `deploy(motor): publica la trayectoria con segunda señal (a14)` |

**4. Tabla de FASE R:** en FASE R, pasos 1 a 10.

**5. 🔒 con evidencia** (salida literal en FASE R, paso 3): 🔒2 a 🔒8 PASA. El 🔒1 pasa sin el LOG; su forma completa (las 3 rutas más el LOG) se mide después del commit de este LOG, y el resultado va en el reporte final.

**6. Alturas medidas por etiqueta** (DOM, `docs` de `HEAD`; tolerancia 0,5 px, y todas exactas):

| etiqueta | alto | `s1280` | `s390` | `sc1280` (OVALLE) | total |
|---|---|---|---|---|---|
| Insuficiente | 7 | 36 | 36 | 9 | 81 |
| Medio-Bajo | 13 | 101 | 101 | 53 | 255 |
| Medio | 19 | 77 | 77 | 96 | 250 |
| Alto | 25 | 7 | 7 | 24 | 38 |
| Sin categoría… | 7 | 27 | 27 | 142 | 196 |
| total | | 248 | 248 | 324 | 820 |

Leyenda: 5 muestras de 14 px de ancho, con altos 7, 13, 19, 25 y 7. Vigentes: 205, con el mismo `box-shadow` de la base. En la base, las 820 marcas medían 18 × 18.

**7. Bytes del motor antes y después:** `docs/index.html` pasa de `018f63657c227036899ae3194bf9c68e`, con 1888877 bytes, a `a89e47e09499022a2d2ac121b63796fd`, con 1889960 bytes (+1083). El template pasa de 110703 a 111786 bytes, también +1083: el template entra entero al motor y la línea del payload no cambió.

**8. Dudas** (pregunta cerrada):

- **D9 (nueva):** en las capturas de estado completas, una línea de texto de la barra de controles no es determinista al subpíxel entre corridas (AE 141 a 184, en 2 de 10 capturas). ¿Los próximos encargos de UI limitan el criterio de AE de las capturas de estado a regiones sin esa barra, o a la captura del modal y de la trayectoria? (sí / no, se mantiene la captura completa con esta advertencia)
- D6 quedó resuelta (= sí) y se aplicó: capturas de ventana y de ventana alta, nunca `fullPage`. D7 y D8 (del a13) y D1, D2 y D3 (del a11) siguen abiertas; este encargo no las toca.

**9. Errores propios:**

- **Primera versión del lector de píxeles.** En FASE R, la primera versión de `/tmp/cat_a14_r_pixeles.js` comparaba los componentes de la imagen con **todas** las marcas del DOM. No tuvo en cuenta que el scroll de `.cat-col-list` recorta filas ni que el borde punteado deja ver el fondo, y dio conteos menores y 7 en vez de 5 para «sin categoría». Se corrigió el instrumento (campo de visibilidad `vis` en el medidor, que no usa ningún candado, y la geometría del borde punteado), sin tocar el mapa de alturas; la segunda corrida coincide en los 3 estados. Efecto: ninguno sobre el trabajo ni sobre los 🔒.
- **Una etiqueta de `obtenido` mal escrita (repetición del a13).** En T1, el resultado del 🔒4 se escribió como «obtenido (`…cmp.js candados`): …», en vez de empezar por `obtenido:`. El conteo de FASE L dio 26 contra 25. Se corrigió solo la etiqueta, sin tocar la evidencia. Es el mismo error del a13; como salvaguarda, desde este LOG el chequeo de paridad corre antes del cierre y también busca `^obtenido[^:]`.

**10. Notas para el revisor:**

- En una pasada por el sitio, en escritorio y en móvil, revisar la leyenda y una fila de cada categoría: Insuficiente abajo, Alto arriba, el vigente con anillo y «sin categoría» con relleno crema y borde punteado.
- Cada fila de la lista gana unos 7 px (el contenedor pasa de 18 a 25 px). Como `.cat-col-list` tiene `max-height: 620px`, en cada columna caben algo menos de filas sin scroll. Es la consecuencia prevista en la decisión.
- Las capturas de la trayectoria para la revisión están en `/tmp/cat_a14_m_R/s1280_traj.png` y `/tmp/cat_a14_m_R/s390_traj.png`.
- Los temporales quedan en `/tmp/cat_a14_*`. No se instaló nada: Babel y `postcss` son copias de `/tmp`, y Puppeteer es el de los encargos anteriores.
- El `CLAUDE.md` local (ignorado por git) no se actualizó porque está fuera de ALCANCE. Queda para el cierre de sesión.

**11. Privacidad del LOG y conteos:**

esperado: grep del patrón de RUT sobre el LOG = 0; `grep -cF "$HOME"` = 0; sin nombres de establecimiento ni de personas, y sin RBD con número
obtenido: 0; 0; la lectura no encuentra nombres de establecimiento ni de personas. El único topónimo es la comuna del estado `sc1280` (OVALLE, y CARAHUE y QUELLÓN entre las candidatas), que es un territorio, no un establecimiento. 0 RBD con número. PASA

esperado: `grep -c '^### FASE'` = 3; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1
obtenido: se mide sobre este archivo terminado, antes del commit; la salida literal va en el reporte final junto con `ls -l` y `wc -l`

**12. Cierre:**
- commit `docs(log): segunda señal de la trayectoria a14` (solo el LOG);
- 🔒1 completo (3 rutas más el LOG);
- simulacro del hook `refs/heads/main <HEAD> refs/heads/main <origin/main>` (esperado exit 0);
- `git push origin main`, el único acto externo, autorizado en el lanzamiento;
- después, `curl` del sitio publicado (hasta 10 intentos cada 30 s), con resultado en el reporte final.

## J. Juicio (lo rellena FASE L)

- **Meta y resultado:** dar a la trayectoria una segunda señal además del color (opción B: altura según la categoría) y desplegarla, sin cambiar colores ni cifras. Resultado: las 820 marcas medidas en tres estados tienen la altura del mapa; la leyenda y el anillo del vigente están bien; los colores, el CSSOM (salvo las tres reglas), el `textContent`, el modal y el payload están intactos; el despliegue es fiel. Veredicto de FASE R: **APROBADO CON ADVERTENCIAS**.
- **Estado por tarea:**
  - FASE 0: completa (M1 a M5 y M-DERIVA; en M4, 2 de 10 capturas con ruido de texto, registrado).
  - T1: completada (`730a7b6`).
  - T2: completada (`cc10295`).
  - FASE R: aprobado con advertencias.
  - FASE L: este cierre.
- **Commits:** `1f167d6` (FASE 0) → `730a7b6` (T1) → `cc10295` (T2) → `docs(log)` (este LOG), en `main` sobre `eb18baa`.
- **Auditoría:** cada afirmación se re-derivó con un comando distinto:
  - las alturas desde los píxeles de las capturas de ventana alta, que coinciden con el mapa y con las marcas visibles del DOM en los 3 estados;
  - el CSSOM con `postcss`;
  - md5 y bytes con `openssl` y `stat`;
  - el SHA y `meta.cat_colors` con Python.

  Los controles positivos discriminan: el paso en 0 da FALLA del 🔒4 (a) y (e), y un color alterado da FALLA del 🔒5.
- **Invariantes:** 🔒2 a 🔒8 PASA con salida literal (FASE R, paso 3). El 🔒1 pasa sin el LOG y se mide completo en FASE L (reporte final).
- **Cifras críticas:**
  - alturas 7, 13, 19, 25 y 7 en 81, 255, 250, 38 y 196 marcas (820); leyenda 7, 13, 19, 25 y 7;
  - 205 vigentes con el mismo anillo; 0 colores cambiados;
  - CSSOM 232 → 233 reglas;
  - motor `018f6365…` (1888877 bytes) → `a89e47e0…` (1889960, +1083);
  - SHA `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`, sin cambio;
  - M-DERIVA `96e583b2…`, 1635 líneas.
- **Decisiones autónomas de mayor riesgo:**
  - Elegir el tercer estado por programa: la comuna con más establecimientos sin categoría vigente en básica, desempatada por código (OVALLE).
  - Ubicar C1 justo antes de `.traj-mark`.
  - En FASE R, agregar al medidor un campo de visibilidad que no usa ningún candado, para comparar conteos por imagen.
- **Desviaciones:** ninguna respecto del ALCANCE ni de los criterios. La única llamada git antes del `fetch` fue `rev-parse --show-toplevel`, que exige ENTORNO, con `GIT_OPTIONAL_LOCKS=0`.
- **Dudas abiertas:** D9 (nueva: ruido de texto de la barra de controles en capturas de estado); D7 y D8 (a13) y D1, D2 y D3 (a11), heredadas. D6 quedó resuelta (= sí).
- **Errores propios:** dos, sin efecto en el trabajo:
  - de instrumento: la primera versión del lector de píxeles no descontaba el scroll ni el borde punteado; se corrigió en FASE R sin tocar criterios;
  - de formato: una etiqueta de `obtenido` sin los dos puntos, la misma falla del a13; se corrigió solo la etiqueta.
- **Qué debe verificar el revisor:**
  - una pasada visual por el sitio: la leyenda y una fila de cada categoría, en escritorio y en móvil;
  - el diff de `730a7b6`;
  - la respuesta a D9.
- **No publicado / queda al usuario:**
  - el push, el 🔒1 completo y el md5 del sitio (en el reporte final);
  - D9 y las dudas heredadas;
  - la actualización del `CLAUDE.md` local, fuera de ALCANCE;
  - los temporales de `/tmp/cat_a14_*`.
- **Ejecución:** autónoma, en un turno, sin subagentes ni workflows, esfuerzo `xhigh`. La sesión estaba en `ultracode` con Opus 5.5 y mandó el encargo. Sin pausas: el único acto externo venía autorizado en el lanzamiento.

