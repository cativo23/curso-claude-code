---
name: exportar-tareas
description: Exporta las tareas pendientes de task-cli a un archivo CSV o markdown. Úsalo cuando el usuario diga "exportar tareas", "generar reporte", "lista en CSV" o similar.
allowed-tools: Read, Bash, Write
---

# /exportar-tareas

Lee `tasks.json` y genera un archivo de export.

Formato por defecto: **markdown** con tabla. Si el usuario pide CSV explícito en `$ARGUMENTS` (ej. `/exportar-tareas csv`), usa CSV.

Pasos:

1. Lee `tasks.json` desde la raíz del proyecto.
2. Filtra solo las tareas con `done: false` (pendientes).
3. Genera el archivo:
   - Markdown: `tareas-pendientes.md` con tabla `| ID | Título | Fecha |`
   - CSV: `tareas-pendientes.csv` con headers `id,titulo,fecha`
4. Confirma al usuario cuántas tareas exportaste y el nombre del archivo.

Si no hay tareas pendientes, NO crees archivo y dile al usuario.
