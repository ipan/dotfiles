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
cmake
gnu-sed
git
jq
htop
python3
vim
neovim
tree
wget
)

cmd="brew update"
echo $cmd
eval $cmd

cmd="brew upgrade"
echo $cmd
eval $cmd

cmd="brew install --with-default-names ${pkg[@]}"
echo $cmd
eval $cmd

