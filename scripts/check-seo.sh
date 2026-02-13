#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(dirname "$0")/.."
SITEMAP="$ROOT_DIR/sitemap.xml"
INDEX="$ROOT_DIR/index.html"

fail() {
  echo "ERRO: $1" >&2
  exit 1
}

echo "Verificando sitemap: $SITEMAP"
if [ ! -f "$SITEMAP" ]; then
  fail "sitemap.xml não encontrado"
fi

if command -v xmllint >/dev/null 2>&1; then
  xmllint --noout "$SITEMAP" || fail "sitemap.xml inválido segundo xmllint"
else
  echo "Aviso: xmllint não encontrado, pulando validação XML formal"
fi

echo "Verificando entradas <loc> do sitemap..."
mapfile -t LOCS < <(sed -n 's:.*<loc>\(.*\)</loc>.*:\1:p' "$SITEMAP")
bad=0
for u in "${LOCS[@]}"; do
  if [[ "$u" != https://* ]]; then
    echo "URL inválida em <loc>: $u"
    bad=1
  fi
done
[ $bad -eq 0 ] || fail "Uma ou mais entradas <loc> não começam com 'https://'"

echo "Verificando meta tags em $INDEX"
if [ ! -f "$INDEX" ]; then
  fail "index.html não encontrado"
fi

og_image=$(sed -n 's/.*property="og:image" content="\([^"]*\)".*/\1/p' "$INDEX" | head -n1 || true)
twitter_image=$(sed -n 's/.*property="twitter:image" content="\([^"]*\)".*/\1/p' "$INDEX" | head -n1 || true)
canonical=$(sed -n 's/.*rel="canonical" href="\([^"]*\)".*/\1/p' "$INDEX" | head -n1 || true)
og_url=$(sed -n 's/.*property="og:url" content="\([^"]*\)".*/\1/p' "$INDEX" | head -n1 || true)
twitter_url=$(sed -n 's/.*property="twitter:url" content="\([^"]*\)".*/\1/p' "$INDEX" | head -n1 || true)

[[ -n "$og_image" ]] || fail "og:image não encontrado em index.html"
[[ "$og_image" == https://* ]] || fail "og:image não contém 'https://' -> $og_image"
[[ "$og_image" == *Straiw.github.io* ]] || fail "og:image não aponta para Straiw.github.io -> $og_image"

[[ -n "$canonical" ]] || fail "canonical não encontrado em index.html"
[[ "$canonical" == https://* ]] || fail "canonical não começa com https:// -> $canonical"

for v in "$og_url" "$twitter_url"; do
  if [[ -n "$v" && "$v" != https://* ]]; then
    fail "Uma meta URL não começa com https:// -> $v"
  fi
done

echo "Verificando claim de acessibilidade no README (se existir)"
if [ -f "$ROOT_DIR/README.md" ]; then
  if grep -q 'role="contentinfo"' "$ROOT_DIR/README.md"; then
    echo "README declara requirement role=\"contentinfo\" — validando presença nos footers"
    missing=0
    # procura footers sem role
    if grep -Rnl --line-number -e '<footer[^>]*>' "$ROOT_DIR" | grep -qv 'role='; then
      echo "Aviso: existem footers sem role=\"contentinfo\""
      missing=1
    fi
    [ $missing -eq 0 ] || fail "Alguns footers não possuem role=\"contentinfo\""
  else
    echo "README não requer role=contentinfo (ou não encontrado) — pulando validação relacionada"
  fi
else
  echo "README.md não existe — pulando validação de claims"
fi

echo "Todas as checagens passaram."
exit 0
