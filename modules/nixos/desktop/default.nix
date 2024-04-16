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

  config = mkIf cfg.enable (let 
    get-current-theme = (let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in pkgs.writeShellScriptBin "get-current-theme" ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings get $gnome_schema gtk-theme
    '');
    set-current-theme = (let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in pkgs.writeShellScriptBin "set-current-theme" ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme $1
    '');

    a1 = (let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in pkgs.writeShellScriptBin "a1" ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Materia'
    '');

    a2 = (let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in pkgs.writeShellScriptBin "a2" ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Materia-light'
    '');
    
    a3 = (let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in pkgs.writeShellScriptBin "a3" ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Materia-dark'
    '');

    c1 = (pkgs.catppuccin-gtk.override {
        accents = ["blue"];
        size = "standard";
        variant = "latte";
    });
    c2 = (pkgs.catppuccin-gtk.override {
        accents = ["blue"];
        size = "standard";
        variant = "mocha";
    });
    theme = pkgs.stdenvNoCC.mkDerivation {
      name = "my-super-theme";
      builder = (pkgs.writeShellScript "builder.sh" ''
        export PATH="${pkgs.coreutils}/bin"

        mkdir -p $out/share/themes
        ln -s ${pkgs.gnome.gnome-themes-extra}/share/themes/* $out/share/themes
        ln -s ${pkgs.materia-theme}/share/themes/* $out/share/themes
        ln -s ${c1}/share/themes/* $out/share/themes
        ln -s ${c2}/share/themes/* $out/share/themes
      '');
    };
    ls-themes = (pkgs.writeShellScriptBin "ls-themes" ''
      echo ${theme}

      ls ${theme}/share/themes
    '');
  in {

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

    home.extraOptions.home.packages = with pkgs; [
      libnotify

      get-current-theme
      set-current-theme
      ls-themes

      a1 a2 a3

      dracula-theme # gtk theme
      (pkgs.catppuccin-gtk.override {
          accents = ["blue"];
          size = "compact";
          variant = "mocha";
      })

    ];

    #############################
    # Пока работает так, вроде можно теперь динамически устанавливать тему
    # ls-themes
    # Adwaita       Catppuccin-Latte-Standard-Blue-Light	Catppuccin-Latte-Standard-Blue-Light-xhdpi  Catppuccin-Mocha-Standard-Blue-Dark-hdpi	HighContrast  Materia-compact  Materia-dark-compact  Materia-light-compact
    # Adwaita-dark  Catppuccin-Latte-Standard-Blue-Light-hdpi  Catppuccin-Mocha-Standard-Blue-Dark	    Catppuccin-Mocha-Standard-Blue-Dark-xhdpi	Materia       Materia-dark     Materia-light
    # set-current-theme Catppuccin-Mocha-Standard-Blue-Dark
    # set-current-theme Catppuccin-Latte-Standard-Blue-Light
    # TODO: сделать переключение в том числе и иконок. И соединить это все с dark man. И затем повесить darkman на короткую клавишу для смены светлой темы на темную. 
    #
    ############################  
    # environment.variables = {
    #   GTK_THEME = "Catppuccin-Mocha-Compact-Blue-dark";
    # };

    # home.extraOptions.gtk = {
    #   enable = true;
    #   theme = {
    #     name = "Catppuccin-Mocha-Compact-Blue-dark";
    #     package = pkgs.catppuccin-gtk.override {
    #       accents = ["blue"];
    #       size = "compact";
    #       variant = "mocha";
    #     };
    #   };
    #   iconTheme = {
    #     name = "Papirus-Dark";
    #     package = pkgs.papirus-icon-theme;
    #   };
    # };
    ############################  
    home.extraOptions = {

      gtk = {
        enable = true;
        # theme = {
        #   name = "Materia-dark";
        #   package = pkgs.materia-theme;
        # };

        # theme = {
        #   name = "Adwaita";
        #   package = pkgs.gnome.gnome-themes-extra;
        # };
        theme = {
          name = "Materia";
          package = theme;
        };

        # theme = {
        #   name = "Catppuccin-Frappe-Standard-Green-Dark";
        #   package = pkgs.catppuccin-gtk.override {
        #     accents = [ "green" ];
        #     size = "standard";
        #     tweaks = [ "normal" ];
        #     variant = "frappe";
        #   };
        # };

        # theme = {
        #   name = "Dracula";
        #   package = pkgs.dracula-theme;
        # };

        # iconTheme = {
        #   name = "Adwaita-Dark";
        #   package = pkgs.gnome3.adwaita-icon-theme; # default gnome cursors
        # };

        iconTheme = {
          name = "Papirus";
          package = pkgs.papirus-icon-theme; # default gnome cursors
        };
      };
    };


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
  });
}
