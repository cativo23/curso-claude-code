#!/usr/bin/env bash
# Genera ASCII art estilo "ANSI Shadow" usando figlet.
# Uso: ./banner.sh "Texto a renderizar"
#
# Requisitos:
#   - figlet (pacman -S figlet | brew install figlet | apt install figlet)
#   - La fuente ANSI Shadow descargada en ~/.figlet/ANSI_Shadow.flf
#
# Si no tienes la fuente, este script la descarga la primera vez.

set -euo pipefail

FONT_DIR="${HOME}/.figlet"
FONT_FILE="${FONT_DIR}/ANSI_Shadow.flf"
FONT_URL="https://raw.githubusercontent.com/xero/figlet-fonts/master/ANSI%20Shadow.flf"

if ! command -v figlet >/dev/null 2>&1; then
  echo "figlet no está instalado." >&2
  echo "  Arch:   sudo pacman -S figlet" >&2
  echo "  Debian: sudo apt install figlet" >&2
  echo "  macOS:  brew install figlet" >&2
  exit 1
fi

if [[ ! -f "${FONT_FILE}" ]]; then
  echo "Descargando fuente ANSI Shadow..." >&2
  mkdir -p "${FONT_DIR}"
  if ! curl -sL "${FONT_URL}" -o "${FONT_FILE}"; then
    echo "No pude descargar la fuente." >&2
    exit 1
  fi
fi

TEXT="${1:-Claude Code}"
figlet -d "${FONT_DIR}" -f ANSI_Shadow -w 200 "${TEXT}"
