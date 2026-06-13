# Traspaso de cierre v12 — slep_categoria_desempeno

## 1. Identificacion
- **Proyecto:** slep_categoria_desempeno
- **Version:** v12
- **Fecha:** 2026-06-13
- **Sesion:** 12 — foco en exponer matricula 2025 en el motor (D19, convivencia),
  desglose de matricula por grado (P-matricula-grado) y un bloque narrativo nuevo
  en la vista por territorio. Las dos primeras quedaron RESUELTAS y verificadas; la
  tercera (narrativa + ajustes de layout) quedo INCOMPLETA por iteracion visual no
  convergente. Cierre solicitado por el titular.
- **Entorno:** R 4.5.2 en Positron, macOS aarch64. Modelo: Claude Opus 4.8.
- **Archivos principales modificados:**
  - `slep_analisis_matricula/04_generar_matricula_rbd_grado.R` (proyecto hermano,
    OneDrive sin Git): CREADO. Genera el parquet a grano de grado.
  - `20_insumos/matricula_rbd_grado.parquet` (NUEVO insumo, copiado a mano).
  - `30_procesamiento/33_generar_html.R`: anio_matricula_vigente, GRADO_LABELS,
    bloque columnar de grado, validaciones.
  - `30_procesamiento/33_motor_template.html`: separacion ANIO_MAT_VIGENTE,
    desglose por grado colapsable, bloque narrativo, ajustes de layout (INESTABLE).
  - `40_salidas/motor_categoria.html` + `docs/index.html` (regenerados).

## 2. Resumen ejecutivo
La sesion 12 abrio sobre el v11 con D19 pendiente (decision de dominio: 2025
reemplaza a 2019 o conviven). El titular eligio CONVIVENCIA. Se descubrio que el
motor NO tenia una constante `ANIO_VIGENTE` como decia el v11, sino
`anio_vigente = max(anios de categoria)`, derivado del parquet territorial. La
convivencia se implemento agregando `anio_matricula_vigente` (dinamico, max de la
matricula = 2025) separado del de categoria (2019); solo la tarjeta de tamano de
la fila de EE consume el nuevo. Verificado end-to-end (datos + visual). Luego se
abordo P-matricula-grado: se creo el script `04` en el hermano (grano
rbd x anio x cod_ense2 x cod_grado, 913.499 filas, validacion de consistencia con
el insumo de ense2 en verde), se filtro a basica/media (2/5/7) en el motor, se
agrego desglose por grado colapsable en la ficha. Verificado. La tercera tarea (un
parrafo narrativo a ancho completo en la vista por territorio, mas ajustes de
alineacion y ancho) NO convergio: multiples iteraciones de layout introdujeron
regresiones (alineacion texto vs borde, solapamiento de filtros, ancho del sitio).
El titular detuvo la sesion con el pendiente narrativo/layout SIN cumplir.

## 3. Estado al cierre
### Que funciona (ultima ejecucion exitosa)
- `run_all()` corre los 4 pasos OK. Ultima corrida limpia confirmada: 2026-06-13
  17:48 (antes de los ultimos ajustes de layout). El motor levanta:
  - `matricula_rbd_ense.parquet`: 211.391 filas, anios 2016-2025.
  - `matricula_rbd_grado.parquet`: 683.914 filas tras filtro a ense2 2/5/7
    (913.499 en origen), anios 2016-2025.
  - JSON 26.9 MB sin comprimir / 2.35 MB comprimido; HTML ~2737 KB.
- Invariantes de categoria del paso 32 intactos (4 categorias por celda, pct suma
  1, n_ee <= n_categorizados, nacional dif=0). La validacion de consistencia de
  grado (suma de grados == matricula por cod_ense2) pasa.
- **D19 RESUELTO Y VERIFICADO:** la ficha muestra "Matricula 2025" como tamano
  vigente; la trayectoria de categoria sigue anclada a 2019; la serie de evolucion
  llega a 2025. Confirmacion visual del titular: OK.
- **P-matricula-grado RESUELTO Y VERIFICADO:** cada tipo de ensenanza basica/media
  en la ficha tiene un toggle que despliega el reparto por grado (1-8 basico, 1-4
  medio); la suma cuadra con la cifra del tipo; los tipos sin grado no tienen
  toggle. Confirmacion visual del titular: OK.

### Que no funciona / pendiente
- **Bloque narrativo + layout: INCOMPLETO (P-narrativa).** La funcion
  `narrativaTerritorial` esta implementada y produce el texto correcto (frases por
  composicion, casos borde 0 EE / 0% / tipo de entidad, datos dinamicos en
  realce, contraste B2 Medio+Alto vs solo Insuficiente sobre matricula 2025). PERO
  los ajustes de LAYOUT alrededor no convergieron: la ultima version centra `.app`
  a max-width 1320px y extiende la tarjeta con margin lateral -26px para alinear su
  texto interno con header y controles. Esta combinacion NO fue verificada como
  correcta por el titular; el historial de la sesion muestra regresiones repetidas
  (desalineacion, solapamiento del rotulo de filtros, ancho oscilante). El estado
  del layout debe considerarse NO CONFIABLE y revisarse de cero.

### Delta respecto a v11
v11 amplio el insumo de matricula a 2016-2025 sin exponerlo. v12 lo expone
(convivencia, D19), agrega el grano de grado (nuevo insumo + nuevo parquet +
desglose en ficha) y deja a medio camino un rediseno de la cabecera de la vista
por territorio (parrafo narrativo + alineacion). Sin cambios estructurales de
carpetas. El hermano `slep_analisis_matricula` gana el script `04`.

## 4. Registro detallado de cambios

### Cambio 59 — Convivencia de anio de matricula (D19): anio_matricula_vigente
- **Categoria:** Diseno UI — Motor (datos derivados).
- **Que (`33_generar_html.R` + `33_motor_template.html`):** se agrego a `meta` el
  campo `anio_matricula_vigente = max(anios de matricula)` (= 2025), derivado de
  `df_mat`, separado de `anio_vigente` (= 2019, de categoria). En el template,
  `ANIO_MAT_VIGENTE` (con fallback `|| anio_vigente`) gobierna SOLO la tarjeta de
  tamano de la fila de EE (mat_nivel_vig, mat_total_vig, etiqueta). Trayectoria,
  detalle por anio y serie de evolucion siguen con ANIO_VIGENTE / p.anio.
- **Por que (C.11):** la convivencia (D19) exige distinguir "tamano vigente" (2025)
  de "categoria vigente" (2019) sin mezclarlos. Dinamico (no hardcode) por A17.
- **Como se verifico (B.4):** resumen del paso 33 imprime "Anio vigente: 2019" y
  "Anio matricula: 2025"; invariantes de categoria intactos; verificacion visual
  del titular OK (tarjeta 2025, trayectoria 2019, serie a 2025).
- **Hallazgo:** el v11 afirmaba que el motor tenia una constante `ANIO_VIGENTE`
  hardcodeada en 2019; FALSO. Era `max(anios_disp)` derivado del parquet
  territorial. Refuerza A16/B.1 (verificar contra el codigo real).

### Cambio 60 — Script 04: parquet de matricula a grano de grado (hermano)
- **Categoria:** Datos y normalizacion (proyecto hermano).
- **Que (`slep_analisis_matricula/04_generar_matricula_rbd_grado.R`, CREADO):**
  replica fiel del `03` (DuckDB perezoso, all_varchar, control COUNT(*) vs DISTINCT
  mrun, llaves character) con `cod_grado` agregado al GROUP BY. Salida
  `matricula_rbd_grado.parquet` a grano rbd x anio x cod_ense2 x cod_grado,
  cobertura 2016-2025, sin `matricula_total_ee` (ya vive en el insumo de ense2).
  913.499 filas. Validacion extra 5.3: reconstruye el agregado por ense2 desde el
  grano de grado y verifica que cuadre con `matricula_rbd_ense.parquet`.
- **Por que (C.11):** P-matricula-grado requeria grano fino; parquet separado para
  no engrosar el principal (decision del alcance).
- **Como se verifico (B.4):** 4 validaciones del `04` en verde, clave la 5.3 (suma
  de grados == matricula por cod_ense2). Dominio confirmado por perfilado previo:
  basica (2) grados 1-8, media (5,7) grados 1-4; sin grados borde en esos niveles.
- **Aprendizaje (refuerza A16):** el alcance afirmaba que `cod_grado` estaba
  confirmado por el script 02; el 03 NO lo lee (lo descarta en el SELECT). Hubo que
  perfilar el CSV (cruce cod_ense2 x cod_grado) antes de escribir el GROUP BY.

### Cambio 61 — Desglose por grado en el motor (33_generar_html.R + template)
- **Categoria:** Diseno UI — Motor.
- **Que:** en `33_generar_html.R`, carga de `matricula_rbd_grado.parquet` filtrada
  a ense2 2/5/7, `GRADO_LABELS` (glosa por cod_ense2 x cod_grado) en meta, bloque
  columnar `matricula_grado_lst`, validacion de dominio (2/5/7) y de consistencia
  (suma de grados == matricula por ense2). En el template, indice `MATG_IX`, helper
  `matriculaPorGrado`, y componente `EnseItem` (cada tipo de ensenanza es un
  sub-componente con estado de colapso; toggle si tiene grado, colapsado por
  defecto). CSS para la sub-lista anidada.
- **Por que (C.11):** anadir profundidad de grano a la ficha sin tocar la categoria.
- **Como se verifico (B.4):** paso 33 imprime "Matric.grado: 683914 filas"; la
  validacion de consistencia no aborta; verificacion visual del titular OK.

### Cambio 62 (PARCIAL/INESTABLE) — Bloque narrativo y rediseno de cabecera territorial
- **Categoria:** Diseno UI — Motor.
- **Que:** funcion `narrativaTerritorial(entity, nivel, dist, porCat)` que arma un
  parrafo de resumen por composicion para la vista por territorio, reemplazando el
  subtitulo "N establecimientos categorizados...". Frases: (1) cuantos EE
  categorizados; (2) distribucion por categoria (omite las de 0 EE); (3) matricula
  por desempeno (contraste B2: Medio+Alto vs SOLO Insuficiente, Medio-Bajo omitido,
  porcentajes sobre matricula total del nivel, anclados a matricula 2025); (4)
  cierre de transicion a la tabla. Datos dinamicos en realce (`dato-destacado`,
  tarjeta sutil crema/plum). Casos borde cubiertos. Sujeto por tipo de entidad (El
  SLEP / La comuna de / La region de / El establecimiento). El titulo del
  territorio se movio dentro de la tarjeta narrativa.
- **Estado:** el CONTENIDO del parrafo es correcto y fue aprobado visualmente. El
  LAYOUT (alineacion del texto del header/controles/tarjeta, ancho del sitio,
  espaciado entre secciones, rotulo de filtros) NO convergio tras ~8 iteraciones y
  quedo en un estado NO confiable. Ultimo intento: `.app` con max-width 1320px
  centrado + tarjeta con margin lateral -26px. NO verificado.
- **Por que no se logro:** iteracion de parametros visuales sin criterio observable
  formal (ver aprendizaje A18). Cada ajuste corregia un sintoma e introducia otro.

## 5. Backlog acumulativo
[Copiar integro el backlog del v11 (1-58) y agregar 59-62. Total cronologico
58->62. Categorias afectadas: "Diseno UI — Motor" (59, 61, 62), "Datos y
normalizacion" (60). El objetivo del proyecto y la nota metodologica no cambian.
Nota v12: se expone matricula 2025 como tamano vigente (convivencia con categoria
2019); se agrega el grano de grado como nuevo insumo y desglose en ficha; queda
incompleto un rediseno narrativo + layout de la cabecera territorial.]

## 6. Bugs de la sesion
No hubo bugs de codigo del pipeline (todas las corridas en verde). Si hubo una
falla de PROCESO grave: la iteracion de layout del cambio 62 produjo regresiones
repetidas (al menos: desalineacion texto/borde, solapamiento del rotulo de filtros
sobre los chips, ancho del sitio oscilando entre 1180/1320/1380/1600/full-width, y
un intento de margin negativo que rompio el layout y debio revertirse). El titular
expreso frustracion explicita y detuvo la sesion. Causa raiz: iterar parametros
CSS sin un criterio de exito observable definido de antemano (A18). No se trato de
un bug del codigo sino de un metodo de trabajo inadecuado para ajuste visual.

## 7. Aprendizajes y restricciones descubiertas

### A16 (reforzado x2) — "Confirmado por otra fuente" se verifica contra el artefacto real
- **Regla:** dos veces en esta sesion una afirmacion heredada resulto falsa al
  inspeccionar el codigo/dato real: (a) el v11 decia que el motor tenia
  `ANIO_VIGENTE` hardcodeado (era derivado); (b) el alcance de P-matricula-grado
  decia que `cod_grado` estaba confirmado por el script 02, pero el 03 lo descarta
  en el SELECT y hubo que perfilar el CSV. Antes de construir sobre una afirmacion
  de un traspaso/alcance, verificarla contra el archivo.
- **Principio:** B.1 (no operar sobre supuestos).

### A17 (reforzado) — Parametrizar en vez de hardcodear el anio vigente
- **Regla:** `anio_matricula_vigente` se definio como `max(anios de matricula)`,
  dinamico; la proxima ampliacion de cobertura no exigira tocarlo. Igual que
  `anio_vigente` para categoria.
- **Principio:** C.10.

### A18 (NUEVO, critico) — El ajuste visual exige criterio observable ANTES de iterar
- **Regla:** iterar parametros de layout (margenes, paddings, max-width,
  alineacion) sin un criterio de exito operacional definido de antemano NO
  converge: cada cambio corrige un sintoma e introduce otro, y el resultado neto es
  frustracion y regresiones. Antes de tocar layout, definir el criterio
  observable EXACTO (p. ej.: "el borde izquierdo del texto del header, del rotulo
  'Vista' y del texto interno de la tarjeta deben caer en la MISMA coordenada X, y
  el sitio debe tener un ancho maximo de NNNN px"), idealmente con un mockup
  anotado del titular, y validar UNA sola vez contra ese criterio. Si el titular
  itera por captura, pedir el criterio explicito en vez de seguir parchando.
- **Principio:** B.4 (criterio de exito antes de actuar). Contexto: la sesion 12
  perdio ~8 turnos en layout sin converger.
- **Precedente en memoria:** ya existia el aprendizaje "la iteracion visual diferida
  necesita criterios de exito" del proyecto hermano. Esta sesion lo confirma con un
  caso costoso. ELEVAR a regla dura.

## 8. Decisiones de diseno

### D19 (RESUELTA) — Convivencia: 2025 (matricula) y 2019 (categoria) coexisten
- **Decision:** 2025 NO reemplaza a 2019. El motor expone matricula 2025 como
  "tamano vigente" (solo en la tarjeta de tamano de la fila de EE) y mantiene la
  categoria anclada a 2019 (trayectoria, distribucion, % de EE). Implementado via
  `anio_matricula_vigente` separado de `anio_vigente`.
- **Alternativa:** reemplazo (2025 como unico vigente). Descartada: la categoria
  tiene cobertura inviolable 2016-2019 (D18); reemplazar sugeriria que la categoria
  llega a 2025.
- **Justificacion:** honesto sobre la convivencia ("matricula 2025 en
  establecimientos clasificados en 2019").

### D20 (NUEVA) — Parquet de grado separado, filtrado a 2/5/7 en el motor
- **Decision:** el grano de grado vive en `matricula_rbd_grado.parquet` (separado
  del de ense2), cubre 2016-2025 y los 8 cod_ense2 en origen; el motor lo filtra a
  2/5/7 (los niveles con categoria) al cargar, para no engrosar el JSON con grados
  de parvularia/especial/adultos que la ficha no muestra.
- **Alternativa:** un solo parquet a grano de grado para todo. Descartada: el insumo
  de ense2 ya da el total por tipo; duplicar el total en el de grado es redundante.
- **Justificacion:** JSON mas liviano, alineado con lo que el template consume.

### D21 (PENDIENTE) — Diseno final de la cabecera narrativa de la vista territorio
- **Estado:** NO resuelta. El contenido del parrafo esta aprobado; el LAYOUT no.
  Requiere un criterio observable explicito del titular (A18) antes de retomar:
  alineacion exacta (que columnas X deben coincidir), ancho maximo del sitio,
  espaciado entre secciones. Sin ese criterio, NO reintentar por captura.

## 9. Constantes y parametros vigentes
[Tabla del v11 sin cambios de CALCULO. Nuevos/cambios:
- `matricula_rbd_ense.parquet`: 2016-2025, 211.391 filas (sin cambio desde v11).
- `matricula_rbd_grado.parquet`: NUEVO, 913.499 filas en origen, 683.914 tras
  filtro 2/5/7 en el motor.
- `meta.anio_vigente` = 2019 (categoria, dinamico = max parquet territorial).
- `meta.anio_matricula_vigente` = 2025 (NUEVO, dinamico = max df_mat).
- `GRADO_LABELS`: NUEVO diccionario cod_ense2 x cod_grado.
- Filtro de grado en motor: cod_ense2 IN (2,5,7).
- Layout: ESTADO INESTABLE, no tomar los valores actuales de max-width/margin como
  definitivos (ver D21).]

## 10. Arquitectura de archivos
Referencia al escaner del cierre (ejecutar `00_escanear_proyecto.R` antes de cerrar
si no se hizo). v12 agrega al repo: `20_insumos/matricula_rbd_grado.parquet`
(NUEVO insumo). Sin cambios estructurales de carpetas. El hermano
`slep_analisis_matricula` (OneDrive sin Git) gana
`04_generar_matricula_rbd_grado.R`; su parquet de salida se copio a mano a
`20_insumos/` de este proyecto. `33_generar_html.R` y `33_motor_template.html`
modificados (este ultimo con layout inestable).

## 11. Pendientes y ruta sugerida

### Inventario de pendientes
- **P-narrativa / D21 — cerrar el rediseno de la cabecera territorial.** Tipo:
  funcionalidad UI + cosmetica. Bloqueado por: FALTA DE CRITERIO OBSERVABLE del
  titular (no por dato ni por codigo). Implica: definir con el titular, idealmente
  con un mockup anotado, (a) que columnas verticales deben alinearse exactamente
  (texto header / rotulo controles / texto interno de la tarjeta / borde de la
  tarjeta), (b) el ancho maximo del sitio en px, (c) el espaciado vertical entre
  secciones. Recien con eso, aplicar UNA vez y validar contra el criterio.
  Complejidad: baja en codigo, alta en coordinacion. Criterio de exito: el titular
  aprueba contra su propio criterio explicito, sin iteracion por captura.
  PRECAUCION: el estado actual del layout es producto de ~8 parches y NO es
  confiable; considerar revertir los cambios de layout del cambio 62 a un estado
  base limpio antes de reconstruir (el contenido de `narrativaTerritorial` SI se
  conserva; lo que se rehace es el CSS de `.app`, `.app-header`, `.controls-bar`,
  `.app-main`, `.terr-narrativa`, `.chip-filter`).
- **P-matricula-grado: CUMPLIDO** (cerrar en backlog).
- **D19: CUMPLIDO** (cerrar en backlog).
- **Modularizacion del template** (deuda tecnica diferida): `33_motor_template.html`
  ahora ~127 KB (crecio con el bloque narrativo y el desglose de grado). La deuda
  del template monolitico se agrava; cualquier trabajo grande de UI deberia evaluar
  modularizar antes. La inestabilidad de layout de esta sesion es sintoma parcial
  de operar sobre un HTML monolitico de 2700+ lineas sin componentizacion del CSS.

### Evaluacion de deuda tecnica
- El template (~127 KB, un solo archivo) es la deuda mayor y creciente. El CSS no
  esta tokenizado por secciones, lo que hizo fragil el ajuste de layout.
- `ANIO_MAT_VIGENTE` y `ANIO_VIGENTE` ambos dinamicos: sin friccion de hardcode.

### Auditoria de cierre (politica 5.6)
- #2 pipeline corre de cero: Si (4 pasos OK). #5 validaciones criticas: Si (6
  invariantes paso 32 + consistencia de grado). #6 reproducible/idempotente: Si.
  #7 constantes nombradas: Si. #8 nombres sin tildes: Si. Resto sin cambios.
- "No" detectado: la entrega de UI de esta sesion (cabecera narrativa) NO cumple
  criterio de calidad visual -> se agrega como pendiente P-narrativa/D21.

### Ruta sugerida para la sesion 13
1. PRIMER paso, antes de tocar codigo: obtener del titular el criterio observable
   EXACTO del layout de la cabecera territorial (mockup anotado con las coordenadas
   X que deben alinearse + ancho maximo del sitio + espaciado). Sin esto, NO
   continuar (A18).
2. Considerar revertir el CSS de layout del cambio 62 a un estado base limpio y
   reconstruir contra el criterio, en vez de seguir parchando el estado actual.
3. Aplicar UNA vez y validar contra el criterio; no iterar por captura.
**Diferir:** modularizacion del template (salvo que se decida que es prerequisito
para un layout estable, lo cual es defendible).

## 12. Instrucciones especificas para la proxima sesion
- 🔒 Agregacion de categoria = conteo de EE. La matricula (ense2 y grado) es
  contexto, nunca pondera agregaciones.
- 🔒 Basica y media nunca se mezclan. El grado vive DENTRO de su cod_ense2; media
  HC (5) y TP (7) comparten grados 1-4 pero son tipos distintos, no se suman a
  nivel de grado.
- 🔒 La categoria mantiene cobertura 2016-2019 (anio_vigente=2019); la matricula es
  2016-2025 y su vigente de tamano es 2025 (anio_matricula_vigente). NO mezclar.
- 🔒 El parquet de grado se filtra a cod_ense2 IN (2,5,7) en el motor; no exponer
  grados de parvularia/especial/adultos.
- 🔒 `docs/index.html` versionado para Pages; `40_salidas/motor_categoria.html`
  regenerable, ignorado. No editar `docs/` a mano.
- ⚠️ NO re-leer los CSV nacionales en este proyecto. El insumo de grado se genera
  en `slep_analisis_matricula` (OneDrive) con `04_generar_matricula_rbd_grado.R`.
- ⚠️ NO retomar el layout de la cabecera territorial sin un criterio observable
  explicito del titular (A18). El estado actual del CSS de layout es producto de
  multiples parches y NO es confiable.
- ✅ ANTES de regenerar el motor: confirmar que `20_insumos/` tiene
  `matricula_rbd_ense.parquet` (211.391 filas, 2016-2025) y
  `matricula_rbd_grado.parquet` (913.499 filas en origen).
- ✅ ANTES de verificar un cambio del template: reemplazar, transpilar babel,
  regenerar.

## 13. Fragmentos de codigo de referencia
[Conservar los de v09-v11. Anadir:]
```r
# Anio vigente de matricula separado del de categoria (convivencia, D19). Ambos
# dinamicos: derivan del parquet, no se hardcodean (A17).
anios_mat <- sort(unique(as.integer(df_mat$anio)))
# en meta:
#   anio_vigente           = max(anios_disp)   # 2019, categoria (parquet territorial)
#   anio_matricula_vigente = max(anios_mat)    # 2025, tamano (df_mat)
```
```r
# Validacion de consistencia grado -> ense2 (el invariante de P-matricula-grado):
# la suma de los grados de un rbd x anio x cod_ense2 debe igualar la matricula de
# ese cod_ense2 en el insumo de ense2. Se corre en el 04 (contra el parquet de
# ense2 en 40_salidas/) y de nuevo en 33_generar_html.R (contra df_mat en memoria).
chk_grado <- df_mat_grado_ord |>
  dplyr::summarise(m_grado = sum(matricula), .by = c(rbd, anio, cod_ense2)) |>
  dplyr::inner_join(
    df_mat_ord |> dplyr::select(rbd, anio, cod_ense2, m_ense = matricula),
    by = c("rbd", "anio", "cod_ense2")
  ) |>
  dplyr::filter(m_grado != m_ense)
stopifnot(nrow(chk_grado) == 0)
```

## 14. Reapertura

### Nombre del chat
`slep_categoria_desempeno, sesion 13 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; leelo desde ahi.
> Retomamos slep_categoria_desempeno en sesion 13. La sesion 12 dejo RESUELTOS D19
> (matricula 2025 como tamano vigente, conviviendo con categoria 2019) y
> P-matricula-grado (desglose por grado en la ficha), ambos verificados. Quedo
> INCOMPLETO el rediseno de la cabecera de la vista por territorio: el parrafo
> narrativo (`narrativaTerritorial`) tiene el contenido correcto, pero el LAYOUT
> (alineacion, ancho, espaciado) no convergio y su estado no es confiable. ANTES de
> tocar codigo necesito definir contigo el criterio observable exacto del layout
> (que columnas deben alinearse, ancho maximo, espaciado), idealmente con un mockup
> anotado. Adjunto el traspaso v12, el escaner, y 33_motor_template.html.

### Documentos para la proxima sesion
1. Protocolo en knowledge base (no se adjuntan): POLITICA_PROYECTO.md v6,
   SETTINGS_Y_PROMPTS_OPERACIONALES.md v1.
2. Opcionales segun foco: `33_motor_template.html` (donde vive el layout a rehacer
   y `narrativaTerritorial`); `33_generar_html.R` (si se toca el JSON);
   `04_generar_matricula_rbd_grado.R` (si se ajusta el grano de grado).
3. Especificos (SI se adjuntan): `traspaso_cierre_v12.md`; `estructura_actual.md`.

### Nota final obligatoria
El insumo `matricula_rbd_grado.parquet` es NUEVO (913.499 filas en origen). Si se
adjunta, adjuntar esa version. `33_motor_template.html` es el archivo clave de la
sesion 13: contiene `narrativaTerritorial` (contenido bueno) y el CSS de layout
(estado inestable, a rehacer contra criterio). Adjuntarlo si se ataca D21.
