# Mini-curso de Claude Code

Presentación para el equipo sobre cómo extender Claude Code: skills, plugins, statuslines, hooks, MCPs y subagents.

Duración objetivo: ~60 min.

## Archivos

| Archivo | Para qué |
|---|---|
| `presentacion.md` | Las slides (formato `slides` CLI) |
| `cheatsheet.md` | Resumen de comandos para que los compas se lo lleven |
| `README.md` | Esto |
| `guion.md` | Guion del presentador (qué decir slide a slide, con ejemplos del proyecto demo) |
| `ejemplo/task-cli/` | Proyecto demo real con skills/hooks/agents aplicados — el hilo conductor del curso |
| `present.sh` | Lanza la presentación con banners ASCII centrados |
| `banner.sh` | Regenera banners ASCII con figlet (fuente ANSI Shadow) |

## Cómo correr la presentación

Uso [`slides`](https://github.com/maaslalani/slides) de maaslalani — un renderizador de markdown a slides en terminal.

### Instalar `slides`

**macOS (Homebrew)**

```bash
brew install slides
```

**Linux (Arch / AUR)**

```bash
yay -S slides
# o con paru
paru -S slides
```

`slides` no está en los repos oficiales de Arch, vive en AUR.

**Linux/WSL (cualquier distro, vía Go)**

```bash
go install github.com/maaslalani/slides@latest
# Asegúrate de tener $HOME/go/bin en tu PATH
```

**Linux/WSL (vía Snap)**

```bash
sudo snap install slides
```

**Windows nativo**

Recomiendo usar **WSL** y seguir las instrucciones de Linux. Si insistes en nativo, hay binarios precompilados en los releases de GitHub: https://github.com/maaslalani/slides/releases

### Lanzar la presentación

```bash
cd ~/projects/work/curso-claude-code
slides presentacion.md
```

### Atajos de teclado dentro de `slides`

| Tecla | Acción |
|---|---|
| `j`, `↓`, `space`, `→`, `n` | Siguiente slide |
| `k`, `↑`, `←`, `p` | Slide anterior |
| `gg` | Primera slide |
| `G` | Última slide |
| `<número><enter>` | Saltar a slide N |
| `q`, `Ctrl+C` | Salir |

> No usamos `Ctrl+E` (ejecutar code blocks) en este curso — los code blocks son referencia, no demos.

## Tips para presentar

- **Antes de empezar**: pon la terminal en pantalla completa y sube el tamaño de fuente (Ctrl+Shift+`+` en la mayoría de terminales).
- **Si tu fuente no muestra los Nerd Font icons** de la slide de Lumira, no pasa nada — el resto se ve bien.
- **Tiempo por slide**: ~3 minutos en promedio. Si te quedas corto, salta la sección "AVANZADO".

## Adaptaciones que puedes hacer

- **Más corto (30 min)**: salta las capas 5 (MCPs) y 6 (Subagents). Quédate con skills + plugins + lumira + hooks.
- **Más largo (90 min)**: agrega ejercicio práctico al final — que cada quien instale un plugin y configure lumira mientras tú acompañas.
- **Diferente audiencia**: si los compas no usan Claude Code aún, antepón una slide de "Instalación" con `npm install -g @anthropic-ai/claude-code` + login.

## Setup verificado

Los datos de la presentación vienen del setup real al **2026-05-11**:

- Claude Code `2.1.128`
- 5 plugins instalados (security-guidance, feature-dev, frontend-design, fullstack-dev-skills, superpowers)
- 4 marketplaces registrados
- `lumira` v actual con preset `full`, tema `tokyo-night`
- GSD `v1.41.0`

Si actualizas Claude Code o cambias algo, revisa `cheatsheet.md` para que no quede desactualizado.
