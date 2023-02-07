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

  services.xserver.videoDrivers = [ "amdgpu" ];
}
