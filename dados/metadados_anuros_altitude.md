---
title: "Metadados — anuros_altitude.csv"
subtitle: "Conjunto de dados da disciplina"
lang: pt
---

Conjunto de dados usado como fio condutor da disciplina **Introdução à
Linguagem R** (PPGEC/UFMS). São dados reais, publicados.

## Fonte

Bovo, R.P.; Simon, M.N.; Provete, D.B.; Lyra, M.; Navas, C.A.; Andrade, D.V.
(2023). **Beyond Janzen's Hypothesis: How Amphibians That Climb Tropical
Mountains Respond to Climate Variation.** *Integrative Organismal Biology*
5(1): obad009. <https://doi.org/10.1093/iob/obad009>

Arquivo original: `RPB_data_alt.csv`, do material suplementar do artigo.
Renomeado aqui apenas para seguir as regras de nomenclatura da aula 02.
**O conteúdo não foi alterado.**

## Desenho amostral

225 indivíduos de 5 espécies de anuros, amostrados em 6 altitudes
distribuídas em 2 serras da Mata Atlântica (SP/RJ/MG).

| Altitude (m) | Serra |
|---:|---|
| 35 | Serra do Mar |
| 820 | Serra do Mar |
| 1022 | Serra do Mar |
| 1500 | Serra do Mar |
| 550 | Serra da Mantiqueira |
| 1600 | Serra da Mantiqueira |

> **Atenção:** altitude e serra estão **perfeitamente confundidas** — cada
> altitude ocorre em uma única serra. Não é possível estimar os dois efeitos
> separadamente no mesmo modelo. Por isso o artigo trata as serras em
> separado. Este é o assunto da aula 06.

## Variáveis

| Coluna | O que é | Unidade |
|---|---|---|
| `ID` | identificador do indivíduo | — |
| `Species` | espécie | — |
| `Sex` | sexo (`Male`/`Female`) | — |
| `EWL_Ugcm2s1` | taxa de perda evaporativa de água (*Evaporative Water Loss*) | µg H₂O·cm⁻²·s⁻¹ |
| `WU_Ugcm2s1` | taxa de reidratação (*Water Uptake*) | µg H₂O·cm⁻²·s⁻¹ |
| `perc_hidration_after_EWL` | % da massa corpórea inicial ao fim do ensaio de EWL | % |
| `Bodymass_g` | massa corpórea | g |
| `CTmin` | tolerância térmica mínima (*Critical Thermal Minimum*) | °C |
| `CTmax` | tolerância térmica máxima (*Critical Thermal Maximum*) | °C |
| `Tbr` | amplitude térmica — **derivada**: `CTmax - CTmin` | °C |
| `WT` | tolerância ao aquecimento — **derivada**: `CTmax - BIO_5` | °C |
| `Mountain_Range` | serra | — |
| `Altitude_m` | altitude do sítio | m |
| `Altitude_categorical` | rótulo do sítio (terras baixas / altas + serra) | — |
| `Lat`, `Lon` | coordenadas do sítio | graus decimais |
| `BIO_1` | temperatura média anual | °C |
| `BIO_2` | amplitude diurna média | °C |
| `BIO_5` | temperatura máxima do mês mais quente | °C |
| `BIO_6` | temperatura mínima do mês mais frio | °C |
| `BIO_7` | amplitude térmica anual | °C |
| `BIO_12` | precipitação anual | mm |
| `BIO_13` | precipitação do mês mais chuvoso | mm |
| `BIO_14` | precipitação do mês mais seco | mm |
| `PET_min_mes_seco` | evapotranspiração potencial, mês seco | mm |
| `PET_max_mes_umido` | evapotranspiração potencial, mês úmido | mm |

As variáveis `BIO_*` vêm do WorldClim e são **do sítio**, não do indivíduo:
repetem-se em todas as linhas da mesma altitude.

## Como CTmin e CTmax foram medidos

Rampa de aquecimento/resfriamento de 0,1 °C/min em câmara climatizada.
Registra-se a temperatura corpórea (cloacal) no momento da perda do reflexo
de endireitamento. Detalhes no Material Suplementar 2 do artigo.

## Dados faltantes

`NA` em `Sex` (107 de 225), `CTmax`, `Tbr` e `WT` (35), `perc_hidration_after_EWL`
(31), `WU_Ugcm2s1` (22) e `EWL_Ugcm2s1` (11). São ausências reais — animais que
não se recuperaram do ensaio, ou medidas não realizadas.

## Duas coisas para reparar no arquivo

1. As quebras de linha são **CRLF** (padrão Windows). O R lê sem reclamar,
   mas alguns programas mostram o arquivo como uma linha só.
2. `Tbr` e `WT` são **colunas derivadas** guardadas junto com as originais.
   Isso viola a regra de "cada variável numa coluna, cada célula um valor"?
   Não — mas guardar o que o script pode recalcular é uma escolha, e vale
   discutir na aula 02.
