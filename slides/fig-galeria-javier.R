# Figura da galeria da aula 05, regerada a partir do Rmd original do Javier.
# Fonte: "Analisis Javier.Rmd" + javier_renacuajos.txt
library(ggplot2)

d <- read.table("javier_renacuajos.txt", header = TRUE)
d$zona <- factor(d$zona, labels = c("Zona 1", "Zona 2", "Zona 3"))

p <- ggplot(d, aes(x = estadio, y = LHC, colour = sexo)) +
  geom_point(size = 1.9, alpha = .75) +
  geom_smooth(method = "lm", formula = y ~ x, se = TRUE, linewidth = .8) +
  facet_wrap(~ zona) +
  scale_colour_manual(values = c(hembra = "#c2701c", macho = "#1c6e8c"),
                      name = NULL) +
  labs(x = "Estágio de desenvolvimento (Gosner)",
       y = "Comprimento rostro-cloacal (mm)") +
  guides(colour = guide_legend(override.aes = list(fill = NA))) +
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(colour = "#e3dccd"),
    strip.text       = element_text(face = "bold", colour = "#144f64"),
    legend.position  = "top",
    plot.background  = element_rect(fill = "#faf7f0", colour = NA),
    panel.background = element_rect(fill = "#faf7f0", colour = NA),
    legend.background = element_rect(fill = "#faf7f0", colour = NA),
    legend.key        = element_rect(fill = "#faf7f0", colour = NA)
  )

ggsave("a05-galeria-javier.png", p, width = 9, height = 3.6, dpi = 200, bg = "#faf7f0")
cat("ok\n")
