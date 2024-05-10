{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  time.timeZone = "Asia/Tbilisi";

  networking.hostId = "fcd3ddc4";
  networking.hostName = "mechrevo";

  #boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.supportedFilesystems = [ "zfs" ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };

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
  system.stateVersion = "23.05"; # Did you read the comment?
  ##################################################################
}

