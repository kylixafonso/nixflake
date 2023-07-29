# This module is primarily responsible for 
# setting up the desktop environment on a NixOS machine
# that doesn't manage its own DE through other means.
{ config, pkgs, inputs, system, ... }:

let
  hdmiSyncScript = pkgs.writeScript "hdmiScript" ''
    intern=$( xrandr | grep -i "edp" | cut -d" " -f1 )
    extern=$( xrandr | grep -i "hdmi" | cut -d" " -f1 )

    if xrandr | grep "$extern disconnected"; then
      xrandr --output "$extern" --off --output "$intern" --auto
    else
      xrandr --output "$extern" --primary --output "$intern" --auto
    fi
  '';
in
{
  imports = [
    ./sxhkd.nix
    ./polybar.nix
    ./bspwm.nix
    ./rofi.nix
  ];

  xsession = {
    enable = true;
    windowManager.command = "[[ -f ~/.profile ]] && . ~/.profile";
  };

  # This sort of patches everything together to make it magically work.
  home.file.".xinitrc".text =
    let
      bspwmrc = pkgs.writeText "bspwmrc" ''
        #!/bin/sh
        intern=$( xrandr | grep -i "edp" | cut -d" " -f1 )
        extern=$( xrandr | grep -i "hdmi" | cut -d" " -f1 )

        if xrandr | grep "$extern disconnected"; then
          bspc monitor "$intern" -d I II III IV V VI VII VIII IX X
        else
          bspc monitor "$extern" -d I II III IV V VI VII VIII IX
          bspc monitor "$intern" -d X
          bspc wm -O "$extern" "$intern"
        fi
        bspc config border_width         0
        bspc config window_gap           12
        bspc config split_ratio          0.52
        bspc config borderless_monocle   true
        bspc config gapless_monocle      true
      '';
      polybarScript = pkgs.writeText "polybarScript" ''
        intern=$( xrandr | grep -i "edp" | cut -d" " -f1 )
        extern=$( xrandr | grep -i "hdmi" | cut -d" " -f1 )

        if xrandr | grep "$extern disconnected"; then
          ${config.services.polybar.package}/bin/polybar default &
        else
          ${config.services.polybar.package}/bin/polybar top_external &
          ${config.services.polybar.package}/bin/polybar default &
        fi
      '';
    in
    ''
      echo "de.nix startup procedure"
      sh ${hdmiSyncScript} &&
      setxkbmap -option "grp:alt_shift_toggle" -layout "us,pt" &&
      ${config.services.sxhkd.package}/bin/sxhkd &
      xsetroot -cursor_name left_ptr &
      ${pkgs.feh}/bin/feh --bg-fill "${../assets/japan.jpg}" &
      sh ${polybarScript} &&
      # This version actually works :)
      ${pkgs.picom}/bin/picom --shadow --vsync &
      sleep 1 && sh ${bspwmrc} &
      exec ${config.xsession.windowManager.bspwm.package}/bin/bspwm
    '';
}
