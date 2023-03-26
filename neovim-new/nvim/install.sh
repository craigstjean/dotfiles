#!/bin/bash

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

pipx install cmake-language-server
npm install -g vscode-langservers-extracted
go install golang.org/x/tools/gopls@latest
npm install -g typescript typescript-language-server
npm install -g @volar/vue-language-server

mkdir -p $HOME/System/bin
mkdir -p $HOME/System/src

pushd
cd $HOME/System/src
wget https://s3.amazonaws.com/rebar3/rebar3 && chmod +x rebar3
./rebar3 local install
git clone https://github.com/erlang-ls/erlang_ls.git
cd erlang_ls
make
PREFIX=$HOME/System make install
popd

pushd
cd $HOME/System/src
git clone https://github.com/elixir-lsp/elixir-ls.git
cd elixir-ls
mix deps.get
MIX_ENV=prod mix compile
MIX_ENV=prod mix elixir_ls.release -o $HOME/System/bin
popd

pushd
cd $HOME/System/src
git clone https://github.com/LuaLS/lua-language-server
cd lua-language-server
./make.sh
popd

