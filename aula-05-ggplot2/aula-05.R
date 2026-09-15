# ---------------------------------------------------------------------------
# Aula 05 — Gramática dos gráficos com ggplot2
# Usa o arquivo limpo que saiu da aula 04.
# ---------------------------------------------------------------------------
library(ggplot2)
library(dplyr)

anuros <- read.csv("dados/processados/anuros_limpo.csv") %>%
  mutate(alt_fator = factor(altitude, levels = sort(unique(altitude))))

# ---- 1. As três camadas ---------------------------------------------------
# dados + mapeamento + geometria
ggplot(anuros, aes(x = ctmin, y = ctmax)) +
  geom_point()

# ---- 2. Uma variável: distribuição ----------------------------------------
ggplot(anuros, aes(x = ctmax)) + geom_histogram(bins = 25)
ggplot(anuros, aes(x = especie)) + geom_bar()

# ---- 3. Dentro ou fora do aes()? -----------------------------------------
ggplot(anuros, aes(ctmin, ctmax, colour = especie)) + geom_point()  # dos dados
ggplot(anuros, aes(ctmin, ctmax)) + geom_point(colour = "red")      # decisão sua

# ---- 4. Discreta vs contínua ---------------------------------------------
ggplot(anuros, aes(ctmin, ctmax, colour = altitude)) + geom_point()   # gradiente
ggplot(anuros, aes(ctmin, ctmax, colour = alt_fator)) + geom_point()  # níveis

# ---- 5. Boxplot: o gráfico da pergunta do artigo -------------------------
ggplot(anuros, aes(x = alt_fator, y = ctmax, colour = especie)) +
  geom_boxplot() +
  labs(x = "Altitude (m)", y = "CTmax (°C)", colour = NULL)

# ---- 6. Facetas: uma janela por espécie ----------------------------------
ggplot(anuros, aes(x = altitude, y = ctmax)) +
  geom_point(alpha = .6) +
  geom_smooth(method = "lm", formula = y ~ x) +
  facet_wrap(~ especie, scales = "free_y") +
  labs(x = "Altitude (m)", y = "CTmax (°C)")

# ---- 7. A ordem das camadas importa --------------------------------------
ggplot(anuros, aes(altitude, tol_aquec)) + geom_point() + geom_smooth()
ggplot(anuros, aes(altitude, tol_aquec)) + geom_smooth() + geom_point()

# ---- 8. A figura que vai para o relatório --------------------------------
fig <- ggplot(anuros, aes(x = altitude, y = tol_aquec, colour = especie)) +
  geom_point(alpha = .65, size = 1.9) +
  geom_smooth(method = "lm", formula = y ~ x, se = TRUE, linewidth = .8) +
  labs(x = "Altitude (m)",
       y = "Tolerância ao aquecimento (°C)",
       colour = NULL,
       caption = "Dados: Bovo et al. (2023), doi:10.1093/iob/obad009") +
  theme_minimal(base_size = 12) +
  theme(legend.position = "top")

dir.create("figuras", showWarnings = FALSE)
ggsave("figuras/tolerancia_aquecimento.png", fig,
       width = 8, height = 4.5, dpi = 200)

# ---------------------------------------------------------------------------
# CONFIRA ANTES DE SEGUIR
# ---------------------------------------------------------------------------
stopifnot(
  file.exists("figuras/tolerancia_aquecimento.png"),
  inherits(fig, "ggplot"),
  nrow(anuros) == 225
)
cat("Aula 05 OK — a figura do relatório está em figuras/.\n")
