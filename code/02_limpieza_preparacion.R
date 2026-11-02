install.packages("naniar")

# =========================================================
# SCRIPT 02: LIMPIEZA Y PREPARACIÓN DE DATOS
# Proyecto: Cohorte ERC — Seminario de Epiclínica II
# Autor: Julián Camilo Velásquez Paz
# Fecha: Octubre 2026
# Descripción: Transforma la base de datos cruda en la base
#              analítica lista para análisis estadísticos.
# =========================================================
library(tidyverse)
library(here)
library(skimr)
library(naniar)

# ── 1. CONFIGURACIÓN Y CARGA DE DATOS ─────────────────────────────────
base_raw <- read.csv(
  here("data", "raw", "base_erc_cohorte.csv"),
  encoding = "UTF-8"
)
cat("Base cargada:", nrow(base_raw), "participantes,", ncol(base_raw), "variables\n")

# ── 2. CORRECCIÓN DE TIPOS ──────────────────────────────────────────────
base <- base_raw %>%
  mutate(
    # Variables categóricas ordinales (con orden definido)
    estadio_basal = factor(estadio_basal,
                           levels  = c("G2", "G3a", "G3b", "G4"),
                           ordered = TRUE),
    nivel_educativo = factor(nivel_educativo,
                             levels  = c("Ninguno", "Primaria", "Secundaria",
                                         "Tecnico", "Universitario"),
                             ordered = TRUE),
    # Variables categóricas nominales
    sexo          = factor(sexo),
    etnia         = factor(etnia),
    procedencia   = factor(procedencia),
    etiologia_erc = factor(etiologia_erc),
    
    # Variables lógicas (0/1)
    diabetes              = as.logical(diabetes),
    hipertension          = as.logical(hipertension),
    cardiopatia_isquemica = as.logical(cardiopatia_isquemica),
    tabaquismo_actual     = as.logical(tabaquismo_actual),
    tabaquismo_previo     = as.logical(tabaquismo_previo),
    ieca_o_ara2           = as.logical(ieca_o_ara2),
    estatinas             = as.logical(estatinas),
    perdida_seguimiento_m12 = as.logical(perdida_seguimiento_m12),
    perdida_seguimiento_m24 = as.logical(perdida_seguimiento_m24),
    progresion_g5_o_trr   = as.logical(progresion_g5_o_trr)
  )

# ── 3. IDENTIFICACIÓN DE VALORES FUERA DE RANGO ─────────────────────────
rangos <- list(
  edad                   = c(30, 85),
  peso_kg_basal          = c(35, 180),
  talla_cm               = c(145, 185),
  imc_basal              = c(15, 50),
  pas_mmhg_basal         = c(80, 220),
  pad_mmhg_basal         = c(40, 120),
  tfg_ml_min_basal       = c(10, 89),
  creatinina_mg_dl_basal = c(0.4, 15),
  hemoglobina_g_dl_basal = c(5, 18),
  albumina_g_dl_basal    = c(1.5, 5.5),
  proteinuria_mg_g_basal = c(20, 5500)
)

cat("\n=== VALORES FUERA DE RANGO IDENTIFICADOS ===\n")
atipicos_encontrados <- list()
for (var in names(rangos)) {
  fuera <- base %>%
    filter(!is.na(.data[[var]])) %>%
    filter(.data[[var]] < rangos[[var]][1] | .data[[var]] > rangos[[var]][2]) %>%
    select(id_estudio, all_of(var))
  
  if (nrow(fuera) > 0) {
    cat("\n[!]", var, ":\n")
    print(fuera)
    atipicos_encontrados[[var]] <- fuera
  }
}

# ── 4. CORRECCIÓN DE VALORES ATÍPICOS ───────────────────────────────────
# De acuerdo con la guía y la verificación del log de datos:
base <- base %>%
  mutate(
    # Correcciones en creatinina basal
    creatinina_mg_dl_basal = case_when(
      id_estudio == "ERC-0047" ~ 0.84,          # error punto decimal: 0.08 → 0.84
      id_estudio == "ERC-0271" ~ 142.0 / 88.4,  # unidades µmol/L → mg/dL
      TRUE ~ creatinina_mg_dl_basal             # ERC-0183 (18.5) se conserva (posible extremo)
    ),
    # Correcciones en peso basal
    peso_kg_basal = case_when(
      id_estudio == "ERC-0112" ~ NA_real_,      # valor 8.5 imposible para adulto → faltante
      TRUE ~ peso_kg_basal                      # ERC-0294 (198) se conserva (obesidad mórbida)
    )
  )

# ── 5. VERIFICACIONES DE CONSISTENCIA ───────────────────────────────────
# PAD debe ser menor que PAS
inconsistencia_pa <- base %>%
  filter(!is.na(pas_mmhg_basal) & !is.na(pad_mmhg_basal)) %>%
  filter(pad_mmhg_basal >= pas_mmhg_basal)
cat("\nInconsistencia PA (PAD >= PAS):", nrow(inconsistencia_pa), "casos\n")

# Tabaquismo actual y previo mutuamente excluyentes
inconsistencia_tabaco <- base %>%
  filter(tabaquismo_actual == TRUE & tabaquismo_previo == TRUE)
cat("Inconsistencia tabaquismo (actual Y previo = TRUE):", nrow(inconsistencia_tabaco), "casos\n")

# IMC coherente con peso y talla
base <- base %>%
  mutate(
    imc_calculado   = round(peso_kg_basal / (talla_cm / 100)^2, 1),
    discrepancia_imc = abs(imc_basal - imc_calculado)
  )
inconsistencia_imc <- base %>%
  filter(!is.na(discrepancia_imc) & discrepancia_imc > 2)
cat("Discrepancia IMC > 2 kg/m²:", nrow(inconsistencia_imc), "casos\n")

# ── 6. VARIABLES DERIVADAS ───────────────────────────────────────────────
base <- base %>%
  mutate(
    grupo_edad = cut(edad, breaks = c(0, 45, 60, 75, Inf),
                     labels = c("<45 años", "45–59 años", "60–74 años", "≥75 años"),
                     right  = FALSE) %>% factor(),
    estadio_agrupado = case_when(
      estadio_basal %in% c("G2", "G3a") ~ "Leve-moderado (G2-G3a)",
      estadio_basal %in% c("G3b", "G4") ~ "Moderado-severo (G3b-G4)"
    ) %>% factor(levels = c("Leve-moderado (G2-G3a)", "Moderado-severo (G3b-G4)")),
    etiologia_agrupada = case_when(
      etiologia_erc == "Diabetica"    ~ "Diabética",
      etiologia_erc == "Hipertensiva" ~ "Hipertensiva",
      TRUE                            ~ "Otras / Desconocida"
    ) %>% factor(levels = c("Diabética", "Hipertensiva", "Otras / Desconocida")),
    log_proteinuria_basal = log(proteinuria_mg_g_basal),
    cambio_tfg_m12   = tfg_ml_min_m12 - tfg_ml_min_basal,
    cambio_tfg_m24   = tfg_ml_min_m24 - tfg_ml_min_basal,
    tasa_declive_tfg = (tfg_ml_min_m24 - tfg_ml_min_basal) / 2,
    anemia_basal = case_when(
      sexo == "Femenino"  & hemoglobina_g_dl_basal < 12 ~ TRUE,
      sexo == "Masculino" & hemoglobina_g_dl_basal < 13 ~ TRUE,
      TRUE ~ FALSE
    )
  )

# ── 7. EVALUACIÓN DE DATOS FALTANTES ────────────────────────────────────
faltantes_resumen <- base %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to  = "variable", values_to = "n_faltantes") %>%
  mutate(pct = round(n_faltantes / nrow(base) * 100, 1)) %>%
  filter(n_faltantes > 0) %>%
  arrange(desc(n_faltantes))
cat("\n=== RESUMEN DE DATOS FALTANTES ===\n")
print(faltantes_resumen)

# ── 8. CONSTRUCCIÓN FINAL Y EXPORTACIÓN ──────────────────────────
base_analitica <- base %>%
  select(-imc_basal, -discrepancia_imc) # Variables redundantes eliminadas

cat("\n=== BASE ANALÍTICA FINAL ===\n")
cat("Participantes:", nrow(base_analitica), "\n")
cat("Variables:", ncol(base_analitica), "\n")
cat("Desenlace (progresión G5/TRR):", sum(base_analitica$progresion_g5_o_trr, na.rm = TRUE), "eventos\n")

# Guardar la base de datos limpia en data/processed
saveRDS(base_analitica, here("data", "processed", "base_analitica_v1.0.rds"))
write.csv(base_analitica, here("data", "processed", "base_analitica_v1.0.csv"), row.names = FALSE, fileEncoding = "UTF-8")

cat("\nBase analítica exportada correctamente en data/processed/\n")

# Registrar información de sesión
capture.output(sessioninfo::session_info(), file = here("docs", "session_info_limpieza.txt"))