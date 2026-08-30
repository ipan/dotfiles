#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

# XDG Base Directory defaults.
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
export XDG_CONFIG_HOME XDG_DATA_HOME

NODIR='__NODIR__'
BACKUP_DIR="$SCRIPT_DIR/tmp/backups"
BACKUP_TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

linkme() {
    local rc="$1"
    local folder="${2:-}"
    local filename="${3:-$rc}"
    local dst source backup backup_name

    source="$SCRIPT_DIR/$rc"
    if [[ ! -f "$source" ]]; then
        echo "Error: configuration file not found: $source" >&2
        return 1
    fi

    if [[ -n "$folder" ]]; then
        if [[ "$folder" == "$NODIR" ]]; then
            dst="$XDG_CONFIG_HOME/$filename"
        else
            dst="$XDG_CONFIG_HOME/$folder/$filename"
        fi
    else
        dst="$HOME/.$filename"
    fi

    mkdir -p "$(dirname "$dst")"

    if [[ -L "$dst" ]]; then
        rm -f "$dst"
    elif [[ -e "$dst" ]]; then
        mkdir -p "$BACKUP_DIR"
        backup_name="$(basename "$dst").${BACKUP_TIMESTAMP}.bak"
        backup="$BACKUP_DIR/$backup_name"
        mv "$dst" "$backup"
        echo "Backed up $dst to $backup"
    fi

    ln -s "$source" "$dst"
    echo "Linked $dst -> $source"
}

detect_os() {
    case "$(uname -s)" in
        Darwin)
            printf 'macos\n'
            ;;
        Linux)
            if [[ -r /etc/os-release ]]; then
                # shellcheck disable=SC1091
                . /etc/os-release
                case "${ID:-}" in
                    ubuntu)
                        printf 'ubuntu\n'
                        ;;
                    *)
                        printf 'unknown\n'
                        ;;
                esac
            else
                printf 'unknown\n'
            fi
            ;;
        *)
            printf 'unknown\n'
            ;;
    esac
}

install_mac() {
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew is required. Install it from https://brew.sh/ and rerun this script." >&2
        return 1
    fi
    brew install "$@"
}

install_ubuntu() {
    if ! command -v apt-get >/dev/null 2>&1; then
        echo "apt-get is required for Ubuntu setup." >&2
        return 1
    fi
    sudo apt-get install --no-upgrade --assume-yes "$@"
}

setup_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    linkme zsh_profile '' zprofile
    linkme zshrc
    linkme aliases

    echo "Zsh configuration installed. Start a new shell to activate it."
}

setup_bash() {
    case "$(detect_os)" in
        macos)
            install_mac bash-completion bash-git-prompt
            ;;
        ubuntu)
            install_ubuntu bash-completion git
            if [[ ! -d "$XDG_CONFIG_HOME/bash-git-prompt" ]]; then
                git clone --depth 1 \
                    https://github.com/magicmonty/bash-git-prompt.git \
                    "$XDG_CONFIG_HOME/bash-git-prompt"
            fi
            ;;
        *)
            echo "Unsupported operating system for Bash setup." >&2
            return 1
            ;;
    esac

    linkme bash_profile
    linkme bashrc
    linkme aliases

    echo "Bash configuration installed. Start a new shell to activate it."
}

setup_git() {
    linkme gitconfig git config
    linkme gitconfig-thermofisher
    linkme gitignore git ignore
}

setup_vim() {
    linkme vimrc
}

setup_nvim_dependencies() {
    case "$(detect_os)" in
        macos)
            install_mac ctags git curl fd neovim ripgrep
            ;;
        ubuntu)
            install_ubuntu ctags git curl fd-find neovim ripgrep
            ;;
        *)
            echo "Unsupported operating system for Neovim setup: $(detect_os)" >&2
            return 1
            ;;
    esac
}

setup_nvim() {
    setup_nvim_dependencies
    linkme nvim/init.lua nvim init.lua
}

setup_zed() {
    # Install Zed using its supported package source.
    case "$(detect_os)" in
        macos)
            install_mac --cask zed
            ;;
        ubuntu)
            install_ubuntu curl
            curl -f https://zed.dev/install.sh | sh
            ;;
        *)
            echo "Unsupported operating system for Zed setup: $(detect_os)" >&2
            return 1
            ;;
    esac

}

setup_macos() {
    local packages=(
        gh
        gnu-sed
        htop
        jq
        nmap
        tree
        wget
    )
    install_mac "${packages[@]}"
}

setup_ubuntu() {
    local packages=(
        gh
        htop
        jq
        nmap
        tree
        wget
    )
    install_ubuntu "${packages[@]}"
}

install_asdf_ubuntu() {
    if command -v asdf >/dev/null 2>&1; then
        return
    fi

    command -v curl >/dev/null 2>&1 || {
        echo "curl is required to install asdf." >&2
        return 1
    }

    local asdf_version="${ASDF_VERSION:-v0.20.0}"
    local asdf_arch archive tmpdir
    case "$(uname -m)" in
        x86_64|amd64) asdf_arch="amd64" ;;
        aarch64|arm64) asdf_arch="arm64" ;;
        *)
            echo "Unsupported Linux architecture for asdf: $(uname -m)" >&2
            return 1
            ;;
    esac

    tmpdir="$(mktemp -d)"
    archive="$tmpdir/asdf.tar.gz"

    curl -fsSL \
        "https://github.com/asdf-vm/asdf/releases/download/${asdf_version}/asdf-${asdf_version}-linux-${asdf_arch}.tar.gz" \
        -o "$archive"
    tar -xzf "$archive" -C "$tmpdir"
    mkdir -p "$HOME/.local/bin"
    install -m 0755 "$tmpdir/asdf" "$HOME/.local/bin/asdf"
    rm -rf "$tmpdir"
    export PATH="$HOME/.local/bin:$PATH"
}

ensure_asdf_plugin() {
    local plugin="$1"
    local repository="$2"

    if ! asdf plugin list | grep -qx "$plugin"; then
        asdf plugin add "$plugin" "$repository"
    fi
}

install_go() {
    if command -v go >/dev/null 2>&1; then
        return
    fi

    command -v curl >/dev/null 2>&1 || {
        echo "curl is required to install Go." >&2
        return 1
    }

    local go_os go_arch go_version archive tmpdir
    case "$(uname -s)" in
        Darwin) go_os="darwin" ;;
        Linux) go_os="linux" ;;
        *)
            echo "Unsupported operating system for Go: $(uname -s)" >&2
            return 1
            ;;
    esac
    case "$(uname -m)" in
        x86_64|amd64) go_arch="amd64" ;;
        aarch64|arm64) go_arch="arm64" ;;
        *)
            echo "Unsupported architecture for Go: $(uname -m)" >&2
            return 1
            ;;
    esac

    if [[ -x "$HOME/.local/go/bin/go" ]]; then
        export PATH="$HOME/.local/go/bin:$PATH"
        return
    fi

    go_version="${GO_VERSION:-}"
    if [[ -z "$go_version" ]]; then
        go_version="$(curl -fsSL 'https://go.dev/VERSION?m=text' | sed -n '1p')"
    fi
    go_version="${go_version#go}"

    tmpdir="$(mktemp -d)"
    archive="$tmpdir/go.tar.gz"
    curl -fsSL \
        "https://go.dev/dl/go${go_version}.${go_os}-${go_arch}.tar.gz" \
        -o "$archive"
    mkdir -p "$HOME/.local"
    tar -xzf "$archive" -C "$HOME/.local"
    rm -rf "$tmpdir"
    export PATH="$HOME/.local/go/bin:$PATH"
}

install_rustup() {
    if command -v rustup >/dev/null 2>&1; then
        return
    fi

    command -v curl >/dev/null 2>&1 || {
        echo "curl is required to install rustup." >&2
        return 1
    }

    curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile default
    export PATH="$HOME/.cargo/bin:$PATH"
}

setup_sdk() {
    # Install the runtime and Python-tool managers.
    case "$(detect_os)" in
        macos)
            install_mac asdf uv
            ;;
        ubuntu)
            install_ubuntu curl
            install_asdf_ubuntu
            if ! command -v uv >/dev/null 2>&1; then
                curl -LsSf https://astral.sh/uv/install.sh | sh
                export PATH="$HOME/.local/bin:$PATH"
            fi
            ;;
        *)
            echo "Unsupported operating system for uv setup." >&2
            return 1
            ;;
    esac

    # Configure asdf-managed runtime plugins.
    ensure_asdf_plugin ant https://github.com/halcyon/asdf-ant.git
    ensure_asdf_plugin java https://github.com/halcyon/asdf-java.git
    ensure_asdf_plugin maven https://github.com/halcyon/asdf-maven.git
    ensure_asdf_plugin nodejs https://github.com/asdf-vm/asdf-nodejs.git

    # Install Go and rustup outside of asdf.
    install_go
    install_rustup

    # Verify the Python environment and tool manager.
    if ! command -v uv >/dev/null 2>&1; then
        export PATH="$HOME/.local/bin:$PATH"
    fi
    command -v uv >/dev/null 2>&1 || {
        echo "uv was installed but is not available in PATH." >&2
        return 1
    }

    # Install shared Python command-line tools.
    uv tool install --upgrade ruff
    linkme ruff.toml ruff ruff.toml
}

setup_ai_tools() {
    command -v curl >/dev/null 2>&1 || {
        echo "curl is required to install AI tools." >&2
        return 1
    }

    # Install Pi, the terminal coding harness.
    if ! command -v pi >/dev/null 2>&1; then
        curl -fsSL https://pi.dev/install.sh | sh
    fi

    # Install omp (Oh My Pi), a terminal coding agent.
    if ! command -v omp >/dev/null 2>&1; then
        curl -fsSL https://omp.sh/install | sh
    fi

    # Install CodeGraph, the code-intelligence CLI.
    if ! command -v codegraph >/dev/null 2>&1; then
        curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh
    fi
}

setup_os() {
    case "$(detect_os)" in
        macos)
            setup_macos
            ;;
        ubuntu)
            setup_ubuntu
            ;;
        *)
            echo "Unsupported operating system: $(detect_os)" >&2
            return 1
            ;;
    esac
}

setup_init() {
    local os
    os="$(detect_os)"

    setup_os
    setup_git
    setup_sdk
    setup_nvim
    setup_zed

    case "$os" in
        macos)
            setup_zsh
            ;;
        ubuntu)
            setup_bash
            ;;
        *)
            echo "Unsupported operating system: $os" >&2
            return 1
            ;;
    esac
}

usage() {
    cat <<EOF
Usage: $(basename "$0") <subcommand>

Subcommands:
  init     Install system utilities and configure the detected system
  os       Install system utilities only
  zsh      Configure Zsh and Oh My Zsh
  bash     Configure Bash and bash-git-prompt
  git-config  Configure Git
  sdk      Install asdf plugins, Go, rustup, uv, Ruff, and SDK configuration
  ai-tools Install Pi, omp, and CodeGraph
  nvim     Install Neovim and dependencies, then configure it
  zed      Install Zed and configure its settings
  vim-config  Configure Vim
EOF
}

if (($# == 0)); then
    usage
    exit 0
fi

subcmd="$1"
shift

if (($# != 0)); then
    echo "Error: '$subcmd' does not accept additional arguments." >&2
    exit 2
fi

case "$subcmd" in
    init) setup_init ;;
    os) setup_os ;;
    zsh) setup_zsh ;;
    bash) setup_bash ;;
    git-config) setup_git ;;
    sdk) setup_sdk ;;
    ai-tools) setup_ai_tools ;;
    nvim) setup_nvim ;;
    zed) setup_zed ;;
    vim-config) setup_vim ;;
    -h|--help) usage ;;
    *)
        echo "Error: '$subcmd' is not a valid subcommand." >&2
        usage >&2
        exit 2
        ;;
esac
