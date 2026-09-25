# Traspaso de cierre — slep_categoria_desempeno v28

## 1. Identificación

- **Proyecto:** slep_categoria_desempeno
- **Versión:** v28
- **Fecha:** 2026-07-02
- **Sesión:** 28, CONTINUATION. Foco: cierre de pendientes administrativos
  heredados de v27 (untracked sin versionar, backlog atrasado, verificación
  del pendiente 4b/depe4).
- **Entorno:** chat conversacional (análisis) + Claude Code (ejecución).
- **Archivos principales modificados:** versionado de 6 archivos untracked
  (encargos PII, reseña, andamio, traspasos v25-v26), `backlog_acumulativo.md`
  (89→90), `ESTADO.md` (nuevo, con corrección de pendiente cruzado).

## 2. Resumen ejecutivo

Sesión administrativa pura, sin trabajo de producto (motor, cifras, UI).
Se cerraron tres de los cuatro pendientes heredados de v27. Primero se
versionó el conjunto de archivos untracked identificado en v27 §8 ítem 4
(dos encargos PII, reseña del proyecto, andamio compass_artifact, traspasos
v25 y v26), en cuatro commits temáticos separados. Segundo, se adjuntó
`backlog_acumulativo.md` (pendiente #1 de v27) y se agregó la entrada 90
correspondiente al incidente PII de v27, creando la categoría temática
nueva "Gobernanza de datos" en lugar de absorberla en "Migración y
publicación / DevOps" (que ya tenía el precedente técnico de
`git-filter-repo` vía `slep_idps`, pero con intención primaria distinta).
Tercero, se investigó el pendiente heredado "4b/depe4" (v27 §8 ítem 3) vía
`conversation_search` y se determinó que corresponde a `slep_simce_adecuado`,
no a este proyecto: entró al traspaso v27 por copia cruzada entre proyectos
hermanos y ya fue resuelto en la sesión 20 de ese proyecto. Se generó
`ESTADO.md` por primera vez para este proyecto, documentando la corrección.
Queda un único pendiente, de acción manual del titular fuera de esta sesión
(re-clonar cualquier clon previo tras la reescritura de historial de v27).
Un error del asistente propio (offrecer cierre de sesión sin que el usuario
lo solicitara, violando R5) fue señalado por el usuario y corregido en el
momento.

## 3. Estado al cierre

**Funciona:** repo sincronizado con `origin/main` en `4884f01`, árbol
limpio. Backlog cuadra en las tres vistas (cronológico 90, tabla temática
suma 90, delta v27 documentado). `ESTADO.md` generado por primera vez.

**No funciona / pendiente:** ninguna falla funcional. Pendiente #2 de v27
(re-clonar clones previos) sigue abierto, es acción manual del titular.

**Delta respecto a v27:** cuatro pendientes de v27 §8 resueltos (untracked
versionado, backlog al día, 4b/depe4 invalidado como pendiente de este
proyecto); uno persiste sin cambio (re-clonar, fuera del alcance del
asistente).

## 4. Registro detallado de cambios

### 4.1 Versionado de untracked heredado (v27 §8 ítem 4)

- **Qué:** cuatro commits temáticos separados: encargos PII (auditoría +
  saneamiento), reseña del proyecto, andamio `compass_artifact_*`,
  traspasos v25-v26. Push con `--set-upstream origin main` (la rama local
  no tenía tracking configurado tras la reescritura de historial de v27).
- **Por qué:** cerrar la deuda de versionado declarada en v27 sin mezclar
  categorías de contenido en un solo commit (C.3).
- **Cómo se verificó:** cada commit confirmado por output real de
  `git commit` y `git push`; `git branch -vv` + `git remote -v` usados
  para diagnosticar la falta de upstream antes de fijarla, en vez de
  asumir la causa.
- **Incidente durante la ejecución:** el usuario pegó un `git add` con
  rutas relativas en vez del comando completo con `cd` + rutas absolutas
  que se le entregó, generando `zsh: no such file or directory`. Se
  diagnosticó por comparación de las rutas del error (relativas) contra
  las rutas dadas (absolutas), no por suposición.

### 4.2 Backlog acumulativo: cierre de pendiente #1 (89 → 90)

- **Qué:** entrada 90 (incidente PII, ver traspaso v27 §4) agregada al
  detalle cronológico, tabla temática y nota de conteo. Categoría nueva
  "Gobernanza de datos" (N=1).
- **Por qué:** v26 no generó entrada (mantenimiento de suite, precedente
  v19/v23/v24, confirmado vía `conversation_search`); v27 sí, por ser
  trabajo de gobernanza/cumplimiento distinguible del titular.
- **Cómo se verificó:** conteo de entradas cronológicas (`grep -c`) contra
  suma de la tabla temática por script; ambos cuadran en 90.
- **Decisión de taxonomía:** categoría nueva en vez de absorber en
  "Migración y publicación / DevOps" pese a compartir herramienta
  (`git-filter-repo`) con el precedente de `slep_idps` (c.89 de ese
  proyecto): la intención primaria del c.90 es cumplimiento y exposición
  de datos personales, no infraestructura de repositorio. Categoría nace
  bajo el umbral de absorción (2%), se mantiene explícitamente por ser
  primer caso real y distinguible, sujeta a revisión si no crece.

### 4.3 Investigación y cierre del pendiente 4b/depe4 (v27 §8 ítem 3)

- **Qué:** búsqueda en histórico de conversaciones (`conversation_search`)
  confirmó que la observación de gobernanza "4b/depe4 = 1 EE" (celda
  comunal×GSE filtrada a un tipo de dependencia con un único
  establecimiento, riesgo de identificación no anónima) pertenece a
  `slep_simce_adecuado`, no a `slep_categoria_desempeno`. Fue resuelta en
  la sesión 20 de ese proyecto (`20260620_decision_celda_unico_establecimiento.md`),
  incluyendo la revisión de los dos (en realidad tres) marcadores
  `# REVISAR` y la migración del backlog histórico de ese proyecto.
- **Por qué:** el traspaso v27 de este proyecto listaba el ítem como
  heredado sin verificar su origen; la búsqueda reveló que entró por
  copia cruzada entre traspasos de proyectos hermanos (ambos con
  `documentar.R` y estructura de backlog similares).
- **Cómo se verificó:** dos búsquedas independientes en
  `conversation_search` ("4b depe4 gobernanza cierre" y "slep_simce_adecuado
  sesion 19 cierre gobernanza 4b depe4 decision") devolvieron los traspasos
  reales de `slep_simce_adecuado` v18-v20 con el ítem completo, incluyendo
  el archivo de decisión generado y su cierre.
- **Resolución:** `ESTADO.md` generado con nota de corrección explícita
  para que v29+ no vuelva a heredar el pendiente por error.

### 4.4 Generación de ESTADO.md (primera vez para este proyecto)

- **Qué:** primer `ESTADO.md` de `slep_categoria_desempeno`, con front
  matter (`semaforo: activo`, `tipo_pendiente: deuda_heredada`) y nota de
  corrección del pendiente cruzado.
- **Por qué:** el proyecto no había adoptado el estándar Fase 2 aún (v27
  no lo generó). Se adopta ahora, destilando el estado real post-v27+v28.
- **Cómo se verificó:** generado después del traspaso (regla de
  generación, SETTINGS §2.1bis), no antes.

## 5. Backlog acumulativo

Ver `50_documentacion/activa/backlog_acumulativo.md`, actualizado a 90
entradas en esta sesión (§4.2). Entrada 90 ya incorporada; no hay delta
adicional que registrar aquí más allá de lo documentado en el archivo
mismo.

## 6. Bugs de la sesión

Ninguno de código. Sin cambios de pipeline ni de motor en esta sesión.

## 7. Aprendizajes y restricciones (nuevas, esta sesión)

- **Pendientes heredados entre proyectos hermanos deben verificarse contra
  su origen real antes de re-listarlos, no solo copiarse del traspaso
  anterior.** Este proyecto y `slep_simce_adecuado` comparten estructura
  de protocolo y nombres de archivo (`documentar.R`, `# REVISAR`), lo que
  facilita confusión de contexto al redactar traspasos. Aplicar
  `conversation_search` como verificación estándar cuando un pendiente
  parece no encajar con el dominio del proyecto actual (en este caso, la
  observación 4b/depe4 es sobre SIMCE Adecuado, no sobre Categoría de
  Desempeño).
- **`git branch -vv` sin rama trackeada tras una reescritura de historial
  con `git-filter-repo` es esperable, no un error nuevo:** la herramienta
  reagrega el remoto pero no restaura el tracking de la rama local.
  Verificar con `git branch -vv` + `git remote -v` antes de fijar upstream
  a ciegas.

## 8. Pendientes (mapa de la próxima ruta)

| # | Descripción | Prioridad | Bloqueante | Acción requerida |
|---|---|---|---|---|
| 1 | Re-clonar cualquier clon previo del repo (historial reescrito en v27 invalida hashes anteriores) | media | no | usuario, acción manual, una vez |

Sin más pendientes activos de este proyecto. Los tres restantes de v27
(backlog, untracked, 4b/depe4) quedan resueltos o invalidados en esta
sesión.

## 9. Errores del asistente (registro obligatorio)

| momento | disparador | que_paso | regla_violada | causa_raiz | salvaguarda_presente | patron |
|---|---|---|---|---|---|---|
| Tras cierre de pendiente #1 (backlog) | usuario corrigió ("error, warning tuyo") | el asistente ofreció cerrar la sesión sin que el usuario lo solicitara | POLITICA §0.5 / R5 (cierre de sesión decidido solo por el usuario, el asistente nunca lo sugiere salvo detección de higiene de sesión explícita en userPreferences) | el asistente interpretó la finalización de una subtarea (pendiente #4) como oportunidad de cierre general, sin que hubiera señal de degradación de contexto que justificara invocar la regla de higiene de sesión | userPreferences (Session hygiene) + memoria de usuario (R5 canónico) | nuevo |

## 10. Registro de ejecución detallado

No aplica en esta sesión: sin encargo autónomo a Claude Code, todos los
comandos fueron órdenes directas de una sola línea ejecutadas por el
usuario en terminal manual.

## 11. Reapertura

**Nombre del chat:** `slep_categoria_desempeno, sesión 29 (Claude Sonnet 5)`

**Mensaje de apertura pre-armado:**

> Sesión 29, CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del
> proyecto. Adjunto el traspaso v28 y el escáner actualizado. El proyecto
> no tiene pendientes forzosos propios; el único pendiente abierto (#1,
> re-clonar clones previos) es acción manual del titular. Evaluar si hay
> trabajo concreto que justifique sesión aquí o pivotar a un proyecto
> hermano.

**Documentos para la próxima sesión:**

1. *Protocolo en knowledge base* (verificar que esté al día, no
   adjuntar): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
2. *Opcionales según foco real:* `CLAUDE.md` si corre en Claude Code.
3. *Específicos de la sesión (SÍ adjuntar):*
   - `traspaso_cierre_v28.md` (este documento)
   - `estructura_actual.md` (re-correr el escáner si pasaron más de unas
     horas)

**Nota final obligatoria:** si algún archivo listado cambió entre
sesiones, adjuntar la versión más actualizada al abrir.
