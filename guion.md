# Guion del presentador — Curso Claude Code

Este es tu guion completo, slide por slide. Cada bloque tiene:
- **Tiempo**: cuánto durar en esa slide
- **Qué decir**: bullets de los puntos clave (no un script palabra-por-palabra)
- **Ejemplo / Mostrar**: si aplica, qué referenciar del proyecto demo
- **Transición**: frase para pasar a la siguiente

---

## Proyecto demo: `task-cli`

Como hilo conductor usamos un proyecto ficticio simple que los compas pueden imaginar fácilmente:

**`task-cli`** — un CLI mínimo en Node/TypeScript para gestionar tareas:

```bash
task-cli add "comprar pan"      # agrega tarea
task-cli list                    # lista pendientes
task-cli done 1                  # marca completada
task-cli rm 2                    # borra
```

Lo usamos como sandbox para explicar cada concepto. **No vamos a programarlo en vivo** — solo lo mencionamos como ejemplo recurrente para aterrizar las ideas.

## Cómo usar el ejemplo durante la presentación

**No vas a correr código en vivo.** El proyecto `ejemplo/task-cli/` existe en el repo para que tú, como presentador, **señales archivos** cuando explicas cada concepto.

### Setup antes de empezar

Abrí **dos paneles en tu terminal** (tmux, split, o dos ventanas):

```
┌─────────────────────────────┬─────────────────────────────┐
│  Panel A — la presentación  │  Panel B — el código demo   │
│                             │                             │
│  $ ./present.sh             │  $ cd ejemplo/task-cli      │
│                             │  $ ls -la                   │
│  (acá vivís el 95% del time)│  (acá señalas cuando        │
│                             │   alguien pregunta "cómo    │
│                             │   se ve eso?")              │
└─────────────────────────────┴─────────────────────────────┘
```

### Cuándo cambiar al panel B

En cada slide donde el guion diga **"📂 Mostrar"** (verás los marcadores abajo), pasás 30 seg al panel B, abrís el archivo con `bat`/`cat`/`less`, lo señalas, volvés a la presentación.

Si alguien pregunta algo que no tiene marcador "📂 Mostrar", no hace falta abrir nada — el guion te dice qué responder verbalmente.

### Si querés cero overhead

Si no querés manejar dos paneles, ignorá esta sección. El curso funciona igual sin abrir el código una sola vez. El ejemplo queda como **material para que los compas exploren después** clonando el repo.

---

## Slide 1 — Portada "Claude Code"

**Tiempo**: 1 min

**Qué decir**:
- Saludo breve. "Vamos a ver qué hay más allá del chat de Claude Code."
- "Si solo lo usan en modo conversación, están dejando el 80% del valor en la mesa."
- "Al final del curso, cada quien sabrá cómo configurar su entorno para que Claude trabaje como un teammate disciplinado, no como un copiloto distraído."

**Transición**: "Estos son los 7 temas que vamos a ver."

---

## Slide 2 — Agenda

**Tiempo**: 1 min

**Qué decir**:
- Recorrer la agenda rápido. Mencionar las 2 secciones: BASE y AVANZADO.
- "BASE son las 6 capas de extensibilidad. AVANZADO es para los que quieran construir cosas propias después."
- "Al final tienen un cheatsheet con todos los comandos para llevarse."

**Transición**: "Antes de entrar a las capas, mapa mental."

---

## Slide 3 — El mapa mental

**Tiempo**: 3 min

**Qué decir**:
- "Claude Code se extiende en capas. Cada capa resuelve un problema distinto."
- Recorrer las 6: skills, plugins, statuslines, hooks, MCPs, subagents. UNA frase por capa.
- "**Mensaje clave**: no aprendan todo a la vez. Cada capa cuando duela el problema que resuelve."
- Ejemplo: "Si hacen el mismo prompt 5 veces al día → suban a 'skill'. Si Claude rompe convenciones de commits → suban a 'hooks'."

**Transición**: "Empezamos por la capa 1 — la más básica y la que más impacto da por esfuerzo."

---

## Slide 4 — Banner SKILLS

**Tiempo**: 10 seg

**Qué decir**: solo "Skills." Pausa visual. Avanzar.

---

## Slide 5 — Capa 1: Slash commands y skills

**Tiempo**: 2 min

**Qué decir**:
- "Un slash command es un atajo. `/security-review`, `/init`. Lo escriben y Claude ejecuta una receta."
- "La receta se llama 'skill' — es un archivo markdown con instrucciones."
- "La skill le dice a Claude: qué archivos leer, qué herramientas usar, qué formato devolver."
- "Las skills viven en dos lugares: globales en `~/.claude/skills/` o del proyecto en `./.claude/skills/`."

**Ejemplo task-cli**:
- "Imagina una skill `/release-notes` que lee los últimos commits de task-cli y genera el changelog. La escriben una vez, la usan toda la vida."

**📂 Mostrar** (opcional, panel B):
```
ls ejemplo/task-cli/.claude/skills/
# agregar-tarea/  exportar-tareas/
```
"Mira, en task-cli ya tengo dos skills. Una para agregar, otra para exportar."

**Transición**: "¿De dónde salen las skills?"

---

## Slide 6 — Skills: ¿de dónde salen?

**Tiempo**: 2 min

**Qué decir**:
- Recorrer la tabla: built-in, plugins, propias.
- "Hacer una skill propia es trivial: una carpeta + un SKILL.md con frontmatter."
- "El frontmatter tiene 3 campos importantes: `name`, `description`, `allowed-tools`."
- "**La descripción es crítica** — Claude la lee para decidir cuándo invocar la skill solo."

**Ejemplo task-cli**:
- "Skill `/agregar-tarea` con descripción 'crea una tarea en task-cli, úsalo cuando el usuario diga agregar/crear/anotar tarea'. Claude la invoca solo cuando matchea."

**📂 Mostrar** (panel B):
```
cat ejemplo/task-cli/.claude/skills/agregar-tarea/SKILL.md
```
Señalá:
- El frontmatter con `name`, `description`, `allowed-tools`
- La `description` cuenta CUÁNDO usar la skill (clave para auto-invocación)
- El `$ARGUMENTS` que recibe el texto del usuario

**Transición**: "Pasemos a empaquetar varias skills juntas — plugins."

---

## Slide 7 — Banner PLUGINS

**Tiempo**: 10 seg

**Qué decir**: "Plugins." Avanzar.

---

## Slide 8 — Capa 2: Plugins y marketplaces

**Tiempo**: 2 min

**Qué decir**:
- "Un plugin = skills + agentes + hooks + comandos, todo empaquetado."
- "Se instala desde un marketplace, que es un repo de GitHub que lista plugins."
- "Flujo de dos pasos: agregar el marketplace una vez, instalar plugins desde él."
- "Anthropic mantiene un marketplace oficial. La comunidad tiene los suyos."

**Transición**: "Estos son los que yo tengo instalados."

---

## Slide 9 — Plugins y workflows en mi setup

**Tiempo**: 2 min

**Qué decir**:
- Recorrer la tabla. "5 plugins + GSD que es un workflow externo distinto."
- "Tres son oficiales de Anthropic, uno de jeffallan, Superpowers que en enero 2026 entró al marketplace oficial."
- "GSD lo separo porque NO se instala como plugin — usa otro mecanismo. Lo veremos en 2 slides."

**Transición**: "Qué hace cada uno."

---

## Slide 10 — Qué hace cada uno

**Tiempo**: 3 min

**Qué decir**:
- Una frase por plugin, sin extenderse.
- security-guidance: "Auditor de seguridad. `/security-review` sobre tu rama."
- feature-dev: "3 agentes que te guían a través de un feature."
- frontend-design: "Plantillas para diseño frontend."
- fullstack-dev-skills: "66 skills, una por lenguaje/framework. Si tu stack está, ya tienes superpoderes."
- superpowers: "El más popular. Skills mandatorias: TDD, debugging, worktrees. 40k estrellas."
- GSD: "Planificación de proyecto. Phases, roadmap, requirements en `.planning/`."

**Ejemplo task-cli**:
- "Si estuvieras construyendo task-cli, podrías hacer: `/security-review` antes del merge, `superpowers` te forzaría a escribir tests TDD, GSD te dividiría 'app, comandos, persistencia' en phases."

**Transición**: "Comandos exactos para que se lo lleven."

---

## Slide 11 — Comandos exactos de instalación

**Tiempo**: 2 min

**Qué decir**:
- "Copien estos comandos. Marketplaces primero (una sola vez), después los plugins."
- "GSD es distinto — un `npx` desde la terminal, no slash command."
- "Después de instalar: `/help` les muestra los nuevos comandos disponibles."

**Transición**: "Hablando de Superpowers y GSD — son los dos más potentes pero NO compiten entre sí."

---

## Slide 12 — Superpowers vs GSD

**Tiempo**: 3 min

**Qué decir**:
- "Confunden mucho. Veámoslo claro."
- "Superpowers se mete en CADA tarea: te obliga a TDD, te hace worktrees, te pide code review. Foco: cómo Claude trabaja dentro de un feature."
- "GSD se mete en EL PROYECTO ENTERO: phases, roadmap, requirements persistentes. Foco: cómo organizas múltiples features."
- "**Conclusión**: úsenlos juntos. GSD planea el proyecto, Superpowers ejecuta cada feature con disciplina."

**Ejemplo task-cli**:
- "GSD te genera el roadmap: Phase 1 'CRUD básico', Phase 2 'persistencia', Phase 3 'UI'. Cuando ejecutas Phase 1, Superpowers te fuerza a escribir el test de `task-cli add` antes que el código."

**Transición**: "Pasemos al HUD — la statusline."

---

## Slide 13 — Banner LUMIRA

**Tiempo**: 10 seg

**Qué decir**: "Lumira." Avanzar.

---

## Slide 14 — Capa 3: Statuslines

**Tiempo**: 1 min

**Qué decir**:
- "La statusline es la línea de info en la parte inferior del CLI."
- "Por defecto es básica. Una statusline custom te da: modelo, tokens, costo, cache hit, branch, contexto disponible, MCPs conectados."
- "Se configura en settings.json con un comando que produce la línea."

**Transición**: "La que mantengo yo se llama lumira."

---

## Slide 15 — Lumira: instalación

**Tiempo**: 2 min

**Qué decir**:
- "Lumira es mi statusline. Es un binario Node, instalable con `npm install -g lumira`."
- "Dos formas de configurarla: el comando `/lumira` dentro de Claude Code (en lenguaje natural) o editando `~/.config/lumira/config.json`."
- "Después de cambiar config, reinicien la sesión."

**Ejemplo**:
- "Si quieren probarla: `/lumira preset minimal` y ven la diferencia inmediatamente."

**Transición**: "Esta es mi config actual."

---

## Slide 16 — Lumira: mi config actual

**Tiempo**: 2 min

**Qué decir**:
- "Preset `full`, tema `tokyo-night`, icons `nerd` (Nerd Font instalada), cache metrics encendidos."
- "Los thresholds del context bar: warning al 60%, critical al 80%. Eso me avisa antes de que se llene la sesión."
- "Si su terminal no tiene Nerd Font instalada, cambien `icons` a `emoji` o `none`."

**Transición**: "Pasamos al verdadero superpoder — hooks."

---

## Slide 17 — Banner HOOKS

**Tiempo**: 10 seg

**Qué decir**: "Hooks." Avanzar.

---

## Slide 18 — Capa 4: Hooks

**Tiempo**: 2 min

**Qué decir**:
- "Un hook = un comando shell que Claude Code dispara automáticamente en ciertos eventos."
- "4 eventos principales: SessionStart, PreToolUse (antes de cada tool), PostToolUse (después), Stop (cuando termina la respuesta)."
- "Para qué sirven: validar commits, bloquear `rm -rf`, inyectar contexto, escanear secretos."
- "**Es la diferencia entre 'Claude Code es una IDE' y 'Claude Code es un teammate disciplinado'**."

**Transición**: "Ejemplo real de mi setup."

---

## Slide 19 — Hooks: ejemplo real

**Tiempo**: 3 min

**Qué decir**:
- "Este hook se dispara antes de cualquier comando Bash."
- Recorrer el JSON: matcher, command, timeout.
- "Si el script `gsd-validate-commit.sh` sale con código 2, **bloquea** la tool. Claude no ejecuta el commit."
- "Lo uso para: validar conventional commits, prevenir `git push --force`, bloquear edits en archivos sensibles."

**Ejemplo task-cli**:
- "Si tuvieran task-cli, podrían tener un hook que valide que cada commit tenga la palabra `task-cli` en el scope. `feat(task-cli): add command`. Si no, lo bloquea."

**📂 Mostrar** (panel B):
```
cat ejemplo/task-cli/.claude/hooks/validar-scope-commit.sh
cat ejemplo/task-cli/.claude/settings.json
```
Señalá:
- En el `.sh`: el regex que valida `(task-cli)` en el mensaje, y el `exit 2` que bloquea la tool
- En `settings.json`: cómo se registra el hook en `PreToolUse.matcher: "Bash"`
- "Si Claude intenta `git commit -m 'feat: nuevo'` sin scope, el hook le tira el commit."

**Transición**: "Estos son los eventos completos."

---

## Slide 20 — Hooks: eventos completos

**Tiempo**: 1 min

**Qué decir**:
- Recorrer la tabla rápido.
- "Cada hook puede tener un `matcher` (regex) para aplicar solo a tools específicos."
- "Doc oficial: el link en la slide. Tiene los esquemas JSON completos del payload de cada evento."

**Transición**: "Capa 5 — conectar Claude a servicios externos."

---

## Slide 21 — Banner MCPS

**Tiempo**: 10 seg

**Qué decir**: "MCPs." Avanzar.

---

## Slide 22 — Capa 5: MCPs

**Tiempo**: 2 min

**Qué decir**:
- "MCP = Model Context Protocol. Es un estándar para que aplicaciones expongan tools a un LLM."
- "Traducido: un MCP server le da a Claude acceso a un servicio externo. Notion, Jira, Linear, GitHub, n8n, lo que sea."
- "Sin MCP: 'lee el ticket X de Jira' no funciona, Claude no tiene acceso."
- "Con MCP: Claude lee, comenta, crea, transiciona estados."

**Ejemplo task-cli**:
- "Con el MCP de Atlassian conectado, podrías decir 'crea un Jira issue para cada bug que detectes en task-cli' y Claude lo hace."

**Transición**: "Cómo se conectan."

---

## Slide 23 — MCPs: cómo instalar y autenticar

**Tiempo**: 2 min

**Qué decir**:
- "Dos formas. Opción A: MCPs de claude.ai. Solo autenticar con `/mcp` y dale 'Authenticate'. La lista ya viene poblada."
- "Opción B: agregar MCPs custom por CLI. `claude mcp add <nombre> <comando>`. Esto es para servers internos o de terceros."
- "El ejemplo de n8n es real — así conecté nuestro n8n interno."

**Transición**: "Capa 6 — la última. Subagents."

---

## Slide 24 — Banner AGENTS

**Tiempo**: 10 seg

**Qué decir**: "Agents." Avanzar.

---

## Slide 25 — Capa 6: Subagents

**Tiempo**: 2 min

**Qué decir**:
- "Un subagent = un Claude separado con sus propias instrucciones y tools."
- "Tres casos típicos: tareas paralelas, investigaciones largas (no contaminar contexto principal), especialistas (code-reviewer, code-architect)."
- "Viven en `~/.claude/agents/<nombre>.md` con un frontmatter parecido al de skills."

**Ejemplo task-cli**:
- "Subagent `task-cli-tester`: 'corre los tests de task-cli y reporta fallas con stack trace'. Lo invoca el principal cuando necesita verificar."

**📂 Mostrar** (panel B):
```
cat ejemplo/task-cli/.claude/agents/task-cli-tester.md
```
Señalá:
- Frontmatter parecido al de skills, pero con `tools:` en lugar de `allowed-tools:`
- Las instrucciones del agente: pasos específicos, sin ambigüedad
- "Cuando el principal lo invoca, este agente arranca CON SU PROPIO contexto. No contamina el principal con la salida de los tests."

**Transición**: "Pasemos al bonus rápido."

---

## Slide 26 — Banner BONUS

**Tiempo**: 10 seg

**Qué decir**: "Bonus." Avanzar.

---

## Slide 27 — Bonus: Output styles

**Tiempo**: 1 min

**Qué decir**:
- "Un output style cambia el tono y formato de las respuestas de Claude."
- "Yo tengo uno llamado `jarvis` para cuando quiero respuestas más concisas y formales."
- "Lo cambian en caliente con `/output-style <nombre>`."
- "Útil para: modo didáctico cuando aprenden, modo ultra-corto cuando van con prisa."

**Transición**: "Y el último bonus — la memoria persistente."

---

## Slide 28 — Bonus: CLAUDE.md y reglas

**Tiempo**: 2 min

**Qué decir**:
- "`CLAUDE.md` es la memoria persistente. Claude lo lee al arrancar cada sesión."
- "Tiene jerarquía: global (`~/.claude/CLAUDE.md`) > reglas modulares > del proyecto."
- "**Aquí va lo que NO quieren repetir cada vez**: convenciones de commits, stack tecnológico, reglas de seguridad, metodologías."

**Ejemplo task-cli**:
- "En `task-cli/CLAUDE.md` ponen: 'Este proyecto usa Node 24, TS estricto, Vitest para tests, conventional commits con scope task-cli'. Claude ya nunca pregunta."

**📂 Mostrar** (panel B):
```
cat ejemplo/task-cli/CLAUDE.md
```
Señalá las 3 secciones:
- **Stack** — qué tecnología usa
- **Convenciones** — cómo escribir commits y tests
- **No hacer** — los anti-patterns del proyecto
- "Esto es lo más alto ROI del curso. 10 minutos de escribir CLAUDE.md te ahorra 100 prompts repetidos."

**Transición**: "Eso fue la BASE. Ahora vamos a power-user."

---

## Slide 29 — Banner PRO TIPS

**Tiempo**: 10 seg

**Qué decir**: "Pro tips." Avanzar.

---

## Slide 30 — Power-user tips

**Tiempo**: 5 min (slide más densa de la sección avanzada)

**Qué decir**:
- Recorrer la tabla. Para cada atajo, una frase de contexto.
- **Shift+Tab** (resaltar): "Antes de cambios grandes, plan mode. Claude solo planifica, NO toca archivos. Se ahorran el 80% de 'deshaz eso'."
- **!comando**: "Si quieren meter el output de un comando al contexto sin escribir todo, lo hacen con `!`. Ejemplo: `!ls -la` y el output queda en el chat."
- **@archivo**: "Para referenciar un archivo específico sin que Claude tenga que buscarlo."
- **Cache TTL 5min**: "Si pausan la sesión más de 5 min, el cache se va. La próxima respuesta cuesta más tokens. Eviten pausas largas si pueden."

**Ejemplo task-cli**:
- "Trabajando en task-cli: Shift+Tab antes de pedir 'refactoriza el handler de errores'. Claude te muestra el plan, lo revisas, le das ok."

**Transición**: "Veamos un caso real combinando varias capas."

---

## Slide 31 — Case study: bug fix end-to-end

**Tiempo**: 4 min

**Qué decir**:
- "Esto es lo que pasa cuando las capas trabajan juntas."
- Recorrer los 6 pasos en orden.
- "El punto: cada herramienta sola es útil. Juntas, te ahorran horas en cada bug fix."
- "Notar: el dev no escribió código manualmente. Investigó, escribió test, fixeó, commiteó, pusheó — todo conducido."

**Ejemplo task-cli**:
- "Imaginen el bug en task-cli: 'no acepta tareas con tildes'. El mismo flujo: ticket → debug → test → fix → ship. Igual."

**Transición**: "Bueno, hora de construir lo suyo."

---

## Slide 32 — Build-your-own #1: tu propia skill

**Tiempo**: 2 min

**Qué decir**:
- "Una carpeta + un SKILL.md. Eso es todo."
- "Ejemplo concreto: una skill que lista tus PRs abiertos usando `gh`."
- "La descripción es CLAVE. Sean específicos en cuándo se debe invocar."
- "`$ARGUMENTS` es la variable mágica para recibir los args del usuario."

**Ejemplo task-cli**:
- "Otra skill útil para task-cli: `/exportar-tareas` que las pasa a CSV. Una sola vez la escriben, toda la vida la usan."

**📂 Mostrar** (panel B):
```
cat ejemplo/task-cli/.claude/skills/exportar-tareas/SKILL.md
```
Mostrar que es solo 20 líneas — describe el comportamiento, no implementa. Claude infiere los detalles.

**Transición**: "Subagents — más poderoso porque puede correr en paralelo."

---

## Slide 33 — Build-your-own #2: tu propio subagent

**Tiempo**: 2 min

**Qué decir**:
- "Mismo patrón: frontmatter + instrucciones."
- "Diferencia con skills: los subagents tienen su PROPIO contexto. No contaminan el principal."
- "Buenos casos de uso: especialistas (reviewer, tester), tareas largas, paralelo."

**Ejemplo**:
- "Yo creé este `md-reviewer` específicamente para revisar la documentación de este curso antes de presentarla."

**📂 Mostrar** (panel B): el agente del ejemplo task-cli como punto de comparación.
```
cat ejemplo/task-cli/.claude/agents/task-cli-tester.md
```
"Acá tienen otro patrón: en lugar de revisar markdown, este agente corre el CLI y verifica que funcione."

**Transición**: "Y el último — hooks."

---

## Slide 34 — Build-your-own #3: tu propio hook

**Tiempo**: 3 min

**Qué decir**:
- "Hooks son los más técnicos. Es bash o cualquier lenguaje. Reciben JSON por stdin."
- "Ejemplo: valida conventional commits. Si el mensaje no matchea el regex, sale con exit 2 y Claude se detiene."
- "Lo registran en `~/.claude/settings.json` bajo `hooks.PreToolUse`."

**Ejemplo task-cli**:
- "Hook que solo permite commits con scope `task-cli`. Cualquier otra cosa, bloquea."

**📂 Mostrar** (panel B) — el hook real funcionando:
```
cat ejemplo/task-cli/.claude/hooks/validar-scope-commit.sh
cat ejemplo/task-cli/.claude/settings.json
```
Repetir el punto clave: el hook recibe **JSON por stdin**, lee la tool input, devuelve **exit 2 para bloquear**. Es la API que Claude Code expone.

**Transición**: "Cierre — el reto para esta semana."

---

## Slide 35 — Ejercicio para casa

**Tiempo**: 2 min

**Qué decir**:
- "No hagan los 3 — hagan UNO. El que más les duela hoy."
- "**Crear skill**: si repiten algo cada día (resumir PR, listar mis tareas, generar release notes), hagan la skill."
- "**Crear hook**: si Claude rompe convención (mensajes de commit, archivos sensibles), hagan el hook."
- "**Instalar plugin**: si están con un stack específico, agreguen fullstack-dev-skills o superpowers."
- "**Reto**: el viernes en el daily, cada quien comparte qué hizo. Yo les ayudo si se atoran."

**Transición**: "Recursos para profundizar."

---

## Slide 36 — Recursos para profundizar

**Tiempo**: 1 min

**Qué decir**:
- "Los links están en el cheatsheet. Doc oficial es la fuente de verdad."
- "Superpowers tiene un README excelente. GSD también."
- "El cheatsheet de este curso tiene todos los comandos para que no tengan que tomar notas."

**Transición**: "Recap."

---

## Slide 37 — Recap

**Tiempo**: 2 min

**Qué decir**:
- "Por capa: cuál es el comando que más usarán y cuándo empezar."
- "**Regla de oro**: no adopten todo a la vez. Cada capa cuando duela el problema que resuelve."
- "Mañana lunes: skills + lumira. Día 5: hooks. Día 10: subagents. Vayan progresivos."

**Transición**: "Preguntas."

---

## Slide 38 — Q&A

**Tiempo**: lo que quede + 5 min de buffer

**Qué decir**:
- "Pregunten lo que quieran. Si no sale ahora, pásenmela en privado."
- "Si quieren ayuda para configurar algo después, pásenme una captura de su settings.json y los oriento."
- "Cheatsheet en `cheatsheet.md` con todos los comandos del curso."

---

## Tips generales como presentador

- **Antes de empezar**: lanza `./present.sh` no `slides presentacion.md` — así se centran los banners.
- **Si te sales del guion**: no problema, este es un mapa, no un script. Las anécdotas reales pegan mejor que el guion.
- **Si alguien pregunta algo que no sabes**: "buena, te la respondo después" + apúntalo. No improvises técnico.
- **Si se acaba el tiempo**: salta la sección AVANZADO completa. Las primeras 28 slides son la BASE auto-contenida.
- **Si sobra tiempo**: profundiza en hooks (slide 18-20) — es lo que más impacto da y la gente lo usa menos.

## Errores a evitar

- No leer las slides palabra por palabra. Las slides son el ancla; tú aportas la voz.
- No demos en vivo (acordamos sin demos). Si alguien pide "muéstrame cómo", anótalo para sesión de seguimiento.
- No vender GSD como "lo mejor". Es UNA opción. Superpowers, Devin, Cursor — son alternativas válidas según contexto.
- No asumir que conocen los términos. "Frontmatter", "YAML", "stdin/stdout" — explica al pasar.
