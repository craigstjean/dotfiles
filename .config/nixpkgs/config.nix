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
}

