# ---------------------------------------------------------------------------
# Aula 07 — Rudimentos de programação
# Todo exemplo aqui resolve um problema que apareceu de verdade nas aulas 04-06.
# ---------------------------------------------------------------------------
library(dplyr)
library(purrr)
library(broom)

anuros <- read.csv("dados/processados/anuros_limpo.csv") %>%
  mutate(across(c(especie, serra, sexo), factor))

# ---------------------------------------------------------------------------
# 1. Por que escrever uma função
# ---------------------------------------------------------------------------
# Na aula 04 escrevemos isto, três vezes, mudando só a coluna:
mean(anuros$ctmax, na.rm = TRUE); sd(anuros$ctmax, na.rm = TRUE)
mean(anuros$ctmin, na.rm = TRUE); sd(anuros$ctmin, na.rm = TRUE)
mean(anuros$ewl,   na.rm = TRUE); sd(anuros$ewl,   na.rm = TRUE)

# Copiar-e-colar tem um custo escondido: na terceira linha você troca a
# coluna do `mean` e esquece a do `sd`. O erro não dá mensagem nenhuma.

# ---------------------------------------------------------------------------
# 2. Anatomia de uma função
# ---------------------------------------------------------------------------
resumo <- function(x, digitos = 2) {     # nome <- function(argumentos)
  c(n    = sum(!is.na(x)),               # corpo
    na   = sum(is.na(x)),
    med  = round(mean(x, na.rm = TRUE), digitos),
    dp   = round(sd(x,   na.rm = TRUE), digitos))
}                                        # o valor da última expressão é o retorno

resumo(anuros$ctmax)
resumo(anuros$ewl, digitos = 3)   # `digitos` tem padrão; só informe se quiser mudar

# Regra prática: se você copiou e colou o mesmo trecho três vezes, escreva
# uma função. Se copiou duas, comece a desconfiar.

# ---------------------------------------------------------------------------
# 3. Escopo: o que acontece dentro, fica dentro
# ---------------------------------------------------------------------------
x <- 10
troca <- function(x) { x <- 999; x }
troca(x)   # 999
x          # continua 10 — a função recebeu uma cópia

# É por isso que uma função precisa DEVOLVER o resultado. Modificar o objeto
# "lá fora" de dentro dela é possível, mas é um jeito de criar bugs.

# ---------------------------------------------------------------------------
# 4. Controle de fluxo: if / else
# ---------------------------------------------------------------------------
classifica_altitude <- function(m) {
  if (is.na(m))     return(NA_character_)
  if (m < 500)      "baixa"
  else if (m < 1200) "média"
  else               "alta"
}
classifica_altitude(35); classifica_altitude(1022); classifica_altitude(1600)

# CUIDADO: `if` aceita UM valor só. Isto não vetoriza:
# anuros$faixa <- classifica_altitude(anuros$altitude)   # erro / só o 1º elemento
# Para a coluna inteira, use a versão vetorizada:
anuros <- anuros %>%
  mutate(faixa = case_when(altitude <  500 ~ "baixa",
                           altitude < 1200 ~ "média",
                           TRUE            ~ "alta"))
table(anuros$faixa)

# ---------------------------------------------------------------------------
# 5. for: quando você quer repetir
# ---------------------------------------------------------------------------
colunas <- c("ctmin", "ctmax", "amplitude", "tol_aquec", "ewl", "massa")

for (cc in colunas) {
  cat(sprintf("%-10s n=%3d  media=%7.2f\n",
              cc, sum(!is.na(anuros[[cc]])), mean(anuros[[cc]], na.rm = TRUE)))
}

# O erro clássico do `for`: crescer um objeto dentro do laço.
# Lento e propenso a erro:
#   res <- c(); for (cc in colunas) res <- c(res, mean(anuros[[cc]], na.rm = TRUE))
# Reserve o espaço antes:
res <- numeric(length(colunas))
names(res) <- colunas
for (i in seq_along(colunas)) res[i] <- mean(anuros[[colunas[i]]], na.rm = TRUE)
round(res, 2)

# `seq_along(x)` em vez de `1:length(x)`: quando x é vazio, `1:0` devolve
# c(1, 0) e o laço roda duas vezes com índices inválidos. `seq_along` devolve
# nada, que é o certo.

# ---------------------------------------------------------------------------
# 6. while: repetir até uma condição
# ---------------------------------------------------------------------------
# Usa-se pouco em análise de dados; aparece em simulação. Exemplo mínimo:
n <- 0; soma <- 0
while (soma < 100) { n <- n + 1; soma <- soma + n }
c(passos = n, soma = soma)
# Sempre garanta que algo dentro do laço muda a condição, senão ele não para.

# ---------------------------------------------------------------------------
# 7. A alternativa funcional: purrr::map
# ---------------------------------------------------------------------------
# O mesmo do item 5, sem laço e sem pré-alocar:
map_dbl(anuros[colunas], mean, na.rm = TRUE) %>% round(2)

# `map` devolve lista; `map_dbl`, `map_chr`, `map_int` devolvem vetor do tipo
# pedido — e dão ERRO se o resultado não for daquele tipo. Isso é uma
# vantagem: o erro aparece na hora, não três passos adiante.
map(anuros[colunas], resumo) %>% head(2)

# A fórmula `~ .x` é um atalho para função anônima de um argumento:
map_dbl(anuros[colunas], ~ sum(is.na(.x)))

# ---------------------------------------------------------------------------
# 8. O caso real: um modelo por espécie
# ---------------------------------------------------------------------------
# Na aula 06 ajustamos um modelo por serra. Agora, um por espécie — sem
# escrever lm() cinco vezes.
modelos <- anuros %>%
  filter(!is.na(tol_aquec)) %>%
  split(.$especie) %>%
  map(~ lm(tol_aquec ~ altitude, data = .x))

# Um data frame com os coeficientes de todos:
coefs <- modelos %>%
  map_dfr(tidy, conf.int = TRUE, .id = "especie") %>%
  filter(term == "altitude")
coefs

# E o ajuste de cada um:
map_dfr(modelos, glance, .id = "especie") %>%
  select(especie, r.squared, p.value, nobs)

# ---------------------------------------------------------------------------
# 9. map2 e pmap: mais de um argumento variando
# ---------------------------------------------------------------------------
map2_chr(coefs$especie, round(coefs$estimate, 5),
         ~ paste0(.x, ": ", .y, " °C/m"))

# pmap recebe uma lista (ou data frame) de argumentos:
pmap_chr(list(esp = coefs$especie,
              est = round(coefs$estimate, 5),
              p   = signif(coefs$p.value, 2)),
         function(esp, est, p) sprintf("%-24s b=%8.5f  p=%s", esp, est, p)) %>%
  cat(sep = "\n")

# ---------------------------------------------------------------------------
# 10. Quando a função precisa falhar com elegância
# ---------------------------------------------------------------------------
ajusta_seguro <- function(dados) {
  if (sum(!is.na(dados$tol_aquec)) < 10) {
    warning("menos de 10 observações — modelo não ajustado")
    return(NULL)
  }
  lm(tol_aquec ~ altitude, data = dados)
}
# Checar as premissas no começo da função ("guard clause") evita que o erro
# apareça lá adiante, disfarçado de outra coisa.

# ---------------------------------------------------------------------------
# 11. Exercício
# ---------------------------------------------------------------------------
# a) Escreva `erro_padrao(x)` que devolva sd(x)/sqrt(n), ignorando NA.
#    Aplique-a a todas as colunas de `colunas` com map_dbl.
# b) Reescreva o item 8 trocando `especie` por `serra`. Quantas linhas do
#    seu código mudaram? (Se foram mais de uma, generalize.)
# b2) Acrescente o R² de cada modelo, com glance(), à tabela do item b.
# c) O item 8 ajusta um modelo por espécie ignorando a serra. Rode
#       anuros %>% filter(!is.na(tol_aquec)) %>% count(especie, serra, altitude)
#    e repare em quantas altitudes cada espécie tem em CADA serra. Para
#    Dendropsophus minutus e Leptodactylus latrans, o ponto mais alto do
#    gradiente vem de uma serra diferente de todos os outros. O que isso
#    faz com a inclinação estimada para essas espécies?

# ---------------------------------------------------------------------------
# CONFIRA ANTES DE SEGUIR
# ---------------------------------------------------------------------------
stopifnot(
  is.function(resumo),
  length(resumo(anuros$ctmax)) == 4,
  length(modelos) == 5,                  # um modelo por espécie
  nrow(coefs) == 5,
  # a função vetorizada e o case_when concordam
  all(table(anuros$faixa) > 0)
)
cat("Aula 07 OK — suas funções rodam e o map devolveu os cinco modelos.\n")
