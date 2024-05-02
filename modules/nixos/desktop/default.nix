{ config, lib, pkgs, ... }: 

with lib;
let
  cfg = config.desktop;
in {
  options.desktop = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, it will be installed desktop environment
      '';
    };

    outputs = mkOption {
      description = "Outputs";
      default = {};
      type = types.attrsOf (types.submodule {
        options = {
          x = mkOption {
            type = types.int;
            default = 0;
          };
          y = mkOption {
            type = types.int;
            default = 0;
          };
          width = mkOption {
            type = types.int;
            default = 1920;
          };
          height = mkOption {
            type = types.int;
            default = 1080;
          };
          scale = mkOption {
            type = types.int;
            default = 1;
          };
        };
      });
    };
  };

  config = mkIf cfg.enable {
    programs.thunar.enable = true;
    programs.thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];

    services.udisks2.enable = mkDefault true;
    services.devmon.enable = mkDefault true;

    services.gvfs.enable = mkDefault true; # Mount, trash and other functionalities ????
    services.tumbler.enable = mkDefault true; # ??????

    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.gdm.wayland = true;
    #services.xserver.displayManager = {
    #  gdm.enable = mkDefault true;
    #  gdm.wayland = mkDefault true;
    #};

    home.extraOptions.services.udiskie = {
      enable = true;
    };

    environment.systemPackages = with pkgs; let 
      schreenshot = (writeShellScriptBin "screenshot" ''
        ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.imagemagick}/bin/convert - -shave 1x1 PNG:- | wl-copy
      '');

      schreenshot-edit = (writeShellScriptBin "screenshot-edit" ''
        wl-paste | ${pkgs.swappy}/bin/swappy -f -
      '');
    in [
      pavucontrol
      libcamera

      ### Browsers
      nyxt # Infinitely extensible web-browser (with Lisp development files using WebKitGTK platform port)
      brave
      chromium
      firefox

      schreenshot
      schreenshot-edit
    ];

    # xdg-desktop-portal works by exposing a series of D-Bus interfaces
    # known as portals under a well-known name
    # (org.freedesktop.portal.Desktop) and object path
    # (/org/freedesktop/portal/desktop).
    # The portal interfaces include APIs for file access, opening URIs,
    # printing and others.
    services.dbus.enable = true;

    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    # это вроде как автоматом влючается если pgrams.hyperland.enable = true
    # xdg.portal = {
    #   enable = true;
    #   wlr.enable = true;
    #   # gtk portal needed to make gtk apps happy
    #   extraPortals = with pkgs; [
    #     xdg-desktop-portal-gtk
    #     xdg-desktop-portal-hyprland
    #   ];
    # };
  };
}
