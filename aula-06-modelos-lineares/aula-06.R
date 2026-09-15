# ---------------------------------------------------------------------------
# Aula 06 — Modelos lineares: do fluxo tidy à inferência
# Continua de onde a aula 04 parou: lê o arquivo limpo, ajusta, diagnostica
# e extrai os resultados em formato tidy.
# ---------------------------------------------------------------------------
library(dplyr)
library(ggplot2)
library(broom)

anuros <- read.csv("dados/processados/anuros_limpo.csv") %>%
  mutate(across(c(especie, serra, sexo), factor))

# ---------------------------------------------------------------------------
# 1. A pergunta
# ---------------------------------------------------------------------------
# A tolerância ao aquecimento (tol_aquec = CTmax - temperatura máxima do mês
# mais quente) diminui com a altitude? Ou seja: quem vive no alto tem mais
# margem térmica?

ggplot(anuros, aes(altitude, tol_aquec)) +
  geom_point(alpha = .6) +
  labs(x = "Altitude (m)", y = "Tolerância ao aquecimento (°C)")

# ---------------------------------------------------------------------------
# 2. O modelo mais simples possível
# ---------------------------------------------------------------------------
m1 <- lm(tol_aquec ~ altitude, data = anuros)
summary(m1)

# Leia o summary de trás para frente:
#   - F-statistic e R-squared: o modelo explica alguma coisa?
#   - Coefficients: qual a direção e o tamanho do efeito?
#   - o intercepto é a previsão em altitude = 0 m. Faz sentido aqui? Quase.

# ---------------------------------------------------------------------------
# 3. Diagnóstico ANTES de interpretar
# ---------------------------------------------------------------------------
par(mfrow = c(2, 2))
plot(m1)
par(mfrow = c(1, 1))

# O que cada painel responde:
#   Residuals vs Fitted  -> a relação é mesmo linear?
#   Q-Q Residuals        -> os resíduos são aproximadamente normais?
#   Scale-Location       -> a variância é constante ao longo do ajuste?
#   Residuals vs Leverage-> algum ponto sozinho está puxando a reta?

# A mesma informação, em tidy:
diag <- augment(m1)
ggplot(diag, aes(.fitted, .resid)) +
  geom_hline(yintercept = 0, linetype = 2) +
  geom_point(alpha = .6) +
  labs(x = "Valores ajustados", y = "Resíduos")

# ---------------------------------------------------------------------------
# 4. broom: o resultado como data frame
# ---------------------------------------------------------------------------
tidy(m1)       # uma linha por coeficiente
glance(m1)     # uma linha por modelo: R2, AIC, gl, p
# augment(m1)  # uma linha por observação: ajustado, resíduo, alavancagem

# Por que isso importa: `summary()` imprime na tela e acabou. `tidy()` devolve
# um data frame — que entra em ggplot, em knitr::kable, em dplyr.
tidy(m1, conf.int = TRUE) %>%
  filter(term != "(Intercept)") %>%
  ggplot(aes(estimate, term)) +
  geom_vline(xintercept = 0, linetype = 2) +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high)) +
  labs(x = "Estimativa (°C por metro)", y = NULL)

# ---------------------------------------------------------------------------
# 5. Uma preditora categórica
# ---------------------------------------------------------------------------
m2 <- lm(tol_aquec ~ especie, data = anuros)
anova(m2)
tidy(m2)

# Repare: com 5 espécies saem 4 coeficientes. O R escolheu a primeira em
# ordem alfabética como referência; cada linha é a DIFERENÇA em relação a ela.
levels(anuros$especie)
# Para mudar a referência:
# anuros$especie <- relevel(anuros$especie, ref = "Rhinella icterica")

# ---------------------------------------------------------------------------
# 6. Juntando as duas
# ---------------------------------------------------------------------------
m3 <- lm(tol_aquec ~ altitude + especie, data = anuros)
summary(m3)
anova(m1, m3)   # vale a pena a complexidade a mais?

# ---------------------------------------------------------------------------
# 7. O desenho amostral decidindo o que o modelo pode responder
# ---------------------------------------------------------------------------
# A ideia óbvia: será que o efeito da altitude é diferente nas duas serras?
# Antes de ajustar qualquer coisa, olhe o desenho amostral:
with(anuros, table(serra, altitude))

# Cada altitude aparece em UMA serra só:
#   35, 820, 1022, 1500 m -> Serra do Mar
#   550, 1600 m           -> Serra da Mantiqueira
#
# Não existe um par de sítios na MESMA altitude em serras diferentes.
# Altitude (como sítio) está ANINHADA em serra, não cruzada com ela.

# Escreva isso como modelo e o R avisa:
anuros$alt_fator <- factor(anuros$altitude, levels = sort(unique(anuros$altitude)))
m4 <- lm(tol_aquec ~ alt_fator * serra, data = anuros)

summary(m4)   # a tabela para em alt_fator1600: os termos de serra sumiram
alias(m4)     # o R mostra que cada termo de serra é combinação dos de altitude

# Isto não é erro do R nem amostra pequena. Com altitude tratada como
# identidade do sítio, nenhum dado no mundo separa "efeito de altitude" de
# "efeito de serra" — os dois rótulos descrevem exatamente a mesma partição.

# ---------------------------------------------------------------------------
# 7b. O mesmo modelo, com altitude contínua: agora ajusta. Cuidado.
# ---------------------------------------------------------------------------
m5 <- lm(tol_aquec ~ altitude * serra, data = anuros)
summary(m5)   # nenhum NA: todos os coeficientes estimados

# Por que agora funciona? Porque tratar altitude como número impõe que a
# resposta seja uma RETA em altitude dentro de cada serra. Com essa premissa,
# duas altitudes por serra já bastam para estimar duas retas, e a diferença
# entre elas vira o termo de interação.
#
# O que mudou não foi o dado — foi a premissa. E ela tem preço:
tapply(anuros$altitude, anuros$serra, range)
#   Serra da Mantiqueira:  550 – 1600 m
#   Serra do Mar        :   35 – 1500 m
#
# O coeficiente `serraSerra do Mar` é a diferença entre as serras em
# altitude = 0 m — fora da faixa amostrada em AMBAS, e a 550 m do dado mais
# baixo da Mantiqueira. É extrapolação, sustentada pela reta, não pelo dado.
# Centralizar altitude põe esse contraste dentro da faixa observada:
anuros$alt_c <- anuros$altitude - 1000
summary(lm(tol_aquec ~ alt_c * serra, data = anuros))

# Compare os dois summaries. R², resíduos e graus de liberdade são IDÊNTICOS:
# é o mesmo ajuste. Mas o coeficiente de serra passou de -1,64 (p = 0,13) para
# +1,09 (p = 0,02) — mudou de sinal e de conclusão. Nenhum dos dois está
# "errado": eles respondem a perguntas diferentes ("a 0 m" e "a 1000 m"), e só
# o segundo cai dentro da faixa amostrada. Coeficiente sem a pergunta junto
# não significa nada.

# É por isso que o artigo original analisa as duas serras SEPARADAMENTE:
# evita apoiar a comparação entre serras numa premissa de linearidade que
# o desenho amostral não permite testar.

# ---------------------------------------------------------------------------
# 8. O que dá para fazer: um modelo por serra
# ---------------------------------------------------------------------------
por_serra <- anuros %>%
  filter(!is.na(tol_aquec)) %>%
  group_by(serra) %>%
  group_modify(~ tidy(lm(tol_aquec ~ altitude, data = .x), conf.int = TRUE)) %>%
  ungroup() %>%
  filter(term == "altitude")

por_serra

# Note que a Serra da Mantiqueira tem só duas altitudes (550 e 1600 m): a
# "reta" ali liga dois pontos. O modelo roda; a inferência é fraca. Saber a
# diferença entre as duas coisas é metade da disciplina.

# ---------------------------------------------------------------------------
# 9. Uma segunda opinião sobre as premissas: o pacote performance
# ---------------------------------------------------------------------------
# Instale uma vez:  install.packages("performance")
# Os quatro gráficos do item 3 pedem que VOCÊ julgue olhando. O `performance`
# faz o teste e devolve um veredito escrito. As duas coisas se completam.
library(performance)

check_normality(m3)          # Shapiro-Wilk nos resíduos
check_heteroscedasticity(m3) # Breusch-Pagan
check_collinearity(m3)       # VIF, para modelos com mais de uma preditora
r2(m3)

# No nosso modelo os dois primeiros DISCORDAM: a normalidade passa, a
# homocedasticidade não. Antes de consertar qualquer coisa, pense:
#
#   a) O que exatamente foi violado, e quanto? Um p pequeno com n = 190
#      detecta um desvio que talvez não importe. Olhe o Scale-Location do
#      item 3 e decida se o que você vê é grave.
#   b) Heterocedasticidade não enviesa os coeficientes — ela estraga os
#      erros-padrão, e portanto os p e os intervalos de confiança.
#   c) Este modelo junta cinco espécies que diferem em tamanho por duas
#      ordens de grandeza. É de espantar que a variância seja constante?
#
# Um teste não decide por você. Ele te obriga a ter um argumento.

# Se tiver o pacote `see` instalado, o painel completo sai em um comando:
# check_model(m3)

# ---------------------------------------------------------------------------
# 10. Exercício
# ---------------------------------------------------------------------------
# a) Refaça o item 2 usando `ctmax` como resposta em vez de `tol_aquec`.
#    O sinal do coeficiente muda? Por quê? (Dica: tol_aquec = ctmax - bio5,
#    e bio5 cai com a altitude.)
# b) Ajuste `ewl ~ massa` e olhe o diagnóstico. A relação precisa de
#    transformação? Teste `log(ewl) ~ log(massa)`.
# c) Quantas observações cada modelo acima usou de fato? Compare
#    `nobs(m1)` com `nrow(anuros)` e explique a diferença.

# ---------------------------------------------------------------------------
# CONFIRA ANTES DE SEGUIR
# ---------------------------------------------------------------------------
stopifnot(
  inherits(m1, "lm"),
  nobs(m1) == 190,                       # 225 menos os 35 sem CTmax
  # o modelo com altitude como FATOR não é estimável: sobram coeficientes NA
  any(is.na(coef(m4))),
  # o modelo com altitude contínua é estimável: nenhum NA
  !any(is.na(coef(m5))),
  nrow(por_serra) == 2
)
cat("Aula 06 OK — e você viu o mesmo dado aceitar um modelo e recusar outro.\n")
