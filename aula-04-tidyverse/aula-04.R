# ---------------------------------------------------------------------------
# Aula 04 — Manuseio de dados com o tidyverse
# A limpeza que o resto da semana usa. O que sai daqui alimenta as aulas 05 e 06.
# ---------------------------------------------------------------------------
library(dplyr)
library(tidyr)

bruto <- read.csv("dados/anuros_altitude.csv")

# ---- 1. Renomear: unidade sai do nome, vai para os metadados ---------------
anuros <- bruto %>%
  rename(
    id        = ID,
    especie   = Species,
    sexo      = Sex,
    ewl       = EWL_Ugcm2s1,     # µg H2O / cm2 / s
    wu        = WU_Ugcm2s1,      # µg H2O / cm2 / s
    massa     = Bodymass_g,      # g
    ctmin     = CTmin,           # °C
    ctmax     = CTmax,           # °C
    amplitude = Tbr,             # °C  (derivada: ctmax - ctmin)
    tol_aquec = WT,              # °C  (derivada: ctmax - BIO_5)
    serra     = Mountain_Range,
    altitude  = Altitude_m       # m
  )

# ---- 2. Tirar o que é redundante ou não usaremos --------------------------
anuros <- anuros %>%
  select(id, especie, sexo, serra, altitude,
         massa, ewl, wu, ctmin, ctmax, amplitude, tol_aquec,
         bio5 = BIO_5, bio6 = BIO_6)

# ---- 3. Tipos: altitude é numérica, mas funciona como fator ordenado ------
anuros <- anuros %>%
  mutate(
    especie  = factor(especie),
    serra    = factor(serra),
    sexo     = factor(sexo),
    alt_fator = factor(altitude, levels = sort(unique(altitude)))
  )

str(anuros)

# ---- 4. Recalcular as derivadas em vez de confiar nelas -------------------
anuros <- anuros %>%
  mutate(
    amplitude = ctmax - ctmin,
    tol_aquec = ctmax - bio5
  )

# ---- 5. Subsetting --------------------------------------------------------
anuros %>% filter(especie == "Boana faber")
anuros %>% filter(altitude >= 1000, !is.na(ctmax))
anuros %>% filter(is.na(sexo)) %>% nrow()   # quantos sem sexo registrado

# ---- 6. split-apply-combine ----------------------------------------------
resumo <- anuros %>%
  group_by(especie, alt_fator) %>%
  summarise(
    n         = n(),
    ctmax_med = mean(ctmax, na.rm = TRUE),
    ctmax_dp  = sd(ctmax, na.rm = TRUE),
    ewl_med   = mean(ewl,  na.rm = TRUE),
    .groups = "drop"
  )
print(resumo, n = 10)

# ---- 7. O desenho amostral, em uma linha ----------------------------------
anuros %>% count(serra, altitude)
# Cada altitude está em UMA serra só. Guarde isso para a aula 06.

# ---- 8. Guardar o resultado ----------------------------------------------
dir.create("dados/processados", showWarnings = FALSE, recursive = TRUE)
write.csv(anuros, "dados/processados/anuros_limpo.csv", row.names = FALSE)
