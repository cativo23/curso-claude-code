---
name: agregar-tarea
description: Agrega una nueva tarea al task-cli. Úsalo cuando el usuario diga "agregar tarea", "anotar tarea", "crear tarea", "nuevo todo" o similar. El título de la tarea viene en $ARGUMENTS.
allowed-tools: Bash
---

# /agregar-tarea

Ejecuta:

```bash
task-cli add "$ARGUMENTS"
```

Reglas:

1. Si `$ARGUMENTS` está vacío, pide al usuario el título de la tarea.
2. El título no debe llevar comillas externas; el comando ya las agrega.
3. Después de ejecutar, confirma al usuario qué tarea agregaste.

Ejemplo:

```
Usuario: /agregar-tarea comprar pan
Tú: ejecutas `task-cli add "comprar pan"` y respondes
    "Agregada: #5 comprar pan"
```
