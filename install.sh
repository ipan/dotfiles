#!/bin/sh

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
            dst="$XDG_CONFIG_HOME/$filename"
        else
            dst="$XDG_CONFIG_HOME/$folder/$filename"
        fi
 
        # mkdir if not exist
        pardir=$(dirname "${dst}")
        mkdir -vp "${pardir}"
    else
        dst="$HOME/.$filename"
    fi

    # remove existing symlink
    if [ -L "${dst}" ]; then
    echo "Removing:"
        rm -v "${dst}"
    fi

    # backup the files
    if [ -f "${dst}" ]; then
    echo "Backing up:"
        mv -v "${dst}" $rc.old
    fi

    ln -svf $(pwd)/$rc ${dst}
}

detect_os() {
    if [ "$(uname)" = "Darwin" ]; then
        printf "macos"
        return
    fi

    os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    case $os_name in
        "Ubuntu" )
            printf "ubuntu"
            ;;
        "CentOS Linux" )
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
    apt-get install --no-upgrade --assume-yes $@
}

install_python() {
    python3 -m pip install --user $@
}

setup_zsh() {
    if [ ! $(which zsh) ]; then
        case $(detect_os) in
            'macos' )
                install_mac zsh
                ;;
            'ubuntu' )
                install_ubuntu zsh
                ;;
        esac
    fi

    if [ ! -d "$HOME/.oh-my-zsh/" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi 

    # ~/.zshrc
    # ~/.aliases
    linkme zshrc
    linkme aliases

    # activate new settings
    source $HOME/.zshrc
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

    # ~/.bashrc
    # ~/.aliases
    linkme bashrc
    linkme aliases

    # remove old aliaes if found
    rm -rf "$XDG_CONFIG_HOME/.bash_profile"
    rm -rf "$XDG_CONFIG_HOME/bash/aliases"
    
    source $HOME/.bashrc
}

setup_git() {
    case $(detect_os) in
        'macos' )
            install_mac git
            ;;
        'ubuntu' )
            install_ubuntu git
            ;;
    esac

    # ~/.config/git/{config,ignore}
    linkme gitconfig git config
    linkme gitignore git ignore
}

setup_vim() {
    case $(detect_os) in
        'macos' )
            install_mac vim
            ;;
        'ubuntu' )
            install_ubuntu vim
            ;;
    esac
    # ~/.vimrc
    linkme vimrc
}

setup_nvim() {
    # https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
    case $(detect_os) in
        'macos' )
            install_mac neovim
            install_python pynvim
            ;;
        'ubuntu' )
            nvim_stable='https://github.com/neovim/neovim/releases/download/stable/nvim.appimage'
            mkdir -p ~/bin
            wget -O ~/bin/nvim $nvim_stable
            chmod +x ~/bin/nvim
            ;;
    esac
        
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
    git
    htop
    jq
    silversearcher-ag
    wget
    )

    install_ubuntu ${pkg[@]}
}
    

setup_os() {
    case $(detect_os) in
        'macos' )
            setup_macos
            ;;
        'ubuntu' )
            setup_ubuntu
            ;;
    esac
}

setup_python() {
    case $(detect_os) in
        'macos' )
            install_mac python3
            ;;
        'ubuntu' )
            install_ubuntu python3 python3-pip 
            ;;
    esac

    # install basic python packages
    install_python black flake8 pipenv
    
    # flake8
    linkme flake8 $NODIR
    
    # pep8
    linkme pep8 $NODIR
    
    # pip
    mac_config="$HOME/Library/Application Support"
    if [ -d "$mac_config" ]; then
        XDG_CONFIG_HOME="$mac_config"
    fi
    linkme pip.conf pip
}

uninstall_pip() {
    pip3 freeze | grep '==' | cut -d '=' -f1 | tr '\n' ' ' | xargs sudo pip3 uninstall -y
}

usage() {
    echo "usage:"
    echo "    $0 [zsh|bash|git|vim|nvim|os|mac|ubuntu|python]"
}

if [ -z "$1" ]; then
    usage
fi

case $1 in
    'zsh' )
        setup_zsh
        ;;
    'bash' )
        setup_bash
        ;;
    'git' )
        setup_git
        ;;
    'vim' )
        setup_vim
        ;;
    'nvim' )
        setup_nvim
        ;;
    'os' )
        setup_os
        ;;
    'mac' )
        setup_macos
        ;;
    'ubuntu' )
        setup_ubuntu
        ;;
    'python' )
        setup_python
        ;;
    'clean-pip' )
        uninstall_pip
        ;;
    'go' )
        # TODO: complete the go packages and installation
        echo "[WIP] will be installing go and gorc"
        ;;
    * )
        echo "$1 is not valid command"
        usage
        exit 1
        ;;
esac
