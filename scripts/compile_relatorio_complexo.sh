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

OUT="${OUT:-relatorio_confidencial}"

# ─────────────────────────────────────
# Verifica dependências
# ─────────────────────────────────────
command -v latexmk >/dev/null || {
  echo "Erro: latexmk não está instalado."
  exit 1
}

command -v qpdf >/dev/null || {
  echo "Erro: qpdf não está instalado (necessário para proteger o PDF)."
  exit 1
}

command -v gawk >/dev/null || {
  echo "Erro: gawk não está instalado."
  exit 1
}

# Exige senha via variável de ambiente
: "${PDF_PASSWORD:?Defina a variável de ambiente PDF_PASSWORD com a senha do PDF}"

# ─────────────────────────────────────
# Preparação
# ─────────────────────────────────────
mkdir -p "$BUILD_DIR"

echo "Normalizando lista de participantes..."

ORDENADOR="$SCRIPT_DIR/ordenar_participantes.sh"

if [[ ! -f "$ORDENADOR" ]]; then
  echo "Erro: ordenar_participantes.sh não encontrado em $ORDENADOR"
  exit 1
fi

# garante permissão
chmod +x "$ORDENADOR" 2>/dev/null || true

# Cria arquivo temporário no diretório build (que é gravável)
TMP_CSV="$BUILD_DIR/tmp_csv_relatorio.csv"

rm -f "$TMP_CSV"

if ! bash "$ORDENADOR" "$CSV" > "$TMP_CSV"; then
  echo "Erro na execução do ordenador"
  exit 1
fi

# Verifica se o arquivo temporário não está vazio
if [[ ! -s "$TMP_CSV" ]]; then
  echo "Erro: ordenador produziu arquivo vazio"
  rm -f "$TMP_CSV"
  exit 1
fi

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
# Força modo confidencial no LaTeX
# ─────────────────────────────────────
sed -i.bak \
  's/\\relatoriocomplexofalse/\\relatoriocomplexotrue/g;
   s/^% \\relatoriocomplexotrue/\\relatoriocomplexotrue/g;
   s/^% \\relatoriocomplexofalse/\\relatoriocomplexotrue/g' \
  "$GERADOR"

# ─────────────────────────────────────
# Compila o LaTeX
# ─────────────────────────────────────
#latexmk -lualatex -quiet -cd "$GERADOR"
CSV_PATH="$TMP_CSV" latexmk -lualatex -quiet -cd "$GERADOR"

PDF_SRC="$ROOT_DIR/tex/gerador.pdf"
PDF_OUT="$BUILD_DIR/$OUT.pdf"

# ─────────────────────────────────────
# Verifica geração
# ─────────────────────────────────────
if [[ ! -f "$PDF_SRC" ]]; then
  echo "Erro: PDF não foi gerado."
  exit 1
fi

mv "$PDF_SRC" "$PDF_OUT"

# ─────────────────────────────────────
# 🔐 Protege o PDF (AES-256)
# ─────────────────────────────────────
qpdf --encrypt "$PDF_PASSWORD" "$PDF_PASSWORD" 256 -- \
  "$PDF_OUT" \
  "$PDF_OUT.tmp"

mv "$PDF_OUT.tmp" "$PDF_OUT"

echo "🔒 PDF protegido com senha."

# ─────────────────────────────────────
# Limpeza completa dos auxiliares
# ─────────────────────────────────────
latexmk -C -cd "$GERADOR" 2>/dev/null || true

echo "Relatório CONFIDENCIAL gerado: build/$OUT.pdf"
echo "ATENÇÃO: Este relatório contém informações exclusivas da Diretoria Técnica!"
