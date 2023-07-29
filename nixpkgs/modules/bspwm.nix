# The bspwm window manager home-manager module
{ lib, config, pkgs, ... }:
{
  xsession = {
    enable = true;
    # windowManager.command = "${config.xsession.windowManager.bspwm.package}/bin/bspwm";
  };

  home.packages = [ config.xsession.windowManager.bspwm.package ];

  xdg = {
    enable = true;
    configFile = {
      "bspwm/bspwmrc".text = ''
        #!/bin/sh
        intern=$( xrandr | grep -i "edp" | cut -d" " -f1 )
        extern=$( xrandr | grep -i "hdmi" | cut -d" " -f1 )

        if xrandr | grep "$extern disconnected"; then
          bspc monitor "$intern" -d I II III IV V VI VII VIII IX X
        else
          bspc monitor "$extern" -d I II III IV V VI VII VIII IX
          bspc monitor "$intern" -d X
          bspc wm -O "$EXTERNAL_MONITOR" "$INTERNAL_MONITOR"
        fi
        bspc config border_width         0
        bspc config window_gap           12
        bspc config split_ratio          0.52
        bspc config borderless_monocle   true
        bspc config gapless_monocle      true
      '';
    };
  };
}




