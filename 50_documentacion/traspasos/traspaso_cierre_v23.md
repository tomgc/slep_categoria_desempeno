# Traspaso de cierre — slep_categoria_desempeno · v23

## 1. Identificación

- **Proyecto:** slep_categoria_desempeno
- **Versión de traspaso:** v23
- **Fecha:** 2026-06-19
- **Sesión:** 23 — foco: reconstrucción de la fuente JSX del motor (`33_app.jsx`) perdida en C3, más actualización de la suite de documentación post-C3 y administrativos de apertura.
- **Entorno:** R 4.5.x en Positron (macOS aarch64); repo Git en `~/Projects/slep_categoria_desempeno`; Rama A (todos los datos públicos, versionados en el repo).
- **Archivos principales modificados/creados:** `30_procesamiento/33_app.jsx` (nuevo); `50_documentacion/activa/decisiones/20260619_reconstruccion_app_jsx.md` (nuevo); `50_documentacion/suite/documentar.R` (reubicado desde raíz) + los 4 HTML de la suite; `50_documentacion/activa/backlog_consolidado.md`; snapshots del escáner.

## 2. Resumen ejecutivo

La sesión 23 abrió como CONTINUATION sobre un proyecto sano (sin deuda técnica viva tras C3) y cerró cuatro frentes. Primero, los administrativos de apertura heredados: versionado de la rotación de snapshots del escáner, consolidación de la fila s22 (N=0) en el backlog, y saneamiento del traspaso v22 que había quedado untracked (A35 fallido por 5ª vez, ahora corregido). Segundo, el foco propuesto: la suite de documentación se actualizó en sus 3 puntos de stack para reflejar el motor post-C3 (sin Babel, cero dependencias de red), regenerando los 4 HTML. Tercero y de mayor peso, se cerró el único pendiente sustantivo abierto: la fuente JSX del motor, perdida cuando C3 transpiló a `React.createElement` sin versionar el origen (deuda A34). Se reconstruyó `33_app.jsx` por transformación inversa y se verificó su fidelidad por equivalencia de AST (retranspila idéntico al motor actual). Cuarto, se reubicó `documentar.R` a su ruta canónica `50_documentacion/suite/` (política 4.6.3.5). El backlog cerró en 88 (una entrada nueva, la 88). El motor en producción no cambió en toda la sesión: `33_app.jsx` es fuente para ediciones futuras, no se inyecta. El repo quedó limpio y sincronizado en `origin/main` (`34e1292`).

## 3. Estado al cierre

**Qué funciona:**
- Pipeline completo operativo (sin cambios desde v21; última corrida end-to-end verde en s21).
- Motor 100% autocontenido en producción (`docs/index.html`, `motor_categoria.html`): React/ReactDOM/D3/pako inline, cuerpo en `React.createElement`, cero dependencias de red (C3, s21). **No tocado en s23.**
- Suite de documentación (4 HTML) regenerada y consistente con el motor post-C3.
- `33_app.jsx` versionado como fuente editable del motor, verificado por AST.
- Auditoría F1-F4 y spot-check: en verde desde s21 (no re-corridos en s23 porque no se tocó ninguna cifra).

**Qué no funciona / pendiente:** nada bloqueante. Sin bugs activos. Sin deuda técnica viva.

**Delta respecto a v22:**
- `+33_app.jsx` (nuevo, fuente del motor) y su decisión de reconstrucción.
- Suite de documentación actualizada post-C3 (3 puntos de stack en 2 de los 4 HTML técnicos; los 2 generales no cambiaron por no contener stack).
- `documentar.R` movido de raíz a `50_documentacion/suite/`.
- Backlog 87 → 88.
- 7 commits nuevos sobre v22 (ver §4).

## 4. Registro detallado de cambios

Un bloque por cambio conceptualmente independiente.

### 4.1 — Rotación de snapshots del escáner (apertura s23)
- **Archivos:** `50_documentacion/estructura/` (snapshots `081709`, `163723`, poda de `211742` y `215605`, aliases).
- **Categoría:** Migración y publicación / DevOps (administrativo, no cuenta como cambio de backlog).
- **Qué:** versionado de la rotación con poda de retención 2 (política 7.4).
- **Verificación:** `git status` limpio tras cada commit; aliases apuntando al snapshot más reciente.
- **Commits:** `a1da6c3` (rotación 215605+081709, poda 211742), `34e1292` (rotación 081709+163723, poda 215605).

### 4.2 — Versionado del traspaso v22 untracked (A35/A32)
- **Archivos:** `50_documentacion/traspasos/traspaso_cierre_v22.md`.
- **Qué:** el cierre de la s22 generó el traspaso pero no lo versionó (A35 fallido, 5º caso del patrón A32). Se saneó en apertura de s23.
- **Verificación:** `git ls-files` lista el archivo tras el commit.
- **Commit:** `f1c40eb`.

### 4.3 — Consolidación de la fila s22 (N=0) al backlog
- **Archivos:** `50_documentacion/activa/backlog_consolidado.md`.
- **Categoría:** administrativo (no cuenta como cambio).
- **Qué:** fila s22 N=0 en la tabla por sesión + bloque delta v22; total intacto en 87. La s22 no generó cambios contabilizables.
- **Verificación:** tres vistas cuadradas en 87.
- **Commit:** `7d7eac3`.

### 4.4 — Actualización de la suite de documentación post-C3
- **Archivos:** `documentar.R` (3 puntos de stack: `etapas[[5]]$d` + `$flags`, `prosa$doc_pipeline`, `pie_extra$arq_tec`) + `arquitectura_slep_categoria_desempeno.html` + `documentacion_proyecto_slep_categoria_desempeno.html`.
- **Categoría:** Documentación de proyecto (no cuenta como cambio nuevo: mantenimiento de artefacto existente, misma intención que su creación c.86).
- **Qué:** se cambió toda descripción del motor que decía "única dependencia de red: Babel 7.29.0 (CDN)" / "C3 planificada" por "pre-transpilado a `React.createElement`, cero dependencias de red" / "C3 ejecutada". Los 2 HTML generales no cambiaron (no contienen stack); regeneraron byte-idénticos.
- **Verificación:** `grep -i babel` solo devuelve las menciones intencionales (narrativa de C3 ejecutada y ruta del archivo de decisión); `unpkg` de Babel = 0; los 2 generales sin diff.
- **Commit:** `4cb489e`.

### 4.5 — Reconstrucción y versionado de la fuente JSX del motor (entrada 88, A34)
- **Archivos:** `30_procesamiento/33_app.jsx` (nuevo) + `50_documentacion/activa/decisiones/20260619_reconstruccion_app_jsx.md` (nuevo).
- **Categoría:** Migración y publicación / DevOps (cuenta como cambio: c.88).
- **Qué:** C3 dejó el motor sin fuente JSX editable. Se reconstruyó por transformación inversa: extracción del cuerpo de la app del template (1462 líneas, 195 `React.createElement`), reversa a JSX con `babel-plugin-transform-react-createelement-to-jsx`, formato Prettier, limpieza de anotaciones `/*#__PURE__*/`, cabecera de proyecto con instrucciones de retranspilación.
- **Verificación (B.4):** se retranspiló `33_app.jsx` con `runtime: "classic"` y se comparó contra el `createElement` original normalizando por AST — fusión de text-nodes adyacentes, escapes Unicode (`\xB7`==`·`), literales numéricos (`0.10`==`0.1`) → **equivalencia total** (43412 == 43412 chars). El motor en producción no cambia.
- **Commit:** `4fc78be`.

### 4.6 — Reubicación de `documentar.R` a la ruta canónica de la suite
- **Archivos:** `documentar.R` (raíz) → `50_documentacion/suite/documentar.R`.
- **Categoría:** higiene estructural (no cuenta como cambio).
- **Qué:** la política 4.6.3.5 fija la ubicación canónica de la suite (`documentar.R` + tema + 4 HTML juntos en `50_documentacion/suite/`). Se movió desde la raíz. Git lo registró como rename 100%.
- **Verificación:** `git status` muestra `renamed`; `ls-files` confirma la nueva ruta.
- **Commit:** `e8f2222`.

### 4.7 — Consolidación de la entrada 88 al backlog (este cierre)
- **Archivos:** `50_documentacion/activa/backlog_consolidado.md`.
- **Qué:** entrada 88 en el detalle cronológico (sección s23), fila s23 N=1 en la tabla por sesión, categoría DevOps 6→7 en la tabla temática, nota de conteo y delta v23 actualizados.
- **Verificación:** tres vistas cuadradas en 88.
- **Commit:** pendiente en el cierre (junto a este traspaso).

## 5. Backlog acumulativo

Consolidado en `50_documentacion/activa/backlog_consolidado.md`, cerrado en **88 entradas** (1-88), tres vistas cuadradas. Una entrada nueva en s23: la 88 (reconstrucción de la fuente JSX del motor). Las sesiones 22 y 20 figuran con N=0 (solo administrativos). Categoría líder "Diseño UI — Motor base y diseño" en 15% (13/88), bajo el umbral de subdivisión. Delta v23 (87→88) registrado.

## 6. Bugs de la sesión

No hubo bugs de código. Un incidente de método atajado durante la reconstrucción del `33_app.jsx`: la comparación inicial reconstruido-vs-original falló por diferencias de **puro formato** (escapes Unicode `\xB7` vs `·`, fragmentación de text-nodes, `0.10` vs `0.1`). No era un fallo de fidelidad sino de método de comparación: comparar por texto en vez de por AST. Se resolvió normalizando esas tres clases de diferencia antes de declarar equivalencia. Generó el aprendizaje A37.

## 7. Aprendizajes y restricciones descubiertas

- **A37 (nuevo):** la fidelidad de una fuente reconstruida desde código transpilado se verifica por **equivalencia de AST, no de texto**. Tres clases de diferencia son inocuas y deben normalizarse antes de comparar: (a) representación Unicode de caracteres no-ASCII (`\xB7` == `·`); (b) fusión de StringLiterals hijos adyacentes en `createElement` (coalescing de text-nodes, sin efecto en render); (c) grafía de literales numéricos (`0.10` == `0.1`). Contexto: si se compara por string crudo, una reconstrucción fiel parece divergente y se descarta por error. Ejemplo: la verificación del `33_app.jsx` pasó de "NO ✗" (texto) a "SÍ ✓✓✓" (AST normalizado) sin cambiar una línea de la fuente.
- **A35 (reforzado):** versionar el traspaso es el último paso del cierre. Falló en s22 (quedó untracked, saneado en s23, 5º caso del patrón A32). En este cierre v23 se cumple explícitamente.
- **Restricción reforzada (A34):** toda edición futura de la UI del motor se hace sobre `33_app.jsx` y se retranspila con `runtime: "classic"`; el runtime automático (`_jsxDEV`/`_jsx`) NO sirve, el motor inline no puede resolverlo.

## 8. Decisiones de diseño

- **Versionar la fuente JSX del motor sin build en el pipeline (Opción A).** Alternativas consideradas: (B) build real de transpilación en `33_generar_html.R` en cada corrida — descartada por reintroducir toolchain Node/Babel en el pipeline R, justo lo que C3 eliminó del producto, con fragilidad cross-OS; (C) no versionar fuente, solo documentar el procedimiento de reconstrucción — descartada por dejar el motor permanentemente sin fuente editable. Justificación de A: recupera la editabilidad (la deuda real de A34) sin tocar el producto ni el pipeline; el `.jsx` es fuente de verdad para ediciones futuras y la transpilación queda como paso de build manual documentado, externo al motor. Tensión resuelta (modularidad/reproducibilidad vs. simplicidad): se aceptó un artefacto fuente adicional a cambio de editabilidad, sin añadir dependencias vivas. Replicada como archivo en `decisiones/20260619_reconstruccion_app_jsx.md`.

## 9. Constantes y parámetros vigentes

Sin cambios respecto a v22. La reconstrucción no introdujo constantes nuevas. Parámetro de build documentado en la cabecera de `33_app.jsx`: preset `@babel/preset-react` con `{ "runtime": "classic" }` (obligatorio).

## 10. Arquitectura de archivos

Escáner al cierre: `50_documentacion/estructura/estructura_actual.md` (snapshot `20260619_163723`, 21 carpetas / 128 archivos). Cambios estructurales de la sesión, todos conformes a la política:
- `+30_procesamiento/33_app.jsx` (junto al template y el generador; correcto por numeración 33).
- `documentar.R` movido a `50_documentacion/suite/` (ruta canónica 4.6.3.5).
- `+decisiones/20260619_reconstruccion_app_jsx.md`.
- `andamios/` permanece con solo `.gitkeep` (el `.md` de reconstrucción se ubicó en `decisiones/` por ser una decisión autocontenida con su porqué, no un script de refactor congelado).

## 11. Pendientes y ruta sugerida

### Inventario de pendientes
No quedan pendientes sustantivos abiertos. El único pendiente del v22 (suite post-C3) y el pendiente A34 (fuente JSX) quedaron cerrados en esta sesión.

Pendiente menor en seguimiento (no bloqueante, sin solicitud activa):
- **Vigilancia pasiva de `documentar.R`:** si reaparece como `deleted` por algún re-run, restaurar con `git checkout --`. Resuelto de fondo al moverlo a su ruta canónica; queda como nota.

### Evaluación de deuda técnica
Sin deuda técnica viva. El motor es 100% autocontenido (C3) y ahora tiene fuente editable versionada (A34 resuelto). El pipeline corre de cero sin intervención manual. Zonas frágiles: ninguna identificada en esta sesión.

### Auditoría de cierre (política 5.6, preguntas "Cierre")
- #2 ¿pipeline corre de cero sin intervención manual? → Sí (sin cambios desde v21).
- #5 ¿cada transformación crítica tiene check de validación? → Sí (F1-F4 + spot-check, vigentes desde s21; no se tocaron cifras en s23).
- #6 ¿outputs reproducibles e idempotentes? → Sí.
- #7 ¿decisiones metodológicas como constantes nombradas? → Sí.
- #8 ¿nombres sin tildes/ñ/espacios? → Sí (incluido `33_app.jsx`).
Sin respuestas "no": la sesión no deja deuda sin documentar.

### Ruta sugerida para la próxima sesión (s24)
No hay trabajo forzoso pendiente en este proyecto. Opciones, en orden de prioridad sugerida:
1. **Otros proyectos del suite** (`slep_idps`: decisión de agregación territorial pendiente + pipeline P6 con join `niveles ↔ rbd`; `slep_simce_estandares_aprendizaje`: fases 9-10 de migración GitHub diferidas). Estos tienen trabajo sustantivo real, a diferencia de `slep_categoria_desempeno`, que está completo.
   - **Criterio de éxito:** abrir el proyecto elegido como CONTINUATION con su propio traspaso y escáner.
2. **Solo si surge edición de UI del motor:** trabajar sobre `33_app.jsx`, retranspilar con `runtime: classic`, reemplazar el bloque `<script>` del template, regenerar y verificar offline. No hay solicitud activa.

Conviene diferir: cualquier toque cosmético al motor sin solicitud concreta (el producto está estable).

## 12. Instrucciones específicas para la próxima sesión

- 🔒 El motor publicado (`docs/index.html`, `motor_categoria.html`) NO incluye Babel ni runtime de transpilación. Invariante de C3. No reintroducir dependencias de red.
- ✅ ANTES de editar la UI del motor, editar `33_app.jsx` (la fuente), NO el `createElement` del template a mano. Retranspilar con `runtime: "classic"`.
- ⚠️ NO inyectar `33_app.jsx` al template "porque sí": el motor en producción ya tiene el `createElement` verificado. Solo se retranspila cuando hay un cambio real de UI.
- 🔒 Agregación = conteo de establecimientos educacionales (matrícula nunca pondera); básica/media nunca se mezclan; `docs/index.html` no se edita a mano.
- ✅ Terminología institucional (4.6.3.6/D32) en toda la suite: "establecimiento educacional" completo; nunca "EE" visible ni "colegio".
- ✅ Git con `git -C /Users/tomgc/Projects/slep_categoria_desempeno`; verificar reportes de Claude Code contra `git log`. Pegar comandos en terminal SIN comentarios `#` ni encabezados (zsh los interpreta como comandos).

## 13. Fragmentos de código de referencia

**Retranspilación de `33_app.jsx` al template (forma correcta, runtime clásico):**
```
# babel.config.json:
# { "presets": [["@babel/preset-react", { "runtime": "classic" }]] }
npx babel 30_procesamiento/33_app.jsx --out-file app_transpilado.js \
  --presets '@babel/preset-react' --config-file ./babel.config.json
# El output reemplaza el contenido del <script> de la app en
# 33_motor_template.html, entre el comentario "Aplicación React (...)" y </script>.
```

**Verificación de fidelidad por AST (patrón A37):** retranspilar la fuente y comparar contra el original normalizando text-nodes adyacentes, escapes Unicode y literales numéricos antes de declarar equivalencia. La comparación por texto crudo da falsos negativos.

## 14. Reapertura

- **Nombre del chat:** `slep_categoria_desempeno, sesión 24 (Opus 4.8)` — o el nombre del proyecto-hermano que se decida abrir.
- **Mensaje de apertura pre-armado:** "Tipo de sesión: CONTINUATION. El protocolo (POLITICA_PROYECTO.md + SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; léelo desde ahí. Retomamos slep_categoria_desempeno en sesión 24. La sesión 23 cerró el pendiente A34 (fuente JSX del motor reconstruida y verificada), actualizó la suite post-C3 y reubicó documentar.R a su ruta canónica; backlog en 88, sin deuda técnica viva. No hay trabajo forzoso pendiente en este proyecto: evaluar si continuar aquí (solo ante edición de UI) o pivotar a un proyecto hermano con trabajo sustantivo (slep_idps, slep_simce_estandares_aprendizaje). Adjunto el traspaso v23 y el escáner."
- **Documentos para la próxima sesión:**
  1. *Protocolo en knowledge base (no adjuntar):* `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales según foco:* `CLAUDE.md` si correrá en Claude Code; protocolo 4.6 + `documentar.R` si se vuelve a tocar la suite; `33_app.jsx` + `33_motor_template.html` si habrá edición de UI.
  3. *Específicos (sí se adjuntan):* `traspaso_cierre_v23.md` + `estructura_actual.md` (correr el escáner al abrir).
- **Nota final:** si algún archivo listado cambió entre sesiones, adjuntar la versión más actualizada y avisarlo en el mensaje de apertura.
