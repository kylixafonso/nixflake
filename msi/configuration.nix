{ config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
    ];

  boot = {
    kernelParams = [ "i915.force_probe=46a6" ];
    loader = {
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
  };

  networking = {
    hostName = "msi-nixos";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.wlo1.useDHCP = true;
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
    nvidia-offload
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "kylix" ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "nvidia-x11"
    "nvidia-settings"
  ];

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    libinput.enable = true;
    displayManager.startx.enable = true;
  };

  hardware = {
    opengl.enable = true;
    nvidia.prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  system.stateVersion = "22.11";
}
