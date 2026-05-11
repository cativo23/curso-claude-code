#!/usr/bin/env bash
# Hook PreToolUse para `task-cli`.
# Bloquea cualquier `git commit` cuyo mensaje no use el scope (task-cli).
#
# Registro en .claude/settings.json:
#   { "hooks": { "PreToolUse": [{ "matcher": "Bash",
#       "hooks": [{ "type": "command",
#                   "command": "bash .claude/hooks/validar-scope-commit.sh" }] }] } }

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Solo procesa git commit
echo "$COMMAND" | grep -qE '^git[[:space:]]+commit' || exit 0

# Extrae el primer mensaje -m "..."
MSG=$(echo "$COMMAND" | grep -oP -- '-m\s+\K"[^"]+"' | head -1 | tr -d '"' || true)

if [[ -z "$MSG" ]]; then
  echo "validar-scope-commit: no encontré -m en el commit." >&2
  exit 2
fi

# Espera: type(task-cli): description
if [[ ! "$MSG" =~ ^(feat|fix|docs|refactor|test|chore)\(task-cli\):[[:space:]].+ ]]; then
  echo "validar-scope-commit: el commit debe usar scope (task-cli)." >&2
  echo "  Recibido: $MSG" >&2
  echo "  Esperado: type(task-cli): descripcion" >&2
  exit 2
fi

exit 0
