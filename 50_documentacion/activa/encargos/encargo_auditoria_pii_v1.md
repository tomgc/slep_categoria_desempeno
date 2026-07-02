# Encargo autónomo — Auditoría incidente PII (Fase 1: solo lectura)

## Contrato

- **Modo:** autónomo, secuencial, ejecuta todo en este turno.
- **Regla de detención:** ninguna operación destructiva en este encargo.
  Cero `git rm`, cero `filter-repo`, cero `push`. Es un encargo de
  auditoría pura. Detente y reporta si encuentras algo que contradiga un
  supuesto de la meta (p.ej. el CSV no tiene las columnas esperadas).
- Rutas absolutas siempre. Sin asumir `cd` previo.
- Proyecto: `/Users/tomgc/Projects/slep_categoria_desempeno`

## Contexto

Traspaso v26 dejó abierto un incidente de gobernanza: posible PII
(`directorio_oficial_ee.csv`, columnas `MRUN`/`RUT_SOSTENEDOR`) en el
historial público de Git. `gobernanza_datos.md` actual clasifica el
proyecto como Rama A (100% público) y no distingue crudo de depurado.
El `.gitignore` actual no tiene regla para `directorio_oficial_ee.csv`.

Antes de decidir el saneamiento (patrón `31_depurar_directorio_oficial.R`
de `slep_idps`, adjunto como referencia) se necesita diagnóstico real.

## Fases

### Fase 1 — Esquema del CSV actual

```
head -3 /Users/tomgc/Projects/slep_categoria_desempeno/20_insumos/auxiliares/directorio_oficial_ee.csv
```

Reportar: delimitador, encabezados completos, si existen `MRUN` y/o
`RUT_SOSTENEDOR` (o nombres equivalentes), cuántas filas tienen
`RUT_SOSTENEDOR` no vacío.

### Fase 2 — Estado en el índice actual

```
git -C /Users/tomgc/Projects/slep_categoria_desempeno ls-files 20_insumos/auxiliares/directorio_oficial_ee.csv
git -C /Users/tomgc/Projects/slep_categoria_desempeno status --porcelain 20_insumos/auxiliares/directorio_oficial_ee.csv
```

Reportar si el archivo está actualmente trackeado o no.

### Fase 3 — Historial completo del archivo

```
git -C /Users/tomgc/Projects/slep_categoria_desempeno log --all --full-history --oneline -- 20_insumos/auxiliares/directorio_oficial_ee.csv
```

Para cada commit listado, reportar hash corto, fecha, mensaje.
Contar el total.

### Fase 4 — Confirmar contenido histórico (no solo el nombre de ruta)

Para el PRIMER y el ÚLTIMO commit de la lista de Fase 3:

```
git -C /Users/tomgc/Projects/slep_categoria_desempeno show <hash>:20_insumos/auxiliares/directorio_oficial_ee.csv | head -3
```

Confirmar que el contenido histórico también trae las columnas
sensibles (no asumir por el nombre de archivo).

### Fase 5 — ¿Está publicado en remoto?

```
git -C /Users/tomgc/Projects/slep_categoria_desempeno log origin/main --oneline -- 20_insumos/auxiliares/directorio_oficial_ee.csv
```

Confirmar si los commits de Fase 3 llegaron a `origin/main` (repo
público) o quedaron solo en local sin pushear.

### Fase 6 — Análisis de filter-repo (sin ejecutar)

```
which git-filter-repo || pip show git-filter-repo
```

Reportar si la herramienta está instalada. Si no, NO instalarla en
este encargo (gate de la Fase 2 de saneamiento, sesión aparte).

## Reporte final (obligatorio, sin log de andamio — esto es auditoría, no ejecución)

Responder en el chat, no como archivo, con esta estructura:

1. Esquema real del CSV (columnas sensibles presentes: sí/no, cuáles).
2. Trackeado actualmente: sí/no.
3. Total de commits afectados, con lista hash+fecha+mensaje.
4. Confirmación de contenido histórico (Fase 4).
5. Publicado en `origin/main`: sí/no, con detalle.
6. `git-filter-repo` disponible: sí/no.

No commitear nada. No modificar nada. Esto es solo lectura.
