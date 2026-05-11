---
theme: tokyo-night
author: Carlos Cativo
date: 2026-05-11
paging: Slide %d / %d
---

```
 ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗     ██████╗ ██████╗ ██████╗ ███████╗
██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝    ██╔════╝██╔═══██╗██╔══██╗██╔════╝
██║     ██║     ███████║██║   ██║██║  ██║█████╗      ██║     ██║   ██║██║  ██║█████╗
██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝      ██║     ██║   ██║██║  ██║██╔══╝
╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗    ╚██████╗╚██████╔╝██████╔╝███████╗
 ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝

                    Mini-curso: del chat al stack completo
```

# Claude Code — Más allá del chat

**Por:** Carlos Cativo
**Duración:** ~60 min
**Audiencia:** devs que ya usan Claude Code

Hoy vamos a ver **6 capas de extensibilidad** que casi nadie usa.

> Si solo escribes prompts en el chat, estás dejando el 80% del valor en la mesa.

---

# Agenda

```
  BASE
  1.  Mapa mental: las 6 capas         ( 5 min)
  2.  Skills y slash commands          ( 8 min)
  3.  Plugins y marketplaces           ( 8 min)
  4.  Statuslines (lumira)             ( 8 min)
  5.  Hooks: automatización real       ( 8 min)
  6.  MCPs y subagents                 ( 8 min)
  7.  Bonus: output styles + CLAUDE.md ( 3 min)

  AVANZADO
  8.  Power-user tips                  ( 5 min)
  9.  Case study real                  ( 4 min)
 10.  Build-your-own: skill+agent+hook ( 5 min)
 11.  Ejercicio para casa + Q&A        ( 3 min)
```

Al final: cheatsheet + un reto para que apliquen lo aprendido.

---

# El mapa mental

Claude Code se extiende en **6 capas**. Cada una resuelve un problema distinto.

```
   más simple
   ─────────────────────────────────────────────────────
   1.  Skills y slash commands     atajos + "playbooks"
   2.  Plugins                     packs de skills/agentes/hooks
   3.  Statuslines                 HUD con info en vivo
   4.  Hooks                       automatización en eventos
   5.  MCPs                        conectar a servicios externos
   6.  Subagents                   delegar a Claudes paralelos
   ─────────────────────────────────────────────────────
   más avanzado
```

**Mensaje clave** — no tienes que aprender todo a la vez.
**Sube de capa cuando te duela** el problema que resuelve.

---

```
███████╗██╗  ██╗██╗██╗     ██╗     ███████╗
██╔════╝██║ ██╔╝██║██║     ██║     ██╔════╝
███████╗█████╔╝ ██║██║     ██║     ███████╗
╚════██║██╔═██╗ ██║██║     ██║     ╚════██║
███████║██║  ██╗██║███████╗███████╗███████║
╚══════╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚══════╝
```

**Capa 1** — Tus primeros superpoderes: comandos y skills.

---

# Capa 1: Slash commands y skills

Un **slash command** es un atajo: `/security-review`, `/init`, `/lumira`.

Una **skill** es la "receta" detrás del comando. Le dice a Claude:

- Qué archivos leer
- Qué herramientas puede usar
- Cómo estructurar la respuesta

```
~/.claude/skills/lumira/SKILL.md     <- una skill global tuya
./.claude/skills/mi-skill/SKILL.md    <- una skill del proyecto
```

Las skills se invocan **con `/<nombre>`** o el modelo las llama automáticamente cuando detecta que aplican (mira la `description` en el frontmatter).

---

# Skills: ¿de dónde salen?

Tres fuentes posibles:

| Origen | Ubicación | Ejemplo |
|---|---|---|
| Built-in (Anthropic) | dentro del binario | `/init`, `/review` |
| Plugins instalados | `~/.claude/plugins/...` | `/security-review` |
| Tuyas/del equipo | `~/.claude/skills/` o `./.claude/skills/` | `/lumira`, `/mi-comando` |

**Para hacer una skill propia** solo necesitas un archivo:

```
~/.claude/skills/mi-skill/SKILL.md
```

Con frontmatter:

    ---
    name: mi-skill
    description: Cuándo usar esto (el modelo lee esto para decidir)
    allowed-tools: Read, Write, Bash
    ---
    # Aquí escribes el "playbook" en markdown

---

```
██████╗ ██╗     ██╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗
██╔══██╗██║     ██║   ██║██╔════╝ ██║████╗  ██║██╔════╝
██████╔╝██║     ██║   ██║██║  ███╗██║██╔██╗ ██║███████╗
██╔═══╝ ██║     ██║   ██║██║   ██║██║██║╚██╗██║╚════██║
██║     ███████╗╚██████╔╝╚██████╔╝██║██║ ╚████║███████║
╚═╝     ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝
```

**Capa 2** — Skills + agentes + hooks empaquetados desde un marketplace.

---

# Capa 2: Plugins y marketplaces

Un **plugin** = paquete de skills + agentes + hooks + comandos, todo junto.

Se instala desde un **marketplace** (un repo de GitHub que lista plugins).

**Flujo en dos pasos:**

```
1) Agregar un marketplace al sistema
   /plugin marketplace add <usuario>/<repo>

2) Instalar plugins desde ese marketplace
   /plugin install <nombre>@<marketplace>
```

**Para ver lo instalado:**

```
/plugin
```

Te abre un menú interactivo para activar, desactivar, actualizar o quitar.

---

# Plugins y workflows en mi setup

Estos son los plugins (+ GSD que es un workflow externo) que tengo instalados:

| # | Nombre | Tipo | Fuente |
|---|---|---|---|
| 1 | `security-guidance` | Plugin | claude-plugins-official |
| 2 | `feature-dev` | Plugin | claude-plugins-official |
| 3 | `frontend-design` | Plugin | claude-plugins-official |
| 4 | `fullstack-dev-skills` | Plugin | jeffallan/claude-skills |
| 5 | `superpowers` | Plugin | claude-plugins-official* |
| 6 | `GSD` | Workflow externo | gsd-build/get-shit-done |

*Superpowers entró al marketplace **oficial** en enero 2026. Antes había que instalarlo desde el marketplace de obra.

---

# Qué hace cada uno

### 1. `security-guidance` (oficial)
Guías de auditoría. Trae `/security-review` que analiza tu rama buscando vulnerabilidades.

### 2. `feature-dev` (oficial)
Desarrollo guiado de features con 3 agentes: `code-architect`, `code-explorer`, `code-reviewer`.

### 3. `frontend-design` (oficial)
Plantillas y workflows para diseño frontend (componentes, design contracts, mockups).

### 4. `fullstack-dev-skills` (jeffallan, v0.4.14)
**66 skills** para full-stack: 12 lenguajes, 10 backend frameworks, 6 frontend/mobile + infra/DevOps/security.

### 5. `superpowers` (oficial desde 2026)
Framework de skills MANDATORIAS: TDD (Red→Green→Refactor), debugging sistemático, worktrees, code review. **40k+ estrellas** — el más usado.

### 6. `GSD` (Get Shit Done)
Sistema de planificación spec-driven para PROYECTOS: phases, roadmap, requirements persistentes en `.planning/`. **31k+ estrellas**.

---

# Comandos exactos de instalación

**Plugins (desde Claude Code):**

```text
# 1) Marketplaces (una sola vez)
/plugin marketplace add anthropics/claude-plugins-official
/plugin marketplace add jeffallan/claude-skills

# 2) Instalar plugins
/plugin install security-guidance@claude-plugins-official
/plugin install feature-dev@claude-plugins-official
/plugin install frontend-design@claude-plugins-official
/plugin install fullstack-dev-skills@fullstack-dev-skills
/plugin install superpowers@claude-plugins-official
```

**GSD (instalación distinta — desde la terminal):**

```bash
npx get-shit-done-cc@latest
```

GSD registra skills + hooks + agentes directamente en `~/.claude/`. No usa el sistema de marketplaces. Para actualizarlo: vuelve a correr el `npx` o desde Claude Code: `/gsd-update`.

---

# Superpowers vs GSD — workflows que se complementan

Los dos son frameworks de workflow. Atacan **capas distintas** del problema:

| Dimensión | Superpowers | GSD |
|---|---|---|
| Foco | Cómo Claude trabaja DENTRO de una tarea | Cómo organizar el PROYECTO completo |
| Tipo | Skills mandatorias + métodos | Sistema de planning + artifacts persistentes |
| Artifacts | Skills en `.claude/skills/` | `.planning/PROJECT.md`, `ROADMAP.md`, phases |
| Persistencia | Por feature (usa git worktrees) | Cross-session vía `.planning/` |
| Brilla en | TDD, debugging, code review de UN feature | Roadmap multi-fase con varios milestones |
| Comando típico | `/brainstorm`, `/plan`, skills auto-load | `/gsd-new-project`, `/gsd-execute-phase 3` |
| Stars (2026) | 40k+ | 31k+ |

**No compiten — se complementan.** GSD para planear el proyecto, Superpowers para ejecutar cada feature con disciplina (TDD, worktrees, code review).

---

```
██╗     ██╗   ██╗███╗   ███╗██╗██████╗  █████╗
██║     ██║   ██║████╗ ████║██║██╔══██╗██╔══██╗
██║     ██║   ██║██╔████╔██║██║██████╔╝███████║
██║     ██║   ██║██║╚██╔╝██║██║██╔══██╗██╔══██║
███████╗╚██████╔╝██║ ╚═╝ ██║██║██║  ██║██║  ██║
╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝
```

**Capa 3** — Statuslines: HUD con info en vivo de la sesión.

---

# Capa 3: Statuslines

La **statusline** es la línea de info en la parte inferior del CLI.

Por defecto Claude Code muestra algo básico. Una statusline custom te da:

- Modelo, tokens, costo, cache hit rate
- Branch de git, archivos modificados
- Contexto disponible (warnings antes de llenarse)
- MCP servers conectados, agentes activos

Se configura en `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "lumira",
    "padding": 0
  }
}
```

---

# Lumira — la statusline que hice

`lumira` es la statusline que mantengo yo. Es un binario Node que lee el estado de la sesión y dibuja un HUD configurable.

**Instalación:**

```bash
npm install -g lumira
```

**Configuración (dos formas):**

```text
# A) Comando interactivo dentro de Claude Code
/lumira  cambiar a preset balanceado
/lumira  tema dracula con icons nerd

# B) Editando ~/.config/lumira/config.json directamente
```

Después de cambiar config, **reinicia la sesión** de Claude Code.

---

# Lumira — mi config actual

```json
{
  "preset": "full",
  "icons": "nerd",
  "theme": "tokyo-night",
  "style": "classic",
  "gsd": true,
  "display": {
    "cacheMetrics": true,
    "contextWarningThreshold": 60,
    "contextCriticalThreshold": 80
  }
}
```

**Presets disponibles:** `full`, `balanced`, `minimal`
**Temas:** `tokyo-night`, `dracula`, `nord`, y más
**Icons:** `nerd` (requiere Nerd Font), `emoji`, `none`

Si usas el preset `full` con Nerd Font, vas a tener el HUD completo.

---

```
██╗  ██╗ ██████╗  ██████╗ ██╗  ██╗███████╗
██║  ██║██╔═══██╗██╔═══██╗██║ ██╔╝██╔════╝
███████║██║   ██║██║   ██║█████╔╝ ███████╗
██╔══██║██║   ██║██║   ██║██╔═██╗ ╚════██║
██║  ██║╚██████╔╝╚██████╔╝██║  ██╗███████║
╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝
```

**Capa 4** — Automatización en eventos. El verdadero superpoder.

---

# Capa 4: Hooks — el verdadero superpoder

Un **hook** = un comando shell que Claude Code dispara automáticamente en ciertos eventos.

```
SessionStart    al abrir sesión
PreToolUse      antes de Write/Edit/Bash/Read/etc.
PostToolUse     después
Stop            cuando termina una respuesta
```

**¿Para qué sirven?**

- Validar commits antes de hacerlos
- Bloquear escrituras a archivos prohibidos
- Inyectar contexto automáticamente al abrir sesión
- Loggear, auditar, escanear secretos
- Disparar tests, linters, formateadores

Es la diferencia entre "Claude Code es una IDE" y "Claude Code es un teammate disciplinado".

---

# Hooks — ejemplo real (de mi setup)

Mi `~/.claude/settings.json` tiene 7 hooks de GSD. Uno muestra el patrón:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/gsd-validate-commit.sh",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

**Qué hace:** cuando Claude va a correr cualquier comando `bash`, primero corre `gsd-validate-commit.sh`. Si el script falla, **bloquea el comando**.

Lo usas para validar mensajes de commit, bloquear `rm -rf`, prevenir `git push --force`, etc.

---

# Hooks — eventos completos

| Evento | Cuándo dispara | Casos de uso |
|---|---|---|
| `SessionStart` | Al abrir Claude Code | Cargar contexto, mostrar banner |
| `UserPromptSubmit` | Cuando envías un prompt | Inyectar reglas, redactar secretos |
| `PreToolUse` | Antes de cada tool | Validar, bloquear, redirigir |
| `PostToolUse` | Después de cada tool | Loggear, escanear, formatear |
| `Stop` | Cuando termina la respuesta | Notificar, commitear, deploy |
| `SubagentStop` | Cuando termina un subagente | Tracking de tiempos |

Cada hook puede tener un `matcher` (regex) para aplicar solo a tools específicos.

**Doc oficial:** `https://docs.claude.com/en/docs/claude-code/hooks`

---

```
███╗   ███╗ ██████╗██████╗ ███████╗
████╗ ████║██╔════╝██╔══██╗██╔════╝
██╔████╔██║██║     ██████╔╝███████╗
██║╚██╔╝██║██║     ██╔═══╝ ╚════██║
██║ ╚═╝ ██║╚██████╗██║     ███████║
╚═╝     ╚═╝ ╚═════╝╚═╝     ╚══════╝
```

**Capa 5** — Conectar Claude Code a servicios externos.

---

# Capa 5: MCPs (Model Context Protocol)

Un **MCP** = servidor que le da a Claude Code acceso a un servicio externo (Notion, Linear, Atlassian, n8n, etc.).

**Sin MCP:** "Lee este issue de Jira" no funciona, Claude no tiene acceso.

**Con MCP:** Claude puede leer issues, crearlos, comentar, transicionar estados, etc.

**MCPs que tengo conectados ahora:**

```text
claude.ai Atlassian    OK (Jira + Confluence)
claude.ai n8n          OK (workflows)
claude.ai Notion       pendiente de auth
claude.ai Linear       pendiente de auth
claude.ai monday.com   pendiente de auth
```

---

# MCPs — cómo instalar y autenticar

**Opción A: MCPs de claude.ai (más fácil)**

Van administrados desde claude.ai. Solo necesitas autenticar.

```text
/mcp                <- abre el panel de MCPs
                     selecciona el servicio y dale "Authenticate"
```

**Opción B: MCP por CLI (servers custom)**

```bash
claude mcp add <nombre> <url-o-comando>
claude mcp list
claude mcp remove <nombre>
```

**Ejemplo real (el que tengo para n8n):**

```bash
claude mcp add n8n-mcp "npx -y supergateway --streamableHttp \
   https://n8n.tu-dominio.com/mcp-server/http \
   --header authorization:Bearer <token>"
```

---

```
 █████╗  ██████╗ ███████╗███╗   ██╗████████╗███████╗
██╔══██╗██╔════╝ ██╔════╝████╗  ██║╚══██╔══╝██╔════╝
███████║██║  ███╗█████╗  ██╔██╗ ██║   ██║   ███████╗
██╔══██║██║   ██║██╔══╝  ██║╚██╗██║   ██║   ╚════██║
██║  ██║╚██████╔╝███████╗██║ ╚████║   ██║   ███████║
╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝
```

**Capa 6** — Delegar trabajo a Claudes paralelos.

---

# Capa 6: Subagents

Un **subagent** = un Claude separado, con sus propias instrucciones y tools, que puedes invocar desde el principal.

**¿Para qué?**

- Tareas independientes que se pueden paralelizar
- Investigaciones largas (no contaminar el contexto principal)
- Especialistas (code-reviewer, code-architect, etc.)

**¿Dónde viven?**

```
~/.claude/agents/<nombre>.md     global
./.claude/agents/<nombre>.md     del proyecto
```

**Plantilla mínima:**

    ---
    name: mi-agente
    description: Qué hace este agente (el modelo lo lee para decidir cuándo invocarlo)
    tools: Read, Grep, Glob, Bash
    ---
    # Instrucciones del agente en markdown

---

```
██████╗  ██████╗ ███╗   ██╗██╗   ██╗███████╗
██╔══██╗██╔═══██╗████╗  ██║██║   ██║██╔════╝
██████╔╝██║   ██║██╔██╗ ██║██║   ██║███████╗
██╔══██╗██║   ██║██║╚██╗██║██║   ██║╚════██║
██████╔╝╚██████╔╝██║ ╚████║╚██████╔╝███████║
╚═════╝  ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
```

**Bonus** — Output styles, CLAUDE.md y reglas.

---

# Bonus: Output styles

Un **output style** cambia el "tono y formato" con el que Claude responde.

Vive en `~/.claude/output-styles/<nombre>.md`. Ejemplo: yo tengo `jarvis.md`.

Se cambia con:

```text
/output-style jarvis
/output-style default
```

Bueno para:
- Modo "explicación didáctica" cuando estás aprendiendo
- Modo "respuestas ultra-cortas" cuando vas con prisa
- Personas/tonos custom

---

# Bonus: CLAUDE.md y reglas

`CLAUDE.md` es el archivo de **memoria persistente** del proyecto.

**Jerarquía (de menos a más prioridad):**

```
~/.claude/CLAUDE.md           <- global (todos tus proyectos)
~/.claude/rules/*.md          <- reglas modulares globales
./CLAUDE.md                    <- del proyecto
./.claude/CLAUDE.md            <- alternativa
```

Claude **lee todos** al arrancar sesión.

**Casos típicos:**

- Convenciones de commits ("usa conventional commits")
- Patrones del proyecto ("usa hooks, no clases")
- Reglas de seguridad ("nunca commits con secrets")
- Metodologías ("sigue TDD: Red → Green → Refactor")

Lo que metas aquí, **Claude lo respeta sin que se lo recuerdes**.

---

```
██████╗ ██████╗  ██████╗     ████████╗██╗██████╗ ███████╗
██╔══██╗██╔══██╗██╔═══██╗    ╚══██╔══╝██║██╔══██╗██╔════╝
██████╔╝██████╔╝██║   ██║       ██║   ██║██████╔╝███████╗
██╔═══╝ ██╔══██╗██║   ██║       ██║   ██║██╔═══╝ ╚════██║
██║     ██║  ██║╚██████╔╝       ██║   ██║██║     ███████║
╚═╝     ╚═╝  ╚═╝ ╚═════╝        ╚═╝   ╚═╝╚═╝     ╚══════╝
```

**Sección avanzada** — Atajos, case study y customización propia.

---

# Power-user tips — atajos que casi nadie usa

| Atajo / técnica | Para qué |
|---|---|
| `Shift+Tab` | **Plan mode**: Claude planifica sin tocar archivos |
| `!ls -la` | Ejecuta shell y mete el output al contexto (sin chat) |
| `@ruta/al/archivo` | Referencia explícita a un archivo |
| `Esc` | Cancela la generación actual |
| `$ARGUMENTS` en tu skill | Recibe los args del usuario en el slash command |
| `/clear` vs `/compact` | Borrar contexto vs comprimirlo (compact preserva más) |
| `claude --resume` | Reanudar la última sesión desde la terminal |
| `claude -p "<prompt>"` | One-shot: corre y devuelve, sin sesión interactiva |
| Cache TTL = 5 min | Pausas largas tiran el cache → cobran más tokens |

**Truco favorito**: `Shift+Tab` antes de cualquier cambio grande. Te ahorras 80% de los "deshaz eso".

---

# Case study: bug fix end-to-end

Imagina: te llega TICKET-123 en Jira. Flujo completo sin salir de Claude Code:

```text
1) "Lee el ticket TICKET-123 y resume qué hay que arreglar"
   ↳ Atlassian MCP trae el contenido del ticket

2) /gsd-debug "el login falla cuando el password tiene caracteres unicode"
   ↳ GSD abre una sesión de debug persistente

3) Claude investiga, propone hipótesis, escribe test que reproduce el bug
   ↳ Red → confirma que el test falla

4) Aplica el fix mínimo
   ↳ Green → test pasa

5) Hook PreToolUse de conventional commits valida el mensaje
   ↳ "fix(auth): handle unicode chars in password validator"

6) /gsd-ship
   ↳ Push + PR con summary + link al ticket
```

**El punto**: cada herramienta sola es útil. Combinadas, te ahorran horas.

---

# Build-your-own #1: tu propia skill

Una skill que te liste los PRs abiertos del repo actual:

```bash
mkdir -p ~/.claude/skills/mis-prs
```

`~/.claude/skills/mis-prs/SKILL.md`:

    ---
    name: mis-prs
    description: Lista los PRs abiertos del repo actual usando gh CLI. Úsalo cuando el usuario pida "mis PRs", "PRs abiertos" o similar.
    allowed-tools: Bash
    ---

    # /mis-prs

    Ejecuta `gh pr list --state open --json number,title,author,createdAt`
    y formatea como tabla legible.

    Si el usuario pasa argumentos en `$ARGUMENTS`, úsalos como filtro
    (por ej. `/mis-prs cativo23` filtra por autor).

**Después**: reinicia sesión y escribe `/mis-prs`. Listo, ya tienes un comando custom.

---

# Build-your-own #2: tu propio subagent

Un subagent especialista en revisar markdown:

`~/.claude/agents/md-reviewer.md`:

    ---
    name: md-reviewer
    description: Revisa archivos markdown: typos, links rotos, headers, formato. Úsalo al editar README o docs.
    tools: Read, Grep, Glob, Bash
    ---

    # Markdown reviewer

    Lee los `.md` que te pasen y reporta:
      1. Typos (por contexto)
      2. Links a archivos que no existen
      3. Headers que rompen jerarquía
      4. Code blocks sin lenguaje declarado

    Lista numerada. No edites, solo reporta.

Claude lo invoca solo al editar markdown, o lo llamas:
"usa el agente md-reviewer en ./README.md"

---

# Build-your-own #3: tu propio hook

Hook que valida **conventional commits** antes de cualquier `git commit`:

`~/.claude/hooks/validar-commit.sh`:

```bash
#!/usr/bin/env bash
# Lee JSON del evento por stdin
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Solo nos interesa si es un git commit
echo "$COMMAND" | grep -qE '^git commit' || exit 0

# Extrae el -m "..."
MSG=$(echo "$COMMAND" | grep -oP -- '-m\s+\K"[^"]+"' | tr -d '"')

# Valida formato: type(scope): description
if [[ ! "$MSG" =~ ^(feat|fix|docs|refactor|test|chore)(\(.+\))?:\ .+ ]]; then
  echo "Commit no sigue conventional commits: $MSG" >&2
  exit 2   # exit 2 bloquea la tool
fi
exit 0
```

Lo registras en `~/.claude/settings.json` bajo `hooks.PreToolUse` con `"matcher": "Bash"`.

---

# Ejercicio para casa

Para sentir el flujo, escojan **una** de estas y pruébenla esta semana:

```
  [ ] Crear una skill propia (algo que repitan a diario)
        ej: /resumir-pr, /comparar-branches, /tareas-de-hoy

  [ ] Crear un hook que les ahorre un error frecuente
        ej: bloquear push --force, validar mensajes de commit,
        prevenir edits en archivos de config sensibles

  [ ] Instalar un plugin nuevo y usarlo en algo real
        ej: superpowers para TDD, fullstack-dev-skills para
        skills de su stack, security-guidance antes de un PR
```

**Reto**: el viernes en el daily, cada quien comparte qué hizo
y qué tan útil le resultó.

Si se atoran: el cheatsheet tiene todos los comandos. Y me preguntan.

---

# Recursos para profundizar

```text
Documentación oficial
  https://docs.claude.com/en/docs/claude-code

Marketplace oficial de plugins
  https://github.com/anthropics/claude-plugins-official

Superpowers (obra/Jesse Vincent)
  https://github.com/obra/superpowers
  /plugin install superpowers@claude-plugins-official

GSD (Get Shit Done)
  https://github.com/gsd-build/get-shit-done
  npx get-shit-done-cc@latest

Fullstack-dev-skills (jeffallan)
  https://github.com/jeffallan/claude-skills

Lumira (mi statusline)
  https://www.npmjs.com/package/lumira
```

---

# Recap — qué te llevas

```
Capa             Comando estrella                    Cuándo subir
─────────────────────────────────────────────────────────────────
1. Skills        /<nombre>                           desde día 1
2. Plugins       /plugin install <p>@<m>             segunda semana
   + GSD         npx get-shit-done-cc@latest         proyectos grandes
   + Superpowers /plugin install superpowers@        TDD/debug serio
                   claude-plugins-official
3. Statusline    /lumira                             cuando duela
4. Hooks         editar settings.json                cuando repitas algo
5. MCPs          /mcp                                cuando necesites datos
6. Subagents     definir en agents/                  para paralelizar

Bonus
  - Output styles      /output-style
  - CLAUDE.md          escribir reglas en md
```

**Regla de oro**: no adoptes todo a la vez. Cada capa cuando te duela el problema que resuelve.

---

# Q&A

```
 ██████╗        ██╗        █████╗
██╔═══██╗       ██║       ██╔══██╗
██║   ██║    ████████╗    ███████║
██║▄▄ ██║    ██╔═██╔═╝    ██╔══██║
╚██████╔╝    ██████║      ██║  ██║
 ╚══▀▀═╝     ╚═════╝      ╚═╝  ╚═╝
```

**Preguntas, comentarios, requests.**

Si quieren ayuda para configurar algo después, pásenme una captura de su `~/.claude/settings.json` y los oriento.

**Cheatsheet** con todos los comandos: `cheatsheet.md` (les pasaré el link).
