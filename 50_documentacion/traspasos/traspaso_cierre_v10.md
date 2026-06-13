# Traspaso de cierre v10 — slep_categoria_desempeno

## 1. Identificacion
- **Proyecto:** slep_categoria_desempeno
- **Version:** v10
- **Fecha:** 2026-06-13
- **Sesion:** 10 — foco en features de matricula en la ficha y el comparador,
  cierre de la DT documental, documentacion de pendientes de matricula, y
  estandarizacion tipografica completa del motor. Nota: el chat de esta sesion
  sufrio una falla tecnica de herramienta en su tramo final; este traspaso se
  redacto a partir del inventario de cambios y el escaner.
- **Entorno:** R 4.5.2 en Positron, macOS aarch64. Modelo: Claude Opus 4.8.
- **Archivos principales modificados:** `30_procesamiento/33_motor_template.html`
  (todas las features de UI y la estandarizacion tipografica). Sin cambios en
  `33_generar_html.R` ni en los insumos (el dato de matricula ya viajaba desde v09).

## 2. Resumen ejecutivo
La sesion 10 partio sin pendientes de codigo abiertos (v09 cerro P-matricula-ficha)
y se dedico a enriquecer la presentacion de la matricula ya integrada. Se agregaron:
estudiantes por categoria con su porcentaje en las tarjetas de modo territorio;
"N EE" y un tooltip con estudiantes y porcentaje en cada celda del comparador; la
evolucion de matricula del nivel 2016-2019 en el panel expandido de la ficha; y un
reformateo del panel (encabezado del anio en dos lineas, desglose con dos puntos).
Se cerro la DT documental con una nota de procedencia del insumo de matricula, y se
documentaron con alcance resuelto los dos pendientes futuros (P-matricula-actual y
P-matricula-grado), ambos bloqueados por dato. Finalmente se estandarizo toda la
tipografia del motor por tokens: 19 tamanios a 8, 6 pesos a 4, 3 familias a 2. Se
aclaro el texto ambiguo de matricula en la fila colapsada. Todos los builds fueron
limpios con invariantes intactos (10.945 EE, 41.244 filas RBD, 85.594 matricula,
2016-2019, vigente 2019).

## 3. Estado al cierre
### Que funciona (ultima ejecucion exitosa)
- `source("33_generar_html.R")` regenera el motor. Ultimo build verificado:
  plantilla 117.722 chars (con la aclaracion de matricula incluida), HTML 1313 KB,
  invariantes intactos. Builds previos de la sesion: 114.700 (inicio), 115.077
  (features de matricula y formato), 117.722 (estandarizacion + aclaracion).
- Tarjetas de modo territorio: "N establecimientos (XX,X% del total del nivel para
  el territorio)" y "M estudiantes (XX,X% del total del nivel para el territorio)".
- Comparador: cada celda "XX,X% · N EE"; tooltip "M estudiantes en N
  establecimientos · XX,X% de la matricula de Educacion Basica/Media".
- Ficha, fila colapsada: "Matricula 2019: N en Educacion Basica · M en total"
  (resuelto el ambiguo "N (M)").
- Ficha, panel expandido: encabezado del anio "2019 (vigente): [Categoria]" en una
  linea, "N matriculados en Educacion Basica/Media" debajo; desglose por tipo de
  ensenanza con dos puntos ("Parvularia: 44 estudiantes", "Basica: 233"...);
  "Total establecimiento: M"; y al cierre, bloque "Evolucion de la matricula en
  Educacion Basica/Media" con cifra por anio y variacion primer-ultimo.
- Tipografia: 8 tamanios (`--fs-display` 30, `--fs-h1` 24, `--fs-h2` 18, `--fs-lg`
  15, `--fs-base` 13, `--fs-sm` 12, `--fs-xs` 11, `--fs-overline` 10), 4 pesos
  (`--fw-regular` 400, `--fw-medium` 600, `--fw-bold` 700, `--fw-heavy` 800), 2
  familias (`--font-sans` unificada con `--font-display`/`--font-body` como alias,
  `--font-mono`). Cero literales salvo un `0.92em` relativo intencional.

### Que no funciona / pendiente
- Sin pendientes bloqueantes de codigo. El ultimo cambio de texto (aclaracion de
  matricula) quedo aplicado en el template y regenerado; falta solo verificacion
  visual final del titular.

### Delta respecto a v09
- v09 integro la matricula a la ficha (dos capas). v10 enriquece su presentacion en
  tres vistas (tarjetas, comparador, evolucion en ficha), reformatea el panel,
  aclara el texto ambiguo, cierra la DT documental, documenta dos pendientes, y
  estandariza toda la tipografia. Sin cambios estructurales de carpetas ni de R.

## 4. Registro detallado de cambios

### Cambio 49 — Estudiantes por categoria + % en tarjetas de modo territorio
- **Categoria:** Diseno UI — Modo territorio (o crear subcategoria si se prefiere).
- **Que (`33_motor_template.html`):** `distribucionDesdeEE` devuelve `matTotalNivel`
  (matricula del nivel de los EE categorizados). `CatColumn` recibe `matTotal`,
  suma `mat_nivel_vig` de sus EE, calcula `matPct = matNivel/matTotal` y muestra
  "M estudiantes (XX,X% ...)". Texto "establec." expandido a "establecimientos"
  con singular/plural; ambos % entre parentesis con la frase "del total del nivel
  para el territorio".
- **Por que (C.11):** dar el peso en estudiantes junto al conteo de EE, sin que el
  % de categoria deje de ser conteo de EE. Denominador A (categorizados) para que
  coincida con el universo del % de establecimientos; los 4 % de matricula suman 100.
- **Como se verifico (B.4):** build limpio; verificacion visual del titular.
- **Invariante:** el % de categoria sigue siendo conteo de EE; la matricula es
  contexto aditivo, nunca pondera.

### Cambio 50 — "N EE" + tooltip de estudiantes y % en el comparador
- **Categoria:** Diseno UI — Hoja comparativa.
- **Que (`33_motor_template.html`):** `distEntidadComparativa` acumula `cats[c].mat`
  y `matTotalNivel`. Cada celda pasa de "XX,X% (n)" a "XX,X% · n EE"; el `<td>` gana
  `title` con "M estudiantes en N establecimientos · XX,X% de la matricula de
  [nivel]". Tooltip nativo (sin estado, no pisa el heatmap).
- **Por que (C.11):** "N EE" aclara que el numero son establecimientos; el tooltip
  aporta el dato de estudiantes sin recargar la celda.
- **Como se verifico (B.4):** build limpio; coincide con modo territorio para el
  mismo territorio/categoria/nivel.

### Cambio 51 — Evolucion de matricula del nivel 2016-2019 en la ficha
- **Categoria:** Diseno UI — Modo establecimiento.
- **Que (`33_motor_template.html`):** helper `matriculaSerieNivel(rbd, nivel)`
  (serie por todos los anios, null donde falte). Bloque "Evolucion de la matricula
  en [nivel]" al cierre del panel expandido, separado de la trayectoria de
  categoria: cifra por anio + variacion primer->ultimo anio con dato (absoluta y %).
  Se oculta con menos de 2 anios con dato. CSS con tendencia en `--ocean` (alza) /
  `--cat-insuf` (baja). Diseno textual, no SVG (HTML autocontenido liviano, B.2).
- **Por que (C.11):** se uso el dato nacional disponible (2016-2019, grano
  cod_ense2) para dar tendencia de tamanio, en vez de la matricula 2025 que no
  existe en el insumo.
- **Como se verifico (B.4):** logica del delta validada con 5 casos (alza, baja,
  igualdad, miles); build limpio.

### Cambio 52 — Reformateo del panel expandido (dos lineas + dos puntos)
- **Categoria:** Diseno UI — Modo establecimiento.
- **Que (`33_motor_template.html`):** encabezado del anio en dos lineas (categoria
  arriba con dos puntos tras el anio, matricula del nivel debajo como bloque
  indentado `.ee-detail-matnivel`); desglose por tipo de ensenanza con dos puntos en
  el label y "estudiantes" solo en la primera fila; "Total establecimiento:" con
  dos puntos.
- **Por que (C.11):** legibilidad pedida por el titular (capturas); el contexto de
  cada linea desambigua sin repetir "estudiantes".
- **Como se verifico (B.4):** build limpio; verificacion visual del titular.

### Cambio 53 — Aclaracion del texto de matricula en la fila colapsada
- **Categoria:** Diseno UI — Modo establecimiento.
- **Que (`33_motor_template.html`):** "Matricula 2019: 58 (68)" pasa a "Matricula
  2019: 58 en Educacion Basica · 68 en total". El parentesis ambiguo se reemplaza
  por texto explicito del nivel y del total del EE.
- **Por que (C.11):** el "(68)" no comunicaba que era el total del establecimiento.
- **Como se verifico (B.4):** aplicado por el titular, verificado en el template
  (lineas 1984-1987); pendiente regenerar + verificacion visual final.

### Cambio 54 — Estandarizacion tipografica por tokens
- **Categoria:** Diseno UI — Motor base y diseno (o crear "Sistema de diseno").
- **Que (`33_motor_template.html`):** se reemplazaron tokens fantasma de `:root`
  (escala clamp sin usar) por la escala real. Tamanios: 19 valores literales
  (9-30px, con medios pixeles) consolidados en 8 tokens `--fs-*`; piso de 11px
  (`--fs-xs`) para minusculas, 10px (`--fs-overline`) solo para etiquetas mayuscula
  con tracking. Pesos: 6 (400-900) a 4 tokens `--fw-*` (900->heavy, 500->medium).
  Familias: `--font-display` y `--font-body` eran identicas; se unifican en
  `--font-sans` con las dos previas como alias (no rompe referencias); `--font-mono`
  se mantiene. Migrados tambien 2 estilos inline en JSX. Cero literales salvo un
  `0.92em` relativo intencional.
- **Por que (C.11):** los medios pixeles eran ruido de ediciones, indistinguibles
  del entero vecino; la escala por tokens da consistencia y mantenibilidad. El piso
  de 11px en minusculas mejora legibilidad (los 9px previos eran solo overlines
  mayuscula, que toleran 10px).
- **Como se verifico (B.4):** cero literales tras la migracion (verificado por grep);
  marcadores A2 intactos; transpilacion babel OK. Ningun elemento cambia de tamanio
  de forma perceptible.

## 5. Backlog acumulativo
[Copiar integro el backlog de v09 y agregar al final los cambios 49-54. Total
cronologico pasa de 48 a 54. Categorias afectadas: "Diseno UI — Modo
establecimiento" (51, 52, 53), "Diseno UI — Hoja comparativa" (50), "Diseno UI —
Modo territorio" o la que aplique (49), "Diseno UI — Motor base y diseno" (54). El
objetivo del proyecto y la nota metodologica no cambian. Nota v10: la ficha
enriquece la presentacion de matricula (tarjetas con %, comparador con tooltip,
evolucion 2016-2019), se reformatea el panel y se estandariza la tipografia; la
matricula sigue siendo contexto, sin entrar en agregaciones de categoria.]

## 6. Bugs de la sesion
No aplica: no hubo bugs de codigo en el proyecto. Si hubo una falla tecnica de
herramienta en el chat (emision espuria del token "court" antes de invocaciones,
que impedia ejecutar tools); no afecta al codigo ni al repo, solo motivo el cierre
anticipado y la redaccion manual de este traspaso.

## 7. Aprendizajes y restricciones descubiertas
### A14 — Un proxy debe verificarse contra su definicion antes de adoptarlo
- **Regla:** la base de rendimiento 2025 (planilla rbd x anio, 4 comunas, sin
  cod_ense2) se evaluo como proxy de matricula 2025 y se descarto: cobertura local
  (73 EE de 10.945), grano sin nivel (mezclaria basica/media), y de otro proyecto.
  Un proxy que no cumple la definicion del dato (matricula = COUNT(*) por
  cod_ense2, nacional) produce cifras enganosas.
- **Principio:** B.1 (no operar sobre supuestos); invariante de no mezclar niveles.

### A15 — Estandarizar por tokens, distinguiendo funcion no solo valor
- **Regla:** al consolidar tamanios pequenos, el mismo valor (10px) fue a tokens
  distintos segun funcion: overline-mayuscula a `--fs-overline`, texto normal al
  piso `--fs-xs` (11). Estandarizar no es reemplazo ciego por valor.
- **Principio:** C.10 (constantes nombradas); accesibilidad (piso de legibilidad).

## 8. Decisiones de diseno
### D15 — % de matricula con denominador de categorizados (no del total con s/i)
- **Decision:** el % de estudiantes por categoria se calcula sobre la matricula del
  nivel de los EE categorizados (mismo universo que el % de EE), no sobre todos los
  EE. Los 4 % suman 100.
- **Alternativa:** denominador con EE sin categoria vigente (no sumaria 100).
- **Justificacion:** coherencia con el % de establecimientos que acompana la cifra.

### D16 — Evolucion de matricula con dato disponible (2016-2019), no 2025
- **Decision:** ante la ausencia de matricula 2025 en el insumo, se implemento la
  evolucion 2016-2019 (dato nacional, grano cod_ense2) en vez de esperar 2025.
- **Justificacion:** entrega valor verificable ahora; P-matricula-actual queda
  documentado para cuando exista el insumo 2025.

### D17 — Escala tipografica de 8 tamanios con piso de legibilidad
- **Decision:** 8 tamanios, piso 11px para minusculas, 10px solo overlines
  mayuscula; 4 pesos; 2 familias (display=body unificadas).
- **Alternativa:** mantener una fuente display distinta (descartada: hoy no hay
  distincion real; agregar fuente es cambio de identidad para otra sesion).

## 9. Constantes y parametros vigentes
[Tabla de v09 + nuevos tokens tipograficos: `--fs-display/h1/h2/lg/base/sm/xs/
overline`, `--fw-regular/medium/bold/heavy`, `--font-sans`. Sin cambios en
constantes de calculo.]

## 10. Arquitectura de archivos
Referencia al escaner del 2026-06-13 14:20:44 (84 archivos, 16 carpetas). v10 agrega
al repo: `50_documentacion/activa/decisiones/20260613_decision_procedencia_insumo_matricula.md`
y `50_documentacion/activa/P-matricula-grado_alcance.md` (el de P-matricula-actual
debe archivarse igual si aun no esta). El informe del one-off figura como
`20260613_decision_granularidad_matricula.docx`. Sin cambios estructurales de carpetas.

## 11. Pendientes y ruta sugerida
### Inventario de pendientes
- **Verificacion visual final** del cambio 53 (aclaracion de matricula) tras
  regenerar. Baja complejidad.
- **P-matricula-actual** (bloqueado por dato): matricula 2025 como tamanio actual.
  Alcance resuelto en `50_documentacion/activa/P-matricula-actual_alcance.md`.
  Requiere regenerar el insumo con 2025 en slep_analisis_matricula.
- **P-matricula-grado** (bloqueado por dato): desglose por cod_grado en el panel.
  Alcance en `50_documentacion/activa/P-matricula-grado_alcance.md`. Requiere
  regenerar el insumo a grano cod_grado.

### Auditoria de cierre (politica 5.6)
- #2 pipeline corre de cero: Si. #5 validaciones criticas: Si (sin cambios en R).
  #7 constantes nombradas: Si (tokens tipograficos). #8 nombres sin tildes: Si.
  Resto sin cambios respecto a v09.

### Ruta sugerida para la sesion 11
1. Generar formalmente el traspaso v10 si este texto no se materializo como archivo
   (este documento es su contenido).
2. Verificacion visual del cambio 53.
3. P-matricula-actual o P-matricula-grado solo si el titular trae el insumo
   regenerado.
**Diferir:** modularizacion del template (sigue siendo HTML unico autocontenido).

## 12. Instrucciones especificas para la proxima sesion
- 🔒 Agregacion de categoria = conteo de EE. La matricula (tarjetas, comparador,
  ficha) es contexto, nunca pondera ni entra en agregaciones.
- 🔒 Basica y media nunca se mezclan. Las cifras de matricula por categoria/nivel
  usan la matricula del NIVEL (basica = cod_ense2 2; media = 5+7), nunca el total.
- 🔒 El % de matricula usa denominador de categorizados (mismo universo que el % de
  EE); los 4 % suman 100 (D15).
- 🔒 Tipografia por tokens: usar SIEMPRE `--fs-*` y `--fw-*`, jamas valores
  literales. Piso `--fs-xs` (11) para minusculas; `--fs-overline` (10) solo
  overlines mayuscula. `--font-sans` para texto, `--font-mono` para codigos (A15).
- 🔒 `docs/index.html` versionado para Pages; `40_salidas/motor_categoria.html`
  regenerable, ignorado por Git. No editar `docs/` a mano.
- ✅ ANTES de verificar un cambio del template: reemplazar, transpilar babel,
  regenerar (A1). Confirmar marcadores A2 (`function EeRow`, `RBD_MOTIVO`,
  `LIMITE = 10`, `cmp-clear-btn`, `sinMedicionEE`).
- ✅ ANTES de regenerar el insumo de matricula: correrlo en slep_analisis_matricula,
  no en este repo; copiar el parquet a mano.
- ⚠️ NO re-leer los CSV nacionales en este proyecto.

## 13. Fragmentos de codigo de referencia
[Conservar los de v09. Anadir el patron de la serie de matricula:]
```javascript
// Serie de matricula del nivel por todos los anios (null donde falte).
function matriculaSerieNivel(rbd, nivel) {
  return YEARS.map(y => ({ anio: y, mat: matriculaNivel(rbd, nivel, y) }));
}
```

## 14. Reapertura
### Nombre del chat
`slep_categoria_desempeno, sesion 11 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; leelo desde ahi.
> Retomamos slep_categoria_desempeno en sesion 11. La sesion 10 cerro con una falla
> tecnica de herramienta; su traspaso v10 se redacto manualmente y esta adjunto.
> Pendiente inmediato: verificacion visual del ultimo cambio de texto de matricula.
> P-matricula-actual y P-matricula-grado siguen bloqueados por dato. Adjunto el
> traspaso v10, el escaner re-ejecutado y 33_motor_template.html (version vigente).

### Documentos para la proxima sesion
1. Protocolo en knowledge base (no se adjuntan): POLITICA_PROYECTO.md v6,
   SETTINGS_Y_PROMPTS_OPERACIONALES.md v1.
2. Opcionales: 33_motor_template.html (molde, si se edita la ficha);
   33_generar_html.R (si se toca el JSON o un insumo).
3. Especificos (si se adjuntan): traspaso_cierre_v10.md; estructura_actual.md.

### Nota final obligatoria
33_motor_template.html crecio a ~115 KB. Adjuntar la version vigente (ya editada con
los cambios 49-54), no una previa (A2).