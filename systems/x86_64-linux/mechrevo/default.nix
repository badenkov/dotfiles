# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  time.timeZone = "Asia/Tbilisi";

  networking.hostId = "fcd3ddc4";
  networking.hostName = "mechrevo";

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
    hyprland.enable = true;
    gnome.enable = true;

    # addons.waybar.enable = true;
    addons.swww.enable = true;

    outputs = {
      "eDP-1" = {
        x = 1920;
        y = 0;
        width = 2880;
        height = 1800;
        scale = 2;
      };
      "HDMI-A-1" = {
        x = 0;
        y = 0;
        width = 1920;
        height = 1080;
        scale = 1;
      };
    };
  };

  laptop = true;

  ####################### DON'T CHANGE ############################
  system.stateVersion = "23.05"; # Did you read the comment?
  ##################################################################
}

