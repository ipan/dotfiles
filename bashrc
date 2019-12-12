# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8

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

py3_user_bin=$(python3 -m site --user-base)
if [ -d $py3_user_bin/bin ]; then
    export PATH="$py3_user_bin/bin:$PATH"
fi

if [ -d $HOME/bin ]; then
    export PATH="$HOME/bin:$PATH"
fi

# shell options
shopt -s histappend
shopt -s checkwinsize
shopt -s cdspell
shopt -s extglob

# history
HISTCONTROL=ignoredups:ignorespace:ignoreboth
HISTSIZE=50000
HISTFILESIZE=50000

# editor
if [ -n $(which nvim) ]; then
  export EDITOR=nvim
elif [ -n $(which vim) ]; then
  export EDITOR=vim
else
  export EDITOR=vi
fi

brewdir=''
which brew > /dev/null 2>&1
if [ $? == 0 ]; then
	brewdir=$(brew --prefix)
fi

bash_completion="${brewdir}/etc/bash_completion"
# enable programmable completion features
if [ -f $bash_completion ] && ! shopt -oq posix; then
  # shellcheck disable=SC1091
  source $bash_completion
fi

# bash-git-prompt: https://github.com/magicmonty/bash-git-prompt
# mac / homebrew
if [ -f "${brewdir}/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR="${brewdir}/opt/bash-git-prompt/share"
  # shellcheck source=/dev/null
  source "${brewdir}/opt/bash-git-prompt/share/gitprompt.sh"
  export GIT_PROMPT_THEME=Solarized
fi

# linux / git clone
if [ -f "${XDG_DATA_HOME}/bash-git-prompt/gitprompt.sh" ]; then
  GIT_PROMPT_ONLY_IN_REPO=1
  source "${XDG_DATA_HOME}/bash-git-prompt/gitprompt.sh"
  export GIT_PROMPT_THEME=Solarized
fi

# terminal title
case "$TERM" in
  xterm*|rxvt*|tmux*)
    export PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
  screen*)
    export PS1="\[\033[00;32m\]\h:\[\033[01;34m\]\W \[\033[31m\]\[\033[00m\]$\[\033[00m\] "
    ;;
  *)
    ;;
esac

[ -f ~/.aliases ] && source ~/.aliases

[ -r "${HOME}/.byobu/prompt" ] && . "${HOME}/.byobu/prompt"   #byobu-prompt#

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
