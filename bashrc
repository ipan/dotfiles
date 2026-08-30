# ~/.bashrc — interactive Bash configuration (Linux)

# Do not configure non-interactive shells.
[ -z "$PS1" ] && return

# System configuration.
if [ -r /etc/bash.bashrc ]; then
  . /etc/bash.bashrc
elif [ -r /etc/bashrc ]; then
  . /etc/bashrc
fi

# Environment and tool managers.
if [ -z "${XDG_CONFIG_HOME:-}" ]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi
if [ -z "${XDG_DATA_HOME:-}" ]; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi

# Add asdf-managed tool shims.
if command -v asdf >/dev/null 2>&1; then
  export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
  export PATH="$ASDF_DATA_DIR/shims:$PATH"
fi

# Configure Go's workspace and binary directory.
export GOPATH="${GOPATH:-$HOME/go}"
export GOBIN="${GOBIN:-$GOPATH/bin}"

# Add Go-installed binaries.
if [ -d "$GOBIN" ]; then
    export PATH="$GOBIN:$PATH"
fi
# Add Rust/Cargo-installed binaries.
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Add Snap-installed binaries.
if [ -d /snap/bin ]; then
    export PATH="/snap/bin:$PATH"
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

# Shell behavior and history.
shopt -s histappend checkwinsize cdspell extglob
HISTCONTROL=ignoredups:ignorespace:ignoreboth
HISTSIZE=50000
HISTFILESIZE=50000

# Bash completion.
for bash_completion in \
    /usr/share/bash-completion/bash_completion \
    /etc/bash_completion; do
  if [ -r "$bash_completion" ] && ! shopt -oq posix; then
    # shellcheck disable=SC1090
    . "$bash_completion"
    break
  fi
done

# Git prompt.
if [ -r "${XDG_CONFIG_HOME}/bash-git-prompt/gitprompt.sh" ]; then
  GIT_PROMPT_ONLY_IN_REPO=1
  . "${XDG_CONFIG_HOME}/bash-git-prompt/gitprompt.sh"
  export GIT_PROMPT_THEME=Solarized
fi

# Terminal title.
case "$TERM" in
  xterm*|rxvt*)
    export PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
  screen*)
    export PS1="\[\033[00;32m\]\h:\[\033[01;34m\]\W \[\033[31m\]\[\033[00m\]\$\[\033[00m\] "
    ;;
esac

# Personal aliases and optional fzf integration.
[ -r "$HOME/.aliases" ] && . "$HOME/.aliases"
[ -r "$HOME/.fzf.bash" ] && . "$HOME/.fzf.bash"
