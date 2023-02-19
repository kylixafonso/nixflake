{
  description = "Home Manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    nixpkgs-latest.url = "github:NixOS/nixpkgs/master";
    nixpkgs-21_11.url = "github:NixOS/nixpkgs/21.11";
    nixpkgs-pin1.url = "github:NixOS/nixpkgs?rev=c2e7745b08a303b468fcaced4bf0774900aba9bc";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    rnix-lsp.url = "github:nix-community/rnix-lsp";
  };

  outputs = inputs:
    {
      homeConfigurations = {
        msi = inputs.home-manager.lib.homeManagerConfiguration rec {
          pkgs = import inputs.nixpkgs { localSystem = "x86_64-linux"; };
          extraSpecialArgs = { inherit inputs; system = "x86_64-linux"; };
          modules = [
            {
              home = {
                homeDirectory = "/home/kylix";
                username = "kylix";
                stateVersion = "22.11";
              };
            }
            ./modules/home-manager.nix
            ./modules/common.nix
            ./modules/zsh.nix
            ./modules/neovim.nix
            ./modules/git.nix
            ./modules/kitty.nix
            ./modules/de.nix
            ./modules/desktop-apps.nix
            ./modules/nixpkgs.nix
            ./modules/user-theme
            ./modules/msi/desktop-apps.nix
          ];
        };
        hp = inputs.home-manager.lib.homeManagerConfiguration rec {
          pkgs = import inputs.nixpkgs { localSystem = "x86_64-linux"; };
          extraSpecialArgs = { inherit inputs; system = "x86_64-linux"; };
          modules = [
            {
              home = {
                homeDirectory = "/home/kylix";
                username = "kylix";
                stateVersion = "22.11";
              };
            }
            ./modules/home-manager.nix
            ./modules/common.nix
            ./modules/zsh.nix
            ./modules/neovim.nix
            ./modules/git.nix
            ./modules/kitty.nix
            ./modules/de.nix
            ./modules/desktop-apps.nix
            ./modules/nixpkgs.nix
            ./modules/user-theme
            ./modules/hp/desktop-apps.nix
            ./modules/hp/minecraft-server.nix
          ];
        };
      };
    };
}

