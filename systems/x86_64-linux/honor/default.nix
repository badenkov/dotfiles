{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  time.timeZone = "Asia/Tbilisi";

  location.provider = "geoclue2";

  location.latitude = 41.716667;
  location.longitude = 44.783333;

  networking.hostId = "386f8e4a";
  networking.hostName = "honor";
  networking.firewall.allowedTCPPorts = [80 443 5201];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [];
  
  ###################################################################
  user.name = "badenkov";
  user.fullName = "Alexey Badenkov";
  user.email = "alexey.badenkov@gmail.com";

  desktop = {
    enable = true;
    
    sway.enable = true;
    addons.waybar.enable = true;
    addons.swww.enable = true;
  };

  laptop = true;

  ####################### DON'T CHANGE ############################
  system.stateVersion = "21.05"; # Did you read the comment?
  ##################################################################
}

