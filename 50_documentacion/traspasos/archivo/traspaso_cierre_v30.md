# Traspaso de cierre: slep_categoria_desempeno v30

## 1. Identificación

- **Proyecto:** slep_categoria_desempeno
- **Versión:** v30
- **Fecha:** 2026-09-25
- **Sesión:** 30, CONTINUATION. Foco: alinear la usabilidad del motor con los patrones de `slep_idps` adaptándolos a la lógica propia, corregir el contraste figura-fondo de todo el motor, ordenar la trayectoria cronológicamente y desplegar.
- **Entorno:** chat (Cowork, con el repositorio conectado: lectura, mediciones de contraste en Chromium, redacción de encargos) + Claude Code (cinco encargos autónomos a1 a a5 y dos instrucciones cortas).
- **Normativos usados:** `POLITICA_PROYECTO.md` con encabezado `> **Versión 5.8 — vigente.**`; `SETTINGS_Y_PROMPTS_OPERACIONALES.md` con encabezado `> **Versión 38.**` (el traspaso v29 no citaba versiones).
- **Archivos principales modificados:** `30_procesamiento/33_app.jsx`, `30_procesamiento/33_motor_template.html`, `30_procesamiento/33_generar_html.R` (solo el bloque `CAT_COLORS`), `docs/index.html` (desplegado), `.gitignore`; documentos nuevos en `50_documentacion/activa/decisiones/`, `50_documentacion/activa/encargos/` y `50_documentacion/andamios/`.

## 2. Resumen ejecutivo

La sesión abrió sin eco de `/apertura` y con dos archivos sin versionar: un encargo (a1) redactado horas antes desde una sesión de `slep_idps`, que proponía alinear el motor con una matriz de 20 patrones de usabilidad medida sobre los tres motores hermanos, y el parquet del contrato de categoría. El titular confirmó el origen del encargo y lo lanzó tras corregirle dos premisas (el `HEAD` de partida y tres dudas de la matriz que no tenían ficha). El a1 produjo el plan de adaptación (18 fichas re-medidas: 2 adoptar, 8 adaptar, 2 inspirarse, 6 diferir), pero congeló la implementación al descubrir que la migración tipográfica de v29 había editado el JavaScript transpilado del template sin tocar la fuente `33_app.jsx`. Con las resoluciones del titular, el a2 sincronizó la fuente e implementó 14 ítems (modales operables con teclado, foco, ancho, plurales, anillo de foco, tinta de cabeceras, rótulo del comparador, frase 1 de la narrativa). Al revisar en pantalla, el titular pidió corregir el contraste de todo el motor: una auditoría figura-fondo en 19 estados (13.725 mediciones de texto) halló 19 pares de texto y 8 familias gráficas bajo WCAG 2.1 AA, y el a3 las llevó a 0 con una paleta recalibrada en dos categorías, grises y bordes nuevos, y cabeceras oscuras con texto blanco (variante pedida por el titular). El a4 ordenó la trayectoria de izquierda a derecha, el a5 devolvió el detalle vertical al orden "vigente primero" (el titular lo prefirió por el scroll) y desplegó todo a `docs/index.html`, verificado byte a byte contra el sitio publicado. El repositorio queda limpio, con el parquet ignorado, y sin fallas funcionales.

## 3. Estado al cierre

**Funciona:** motor publicado en GitHub Pages con md5 `788d5026562a67a73af43abffd97034e`, idéntico al `docs/index.html` del commit `56f6629` (fuente: `curl` del sitio publicado y `md5sum`, sesión 30). Payload con `fecha_generacion` normalizada: SHA `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`; con `meta.cat_colors` restituido a la paleta anterior, `0ffd98993746229c42ac2e2b061a1cfe99733b42342186346eec3cebfae12ad8`, el mismo de antes de la sesión (fuente: logs a3, a4 y a5). `tests/auditar_cifras.R` (F1 a F4) y `tests/spot_check_publicado.R` en verde en cada build. `renv` restaurado por el titular: todas las corridas R de a2 a a5 usaron `renv` activo. `main` en `f532d94` más el commit que completa el resumen estadístico del backlog (previo al commit de cierre), árbol limpio.

**No funciona / pendiente:** ninguna falla funcional. `renv` avisa "project is out-of-sync" al cargar (duda registrada, §11).

**Delta respecto a v29:** el trabajo de v29 (migración tipográfica, commits `91ff8ed` a `e09b5bc`) data del 2026-07-02, aunque su traspaso lleva fecha 2026-09-25; entre ambos hubo commits de cartera (portabilidad, gobernanza, `ventana_insumos`) que v29 no registra. Esta sesión agregó 26 commits propios y cerró tres pendientes de v29: el #3 (entrada de backlog de la migración tipográfica, c.91), la deuda de fuente JSX que v29 dejó sin saber (bug §6) y el parquet sin ignorar. Siguen abiertos: re-clonar clones previos (#1 de v29) y el CSS muerto (#2), que ahora tiene inventario (§11).

## 4. Registro detallado de cambios

### 4.1 Corrección de premisas del encargo a1 (antes de lanzarlo)

- **Qué:** en `encargo_claude_code_categoria_alineamiento_motores_a1.md`, `HEAD` de partida `b709400` → `3afd23a` (§2 y M2) y fichas de T1 ampliadas de D-03 y D-08 a D-03, D-08, D-13, D-22 y D-24.
- **Por qué:** el cierre de v29 había agregado 3 commits documentales y el encargo se habría detenido en M2; el titular había declarado que las cinco dudas pesaban aquí.
- **Cómo se verificó:** `grep -n` sobre el encargo antes y después; M2 del a1 pasó con `3afd23a`.

### 4.2 Plan de adaptación de patrones de `slep_idps` (a1)

- **Qué:** `50_documentacion/andamios/20260925_plan_alineamiento_motores.md`, 18 fichas con las cinco preguntas (problema de uso aquí, si existe, decisión propia que lo toca, qué depende de la lógica de `slep_idps`, forma adaptada) y medición propia (M5). Commits `9d4e120`, `5160d22`, `51447ce`.
- **Categoría:** Accesibilidad y usabilidad (c.92, junto con 4.3).
- **Por qué:** estandarizar la usabilidad con los motores hermanos sin trasladar lo que es propio de este (sin GSE, paleta ordinal, "sin categoría" con motivo, comparador traspuesto).
- **Cómo se verificó:** FASE R del a1 (22 filas; BLOQUEADO solo por la falla heredada de §6); control positivo de los huecos sobre el motor publicado.

### 4.3 Sincronización de la fuente e implementación del plan (a2)

- **Qué:** T0 corrige `fontSize: "var(--fs-base)"` → `"var(--fs-body)"` en `33_app.jsx` (bug §6). T1 implementa F02, F03, F04, F05, F07 (modales: filas con teclado, ciclo de foco, Escape = Cancelar, respaldo de foco, ✕ con nombre, aviso de cupo), F08 y F14 (ancho: secundario que cede, nombres que se parten en la narrativa), F01 y D-03 (plurales y "Está en nivel…"), F12 (anillo de foco en `--ocean` con separación). T2 aplica las resoluciones del titular: tinta `--ink` en tres cabeceras (luego sustituida en 4.5), rótulo "Sin categoría en {año vigente} (incluye sin medición)" en el comparador, frase 1 de la narrativa con un establecimiento como sujeto. T3 escribe `20260925_decision_contraste_texto_categorias.md` y anexa la §6 al plan. Commits `cc0bced` a `2238930`.
- **Por qué:** resoluciones del titular a las dudas del plan (D-M4 Sí; Q-F11 B; Q-F09 B; Q-F18 No; Q-D08 mantener c.21; Q-D22 abierta).
- **Cómo se verificó:** siete invariantes; SHA del payload idéntico en 7 builds; `textContent` solo con las cadenas declaradas; control positivo.

### 4.4 Auditoría de contraste figura-fondo (chat)

- **Qué:** `50_documentacion/andamios/20260925_auditoria_contraste_motor.md` y maqueta `20260925_cabeceras_variante.png`: render en Chromium de 19 estados, texto contra fondo efectivo (componiendo transparencias y opacidades) y gráficos o controles contra su fondo adyacente, con umbrales WCAG 2.1 AA; propuesta P1 a P10 simulada en el mismo motor, más la variante P11.
- **Por qué:** pedido explícito del titular ("mejorar el contraste completo del proyecto; haz pruebas figura-fondo").
- **Cómo se verificó:** medición repetida tras la simulación: 0 fallas activas. Una primera corrida con transiciones activas midió colores intermedios y se descartó.

### 4.5 Contraste completo (a3)

- **Qué:** P1 `--fg-3` #5E5E5E; P2 `--border-2` #8A7F68 en controles (y `--line-strong` en dos decorativos vivos); P3 `--fg-on-dark-muted` #A9B7BB; P4 y P5 `CAT_COLORS` Insuficiente #D0112D y Medio-Bajo #E05D2F; P6 sin opacidad en las cabeceras; P7 rojo nuevo en delta y ✕; P8 % máximo con tinta y marco `--ink`; P9 segmentado activo en `--ocean`; P10 borde de "Cancelar"; P11 cabeceras #B30F27, #C1481D, #2074B2, #004976 con texto blanco. Decisión `20260925_decision_paleta_categorias_v2.md`; las dos decisiones anteriores cambian solo su línea `Estado:`. Commits `cb2e6a9` a `118cf25`.
- **Categoría:** Accesibilidad y usabilidad (c.93); la variante de cabeceras, Diseño UI, Motor base y diseño (c.94).
- **Cómo se verificó:** 19 pares de texto y 2.103 mediciones fallidas → 0; 8 familias gráficas → 0; quedan solo 4 pares en controles deshabilitados, exentos. Payload igual salvo `meta.cat_colors`. Cabeceras 6,97 / 4,99 / 5,00 / 9,48.

### 4.6 Trayectoria cronológica (a4) y detalle con el vigente primero (a5)

- **Qué:** `Trayectoria` ordena 2016 → 2019 con el anillo del vigente a la derecha (a4, `787ed9c`); el detalle "Trayectoria y matrícula por año" vuelve a 2019 → 2016 (a5, `22826e9`, revierte solo O2 del a4). "Evolución de la matrícula" sigue ascendente.
- **Categoría:** Motor base y diseño (c.95); Modo establecimiento (c.96).
- **Por qué:** una línea de tiempo horizontal corta se lee de izquierda a derecha; una lista vertical larga debe poner el vigente arriba para no forzar scroll (decisión del titular tras ver el a4). Deja sin efecto la parte "orden reciente → antiguo" de la c.20 solo para la trayectoria.
- **Cómo se verificó:** orden por nodos y por coordenada en pantalla; 631 trayectorias ascendentes y 2 detalles descendentes en los 19 estados; `textContent` sin otro cambio.

### 4.7 Despliegue (a5) y `.gitignore`

- **Qué:** commit de despliegue `56f6629` (a2 a a5 en `docs/index.html`); `.gitignore` con `40_salidas/*.parquet` (`f532d94`).
- **Categoría:** Migración y publicación / DevOps (c.97, el `.gitignore`).
- **Cómo se verificó:** md5 del `docs/index.html` = md5 del build = md5 del archivo en el commit = md5 del sitio publicado (`788d5026…`); `git check-ignore` sobre el parquet; árbol limpio.

## 5. Backlog acumulativo

Siete entradas nuevas (c.91 a c.97, numeración provisional). Antes del cierre se completó el resumen estadístico por sesión, que llegaba solo hasta la sesión 24 y sumaba 89 frente a 90 entradas: se agregaron las filas 25 a 29 (N = 0, 0, 1, 0, 0) y el total pasó a 90; el primer intento de cierre (instrumento v15) se había detenido en F5 por ese descuadre. La c.91 es un registro tardío: resuelve el pendiente #3 del traspaso v29 (la migración tipográfica de la sesión 29 no tenía entrada) aplicando el criterio de intención primaria. Categoría nueva "Accesibilidad y usabilidad" (c.92, c.93).

## 6. Bugs de la sesión

| Campo | Contenido |
|---|---|
| Síntoma | Retranspilar `33_app.jsx` no reproducía el motor: el buscador de los dos modales pasaba de 16 a 18 px (a1, M4) |
| Causa raíz | La migración tipográfica de v29 (`91ff8ed`) editó el bloque transpilado del template (`--fs-base` → `--fs-body`) sin tocar la fuente; `33_app.jsx` quedó citando un token que ya no existía. El traspaso v29 validó con `node --check` sin retranspilar |
| Solución | `33_app.jsx`, buscador de `EntityModal`: `var(--fs-base)` → `var(--fs-body)` (a2 T0, `b19d0f0`) |
| Verificación | Retranspilación con render idéntico en 9 pantallas a 1280 y 390; desde entonces cada encargo exige cadena idéntica (M-DERIVA) |
| Patrón aprendido | El bloque de la app del template nunca se edita a mano: la lógica y el JSX se editan en `33_app.jsx` y llegan al template solo por retranspilación completa |
| Estado | Resuelto |

## 7. Aprendizajes y restricciones

- **Fuente JSX como única vía (C.11, B.3).** Toda edición de lógica pasa por `33_app.jsx` y retranspilación completa; el CSS sí se edita en el template. Violarla deja la fuente desfasada sin que ningún build lo note (ejemplo: §6).
- **Medir contraste con transiciones desactivadas (B.4).** Con `transition` activa, el render captura colores intermedios (la casilla marcada se medía blanca). Toda medición de color inyecta `*{transition:none!important;animation:none!important}` antes de medir.
- **Adaptar, no copiar (B.1).** Un patrón de un proyecto hermano se traslada solo si el problema de uso existe aquí; las decisiones propias mandan (ejemplo: Escape = Cancelar porque aquí el modal múltiple guarda una selección local).
- **Orden temporal según la forma (diseño).** Horizontal y corto: cronológico de izquierda a derecha. Vertical y largo: lo vigente primero.
- **El shell del computador no borra archivos (entorno).** Todo `git` de lectura desde ese shell va con `GIT_OPTIONAL_LOCKS=0`; si no, deja `index.lock` huérfanos.
- **Archivos enviados al chat con una carpeta conectada.** La app de escritorio puede guardarlos en `Claude outputs/` dentro del repositorio; hay que moverlos o no versionarlos.

## 8. Decisiones de diseño

- **Paleta de categorías v2** (`20260925_decision_paleta_categorias_v2.md`): Insuficiente #D0112D, Medio-Bajo #E05D2F; Medio y Alto sin cambio; tonos de cabecera propios con texto blanco. Alternativas: sin tocar la paleta (dejaba dos fallas) u oscurecer todo el motor (descartada por el mapa de calor y la distinción entre marcas). Reemplaza dos colores de `20260612_decision_paleta_categorias.md` y la excepción de `20260925_decision_contraste_texto_categorias.md`.
- **Orden temporal:** trayectoria ascendente, detalle vigente primero, evolución de matrícula ascendente (§4.6). Sin archivo de decisión propio; queda en este traspaso y en el backlog (c.95, c.96).
- **Clasificación de patrones de `slep_idps`:** plan del a1 con §6 de resoluciones; D-22 sigue abierta.

## 9. Constantes y parámetros

| Constante | Valor anterior | Valor nuevo | Archivo | Motivo |
|---|---|---|---|---|
| `CAT_COLORS$INSUFICIENTE` | `#EE2D49` | `#D0112D` | `33_generar_html.R` | contraste (P4) |
| `CAT_COLORS$MEDIO-BAJO` | `#E88663` | `#E05D2F` | `33_generar_html.R` | contraste (P5) |
| `--fg-3` | `var(--slate)` | `#5E5E5E` | template `:root` | P1 |
| `--border-2` | `var(--line-strong)` | `#8A7F68` | template `:root` | P2 |
| `--fg-on-dark-muted` | (no existía) | `#A9B7BB` | template `:root` | P3 |
| `--cat-insuf` | (solo respaldo `#EE2D49`) | `#D0112D` | template `:root` | P4 |
| `--cat-insuf-cab`, `--cat-mbajo-cab`, `--cat-medio-cab`, `--cat-alto-cab` | (no existían) | `#B30F27`, `#C1481D`, `#2074B2`, `#004976` | template `:root` | P11 |

Las demás constantes siguen vigentes en `33_generar_html.R` y en el `:root` del template.

## 10. Arquitectura de archivos

Escáner regenerado por el ejecutor del cierre. Cambios de estructura: archivos nuevos en `decisiones/` (2), `encargos/` (a2 a a5), `andamios/` (plan, auditoría, maqueta PNG) y `andamios/logs/` (5 logs). Traspasos: `50_documentacion/traspasos/` tiene 29 traspasos planos; el ejecutor de este cierre los archiva en `traspasos/archivo/` (F6) y deja vigente solo el v30 (SETTINGS §2.1: migrarlos es parte de este cierre). Deuda heredada: no existe `50_ordenacion_repositorio.md` (el resto de la ordenación de la política v5.5 sigue pendiente, §11).

## 11. Pendientes y ruta sugerida

### Inventario

| # | Descripción | Tipo | Impacto | Complejidad | Criterio de éxito sugerido |
|---|---|---|---|---|---|
| 1 | Defectos de texto y UI anotados por a2 y a3: frase 3 vacía ("Considerando la matrícula 2025, .") cuando la matrícula está solo en Medio-Bajo; frase 3 con un establecimiento como sujeto ("a uno de desempeño…"); `el**Simce 2022**` sin espacio; pestaña "Establecimiento" cortada a 390 px; botón de territorio desmedido a 320 px con un nombre largo; foco en `BODY` tras "Limpiar" | bug activo (visibles, sin efecto en cifras) | medio | baja | cada caso reproducido antes y corregido después con medición; `textContent` solo con las cadenas declaradas |
| 2 | Regenerar la suite de documentación (`50_documentacion/suite/`): cita la paleta vieja (`#EE2D49`, `#E88663`) y no incluye las decisiones nuevas | documentación | medio | media | `grep -c 'EE2D49\|E88663'` en `50_documentacion/suite/*` = 0; cfg con las dos decisiones nuevas |
| 3 | Limpieza del CSS muerto (pendiente #2 de v29): el a3 inventarió 12 selectores sin referencia (`.select/.input`, `.entity-chip`, `.btn-ghost`, `.empty-board`, `.icon-export`, `.tooltip`, `.tt-estab-link`, `.data-table` ×2, `.td-empty`, `.estab-popup`, `.gse-filter select`) más los de v29 | deuda técnica | bajo | baja | cada selector retirado con 0 apariciones en `33_app.jsx`; capturas 19/19 idénticas |
| 4 | Resto de la ordenación del repositorio (política v5.5, SETTINGS §4.7: obsoletos, nomenclatura, escáner); el bloque de traspasos quedó hecho en este cierre | deuda heredada | bajo | media | existe `50_ordenacion_repositorio.md` con el conteo por bloque |
| 5 | Guarda de locale UTF-8 (POLITICA §5.2bis, pregunta 9 de §5.6): no existe `50_locale_utf8.md`; `asegurar_locale_utf8` aparece solo en `10_utils/10_validar_portabilidad.R` | deuda heredada | bajo | baja; el punto de arranque lo decide el titular | guarda instalada y vista fallar; marcador creado |
| 6 | Re-clonar clones previos (historial reescrito en v27) | administrativo manual | bajo | baja | ningún clon con hashes previos a v27 |
| 7 | Uso del color (WCAG 1.4.1): las marcas de trayectoria comunican la categoría solo por color (el nombre va en `title`) | mejora de accesibilidad (decisión de diseño) | medio | media | segunda señal visible definida y aprobada por el titular |
| 8 | `CLAUDE.md` ausente en la raíz | documentación | bajo | baja | `CLAUDE.md` presente con el bloque canónico |
| 9 | Hermanos: si `slep_idps` y `slep_simce_adecuado` comparten `--fg-3` #747474 y `--border-2` #C8BDA0, arrastran las fallas T1 y G3 | observación para otros proyectos | (fuera de este repo) | baja | medir en esas sesiones, no aquí |
| 10 | D-22: ¿la categorización con Simce 2025 llegará como preliminar? | duda del titular | futuro | n/a | respuesta del titular |

### Evaluación de deuda técnica

Zona frágil principal: el bloque transpilado del template (la regla de §6 la protege; M-DERIVA la mide). Oportunidad: versionar como prueba en R el SHA normalizado del payload (F19 y D-24 del plan, "inspirarse").

### Auditoría de cierre (POLITICA 5.6, preguntas de cierre)

- 2. ¿El pipeline corre de cero sin intervención manual? → Sí para el paso 33 (`run_all(only = 33)` en cada build de a2 a a5, con `renv` activo); el pipeline completo no se corrió en esta sesión.
- 5. ¿Cada transformación crítica tiene check? → Sí: `auditar_cifras.R` (F1 a F4) y `spot_check_publicado.R` en verde en cada build.
- 6. ¿Outputs reproducibles e idempotentes? → Sí: mismas fuentes y fecha dan el mismo md5 (a3 y a5).
- 7. ¿Decisiones como constantes nombradas? → Sí: paleta y tintas como tokens del `:root` y `CAT_COLORS`.
- 8. ¿Nombres sin tildes, ñ ni espacios? → Sí en todos los archivos nuevos.
- 9. ¿Guarda `asegurar_locale_utf8()` instalada y vista fallar? → No: pendiente #5.

### Compuerta de dudas

| supuesto | predicado | medicion | destino |
|---|---|---|---|
| GitHub Pages sirve el despliegue | el md5 de https://tomgc.github.io/slep_categoria_desempeno/ es `788d5026…` | `curl -sS <url> \| md5` | **cerrada en sesión**: 200 y md5 `788d5026562a67a73af43abffd97034e` |
| `renv` está consistente pese al aviso "out-of-sync" | `renv::status()` informa el proyecto sincronizado | `Rscript -e 'renv::status()'` en la raíz | **registrada** (pendiente para la próxima apertura) |

### Ruta sugerida

1. Pendiente #1 (bugs visibles de narrativa y UI): primero por criterio (bugs), baja complejidad, sin cifras.
2. Pendiente #2 (suite de documentación), porque hoy documenta una paleta que ya no existe.
3. Pendiente #3 (CSS muerto), con el inventario del a3 y la regla de §6.
4. Ofrecer #4 y #5 como prioridad propuesta; diferir #7 a una sesión de diseño.

## 12. Instrucciones específicas para la próxima sesión

- ⚠️ NO editar el bloque transpilado del template sin pasar por `33_app.jsx` y retranspilar.
- ⚠️ NO medir colores sin desactivar transiciones y animaciones.
- ⚠️ NO correr `git` de lectura desde el shell del computador sin `GIT_OPTIONAL_LOCKS=0`.
- ✅ ANTES de cualquier encargo sobre el motor, medir M-DERIVA (retranspilación = bloque del template).
- ✅ ANTES de desplegar, verificar el SHA normalizado del payload y las pruebas del dato.
- 🔒 Payload y cifras: ningún cambio visual altera el payload salvo `meta.cat_colors` por decisión escrita.
- 🔒 Orden temporal: trayectoria ascendente, detalle vigente primero.

## 13. Fragmentos de código de referencia

Sin patrones nuevos en R. Las recetas de verificación (payload normalizado, retranspilación, contraste en 19 estados, orden por bloque) viven en los logs `20260925_*_a1` a `a5` de `50_documentacion/andamios/logs/` y en §7 del encargo a3 (instrumento de contraste).

## 14. Reapertura

**Mensaje de apertura pre-armado:**

> Sesión 31, CONTINUATION. El protocolo (POLITICA_PROYECTO.md + SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del proyecto. Pego el eco de /apertura y adjunto el traspaso v30. Estado: motor publicado con alineamiento de usabilidad, contraste AA y trayectoria cronológica; repo limpio. Foco propuesto: pendiente #1 (defectos visibles de narrativa y UI anotados en a2 y a3).

**Documentos para la próxima sesión:**

1. *Protocolo en knowledge base* (no se adjuntan): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
2. *Opcionales según foco:* `CLAUDE.md` si correrá en Claude Code (hoy no existe en la raíz, pendiente #8).
3. *Específicos (sí se adjuntan):* `traspaso_cierre_v30.md`.

**Nota final obligatoria:** si algún archivo listado cambió entre sesiones, adjuntar la versión más actualizada al abrir y avisarlo en el mensaje de apertura.

## 15. Errores del asistente

| momento | disparador | que_paso | regla_violada | causa_raiz | salvaguarda_presente | patron | gatillo_observable | intentos_previos | costo |
|---|---|---|---|---|---|---|---|---|---|
| Apertura y edición del encargo a1 | asistente lo señaló espontáneamente | los `git fetch` y `git status` corridos desde el shell del computador dejaron `.git/index.lock` y `.git/objects/maintenance.lock` huérfanos (ese shell no puede borrar), lo que habría hecho fallar el primer commit del a1 | SETTINGS §1.2.6, "Ningún comando asume el entorno"; encargo a1 §0 (lecturas con `GIT_OPTIONAL_LOCKS=0`) | se trató el shell remoto como uno normal sin medir su restricción de borrado | SETTINGS; encargo a1 | PAT-03, shell del computador sin permiso de borrado | comando-entorno: el primer `git fetch` ya imprimió `unable to unlink … Operation not permitted` | 0 | 1 permiso de borrado pedido al titular; 0 commits afectados |
| Redacción del encargo a3 (§1, fila P1) | asistente lo señaló espontáneamente al leer el log a3 | la fila P1 nombró solo `--fg-3` y omitió quitar la opacidad de `.ee-row-sep`, que la auditoría del mismo turno exigía (§3, T4); el ejecutor salió de la letra de §1 para alcanzar el esperado | SETTINGS §1.2.6 (entrega materializada completa); `encargo_autonomo_claude_code_v1.md` (alcance cerrado) | al pasar de la tabla de fallas a la lista cerrada se resumió P1 por su variable y no por sus efectos | SETTINGS; encargo_autonomo_claude_code_v1.md | PAT-07, cambio de la auditoría no propagado a la lista cerrada del encargo | restriccion-no-propagada: la auditoría decía "sin opacidad" y la fila P1 no | 0 | 1 duda al titular (Q-SEP); 1 desviación declarada |
| Mensaje a Claude Code para ignorar el parquet | asistente lo señaló espontáneamente | el mensaje pedía `git status --porcelain` vacío **antes** del commit, un esperado falso por construcción (el `.gitignore` recién editado aparece modificado) | SETTINGS §1.2.6, "Generar, verificar, consumar" | el predicado se redactó para el estado final y se ubicó antes del commit | SETTINGS | PAT-NUEVO-esperado-falso-por-construccion, verificación intermedia con un esperado que el paso previo vuelve imposible | comando-entorno: el mismo mensaje editaba `.gitignore` y luego exigía porcelain vacío sin commit de por medio | 0 | 1 interpretación del ejecutor |
| Paquete de cierre v30, §3 y §10 del traspaso | ejecutor del cierre (advertencia de F-cierre) | el traspaso afirmó como hecho el archivado de los traspasos v01 a v28, que dependía de un paso previo que aún no se había ejecutado (y no se ejecutó) | SETTINGS §1.2.6, marcador de fuente S-01 (estado de repositorio solo con fuente de esta sesión) | se redactó el traspaso en el mismo turno que la instrucción del paso previo, dando su resultado por ocurrido | SETTINGS | PAT-01, estado de repositorio afirmado antes de ocurrir | estado-git: el directorio `traspasos/archivo/` no existía al emitir el paquete | 0 | 1 reemisión del paquete (compartida con el bloqueo) |
| Emisión del paquete de cierre v30 | ejecutor del cierre (BLOQUEA en F5, I2) | se emitió el paquete sin comprobar que el resumen estadístico del backlog cuadrara con el detalle cronológico (llegaba a la sesión 24 y sumaba 89 frente a 90), aunque la tabla se leyó en el mismo turno | SETTINGS §1.2.6, "Generar, verificar, consumar" | la lectura del backlog se usó para el número y las categorías, no para verificar su cuadratura | SETTINGS | PAT-02, paquete emitido sin verificar la cuadratura del backlog que consume | cifras-datos: el total del resumen (89) no calzaba con la nota de conteo (1-90) leída en el mismo turno | 0 | 1 cierre detenido en F5; 1 reemisión del paquete; 1 commit de reparación del backlog |

**Propuesta de entrada de catálogo (por el `PAT-NUEVO`):** `PAT-14 · Esperado falso por construcción`: un paso de verificación exige un estado que el paso anterior del mismo bloque vuelve imposible (p. ej., árbol limpio después de editar y antes de commitear). Salvaguarda sugerida: al redactar cada `esperado`, preguntar qué deja en el árbol el paso inmediatamente anterior.

**Fricciones:**

- friccion: el detalle por año en orden ascendente obligaba a hacer scroll para ver el vigente → a5 lo devolvió a "vigente primero" y la regla quedó en §7.
- friccion: la tinta oscura en tres cabeceras (a2) no gustó frente a la maqueta → variante P11 con cabeceras oscuras y texto blanco en las cuatro.
