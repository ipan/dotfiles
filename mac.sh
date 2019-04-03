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
cmake
ctags
git
gnu-sed
htop
jq
neovim
python3
tree
vim
wget
)

cmd="brew update"
echo $cmd
eval $cmd

# cmd="brew upgrade"
# echo $cmd
# eval $cmd

cmd="brew install ${pkg[@]}"
echo $cmd
eval $cmd

cmd="brew cleanup"
echo $cmd
eval $cmd

cmd="brew doctor"
echo $cmd
eval $cmd

