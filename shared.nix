{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
    ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
      version = 2;
    };
  };

  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.wlo1.useDHCP = true;
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    resolvconf.dnsExtensionMechanism = false;
  };

  time = {
    timeZone = "Europe/Lisbon";
    hardwareClockInLocalTime = true;
  };

  users.users.kylix = {
    isNormalUser = true;
    extraGroups = [ "docker" "wheel" ];
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
    trusted-users = [ "kylix" ];
  };

  services = {
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };
    xserver = {
      enable = true;
      libinput.enable = true;
      displayManager.startx.enable = true;
    };
  };

  virtualisation.docker.enable = true;

  sound.enable = true;
  hardware.pulseaudio = {
    package = pkgs.pulseaudioFull;
    enable = true;
    support32Bit = true;
  };

  system.stateVersion = "23.05";
}
