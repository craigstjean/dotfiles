#!/bin/bash

# Brew
OS=$(uname -s)
if [ $OS == "Darwin" ]; then
    brew update
    brew upgrade
fi

# NPM
if command -v npm &> /dev/null; then
    npm update -g
fi

# Rust
if command -v rustup &> /dev/null; then
    rustup update
    cargo install-update --all
fi

# Go
if command -v go-global-update &> /dev/null; then
    go-global-update
fi

# OCaml
if command -v opam &> /dev/null; then
    opam update
    opam upgrade -y
fi

# Doom Emacs
if [ -d $HOME/.config/emacs/bin ]; then
    cd $HOME/.config/emacs/bin
    ./doom upgrade
    ./doom sync -u
    cd
elif [ -d $HOME/.emacs.d/bin ]; then
    cd $HOME/.emacs.d/bin
    ./doom upgrade
    ./doom sync -u
    cd
fi

