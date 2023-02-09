# This module is responsible for msi desktop apps
{ config, pkgs, inputs, system, ... }:
{
  home.packages =
    with pkgs; [
      jetbrains.idea-ultimate
    ];
}
