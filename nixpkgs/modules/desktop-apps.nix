# This module is responsible for desktop apps
{ config, pkgs, inputs, system, ... }:
let custom-discord =
  pkgs.discord.overrideAttrs (_: rec {
    version = "0.0.32";
    src = builtins.fetchTarball {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "0qzdvyyialvpiwi9mppbqvf2rvz1ps25mmygqqck0z9i2q01c1zd";
    };
  });
in
{
  home.packages =
    with pkgs; [
      brave
      custom-discord
      spotify
      pavucontrol
      slack
      vscode
      gimp
      openvpn
      libreoffice
      staruml
    ];
}
