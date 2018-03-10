# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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
if [ -n $(which vim) ]; then
  export EDITOR=vim
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

[ -r "${HOME}/.byobu/prompt" ] && . "${HOME}/.byobu/prompt"   #byobu-prompt#
