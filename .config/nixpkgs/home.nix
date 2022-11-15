{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "craig";
  home.homeDirectory = "/home/craig";

  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.nixfmt

    pkgs.dejavu_fonts
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk
    pkgs.noto-fonts-emoji
    pkgs.liberation_ttf
    pkgs.fira-code
    pkgs.fira-code-symbols
    pkgs.powerline-fonts
    pkgs.powerline-symbols
    pkgs.source-code-pro
    pkgs.ubuntu_font_family

    pkgs.bat
    pkgs.exa
    pkgs.fd
    pkgs.fzf
    pkgs.fzf-zsh
    pkgs.p7zip
    pkgs.pkg-config
    pkgs.readline
    pkgs.ripgrep
    pkgs.rlwrap
    pkgs.unzip
    pkgs.zip
    pkgs.openssl
    pkgs.direnv

    pkgs.python3Full
    pkgs.vimHugeX

    pkgs.aspell
    pkgs.hunspell
    pkgs.cmake
    pkgs.gnumake
    pkgs.gnutls
    pkgs.go_1_19
    pkgs.golangci-lint
    pkgs.graphviz-nox
    pkgs.html-tidy
    pkgs.imagemagick
    pkgs.jansson
    pkgs.librsvg
    pkgs.libxml2
    pkgs.nodejs-16_x
    pkgs.pandoc
    pkgs.shellcheck
    pkgs.libvterm
    pkgs.emacsNativeComp

    pkgs.vscode

    pkgs.sqlite

    pkgs.erlangR24
    pkgs.elixir_1_14
    pkgs.inotify-tools
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.lorri.enable = true;
}

