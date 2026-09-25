# Traspaso de cierre — v26

## 1. Identificación

- **Proyecto:** `slep_categoria_desempeno`
- **Versión:** v26
- **Fecha:** 2026-07-01
- **Sesión:** 26 (Opus 4.8). Foco: regeneración de la suite de documentación en modo standalone offline (HTML autocontenido). Sesión originada como exploratoria (ONE-OFF) de trabajo nuevo transversal; derivó en la activación standalone de esta suite.
- **Entorno:** R 4.5.2 (aarch64-apple-darwin20), Positron, macOS. Repo Git en `~/Projects/slep_categoria_desempeno`, datos públicos versionados (Rama A). npm 11.12.1.
- **Archivos principales modificados:** `50_documentacion/suite/documentar.R` (añadido `standalone = TRUE`, mantenido `verificar = TRUE`); los 4 `*_standalone.html` de la suite; `50_documentacion/suite/suite_estilos.css`; `.gitignore` (reglas para `fonts/` y `assets/` del tema).

## 2. Resumen ejecutivo

Sesión que comenzó como exploración de trabajo nuevo transversal (paquete interno `slepverse` y dashboard maestro de monitoreo) y derivó, por decisión del titular, en la regeneración de la suite de documentación de este proyecto en modo standalone offline. Se ejecutó el procedimiento §4.6.4 vía Claude Code: se añadió `standalone = TRUE` a `documentar.R` (manteniendo `verificar = TRUE`), se regeneró la suite, se verificó empíricamente que los 4 HTML quedaran 100% offline (0 referencias de red accionables; las coincidencias `http://` son todas `xmlns` de SVG inline, no descargas; iconos como `<svg>` embebido; fuentes como `data:` URIs), se sacó el tema (`fonts/` + `assets/`) del índice con `git rm --cached` y se blindó en `.gitignore`. Commit atómico `eff95ef`, pusheado a `origin/main` (fast-forward `514ebda..eff95ef`) tras visto bueno visual del titular. La regeneración de la suite es mantenimiento de un artefacto existente y **no cuenta como cambio nuevo** por la nota metodológica del backlog (precedente v19, v23, v24): el backlog se mantiene en **89 entradas**. Al cierre se identificó un incidente de gobernanza de alta prioridad (PII en historial público) que se difiere a una sesión CONTINUATION dedicada.

## 3. Estado al cierre

- **Qué funciona:** todo lo de v25 sin cambios. Pipeline operativo sin tocar desde v21. Motor autocontenido (C3). Suite de documentación ahora en modo **standalone offline** (los 4 HTML embeben CSS, fuentes, logos e iconos; sin dependencia del tema en disco ni de CDN). Repo sincronizado en `origin/main` (`eff95ef`).
- **Qué no funciona:** nada identificado en el pipeline ni en el motor. **Incidente de gobernanza abierto** (no es un fallo funcional): PII en historial público, ver sección 11.
- **Delta respecto a v25:** suite migrada de enlazada a standalone (4 `*_standalone.html`, swap completo; enlazados eliminados del disco y del índice); `documentar.R` con `standalone = TRUE`; tema fuera del índice y en `.gitignore`. Sin cambios en pipeline, cifras ni motor.

## 4. Registro detallado de cambios

### Mantenimiento de suite — Activación standalone offline
- **Archivos:** `50_documentacion/suite/documentar.R`, los 4 `*_standalone.html`, `suite_estilos.css`, `.gitignore`.
- **Categoría temática:** Documentación de proyecto (mantenimiento de artefacto existente).
- **Qué se hizo:** se añadió `standalone = TRUE` a la llamada `generar_suite()` de `documentar.R` (se mantuvo `verificar = TRUE`, sin razón para cambiarlo); se regeneró la suite; `inlinar_suite` escribió los 4 `*_standalone.html` y limpió los enlazados. Sin iconos faltantes → sin sustituciones. Se sacó el tema (`fonts/` 6 + `assets/` 3) del índice con `git rm --cached` y se agregaron reglas al `.gitignore`.
- **Por qué:** dejar la suite 100% offline, sin dependencia del tema en disco ni de CDN, conforme §4.6.4.
- **Cómo se verificó (empírico, sobre los HTML reales):** referencias de red accionables (`src=`/`href=`/`<link>` a CDN) = 0 en los 4; las coincidencias `http(s)://` son todas `xmlns="http://www.w3.org/2000/svg"` (identificador XML de SVG inline, no descarga); iconos como `<svg>` embebido (0 `<i data-lucide>`, 0 `<script>` de lucide); fuentes como `url(data:...)`. Verificación visual del titular: los 4 HTML renderizan bien.
- **Por qué NO cuenta como entrada de backlog:** la nota metodológica excluye el mantenimiento/regeneración de la suite de documentación (mismo criterio aplicado en delta v19 c.86, v23 y v24). No es una solicitud de producto distinguible, es mantenimiento de un artefacto ya existente. Backlog se mantiene en 89.
- **Registro de ejecución detallado:** el log de Claude Code de esta sesión no se persistió como andamio en `50_documentacion/andamios/logs/`; el detalle paso a paso quedó en el reporte de la sesión de chat. Pendiente menor: si se desea el andamio congelado, regenerarlo desde el reporte.

### Git
- Commit atómico `eff95ef` (`docs(suite): regenera la suite en modo standalone offline (HTML autocontenido)`), path-scoped, sin mezclar ámbitos (SETTINGS, snapshots del escáner, traspaso v25 y demás working tree quedaron sin tocar). Push fast-forward `514ebda..eff95ef` a `origin/main` tras visto bueno visual. `git status -sb`: al día con `origin/main` (A38 satisfecho).

## 5. Backlog acumulativo

Consolidado en `50_documentacion/activa/backlog_acumulativo.md`, en **89 entradas** (última: 89, portabilidad cross-OS, delta v24). **Esta sesión (s26) no agrega entradas:** la regeneración de la suite a standalone es mantenimiento de un artefacto existente, excluido por la nota metodológica (precedente v19/v23/v24). Se registra la sesión con **N=0** en la tabla por sesión, por completitud del registro de sesiones (paralelo a s20, s22, s25). Sin categorías nuevas, sin reclasificaciones. Las tres vistas siguen cuadrando en 89.

**Delta v26 (sin cambios; total se mantiene en 89).**

## 6. Bugs de la sesión

No hubo bugs de código. Un punto de método relevante, resuelto en el mismo turno:

- **Falso positivo de red por `xmlns`.** El grep de red devolvió 16 y 5 coincidencias `http://` en los dos HTML generales. Antes de declarar fallo, se clasificaron: todas eran `xmlns="http://www.w3.org/2000/svg"` (namespace XML inherente a cada `<svg>` inline), no descargas. Las referencias de red accionables son 0. **Patrón aprendido (ya conocido como A-xmlns):** al verificar offline, `xmlns="http://www.w3.org/2000/svg"` es identificador, no red; contarlo como fallo es un falso positivo. Candidato a incorporar como nota explícita al instrumento `prompt_activar_suite_standalone_v1.md` de `herramientas_dev/` (ver sección 11).
- **Deleciones de HTML enlazados no staged por glob sobre disco.** El glob `*.html` se expandió sobre disco, donde `inlinar_suite` ya había borrado los enlazados; solo se stagearon los `*_standalone.html`. Se stagearon explícitamente las deleciones de los 4 enlazados antes de commitear. **Patrón:** tras una operación que borra archivos en disco, un `git add <glob>` no captura las deleciones; hay que stagearlas explícitamente y verificar el staged set.

## 7. Aprendizajes y restricciones descubiertas

- **`xmlns` no es red (A-xmlns).** Ver sección 6. La verificación offline debe distinguir `xmlns="http://www.w3.org/2000/svg"` de una descarga real antes de declarar fallo.
- **Refuerzo de A20.** El escáner lista el filesystem, no el índice de Git. La confirmación de que el tema quedó fuera del índice se hizo con `git ls-files`, no con el escáner.
- **Errores del asistente de análisis registrados:** ver sección 15. Se registra incumplimiento de la regla de verbosidad (R6 / preferencia de brevedad): las respuestas de la sesión de análisis fueron más largas de lo debido y se repitieron preguntas ya respondidas por el titular.

## 8. Decisiones de diseño

- **No registrar entrada de backlog para la regeneración standalone.** La nota metodológica excluye el mantenimiento de la suite; registrarla inflaría el conteo contra el criterio ya aplicado tres veces (v19/v23/v24). Alternativa descartada: entrada 90 "activación standalone" — contradiría la nota metodológica.
- **Tema fuera del índice + `.gitignore` en vez de dejarlo versionado.** Con standalone los recursos viajan embebidos en los HTML; versionar `fonts/`/`assets/` sería duplicación. Se sacan del índice (conservados en disco) y se blindan en `.gitignore`.
- **Diferir el incidente PII a sesión dedicada.** No mezclar una purga de historial con el resto del trabajo (política §9.7: no mezclar migración con otros cambios). Ver sección 11.

## 9. Constantes y parámetros vigentes

Sin cambios respecto a v25. `standalone = TRUE` y `verificar = TRUE` vigentes en `documentar.R`. Regla de EOL (`* text=auto eol=lf`) en `.gitattributes`. Paleta de categorías fija (`CAT_COLORS`): Insuficiente `#EE2D49`, Medio-Bajo `#E88663`, Medio `#2A8FD9`, Alto `#0062A0`.

## 10. Arquitectura de archivos

Escáner al cierre: `50_documentacion/estructura/estructura_actual.md` (2026-07-01 08:05:17), 21 carpetas, 137 archivos.

**Delta observado no presenciado por esta sesión (a reconciliar en la próxima apertura, R9):** el escáner de hoy muestra cambios respecto al de s25 que no ocurrieron en esta sesión de chat: `backlog_consolidado.md` renombrado a `backlog_acumulativo.md`; aparición de `ESTADO.md` y `resena_slep_categoria_desempeno.md` en `activa/`; un andamio nuevo (`compass_artifact_...md`) en `andamios/`; crecimiento de `POLITICA_PROYECTO.md` (29.7K→33K) y `SETTINGS_Y_PROMPTS_OPERACIONALES.md` (31.9K→46.7K); snapshot pendiente de s25 ya versionado. Interpretación provisional: infraestructura de protocolo/documentación (incluida la adopción de Fase 2 vía `ESTADO.md`), no contabilizable como cambio de producto por la nota metodológica, y por eso ausente del backlog. **No verificado por esta sesión**; si alguno fue trabajo de producto sin registrar, reconciliarlo contra el backlog en la apertura de s27.

**Observación menor persistente (heredada):** `.DS_Store` en disco en varias carpetas de `50_documentacion/` (más un `.DS_Store` nuevo en `suite/`) y un `.Rhistory` vacío en `traspasos/`. Cero tracked vía `git ls-files` (A20); candidatos a limpieza de disco, sin impacto en Git.

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

1. **[PRIORIDAD 1 — GOBERNANZA] Incidente PII en historial público.** `20_insumos/auxiliares/directorio_oficial_ee.csv` (crudo, con `RUT_SOSTENEDOR` y `MRUN`) está commiteado en el historial de este repo público. Confirmado por dos lectores independientes durante el paso 2 de `slep_paes` (sesión 2026-06-30). El de-versionado previo (`git rm --cached`, traspaso v-anterior) sacó el crudo del HEAD pero **no lo purgó del historial**: sigue recuperable en commits pasados. Patrón a replicar: `slep_idps` ya lo resolvió (gitignora el crudo, versiona solo `directorio_oficial_ee_publico.csv` depurado vía `31_depurar_directorio_oficial.R`). Alcance: (a) auditoría de gobernanza §8.3 (archivo(s) y commits afectados); (b) generar/adaptar el depurador a `directorio_oficial_ee_publico.csv` siguiendo `slep_idps`; (c) `.gitignore` blindado contra el nombre del crudo; (d) purga de historial (`git filter-repo` o BFG) + `push --force` con gate de confirmación explícita antes de forzar; (e) registrar como decisión en `50_documentacion/activa/decisiones/` y evaluar procedimiento de incidente (POLITICA §6.4, `gobernanza_datos.md`). **Tipo:** CONTINUATION con foco único (no mezclar con otro trabajo; una purga de historial es la operación más destructiva del repo). **Complejidad:** media-alta.
2. **Administrativo de apertura s27:** versionar este traspaso v26 y el snapshot del escáner del cierre de s26. Tipo: administrativo. Complejidad: baja.
3. **Reconciliar el delta observado (sección 10)** contra el backlog: confirmar que el renombre del backlog, `ESTADO.md`, la reseña y el crecimiento de POLITICA/SETTINGS son infraestructura no contabilizable y no trabajo de producto sin registrar. Tipo: verificación documental. Complejidad: baja.
4. **Mejora al instrumento standalone** (`herramientas_dev/`, no de este proyecto): anexar a `prompt_activar_suite_standalone_v1.md` la nota A-xmlns (la verificación de red debe distinguir `xmlns` de descarga real). Tipo: BIBLIOTECA. Complejidad: baja.
5. **Andamio del log de Claude Code (opcional):** persistir el log de ejecución de esta sesión en `50_documentacion/andamios/logs/` si se desea la evidencia congelada. Complejidad: baja.
6. **Limpieza de `.DS_Store`/`.Rhistory` en disco (opcional, heredado).** Sin impacto en Git.
7. **Validación empírica cross-OS (opcional, heredado).**

### Evaluación de deuda técnica

Sin deuda técnica viva en el pipeline ni en el motor. La deuda abierta es de **gobernanza** (pendiente 1), no técnica, y es prioritaria por tratarse de PII de personas naturales en un repo público bajo Ley 21.719.

### Auditoría de cierre (política 5.6)

- #2 ¿pipeline corre de cero sin intervención manual? → Sí (sin cambios desde v21).
- #5 ¿cada transformación crítica con check de validación? → Sí (suite F1–F4 + spot-check, sin cambios).
- #6 ¿outputs reproducibles e idempotentes? → Sí.
- #7 ¿decisiones metodológicas como constantes nombradas? → Sí.
- #8 ¿nombres sin tildes/ñ/espacios? → Sí.
- Respuesta "no" derivada: ninguna en lo técnico. Se levanta el incidente de gobernanza (pendiente 1) como hallazgo prioritario fuera del checklist técnico.

### Ruta sugerida para la próxima sesión

Abrir **CONTINUATION con foco único en el incidente PII** (pendiente 1). Primer acto administrativo: versionar este traspaso v26 y el snapshot del escáner. Adjuntar `31_depurar_directorio_oficial.R` de `slep_idps` (patrón a replicar), `.gitignore` y `00_escanear_proyecto.R` de este repo, y `gobernanza_datos.md`. No mezclar la purga con ningún otro trabajo del proyecto.

## 12. Instrucciones específicas para la próxima sesión

- 🔒 Motor publicado sin Babel ni runtime de transpilación (C3). No reintroducir dependencias de red.
- 🔒 Suite en modo standalone (`standalone = TRUE` en `documentar.R`). Al regenerar, mantenerlo; verificar offline distinguiendo `xmlns` de red real.
- 🔒 `.gitattributes` con `* text=auto eol=lf` es la regla de EOL del repo.
- 🔒 Agregación = conteo de establecimientos; básica/media nunca se mezclan; `docs/index.html` no se edita a mano.
- ✅ ANTES de cerrar cualquier sesión, verificar `git status` (árbol limpio) y `git push` confirmado contra `origin` (A38).
- ✅ ANTES de editar la suite, leer `documentar.R` completo; nunca editar los HTML a mano.
- ✅ Edición de UI: editar `33_app.jsx`, retranspilar con `runtime: "classic"`, reemplazar el `<script>` del template; nunca editar el `createElement` a mano.
- ⚠️ Incidente PII (pendiente 1): la purga de historial exige gate de confirmación explícita antes de `push --force`. Foco único, no mezclar.
- ⚠️ El escáner lista el filesystem, no el índice (A20). Verificar con `git ls-files`.
- ⚠️ Reconciliar el delta observado de la sección 10 contra el backlog antes de asumir que el estado en disco está completo (R9).

## 13. Constantes de la paleta (referencia rápida)

| Categoría | Hex | Token |
|---|---|---|
| Insuficiente | `#EE2D49` | mark-red |
| Medio-Bajo | `#E88663` | coral |
| Medio | `#2A8FD9` | mark-blue |
| Alto | `#0062A0` | ocean |

Fuente única: `CAT_COLORS` en `33_generar_html.R`.

## 14. Fragmentos de código de referencia

```bash
# Verificar que el tema NO quedó en el índice (A20).
git -C /Users/tomgc/Projects/slep_categoria_desempeno ls-files 50_documentacion/suite/fonts 50_documentacion/suite/assets
# Vacío = tema fuera del índice, aunque el escáner lo liste en disco.
```

```bash
# Cierre de Git como condición de término (A38).
git -C /Users/tomgc/Projects/slep_categoria_desempeno status
git -C /Users/tomgc/Projects/slep_categoria_desempeno status -sb   # al día con origin/main
```

## 15. Errores del asistente en esta sesión

| # | Error | Regla violada | Corrección |
|---|---|---|---|
| 1 | Verbosidad excesiva: respuestas largas, con opciones y matices que excedieron lo necesario. | R6 (brevedad como requisito) / preferencia de brevedad. | Registrado a petición del titular; aplicar brevedad estricta en lo que resta y en próximas sesiones. |
| 2 | Preguntas repetidas ya respondidas por el titular en la misma conversación (regeneración de la suite, generación del traspaso). | Regla de no re-preguntar lo ya respondido; nota metodológica A10 (regenerar suite = actualización deliberada, proceder sin objetar). | Registrado; proceder sin re-confirmar cuando el titular ya autorizó. |

## 16. Reapertura

- **Nombre del chat:** `slep_categoria_desempeno, sesión 27 (Opus 4.8)`
- **Mensaje de apertura pre-armado:**

  > Tipo de sesión: CONTINUATION, foco único: incidente PII en historial público. El protocolo (POLITICA_PROYECTO.md + SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; léelo desde ahí. Retomamos slep_categoria_desempeno en sesión 27. La sesión 26 regeneró la suite en modo standalone offline (commit eff95ef, pusheado); no agregó entradas al backlog (mantenimiento de suite, no contabilizable), que se mantiene en 89. Foco de esta sesión: sanear la fuga de PII (directorio_oficial_ee.csv crudo con RUT_SOSTENEDOR/MRUN commiteado en el historial público). Replicar el patrón de slep_idps (depurador + versionar solo el CSV público + blindar .gitignore + purga de historial con git filter-repo/BFG + push --force con gate explícito). Administrativo de apertura: versionar el traspaso v26 y el snapshot del escáner del cierre de s26. No mezclar la purga con otro trabajo.
  >
  > Documentos:
  > 1. Knowledge base (no adjuntar): POLITICA_PROYECTO.md, SETTINGS_Y_PROMPTS_OPERACIONALES.md.
  > 2. Adjuntar: traspaso_cierre_v26.md; estructura_actual.md (correr el escáner al abrir); 31_depurar_directorio_oficial.R de slep_idps (patrón a replicar); .gitignore y gobernanza_datos.md de este repo.

- **Documentos para la próxima sesión:**
  1. *Protocolo en knowledge base* (NO se adjuntan; verificar que estén al día): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Específicos (SÍ se adjuntan):* `traspaso_cierre_v26.md`; `estructura_actual.md` (correr el escáner al abrir); `31_depurar_directorio_oficial.R` de `slep_idps`; `.gitignore` y `gobernanza_datos.md` de este repo.

- **Nota final:** si algún archivo listado cambió entre sesiones, adjuntar la versión más actualizada al abrir y avisarlo.
