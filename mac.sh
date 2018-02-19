#!/bin/bash

# Homebrew
if [[ ! $(which brew) ]]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# must-have tools
pkg=(
ag
bash-completion
bash-git-prompt
byobu
ctags
git
htop
python3
vim
nvim
wget
)

cmd="brew update"
echo $cmd
eval $cmd

cmd="brew install ${pkg[@]}"
echo $cmd
eval $cmd

