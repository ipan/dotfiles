#!/bin/bash

NODIR='__NODIR__'

source bash_profile

function linkme {
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

    cmd="ln -svf '$(pwd)/$rc' '${dst}'"
    echo $cmd
    eval $cmd
}

echo $XDG_CONFIG_HOME
echo $XDG_DATA_HOME

# bash
linkme bash_profile
linkme bashrc
linkme bash_aliases bash aliases

# git
linkme gitconfig git config
linkme gitignore git ignore

# vim
linkme vimrc
linkme init.vim nvim

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

