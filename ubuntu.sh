#!/bin/bash

if [ "$(id -u)" != "0" ]; then
  echo "need sudo: sudo $0"
  exit 1
fi

source bash_profile

# must-have tools
pkg=(
bash-completion
byobu
cmake
ctags
htop
silversearcher-ag
wget
curl
)

cmd="apt-get update"
echo $cmd
eval $cmd

cmd="apt-get install -y -q ${pkg[@]}"
echo $cmd
eval $cmd

# neovim
mkdir -p ~/bin
wget -O ~/bin/nvim https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
chmod +x ~/bin/nvim

# bash git promot
git_prompt_dir="$XDG_DATA_HOME/bash-git-prompt"
git clone https://github.com/magicmonty/bash-git-prompt.git $git_prompt_dir --depth=1

