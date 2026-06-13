# dotfiles

My macOS configuration - a tiling, keyboard-centric setup for Python/Django web development.

## What's here

- `aerospace/` - AeroSpace tiling window manager
- `borders/` - active-window border highlights
- `claude-skills/` - custom Claude Code skills (see its README)
- `ghostty/` - Ghostty terminal (Tokyo Night, translucent, JetBrainsMono Nerd Font)
- `karabiner/` - Caps Lock as Hyper key (Ctrl+Alt+Cmd), tap for Escape
- `lazygit/` - lazygit config
- `nvim/` - Neovim config (Kickstart-based) with a small project switcher
- `starship.toml` - shell prompt
- `.vimrc` - IdeaVim config for JetBrains IDEs
- `git/` - global gitignore

## Philosophy

- Vim-style `h/j/k/l` everywhere: window management, editor, IDE
- Caps Lock as Hyper key drives all window-management chords
- Tokyo Night theme across terminal, editor, and prompt

## Setup

This repo lives directly at `~/.config`:

```bash
git clone https://github.com/alexander-posztos/dotfiles ~/.config
```

Machine-local files are gitignored. For the Neovim project switcher, copy
`nvim/lua/custom/projects-example.lua` to `nvim/lua/custom/projects.lua` and
list your own projects.
