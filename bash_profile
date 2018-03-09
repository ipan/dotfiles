# .bash_profile

# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
if [ -n $XDG_CONFIG_HOME ]; then
	export XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -n $XDG_DATA_HOME ]; then
	export XDG_DATA_HOME="$HOME/.local/share"
fi

# path
if [ -d $HOME/go/bin ]; then
    export PATH="$HOME/go/bin:$PATH"
fi

if [ -d $HOME/bin ]; then
    export PATH="$HOME/bin:$PATH"
fi

# configuration
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Get the aliases and functions
alias_rc="$XDG_CONFIG_HOME/bash/aliases"
if [ -f "$alias_rc" ]; then
    source "$alias_rc"
fi
