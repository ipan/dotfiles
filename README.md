# Dotfiles

Personal shell, Git, Vim, and Neovim configuration for macOS and Linux.

## Installation

Run the installer from the repository root:

```bash
./install.sh init
```

The `os` command installs system utilities only:

```bash
./install.sh os
```

Individual components can also be installed:

```bash
./install.sh git-config
./install.sh nvim  # installs Neovim and its dependencies
./install.sh vim-config
./install.sh zsh
./install.sh bash
./install.sh sdk
```

Installer backups are stored in the ignored `tmp/backups/` directory with a
`YYYYMMDD-HHMMSS` timestamp in each filename.

The `init` command:

- Configures Git, shell files, and editor settings with symlinks.
- Installs Neovim on macOS and Ubuntu.
- Installs asdf and `uv`; manages language tools with asdf and Ruff with `uv tool install`.
- Installs `fd`/`fd-find` and `ripgrep` for Neovim search.
- Uses Zsh on macOS and Bash on Linux.
- The `os` command installs system utilities without changing configuration files.
- Does not install or configure tmux, i3, Byobu, Flake8, pycodestyle, or Deoplete.

## Neovim

Neovim is configured in [`nvim/init.lua`](nvim/init.lua) and uses `lazy.nvim`.
The first launch bootstraps `lazy.nvim` and installs the configured plugins.
`./install.sh nvim` also installs Neovim's system dependencies, including Git,
curl, fd, ripgrep, and ctags.

Selected plugins include:

- `telescope.nvim` for file, text, buffer, and help search
- `oil.nvim` as the file explorer
- `gitsigns.nvim` for Git decorations
- `lualine.nvim` for the statusline
- `aerial.nvim` for code symbols
- `nvim-treesitter` for syntax parsing
- `vim-fugitive` for Git commands
- `tokyonight.nvim` for the color scheme

Useful Neovim mappings and commands:

### Telescope

- `<Space>ff` — find files
- `<Space>fg` — search text across the project
- `<Space>fb` — find open buffers
- `<Space>fr` — find recent files
- `<Space>gf` — find Git-tracked files
- `<Space>/` — search the current buffer
- `<Space>fd` — show diagnostics
- `<Space>fc` — list available commands
- `<Space>fk` — search keymaps
- `<Space>fh` — search help tags

Equivalent commands include `:Telescope find_files`, `:Telescope live_grep`,
`:Telescope buffers`, `:Telescope oldfiles`, `:Telescope git_files`, and
`:Telescope diagnostics`.

### File navigation

- `<Ctrl-n>` or `:Oil` — open the Oil file explorer
- `<Space>rt` or `<Space>ao` — toggle the Aerial symbol outline
- `[s` — previous symbol in Aerial
- `]s` — next symbol in Aerial
- `:AerialToggle` — toggle the symbol outline

### Git

- `:Git` or `:G` — open Fugitive Git status
- `:Gdiffsplit` — view a diff split
- `:Gblame` — show Git blame
- `:Gwrite` — stage/write the current file
- `:Gread` — restore the current file from Git
- `:Gcommit` — create a commit
- `:Gpush` — push commits
- `:Gpull` — pull commits

### Plugin management

- `:Lazy` — open the lazy.nvim interface
- `:Lazy sync` — install and update configured plugins
- `:Lazy update` — update plugins
- `:Lazy clean` — remove unused plugins

## Editors

Neovim is the default editor when available:

```text
EDITOR=nvim
VISUAL=nvim
vi -> nvim
vim -> nvim
```

## Git email

`set-git-email.sh` sets the local Git email for repositories under `~/Projects`.
It defaults to `[redacted-email]`:

```bash
./set-git-email.sh
```

An alternate directory or email can be supplied:

```bash
./set-git-email.sh /path/to/projects [redacted-email]
```

Existing commits are not changed.
