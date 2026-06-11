# Alex's macOS Configuration

Personal dotfiles repository for macOS setup on MacBook M4.

## Overview

This is a tiling window manager + keyboard-centric development setup optimized for Django/Python web development.

### Core Philosophy
- **Caps Lock as Hyper Key** - Caps Lock → Ctrl+Alt+Cmd (via Karabiner), tap for Escape
- **Vim-style navigation everywhere** - h/j/k/l for window management, text editing, and IDE navigation
- **Tokyo Night theme** - Consistent dark theme across terminal, editor, and prompt
- **Transparency/glassmorphism** - Semi-transparent terminal with blur effects

## Directory Structure

```
~/.config/
├── aerospace/          # Tiling window manager
├── borders/            # Window border highlights
├── ghostty/            # Terminal emulator
├── git/                # Global git ignore
├── karabiner/          # Keyboard remapping (Hyper key)
├── nvim/               # Neovim configuration (Kickstart-based)
├── raycast/            # Raycast extensions (auto-generated)
├── starship.toml       # Shell prompt
└── .vimrc              # IdeaVim config for JetBrains IDEs
```

## Tools & Configuration

### Ghostty (Terminal)
**Config:** `ghostty/config`

- **Theme:** Tokyo Night
- **Font:** JetBrainsMono Nerd Font, size 14
- **Transparency:** 85% opacity with blur (glassmorphism)
- **Titlebar:** Hidden (macOS native)
- **Key bindings:**
  - `Cmd+D` - Split right
  - `Cmd+Shift+D` - Split down
  - `Cmd+Left/Right` - Navigate tabs

### Aerospace (Window Manager)
**Config:** `aerospace/aerospace.toml`

Tiling window manager similar to i3/yabai. Uses Hyper key (Caps Lock) for all shortcuts.

**Navigation (Hyper + h/j/k/l):**
- `Hyper+h/j/k/l` - Focus window left/down/up/right
- `Hyper+Shift+h/j/k/l` - Move window

**Workspaces (Hyper + number):**
- `Hyper+1-9` - Switch to workspace
- `Hyper+Shift+1-9` - Move window to workspace

**Quick Launch:**
- `Hyper+b` - Firefox
- `Hyper+t` - Ghostty
- `Hyper+d` - Discord

**Multi-Monitor:**
- `Hyper+Tab` - Move workspace to next monitor
- `Hyper+Shift+Tab` - Move workspace to previous monitor
- `Hyper+n` - Focus previous monitor
- `Hyper+m` - Focus next monitor
- `Hyper+Shift+n` - Move window to previous monitor
- `Hyper+Shift+m` - Move window to next monitor

**Layout:**
- `Hyper+Space` - Toggle floating/tiling
- `Hyper+f` - Fullscreen
- `Hyper+,/.` - Resize smaller/larger

### Karabiner Elements (Keyboard)
**Config:** `karabiner/karabiner.json`

Single rule: **Caps Lock → Hyper Key**
- Hold: Ctrl+Alt+Cmd (Hyper modifier for Aerospace)
- Tap alone: Escape (useful for Vim)
- Keyboard type: ISO (German layout)

### Neovim
**Config:** `nvim/init.lua`

Based on **Kickstart.nvim** with custom additions. Leader key is `Space`.

**Core Features:**
- Lazy.nvim plugin manager
- Mason for LSP management
- Telescope for fuzzy finding
- Treesitter for syntax highlighting
- blink.cmp for autocompletion (super-tab preset)
- Tokyo Night theme (transparent)

**LSP Servers:**
- `basedpyright` - Python (type checking off)
- `ruff` - Python linting/formatting
- `html` / `tailwindcss` / `cssls` - Web development
- `lua_ls` - Lua

**Custom Plugins** (`nvim/lua/custom/plugins/`):
- `lualine` - Statusline with project/env/server status
- `alpha-nvim` - Dashboard with Neovim ASCII art
- `toggleterm` - Terminal integration for Django dev servers
- `auto-save` - Autosave with 1s debounce (saves on idle, not while typing)
- `nvim-notify` - Pretty notifications
- `hardtime` - Enforces good Vim habits
- `nvim-colorizer` - Color preview in code

**Project Manager** (`nvim/lua/custom/project-manager.lua`):
- **Auto-detects** registered projects on startup (no need to pick if already in project dir)
- Quick project switching with Telescope
- Supports conda environments and venvs
- Django development shortcuts:
  - `<leader>pp` - Pick project
  - `<leader>da` - Start all dev servers (background, no window)
  - `<leader>ds` - Show/hide dev terminal windows (keeps focus in code)
  - `<leader>dr` - Toggle Django runserver terminal
  - `<leader>dt` - Toggle Tailwind terminal
  - `<leader>dx` - Stop all dev servers
- Lualine shows: project name, conda/venv, `DJ ●` `TW ●` (green=running, grey=stopped)

**Key Custom Mappings:**
- `jj` - Escape from insert mode
- `<leader>gg` - Open lazygit
- `<leader>j/k` - Next/previous paragraph (German keyboard friendly)
- `Ctrl+h/j/k/l` - Navigate splits

### Starship (Prompt)
**Config:** `starship.toml`

Custom powerline-style prompt with Gruvbox-inspired colors (modified blues/oranges).

**Segments:** OS icon → Username → Directory → Git branch/status → Language version

**Language detection:** Node.js, Python, Rust, Go, C/C++, Java, Kotlin, Haskell, PHP, Docker, Conda, Pixi

### Borders
**Config:** `borders/bordersrc`

JankyBorders configuration for window border highlights:
- Round style, 2.5px width
- Active: Semi-transparent white (`0xccffffff`)
- Inactive: Subtle dark (`0x33000000`)

### IdeaVim (JetBrains IDEs)
**Config:** `.vimrc`

Vim emulation for IntelliJ/PyCharm/etc.

**Features:**
- Space as leader
- which-key for keybind hints
- surround, commentary, argtextobj, multiple-cursors
- NERDTree integration
- German keyboard mappings (ö→{, ä→[, etc.)

**Key groups:**
- `<leader>s` - Search (files, classes, symbols, text)
- `<leader>g` - Git operations
- `<leader>r` - Run/Debug
- `<leader>d` - Debugging
- `<leader>l` - Language/Refactoring
- `<leader>t` - Tool windows
- `<leader>n` - Navigation

## Development Workflow

### Django Projects
1. `cd` into project directory and open Neovim (auto-detects project + conda/venv)
   - Or use `<leader>pp` to pick project from anywhere
2. `<leader>da` to start Django + Tailwind servers (runs in background)
3. Check lualine - `DJ ●` and `TW ●` turn green when running
4. `<leader>ds` to peek at logs (press again to hide)
5. `<leader>dx` to stop servers when done

### Window Management
1. Caps Lock held = Hyper key
2. `Hyper+t` for new terminal
3. `Hyper+h/j/k/l` to navigate windows
4. `Hyper+1-9` for workspaces
5. `Hyper+Tab` to move workspace to other monitor
6. `Hyper+n/m` to focus different monitors

## Dependencies

Install via Homebrew:
```bash
brew install --cask ghostty
brew install --cask karabiner-elements
brew install nikitabobko/tap/aerospace
brew tap FelixKratz/formulae && brew install borders
brew install neovim starship lazygit
```

## Notes

- German ISO keyboard layout - some mappings account for this
- Uses conda for Python environment management
- Raycast extensions directory is auto-generated (don't edit manually)
