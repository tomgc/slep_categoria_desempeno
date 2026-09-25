# Traspaso de cierre v11 — slep_categoria_desempeno

## 1. Identificacion
- **Proyecto:** slep_categoria_desempeno
- **Version:** v11
- **Fecha:** 2026-06-13
- **Sesion:** 11 — foco en infraestructura de datos (ampliacion del insumo de
  matricula a 2016-2025) y consolidacion de Git (recuperacion de la sesion 10 sin
  commitear, materializacion del backlog del v10). Sin cambios de UI en el motor.
- **Entorno:** R 4.5.2 en Positron, macOS aarch64. Modelo: Claude Opus 4.8.
- **Archivos principales modificados:**
  - `slep_analisis_matricula/03_generar_matricula_rbd_ense.R` (proyecto hermano,
    one-off sin Git): `ANIOS_OBJETIVO` de `2016:2019` a `2016:2025` + comentarios.
  - `20_insumos/matricula_rbd_ense.parquet` (reemplazado a mano por la version
    2016-2025).
  - `40_salidas/motor_categoria.html` + `docs/index.html` (regenerados por
    `run_all()`; el motor levanta el insumo nuevo).
  - Documentacion: `traspaso_cierre_v10.md` (backlog materializado),
    `P-matricula-actual_alcance.md` (creado),
    `20260613_decision_cobertura_matricula_2025.md` (creado).

## 2. Resumen ejecutivo
La sesion 11 abrio sobre un v10 que la sesion 10 cerro con falla de herramienta:
el traspaso v10 estaba completo pero su backlog (§5) seguia en placeholder, y todo
el trabajo de la sesion 10 (cambios 49-54 en el template, mas docs) estaba en el
working tree sin commitear. Se recupero todo en 5 commits tematicos + push, se
materializo el backlog del v10 a 54 entradas, y se creo el `P-matricula-actual_
alcance.md` que el v10 referenciaba pero no existia. Luego se ataco el bloqueo de
fondo de P-matricula-actual: se descubrio que NO era falta de dato (los CSV
nacionales 2016-2025 ya estaban en `slep_analisis_matricula`) sino un parquet
congelado en 2016-2019 y una constante hardcodeada en el script productor. Se
amplio la cobertura del insumo a 2016-2025 (cambio de una linea), se regenero el
parquet (211.391 filas, 5 validaciones en verde, 2025 con 10.945 EE), se copio a
`20_insumos/`, y `run_all()` confirmo que el motor lo levanta limpio sin romper
invariantes de categoria. El cambio quedo documentado como decision formal. El
consumo de los anios 2020-2025 por el motor (cambio de `ANIO_VIGENTE`) queda como
pendiente bloqueado por decision de dominio, NO por dato.

## 3. Estado al cierre
### Que funciona (ultima ejecucion exitosa)
- `run_all()` corre los 4 pasos (30 auxiliares, 31 normalizacion, 32 agregacion,
  33 motor) en 1.9 s, todos OK. Ultima corrida: 2026-06-13 16:17.
- El motor levanta `matricula_rbd_ense.parquet` con 211.391 filas, 12.194 RBD,
  anios 2016-2025. JSON 11.0 MB sin comprimir / 1.31 MB comprimido; HTML 1713 KB.
- Invariantes de categoria intactos: 10.945 EE, 41.244 filas RBD, "toda celda
  tiene las 4 categorias", "pct suma 1 por celda", "n_ee <= n_categorizados",
  "nacional cuadra con conteo directo (dif = 0)".
- Git al dia: 6 commits empujados en la sesion (edbf86c→9a5467e). Working tree
  limpio salvo `33_motor_template.html` si se regenera.

### Que no funciona / pendiente
- Sin pendientes bloqueantes de codigo. El motor carga los 10 anios de matricula
  pero NO los expone: `ANIO_VIGENTE` sigue en 2019, asi que tarjetas, comparador y
  ficha muestran matricula 2019 como vigente. Exponer 2025 es el cambio pendiente
  (decision de dominio, no bug).
- Verificacion visual del cambio 53 (aclaracion de texto de matricula) y de la
  serie de evolucion (¿llega a 2025 o se queda en 2019?): pendiente del titular.

### Delta respecto a v10
v10 cerro el trabajo de UI de la sesion 10 (cambios 49-54). v11 no toca UI:
recupera la sesion 10 en Git, materializa el backlog del v10, y amplia la cobertura
del insumo de matricula de 4 a 10 anios. El motor ahora tiene el dato 2016-2025
disponible internamente, pero su presentacion sigue anclada a 2019. Sin cambios
estructurales de carpetas.

## 4. Registro detallado de cambios

### Cambio 55 — Recuperacion de la sesion 10 en Git (5 commits + push)
- **Categoria:** Migracion y publicacion / DevOps.
- **Que:** la sesion 10 cerro con falla de herramienta dejando todo en el working
  tree. Se recupero en commits tematicos: (a) `33_motor_template.html` + `docs/
  index.html` (cambios 49-54, feat); (b) `P-matricula-grado_alcance.md` + decision
  de procedencia (docs); (c) `traspaso_cierre_v10.md` (docs); (d) snapshots del
  escaner (chore). Push a main (edbf86c→9822fe0).
- **Por que (C.11):** el commit `718b141` ("regenera motor con matricula") era de
  v09; ningun cambio de la sesion 10 estaba versionado, y Pages servia una version
  previa a los cambios 49-54. Commits atomicos para trazabilidad tematica (politica
  seccion 3).
- **Como se verifico (B.4):** `git status` limpio tras los commits; push aceptado.

### Cambio 56 — Materializacion del backlog acumulativo del v10
- **Categoria:** Documentacion de proyecto.
- **Que:** el §5 del `traspaso_cierre_v10.md` estaba en placeholder ("copiar
  integro v09 + agregar 49-54"). Se materializo: backlog de v09 integro (1-48, sin
  tocar una entrada) + las 6 entradas 49-54, con tabla tematica y estadistico
  recalculados sobre 54. Commit `e16d19a` + push.
- **Por que (C.11):** el backlog es la unica fuente de verdad del conteo historico
  (politica 2.2.5); en placeholder, el v10 era inconsistente.
- **Como se verifico (B.4):** transicion §4→§5→§6 sin lineas huerfanas; el
  cronologico (54) cuadra con la tabla tematica (54).
- **Decision de taxonomia:** los cambios 49 (tarjetas territorio) y 54 (tipografia)
  se absorbieron en "Diseno UI — Motor base y diseno" en vez de abrir categorias
  nuevas (una entrada = ~1.9%, bajo el umbral de absorcion del 2%). Ninguna
  categoria supera 25%.

### Cambio 57 — Ampliacion de la cobertura del insumo de matricula a 2016-2025
- **Categoria:** Datos y normalizacion.
- **Que (`slep_analisis_matricula/03_generar_matricula_rbd_ense.R`):** se cambio
  `ANIOS_OBJETIVO <- 2016:2019` a `2016:2025` y se actualizaron los comentarios del
  header. El resto del pipeline ya era agnostico al anio (localizacion de CSV,
  `normalize_names`, agregacion DuckDB, validaciones, escritura derivan de esa
  constante). Se regenero el parquet: 85.594→211.391 filas, 5 validaciones OK, 2025
  con 10.949 RBD / 10.945 funcionando / 3.541.840 matriculas, sin duplicados a
  grano rbd x cod_ense2 en ningun anio. Se copio a `20_insumos/` a mano.
- **Por que (C.11):** P-matricula-actual estaba documentado como "bloqueado por
  dato 2025"; el diagnostico revelo que el dato YA estaba (CSV 2016-2025 en disco) y
  el bloqueo era un parquet desactualizado + constante hardcodeada.
- **Como se verifico (B.4):** las 5 validaciones del script en verde; conteos por
  anio cuadran con el perfil del script 02; parquet en destino verificado (211.391
  filas, 10 anios, esquema intacto).
- **Aprendizaje (A16):** "bloqueado por dato" debe verificarse contra el disco
  antes de aceptarse; el bloqueo real puede ser un artefacto desactualizado.

### Cambio 58 — Regeneracion del motor con el insumo 2016-2025
- **Categoria:** Pipeline R.
- **Que:** `run_all()` corrio los 4 pasos. El motor (paso 33) levanto el parquet
  nuevo: 211.391 filas, anios 2016-2025. JSON 8.0→11.0 MB; HTML 1313→1713 KB. Los 6
  invariantes de categoria del paso 32 intactos.
- **Por que (C.11):** confirmar que el insumo ampliado entra al motor sin romper
  nada, ANTES de tocar la presentacion.
- **Como se verifico (B.4):** log de `run_all` con los 4 pasos OK; resumen del
  paso 33 con 211.391 filas y 10 anios; validaciones del paso 32 en verde.
- **Nota:** el motor carga los 10 anios pero `ANIO_VIGENTE` sigue en 2019; el dato
  2025 NO se expone aun. Esto es esperado: exponerlo es el cambio pendiente.

## 5. Backlog acumulativo
[Copiar integro el backlog materializado del v10 (1-54) y agregar las entradas
55-58. Total cronologico 54→58. Categorias afectadas: "Migracion y publicacion /
DevOps" (55), "Documentacion de proyecto" (56), "Datos y normalizacion" (57),
"Pipeline R" (58). El objetivo del proyecto y la nota metodologica no cambian.
Nota v11: la cobertura del insumo de matricula se amplia de 2016-2019 a 2016-2025;
el motor levanta el dato nuevo pero no lo expone (ANIO_VIGENTE sigue en 2019); la
sesion fue de infraestructura de datos y Git, sin cambios de UI. Pendiente: exponer
2025 como tamano vigente, bloqueado por decision de dominio, no por dato.]

## 6. Bugs de la sesion
No aplica: no hubo bugs de codigo. Si hubo dos correcciones de rumbo del asistente
(corregidas de inmediato, no cuentan como cambios): (a) acepto inicialmente que un
parquet adjunto era "el nuevo" cuando era el viejo 2016-2019 — se detecto al
inspeccionarlo; (b) sugirio `run_all(only=33)` cuando el titular pidio regenerar
todo — se corrigio a `run_all()`. Ambas refuerzan A16 y B.1 (verificar contra el
artefacto real, no contra el supuesto).

## 7. Aprendizajes y restricciones descubiertas
### A16 — "Bloqueado por dato" se verifica contra el disco antes de aceptarse
- **Regla:** un pendiente marcado "bloqueado por dato externo" puede en realidad
  estar bloqueado por un artefacto desactualizado (parquet viejo) o codigo
  hardcodeado, con el dato ya presente. Antes de declarar que falta un dato,
  inspeccionar que hay en disco (escaner de insumos, esquema del parquet, CSV
  presentes).
- **Principio:** B.1 (no operar sobre supuestos). Contexto: P-matricula-actual se
  arrastro como "bloqueado por dato 2025" cuando los CSV 2016-2025 ya estaban; el
  bloqueo real era el parquet congelado y `ANIOS_OBJETIVO <- 2016:2019`.

### A17 — Un pipeline agnostico al parametro no requiere cambios para extender alcance
- **Regla:** el script `03` esta escrito de forma que toda su logica deriva de
  `ANIOS_OBJETIVO`; ampliar cobertura es cambiar la constante, no escribir logica.
  Cuando un pipeline esta bien parametrizado, "construir los anios faltantes" puede
  reducirse a una linea.
- **Principio:** C.10 (constantes nombradas, no numeros magicos). Ejemplo: pasar de
  4 a 10 anios fue `2016:2019` → `2016:2025`.

## 8. Decisiones de diseno
### D18 — Cobertura del insumo de matricula ampliada a 2016-2025
- **Decision:** el insumo cubre ahora 2016-2025 (serie completa disponible), no
  solo los 4 anios del motor de categoria. Los anios 2020-2025 viajan como contexto
  de tamano; la categoria mantiene su cobertura 2016-2019.
- **Alternativa:** mantener 2016-2019 (descartada: bloqueaba P-matricula-actual sin
  razon, el dato estaba disponible).
- **Justificacion:** desbloquea el tamano actual del EE (matricula 2025) sin afectar
  la categoria; documentada en `20260613_decision_cobertura_matricula_2025.md`.

### D19 (pendiente) — ¿2025 reemplaza a 2019 como ANIO_VIGENTE, o conviven?
- **Estado:** NO decidida. Es la decision de dominio que bloquea exponer 2025 en el
  motor. Opciones: (a) 2025 reemplaza a 2019 como vigente y la evolucion se extiende
  a 2025; (b) conviven (2019 historico de categoria, 2025 tamano actual). Requiere
  input del titular en la proxima sesion.

## 9. Constantes y parametros vigentes
[Tabla de v10 sin cambios de calculo. Cambio en insumo: `matricula_rbd_ense.parquet`
ahora 2016-2025 (211.391 filas) en vez de 2016-2019 (85.594). `ANIO_VIGENTE` SIGUE
en 2019 en `33_generar_html.R` (sin cambio; su actualizacion es D19 pendiente).]

## 10. Arquitectura de archivos
Referencia al escaner del 2026-06-13 14:23:35 (86 archivos, 16 carpetas). v11 agrega
al repo: `50_documentacion/activa/P-matricula-actual_alcance.md` y
`50_documentacion/activa/decisiones/20260613_decision_cobertura_matricula_2025.md`.
El `traspaso_cierre_v10.md` se materializo (backlog). Insumo `matricula_rbd_ense.
parquet` reemplazado. Sin cambios estructurales de carpetas. Nota: el productor
`slep_analisis_matricula` vive en OneDrive sin Git (one-off); su `03` modificado se
versiona via OneDrive, con `_archivo/20260613/` creado para la version previa.

## 11. Pendientes y ruta sugerida
### Inventario de pendientes
- **D19 — exponer 2025 en el motor (decision + implementacion).** Tipo: decision de
  dominio + funcionalidad. Bloqueado por: decision del titular (no por dato).
  Implica: definir reemplazo-vs-convivencia, cambiar `ANIO_VIGENTE` en
  `33_generar_html.R`, regenerar, verificar que la evolucion de matricula y las 3
  vistas se comporten bien, verificar invariantes (conteo EE, no mezcla niveles, 4%
  suman 100), verificacion visual. Complejidad: media. Criterio de exito: el motor
  muestra matricula 2025 como vigente sin alterar ningun invariante de categoria.
- **P-matricula-grado** (bloqueado por grano, NO por dato): la columna `cod_grado`
  EXISTE en los CSV (confirmado por el script 02). Requiere un segundo parquet a
  grano `rbd x anio x cod_grado` (cambio del `GROUP BY` en el `03`) y cambios en el
  motor para el desglose por grado. Alcance en `P-matricula-grado_alcance.md`.
- **Verificacion visual** del cambio 53 y de la serie de evolucion (¿2025?).
  Pendiente del titular. Baja complejidad.
- **Modularizacion del template** (deuda tecnica diferida): `33_motor_template.html`
  ~118 KB en un solo HTML autocontenido. No bloqueado. Sesion dedicada.

### Evaluacion de deuda tecnica
- El `ANIO_VIGENTE` hardcodeado en el generador es un punto de friccion: cada cambio
  de cobertura del motor exige tocarlo a mano. Tolerable mientras sea infrecuente.
- El template monolitico (~118 KB) sigue siendo la deuda tecnica mayor; cualquier
  trabajo de UI grande deberia evaluar modularizar antes.

### Auditoria de cierre (politica 5.6)
- #2 pipeline corre de cero: Si (run_all 4 pasos OK). #5 validaciones criticas: Si
  (6 invariantes del paso 32 en verde). #6 reproducible/idempotente: Si. #7
  constantes nombradas: Si (ANIOS_OBJETIVO). #8 nombres sin tildes: Si. Resto sin
  cambios respecto a v10.

### Ruta sugerida para la sesion 12
1. Resolver D19 (decision de dominio): 2025 reemplaza vs convive. PRIMER paso, antes
   de tocar codigo.
2. Implementar la decision: cambiar `ANIO_VIGENTE`, regenerar, verificar invariantes
   y verificacion visual.
3. Solo si hay tiempo y el titular lo prioriza: P-matricula-grado (segundo parquet a
   grano cod_grado).
**Diferir:** modularizacion del template.

## 12. Instrucciones especificas para la proxima sesion
- 🔒 Agregacion de categoria = conteo de EE. La matricula (ahora 2016-2025) es
  contexto, nunca pondera ni entra en agregaciones.
- 🔒 Basica y media nunca se mezclan. Las cifras por categoria/nivel usan la
  matricula del NIVEL (basica = cod_ense2 2; media = 5+7), nunca el total.
- 🔒 El % de matricula usa denominador de categorizados (4% suman 100, D15).
- 🔒 La categoria mantiene su cobertura 2016-2019; los anios 2020-2025 del insumo
  de matricula son contexto de tamano, no de categoria (D18).
- ⚠️ NO cambiar `ANIO_VIGENTE` sin resolver primero D19 (reemplazo vs convivencia).
  Cambiarlo a ciegas alteraria las 3 vistas sin criterio definido.
- ⚠️ NO re-leer los CSV nacionales en este proyecto. La regeneracion del insumo de
  matricula ocurre en `slep_analisis_matricula` (OneDrive), no aqui.
- ✅ ANTES de regenerar el motor: confirmar que `20_insumos/matricula_rbd_ense.
  parquet` es la version 2016-2025 (211.391 filas), no una previa.
- ✅ ANTES de verificar un cambio del template: reemplazar, transpilar babel,
  regenerar. Confirmar marcadores A2.
- 🔒 `docs/index.html` versionado para Pages; `40_salidas/motor_categoria.html`
  regenerable, ignorado por Git. No editar `docs/` a mano.

## 13. Fragmentos de codigo de referencia
[Conservar los de v09-v10. Anadir el patron de ampliacion de cobertura del insumo:]
```r
# La cobertura del insumo se controla con UNA constante; el resto del pipeline
# (localizacion de CSV, agregacion, validaciones) deriva de ella. Ampliar alcance
# es cambiar el rango, no escribir logica nueva.
ANIOS_OBJETIVO <- 2016:2025
```

## 14. Reapertura
### Nombre del chat
`slep_categoria_desempeno, sesion 12 (Claude Opus 4.8)`

### Mensaje de apertura pre-armado
> Tipo de sesion: CONTINUATION. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; leelo desde ahi.
> Retomamos slep_categoria_desempeno en sesion 12. La sesion 11 amplio el insumo de
> matricula a 2016-2025 y lo dejo cargado en el motor, pero sin exponer (ANIO_VIGENTE
> sigue en 2019). Pendiente inmediato: resolver D19 (¿2025 reemplaza a 2019 como anio
> vigente, o conviven?) ANTES de tocar codigo, y luego implementarlo. Adjunto el
> traspaso v11, el escaner, y 33_generar_html.R + 33_motor_template.html.

### Documentos para la proxima sesion
1. Protocolo en knowledge base (no se adjuntan): POLITICA_PROYECTO.md v6,
   SETTINGS_Y_PROMPTS_OPERACIONALES.md v1.
2. Opcionales segun foco: `33_generar_html.R` (donde vive ANIO_VIGENTE, SI se ataca
   D19); `33_motor_template.html` (molde, si se edita la ficha);
   `P-matricula-grado_alcance.md` (si se ataca el pendiente de grado).
3. Especificos (SI se adjuntan): `traspaso_cierre_v11.md`; `estructura_actual.md`.

### Nota final obligatoria
El insumo `matricula_rbd_ense.parquet` ahora es 2016-2025 (211.391 filas). Si se
adjunta el parquet, adjuntar esa version. `33_generar_html.R` es el archivo clave
de la sesion 12 (ahi vive `ANIO_VIGENTE`); adjuntarlo si se ataca D19.
