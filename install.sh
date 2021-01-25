#!/bin/bash
# da/sh does not support array

# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
if [ -n $XDG_CONFIG_HOME ]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -n $XDG_DATA_HOME ]; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi

echo "XDG_CONFIG_HOME: $XDG_CONFIG_HOME"
echo "XDG_DATA_HOME: $XDG_DATA_HOME"

NODIR='__NODIR__'

linkme() {
    rc=$1
    folder=$2
    filename=$3

    if [ -z "$filename" ]; then
        filename="$rc"
    fi

    if [ -n "$folder" ]; then
        if [ "$folder" == "$NODIR" ]; then
            dst="${XDG_CONFIG_HOME}/${filename}"
        else
            dst="${XDG_CONFIG_HOME}/${folder}/${filename}"
        fi

        # mkdir if not exist
        pardir=$(dirname "$dst")
        eval mkdir -vp "$pardir"
    else
        dst="${HOME}/.${filename}"
    fi

    # remove existing symlink
    if [ -L "$dst" ]; then
    echo "Removing:"
        eval rm -v "$dst"
    fi

    # backup the files
    if [ -f "$dst" ]; then
    echo "Backing up:"
        eval mv -v "$dst" ${rc}.old
    fi

    eval ln -svf "$(pwd)/${rc}" "$dst"
}

detect_os() {
    if [ "$(uname)" = "Darwin" ]; then
        printf "macos"
        return
    fi

    os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    case "$os_name" in
        '"Ubuntu"' )
            printf "ubuntu"
            ;;
        '"CentOS Linux"' )
            printf "centos"
            ;;
        "*" )
            printf "unknown"
            ;;
    esac
}

install_mac() {
    if [ ! $(which brew) ]; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew install $@
}

install_ubuntu() {
    sudo apt-get install --no-upgrade --assume-yes $@
}

install_python() {
    python3 -m pip install --user $@
}

setup_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh/" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    # ~/.zsh_profile
    # ~/.zshrc
    # ~/.aliases
    linkme zsh_profile
    linkme zshrc
    linkme aliases

    echo ""
    echo "Run the follow to activate the new settings"
    echo " source ${HOME}/.zshrc"
}

setup_bash() {
    case $(detect_os) in
        'macos' )
            install_mac bash-completion bash-git-prompt
            ;;
        'ubuntu' )
            install_ubuntu bash-completion git
            git clone https://github.com/magicmonty/bash-git-prompt.git $XDG_CONFIG_HOME/bash-git-prompt --depth 1
            ;;
    esac

    # ~/.bash_profile
    # ~/.bashrc
    # ~/.aliases
    linkme bash_profile
    linkme bashrc
    linkme aliases

    # remove old aliaes if found
    rm -rf "$XDG_CONFIG_HOME/bash/aliases"

    source $HOME/.bashrc
}

setup_tmux() {
    # ~/.tmux.conf
    linkme tmux.conf
}

setup_i3() {
    # ~/.config/i3/config
    # ~/.config/i3status/config
    linkme i3.config i3 config
    linkme i3status.config i3status config
}

setup_git() {
    # ~/.config/git/{config,ignore}
    linkme gitconfig git config
    linkme gitignore git ignore
}

setup_vim() {
    # install python pacakges for vim plugins
    install_python pynvim

    # ~/.vimrc
    linkme vimrc
}

setup_nvim() {
    # install python packages for nvim plugins
    install_python pynvim

    # ~/.config/nvim/init.vim
    linkme vimrc nvim init.vim
}


setup_macos() {
    pkg=(
    ag
    byobu
    cmake
    ctags
    gnu-sed
    htop
    jq
    tree
    wget
    )

    install_mac ${pkg[@]}
}

setup_ubuntu() {
    pkg=(
    byobu
    cmake
    ctags
    curl
    htop
    jq
    silversearcher-ag
    wget
    )

    install_ubuntu ${pkg[@]}
}

setup_python() {
    case $(detect_os) in
        'macos' )
            install_mac pyenv
            ;;
        'ubuntu' )
            install_ubuntu python3-pip
            ;;
    esac

    # install basic python packages
    install_python black flake8 pipenv

    # flake8
    linkme flake8 $NODIR

    # pep8
    linkme pep8 $NODIR

    # pip
    linkme pip.conf pip
}

setup_os() {
    setup_git
    setup_python

    case $(detect_os) in
        'macos' )
            setup_macos
            setup_vim
            setup_zsh
            ;;
        'ubuntu' )
            setup_ubuntu
            setup_vim
            setup_bash
            ;;
    esac
}

uninstall_pip() {
    pip3 freeze | grep '==' | cut -d '=' -f1 | tr '\n' ' ' | xargs sudo pip3 uninstall -y
}

maincmd=$(basename $0)

usage() {
    echo "Usage: $maincmd <subcommand> [options]\n"
    echo "Subcommands:"
    echo "  os [macos|ubuntu]: set up system based on OS. (Mac or Ubuntu)"
    echo "  [z|ba]sh: set up zsh (Mac) or bash (Ubuntu)"
    echo "  git: install and setup git"
    echo "  python: install python packages"
    echo "  [nvim|vim]: install and setup (neo)vim"
    echo "  i3: setup i3"
    echo "  tmux: setup tmux"
}


subcmd=$1
case $subcmd in
    '' | '-h' | '--help' )
        usage
        ;;
    'clean-pip' )
        uninstall_pip
        ;;
    * )
        shift
        setup_${subcmd} $@
        if [ $? = 127 ]; then
            echo "Error: '$subcmd' is not valid subcommand." >&2
            echo "       Run $maincmd --help"
        fi
        ;;
esac
