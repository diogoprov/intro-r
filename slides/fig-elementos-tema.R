# Figura da aula 05: onde fica cada elemento do theme().
# Ideia de Henry Wang ("ggplot2 Theme Elements Demonstration") e de Isabella
# Benabaye ("ggplot2 Theme Elements Reference Sheet"), refeita com o gráfico
# final da aula. Rodar da raiz do projeto:
#   Rscript slides/fig-elementos-tema.R
library(ggplot2)
library(dplyr)

anuros <- read.csv("dados/anuros_altitude.csv") |>
  transmute(especie = Species, altitude = Altitude_m,
            tol_aquec = CTmax - BIO_5)

creme <- "#faf7f0"
cores_tipo <- c(element_text = "#144f64",
                element_line = "#c2701c",
                element_rect = "#5b7f3a",
                outro        = "#7a5c8e")

# ---- O gráfico, com cada elemento do tema visível -------------------------
p <- ggplot(anuros, aes(x = altitude, y = tol_aquec, colour = especie)) +
  geom_point(alpha = .65, size = 1.6, na.rm = TRUE) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, linewidth = .8,
              na.rm = TRUE) +
  labs(title = "Tolerância ao aquecimento ao longo da altitude",
       subtitle = "Cinco espécies de anuros da Mata Atlântica",
       x = "Altitude (m)", y = "Tolerância ao aquecimento (°C)",
       colour = "Espécie",
       caption = "Dados: Bovo et al. (2023)") +
  guides(colour = guide_legend(nrow = 2)) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title        = element_text(face = "bold", size = 13),
    plot.subtitle     = element_text(colour = "grey35"),
    plot.caption      = element_text(colour = "grey40", size = 8),
    plot.background   = element_rect(fill = creme, colour = "grey70"),
    panel.background  = element_rect(fill = "#efe9dc", colour = NA),
    panel.grid.major  = element_line(colour = "white", linewidth = .6),
    panel.grid.minor  = element_line(colour = "white", linewidth = .25),
    axis.line         = element_line(colour = "grey30"),
    axis.ticks        = element_line(colour = "grey30"),
    axis.title        = element_text(size = 10),
    legend.position   = "top",
    legend.title      = element_text(face = "bold", size = 9),
    legend.text       = element_text(size = 8, face = "italic"),
    legend.key        = element_rect(fill = "white", colour = NA),
    legend.background = element_rect(fill = creme, colour = NA),
    plot.margin       = margin(10, 12, 8, 10)
  )

# ---- Rótulos: nome do elemento, onde fica o texto e para onde aponta ------
# Só o nome, para caber grande no slide; a cor diz a função (element_text,
# element_line, element_rect). Coordenadas em fração da figura inteira
# (0 a 1); o gráfico ocupa a faixa x de .28 a .72.
rotulos <- tribble(
  ~codigo,             ~tipo,           ~lx,  ~ly,  ~tx,  ~ty,
  "plot.title",        "element_text",  .26,  .95,  .322, .943,
  "plot.subtitle",     "element_text",  .26,  .87,  .322, .90,
  "legend.title",      "element_text",  .26,  .79,  .318, .809,
  "axis.title.y",      "element_text",  .26,  .58,  .289, .50,
  "axis.text.y",       "element_text",  .26,  .43,  .309, .433,
  "axis.ticks",        "element_line",  .26,  .30,  .321, .29,
  "axis.line",         "element_line",  .26,  .18,  .324, .18,
  "axis.title.x",      "element_text",  .26,  .05,  .483, .086,
  "legend.key",        "element_rect",  .74,  .95,  .629, .858,
  "legend.text",       "element_text",  .74,  .87,  .713, .84,
  "legend.position",   "outro",         .74,  .79,  .63,  .78,
  "panel.grid.major",  "element_line",  .74,  .58,  .70,  .574,
  "panel.grid.minor",  "element_line",  .74,  .50,  .70,  .504,
  "panel.background",  "element_rect",  .74,  .42,  .64,  .40,
  "plot.background",   "element_rect",  .74,  .30,  .713, .30,
  "axis.text.x",       "element_text",  .74,  .17,  .682, .118,
  "plot.caption",      "element_text",  .74,  .05,  .708, .05
) |>
  mutate(hjust = ifelse(lx < .5, 1, 0))

# ---- Montagem: o gráfico no centro de uma tela em branco -------------------
fig <- ggplot() +
  annotation_custom(ggplotGrob(p), xmin = .28, xmax = .72, ymin = .02, ymax = .98) +
  geom_segment(data = rotulos,
               aes(x = lx + ifelse(hjust == 1, .005, -.005), y = ly,
                   xend = tx, yend = ty, colour = tipo),
               linewidth = .45,
               arrow = arrow(length = unit(.08, "in"), type = "closed")) +
  geom_label(data = rotulos,
             aes(x = lx, y = ly, label = codigo, hjust = hjust, colour = tipo),
             family = "mono", fontface = "bold", size = 6, fill = creme,
             linewidth = 0, label.padding = unit(.12, "lines")) +
  scale_colour_manual(values = cores_tipo, guide = "none") +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1), expand = FALSE) +
  theme_void() +
  theme(plot.background = element_rect(fill = creme, colour = NA))

ggsave("slides/img/a05-elementos-tema.png", fig,
       width = 12, height = 5.6, dpi = 200, bg = creme)
cat("ok\n")
