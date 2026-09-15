# ---------------------------------------------------------------------------
# Aula 02 — Curadoria de dados
# O exercício em dupla é com a "Planilha de dados FINAL v2 (1).xlsx".
# Este script é o outro lado: o mesmo tipo de problema, em dado PUBLICADO.
# ---------------------------------------------------------------------------

dados <- read.csv("dados/anuros_altitude.csv")

# ---- 1. O que este arquivo faz certo --------------------------------------
# - uma observação (indivíduo) por linha
# - uma variável por coluna
# - uma célula, um valor
# - faltantes como NA de verdade, não como "-" nem "sem dados"
colSums(is.na(dados))

# ---- 2. E o que ele faz discutível ----------------------------------------

# 2a. Unidades escondidas no NOME da coluna, não em metadados
names(dados)[grepl("EWL|WU|mass", names(dados))]
# EWL_Ugcm2s1 -> microgramas por cm2 por segundo. Quem não leu o artigo,
# não adivinha. Por isso existe o dados/metadados_anuros_altitude.md.

# 2b. Colunas DERIVADAS guardadas junto com as originais
all.equal(dados$Tbr, dados$CTmax - dados$CTmin)      # Tbr = CTmax - CTmin
all.equal(dados$WT,  dados$CTmax - dados$BIO_5)      # WT  = CTmax - BIO_5
# Funciona hoje. Se alguém editar CTmax à mão, Tbr e WT ficam errados
# em silêncio. Derivada boa é a que o script recalcula.

# 2c. Variáveis do SÍTIO repetidas em toda linha do indivíduo
aggregate(BIO_5 ~ Altitude_m, dados, function(x) c(n = length(x), sd = sd(x)))
# desvio zero: BIO_5 é do sítio, não do bicho. São duas tabelas amassadas
# numa só — e é exatamente o exemplo da Figura 1 do Hart et al. (2016).

# 2d. Redundância entre colunas
table(dados$Altitude_categorical, dados$Altitude_m)
# Altitude_categorical não traz nada que Altitude_m + Mountain_Range já não digam.

# ---- 3. O problema que só aparece fora do R -------------------------------
# As quebras de linha são CRLF (Windows). O R não liga; alguns editores
# mostram o arquivo inteiro como UMA linha. Para conferir no terminal:
#   file dados/anuros_altitude.csv

# ---- 4. E o nome do arquivo ------------------------------------------------
# O original chamava-se RPB_data_alt.csv. Iniciais de pessoa + "alt"
# abreviado + nada de projeto nem data. Renomeamos para anuros_altitude.csv
# seguindo as regras de hoje. O conteúdo é idêntico.
