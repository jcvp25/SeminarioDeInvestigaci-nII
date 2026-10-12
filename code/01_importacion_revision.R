# SCRIPT 01: IMPORTACIÓN Y REVISIÓN INICIAL DE DATOS
library(tidyverse)
library(here)
library(skimr)

# 1. CARGA DE DATOS
base_raw <- read.csv(here("data", "raw", "base_erc_cohorte.csv"), encoding = "UTF-8")

# 2. REVISIÓN INICIAL
cat("Participantes:", nrow(base_raw), "\n")
cat("Variables:", ncol(base_raw), "\n")
names(base_raw)
glimpse(base_raw)
head(base_raw, 10)

# 3. ESTADÍSTICAS
skim(base_raw)

# 4. DATOS FALTANTES
faltantes <- base_raw %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "n_faltantes") %>%
  mutate(pct_faltantes = round(n_faltantes / nrow(base_raw) * 100, 1)) %>%
  filter(n_faltantes > 0) %>%
  arrange(desc(n_faltantes))
print(faltantes)