#!/usr/bin/env bash

set -e

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
    if [ $# -eq 2 ]; then
        absolute="$2"
    fi
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

function install_doom_emacs {
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
    yes | ~/.config/emacs/bin/doom install
}

function install_rust {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

is_in_path git || dump_requirements

echo "####################"
echo "##  Dependencies  ##"
echo "####################"
distro=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
case $distro in
    *"Arch Linux"*)
        echo "Arch Linux detected"
        sudo pacman -Syyu
        sudo pacman -S --needed --noconfirm \
            git base-devel \
            curl zsh \
            cmake clang ninja erlang elixir go \
            adobe-source-code-pro-fonts awesome-terminal-fonts noto-fonts \
            powerline-fonts \
            neovim python-pynvim emacs-nativecomp \
            xorg lightdm lightdm-gtk-greeter i3-gaps i3status i3lock xss-lock nitrogen \
            graphviz inotify-tools python-pipx \
            sqlite tidy tree-sitter wget xclip \
            tmux ripgrep fd bat eza fzf jq

        if [[ -d $HOME/System/aur/yay ]]; then
            echo "yay already installed"
            yay -Syu
        else
            mkdir -p $HOME/System/aur
            pushd $HOME/System/aur
            git clone https://aur.archlinux.org/yay.git
            cd yay
            makepkg -si
            popd

            yay -Y --gendb
            yay -Syu --devel
            yay -Y --devel --save
        fi

        is_in_path golangci-lint && echo "golangci-lint-bin already installed" || yay -S golangci-lint-bin
        is_in_path pandoc && echo "pandoc-bin already installed" || yay -S pandoc-bin
        is_in_path shellcheck && echo "shellcheck-bin already installed" || yay -S shellcheck-bin
        is_in_path postman && echo "postman-bin already installed" || yay -S postman-bin
        is_in_path subl && echo "sublime-text-dev already installed" || yay -S sublime-text-dev
        is_in_path code && echo "visual-studio-code-bin already installed" || yay -S visual-studio-code-bin
        ;;
    *"Ubuntu"*)
        echo "Ubuntu detected"
        sudo apt update
        sudo apt install -y \
            build-essential git \
            curl wget zsh \
            cmake clang ninja-build erlang elixir golang \
            fonts-font-awesome fonts-powerline \
            neovim python3-neovim \
            graphviz inotify-tools pipx \
            sqlite tidy libtree-sitter0 libtree-sitter-dev \
            tmux ripgrep fd-find bat eza fzf jq \
            pandoc shellcheck

            wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
            echo "deb https://download.sublimetext.com/ apt/dev/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
            sudo apt update
            sudo apt install -y sublime-text

            sudo snap install --classic code
            sudo snap install --classic emacs

            mkdir -p /tmp/adodefont
            pushd /tmp/adodefont
            wget https://github.com/adobe-fonts/source-code-pro/archive/1.017R.zip
            unzip 1.017R.zip
            mkdir -p ~/.fonts
            cp source-code-pro-1.017R/OTF/*.otf ~/.fonts/
            fc-cache -f -v
            popd
        ;;
    *"Fedora"*)
        echo "Fedora detected"
        sudo dnf update
        sudo dnf install -y \
            git base-devel \
            curl zsh \
            cmake clang ninja-build erlang elixir golang \
            adobe-source-code-pro-fonts fontawesome-fonts \
            neovim emacs \
            graphviz inotify-tools pipx \
            sqlite tidy libtree-sitter tree-sitter-cli \
            tmux ripgrep fd-find bat eza fzf jq \
            pandoc ShellCheck

        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        sudo dnf check-update
        sudo dnf install -y code

        sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
        sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo
        sudo dnf install -y sublime-text
        ;;
    *)
        echo "Unsupported distro"
        exit 1
        ;;
esac

echo
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
echo "##################"
echo "##    NeoVim    ##"
echo "##################"
install_link .config/nvim $HOME/.config/nvim || true
if [[ -f $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim ]]; then
    echo "packer already installed"
else
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
     ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    nvim +"PackerSync" +qa
fi

echo
echo "#################"
echo "## Doom Emacs  ##"
echo "#################"
if [[ -f $HOME/.config/emacs/bin/doom ]]; then
    echo "doom emacs already installed"
elif [[ -d $HOME/.config/emacs ]]; then
    echo "$HOME/.config/emacs already exists, setting it to $HOME/.config/emacs.old"
    mv $HOME/.config/emacs $HOME/.config/emacs.old
    install_doom_emacs
else
    install_doom_emacs
fi

install_link .config/doom $HOME/.config/doom || true
$HOME/.config/emacs/bin/doom sync

echo
echo "#########"
echo "## i3  ##"
echo "#########"
if [[ -d $HOME/.config/i3 ]]; then
    echo "$HOME/.config/i3 already exists, setting it to $HOME/.config/i3.old"
    mv $HOME/.config/i3 $HOME/.config/i3.old
fi
install_link .config/i3 $HOME/.config/i3 || true

if [[ -d $HOME/.config/nitrogen ]]; then
    echo "$HOME/.config/nitrogen already exists, setting it to $HOME/.config/nitrogen.old"
    mv $HOME/.config/nitrogen $HOME/.config/nitrogen.old
fi
install_link .config/nitrogen $HOME/.config/nitrogen || true

echo
echo "#################"
echo "##    Node     ##"
echo "#################"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
. "$HOME/.nvm/nvm.sh"
nvm install --lts
nvm use --lts
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
echo "##    rust     ##"
echo "#################"
is_in_path rustup && echo "rustup already installed" || install_rust
. "$HOME/.cargo/env"
rustup update
rustup default stable
is_in_path zoxide && echo "zoxide already installed" || cargo install zoxide
is_in_path kondo && echo "kondo already installed" || cargo install kondo
is_in_path tokei && echo "tokei already installed" || cargo install tokei
is_in_path starship && echo "starship already installed" || cargo install starship --locked
is_in_path nu && echo "nu already installed" || cargo install nu
is_in_path git-delta && echo "git-delta already installed" || cargo install git-delta
is_in_path du-dust && echo "du-dust already installed" || cargo install du-dust
is_in_path eza && echo "eza already installed" || cargo install eza
is_in_path bat && echo "bat already installed" || cargo install bat
is_in_path mprocs && echo "mprocs already installed" || cargo install mprocs
is_in_path gitui && echo "gitui already installed" || cargo install gitui
is_in_path cargo-update && echo "cargo-update already installed" || cargo install cargo-update
is_in_path cargo-binstall && echo "cargo-binstall already installed" || cargo install cargo-binstall
is_in_path zellij && echo "zellij already installed" || yes | cargo binstall zellij

echo
echo "#######################"
echo "## LSP Requirements  ##"
echo "#######################"
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
is_in_path air && echo "air already installed" || go install github.com/cosmtrek/air@latest

is_in_path cmake-language-server && echo "cmake-language-server already installed" || pipx install cmake-language-server
is_in_path vscode-html-language-server && echo "vscode-langservers-extracted already installed" || npm i -g vscode-langservers-extracted
is_in_path tsc && echo "typescript already installed" || npm i -g typescript
is_in_path typescript-language-server && echo "typescript-language-server already installed" || npm i -g typescript-language-server
is_in_path vue-language-server && echo "vue-language-server already installed" || npm i -g @volar/vue-language-server

mkdir -p $HOME/System/bin
mkdir -p $HOME/System/src
export PATH=$PATH:$HOME/.cache/rebar3/bin

pushd $HOME/System/src
wget https://s3.amazonaws.com/rebar3/rebar3 && chmod +x rebar3
./rebar3 local install
git clone https://github.com/erlang-ls/erlang_ls.git
cd erlang_ls
make
PREFIX=$HOME/System make install
popd

pushd $HOME/System/src
git clone https://github.com/elixir-lsp/elixir-ls.git
cd elixir-ls
mix deps.get
MIX_ENV=prod mix compile
MIX_ENV=prod mix elixir_ls.release -o $HOME/System/bin
popd

pushd $HOME/System/src
git clone https://github.com/LuaLS/lua-language-server
cd lua-language-server
./make.sh
popd

echo
echo "#################"
echo "##  User bin   ##"
echo "#################"
install_link .gitconfig || true

echo
echo "###################"
echo "##  Wallpapers   ##"
echo "###################"
mkdir -p $HOME/System/wallpapers
install_link bsod.jpg $HOME/System/wallpapers/bsod.jpg || true
install_link desktop-1920x1080.jpg $HOME/System/wallpapers/desktop-1920x1080 || true

echo
echo "####################"
echo "##  VMWare Guest  ##"
echo "####################"
is_vmware=$(hostnamectl | grep -i "Hardware Model" | grep -i "VMware" | wc -l)
if [ $is_vmware -eq 1 ]; then
    echo "VMware Guest detected"
else
    echo "VMware not detected"
fi

echo
echo "#######################"
echo "##  Parallels Guest  ##"
echo "#######################"
is_parallels=$(hostnamectl | grep -i "Hardware Model" | grep -i "Parallels" | wc -l)
if [ $is_parallels -eq 1 ]; then
    echo "Parallels Guest detected"
    install_link vm_guests/parallels/.xinitrc $HOME/.xinitrc || true
    case $distro in
        *"Arch Linux"*)
            sudo pacman -S --needed --noconfirm open-vm-tools
            ;;
        *"Ubuntu"*)
            echo "Ubuntu detected"
            sudo apt install -y open-vm-tools-desktop
            ;;
        *"Fedora"*)
            echo "Fedora detected"
            sudo dnf install -y open-vm-tools
            ;;
        *)
            echo "Unsupported distro"
            exit 1
            ;;
    esac
    sudo systemctl enable vmtoolsd
    sudo systemctl start vmtoolsd
else
    echo "Parallels not detected"
fi

