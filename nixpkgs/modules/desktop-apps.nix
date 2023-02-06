# This module is responsible for desktop apps
{ config, pkgs, inputs, system, ... }:
let custom-discord =
  pkgs.discord.overrideAttrs (_: rec {
    version = "0.0.21";
    src = builtins.fetchTarball {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "1pw9q4290yn62xisbkc7a7ckb1sa5acp91plp2mfpg7gp7v60zvz";
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
    ];
}
