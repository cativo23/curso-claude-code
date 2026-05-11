#!/usr/bin/env bash
# Lanza la presentación con banners ASCII centrados dinámicamente al ancho de tu terminal.
#
# Funciona en cualquier terminal/WM porque no intenta redimensionar nada:
# mide el ancho actual con `tput cols` y agrega padding a cada banner en un .md temporal.
#
# Uso: ./present.sh [archivo.md]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILE="${1:-${SCRIPT_DIR}/presentacion.md}"

if ! command -v slides >/dev/null 2>&1; then
  echo "slides no está instalado." >&2; exit 1
fi
if [[ ! -f "${FILE}" ]]; then
  echo "No encuentro ${FILE}" >&2; exit 1
fi

COLS=$(tput cols)
TMP="/tmp/presentacion-centered-$$.md"
trap 'rm -f "$TMP"' EXIT

# Centra cada línea de los code blocks que contengan caracteres de banner ASCII.
# Detecta runas visuales correctamente (no bytes).
python3 - "$FILE" "$TMP" "$COLS" <<'PY'
import sys, unicodedata

src, dst, cols = sys.argv[1], sys.argv[2], int(sys.argv[3])

def visual_width(s):
    """Ancho visual aproximado en columnas de terminal (cuenta runas, no bytes)."""
    w = 0
    for ch in s:
        if unicodedata.category(ch).startswith("C"):
            continue
        ea = unicodedata.east_asian_width(ch)
        w += 2 if ea in ("F", "W") else 1
    return w

with open(src, encoding="utf-8") as f:
    raw = f.read()

# Separa frontmatter del contenido (las primeras `---` líneas son YAML frontmatter)
parts = raw.split("\n---\n", 2)
if raw.startswith("---\n") and len(parts) >= 2:
    # Tenemos frontmatter
    frontmatter = parts[0] + "\n---"
    body = "\n---\n".join(parts[1:]).lstrip("\n")
else:
    frontmatter = ""
    body = raw

# El body se divide por separadores de slide `\n---\n`
slides = body.split("\n---\n")

def is_separator_slide(slide_text):
    """Centramos toda slide que tenga un banner ASCII (caracteres de bloque)."""
    return "█" in slide_text

def center_lines(text, cols):
    """Centra cada línea no-vacía del texto al ancho dado."""
    out = []
    for line in text.splitlines():
        if not line.strip():
            out.append(line)
            continue
        w = visual_width(line.rstrip())
        pad = max(0, (cols - w) // 2)
        out.append(" " * pad + line.rstrip())
    return "\n".join(out)

processed = []
for slide in slides:
    if is_separator_slide(slide):
        processed.append(center_lines(slide, cols))
    else:
        processed.append(slide)

result = (frontmatter + "\n\n" if frontmatter else "") + "\n---\n".join(processed)

with open(dst, "w", encoding="utf-8") as f:
    f.write(result)
PY

exec slides "$TMP"
