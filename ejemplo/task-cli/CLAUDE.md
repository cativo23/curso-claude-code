# task-cli — contexto del proyecto

Este archivo lo lee Claude Code automáticamente al abrir el proyecto.

## Stack

- Node 24+ (ESM, `"type": "module"` en package.json)
- Sin TypeScript ni compilación: JavaScript puro
- Persistencia en `tasks.json` local (no base de datos)
- Cero dependencias externas

## Convenciones

- Conventional commits con scope `task-cli`: `feat(task-cli): add export command`
- Tests con `node --test` cuando los agreguemos (no usar otras libs)
- Mensajes al usuario siempre en español

## Comandos del CLI

```
task-cli add "<titulo>"
task-cli list
task-cli done <id>
task-cli rm <id>
task-cli help
```

## No hacer

- No agregar dependencias npm — todo con stdlib
- No introducir TypeScript ni build steps
- No cambiar el formato de `tasks.json` sin migración explícita
