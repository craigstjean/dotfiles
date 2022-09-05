{ pkgs }:
let
  inherit (pkgs) lib buildEnv;
  homeDir = builtins.getEnv "HOME";

in {
  allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg)
  [
    "vscode"
  ];

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

        myEmacs

        sqlite
      ];
    };

    myEmacs = with pkgs; buildEnv {
      name = "my-emacs";

      paths = [
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
        libvterm
        libtool
        emacsNativeComp
      ];
    };

    myVscode = with pkgs; buildEnv {
      name = "my-vscode";
      paths = [
        vscode
      ];
    };
  };
}

