# This module is primarily responsible for 
# setting up the desktop environment on a NixOS machine
# that doesn't manage its own DE through other means.
{ config, pkgs, inputs, system, ... }:

let
  displaySyncScript = pkgs.writeScript "displaySyncScript" ''
    #!/bin/sh
    intern=$( xrandr | grep -i "edp" | cut -d" " -f1 )
    # FIXME: Hardcoded
    extern0="DP-1"
    extern1=$( xrandr | grep -i "hdmi" | cut -d" " -f1 )

    # FIXME: Unoptimal logic
    if [[ $( xrandr ) == *"$extern0 disconnected"* ]] && [[ $( xrandr ) == *"$extern1 disconnected"* ]]; then
      xrandr \
        --output "$intern" \
          --auto \
        --output "$extern0" \
          --off \
        --output "$extern1" \
          --off
    else
      if [[ $( xrandr ) == *"$extern0 disconnected"* ]]; then
        xrandr \
          --output "$intern" \
            --auto \
            --left-of "$extern1" \
          --output "$extern0" \
            --off \
          --output "$extern1" \
            --primary \
            --mode 1920x1080 \
            --rate 74.97
      else
        if [[ $( xrandr ) == *"$extern1 disconnected"* ]]; then
          xrandr \
            --output "$intern" \
              --auto \
              --left-of "$extern0" \
            --output "$extern0" \
              --primary \
              --mode "2560x1440" \
              --rate 155 \
            --output "$extern1" \
              --off
        else
          xrandr \
            --output "$intern" \
              --auto \
              --left-of "$extern0" \
            --output "$extern0" \
              --primary \
              --mode "2560x1440" \
              --rate 155 \
              --left-of "$extern1" \
              --auto \
            --output "$extern1" \
              --mode 1920x1080 \
              --rate 74.97 \
              --pos 4480x0 \
              --auto
        fi
      fi
    fi
  '';
in
{
  imports = [
    ./sxhkd.nix
    ./polybar.nix
    ./rofi.nix
    ./bspwm.nix
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
        # FIXME: Hardcoded
        extern0="DP-1"
        extern1=$( xrandr | grep -i "hdmi" | cut -d" " -f1 )

        # FIXME: Unoptimal logic
        if [[ $( xrandr ) == *"$extern0 disconnected"* ]] && [[ $( xrandr ) == *"$extern1 disconnected"* ]] ; then
          bspc monitor "$intern" -d I II III IV V VI VII VIII IX X
        else
          if [[ $( xrandr ) == *"$extern1 disconnected"* ]] ; then
            bspc monitor "$extern0" -d I II III IV V VI VII VIII IX
            bspc monitor "$intern" -d X
            bspc wm -O "$intern" "$extern0"
          else
            if [[ $( xrandr ) == *"$extern0 disconnected"* ]] ; then
              bspc monitor "$extern1" -d I II III IV V VI VII VIII IX
              bspc monitor "$intern" -d X
              bspc wm -O "$intern" "$extern1"
            else
              bspc monitor "$extern0" -d I II III IV V
              bspc monitor "$extern1" -d VI VII VIII IX
              bspc monitor "$intern" -d X
              bspc wm -O "$extern0" "$extern1"
            fi
          fi
        fi
        bspc config border_width         0
        bspc config window_gap           12
        bspc config split_ratio          0.52
        bspc config borderless_monocle   true
        bspc config gapless_monocle      true
      '';
      polybarScript = pkgs.writeText "polybarScript" ''
        #!/bin/sh
        for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
          MONITOR=$m ${config.services.polybar.package}/bin/polybar --reload default &
        done
      '';
    in
    ''
      echo "de.nix startup procedure"
      sh ${displaySyncScript} &&
      setxkbmap -option "grp:alt_shift_toggle" -layout "us,pt" &&
      ${config.services.sxhkd.package}/bin/sxhkd &
      xsetroot -cursor_name left_ptr &
      ${pkgs.feh}/bin/feh --bg-fill "${../assets/planet.png}" &
      sh ${polybarScript} &&
      # This version actually works :)
      ${pkgs.picom}/bin/picom --shadow --vsync &
      sleep 1 && sh ${bspwmrc} &
      exec ${config.xsession.windowManager.bspwm.package}/bin/bspwm
    '';
}
