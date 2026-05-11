# Claude Code — Cheatsheet

Comandos esenciales para extender Claude Code. Imprime esto o tenlo abierto en otra pestaña.

---

## 1. Skills y slash commands

```text
/help                     Ver todos los comandos disponibles
/<nombre-skill>           Invocar una skill (ej: /security-review, /lumira)
```

**Crear una skill propia:**

```bash
mkdir -p ~/.claude/skills/mi-skill
cat > ~/.claude/skills/mi-skill/SKILL.md << 'EOF'
---
name: mi-skill
description: Cuándo usar esto (el modelo lo lee para decidir)
allowed-tools: Read, Write, Bash
---
# Aquí escribes el playbook
EOF
```

Skill del proyecto en lugar de global: usa `./.claude/skills/` en vez de `~/.claude/skills/`.

---

## 2. Plugins

```text
/plugin                                    Abre menú interactivo
/plugin marketplace add <user>/<repo>      Registrar marketplace
/plugin install <plugin>@<marketplace>     Instalar
/plugin uninstall <plugin>@<marketplace>   Desinstalar
/plugin marketplace remove <marketplace>   Quitar marketplace
```

### Marketplaces recomendados

```text
anthropics/claude-plugins-official    (oficial Anthropic, incluye Superpowers desde 2026)
jeffallan/claude-skills               (fullstack-dev-skills)
```

> Nota: `obra/superpowers-marketplace` ya no es necesario — Superpowers entró al marketplace oficial en enero 2026. Si lo tienes instalado desde el viejo, puedes migrarlo.

### Plugins de Carlos (lista completa)

```text
/plugin install security-guidance@claude-plugins-official
/plugin install feature-dev@claude-plugins-official
/plugin install frontend-design@claude-plugins-official
/plugin install fullstack-dev-skills@fullstack-dev-skills
/plugin install superpowers@claude-plugins-official
```

| Plugin | Qué te da |
|---|---|
| `security-guidance` | Comando `/security-review` para auditar tu rama |
| `feature-dev` | Desarrollo guiado con 3 agentes (architect, explorer, reviewer) |
| `frontend-design` | Workflows de diseño frontend |
| `fullstack-dev-skills` | 66 skills: lenguajes, frameworks, DevOps, security |
| `superpowers` | Skills mandatorias: TDD, debugging, worktrees, code review (40k+ stars) |

---

## 3. Statusline (lumira)

```bash
npm install -g lumira
```

Activar en `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "lumira",
    "padding": 0
  }
}
```

Configurar (dentro de Claude Code):

```text
/lumira  preset balanced
/lumira  tema dracula
/lumira  icons emoji
```

Config manual: `~/.config/lumira/config.json`. Reinicia la sesión tras cambiar.

**Presets:** `full | balanced | minimal`
**Temas:** `tokyo-night | dracula | nord | ...`
**Icons:** `nerd | emoji | none`

---

## 4. Hooks (settings.json)

Ubicación: `~/.claude/settings.json` (global) o `./.claude/settings.json` (proyecto).

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/validar-bash.sh",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

### Eventos disponibles

| Evento | Cuándo |
|---|---|
| `SessionStart` | Al abrir sesión |
| `UserPromptSubmit` | Cuando envías un prompt |
| `PreToolUse` | Antes de cualquier tool |
| `PostToolUse` | Después de cualquier tool |
| `Stop` | Al terminar la respuesta |
| `SubagentStop` | Al terminar un subagente |

### Contrato del script

- Recibe JSON por stdin con info del evento + tool
- Devuelve exit code `0` (OK) o `2` (bloquear) en `PreToolUse`
- Cualquier stdout va al log de Claude Code

Doc completa: https://docs.claude.com/en/docs/claude-code/hooks

---

## 5. MCPs

```text
/mcp                              Panel interactivo (autenticar/desautenticar)
claude mcp list                   Listar MCPs configurados
claude mcp add <nombre> <cmd>     Agregar uno custom
claude mcp remove <nombre>        Quitar
```

**MCPs de claude.ai disponibles** (solo se autentican, no se instalan):

```text
Atlassian (Jira/Confluence)   Notion        Linear
HubSpot                       Intercom      Asana
Canva                         Box           Miro
monday.com                    Microsoft 365 Figma
```

Ejemplo MCP custom (n8n con bearer token):

```bash
claude mcp add n8n-mcp "npx -y supergateway --streamableHttp \
   https://n8n.tu-dominio.com/mcp-server/http \
   --header authorization:Bearer <TOKEN>"
```

---

## 6. Subagents

Ubicación: `~/.claude/agents/<nombre>.md` (global) o `./.claude/agents/<nombre>.md` (proyecto).

```yaml
---
name: mi-agente
description: Qué hace y cuándo invocarlo
tools: Read, Grep, Glob, Bash
---
# Instrucciones detalladas del agente en markdown
```

El subagente se invoca con la tool `Agent` (Claude lo decide) o tú lo nombras directamente.

---

## 7. Output styles

```text
/output-style                    Listar y elegir
/output-style <nombre>           Cambiar
/output-style default            Volver al default
```

Crear uno: `~/.claude/output-styles/<nombre>.md` con frontmatter `name` y `description`.

---

## 8. CLAUDE.md (memoria del proyecto)

**Jerarquía** (de menos a más prioridad):

```
~/.claude/CLAUDE.md          Global (todos los proyectos)
~/.claude/rules/*.md         Reglas modulares globales
./CLAUDE.md                   Del proyecto
./.claude/CLAUDE.md           Alternativa
```

Claude lee todos al arrancar sesión.

**Ejemplos típicos:**

```markdown
# Convenciones
- Conventional commits: feat(scope): description
- TDD obligatorio en services/
- No hardcodear secrets, usar .env

# Stack
- Node 24, TypeScript estricto, ESM
- PostgreSQL + Prisma
```

---

## 9. GSD (Get Shit Done) — mención

**Instalación:**

```bash
npx get-shit-done-cc@latest
```

**Happy path:**

```text
/gsd-new-project              Iniciar proyecto (cuestionario + roadmap)
/gsd-plan-phase 1             Plan detallado de la phase 1
/gsd-execute-phase 1          Ejecutar phase
/gsd-progress                 Ver dónde vas
/gsd-progress --do "fix X"    Smart router en lenguaje natural
/gsd-help                     Referencia completa
```

**Comandos útiles sueltos:**

```text
/gsd-fast "fix typo"          Tarea trivial, sin overhead
/gsd-quick                    Tarea pequeña con plan ligero
/gsd-debug "form fails"       Sesión de debug que sobrevive /clear
/gsd-spike "puedo X?"         Experimento throwaway con verdicto
```

---

## Comandos del CLI (fuera de Claude Code)

```bash
claude                                    Iniciar sesión
claude --version                          Versión instalada
claude --resume                           Reanudar última sesión
claude --continue                         Continuar la sesión activa
claude mcp list                           MCPs configurados

# Para usar Claude Code como pipe
echo "explica este código" | claude       (con stdin)
claude -p "qué hace ./script.sh"          (one-shot prompt)
```

---

## Atajos de teclado en sesión

| Atajo | Acción |
|---|---|
| `Esc` | Cancelar generación actual |
| `Ctrl+C` (2x) | Salir |
| `Shift+Tab` | Cambiar de modo (plan / normal) |
| `!<comando>` | Ejecutar shell command en el contexto |
| `/clear` | Limpiar contexto (con cuidado) |
| `/compact` | Comprimir contexto manualmente |
| `↑` / `↓` | Navegar historial de prompts |

---

## Troubleshooting rápido

| Problema | Solución |
|---|---|
| Statusline rota | `lumira` falla → revisa `~/.config/lumira/config.json` (JSON válido) |
| Plugin no aparece | `/plugin` y verifica que esté **enabled** |
| MCP "Needs authentication" | `/mcp` y dale autenticar |
| Skill custom no se invoca | Verifica `description` en frontmatter (mientras más específico, mejor) |
| Hook bloquea todo | Comenta el hook en settings.json y revisa logs en `~/.claude/` |

---

## Enlaces de referencia

```text
Docs oficiales        https://docs.claude.com/en/docs/claude-code
Hooks                 https://docs.claude.com/en/docs/claude-code/hooks
MCP spec              https://modelcontextprotocol.io
Plugins oficiales     https://github.com/anthropics/claude-plugins-official
Superpowers           https://github.com/obra/superpowers
fullstack-dev-skills  https://github.com/jeffallan/claude-skills
slides (presenter)    https://github.com/maaslalani/slides
lumira (statusline)   https://www.npmjs.com/package/lumira
```
