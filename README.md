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
./install.sh zed   # installs Zed
./install.sh vim-config
./install.sh zsh
./install.sh bash
./install.sh sdk
./install.sh ai-tools  # installs Pi, omp, and CodeGraph
./install.sh agent-instructions  # link CodeGraph instructions for Codex, Pi, and omp
```

Installer backups are stored in the ignored `tmp/backups/` directory with a
`YYYYMMDD-HHMMSS` timestamp in each filename.

The `init` command:

- Configures Git, shell files, and editor settings with symlinks.
- Installs Neovim and Zed on macOS and Ubuntu.
- Installs asdf and `uv`; asdf manages Node.js, Java, Maven, and Ant, while uv manages Python environments and tools across code repositories.
- Installs Go through Homebrew on macOS and the official distribution on Ubuntu; installs rustup using the official installer. Go manages its own toolchain and installed binaries; rustup manages Rust toolchains, `rustc`, `cargo`, and Rust components.
- Installs `fd`/`fd-find` and `ripgrep` for Neovim search.
- Uses Zsh on macOS and Bash on Linux.
- The `os` command installs system utilities without changing configuration files. The `sdk` command installs the language/tool managers, Go, and rustup's default stable toolchain.
- Does not install or configure tmux, i3, Byobu, Flake8, pycodestyle, or Deoplete.

## Toolchain management

Each ecosystem owns its toolchain. Homebrew manages Go on macOS; the official
Go distribution is used on Ubuntu; rustup manages Rust.

- **asdf** manages selectable versions of Node.js, Java, Maven, and Ant. Set a
  machine default in `~/.tool-versions` with `asdf set -u <plugin> <version>`;
  set a project-specific version with `asdf set <plugin> <version>` from that
  project. asdf reads the nearest `.tool-versions` while walking up from the
  current directory, and its shims select the configured runtime.
- **uv** manages Python interpreters, project virtual environments, dependency
  resolution, and isolated CLI tools across repositories. Use `uv sync` (or
  `uv run`) in a Python project and `uv tool install <tool>` for a globally
  available Python CLI such as Ruff.
- **Go** manages its own compiler toolchain and project dependencies. On macOS,
  Homebrew manages the Go installation and updates; on Ubuntu, the SDK
  installer downloads the current official release. `go.mod` declares the
  language version for a project, and `go install` places user binaries in
  `GOBIN` (default: `~/go/bin`).
- **rustup** installs and selects Rust toolchains, which provide `rustc`,
  `cargo`, `rustfmt`, and Clippy. The SDK installer bootstraps rustup with its
  default stable toolchain. Projects can select a toolchain with
  `rust-toolchain.toml`.

The `sdk` installer installs asdf and uv; configures the Node.js, Java, Maven,
and Ant asdf plugins; installs Go through Homebrew on macOS or the official
distribution on Ubuntu; installs rustup's default stable toolchain; then
installs Ruff with uv.

## AI tools

`./install.sh ai-tools` installs the following optional terminal tools via their
official installers. It skips a tool that is already available on `PATH`.

- [Pi](https://pi.dev/) — terminal coding harness.
- [omp](https://omp.sh/) (Oh My Pi) — terminal coding agent.
- [CodeGraph](https://github.com/colbymchenry/codegraph) — code-intelligence CLI.

### Shared agent instructions

`./install.sh agent-instructions` symlinks the repository's
[`AGENTS.md`](AGENTS.md) to these global instruction paths:

- `~/.codex/AGENTS.md`
- `~/.pi/agent/AGENTS.md`
- `~/.omp/agent/AGENTS.md`

Existing regular files are backed up to `tmp/backups/`; existing symlinks are
replaced. The shared instructions direct agents to initialize and synchronize a
repository's CodeGraph index before exploratory work. They do not install
CodeGraph or configure an MCP server.

## Zed

`./install.sh zed` installs Zed through Homebrew on macOS and Zed's official
installer on Ubuntu. Existing Zed settings are left unchanged.

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

