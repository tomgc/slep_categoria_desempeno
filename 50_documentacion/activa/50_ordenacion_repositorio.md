# Ordenación del repositorio (política v5.5, SETTINGS §4.7)

> Marcador de SETTINGS §4.7.3, punto 7. Su existencia apaga el gatillo de
> SETTINGS §1.2.2, punto 4bis. Escrito en el encargo a11b con datos copiados de
> los LOG del a11 y del a11b, no de memoria.

- **Fecha:** 2026-09-26. La ordenación se ejecutó el 2026-09-25 (encargo a11). La publicación de la rama, el PR y este marcador son del 2026-09-26 (encargo a11b).
- **Rama:** `ordenacion/20260925`, rebasada en el a11b sobre `main` (`bdf18aa`).
- **PR:** #3, <https://github.com/tomgc/slep_categoria_desempeno/pull/3>. El merge lo decide el titular.
- **LOG:** `50_documentacion/andamios/logs/20260925_ordenacion_repositorio_a11_log.md` (a11) y `50_documentacion/andamios/logs/20260926_autorizacion_datos_y_pr_a11b_log.md` (a11b, en `main`).

## Conteo por bloque (hashes tras el rebase)

| Bloque | Qué | Archivos | Commit |
|---|---|---|---|
| B1 | traspasos y normativos (solo comprobación) | 0 movidos | sin commit |
| B2 | obsoletos a `_archivo/20260925/` | 4 movidos, 3 de ellos versionados | `509a056` |
| B3 | nomenclatura de `50_documentacion/activa/` | 1 renombre | `e12a089` |
| B4 | escáner | 0 movidos, 1 script corregido | `24bb5f3` |

Los otros commits de la rama son el escáner final del a11 (`2c3ae56`), el LOG del a11 (`eff7299`) y el commit de este marcador con el escáner final del a11b.

- **B1:** 1 traspaso vigente (`traspaso_cierre_v31.md`). POLITICA y SETTINGS de `activa/` son idénticos a los del kit (`cmp` exit 0).
- **B2:** los hashes de origen y de destino son idénticos en los 4 archivos.
  - `50_documentacion/activa/P-matricula-actual_alcance.md` (`71d8fb1a`);
  - `50_documentacion/activa/P-matricula-grado_alcance.md` (`1449e5ba`);
  - `20_insumos/auxiliares/prompt_nuevo_proyecto_categoria_desempeno.md` (`3375431a`);
  - `50_documentacion/traspasos/.Rhistory` (0 bytes, ignorado; no entró a ningún commit).
- **B3:** `resena_slep_categoria_desempeno.md` pasó a `50_resena_slep_categoria_desempeno.md` con `git mv` (`430074a0`, renombre al 100 %).
- **B4:** `00_escanear_proyecto.R` tiene dos cambios:
  - C4a, línea 45: excluye `node_modules`, `packrat` y `venv`;
  - C4b, líneas 185 y 200: la línea `Raiz` de los snapshots lleva el nombre del proyecto, no la ruta absoluta.

## Filas canceladas

- `20_insumos/auxiliares/31_depurar_directorio_oficial.R` (B2) no se movió. Tiene referencias vivas en `.gitignore:38`, `gobernanza_datos.md:82` y `:101` (que fija su ubicación), y en `30_procesamiento/30_construir_auxiliares.R:56`. Queda como excepción ubicada por gobernanza.
- `50_documentacion/activa/contrato_categoria_desempeno_v1.md` (B3) no se renombró. Lo fija por nombre `30_procesamiento/34_exportar_contrato_categoria.R:21`, y renombrarlo exige editar el pipeline (SETTINGS §4.7.4).

## Lo que quedó fuera

- Las seis excepciones de POLITICA §2.
- `decisiones/`, que tiene patrón propio según POLITICA §2.
- `andamios/`, que está congelado.
- `P-matricula-*`, que salieron por el Bloque 2.
- `encargos/` (duda D3).
- Las cuatro librerías `.js` de `10_utils/` (duda D1) y los reportes con sello de `tests/reportes/` (duda D2).

## Dudas abiertas

- **D1:** ¿las cuatro librerías `.js` de `10_utils/` se mueven a una carpeta propia (por ejemplo, `30_procesamiento/vendor/`) en un encargo aparte que edite `33_generar_html.R` y `00_run_all.R`? (sí / no, se declaran excepción)
- **D2:** ¿se archivan los reportes con sello de `tests/reportes/` y se conserva solo el alias `auditoria_cifras.md`? (sí / no)
- **D3:** ¿los encargos de `activa/encargos/` llevan prefijo `50_`? (sí: se renombran en un encargo aparte / no: se declaran excepción, como `decisiones/`)

## D4, resuelta por el a11b

- **Pregunta del a11:** el primer push de la rama se detuvo en el hook global `pre-push` (regla R1: 14 archivos con extensión de datos versionados y sin lista de autorización). ¿Se usaba `--no-verify` o se creaba la lista?
- **Resolución:** el titular eligió la opción A (sesión 32). El a11b midió en R las 14 rutas, con control positivo: 0 coincidencias del patrón de RUT y 0 columnas MRUN, RUN o RUT. Después creó `50_documentacion/activa/50_datos_versionados_autorizados.md` en `main`, con una entrada por ruta y sin comodines, en el commit `bdf18aa` (`docs(gobernanza): autoriza los 14 archivos de datos públicos versionados (a11b)`). La rama se rebasó sobre ese `main` y se publicó sin `--no-verify`.
