{ pkgs }:
let
  inherit (pkgs) lib buildEnv;
  homeDir = builtins.getEnv "HOME";

in {
  allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg)
  [
    "rar"
    "unrar"
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
    powerline-symbols
    source-code-pro
    ubuntu_font_family
  ];
  fonts.fontDir.enable = true;

  packageOverrides = nixpkgs: with nixpkgs; rec {
    myPackages = with pkgs; buildEnv {
      name = "my-packages";

      paths = [
        nixfmt

        bat
        exa
        fd
        fzf
        fzf-zsh
        p7zip
        pkg-config
        readline
        ripgrep
        rlwrap
        unrar
        unzip
        zip

        fish
        powershell

        python3Full
        vimHugeX

        aspell
        cmake
        gnumake
        gnutls
        go_1_18
        golangci-lint
        graphviz-nox
        html-tidy
        hunspell
        imagemagick
        jansson
        librsvg
        libxml2
        pandoc
        shellcheck
        emacsNativeComp
        
        sqlite
      ] ++ (if pkgs.system == "aarch64-darwin"
      then [
        #macvim
        #vlc
      ] else [ libvterm ]);
    };

    myDesktop = with pkgs; buildEnv {
      name = "my-desktop";
      paths = [
        gnome.gnome-session.sessions
        at-spi2-core

        fontconfig
      ] ++ config.fonts.fonts;
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
        protobuf
      ];
    };

    myDlang = with pkgs; buildEnv {
      name = "my-dlang";
      paths = [
        dub
        ldc
      ] ++ (if pkgs.system == "aarch64-darwin"
      then [ ]
      else [ dmd ]);
    };

    myElixir = with pkgs; buildEnv {
      name = "my-elixir";
      paths = [
        erlang
        elixir
      ] ++ (if pkgs.system == "aarch64-darwin"
      then [ ]
      else [ inotify-tools ]);
    };

    myDotnet = with pkgs; buildEnv {
      name = "my-dotnet";
      paths = [
        dotnet-sdk
      ];
    };

    myRuby = with pkgs; buildEnv {
      name = "my-ruby";
      paths = [
        rbenv
      ];
    };

    myLisp = with pkgs; buildEnv {
      name = "my-lisp";
      paths = [
        sbcl
        lispPackages.quicklisp
      ];
    };
  };
}

