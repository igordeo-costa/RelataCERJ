# RelataCERJ

O **RelataCERJ** é um projeto para geração automatizada de relatórios em **LaTeX** a partir de dados estruturados em CSV, voltado para registro e consolidação de atividades do Centro Excursionista Rio de Janeiro (como excursões, eventos e outros tipos de pranchetas oficiais). O foco do projeto é produzir relatórios padronizados, reproduzíveis e visualmente consistentes, com suporte a cálculos automáticos e diferentes níveis de detalhamento.

---

## 📌 Visão geral

O projeto utiliza:

- **LuaLaTeX** para compilação tipográfica do relatório
- **latexmk** para automação da compilação
- **Scripts Bash** para automatizar o processo de geração
- **Arquivos `.tex` modulares**, organizados por responsabilidade
- **Dados em CSV** como fonte única da informação
- **qpdf** para criptografia do relatório confidencial

A ideia central é: **editou o CSV → executou o script → relatório atualizado**, sem edições manuais no documento final.

---

## 📁 Estrutura do projeto

```
RelataCERJ/
├── scripts/
│   ├── compile_relatorio.sh
│   └── compile_relatorio_complexo.sh
├── tex/
│   ├── gerador.tex
│   └── capa.tex
├── data/
│   └── DadosBrutos.csv
├── includes/
│   ├── aesthetics.tex
│   ├── calc_duracao.tex
│   ├── calc_participantes.tex
│   └── calc_trimestre.tex
├── img/
│   ├── logo.png
│   └── LogoRetro1939.png
├── build/              # PDFs gerados
└── README.md
```

## 🧩 Descrição dos componentes

### 🔧 scripts/

- `compile_relatorio.sh`
  Script para gerar o relatório padrão.

- `compile_relatorio_complexo.sh`
  Script que ativa um modo mais detalhado do relatório (via flags no LaTeX). Este script gera relatórios que exibem um campo específico do CSV em que o guia insere informações confidenciais, que podem ser lidas exclusivamente pela Diretoria Técnica (ou pessoas escolhidas por ela). O PDF final gerado por este script é criptogrado e só pode ser aberto via senha, definida quando da compilação do relatório confidencial.

- `ordenar_participantes.sh`
  Script para normalização da lista de participantes, garantindo a ordem alfabética.

### 📄 tex/
  - `gerador.tex`
    Arquivo principal do LaTeX. Controla a estrutura do relatório e importa os demais módulos.

  - `capa.tex`
    Script para impressão da capa do documento.

### 🗂 data/
- `data/DadosBrutos.exemplo.csv`
  Base de dados do relatório. Todas as informações exibidas no PDF vêm deste arquivo.

Para rodar os dados de exemplo, converta o nome do arquivo de exemplo:

```bash
cp data/DadosBrutos.exemplo.csv data/DadosBrutos.csv
```

### 🧠 includes/

  Arquivos auxiliares:
  - `aesthetics.tex`: identidade visual e ajustes de layout.

  Arquivos com códigos LUA para cálculos diretamente no LaTeX:
  - `calc_duracao.tex`: cálculos automáticos de duração.
  - `calc_participantes.tex`: contagem e consolidação de participantes.
  - `calc_trimestre.tex`: cálculo para o trimestre coberto pelos relatórios (impresso na capa).

### 🖼 img/
  - `logo.png` é o logotipo utilizado em cada relatório individual.
  - `LogoRetro1939.png` é o logotipo antigo usado na capa.

### 📦 build/

  Diretório de saída dos PDFs gerados pelos scripts.

---

## ⚙️ Requisitos

Para utilizar o projeto, é necessário:

- TeX Live (recomendado **TeX Live 2023** ou superior)
- LuaLaTeX
- Bash (Linux ou macOS)
- gawk (para normalização da lista de participantes)
- qpdf (para proteção do PDF, no caso do relatório confidencial)

### 🐧 Instalação (Debian/Ubuntu):

```bash
sudo apt install texlive-full latexmk gawk qpdf
```

---

## ▶️ Como gerar o relatório

### Relatório padrão

```bash
./scripts/compile_relatorio.sh
```

Saída:
```bash
build/relatorio_excursoes.pdf
```

### Relatório confidencial (modo complexo)

```bash
PDF_PASSWORD="insira_senha_aqui" ./scripts/compile_relatorio_complexo.sh
```

Saída:
```bash
build/relatorio_confidencial.pdf
```

Características:

- modo confidencial ativado
- campo sensível exibido
- PDF criptografado (AES-256)

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
## 🛠 Desenvolvimentos em curso

- Produzir uma interface gráfica em python usando `tkinter` para facilitar a produção dos relatórios por outras pessoas que não o auxiliar da Diretoria Técnica. A pasta já contém no diretório raiz o arquivo `relatacerj_gui.py`.

- Para executar:
  ```Bash
  python3 relatacerj_gui.py
  ```

## 📄 Licença

Este projeto é de uso interno/institucional. Todos que forem reproduzir devem uma cerveja artesanal para o Autor do projeto.

---

## 👤 Autor

**Igor de Oliveira Costa**

Auxiliar da Diretoria Técnica do CERJ, biênio 2026-2028.
