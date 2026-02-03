# RelataCERJ

O **RelataCERJ** é um projeto para geração automatizada de relatórios em **LaTeX** a partir de dados estruturados em CSV, voltado para registro e consolidação de atividades do Centro Excursionista Rio de Janeiro (como excursões, eventos e outros tipos de pranchetas oficiais). O foco do projeto é produzir relatórios padronizados, reproduzíveis e visualmente consistentes, com suporte a cálculos automáticos e diferentes níveis de detalhamento.

---

## 📌 Visão geral

O projeto utiliza:

- **LuaLaTeX** para compilação do relatório  
- **Scripts Bash** para automatizar o processo de geração  
- **Arquivos `.tex` modulares**, organizados por responsabilidade  
- **Dados em CSV** como fonte única da informação  

A ideia central é: **alterou o CSV → recompilou → relatório atualizado**, sem edições manuais no documento final.

---

## 📁 Estrutura do projeto

```
RelataCERJ/
├── compile_relatorio.sh
├── compile_relatorio_complexo.sh
├── gerador.tex
├── capa.tex
├── data/
│   └── DadosBrutos.csv
├── includes/
│   ├── aesthetics.tex
│   ├── calc_duracao.tex
│   └── calc_participantes.tex
├── img/
│   └── logo.png
└── RelataCERJ.pdf
```

### Descrição dos principais arquivos

- **`gerador.tex`**  
  Arquivo principal do LaTeX. Controla a estrutura do relatório e importa os demais módulos.

- **`compile_relatorio.sh`**  
  Script para gerar o relatório padrão.

- **`compile_relatorio_complexo.sh`**  
  Script que ativa um modo mais detalhado do relatório (via flags no LaTeX). Este script gera relatórios que exibem um campo específico do CSV em que o guia insere informações confidenciais, que podem ser lidas exclusivamente pela Diretoria Técnica (ou pessoas escolhidas por ela). O PDF final gerado por este script é criptogrado e só pode ser aberto via senha, definida quando da compilação do relatório confidencial.

- **`data/DadosBrutos.csv`**  
  Base de dados do relatório. Todas as informações exibidas no PDF vêm deste arquivo.

- **`includes/`**  
  Arquivos auxiliares:
  - `aesthetics.tex`: identidade visual e ajustes de layout
  - `calc_duracao.tex`: cálculos automáticos de duração
  - `calc_participantes.tex`: contagem e consolidação de participantes

- **`img/logo.png`**  
  Logotipo utilizado no relatório.

---

## ⚙️ Requisitos

Para utilizar o projeto, é necessário:

- TeX Live (recomendado **TeX Live 2023** ou superior)
- LuaLaTeX
- Bash (Linux ou macOS)
- qpdf (para proteção do PDF, no caso do relatório confidencial)

No Debian/Ubuntu, por exemplo:

```bash
sudo apt install texlive-full
```

---

## ▶️ Como gerar o relatório

### Relatório padrão

```bash
./compile_relatorio.sh
```

### Relatório detalhado (modo complexo)

```bash
PDF_PASSWORD="insira_senha_aqui" ./compile_relatorio_complexo.sh
```

Ao final da execução, o arquivo PDF será gerado no diretório principal do projeto. No caso do relatório complexo, o pdf só poderá ser aberto pela senha definida na complicação.

---

## 🧠 Conceitos importantes

- O projeto usa **flags internas no LaTeX** para alternar entre versões do relatório.
- O CSV é tratado como fonte única de verdade.
- Cálculos de tempo e totais são feitos diretamente no LaTeX, garantindo rastreabilidade.

---

## ✏️ Customização

Alguns pontos comuns de customização:

- **Layout e identidade visual**: `includes/aesthetics.tex`
- **Novos campos ou cálculos**: criar novos arquivos em `includes/`
- **Formato dos dados**: ajustar `DadosBrutos.csv` e o parser correspondente no LaTeX

---

## 📄 Licença

Este projeto é de uso interno/institucional. Todos que forem reproduzir devem uma cerveja artesanal para o Autor do projeto.

---

## 👤 Autor

**Igor de Oliveira Costa**  
Auxiliar da Diretoria Técnica do CERJ, biênio 2026-2028.
