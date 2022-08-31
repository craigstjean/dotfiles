#!/bin/bash

set -e

function is_in_path {
    builtin type -P "$1" &> /dev/null
}

function setup_zshrc {
    sl="$HOME/.zshrc"
    if [ -L ${sl} ]; then
        if [ -e ${sl} ]; then
            echo "$sl is already a symlink"
        else
            echo "$sl is broken, restoring"
            unlink "$sl"
            ln -s "$(pwd -P)/.zshrc" "$HOME/"
        fi
    elif [ -e ${sl} ]; then
        echo "$sl already exists but is not symlinked, moving it to $sl.old"
        mv "$sl" "$sl.old"
        echo "creating symlink for $sl"
        ln -s "$(pwd -P)/.zshrc" "$HOME/"
    else
        echo "creating symlink for $sl"
        ln -s "$(pwd -P)/.zshrc" "$HOME/"
    fi
}

function install_nix {
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
}

function update_nixpkgs {
    echo "updating nix my-packages"
    nix-env -i my-packages

    echo "updating nix my-desktop"
    nix-env -i my-desktop
}

function setup_nixpkgs {
    sl="$HOME/.config/nixpkgs"
    if [ -L ${sl} ]; then
        if [ -e ${sl} ]; then
            echo "$sl is already a symlink"
        else
            echo "$sl is broken, restoring"
            unlink "$sl"
            ln -s "$(pwd -P)/.config/nixpkgs" "$HOME/.config/"
            update_nixpkgs
        fi
    elif [ -e ${sl} ]; then
        echo "$sl already exists but is not symlinked, moving it to $sl.old"
        mv "$sl" "$sl.old"
        echo "creating symlink for $sl"
        ln -s "$(pwd -P)/.config/nixpkgs" "$HOME/.config/"
        update_nixpkgs
    else
        echo "creating symlink for $sl"
        ln -s "$(pwd -P)/.config/nixpkgs" "$HOME/.config/"
        update_nixpkgs
    fi
}

function setup_nixfonts {
    mkdir -p "$HOME/.config/fontconfig/conf.d/"
    sl="$HOME/.config/fontconfig/conf.d/10-nix-fonts.conf"
    if [ -L ${sl} ]; then
        if [ -e ${sl} ]; then
            echo "$sl is already a symlink"
        else
            echo "$sl is broken, restoring"
            unlink "$sl"
            ln -s "$(pwd -P)/.config/fontconfig/conf.d/10-nix-fonts.conf" "$HOME/.config/fontconfig/conf.d/"
	    fc-cache -f
        fi
    elif [ -e ${sl} ]; then
        echo "$sl already exists but is not symlinked, moving it to $sl.old"
        mv "$sl" "$sl.old"
        echo "creating symlink for $sl"
        ln -s "$(pwd -P)/.config/fontconfig/conf.d/10-nix-fonts.conf" "$HOME/.config/fontconfig/conf.d/"
	fc-cache -f
    else
        echo "creating symlink for $sl"
        ln -s "$(pwd -P)/.config/fontconfig/conf.d/10-nix-fonts.conf" "$HOME/.config/fontconfig/conf.d/"
	fc-cache -f
    fi
}

function install_doom_emacs {
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
    yes | ~/.emacs.d/bin/doom install
}

function setup_doom_d {
    sl="$HOME/.doom.d"
    if [ -L ${sl} ]; then
        if [ -e ${sl} ]; then
            echo "$sl is already a symlink"
        else
            echo "$sl is broken, restoring"
            unlink "$sl"
            ln -s "$(pwd -P)/.doom.d" "$HOME/"
	    $HOME/.emacs.d/bin/doom sync
        fi
    elif [ -e ${sl} ]; then
        echo "$sl already exists but is not symlinked, moving it to $sl.old"
        mv "$sl" "$sl.old"
        echo "creating symlink for $sl"
        ln -s "$(pwd -P)/.doom.d" "$HOME/"
        $HOME/.emacs.d/bin/doom sync
    else
        echo "creating symlink for $sl"
        ln -s "$(pwd -P)/.doom.d" "$HOME/"
        $HOME/.emacs.d/bin/doom sync
    fi
}

function install_nvm {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install node
    nvm use node
    nvm alias default node
}

function setup_bin {
    sl="$HOME/bin/nix-go"
    if [ -L ${sl} ]; then
        if [ -e ${sl} ]; then
            echo "$sl is already a symlink"
        else
            echo "$sl is broken, restoring"
            unlink "$sl"
            ln -s "$(pwd -P)/bin/nix-go" "$HOME/bin/"
        fi
    elif [ -e ${sl} ]; then
        echo "$sl already exists but is not symlinked, moving it to $sl.old"
        mv "$sl" "$sl.old"
        echo "creating symlink for $sl"
        ln -s "$(pwd -P)/bin/nix-go" "$HOME/bin/"
    else
        echo "creating symlink for $sl"
        ln -s "$(pwd -P)/bin/nix-go" "$HOME/bin/"
    fi
}

echo "#################"
echo "##     ZSH     ##"
echo "#################"
setup_zshrc

echo
echo "#################"
echo "##     NIX     ##"
echo "#################"
is_in_path nix-env && echo "nix already installed" || install_nix
setup_nixpkgs
setup_nixfonts

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
setup_doom_d

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

echo
echo "#################"
echo "##  User bin   ##"
echo "#################"
setup_bin

