# ---------------------------------------------------------------------------
# Aula 03 — Controle de versão
# Esta aula não tem análise: tem o seu projeto entrando no git.
# Os comandos abaixo rodam no TERMINAL (aba Terminal do RStudio), não no R.
# ---------------------------------------------------------------------------

# ---- O .gitignore que este projeto precisa --------------------------------
# Crie um arquivo chamado .gitignore na raiz, com:
#
#   .Rproj.user
#   .Rhistory
#   .RData
#   .DS_Store
#   dados/processados/
#   *.html
#
# Repare no que NÃO entra: dados/anuros_altitude.csv fica versionado.
# Ele é pequeno, é texto, e é o insumo do trabalho todo.

# ---- O ciclo, no terminal --------------------------------------------------
#   git init
#   git add .gitignore dados/ scripts/
#   git commit -m "Dados brutos e metadados da disciplina"
#   git remote add origin https://github.com/SEU_USUARIO/SEU_REPO.git
#   git push -u origin main

# ---- Conferindo do R, se quiser -------------------------------------------
# O painel Git do RStudio faz tudo isso com botão. Mas dá para espiar:
# system("git status")
# system("git log --oneline -5")

# ---- Exercício ------------------------------------------------------------
# Ao fim da aula, o seu projeto deve estar no GitHub com pelo menos:
#   - dados/anuros_altitude.csv
#   - dados/metadados_anuros_altitude.md
#   - o script da aula 01
# e um .gitignore que deixe de fora o que não é fonte.
