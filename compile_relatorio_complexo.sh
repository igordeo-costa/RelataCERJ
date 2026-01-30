#!/bin/bash
set -euo pipefail

# Verifica dependências
command -v latexmk >/dev/null || {
  echo "Erro: latexmk não está instalado."
  exit 1
}

command -v qpdf >/dev/null || {
  echo "Erro: qpdf não está instalado (necessário para proteger o PDF)."
  exit 1
}

# Exige senha via variável de ambiente
: "${PDF_PASSWORD:?Defina a variável de ambiente PDF_PASSWORD com a senha do PDF}"

# Restaura o gerador.tex ao estado padrão após rodar o script
trap 'mv gerador.tex.bak gerador.tex' EXIT

OUT="${OUT:-relatorio_confidencial}"

echo "Gerando relatório CONFIDENCIAL..."

# Força modo confidencial no LaTeX
sed -i.bak \
  's/\\relatoriocomplexofalse/\\relatoriocomplexotrue/g;
   s/^% \\relatoriocomplexotrue/\\relatoriocomplexotrue/g;
   s/^% \\relatoriocomplexofalse/\\relatoriocomplexotrue/g' \
  gerador.tex

# Compila o LaTeX
latexmk -lualatex -quiet gerador.tex

# Verifica se o PDF foi gerado
if [[ ! -f gerador.pdf ]]; then
  echo "Erro: PDF não foi gerado."
  exit 1
fi

mv gerador.pdf "$OUT.pdf"

# 🔐 Protege o PDF com senha (AES-256)
qpdf --encrypt "$PDF_PASSWORD" "$PDF_PASSWORD" 256 -- \
  "$OUT.pdf" \
  "$OUT.tmp.pdf"

mv "$OUT.tmp.pdf" "$OUT.pdf"

echo "🔒 PDF protegido com senha."

# Remove arquivos auxiliares
latexmk -c gerador.tex 2>/dev/null || true

echo "Relatório CONFIDENCIAL gerado: $OUT.pdf"
echo "ATENÇÃO: Este relatório contém informações exclusivas da Diretoria Técnica!"

