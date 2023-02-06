{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
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
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time = {
    timeZone = "Europe/Lisbon";
    hardwareClockInLocalTime = true;
  };

  users.users.kylix = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "kylix" ];
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    libinput.enable = true;
    displayManager.startx.enable = true;
  };
  system.stateVersion = "22.11";
}
