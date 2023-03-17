# This module is responsible for desktop apps
{ config, pkgs, inputs, system, ... }:
let custom-discord =
  pkgs.discord.overrideAttrs (_: rec {
    version = "0.0.25";
    src = builtins.fetchTarball {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "12yrhlbigpy44rl3icir3jj2p5fqq2ywgbp5v3m1hxxmbawsm6wi";
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
