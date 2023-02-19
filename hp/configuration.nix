{ config, pkgs, ... }:

{
  imports =
    [
      ../shared.nix
    ];

  networking.hostName = "hp-nixos";

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  services = {
    xserver.videoDrivers = [ "amdgpu" ];

    minecraft-server = {
      enable = true;
      eula = true;

      package =
        let
          version = "1.19.3";
          url = "https://piston-data.mojang.com/v1/objects/c9df48efed58511cdd0213c56b9013a7b5c9ac1f/server.jar";
          sha256 = "";
        in
        (pkgs.minecraft-server_1_19_3.overrideAttrs (old: rec {
          name = "minecraft-server-${version}";
          inherit version;

          src = pkgs.fetchurl {
            inherit url sha256;
          };
        }));
    };
  };
}
