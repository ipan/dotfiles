# ~/.zshrc — interactive Zsh configuration (macOS)

# Environment and tool managers.
# Add asdf-managed tool shims.
if command -v asdf >/dev/null 2>&1; then
    export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
    export PATH="$ASDF_DATA_DIR/shims:$PATH"
fi

# Configure Go's workspace and binary directory.
export GOPATH="${GOPATH:-$HOME/go}"
export GOBIN="${GOBIN:-$GOPATH/bin}"

# Add user-local tools such as uv and Ruff.
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Add Go-installed binaries.
if [ -d "$GOBIN" ]; then
    export PATH="$GOBIN:$PATH"
fi
# Add Rust/Cargo-installed binaries.
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Add Python user-installed binaries.
if command -v python3 >/dev/null 2>&1; then
    py3_user_bin=$(python3 -m site --user-base)
    if [ -d "$py3_user_bin/bin" ]; then
        export PATH="$py3_user_bin/bin:$PATH"
    fi
fi

# Add personal binaries.
if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi

# Personal functions.
editknownhosts() {
    ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$1"
}

# Oh My Zsh.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="apple"
plugins=(git)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi

# Personal aliases and optional integrations.
[[ -r "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -r "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"
[[ -r "$HOME/.docker/init-zsh.sh" ]] && source "$HOME/.docker/init-zsh.sh"
