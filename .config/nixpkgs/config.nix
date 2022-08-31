{ pkgs }:
let
  inherit (pkgs) lib buildEnv;
  homeDir = builtins.getEnv "HOME";

in {
  allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg)
  [
    "vscode"
  ];

  programs.dconf.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    gedit
    gnome-software
    gnome-music
    simple-scan
    totem
    epiphany
    geary
  ]);

  fonts.fonts = with pkgs; [
    dejavu_fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    powerline-fonts
    source-code-pro
    ubuntu_font_family
  ];
  fonts.fontDir.enable = true;

  packageOverrides = nixpkgs: with nixpkgs; rec {
    myPackages = with pkgs; buildEnv {
      name = "my-packages";

      paths = [
        fd
        ripgrep
        fzf
        fzf-zsh
        unzip
        zip
        nixfmt

        python3Full
        vimHugeX

        emacsNativeComp
        gnutls
        librsvg
        libvterm
        libxml2
        html-tidy
        shellcheck
        pandoc
        graphviz-nox
        imagemagick
        go_1_18
        golangci-lint
        jansson
        aspell
        hunspell
        cmake
        gnumake
        
        sqlite
      ];
    };

    myDesktop = with pkgs; buildEnv {
      name = "my-desktop";
      paths = [
        gnome.gnome-session.sessions
        at-spi2-core

        fontconfig
        dejavu_fonts
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
        powerline-fonts
        source-code-pro
        ubuntu_font_family
      ];
    };

    myVscode = with pkgs; buildEnv {
      name = "my-vscode";
      paths = [
        vscode
      ];
    };

    myCpp = with pkgs; buildEnv {
      name = "my-cpp";
      paths = [
        clang_14
        ninja
        autogen
        autoconf
        automake
      ];
    };

    myDlang = with pkgs; buildEnv {
      name = "my-dlang";
      paths = [
        dmd
        dub
        ldc
      ];
    };

    myElixir = with pkgs; buildEnv {
      name = "my-elixir";
      paths = [
        erlang
        elixir
        inotify-tools
      ];
    };

    myDotnet = with pkgs; buildEnv {
      name = "my-dotnet";
      paths = [
        dotnet-sdk
      ];
    };
  };
}

