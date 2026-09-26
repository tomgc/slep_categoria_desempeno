# Traspaso de cierre: slep_categoria_desempeno v31

## 1. Identificación

- **Proyecto:** slep_categoria_desempeno
- **Versión:** v31
- **Fecha:** 2026-09-25
- **Sesión:** 31, CONTINUATION. Foco: cerrar el pendiente #1 del traspaso v30 (seis defectos visibles de narrativa y UI), poner al día la suite de documentación con `suitedoc` fuera de renv (#2) y retirar el CSS muerto del motor (#3), desplegando cada cambio verificado.
- **Entorno:** chat (Cowork, con el repositorio conectado: apertura 0bis a mano, lectura de código y de logs, mediciones previas a cada encargo, redacción de encargos) + Claude Code (`/apertura` y cinco encargos autónomos, a6 a a10). Modelo configurado en el chat: `claude-opus-5-5`; los encargos declaran Opus 5.5.
- **Normativos usados:** `POLITICA_PROYECTO.md` con encabezado `> **Versión 5.8 — vigente.**`; `SETTINGS_Y_PROMPTS_OPERACIONALES.md` con encabezado `> **Versión 38.**` (las mismas que citó el traspaso v30).
- **Archivos principales modificados:** `30_procesamiento/33_app.jsx`, `30_procesamiento/33_motor_template.html`, `docs/index.html` (tres despliegues), `.renvignore` (nuevo), `50_documentacion/suite/documentar.R`, `50_documentacion/suite/documentacion_proyecto_slep_categoria_desempeno_standalone.html`; documentos nuevos en `50_documentacion/activa/encargos/` (a6 a a10), `50_documentacion/andamios/logs/` (5 logs) y `50_documentacion/andamios/20260925_errores_asistente_sesion31.md`.

## 2. Resumen ejecutivo

La sesión abrió sin eco de `/apertura`: el control 0bis se corrió a mano desde el shell del computador y pasó 5/5; luego `/apertura` marcó la sesión abierta (`0396c2a`). La duda de renv quedó medida: el único desfase era `suitedoc`, usado en la suite y no registrado en el lock. El pendiente #1 se cerró en tres encargos: el a6 corrigió la frase 3 de la narrativa (vacía o con el establecimiento hablando de sí mismo), el espacio de la nota de cobertura y el foco tras "Limpiar", y congeló las dos correcciones de ancho porque el encargo exigía esperados inalcanzables; el a7 publicó el botón de territorio con puntos suspensivos y volvió a congelar las pestañas por otro esperado mal calculado; el a8 las publicó con un margen de 8 px, cuya cuenta quedó escrita en el encargo. El a9 agregó `.renvignore` para la suite (renv sin avisos) y documentó en la suite la paleta v2 con contraste AA y el orden temporal; el criterio heredado del traspaso v30 para #2 medía tokens del tema de `suitedoc` y se corrigió antes del encargo. El a10 retiró 157 clases de CSS muerto (196 reglas) con render idéntico en 30 estados y un motor 23.385 bytes más liviano. El sitio publicado sirve `587f4233…` y la revisión en Safari de iPhone la hizo el titular. Cinco errores de redacción de encargos quedaron registrados, tres de ellos del mismo patrón (esperado falso por construcción). Sin fallas funcionales.

## 3. Estado al cierre

**Funciona:** motor publicado en GitHub Pages con md5 `587f4233baf7561f332235780a04805a`, idéntico a `docs/index.html` del commit `812aab1` (fuente: `curl` del sitio y `md5sum`, sesión 31). Payload con `fecha_generacion` normalizada: SHA `d9895a78568c9bdc8aeac3eaa082f93d0666fe56a16d88d9365ffc770b0a0442`, sin cambio en toda la sesión (fuente: LOG a6 a a10). `tests/auditar_cifras.R` (F1 a F4) y `tests/spot_check_publicado.R` en verde con renv activo en cada build (fuente: LOG a6 a a10). `renv::status()`: "No issues found -- the project is in a consistent state." (fuente: LOG a9, T1 y FASE R). `main` en `c3eb5cf` (previo al commit de cierre), igual a `origin/main`, árbol limpio (fuente: `git rev-parse` y `git status --porcelain`, sesión 31). Revisión visual en Safari de iPhone: hecha por el titular, sin observaciones.

**No funciona / pendiente:** ninguna falla funcional. Quedan dos dudas registradas (§11, compuerta de dudas).

**Delta respecto a v30:** cerrados los pendientes #1, #2 y #3 del traspaso v30 y la duda de renv. Siguen abiertos #4 a #10 (con #8 propuesto para cerrar, §11). Veinte commits propios entre `0396c2a` y `c3eb5cf`.

## 4. Registro detallado de cambios

### 4.1 Narrativa: frase 3 y nota de cobertura (a6 T1)

- **Qué:** `33_app.jsx`, `narrativaTerritorial`, frase 3: con un establecimiento como sujeto y matrícula del nivel > 0, la frase pasa a "Considerando la matrícula 2025, el establecimiento tiene N estudiantes en el nivel." (C2); cuando la matrícula del nivel no está ni en Medio/Alto ni en Insuficiente (solo Medio-Bajo), la frase se omite (C1). En `NotasMetodologicas`, `el<b>Simce 2022</b>` → `el{" "}<b>Simce 2022</b>` (C3). Commit `3bc0c57`.
- **Categoría:** Diseño UI — Motor base y diseño.
- **Por qué:** defectos visibles anotados en los logs a2 y a3 (pendiente #1 del traspaso v30); textos C1 y C2 aprobados por el titular al lanzar el a6.
- **Cómo se verificó:** reproducción antes y después en estados elegidos por programa desde el payload (N1 comuna solo Medio-Bajo, N2 y N3 establecimientos): `Considerando la matrícula 2025, .` 2 → 0; `a uno de desempeño` en N3 1 → 0; `elSimce 2022` 1 → 0; `textContent` 28/28 igual salvo las cadenas declaradas; re-derivado por `innerText` (fuente: LOG a6, T1 y FASE R).

### 4.2 Foco tras "Limpiar" en el comparador (a6 T3)

- **Qué:** `33_app.jsx`, `ComparativaSheet`: el `onClick` de "Limpiar" fija `focoTrasQuitar.current = entidades.length` y reutiliza el efecto a1-F04, que deja el foco en "+ Agregar". Commit `eabf8ad`.
- **Categoría:** Accesibilidad y usabilidad.
- **Cómo se verificó:** foco `BODY` → `BUTTON.cmp-add-btn` tras clic y tras Enter; quitar chips sin cambio; re-derivado por `focusin` (fuente: LOG a6, T3 y FASE R).

### 4.3 Botón de territorio en pantallas angostas (a7 T2)

- **Qué:** JSX: `title={entity.nom}` y el nombre en `<span className="entity-select-nom">`; CSS: `.entity-select-btn` con `gap: 4px` (antes 8), `max-width: 100%` y `min-width: 0`; reglas nuevas `.entity-select-nom` (recorte con puntos suspensivos) y `.controls-bar .control-group { min-width: 0; max-width: 100%; }`. Commit `2c779fb`.
- **Categoría:** Accesibilidad y usabilidad.
- **Por qué:** a 320 px, con un nombre largo, el botón ocupaba 9 líneas y la barra fija el 68% del alto. El candidato del a6 (con `gap: 8px`) cortaba el SLEP por defecto; el titular aprobó bajar el `gap` a 4 px.
- **Cómo se verificó:** a 320 px, 147,7 × 180 (9 líneas, barra 385 px) → 146,9 × 36 (1 línea, barra 241 px); SLEP por defecto 104/104 sin recorte en 5 anchos; ▾ a ±0,1 px de la base (fuente: LOG a7, T2 y FASE R).

### 4.4 Pestañas del modal en pantallas angostas (a8 T1)

- **Qué:** template, `@media (max-width: 560px) { .modal-tabs { padding: 0 16px; flex-wrap: wrap; } .modal-tab { margin-right: 8px; } }`. Commit `59946c8`.
- **Categoría:** Accesibilidad y usabilidad.
- **Por qué:** "Establecimiento" quedaba cortada a 320, 360, 375 y 390 px. Dos intentos previos se congelaron por esperados mal calculados (§15). Cuenta del a8: 279,2 + 4 × 8 = 311,2 ≤ 318 px a 390.
- **Cómo se verificó:** 4/4 pestañas completas en los cuatro anchos, una fila a 390 y dos en los demás con cualquier pestaña activa, subrayado de 2 px, `scrollHeight − clientHeight` = 1 como la base; re-derivado por bandas de tinta en 16 capturas (fuente: LOG a8, T1 y FASE R).

### 4.5 Despliegues (a7 T3 y a8 T2)

- **Qué:** `1d9b9d9` publica C1, C2, C3, C5 y C6 (md5 `d58d2f2c…`); `69c32b4` publica C4 (md5 `2e408857…`).
- **Cómo se verificó:** md5 de `docs/index.html` = md5 del build; SHA del payload `d9895a78…0442`; sitio publicado comprobado con `curl` tras cada despliegue (sesión 31).

### 4.6 Suite fuera del análisis de renv (a9 T1)

- **Qué:** `.renvignore` nuevo con `50_documentacion/suite/`. Commit `a730fdb`.
- **Categoría:** Migración y publicación / DevOps.
- **Por qué:** `renv::status()` avisaba "out-of-sync" solo por `suitedoc` (M0 del a6); opción A aprobada por el titular (la B ataba el lock a una fuente local).
- **Cómo se verificó:** `renv::status()` → "No issues found"; el motor construye idéntico con renv (`2e408857…`) y las pruebas del dato siguen en verde (fuente: LOG a9, T1).

### 4.7 Suite de documentación al día (a9 T2)

- **Qué:** `documentar.R` suma dos decisiones: "Paleta de categorías con contraste WCAG 2.1 AA" y "Orden temporal según la forma de la vista"; suite regenerada sin renv (`RENV_ACTIVATE_PROJECT=FALSE`) con `suitedoc` 0.3.0 y lucide-static 1.21.0. Commit `961538b`.
- **Categoría:** Documentación de proyecto.
- **Por qué:** pendiente #2 del traspaso v30, con el criterio corregido: `EE2D49` y `E88663` eran tokens del tema de `suitedoc` (`--mk-red`, `--coral`), no la paleta de categorías (§15, fila 5).
- **Cómo se verificó:** las dos decisiones aparecen en la sección 4 de `documentacion_proyecto_…_standalone.html`; los otros tres HTML y el CSS salen byte a byte iguales; 0 solicitudes de red al abrir los cuatro (fuente: LOG a9, T2 y FASE R).

### 4.8 CSS muerto retirado (a10 T1) y despliegue (a10 T2)

- **Qué:** template, bloque `<style>`: 196 reglas borradas (157 clases sin uso en `33_app.jsx`, el resto del template ni `33_generar_html.R`), 1 `@media` que quedó vacío y el selector `.select` en dos listas mixtas. Commits `596d1fb` y `812aab1` (md5 `587f4233…`).
- **Categoría:** Calidad de código / pipeline.
- **Por qué:** pendiente #3 del traspaso v30. La lista se midió en la sesión 31 (el inventario del a3 cubría solo los usos de `--border-2` y marcaba `.tooltip` como muerta, pero está viva).
- **Cómo se verificó:** capturas, `textContent` y 28 propiedades computadas por elemento idénticas en los 30 estados; segundo camino con un decodificador PNG propio; control positivo (borrar `.entity-select-btn` en una copia se detecta en 23 estados); template 134.601 → 111.216 bytes (fuente: LOG a10).

## 5. Backlog acumulativo

Seis entradas nuevas (numeración provisional c.98 a c.103; el ejecutor renumera desde disco). Sin categorías nuevas ni reclasificaciones. Las entradas de ancho y foco (c.99 y c.100) refuerzan "Accesibilidad y usabilidad", creada en la sesión 30.

## 6. Bugs de la sesión

No aplica en esta sesión como bug de código del pipeline o del motor: los seis defectos corregidos venían inventariados como pendiente #1 del traspaso v30 (bugs visibles ya documentados, sin causa raíz nueva). Los tropiezos de la sesión fueron de redacción de encargos y están en §15.

## 7. Aprendizajes y restricciones

- **Un esperado de encargo se calcula antes de exigirse (B.4).** Si el LOG anterior trae las medidas (posiciones, anchos, valores de base), el esperado se deriva de ellas por cuenta escrita en el encargo. Ejemplo: el a7 exigió una fila a 390 px sin hacer la cuenta (343,2 contra 318 px) y el a8 la escribió (311,2 ≤ 318) y pasó al primer intento.
- **Un criterio heredado es hipótesis hasta medirlo (B.1).** Antes de proponer un criterio de un traspaso, verificar con un `grep -n` qué mide. Ejemplo: `EE2D49|E88663` en la suite medía el tema de `suitedoc`.
- **Un inventario heredado se re-mide contra el código actual.** Ejemplo: el inventario de CSS del a3 cubría solo `--border-2` y marcaba viva como muerta `.tooltip`.
- **Un `span` dentro de un botón `inline-flex` convierte el texto vecino en otro ítem flex:** el `gap` reemplaza al espacio y `innerText` los separa con un salto de línea. Ejemplo: el SLEP por defecto se cortaba a 320 px con `gap: 8px`.
- **`overflow` distinto de `visible` en un contenedor flex arrastra el otro eje y deja encoger a sus ítems.** Ejemplo: la forma B del a6 volvía desplazable la fila de pestañas y recortaba el subrayado.
- **La suite se regenera sin renv.** `RENV_ACTIVATE_PROJECT=FALSE`, con `suitedoc` en la biblioteca del sistema; el motor se sigue construyendo con renv.
- **Contar frases por `grep` sobre HTML falla si el marcado las parte;** para conteos de texto visible, usar el DOM (`innerText`).
- **Leer el LOG completo de cada encargo antes de responder al reporte de Claude Code** (pedido del titular, vigente para todas las sesiones).

## 8. Decisiones de diseño

- **Frase 3 de la narrativa (C1, C2):** variante propia para un establecimiento como sujeto (como la frase 1 del a2) y omisión de la frase sin matrícula en Medio/Alto ni Insuficiente. Alternativa descartada: nombrar Medio-Bajo, que rompía el contraste B2 (Medio/Alto contra Insuficiente).
- **Botón de territorio (C5):** recorte con puntos suspensivos y nombre completo en `title`, `gap: 4px`. Alternativa descartada: el `gap: 8px` del candidato del a6, que cortaba el SLEP por defecto.
- **Pestañas del modal (C4):** segunda fila cuando no caben (`flex-wrap`), margen de 8 px. Alternativas descartadas: `overflow-x: auto` (scroll a 390 px, subrayado recortado) y margen de 16 px (dos filas a 390).
- **renv (opción A):** `.renvignore` para la suite en vez de registrar `suitedoc` en el lock.
- Sin archivos de decisión nuevos: son ajustes de UI y de entorno sin peso arquitectónico; quedan en este traspaso, en los encargos y en el backlog.

## 9. Constantes y parámetros

| Constante | Valor anterior | Valor nuevo | Archivo | Motivo |
|---|---|---|---|---|
| `.entity-select-btn` `gap` | `8px` | `4px` | template `<style>` | C5 |
| `.modal-tabs` a ≤ 560 px | `padding: 0 22px`, sin `flex-wrap` | `padding: 0 16px; flex-wrap: wrap` | template `<style>` | C4 |
| `.modal-tab` `margin-right` a ≤ 560 px | `24px` | `8px` | template `<style>` | C4 |

Las demás constantes siguen vigentes en `33_generar_html.R` (`CAT_COLORS`) y en el `:root` del template.

## 10. Arquitectura de archivos

Escáner regenerado por el ejecutor del cierre. Cambios de estructura: `.renvignore` nuevo en la raíz; cinco encargos en `activa/encargos/`; cinco logs en `andamios/logs/`; `andamios/20260925_errores_asistente_sesion31.md`. El `<style>` del template pasó de las líneas 8–1535 a 8–940. Deuda heredada sin cambio: no existe `50_ordenacion_repositorio.md` (pendiente #4); un `.R` vive en `20_insumos/auxiliares/` (desviación de la auditoría de apertura, pregunta 4).

## 11. Pendientes y ruta sugerida

### Inventario

| # | Descripción | Tipo | Impacto | Complejidad | Criterio de éxito sugerido |
|---|---|---|---|---|---|
| 4 | Ordenación del repositorio (política v5.5, SETTINGS §4.7): obsoletos, nomenclatura, escáner; incluye el `.R` de `20_insumos/auxiliares/` y los 11 comentarios huérfanos del `<style>` listados en el LOG a10 | deuda heredada | bajo | media | existe `50_ordenacion_repositorio.md` con el conteo por bloque; PR abierto |
| 5 | Guarda de locale UTF-8 (POLITICA §5.2bis): no existe `50_locale_utf8.md` ni `10_utils/10_configuracion.R` | deuda heredada (bloqueada) | bajo | baja; el punto de arranque lo decide el titular | guarda instalada y vista fallar; marcador creado |
| 6 | Re-clonar clones previos (historial reescrito en v27) | administrativo manual | bajo | baja | ningún clon con hashes previos a v27 |
| 7 | Uso del color (WCAG 1.4.1): las marcas de trayectoria comunican la categoría solo por color | mejora de accesibilidad (decisión de diseño) | medio | media | segunda señal visible aprobada por el titular |
| 8 | `CLAUDE.md` ausente en la raíz: propuesto para cerrar, porque `.gitignore` lo excluye por decisión del proyecto (commit `198a008`); existe una copia local ignorada | documentación | bajo | baja | titular confirma el cierre |
| 9 | Hermanos (`slep_idps`, `slep_simce_adecuado`): medir si comparten `--fg-3` #747474 y `--border-2` #C8BDA0 | observación para otros proyectos | (fuera de este repo) | baja | medido en esas sesiones |
| 10 | D-22: ¿la categorización con Simce 2025 llegará como preliminar? | duda del titular | futuro | n/a | respuesta del titular |
| 11 | Llevar la propuesta PAT-14 (esperado falso por construcción, 2 ocurrencias en la sesión 31 y 1 en la 30) al catálogo de patrones | gobernanza (sesión BIBLIOTECA) | medio | baja | entrada PAT-14 en el catálogo vigente |

### Evaluación de deuda técnica

Zona frágil principal: el bloque transpilado del template (M-DERIVA la mide; sin deriva en toda la sesión). El CSS quedó sin reglas muertas; los comentarios huérfanos son cosmética. Oportunidad: versionar como prueba en R el SHA normalizado del payload (F19 y D-24 del plan de v30).

### Auditoría de cierre (POLITICA 5.6, preguntas de cierre)

- 2. ¿El pipeline corre de cero sin intervención manual? → Sí para el paso 33 (`run_all(only = 33)` en cada build de a6 a a10, con renv activo); el pipeline completo no se corrió en esta sesión.
- 5. ¿Cada transformación crítica tiene check? → Sí: `auditar_cifras.R` (F1 a F4) y `spot_check_publicado.R` en verde en cada build.
- 6. ¿Outputs reproducibles e idempotentes? → Sí: builds repetidos con el mismo md5 (a7, a8, a10) y suite regenerada idéntica dos veces (a9).
- 7. ¿Decisiones como constantes nombradas? → Sí: paleta y tintas como tokens del `:root` y `CAT_COLORS`; los valores de C4 y C5 van en reglas CSS con comentario.
- 8. ¿Nombres sin tildes, ñ ni espacios? → Sí en todos los archivos nuevos.
- 9. ¿Guarda `asegurar_locale_utf8()` instalada y vista fallar? → No: pendiente #5.

### Compuerta de dudas

| supuesto | predicado | medicion | destino |
|---|---|---|---|
| C4 y C5 se ven en Safari igual que en Chrome | en Safari de iPhone, 4 pestañas completas y botón en una línea con "…" | revisión del titular en su iPhone | **cerrada en sesión** (titular: "chequeado y ok") |
| La suite se puede regenerar desde la otra estación | `packageVersion("suitedoc")` sin renv devuelve 0.3.0 en la otra estación | `RENV_ACTIVATE_PROJECT=FALSE Rscript -e 'packageVersion("suitedoc")'` en esa máquina | **registrada** |
| Los 70 avisos de codificación de `suitedoc` no afectan a otros proyectos | `generar_suite()` con `options(warn = 1)` da 0 avisos "cannot be translated" | corrida con avisos visibles en `herramientas_dev` | **registrada** (alcance del kit, no de este repo) |

### Ruta sugerida

1. Pendiente #4 (ordenación del repositorio, con los comentarios huérfanos): deuda heredada de la auditoría de apertura; encargo con rama propia y PR.
2. Confirmar el cierre de #8.
3. Ofrecer #5 cuando el titular defina el punto de arranque; diferir #7 a una sesión de diseño y #11 a una sesión BIBLIOTECA.

## 12. Instrucciones específicas para la próxima sesión

- ⚠️ NO editar el bloque transpilado del template sin pasar por `33_app.jsx` y retranspilar.
- ⚠️ NO medir colores sin desactivar transiciones y animaciones.
- ⚠️ NO correr `git` de lectura desde el shell del computador sin `GIT_OPTIONAL_LOCKS=0`.
- ⚠️ NO exigir en un encargo un esperado sin derivarlo de medidas ya tomadas (cuenta escrita en el encargo) ni un criterio heredado sin comprobar qué mide.
- ✅ ANTES de cualquier encargo sobre el motor, medir M-DERIVA (retranspilación = bloque del template).
- ✅ ANTES de desplegar, verificar el SHA normalizado del payload y las pruebas del dato.
- ✅ ANTES de responder a un reporte de Claude Code, leer el LOG completo del encargo.
- ✅ ANTES de regenerar la suite, correr sin renv (`RENV_ACTIVATE_PROJECT=FALSE`) y comprobar `suitedoc` 0.3.0 en esa estación.
- 🔒 Payload y cifras: ningún cambio visual altera el payload salvo `meta.cat_colors` por decisión escrita.
- 🔒 Orden temporal: trayectoria ascendente, detalle vigente primero.

## 13. Fragmentos de código de referencia

Sin patrones nuevos en R. Las recetas de verificación de la sesión (estados N elegidos por programa, estilos computados por elemento, decodificador PNG propio, generación de la suite sin renv) viven en los logs `20260925_*_a6` a `a10` de `50_documentacion/andamios/logs/`.

## 14. Reapertura

**Mensaje de apertura pre-armado:**

> Sesión 32, CONTINUATION: slep_categoria_desempeno. El protocolo (POLITICA_PROYECTO.md + SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del proyecto; léelo desde ahí. La carpeta del repo (/Users/tomgc/Projects/slep_categoria_desempeno) está conectada: lee el traspaso vigente completo desde 50_documentacion/traspasos/traspaso_cierre_v31.md y ejecuta tú el control de apertura 0bis (SETTINGS §1.2.2) sobre el disco, con GIT_OPTIONAL_LOCKS=0 en todo git de lectura; si no pego eco de /apertura, decláralo en el acuse. Todo lo que no midas en esta sesión es hipótesis. Estado: motor publicado con los seis defectos del pendiente #1 corregidos y sin CSS muerto; suite de documentación al día; renv sin avisos; repo limpio. Foco propuesto: pendiente #4 (ordenación del repositorio, con los comentarios huérfanos del CSS). Espero el acuse en pantalla con el 0bis medido y la ruta de la Fase C con recomendación explícita.

**Documentos para la próxima sesión:**

1. *Protocolo en knowledge base* (no se adjuntan): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
2. *Opcionales según foco:* protocolo §4.7 de SETTINGS (ordenación del repositorio), que vive en la knowledge base.
3. *Específicos:* ninguno que adjuntar; el traspaso v31 se lee desde la carpeta conectada.

**Nota final obligatoria:** si algún archivo listado cambió entre sesiones, adjuntar la versión más actualizada al abrir y avisarlo en el mensaje de apertura.

## 15. Errores del asistente

| momento | disparador | que_paso | regla_violada | causa_raiz | salvaguarda_presente | patron | gatillo_observable | intentos_previos | costo |
|---|---|---|---|---|---|---|---|---|---|
| Redacción del encargo a6, §1, fila C4 | asistente lo señaló espontáneamente al leer el LOG a6 | la forma B de C4 (`overflow-x: auto`) quedó dentro de la misma `@media (max-width: 560px)` que cubre 390 px, donde el propio encargo exigía "sin scroll"; si la medición a 320 exigía B, el esperado a 390 se volvía inalcanzable | instrucción del titular en el mensaje de apertura de la sesión 31 ("cada esperado debe ser alcanzable donde se ubica"); SETTINGS §1.2.6, "Generar, verificar, consumar" | la forma B se condicionó a una medición a 320 px sin propagar que su CSS también actuaba a 390 px | instrucción de la sesión; traspaso v30 §15 (propuesta PAT-14) | PAT-NUEVO-esperado-falso-por-construccion, segunda ocurrencia (la propuesta PAT-14 del traspaso v30 sigue fuera del catálogo vigente) | encargos-premisas: la fila C4 ubicaba B en `@media (max-width: 560px)` y el criterio de T2 pedía 390 px sin scroll | 0 | T2 congelada; T4 sin despliegue; 1 encargo adicional (a7) |
| Redacción del encargo a6, §1, fila C5 | asistente lo señaló espontáneamente al leer el LOG a6 | el JSX de C5 envolvió el nombre en un `span` y dejó « ▾» como segundo ítem flex; el `gap: 8px` del botón reemplazó al espacio y el SLEP por defecto se lee «Costa Cent…» a 320 px | SETTINGS §1.2.6, "Fuente primaria de una ESTRUCTURA es su inspección"; `encargo_autonomo_claude_code_v1.md` (alcance cerrado que cubra los efectos) | la regla `.entity-select-btn { gap: 8px }` se leyó en la sesión, pero no se evaluó su efecto sobre el ítem flex nuevo | SETTINGS; encargo_autonomo_claude_code_v1.md | PAT-07, restricción leída no propagada al diseño del encargo | restriccion-no-propagada: el CSS leído decía `display: inline-flex; gap: 8px` y el cambio creaba un segundo ítem flex | 0 | C5 congelado; mismo encargo adicional (a7, compartido) |
| Redacción del encargo a7, §1, fila C4 | asistente lo señaló espontáneamente al leer el LOG a7 | se exigió una sola fila a 390 px con `padding: 0 16px` y `margin-right: 16px` sin calcular el ancho con las posiciones de pestaña ya medidas en el a6 (pestañas 279,2 px + 4 × 16 = 343,2 px contra 318 px disponibles): el esperado era inalcanzable con la lista cerrada | instrucción del titular en el mensaje de apertura de la sesión 31 ("cada esperado debe ser alcanzable donde se ubica"); SETTINGS §1.2.6, "Generar, verificar, consumar" | la forma se eligió por su comportamiento cualitativo (`flex-wrap` parte solo si no cabe) y no se hizo la cuenta con las cifras disponibles en el LOG a6 | instrucción de la sesión; esta misma tabla (fila 1) | PAT-NUEVO-esperado-falso-por-construccion, tercera ocurrencia (segunda en la sesión) | encargos-premisas: el LOG a6 traía las posiciones de las cuatro pestañas y el criterio pedía una fila a 390 px sin verificación aritmética | 1 (a6, fila 1 de esta tabla, mismo defecto C4) | T1 del a7 congelada; C4 sin publicar; 1 encargo adicional (a8) |
| Redacción del encargo a7, T1, criterio `scrollHeight ≤ clientHeight` | asistente lo señaló espontáneamente al leer el LOG a7 | se exigió `scrollHeight ≤ clientHeight` en `.modal-tabs` aunque el LOG a6 ya había medido 44/43 en la base por el `margin-bottom: -1px` del subrayado: el criterio contradecía el de subrayado completo de 2 px | SETTINGS §1.2.6, "Fuente primaria de una ESTRUCTURA es su inspección"; `encargo_autonomo_claude_code_v1.md` (criterio alcanzable) | el criterio se redactó como proxy genérico de "sin scroll" sin contrastarlo con el valor de base que el LOG a6 declaraba | SETTINGS; encargo_autonomo_claude_code_v1.md | PAT-07, restricción leída no propagada al criterio de aceptación | restriccion-no-propagada: el LOG a6 (T2) decía "vertical clientHeight 43 scrollHeight 44" y el criterio exigía ≤ | 0 | duda Q-SH al titular; compartido con la fila anterior |
| Acuse de apertura de la sesión 31, Fase C, prioridad 2 | asistente lo señaló espontáneamente al preparar el encargo a9 | se propuso como criterio de éxito del pendiente #2 `grep -c 'EE2D49\|E88663'` = 0 en `50_documentacion/suite/`, copiado del traspaso v30 sin verificar qué medía: esas cadenas son tokens del tema de `suitedoc` (`--coral`, `--mk-red` en `suite_estilos.css` y en el CSS embebido), no la paleta de categorías, que `documentar.R` nunca cita | SETTINGS §1.2.6, marcador de fuente S-01 (premisa de un encargo con fuente de esta sesión); SETTINGS §2.2.15, PAT-13 | el criterio heredado se trató como hecho verificado y no como hipótesis, y no se abrió la suite antes de proponerlo | SETTINGS | PAT-13, criterio de aceptación que mide un proxy (cadenas hex) y no el riesgo (decisiones de paleta ausentes de la suite) | encargos-premisas: el traspaso v30 fijaba el criterio y el acuse lo repitió sin un `grep -n` sobre la suite | 0 | ninguno (detectado antes de redactar el encargo a9) |
| Respuesta a la pregunta del titular sobre dudas de la sesión (después del a10) | asistente lo señaló espontáneamente al redactar el paquete de cierre | se comunicó que la propuesta PAT-14 sumaba "tres casos en esta sesión", cuando la tabla de errores tiene dos filas con ese patrón en la sesión 31 (la tercera es PAT-07) | SETTINGS §1.2.6, marcador de fuente S-01 (toda cifra comunicada con recuento programático del mismo turno) | la cifra se dio de memoria, sin contar las filas del registro | SETTINGS; userPreferences (marcador de fuente) | PAT-01, cifra comunicada sin recuento | cifras-datos: el registro de errores estaba en disco y no se contó antes de citar la cifra | 0 | ninguno (corregido en el traspaso: 2 en la sesión 31 y 1 en la 30) |

**Propuesta de entrada de catálogo (por el `PAT-NUEVO`):** se reitera la del traspaso v30: `PAT-14 · Esperado falso por construcción`: un paso de verificación exige un estado que la propia forma del encargo vuelve imposible (un esperado incompatible con el cambio que el mismo bloque aplica, o no derivado de las medidas disponibles). Salvaguarda sugerida: todo esperado geométrico o numérico va acompañado de su cuenta con las cifras del LOG anterior, escrita en el encargo. Evidencia: 1 caso en la sesión 30 y 2 en la 31 (filas 1 y 3).

**Fricciones:**

- friccion: el titular tuvo que pedir en cada reporte de Claude Code que se leyera el LOG → el LOG completo se lee siempre antes de responder, sin pedirlo (§7 y §12).
- friccion: tres encargos para cerrar las pestañas del modal (a6, a7, a8) → cuenta escrita en el encargo (§7).
