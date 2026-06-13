# Estructura actual — slep_categoria_desempeno

- **Raiz:** `/Users/tomgc/Projects/slep_categoria_desempeno`
- **Fecha:** 2026-06-13 18:35:31
- **Totales:** 16 carpetas, 90 archivos
- **Nota:** todos los datos son publicos (Agencia de Calidad) y se versionan en el repo.

## Arbol

```
slep_categoria_desempeno/
├── .github/
│   ├── workflows/
│   │   └── validacion_seguridad.yml  (2.61K)
│   └── .DS_Store  (6K)
├── 10_utils/
│   ├── 10_utils.R  (1.8K)
│   ├── d3.min.js  (273K)
│   └── pako.min.js  (45.8K)
├── 20_insumos/
│   ├── auxiliares/
│   │   ├── .gitkeep  (0)
│   │   ├── 202602_Listado_SLEP_2026_vf.xlsx  (55.5K)
│   │   ├── caracterizacion_establecimientos.xlsx  (16.5K)
│   │   ├── condiciones_uso_bd.doc  (738K)
│   │   ├── diccionario_territorios.xlsx  (16.8K)
│   │   ├── directorio_oficial_ee.csv  (3.6M)
│   │   ├── glosas_directorio_oficial_ee.pdf  (457K)
│   │   ├── prompt_nuevo_proyecto_categoria_desempeno.md  (7.71K)
│   │   ├── rex_1440.pdf  (995K)
│   │   ├── rex_1459.pdf  (3.16M)
│   │   └── rex_589.pdf  (2.68M)
│   ├── .DS_Store  (8K)
│   ├── cdb_2016.xlsx  (398K)
│   ├── cdb_2017.xlsx  (344K)
│   ├── cdb_2018.xlsx  (390K)
│   ├── cdb_2019.xlsx  (376K)
│   ├── cdm_2017.xlsx  (132K)
│   ├── cdm_2018.xlsx  (155K)
│   ├── cdm_2019.xlsx  (151K)
│   ├── matricula_rbd_ense.parquet  (767K)
│   └── matricula_rbd_grado.parquet  (1.47M)
├── 30_procesamiento/
│   ├── .gitkeep  (0)
│   ├── 30_construir_auxiliares.R  (12.7K)
│   ├── 31_leer_normalizar.R  (11.9K)
│   ├── 32_agregar_territorial.R  (13.8K)
│   ├── 33_generar_html.R  (22.7K)
│   └── 33_motor_template.html  (125K)
├── 40_salidas/
│   ├── intermedios/
│   │   ├── .gitkeep  (0)
│   │   ├── categoria_rbd.parquet  (361K)
│   │   ├── categoria_sin_vigente.parquet  (13.6K)
│   │   ├── categoria_territorial.parquet  (40.4K)
│   │   ├── comunas_chile.parquet  (7.18K)
│   │   ├── establecimientos_chile.parquet  (261K)
│   │   └── sleps_chile.parquet  (58.7K)
│   ├── .DS_Store  (6K)
│   └── motor_categoria.html  (2.67M)
├── 50_documentacion/
│   ├── activa/
│   │   ├── decisiones/
│   │   │   ├── 20260611_decision_nombres_establecimientos.md  (2K)
│   │   │   ├── 20260611_decision_sin_gse.md  (2.25K)
│   │   │   ├── 20260612_auditoria_migracion_github.md  (5.84K)
│   │   │   ├── 20260612_decision_cobertura_temporal.md  (2.17K)
│   │   │   ├── 20260612_decision_licencia.md  (1.89K)
│   │   │   ├── 20260612_decision_modelo_pages.md  (1.76K)
│   │   │   ├── 20260612_decision_paleta_categorias.md  (1.99K)
│   │   │   ├── 20260612_decision_visibilidad_repo.md  (1.97K)
│   │   │   ├── 20260613_decision_cobertura_matricula_2025.md  (3.7K)
│   │   │   ├── 20260613_decision_granularidad_matricula.docx  (22.5K)
│   │   │   └── 20260613_decision_procedencia_insumo_matricula.md  (4.94K)
│   │   ├── .DS_Store  (6K)
│   │   ├── gobernanza_datos.md  (3.04K)
│   │   ├── P-matricula-actual_alcance.md  (3.08K)
│   │   ├── P-matricula-grado_alcance.md  (4.85K)
│   │   ├── POLITICA_PROYECTO.md  (29.7K)
│   │   └── SETTINGS_Y_PROMPTS_OPERACIONALES.md  (24.7K)
│   ├── andamios/
│   │   ├── .DS_Store  (6K)
│   │   └── .gitkeep  (0)
│   ├── estructura/
│   │   ├── 20260613_161952_estructura.md  (5.27K)
│   │   ├── 20260613_161952_estructura.txt  (5.33K)
│   │   ├── 20260613_162203_estructura.md  (5.27K)
│   │   ├── 20260613_162203_estructura.txt  (5.33K)
│   │   ├── estructura_actual.md  (5.27K)
│   │   └── estructura_actual.txt  (5.33K)
│   ├── traspasos/
│   │   ├── .gitkeep  (0)
│   │   ├── .Rhistory  (0)
│   │   ├── traspaso_cierre_v01.md  (17.6K)
│   │   ├── traspaso_cierre_v02.md  (18.3K)
│   │   ├── traspaso_cierre_v03.md  (25K)
│   │   ├── traspaso_cierre_v04.md  (25.1K)
│   │   ├── traspaso_cierre_v05.md  (28.6K)
│   │   ├── traspaso_cierre_v06.md  (24.2K)
│   │   ├── traspaso_cierre_v07.md  (25.4K)
│   │   ├── traspaso_cierre_v08.md  (29K)
│   │   ├── traspaso_cierre_v09.md  (36.2K)
│   │   ├── traspaso_cierre_v10.md  (27.9K)
│   │   └── traspaso_cierre_v11.md  (16.9K)
│   └── .DS_Store  (6K)
├── docs/
│   └── index.html  (2.67M)
├── tests/
│   └── .gitkeep  (0)
├── .DS_Store  (12K)
├── .gitignore  (362)
├── 00_escanear_proyecto.R  (8.98K)
├── 00_run_all.R  (6.9K)
├── CLAUDE.md  (4.6K)
├── LICENSE  (1.75K)
├── README.md  (3.4K)
└── slep_categoria_desempeno.Rproj  (220)
```

## Conteo por extension

| Extension | Archivos |
|---|---|
| md | 32 |
| (sin extension) | 16 |
| xlsx | 10 |
| parquet | 8 |
| r | 7 |
| pdf | 4 |
| html | 3 |
| txt | 3 |
| js | 2 |
| csv | 1 |
| doc | 1 |
| docx | 1 |
| rproj | 1 |
| yml | 1 |
