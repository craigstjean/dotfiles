#!/usr/bin/env bash

set -e

if [ -f /etc/os-release ]; then
    case $(uname -n) in
        nixos)
            echo Do not use this in NixOS, see nixos directory
            exit
            ;;
        *)
            ;;
    esac
fi

function is_in_path {
    builtin type -P "$1" &> /dev/null
}

function dump_requirements {
    echo "install git first"
    exit 1
}

function install_link {
    relative="$1"
    absolute="$HOME/$1"
    basepath="$(dirname $absolute)/"

    if [ -L ${absolute} ]; then
        if [ -e ${absolute} ]; then
            echo "$absolute is already a symlink"
            false
        else
            echo "$absolute is broken, restoring"
            unlink "$absolute"
            ln -s "$(pwd -P)/$relative" "$basepath"
            true
        fi
    elif [ -e ${absolute} ]; then
        echo "$absolute already exists but is not symlinked, moving it to $absolute.old"
        mv "$absolute" "$absolute.old"
        echo "creating symlink for $absolute"
        ln -s "$(pwd -P)/$relative" "$basepath"
        true
    else
        echo "creating symlink for $absolute"
        ln -s "$(pwd -P)/$relative" "$basepath"
        true
    fi
}

function install_nix {
    case "$OSTYPE" in
        darwin*)
            sh <(curl -L https://nixos.org/nix/install)
            ;;
        linux*)
            if grep -qi microsoft /proc/version; then
                # WSL
                sh <(curl -L https://nixos.org/nix/install) --no-daemon
            else
                sh <(curl -L https://nixos.org/nix/install) --daemon
            fi
            ;;
        *)
            echo "unsupported OSTYPE: $OSTYPE"
            ;;
    esac
}

function update_nixpkgs {
    echo "updating nix my-packages"
    nix-env -i my-packages

    case "$OSTYPE" in
        linux*)
            if grep -qi microsoft /proc/version; then
                # WSL
                echo "updating nix my-desktop"
                nix-env -i my-desktop
            fi
            ;;
        *)
            echo "skipping nix my-desktop"
            ;;
    esac
}

function setup_nixfonts {
    mkdir -p "$HOME/.config/fontconfig/conf.d/"
    install_link .config/fontconfig/conf.d/10-nix-fonts.conf && fc-cache -f || true
}

function install_doom_emacs {
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
    yes | ~/.emacs.d/bin/doom install
}

function install_nvm {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install --lts
    nvm use --lts
    nvm alias default 16
}

is_in_path git || dump_requirements

echo "#################"
echo "##     ZSH     ##"
echo "#################"
install_link .zshrc || true
if [[ -d $HOME/.oh-my-zsh ]]; then
    echo "oh-my-zsh already installed"
else
    RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo
echo "#################"
echo "##     NIX     ##"
echo "#################"
if [[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]]; then
    . $HOME/.nix-profile/etc/profile.d/nix.sh
fi
is_in_path nix-env && echo "nix already installed" || install_nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
if [[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]]; then
    . $HOME/.nix-profile/etc/profile.d/nix.sh
fi
install_link .config/nixpkgs || true
update_nixpkgs
setup_nixfonts

echo
echo "#################"
echo "##     Vim     ##"
echo "#################"
install_link .vimrc || true
if [[ -f $HOME/.vim/autoload/plug.vim ]]; then
    echo "vim plug already installed"
else
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +"PlugInstall --sync" +qa
fi

echo
echo "#################"
echo "## Doom Emacs  ##"
echo "#################"
if [[ -f $HOME/.emacs.d/bin/doom ]]; then
    echo "doom emacs already installed"
elif [[ -d $HOME/.emacs.d ]]; then
    echo "$HOME/.emacs.d already exists, setting it to $HOME/.emacs.d.old"
    mv $HOME/.emacs.d $HOME/.emacs.d.old
    install_doom_emacs
else
    install_doom_emacs
fi

install_link .doom.d || true
$HOME/.emacs.d/bin/doom sync

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
is_in_path gore && echo "gore already installed" || go install github.com/x-motemen/gore/cmd/gore@latest
is_in_path gocode && echo "gocode already installed" || go install github.com/stamblerre/gocode@latest
is_in_path godoc && echo "godoc already installed" || go install golang.org/x/tools/cmd/godoc@latest
is_in_path goimports && echo "goimports already installed" || go install golang.org/x/tools/cmd/goimports@latest
is_in_path gorename && echo "gorename already installed" || go install golang.org/x/tools/cmd/gorename@latest
is_in_path guru && echo "guru already installed" || go install golang.org/x/tools/cmd/guru@latest
is_in_path gotests && echo "gotests already installed" || go install github.com/cweill/gotests/gotests@latest
is_in_path gomodifytags && echo "gomodifytags already installed" || go install github.com/fatih/gomodifytags@latest
is_in_path gopls && echo "gopls already installed" || go install golang.org/x/tools/gopls@latest

echo
echo "#################"
echo "##    Node     ##"
echo "#################"
if [[ -d $HOME/.nvm ]]; then
    echo "nvm already installed"
else
    install_nvm
fi
is_in_path typescript-language-server && echo "typescript-language-server already installed" || npm i -g typescript-language-server
is_in_path js-beautify && echo "js-beautify already installed" || npm i -g js-beautify
is_in_path stylelint && echo "stylelint already installed" || npm i -g stylelint
is_in_path yarn && echo "yarn already installed" || npm i -g yarn
is_in_path pnpm && echo "pnpm already installed" || npm i -g pnpm

echo
echo "#################"
echo "##    tmux     ##"
echo "#################"
install_link .tmux.conf || true

echo
echo "#################"
echo "##  User bin   ##"
echo "#################"
mkdir -p $HOME/bin
install_link bin/nix-go || true

