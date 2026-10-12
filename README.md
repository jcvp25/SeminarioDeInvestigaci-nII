# SeminarioDeInvestigaci-nII

# Impacto de Revistas Potencialmente Depredadoras en Metaanálisis de Anestesiología

## Descripción
Este es un estudio metaepidemiológico que tiene como objetivo describir las características de los ensayos clínicos aleatorizados (ECA) incluidos en el metaanálisis (MA) del desenlace primario de revisiones sistemáticas (RS) de las principales 10 revistas de Anestesiología entre 2021 y 2025. La investigación busca determinar cómo se modifica la estimación del efecto global y la robustez estadística del MA tras la exclusión sistemática de los ECA publicados en revistas potencialmente depredadoras. 

## Fuentes de datos
Los datos provienen de una búsqueda sistemática de RS con MA publicadas entre enero de 2021 y diciembre de 2025 en el top 10 de revistas de Anestesiología según el indicador SCImago Journal Rank (SJR) del año 2024. Se proyecta analizar una muestra de aproximadamente 198 RS y 2775 ECA primarios. Las principales variables disponibles incluyen el estatus de la revista fuente (evaluado mediante la herramienta JET), las estimaciones de efecto globales originales y recalculadas, la heterogeneidad estadística (I2), y las métricas de robustez como el Índice de Fragilidad (FI), el Índice de Fragilidad Inverso (FII) y el Cociente de Fragilidad (FQ).

## Estructura del repositorio
nombre-del-repositorio/
├── README.md # Este archivo
├── protocolo_metaepidemiologia.Rproj # Archivo de proyecto de RStudio
├── data/
│   ├── raw/ # Datos originales (no incluidos en el repositorio)
│   └── processed/ # Datos procesados (no incluidos en el repositorio)
├── code/
│   ├── 01_importacion.R # Importación y revisión inicial de datos
│   ├── 02_limpieza.R # Limpieza y preparación de datos
│   ├── 03_analisis_fragilidad.R # Cálculo de índices FI, FII y FQ
│   ├── 04_analisis_sensibilidad.R # Recálculo de estimadores (Leave-one-out)
│   └── 05_resultados.Rmd # Reporte reproducible de resultados
├── output/
│   ├── figures/ # Forest plots y gráficos generados por el código
│   └── tables/ # Tablas generadas por el código
└── docs/
    └── diccionario_variables.md # Diccionario de variables del proyecto

## Requisitos
Este proyecto fue desarrollado con R Studio. Los paquetes requeridos son:
- `tidyverse` (para manipulación de datos)
- `rmarkdown` (para reportes reproducibles)
- `meta` o `metafor` (para la replicación del modelo estadístico, recálculo de OR/RR/MD y análisis de sensibilidad leave-one-out)

## Cómo reproducir el análisis
1. Clone este repositorio.
2. Coloque los datos extraídos en la carpeta `data/raw/` (solicitar acceso al equipo de investigación).
3. Abra el archivo `.Rproj` en RStudio.
4. Ejecute los scripts en el orden indicado por su numeración.

## Contacto
Julián Camilo Velásquez Paz — [velasquezpjulian@javeriana.edu.co]