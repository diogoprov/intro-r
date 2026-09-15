---
title: "Uma versão anterior do mesmo conjunto de dados"
subtitle: "Material do exercício 2 da aula 08"
lang: pt
---

`anuros_altitude_versao-trabalho.txt` é a planilha de trabalho que circulou
entre os autores **antes** da publicação. O arquivo publicado, que usamos a
semana toda, é o `../anuros_altitude.csv`.

Ele está aqui **para o exercício da aula 08**, não para análise. Nenhum
script da disciplina o lê.

## O que muda de um para o outro

| | versão de trabalho | versão publicada |
|---|---:|---:|
| linhas | 233 | 225 |
| colunas | 17 | 26 |
| separador | tabulação | vírgula |
| nome da espécie | `Hypsiboas_faber` | `Boana faber` |

- **219 indivíduos** aparecem nos dois arquivos.
- **9 códigos** existem só na versão de trabalho.
- **4 indivíduos têm a massa corporal diferente** entre as duas versões.

Nenhuma dessas diferenças é anunciada em lugar nenhum. Só aparece se alguém
comparar — que é exatamente o exercício.

## Por que isso não é um defeito do artigo

Dado de campo é revisado: uma balança é reconferida, um indivíduo é excluído
por um motivo registrado no caderno, um código de campo é reconciliado. O
problema não é revisar — é revisar **sem deixar rastro**. Com os dois
arquivos versionados no git, `git log` responderia o que aqui exige um
script.
