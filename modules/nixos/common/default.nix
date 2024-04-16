{ config, pkgs, lib, ... }:

with lib;
{
  config = {
    networking = {
      networkmanager.enable = true;
      networkmanager.plugins = [
        pkgs.networkmanager-openvpn
      ];

      wireguard.enable = true;
      firewall.logReversePathDrops = true;

      # The global useDHCP flag is deprecated, therefore explicitly set to false here.
      useDHCP = false;

      extraHosts = ''
        127.0.0.1 lvh.me firm1.lvh.me
        116.203.133.168 badenkov.example
      '';
      #172.20.0.1 portal2.captive.network captive.network network
    };

    i18n.defaultLocale = "en_US.UTF-8";
    # console = {
    #   font = "UniCyrExt_8x16";
    #   #keyMap = "us";
    #   useXkbConfig = true;
    # };

    # services.xserver.enable = true;
    # services.xserver.layout = "us,ru";
    # services.xserver.xkbModel = "pc86";
    # services.xserver.xkbOptions = "ctrl:nocaps,grp:toggle";

    services.openssh.enable = true;

    environment.systemPackages = with pkgs; [
      vial # An Open-source GUI and QMK fork for configuring your keyboard in real time
    ];

    # For vial
    services.udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';
  };
}
