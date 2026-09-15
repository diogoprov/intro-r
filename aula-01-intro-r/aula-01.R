# ---------------------------------------------------------------------------
# Aula 01 — Introdução ao ambiente R
# Disciplina: Introdução à Linguagem R · PPGEC/UFMS
#
# Este é o primeiro contato com o conjunto de dados que acompanha a semana
# inteira: anuros de Mata Atlântica medidos em seis altitudes.
# Veja dados/metadados_anuros_altitude.md antes de rodar.
# ---------------------------------------------------------------------------

# ---- 1. O R como calculadora ----------------------------------------------
2 + 3
10 / 4
2^10
sqrt(144)
5 %% 2       # resto da divisão
5 %/% 2      # divisão inteira

# ---- 2. Atribuir é guardar ------------------------------------------------
a <- 1
b <- c(1, 2, 3, 4, 5)
minha.media <- mean(b)
minha.media

# ---- 3. Coerção: o R nunca reclama ----------------------------------------
c(1, 2, "três")        # vira tudo texto
c(TRUE, FALSE, 1)      # vira tudo número
class(c(1, 2, "três"))

# ---- 4. Importando os dados da disciplina ---------------------------------
# O caminho é relativo à raiz do Projeto do RStudio. Nada de setwd().
dados <- read.csv("dados/anuros_altitude.csv")

# ---- 5. Os quatro comandos que vêm sempre antes de qualquer análise -------
head(dados)        # as primeiras linhas
str(dados)         # a estrutura: o tipo de cada coluna
dim(dados)         # quantas linhas e colunas
summary(dados)     # resumo por coluna

# ---- 6. O que dá para reparar já no primeiro olhar ------------------------
names(dados)                       # unidades escondidas nos nomes das colunas
table(dados$Species)               # 5 espécies
table(dados$Sex, useNA = "ifany")  # quase metade sem sexo registrado
colSums(is.na(dados))              # onde estão os NAs

# ---- 7. Ajuda -------------------------------------------------------------
?mean
?read.csv

# ---- 8. Pacotes -----------------------------------------------------------
# install.packages("dplyr")   # uma vez só na vida da máquina — fora do script
library(dplyr)

# ---- 9. Exportando --------------------------------------------------------
# Nada a exportar hoje. Mas quando houver:
# write.csv(objeto, "dados/processados/resultado.csv", row.names = FALSE)

# ---------------------------------------------------------------------------
# CONFIRA ANTES DE SEGUIR
# ---------------------------------------------------------------------------
# Rode este bloco. Se ele passar sem erro, sua aula 01 está fechada.
stopifnot(
  exists("dados"),
  is.data.frame(dados),
  nrow(dados) == 225,
  ncol(dados) == 26,
  "CTmax" %in% names(dados)
)
cat("Aula 01 OK — o arquivo está lido e no formato esperado.\n")
