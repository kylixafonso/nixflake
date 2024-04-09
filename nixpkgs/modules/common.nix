{ config, pkgs, libs, ... }:
{
  # https://github.com/nix-community/nix-direnv#via-home-manager
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.enableFishIntegration = false;

  home.packages = with pkgs; [
    du-dust
    wget
    bash
    docker
    coreutils
    ripgrep
    nix
    github-cli
    file
    cachix
    brightnessctl
    glibc
    telepresence2
    pgcli
    kubectl
    gcc
    gnumake
    valgrind
    gnupg
    pinentry
  ];

  home.file = {
    ".ghci".text = ''
      :set prompt "λ> "
      :set +s
    '';

    ".haskeline".text = ''
      editMode: Vi
    '';
  };

  programs.jq.enable = true;
  programs.htop.enable = true;
}
