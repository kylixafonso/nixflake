# This module is responsible for desktop apps
{ config, pkgs, inputs, system, ... }:
let custom-discord =
  pkgs.discord.overrideAttrs (_: rec {
    version = "0.0.24";
    src = builtins.fetchTarball {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "087p8z538cyfa9phd4nvzjrvx4s9952jz1azb2k8g6pggh1vxwm8";
    };
  });
in
{
  home.packages =
    with pkgs; [
      brave
      custom-discord
      spotify
      ledger-live-desktop
      pavucontrol
      vlc
      libreoffice
      stremio
      zoom-us
      slack
    ];
}
