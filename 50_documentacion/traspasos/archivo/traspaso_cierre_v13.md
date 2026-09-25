# Traspaso de cierre v13 — slep_categoria_desempeno

## 1. Identificacion
- **Proyecto:** slep_categoria_desempeno
- **Version:** v13
- **Fecha:** 2026-06-13
- **Sesion:** 13 — foco en cerrar D21 (rediseno de la cabecera territorial y el
  layout del motor) a partir de un archivo de referencia UI aprobado por el
  titular, mas tres pendientes de cierre: silenciar el warning de `readLines`,
  agregar un atajo de conveniencia al orquestador, y un check de particion
  territorial (6.5). D21 quedo RESUELTO. Despliegue a GitHub Pages confirmado.
- **Entorno:** R 4.5.2 en Positron, macOS aarch64. Modelo: Claude Opus 4.8.
- **Archivos principales modificados:**
  - `30_procesamiento/33_motor_template.html`: REGENERADO desde la referencia UI
    aprobada (ingenieria inversa restaurando los 3 placeholders del pipeline).
  - `30_procesamiento/33_generar_html.R`: `warn = FALSE` en las 3 lecturas de
    `readLines` (plantilla, d3, pako).
  - `30_procesamiento/32_agregar_territorial.R`: nuevo check 6.5 (particion
    territorial: suma comunal <= nacional por nivel x anio).
  - `00_run_all.R`: alias de conveniencia `regenerar_motor()` (= run_all(only=33));
    default de `run_all()` intacto.
  - `40_salidas/motor_categoria.html` + `docs/index.html` (regenerados).
  - `_archivo/20260613/handoff_claude_design/`: archivado el handoff de Claude
    Design (referencia UI + prompt de implementacion), renombrado a snake_case.

## 2. Resumen ejecutivo
La sesion 13 abrio sobre el v12 con D21 pendiente (rediseno de la cabecera
territorial bloqueado en v12 por iteracion visual no convergente, A18). El titular
aporto la palanca que faltaba: un archivo de referencia UI ya aprobado (con DATA
inyectado) mas un prompt de implementacion con 10 reglas de armonia. Se eligio la
Opcion A (la referencia ES el resultado bueno) y se reconstruyo el template por
ingenieria inversa, restaurando los 3 placeholders del pipeline (`__D3_INLINE__`,
`__PAKO_INLINE__`, `__JSON_DATA__`) sin tocar el cuerpo aprobado. El diff contra el
template del repo fue limpio y acotado a las hunks de cabecera, narrativa, grilla,
separacion de filtros, fichas de EE y leyenda, mas la correccion de copy "Agencia
de Calidad" -> "Sistema de Aseguramiento de la Calidad de la Educacion". Build en
verde, confirmacion visual del titular ("se ve bien, finalmente"): D21 RESUELTO sin
iteracion por captura (A18 satisfecho via referencia aprobada). Ademas: se silencio
de raiz el warning de `readLines` (afectaba a cualquier insumo sin newline final);
se agrego `regenerar_motor()` como atajo sin romper la reproducibilidad de
`run_all()`; se agrego el check 6.5 al paso 32; y se verificaron las 6 invariantes
de agregacion + consistencia de grado, todas en verde. Todo desplegado a Pages en
tres commits limpios.

## 3. Estado al cierre

### Que funciona (ultima ejecucion exitosa)
- `run_all()` corre los 4 pasos OK. Ultima corrida limpia del paso 33: 2026-06-13
  20:09 (plantilla 129.042 chars, JSON 26.9 MB / 2.35 MB comprimido, HTML 2739 KB).
  Ultima corrida limpia del paso 32 con el check 6.5: 2026-06-13 22:28.
- **D21 RESUELTO Y VERIFICADO:** el motor levanta con el layout de la referencia
  aprobada (cabecera alineada, narrativa con interlineado homogeneo y badges en
  baseline, grilla de "sin vigente" en 3/2/1 columnas, filtros con >=44px de
  separacion, fichas de EE apiladas con separador punteado, leyenda a la derecha,
  copy institucional corregido). Confirmacion visual del titular: OK.
- **Warning de `readLines` ELIMINADO:** las 3 lecturas usan `warn = FALSE`; el build
  ya no emite "incomplete final line". Corrige el caso general, no solo el template.
- **Atajo `regenerar_motor()` OPERATIVO:** equivale a `run_all(only = 33)`;
  `run_all()` sin argumentos sigue corriendo el pipeline completo (reproducibilidad
  intacta, politica del orquestador respetada).
- **Invariantes del paso 32 INTACTOS Y VERIFICADOS (6 + grado):** toda celda con 4
  categorias; pct suma 1; n_ee <= n_categorizados; nacional dif = 0; NUEVO check 6.5
  suma comunal <= nacional (particion valida); basica/media no se mezclan; llaves
  character. Sanity de Costa Central basica sin cambios (55 EE 2016-2018, 56 en 2019,
  distribucion identica al historico). La consistencia de grado (suma grados ==
  matricula por cod_ense2) sigue en verde desde el paso 33.
- **Despliegue a GitHub Pages CONFIRMADO:** tres commits en `main`
  (`e0112be` rediseno + warning + alias; `4a30f36` snapshot escaner;
  `0749e8f` check 6.5; `5989025` snapshot escaner final). `docs/index.html`
  republicado.

### Que no funciona / pendiente
- No hay nada roto. Quedan deudas tecnicas menores diferidas (ver seccion 11):
  el template monolitico (~126 KB, sin tokenizar) sigue siendo la deuda mayor.

### Delta respecto a v12
v12 dejo D21 incompleto (layout no convergente, estado CSS no confiable). v13 lo
RESUELVE usando la referencia UI aprobada como fuente de verdad (ingenieria inversa
restaurando placeholders), no parchando el estado inestable heredado. Ademas cierra
tres pendientes de calidad (warning de readLines, atajo del orquestador, check 6.5)
y archiva el handoff de Claude Design. Sin cambios estructurales de carpetas. Sin
cambios de CALCULO en ningun paso.

## 4. Registro detallado de cambios

### Cambio 63 — D21 resuelto: template regenerado desde la referencia UI aprobada
- **Categoria:** Diseno UI — Motor.
- **Que (`33_motor_template.html`, REGENERADO):** se tomo el archivo de referencia
  UI aprobado por el titular (con DATA ya inyectado, 2.8 MB) y se reconstruyo el
  template del pipeline por ingenieria inversa, restaurando via regex los 3 bloques
  de inyeccion a sus placeholders: el `<script>` de d3 -> `__D3_INLINE__`, el de
  pako -> `__PAKO_INLINE__`, y el payload base64 dentro de `atob("...")` ->
  `__JSON_DATA__`. El cuerpo (CSS + JSX) quedo identico a la referencia. Cambios de
  layout respecto al template v12: padding/alineacion de `.app-header`,
  `.brand-eyebrow-row` nuevo, `.terr-narrativa` a ancho de grilla con line-height
  2.0 y badges en baseline 1.45, `.sin-vigente-ul` en grilla 3/2/1 col,
  `.terr-narrativa + .chip-filter { margin-top: 44px }`, `.ee-row` apilada con
  separador punteado, leyenda a la derecha. Copy: "Agencia de Calidad" -> "Sistema
  de Aseguramiento de la Calidad de la Educacion".
- **Por que (C.11):** D21 estaba bloqueado en v12 por iteracion visual sin criterio
  observable (A18). La referencia aprobada ES el criterio observable: no se itera,
  se reproduce.
- **Como se verifico (B.4):** cada placeholder aparece exactamente 1 vez; ninguna
  linea > 4000 chars (sin blob residual); diff vs template-repo (con data stripped)
  solo las hunks intencionadas; build en verde (plantilla 129.042 chars);
  confirmacion visual del titular OK. El template subido por el titular resulto
  identico en contenido al generado (0 lineas difieren).
- **Aprendizaje (A19, NUEVO):** cuando el ajuste visual no converge por iteracion,
  la salida es pedir al titular un artefacto de referencia aprobado y hacer
  ingenieria inversa, no seguir parchando. La referencia colapsa el espacio de
  iteracion a cero (ver seccion 7).

### Cambio 64 — Warning de `readLines` silenciado de raiz
- **Categoria:** Calidad de codigo / pipeline.
- **Que (`33_generar_html.R`, L491-493):** las 3 lecturas
  `readLines(plantilla_path/d3_path/pako_path, encoding = "UTF-8")` pasan a
  `readLines(..., encoding = "UTF-8", warn = FALSE)`.
- **Por que (C.11):** el warning "incomplete final line" se dispara cuando un insumo
  no termina en newline (el template de referencia no lo tenia). `warn = FALSE`
  corrige el CASO GENERAL (cualquier insumo sin newline final), no solo el template
  de hoy; evita depender de reformatear archivos a mano en cada build.
- **Como se verifico (B.4):** diff de 3 lineas (solo el argumento agregado); build
  del paso 33 sin el `Warning message`.
- **Alternativa descartada:** reescribir el template con newline final
  (`writeLines`). Resolveria el sintoma de hoy pero no el caso general; ademas
  obligaria a una tarea manual recurrente.

### Cambio 65 — Alias de conveniencia `regenerar_motor()` en el orquestador
- **Categoria:** Orquestador / DX.
- **Que (`00_run_all.R`):** nueva funcion `regenerar_motor()` que llama a
  `run_all(only = 33L)`, insertada tras el cierre de `run_all()` con su roxygen y un
  ejemplo de uso comentado. El default de `run_all(from=NULL, to=NULL, only=NULL,
  skip=NULL)` NO se toco.
- **Por que (C.11):** el titular pidio un atajo para regenerar solo el HTML. Cambiar
  el DEFAULT a `only = 33` habria violado la politica del orquestador (run_all() sin
  argumentos debe correr el pipeline completo, reproducible; auditoria 5.6 #2) y
  habria sorprendido a quien clone el repo. El alias da el atajo sin romper la
  invariante.
- **Como se verifico (B.4):** diff solo adiciones (13 lineas de funcion + 1 de
  ejemplo); `run_all <- function(...)` con su firma original intacta.
- **Tension resuelta:** conveniencia (DX) vs reproducibilidad (politica). Se
  resolvio a favor de la politica, dando la conveniencia por una via paralela.

### Cambio 66 — Check 6.5 de particion territorial en el paso 32
- **Categoria:** Validacion / integridad.
- **Que (`32_agregar_territorial.R`, tras el 6.4):** nuevo check que toma
  `n_categorizados` distinto por celda comunal, lo suma por nivel x anio, y lo
  compara contra el total nacional (`control_nac` del 6.4). Alerta SOLO si la suma
  comunal EXCEDE el nacional (`exceso > 0`); la suma menor es valida (las comunas
  son particion parcial: los EE sin match comunal solo cuentan en nacional).
- **Por que (C.11):** el 6.4 validaba nacional contra `df_cat`, pero no existia un
  cruce que verificara que ninguna particion sub-nacional excediera el universo
  (invariante implicita sin test). El 6.5 la hace explicita.
- **Como se verifico (B.4):** diff solo adiciones (19 lineas); corrida del paso 32
  imprime "OK: suma comunal <= nacional por nivel x anio (particion valida)"; sanity
  de Costa Central sin cambios (el check no toca el calculo).
- **Decision de diseno:** condicion de alerta `> 0` (no `!= 0`) porque la particion
  parcial admite suma menor; reuso de `df_comuna` y `control_nac` ya en memoria (no
  recalcula). `distinct` antes de `sum` para no multiplicar por las 4 categorias.

## 5. Backlog acumulativo
[Copiar integro el backlog del v12 (1-62) y agregar 63-66. Total cronologico
62->66. El objetivo del proyecto y la nota metodologica no cambian.
- Cambios nuevos: 63 (D21 resuelto, "Diseno UI — Motor"), 64 (warning readLines,
  "Calidad de codigo / pipeline"), 65 (alias regenerar_motor, "Orquestador / DX"),
  66 (check 6.5, "Validacion / integridad").
- Reclasificaciones/cierres: P-narrativa/D21 -> CUMPLIDO (cerrar). DT de warning de
  readLines -> CUMPLIDO. DT del check sub-nacional vs nacional -> CUMPLIDO (era el
  6.5 propuesto en v13).
- Delta del backlog: 4 entradas nuevas (63-66); 0 refinamientos de taxonomia; el
  pendiente de modularizacion del template SIGUE abierto (deuda diferida).
Nota: la convencion de referencia del backlog (no reproducir 1-58 in extenso) se
hereda del v12 por falta del detalle historico completo en esta sesion; cuando se
disponga del backlog integro 1-62, consolidarlo aqui en extenso (DT documental).]

## 6. Bugs de la sesion
No hubo bugs de codigo del pipeline (todas las corridas en verde). Tampoco fallas de
proceso: a diferencia del v12, el ajuste visual (D21) convergio de inmediato al usar
la referencia aprobada como fuente, validando A18/A19. Una imprecision del asistente
(corregida en la misma sesion, no cuenta como bug del pipeline): asumio que los
`.DS_Store`/`.Rhistory` vistos en el escaner estaban versionados en Git; `git
ls-files` confirmo que NO lo estaban (el `.gitignore` ya los bloquea). El escaner
lista el filesystem completo, no solo lo trackeado: no confundir ambos.

## 7. Aprendizajes y restricciones descubiertas

### A19 (NUEVO) — Ante iteracion visual no convergente, pedir referencia aprobada y hacer ingenieria inversa
- **Regla:** cuando un ajuste de layout no converge por iteracion (el caso A18 del
  v12), la salida correcta NO es seguir parchando ni pedir "otro intento", sino
  pedir al titular un ARTEFACTO DE REFERENCIA aprobado (un HTML/mockup que el titular
  declara "asi quiero que se vea") y reconstruir el archivo del pipeline por
  ingenieria inversa sobre esa referencia. La referencia colapsa el espacio de
  iteracion a cero: ya no se decide nada visual, solo se restauran los puntos de
  inyeccion de datos. En esta sesion, D21 (bloqueado ~8 turnos en v12) se cerro en
  una pasada.
- **Principio:** B.4 (criterio de exito antes de actuar) + B.1 (no operar sobre
  supuestos visuales). A19 es el corolario operativo de A18: A18 dice "no iteres sin
  criterio observable"; A19 dice "y si no logras el criterio en abstracto, pide la
  referencia concreta".
- **Tecnica concreta:** para restaurar placeholders en un HTML autocontenido con
  data inyectada: regex sobre el `<script>` de cada libreria (d3, pako) y sobre el
  `atob("...")` del payload, sustituyendo por el placeholder; verificar que cada uno
  aparezca exactamente 1 vez y que no quede ninguna linea > 4000 chars (blob
  residual).

### A20 (NUEVO) — El escaner lista el filesystem, no el indice de Git
- **Regla:** ver un archivo en `estructura_actual.md` NO implica que este versionado.
  Antes de afirmar que algo es "basura versionada" o proponer `git rm --cached`,
  verificar con `git ls-files | grep <patron>`. El `.gitignore` puede ya estar
  bloqueandolo correctamente (archivos presentes en disco pero fuera del indice).
- **Principio:** B.1 (verificar contra la fuente real antes de actuar). Refuerza A16.

### A18 (heredado, CONFIRMADO Y CERRADO en su caso D21)
- El aprendizaje del v12 (no iterar layout sin criterio observable) se cumplio: esta
  sesion NO itero, uso la referencia. A18 sigue vigente como regla dura; A19 es su
  complemento operativo.

## 8. Decisiones de diseno

### D21 (RESUELTA) — Cabecera narrativa y layout de la vista territorio
- **Decision:** adoptar el archivo de referencia UI aprobado por el titular como
  resultado final, reconstruyendo el template por ingenieria inversa (Opcion A). El
  contenido de `narrativaTerritorial` (ya correcto desde v12) se conserva; el CSS de
  layout (inestable en v12) se reemplaza integro por el de la referencia.
- **Alternativa descartada (Opcion B):** revertir el layout del cambio 62 a un estado
  base y reconstruir contra un criterio observable redactado en texto. Mas costosa y
  con riesgo de re-divergir; la referencia aprobada ya encapsula el criterio.
- **Justificacion:** la referencia es el criterio observable hecho artefacto (A19).
  Cierra D21 sin iteracion por captura.

### D22 (NUEVA) — Atajo del orquestador via alias, no via cambio de default
- **Decision:** exponer la conveniencia de "regenerar solo el HTML" como funcion
  separada `regenerar_motor()`, dejando `run_all()` con su comportamiento canonico
  (pipeline completo por defecto).
- **Alternativa descartada:** cambiar el default de `run_all()` a `only = 33`.
  Violaria la politica del orquestador (reproducibilidad, 5.6 #2) y sorprenderia a
  quien clone el repo.
- **Justificacion:** se obtiene la DX sin sacrificar la invariante de
  reproducibilidad.

### D21 del v12 — cerrada. D19 y D20 (v12) — vigentes sin cambios.

## 9. Constantes y parametros vigentes
[Tabla del v12 sin cambios de CALCULO. Notas:
- `33_motor_template.html`: 129.042 chars (regenerado desde referencia; el escaner
  lo reporta como 126 KB). Layout AHORA ESTABLE (referencia aprobada), ya NO marcar
  como inestable (deroga la nota del v12 sobre max-width/margin no definitivos).
- `meta.anio_vigente` = 2019 (categoria, dinamico). `meta.anio_matricula_vigente` =
  2025 (dinamico). Sin cambios.
- Filtro de grado en motor: cod_ense2 IN (2,5,7). Sin cambios.
- `CAT_REALES` = c("ALTO","MEDIO","MEDIO-BAJO","INSUFICIENTE"). Sin cambios.
- Copy institucional: "Sistema de Aseguramiento de la Calidad de la Educacion"
  (antes "Agencia de Calidad" en algunos rotulos del template).]

## 10. Arquitectura de archivos
Referencia al escaner del cierre: `00_escanear_proyecto.R` corrido 2026-06-13
22:24/22:29 (16 carpetas, 91 archivos; poda de retencion = 2 aplicada). Sin cambios
estructurales de carpetas. Nuevo en `_archivo/` (fuera de Git):
`_archivo/20260613/handoff_claude_design/{motor_referencia_ui.html,
prompt_implementacion_ui.md}` (renombrados a snake_case sin tildes). Modificados y
versionados: `33_motor_template.html`, `33_generar_html.R`,
`32_agregar_territorial.R`, `00_run_all.R`, `docs/index.html`. `motor_categoria.html`
regenerado pero ignorado por `.gitignore` (output regenerable).

## 11. Pendientes y ruta sugerida

### Inventario de pendientes
- **DT-template (deuda tecnica, diferida) — modularizar `33_motor_template.html`.**
  Tipo: deuda tecnica. El template monolitico (~126 KB, CSS sin tokenizar, 3000+
  lineas) sigue siendo la deuda mayor. Contexto: esta sesion no lo agravo (el layout
  ahora es estable), pero cualquier trabajo grande de UI futuro deberia evaluar
  componentizar el CSS antes. Complejidad: alta. Dependencias: ninguna bloqueante.
  Criterio de exito sugerido: CSS por secciones tokenizado, build identico
  byte-a-byte tras la modularizacion (invariante de salida). Precaucion: es un
  refactor de riesgo; hacerlo en sesion dedicada, con snapshot previo y verificacion
  visual completa.
- **DT-backlog-documental (NUEVO, menor) — consolidar el backlog 1-62 in extenso.**
  Tipo: documentacion. El backlog se viene arrastrando por referencia ("copiar
  integro 1-58/1-62") sin reproducir el detalle historico. Cuando se disponga de los
  traspasos v01-v12 juntos, consolidar el detalle cronologico completo en un traspaso.
  Complejidad: baja, mecanica. Criterio de exito: backlog con las 66 entradas
  reproducidas, no referenciadas.

### Evaluacion de deuda tecnica
- Deuda mayor y creciente: el template monolitico. Estable hoy, pero fragil ante
  cambios grandes de UI por falta de tokenizacion del CSS.
- Resuelto en v13: el warning de readLines (caso general), el check de particion
  (6.5), el atajo del orquestador. Sin friccion de hardcode (anios dinamicos).

### Auditoria de cierre (politica 5.6)
- #2 pipeline corre de cero: Si (4 pasos OK). #5 validaciones criticas: Si (6
  invariantes del paso 32 + check 6.5 NUEVO + consistencia de grado). #6
  reproducible/idempotente: Si (parquets identicos; build determinista). #7
  constantes nombradas: Si (`CAT_REALES`, anios dinamicos). #8 nombres sin tildes:
  Si (handoff renombrado a snake_case). Resto sin cambios.
- No quedan "no" sin convertir en pendiente.

### Ruta sugerida para la sesion 14
1. Si el titular trae trabajo de UI grande: evaluar PRIMERO modularizar el template
   (DT-template) como prerequisito de estabilidad, con snapshot previo y criterio de
   build identico.
2. Si no: atacar lo que el titular priorice; el motor esta estable y desplegado.
3. Oportunista y barato: consolidar el backlog in extenso (DT-backlog-documental) si
   se tienen los traspasos historicos a mano.
**Diferir:** modularizacion del template salvo que un trabajo de UID la exija.

## 12. Instrucciones especificas para la proxima sesion
- 🔒 Agregacion de categoria = conteo de EE. La matricula (ense2 y grado) es
  contexto, nunca pondera agregaciones.
- 🔒 Basica y media nunca se mezclan. El grado vive DENTRO de su cod_ense2.
- 🔒 La categoria mantiene cobertura 2016-2019 (anio_vigente=2019); la matricula es
  2016-2025 y su vigente de tamano es 2025 (anio_matricula_vigente). NO mezclar.
- 🔒 El parquet de grado se filtra a cod_ense2 IN (2,5,7) en el motor.
- 🔒 `docs/index.html` versionado para Pages; `40_salidas/motor_categoria.html`
  regenerable, ignorado. No editar `docs/` a mano.
- 🔒 El motor conserva los 3 placeholders del pipeline (`__D3_INLINE__`,
  `__PAKO_INLINE__`, `__JSON_DATA__`) en el template; NUNCA dejarlos inyectados al
  guardar el template (eso lo hace el paso 33 al generar el HTML final).
- 🔒 `run_all()` sin argumentos corre el pipeline completo (reproducibilidad). El
  atajo es `regenerar_motor()` (= only = 33). NO cambiar el default de run_all().
- ⚠️ NO re-leer los CSV nacionales en este proyecto. El insumo de grado se genera en
  `slep_analisis_matricula` (OneDrive) con `04_generar_matricula_rbd_grado.R`.
- ⚠️ NO confundir el escaner (filesystem) con el indice de Git. Verificar con
  `git ls-files` antes de afirmar que algo esta versionado (A20).
- ✅ ANTES de modificar el template: leer el archivo completo; el layout actual es la
  referencia APROBADA, no parchear sin criterio (A18/A19).
- ✅ ANTES de regenerar el motor: confirmar que `20_insumos/` tiene
  `matricula_rbd_ense.parquet` (211.391 filas) y `matricula_rbd_grado.parquet`.
- ✅ Para regenerar solo el HTML: `regenerar_motor()`.

## 13. Fragmentos de codigo de referencia
[Conservar los del v12 (convivencia de anio, consistencia grado->ense2). Anadir:]
```r
# Check 6.5 — particion territorial: la suma de EE categorizados de las comunas
# por nivel x anio no puede exceder el total nacional. Particion PARCIAL: la suma
# puede ser menor (EE sin match comunal van solo a nacional), nunca mayor.
# n_categorizados es constante por celda comunal -> distinct antes de sumar.
suma_comunal <- df_comuna |>
  dplyr::distinct(cod_entidad, nivel, anio, n_categorizados) |>
  dplyr::summarise(n_sub = sum(n_categorizados), .by = c(nivel, anio))
part_check <- suma_comunal |>
  dplyr::left_join(control_nac, by = c("nivel", "anio")) |>
  dplyr::mutate(exceso = .data$n_sub - .data$n_control)
if (any(part_check$exceso > 0)) {
  warning("Suma comunal de EE excede el total nacional (particion imposible).")
  print(dplyr::filter(part_check, .data$exceso > 0))
} else {
  message("    OK: suma comunal <= nacional por nivel x anio (particion valida).")
}
```
```r
# Atajo de conveniencia del orquestador. NO reemplaza a run_all(): el pipeline
# reproducible de cero sigue siendo run_all() sin argumentos.
regenerar_motor <- function() {
  run_all(only = 33L)
}
```
```r
# Lectura de insumos del template sin warning de "incomplete final line".
# warn = FALSE cubre el caso general (cualquier insumo sin newline final).
plantilla <- paste(readLines(plantilla_path, encoding = "UTF-8", warn = FALSE), collapse = "\n")
```

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 14 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; leelo desde ahi.
> Retomamos slep_categoria_desempeno en sesion 14. La sesion 13 dejo RESUELTO D21
> (rediseno de la cabecera territorial y el layout, adoptando la referencia UI
> aprobada por ingenieria inversa), mas tres cierres: warning de readLines
> silenciado, atajo `regenerar_motor()` en el orquestador, y check 6.5 de particion
> territorial en el paso 32. Todo verificado y desplegado a GitHub Pages. El motor
> esta estable. Queda como deuda diferida la modularizacion del template monolitico.
> Adjunto el traspaso v13 y el escaner.

### Documentos para la proxima sesion
1. Protocolo en knowledge base (no se adjuntan): POLITICA_PROYECTO.md v6,
   SETTINGS_Y_PROMPTS_OPERACIONALES.md v1.
2. Opcionales segun foco: `33_motor_template.html` (si se modulariza el CSS o se
   toca UI); `33_generar_html.R` (si se toca el JSON o las validaciones);
   `32_agregar_territorial.R` (si se toca la agregacion); `00_run_all.R` (si se toca
   el orquestador).
3. Especificos (SI se adjuntan): `traspaso_cierre_v13.md`; `estructura_actual.md`.

### Nota final obligatoria
El motor (`33_motor_template.html`) esta en su estado APROBADO (referencia UI). Si
se adjunta para trabajo de UI, partir de esa version y conservar los 3 placeholders.
Si algun archivo listado cambio entre sesiones, adjuntar la version mas actualizada
al abrir y avisarlo en el mensaje de apertura.
