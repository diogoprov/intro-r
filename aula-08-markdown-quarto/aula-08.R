# ---------------------------------------------------------------------------
# Aula 08 — Reprodutibilidade com Markdown e Quarto
# Este script NÃO é o produto da aula: o produto é o `relatorio-modelo.qmd`.
# Aqui ficam as ferramentas que sustentam um documento reprodutível.
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# 1. O problema que o Quarto resolve
# ---------------------------------------------------------------------------
# O fluxo que a maioria aprende:
#   roda a análise -> copia o número -> cola no Word -> salva o gráfico ->
#   insere no Word -> o orientador pede para tirar os juvenis -> repete tudo
#
# Na terceira rodada, algum número do texto é de uma versão anterior da
# análise. Não há como saber qual. Esse é o bug mais comum da ciência
# quantitativa, e ele não deixa rastro.
#
# Documento dinâmico: o número no texto É o resultado do código. Mudou o
# dado, mudou o texto, sem intervenção humana.

# ---------------------------------------------------------------------------
# 2. Caminhos: a causa nº 1 de "no meu computador funciona"
# ---------------------------------------------------------------------------
# O script suplementar do artigo que usamos a semana toda começa assim:
#
#   setwd("your_path")
#
# Ou seja: não roda em lugar nenhum sem edição manual. E `setwd()` com um
# caminho de verdade é pior — roda só na máquina de quem escreveu.

# A solução tem duas partes. A primeira é o Projeto do RStudio (aula 01):
# ele define a raiz e todo caminho passa a ser relativo a ela.
list.files("dados")

# A segunda é o `here`, para quando o .qmd está numa subpasta:
library(here)
here()                                   # a raiz do projeto
here("dados", "anuros_altitude.csv")     # caminho montado a partir dela

# Por que não "dados/anuros_altitude.csv" direto? Porque ao renderizar, o
# Quarto roda o código com o diretório de trabalho na pasta do .qmd. Se o
# .qmd estiver em `relatorios/`, o caminho relativo quebra — e o `here()`
# não. Ele também resolve a barra invertida do Windows sozinho.

# ---------------------------------------------------------------------------
# 3. O ambiente: a causa nº 2
# ---------------------------------------------------------------------------
# Feche o R e reabra ANTES de renderizar a versão final. Se o documento só
# compila com objetos que ficaram no Environment de ontem, ele não é
# reprodutível — é um acaso feliz.
#
# No RStudio: Session > Restart R (Ctrl+Shift+F10). E desligue
# "Restore .RData into workspace at startup" em Tools > Global Options.

# Registre o ambiente no fim do relatório. É barato e resolve discussão:
sessionInfo()

# ---------------------------------------------------------------------------
# 4. Números no meio do texto (inline code)
# ---------------------------------------------------------------------------
library(dplyr)
anuros <- read.csv(here("dados", "processados", "anuros_limpo.csv"))

n_ind <- nrow(anuros)
n_esp <- n_distinct(anuros$especie)
ctmax_med <- round(mean(anuros$ctmax, na.rm = TRUE), 1)

# No .qmd você escreveria, no meio do parágrafo:
#
#   Analisamos `r n_ind` indivíduos de `r n_esp` espécies, com CTmax
#   médio de `r ctmax_med` °C.
#
# Resultado:
sprintf("Analisamos %d indivíduos de %d espécies, com CTmax médio de %.1f °C.",
        n_ind, n_esp, ctmax_med)

# Nunca digite 225 no texto. Digite o código que produz 225.

# ---------------------------------------------------------------------------
# 5. Tabelas prontas para publicação
# ---------------------------------------------------------------------------
library(knitr)
library(broom)

tab <- anuros %>%
  group_by(especie) %>%
  summarise(n = n(),
            `CTmin (°C)` = round(mean(ctmin, na.rm = TRUE), 2),
            `CTmax (°C)` = round(mean(ctmax, na.rm = TRUE), 2),
            .groups = "drop")

kable(tab, caption = "Limites térmicos por espécie.")

# O mesmo vale para a saída de um modelo: `tidy()` (aula 06) devolve um data
# frame, e `kable()` o transforma em tabela formatada.
lm(tol_aquec ~ altitude, data = anuros) %>%
  tidy(conf.int = TRUE) %>%
  kable(digits = 4, caption = "Tolerância ao aquecimento em função da altitude.")

# ---------------------------------------------------------------------------
# 6. Opções de chunk que você vai usar
# ---------------------------------------------------------------------------
# Escritas com `#|` na primeira linha do bloco:
#
#   #| label: fig-altitude          nome do bloco; permite referência cruzada
#   #| fig-cap: "Legenda da figura." vira a legenda numerada
#   #| echo: false                   esconde o código, mostra o resultado
#   #| message: false                esconde mensagens de pacote
#   #| warning: false                esconde avisos (use com parcimônia)
#   #| eval: false                   mostra o código sem executar
#   #| cache: true                   guarda o resultado; só refaz se mudar
#
# No texto, `@fig-altitude` vira "Figura 1" e vira link. Renumera sozinho
# quando você inserir outra figura antes.
#
# Para valer no documento inteiro, ponha no YAML:
#   execute:
#     echo: false
#     warning: false

# ---------------------------------------------------------------------------
# 7. Renderizar
# ---------------------------------------------------------------------------
# Pelo botão **Render** do RStudio, ou:
#
#   quarto render relatorio-modelo.qmd            # no terminal
#   quarto render relatorio-modelo.qmd --to pdf
#
# Do R:
#   quarto::quarto_render(here("relatorio-modelo.qmd"))
#
# O formato de saída está no YAML. `format: html` é o padrão; `format: pdf`
# exige LaTeX — se não tiver, instale com `tinytex::install_tinytex()`.

# ---------------------------------------------------------------------------
# 8. O trabalho final
# ---------------------------------------------------------------------------
# Um .qmd que, renderizado do zero numa máquina limpa, produz o HTML ou PDF
# com o fluxo completo: leitura do dado bruto, limpeza, exploração gráfica,
# modelo, diagnóstico e interpretação.
#
# Teste de aceitação, antes de entregar:
#   1. Reinicie o R (Ctrl+Shift+F10)
#   2. Apague a pasta de saída e o `_files`
#   3. Render
#   4. Se compilou sem tocar em nada, está pronto
#
# Comece pelo `relatorio-modelo.qmd`, nesta mesma pasta.
