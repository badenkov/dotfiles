{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  time.timeZone = "Asia/Tbilisi";
  networking.hostName = "lenovo";

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-id/nvme-WDC_PC_SN530_SDBPMPZ-512G-1101_22015T804329-part1";
      preLVM = true;
    };
  };

  fileSystems."/" =
    { device = "rpool/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "rpool/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/073D-0630";
      fsType = "vfat";
    };

  swapDevices = [ ];

  networking.hostId = "08de8a39";

  ##################################################################
  user.name = "badenkov";
  user.fullName = "Alexey Badenkov";
  user.email = "alexey.badenkov@gmail.com";

  desktop = {
    enable = true;
    outputs = {
      "eDP-1" = {
        x = 1920;
        y = 0;
        width = 1920;
        height = 1080;
        scale = 1;
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

