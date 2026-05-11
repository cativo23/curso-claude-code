# task-cli — proyecto demo del curso

Mini gestor de tareas en CLI. **Es el hilo conductor del curso**: cada concepto que vemos en las slides (skill, hook, subagent, CLAUDE.md) está aplicado aquí en código real.

No necesitas correrlo para entender el curso. Es referencia.

## Uso del CLI

```bash
# Instalar (opcional — también funciona con `node src/index.js`)
cd ejemplo/task-cli
npm link            # te deja `task-cli` global

# Comandos
task-cli add "comprar pan"
task-cli list
task-cli done 1
task-cli rm 2
task-cli help
```

Las tareas se guardan en `tasks.json` (mismo directorio, no es DB).

## Las piezas de Claude Code aplicadas aquí

```
task-cli/
├── CLAUDE.md                              <- memoria del proyecto (Capa Bonus)
├── package.json
├── src/
│   └── index.js                            <- el código del CLI
└── .claude/
    ├── settings.json                       <- registra el hook (Capa 4)
    ├── skills/
    │   ├── agregar-tarea/SKILL.md          <- Skill custom (Capa 1)
    │   └── exportar-tareas/SKILL.md        <- Skill custom (Capa 1)
    ├── agents/
    │   └── task-cli-tester.md              <- Subagent (Capa 6)
    └── hooks/
        └── validar-scope-commit.sh         <- Hook PreToolUse (Capa 4)
```

### `.claude/skills/agregar-tarea/SKILL.md`

Cuando alguien dice "agrega una tarea de comprar pan", Claude detecta el match contra la `description` de la skill y ejecuta `task-cli add "comprar pan"`. Ejemplo de la Capa 1.

### `.claude/skills/exportar-tareas/SKILL.md`

Genera un export en markdown o CSV de las tareas pendientes. Útil cuando hacen un reporte semanal.

### `.claude/agents/task-cli-tester.md`

Subagent especialista en validar que el CLI siga funcionando. Lo invoca el principal cuando se modifica `src/index.js`. Tiene su propio contexto, no contamina el principal. Ejemplo de la Capa 6.

### `.claude/hooks/validar-scope-commit.sh`

Hook PreToolUse que bloquea `git commit` si el mensaje no usa scope `(task-cli)`. Demuestra cómo los hooks imponen disciplina automáticamente. Ejemplo de la Capa 4.

### `CLAUDE.md`

Memoria persistente del proyecto: stack, convenciones, qué NO hacer. Claude lo lee al abrir cada sesión. Ejemplo del bloque Bonus.

## Cómo abrirlo en Claude Code

```bash
cd ejemplo/task-cli
claude
```

Al arrancar:
- Lee `CLAUDE.md` → conoce el stack y las convenciones
- Detecta las skills en `.claude/skills/` → quedan disponibles como `/agregar-tarea` y `/exportar-tareas`
- Carga el subagent → puede invocar `task-cli-tester` cuando aplique
- Registra el hook → cualquier intento de `git commit` pasa por la validación de scope

Probálo: pídele a Claude "agrega una tarea de comprar pan" y mira cómo invoca la skill sola.
