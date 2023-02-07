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
      xrandr --output "$intern" --off --output "$extern" --auto
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
        bspc monitor -d I II III IV V VI VII VIII IX X
        bspc config border_width         0
        bspc config window_gap           48
        bspc config split_ratio          0.52
        bspc config borderless_monocle   true
        bspc config gapless_monocle      true
      '';
    in
    ''
      echo "de.nix startup procedure"
      sh ${hdmiSyncScript} &&
      ${config.services.sxhkd.package}/bin/sxhkd &
      xsetroot -cursor_name left_ptr &
      ${pkgs.feh}/bin/feh --bg-fill "${../assets/japan.jpg}" &
      ${config.services.polybar.package}/bin/polybar default &
      # This version actually works :)
      ${pkgs.picom}/bin/picom --shadow --vsync &
      sleep 1 && sh ${bspwmrc} &
      exec ${config.xsession.windowManager.bspwm.package}/bin/bspwm
    '';
}
