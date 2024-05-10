{ pkgs, lib, config, ... }: 

with lib;
let
  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Catppuccin-Mocha-Standard-Lavender-Dark'
      gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    '';
  };
  configure-gtk1 = pkgs.writeTextFile {
    name = "configure-gtk1";
    destination = "/bin/configure-gtk1";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Catppuccin-Latte-Standard-Lavender-Light'
      gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    '';
  };
  get-gtk = pkgs.writeTextFile {
    name = "get-gtk";
    destination = "/bin/get-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings get $gnome_schema gtk-theme
    '';
  };
  fn = k: v: { 
    pos = "${builtins.toString v.x} ${builtins.toString v.y} res ${builtins.toString v.width}x${builtins.toString v.height}";
    scale = builtins.toString v.scale; 
  };
  outputs = lib.attrsets.mapAttrs fn config.desktop.outputs;
  homeModule = { config, ... }: {
    wayland.windowManager.sway = {
      enable = true;
      #package = pkgs.sway-unwrapped;
      systemd.enable = true;

      config = rec {
        modifier = "Mod4";
        left = "h";
        down = "j";
        up = "k";
        right = "l";

        terminal = "kitty";
        menu = "bemenu-run";

        bindkeysToCode = true;
        keybindings = {
          "${modifier}+Shift+Return" = "exec ${terminal} --working-directory `swaycwd`";

          "${modifier}+q" = "kill";
          "${modifier}+p" = "exec $menu";

          "${modifier}+${left}" = "focus left";
          "${modifier}+${down}" = "focus down";
          "${modifier}+${up}" = "focus up";
          "${modifier}+${right}" = "focus right";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+${left}" = "move left";
          "${modifier}+Shift+${down}" = "move down";
          "${modifier}+Shift+${up}" = "move up";
          "${modifier}+Shift+${right}" = "move right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+a" = "focus parent";

          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 0";

          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 0";

          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          "${modifier}+r" = "mode resize";

          "${modifier}+Comma" = "focus output left";
          "${modifier}+Period" = "focus output right";

          "${modifier}+Shift+Comma" = "move workspace to output left";
          "${modifier}+Shift+Period" = "move workspace to output right";

          "XF86AudioLowerVolume" = "exec pamixer -d 2";
          "XF86AudioRaiseVolume" = "exec pamixer -i 2";
          "XF86AudioMute" = "exec pamixer -t";
          "${modifier}+F4" = "exec pamixer -t";
        
          "${modifier}+Backspace" = "exec darkman toggle";
          "${modifier}+Shift+Backspace" = "exec swaylock -c 000000";

          "${modifier}+i" = "exec pkill -USR2 -u $USER waybar || true";

          "Print" = "exec screenshot";
          "${modifier}+Print" = "exec screenshot-edit";

          "F12" = "exec wallpapper";
          # Configure monitors and save their configurations in files
          "${modifier}+F12" = "exec nwg-displays";
          # Show focused window info
          "${modifier}+Shift+F12" = "exec swaymsg -t get_tree | jq '.. | (.nodes? // empty)[] | select(.focused==true)' | swaynag -m \"Window Info\" -l";
        };

        input = {
          "type:keyboard" = {
            xkb_layout = "us,ru";
            xkb_model = "pc105";
            #xkb_options = "ctrl:nocaps,grp:switch";
            xkb_options = "ctrl:nocaps,grp:toggle";
            xkb_variant = "\"\"";
          };

          "type:touchpad" = {
            dwt = "true";
            natural_scroll = "true";
            tap = "true";
          };
        };

        # output = {
        #   "*" = {
        #     bg = "${./wallpapers/pexels-steve-johnson-1416367.jpg} fill";
        #   };
        # } // outputs;
        #

        bars = [];
      };

      extraConfig = ''
        font pango:Sans 14px

        show_marks yes

        gaps outer 0px
        gaps inner 0px

        smart_borders no_gaps
        default_border pixel 2
        default_floating_border pixel 2

        exec configure-gtk
        exec dbus-sway-environment

        include ${config.home.homeDirectory}/.config/sway/colors
        include ${config.home.homeDirectory}/.config/sway/outputs

        include ${config.home.homeDirectory}/.sway.local
      '';
    };

    home.activation.mySwayActionScript = ''
      test -f ${config.home.homeDirectory}/.sway.local || touch ${config.home.homeDirectory}/.sway.local
      test -f ${config.home.homeDirectory}/.config/sway/colors || touch ${config.home.homeDirectory}/.config/sway/colors
      test -f ${config.home.homeDirectory}/.config/sway/outputs || touch ${config.home.homeDirectory}/.config/sway/outputs
    '';

    services.darkman = let
      h = config.home.homeDirectory;
    in {
      lightModeScripts.waybar = ''
        cp -f ${./light} ${h}/.config/sway/colors
        swaymsg reload
      '';
      darkModeScripts.waybar = ''
        cp -f ${./dark} ${h}/.config/sway/colors
        swaymsg reload
      '';
    };


    # Day/night gamma adjustments
    services.wlsunset = {
      enable = true;
      # Tbilisi
      latitude = "41.71";
      longitude = "44.78";
    };
  };

  cfg = config.desktop.sway;
in {
  options.desktop.sway = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, it will be installed desktop environment
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    environment.systemPackages = with pkgs; [


      nwg-displays

      swayimg # Image viewer for Sway/Wayland 

      mako # notification system developed by swaywm maintainer
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      wev # Wayland event viewer

      bemenu # wayland clone of dmenu

      pamixer

      lswt # A command that lists Wayland toplevels

      wlr-randr
      way-displays # Auto Manage Your Wayland Displays

      #unstable.shotman ## Хрень какая то не рабочая для скриншотов
      #fusuma # Глянуть программу для жестов на тачпад
      ####


      xdg-utils # for opening default programs when clicking links

      glib # gsettings
      swaylock
      swayidle

      grim # screenshot functionality
      slurp # screenshot functionality

      cliphist #Wayland clipboard manager

      sway-contrib.grimshot # sway-contrib.grimshot

      swaycwd
      swayws
      swaysome
      autotiling-rs

      wofi

      # scripts
      configure-gtk
      configure-gtk1
      get-gtk
      dbus-sway-environment
    ];

    home-manager.users.badenkov.imports = [ homeModule ];

    environment.etc."ttt.json".text = (builtins.toJSON outputs);
  };
}
