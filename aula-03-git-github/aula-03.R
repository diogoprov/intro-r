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

# ---------------------------------------------------------------------------
# CONFIRA ANTES DE SEGUIR
# ---------------------------------------------------------------------------
# Esta aula não produz objeto no R — produz um repositório. Ao contrário das
# outras, ESTE bloco deve falhar na primeira vez que você rodar. Ele falha
# apontando o que ainda falta fazer.

confere <- function() {
  faltou <- character(0)
  if (!dir.exists(".git"))
    faltou <- c(faltou, "A pasta nao e um repositorio git. No RStudio: Tools > Version Control > Project Setup > Git, ou no terminal: git init")
  if (!file.exists(".gitignore"))
    faltou <- c(faltou, "Falta o .gitignore na raiz. Escreva-o ANTES do primeiro 'git add .' — depois o peso ja entrou na historia.")
  else {
    ign <- readLines(".gitignore", warn = FALSE)
    if (!any(grepl("processados", ign)))
      faltou <- c(faltou, "O .gitignore existe mas nao ignora dados/processados/. Esse arquivo o aula-04.R regenera: nao precisa versionar.")
    if (!any(grepl("Rhistory", ign)))
      faltou <- c(faltou, "O .gitignore nao ignora .Rhistory. Configuracao da sua maquina nao vai para o repositorio.")
  }
  if (!dir.exists("dados"))
    faltou <- c(faltou, "Falta a pasta dados/ com o anuros_altitude.csv (aula 01).")

  if (length(faltou)) {
    cat("\nAinda falta:\n")
    cat(paste0("  ", seq_along(faltou), ". ", faltou, collapse = "\n"), "\n\n")
    cat("Corrija e rode confere() de novo.\n")
    invisible(FALSE)
  } else {
    cat("Aula 03 OK - repositorio criado e .gitignore no lugar.\n")
    invisible(TRUE)
  }
}

confere()
