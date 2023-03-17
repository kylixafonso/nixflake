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
    extraGroups = [ "wheel" ];
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
    trusted-users = [ "kylix" ];
  };

  services.xserver = {
    enable = true;
    libinput.enable = true;
    displayManager.startx.enable = true;
  };

  sound.enable = true;
  hardware.pulseaudio = {
    package = pkgs.pulseaudioFull;
    enable = true;
    support32Bit = true;
  };

  system.stateVersion = "22.11";
}
