{ config, pkgs, inputs, system, ... }:
{
  home.packages =
    with pkgs; [
      jetbrains.idea-ultimate
      prismlauncher
    ];
}
