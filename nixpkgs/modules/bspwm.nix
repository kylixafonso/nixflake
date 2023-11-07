# The bspwm window manager home-manager module
{ lib, config, pkgs, ... }:
{
  xsession = {
    enable = true;
  };

  home.packages = [ config.xsession.windowManager.bspwm.package ];

  xdg.enable = true;
}
