# dotfiles

My macOS configuration. A tiling, keyboard-centric setup for Python/Django web
development, with coding agents doing much of the typing.

## What's here

- `aerospace/` - AeroSpace tiling window manager
- `karabiner/` - Caps Lock as Hyper key (Ctrl+Alt+Cmd), tap for Escape
- `ghostty/` - Ghostty terminal (Tokyo Night, translucent, JetBrainsMono Nerd Font)
- `herdr/` - herdr terminal workspaces, plus `herdr-raise` to focus or reattach a client from a Hyper chord
- `nvim/` - Neovim config (Kickstart-based) with a small project switcher
- `zed/` - Zed settings and keymap
- `t3code/` - T3 Code client settings and a Tokyo Night theme
- `vorssaint/` - Vorssaint settings backup (command bar, clipboard history, keep awake)
- `claude-code/` - Claude Code statusline, session resume helper and my global `CLAUDE.md`
- `claude-skills/` - custom Claude Code skills (see its README)
- `lazygit/` - lazygit config
- `starship.toml` - shell prompt
- `.vimrc` - IdeaVim config for JetBrains IDEs
- `git/` - global gitignore

## Philosophy

- Vim-style `h/j/k/l` everywhere: window management, editor, IDE
- Caps Lock as Hyper key drives all window-management chords
- Tokyo Night across terminal, editors and prompt

## Setup

This repo lives directly at `~/.config`:

```bash
git clone https://github.com/alexander-posztos/dotfiles ~/.config
```

Machine-local files are gitignored. For the Neovim project switcher, copy
`nvim/lua/custom/projects-example.lua` to `nvim/lua/custom/projects.lua` and
list your own projects.

T3 Code keeps its settings in `~/.t3/userdata` and replaces the files on every
save, so `t3code/` holds copies rather than symlink targets:

```bash
cp ~/.config/t3code/client-settings.json ~/.t3/userdata/
cp ~/.config/t3code/themes/*.json ~/.t3/userdata/themes/
```

Restore Vorssaint from its Settings window with the backup in `vorssaint/`.
