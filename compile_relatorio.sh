#!/bin/bash
set -euo pipefail

# Verifica dependências
command -v latexmk >/dev/null || {
  echo "Erro: latexmk não está instalado."
  exit 1
}

# Restaura o gerador.tex ao estado padrão após rodar o script
trap 'mv gerador.tex.bak gerador.tex' EXIT

OUT="${OUT:-relatorio_excursoes}"

echo "Gerando relatório..."

# Força modo confidencial no LaTeX
sed -i.bak \
   's/\\relatoriocomplexotrue/\\relatoriocomplexofalse/g;
   s/^% \\relatoriocomplexofalse/\\relatoriocomplexofalse/g;
   s/^% \\relatoriocomplexotrue/\\relatoriocomplexofalse/g' \
   gerador.tex

# Compila o LaTeX   
latexmk -lualatex -quiet gerador.tex

# Verifica se o PDF foi gerado
if [[ -f gerador.pdf ]]; then
  mv gerador.pdf "$OUT.pdf"
else
  echo "Erro: PDF não foi gerado."
  exit 1
fi

# Remove os arquivos auxiliares
latexmk -c gerador.tex 2>/dev/null || true

echo "Relatório de Excursões gerado: relatorio_excursoes.pdf"
