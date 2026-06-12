# Estructura actual — slep_categoria_desempeno

- **Raiz:** `/Users/tomgc/Projects/slep_categoria_desempeno`
- **Fecha:** 2026-06-12 12:37:42
- **Totales:** 16 carpetas, 68 archivos
- **Nota:** todos los datos son publicos (Agencia de Calidad) y se versionan en el repo.

## Arbol

```
slep_categoria_desempeno/
├── .github/
│   └── workflows/
│       └── validacion_seguridad.yml  (2.61K)
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
│   └── cdm_2019.xlsx  (151K)
├── 30_procesamiento/
│   ├── .gitkeep  (0)
│   ├── 30_construir_auxiliares.R  (12.7K)
│   ├── 31_leer_normalizar.R  (11.9K)
│   ├── 32_agregar_territorial.R  (13.8K)
│   ├── 33_generar_html.R  (15K)
│   └── 33_motor_template.html  (66.4K)
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
│   └── motor_categoria.html  (928K)
├── 50_documentacion/
│   ├── activa/
│   │   ├── decisiones/
│   │   │   ├── 20260611_decision_nombres_establecimientos.md  (2K)
│   │   │   ├── 20260611_decision_sin_gse.md  (2.25K)
│   │   │   └── 20260612_auditoria_migracion_github.md  (5.84K)
│   │   ├── .DS_Store  (6K)
│   │   ├── gobernanza_datos.md  (3.04K)
│   │   ├── POLITICA_PROYECTO.md  (29.7K)
│   │   └── SETTINGS_Y_PROMPTS_OPERACIONALES.md  (24.7K)
│   ├── andamios/
│   │   └── .gitkeep  (0)
│   ├── estructura/
│   │   ├── 20260612_092909_estructura.md  (3.69K)
│   │   ├── 20260612_092909_estructura.txt  (3.73K)
│   │   ├── 20260612_123657_estructura.md  (4.07K)
│   │   ├── 20260612_123657_estructura.txt  (4.12K)
│   │   ├── estructura_actual.md  (4.07K)
│   │   └── estructura_actual.txt  (4.12K)
│   ├── traspasos/
│   │   ├── .gitkeep  (0)
│   │   ├── traspaso_cierre_v01.md  (17.6K)
│   │   ├── traspaso_cierre_v02.md  (18.3K)
│   │   └── traspaso_cierre_v03.md  (25K)
│   └── .DS_Store  (6K)
├── docs/
│   └── index.html  (928K)
├── tests/
│   └── .gitkeep  (0)
├── .DS_Store  (10K)
├── .gitignore  (362)
├── 00_build.R  (1.25K)
├── 00_escanear_proyecto.R  (8.98K)
├── 00_run_all.R  (6.59K)
├── CLAUDE.md  (4.6K)
├── LICENSE  (1.75K)
├── README.md  (3.4K)
└── slep_categoria_desempeno.Rproj  (220)
```

## Conteo por extension

| Extension | Archivos |
|---|---|
| md | 15 |
| (sin extension) | 13 |
| xlsx | 10 |
| r | 8 |
| parquet | 6 |
| pdf | 4 |
| html | 3 |
| txt | 3 |
| js | 2 |
| csv | 1 |
| doc | 1 |
| rproj | 1 |
| yml | 1 |
