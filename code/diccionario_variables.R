library(tidyverse)
library(here)

diccionario <- tribble(
  ~nombre_variable,           ~etiqueta,                                      ~tipo,                 ~unidades,        ~rango_valores,                              ~codigo_missing, ~fuente,
  "id_estudio",               "Identificador único del participante",          "Texto",               "—",              "ERC-0001 a ERC-0300",                       "—",             "Asignado al reclutamiento",
  "edad",                     "Edad al momento del reclutamiento",             "Numérica continua",   "Años",           "30–85",                                     "NA",            "Historia clínica",
  "sexo",                     "Sexo biológico",                                "Categórica nominal",  "—",              "Masculino, Femenino",                       "NA",            "Historia clínica",
  "estadio_basal",            "Estadio KDIGO de ERC al reclutamiento",         "Categórica ordinal",  "—",              "G2, G3a, G3b, G4",                          "NA",            "Clasificado según TFG basal (CKD-EPI)",
  "tfg_ml_min_basal",         "TFG estimada (CKD-EPI) en visita basal",        "Numérica continua",   "mL/min/1.73m²", "10–89",                                     "NA",            "Calculada: fórmula CKD-EPI 2021",
  "creatinina_mg_dl_basal",   "Creatinina sérica en visita basal",             "Numérica continua",   "mg/dL",          "0.5–20",                                    "NA",            "Laboratorio clínico",
  "diabetes",                 "Diagnóstico de diabetes mellitus",              "Lógica (0/1)",        "—",              "0 = No, 1 = Sí",                            "—",             "Historia clínica / criterios ADA",
  "hipertension",             "Diagnóstico de hipertensión arterial",          "Lógica (0/1)",        "—",              "0 = No, 1 = Sí",                            "—",             "Historia clínica / criterios JNC",
  "progresion_g5_o_trr",      "Desenlace primario: progresión a G5 o TRR",     "Lógica (0/1)",        "—",              "0 = No, 1 = Sí",                            "—",             "Revisión de historia clínica al mes 24",
  "tiempo_seguimiento_dias",  "Tiempo hasta evento o último seguimiento",       "Numérica continua",   "Días",           "30–730",                                    "NA",            "Calculado"
)

write.csv(diccionario, here("docs", "diccionario_variables.csv"), row.names = FALSE, fileEncoding = "UTF-8")