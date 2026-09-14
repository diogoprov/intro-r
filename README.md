# Introdução à Linguagem R

Materiais da disciplina de pós-graduação **Introdução à Linguagem R**
(30 h, formato intensivo) do
[PPG em Ecologia e Conservação](https://ppgec.ufms.br/) da Universidade
Federal de Mato Grosso do Sul.

**Site publicado: <https://provetelab.org/intro-r/>**

Voltada a quem está chegando ao R pela primeira vez: parte da sintaxe e do
RStudio e vai até relatórios reprodutíveis, passando por manipulação de
dados, visualização, modelos lineares simples e controle de versão.

## O que há aqui

Oito aulas, cada uma em sua própria pasta, com a página da aula
(`index.qmd`), os scripts em R, os conjuntos de dados e, quando existem, os
*walkthroughs* — versões HTML comentadas do código. Os slides em PDF ficam
em `slides/`.

| Aula | Tópico |
|-----:|--------|
| 1 | Apresentação e introdução ao R |
| 2 | Curadoria de dados e boas práticas |
| 3 | Controle de versão com git e GitHub |
| 4 | Manuseio de dados com o tidyverse |
| 5 | Visualização de dados com ggplot2 |
| 6 | Análises com modelos lineares simples |
| 7 | Rudimentos de programação |
| 8 | Reprodutibilidade com Markdown e Quarto |

## Como o site é construído

Site [Quarto](https://quarto.org) publicado no GitHub Pages por GitHub
Actions (`.github/workflows/publish.yml`). **A pasta `docs/` não é
versionada** — ela é gerada a cada push. Para publicar uma alteração, basta
editar o `.qmd`, commitar e dar push.

Para trabalhar localmente:

```bash
quarto preview      # pré-visualiza com recarga automática
quarto render       # gera docs/
```

O código R é exibido mas **não executado** durante o render (os walkthroughs
trazem `eval: false`), então não é preciso ter os pacotes das aulas
instalados para construir o site.

## Origem

Estes materiais viviam em `teaching/intro-r/` no repositório do site do
laboratório ([diogoprov.github.io](https://github.com/diogoprov/diogoprov.github.io)),
de onde foram extraídos com o histórico preservado. O histórico anterior à
migração continua disponível lá.

---

[Biodiversity Synthesis Lab](https://provetelab.org/) · Diogo B. Provete ·
Instituto de Biociências, UFMS
