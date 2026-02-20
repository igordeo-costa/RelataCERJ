#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────
# Descobre diretórios do projeto
# ─────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

CSV="$ROOT_DIR/data/DadosBrutos.csv"
GERADOR="$ROOT_DIR/tex/gerador.tex"
BUILD_DIR="$ROOT_DIR/build"

OUT="${OUT:-relatorio_excursoes}"

# ─────────────────────────────────────
# Verifica dependências
# ─────────────────────────────────────
command -v latexmk >/dev/null || {
  echo "Erro: latexmk não está instalado."
  exit 1
}

command -v gawk >/dev/null || {
  echo "Erro: gawk não está instalado."
  exit 1
}

# ─────────────────────────────────────
# Preparação
# ─────────────────────────────────────
mkdir -p "$BUILD_DIR"

echo "Normalizando lista de participantes..."
echo "Gerando relatório..."

# ─────────────────────────────────────
# Traps
# ─────────────────────────────────────
TMP_CSV=""
trap '
  [[ -n "${TMP_CSV:-}" && -f "$TMP_CSV" ]] && rm -f "$TMP_CSV"
  [[ -f "'"$GERADOR"'.bak" ]] && mv "'"$GERADOR"'.bak" "'"$GERADOR"'"
' EXIT

# ─────────────────────────────────────
# Força modo NÃO confidencial no LaTeX
# ─────────────────────────────────────
sed -i.bak \
  's/\\relatoriocomplexotrue/\\relatoriocomplexofalse/g;
   s/^% \\relatoriocomplexofalse/\\relatoriocomplexofalse/g;
   s/^% \\relatoriocomplexotrue/\\relatoriocomplexofalse/g' \
  "$GERADOR"

# ─────────────────────────────────────
# Compila o LaTeX (entra no diretório correto)
# ─────────────────────────────────────
latexmk -lualatex -quiet -cd "$GERADOR"

# ─────────────────────────────────────
# Move PDF para build
# ─────────────────────────────────────
PDF_SRC="$ROOT_DIR/tex/gerador.pdf"

if [[ -f "$PDF_SRC" ]]; then
  mv "$PDF_SRC" "$BUILD_DIR/$OUT.pdf"
else
  echo "Erro: PDF não foi gerado."
  exit 1
fi

# ─────────────────────────────────────
# Limpeza de auxiliares
# ─────────────────────────────────────
latexmk -C -cd "$GERADOR" 2>/dev/null || true

echo "Relatório de Excursões gerado: build/$OUT.pdf"
