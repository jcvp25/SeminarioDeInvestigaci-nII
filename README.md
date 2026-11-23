# Proyecto Analítico: Cohorte de Enfermedad Renal Crónica (ERC)

## Descripción
Este repositorio contiene la estructura analítica reproducible para el análisis de una cohorte prospectiva de pacientes con Enfermedad Renal Crónica (ERC) en estadios G2 a G4. El proyecto hace parte de las actividades prácticas del Módulo 2 del Seminario de Epidemiología Clínica II. El objetivo principal es ejecutar procesos de importación, limpieza, análisis descriptivo y modelado de datos en un entorno controlado y reproducible.

## Fuentes de datos
El análisis se fundamenta en la base de datos sintética `base_erc_cohorte.csv` proporcionada por el curso. Consiste en 300 participantes evaluados en tres puntos de medición (basal, mes 12 y mes 24) con un total de 47 variables clínicas, sociodemográficas y de laboratorio. El detalle completo del diseño y las variables se encuentra documentado en la carpeta `docs/`.

## Estructura del repositorio
cohorte-erc-analisis/
├── README.md                     # Este archivo
├── proyecto_analitico.Rproj      # Archivo de proyecto de RStudio
├── data/
│   ├── raw/                      # Datos originales crudos (excluidos de Git)
│   └── processed/                # Datos procesados limpios (excluidos de Git)
├── code/
│   ├── 01_importacion_revision.R # Script de importación y revisión inicial
│   └── diccionario_variables.R   # Script generador del diccionario
├── output/
│   ├── figures/                  # Figuras generadas por el código
│   └── tables/                   # Tablas generadas por el código
└── docs/
    ├── diccionario_variables.csv # Diccionario detallado de las 47 variables
    └── fuentes_datos.md          # Documentación detallada de la base sintética

## Requisitos
Este proyecto fue desarrollado con R. Los paquetes requeridos para la ejecución del código son:
- `tidyverse` (manipulación y visualización de datos)
- `here` (gestión reproducible de rutas de directorios)
- `skimr` (exploración rápida de estadísticas descriptivas)

## Cómo reproducir el análisis
1. Clone este repositorio en su entorno local.
2. Asegúrese de colocar el archivo `base_erc_cohorte.csv` en la ruta `data/raw/`.
3. Abra el proyecto desde el archivo `.Rproj` en RStudio.
4. Ejecute los scripts de la carpeta `code/` en orden numérico.

## Contacto
Julián Camilo Velásquez Paz

## Estado del proyecto

**Versión actual:** v1.0 (análisis final)

### Productos generados

| Archivo | Descripción |
|---------|-------------|
| `code/08_reporte_final.html` | Reporte completo del análisis |
| `output/tables/tabla_01_caracteristicas_basales.docx` | Características basales |
| `output/tables/tabla_02_or_ajustados.docx` | OR ajustados (regresión logística) |
| `output/tables/tabla_03_hr_ajustados.docx` | HR ajustados (modelo de Cox) |
| `output/figures/figura_01_tfg_declive_estadio.png` | TFG y tasa de declive por estadio |
| `output/figures/figura_02_kaplan_meier.png` | Curvas de Kaplan-Meier |

### Cómo reproducir el análisis

1. Clone el repositorio
2. Coloque `base_erc_cohorte.csv` en `data/raw/`
3. Ejecute los scripts en orden numérico (01 → 08)
4. Los productos se generarán automáticamente en `output/`