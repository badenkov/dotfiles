{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.desktop.hyprland;
in {
  options.desktop.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, it will be installed desktop environment
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
    environment.systemPackages = with pkgs; [
      kitty

      gtklock

      grim
      slurp
      swappy
      imagemagick

      (writeShellScriptBin "screenshot" ''
        grim -g "$(slurp)" - | convert - -shave 1x1 PNG:- | wl-copy
      '')
      (writeShellScriptBin "screenshot-edit" ''
        wl-paste | swappy -f -
      '')

      (writeShellScriptBin "cwd-by-pid" ''
        # how far down does the rabbit hole go? D:
        PID=$1

        while pgrep -P "$PID" >/dev/null; do
          PID=$(pgrep -P "$PID" | tail -n1)
        done

        # Show the current working directory
        readlink -e "/proc/$PID/cwd"
      '')

      (writeShellScriptBin "cwd-of-activewindow" ''
        PID=$(hyprctl activewindow -j | jq .pid)

        if [[ $PID == "null" ]]; then
          echo $HOME
        else
          echo $(cwd-by-pid $PID)
        fi
      '')

      #pulseaudio
    ];

    programs.hyprland.enable = true;
    programs.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    programs.hyprland.portalPackage = inputs.xdgh.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

    programs.hyprland.xwayland.enable = true;
    home.extraOptions.wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      settings = {
        exec-once = [
          "/usr/bin/env swww init"
        ];

        monitor = [
          "eDP-1,2880x1800,1920x0,2"
          "HDMI-A-1,1920x1080,0x0,1"
          ",preferred,auto,auto"
        ];
        input = {
          kb_layout = "us,ru";
          kb_options = "ctrl:nocaps,grp:toggle";

          follow_mouse = "1";
          touchpad = {
            natural_scroll = "yes";
          };
        };
        general = {
          gaps_in = 1;
          gaps_out = 0;
          border_size = 2;
          layout = "master";
        };
        master = {
          mfact = "0.7";
          new_is_master = "false";
        };

        decoration = {
          rounding = 2;
        };

        animations = {
          enabled = "0";
        };

        gestures = {
          workspace_swipe = "on";
        };

        "$mod" = "SUPER";

        bind = [
          "$mod SHIFT, RETURN, exec, foot --working-directory \"$(cwd-of-activewindow)\""
          "$mod, Q, killactive,"
          "$mod, SPACE, togglefloating,"
          #"$mod, P, exec, wofi --show drun"
          "$mod, P, exec, bemenu-run"
          "$mod, F, fullscreen"
          "$mod, TAB, pseudo"

          "$mod SHIFT, E, exec, wlogout -b 1 -p layer-shell"
          "$mod SHIFT, BACKSPACE, exec, swaylock -c 000000"
          "$mod SHIFT, C, exec, wallpaper"
          
          ", code:107, exec, screenshot"
          "$mod, code:107, exec, screenshot-edit"

           # Move focus with mainMod + arrow keys"
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"

          "$mod, COMMA, focusmonitor, l"
          "$mod, PERIOD, focusmonitor, r"

          # Move window with mainMod_SHIFT + arrow keys
          "$mod_SHIFT, h, movewindow, l"
          "$mod_SHIFT, l, movewindow, r"
          "$mod_SHIFT, k, movewindow, u"
          "$mod_SHIFT, j, movewindow, d"

          "$mod_SHIFT, COMMA,movecurrentworkspacetomonitor , l"
          "$mod_SHIFT, PERIOD, movecurrentworkspacetomonitor, r"

          # Switch workspaces with mainMod + [0-9]
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"

          # Scroll through existing workspaces with mainMod + scroll
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"

          "$mod, o, exec, foot yazi"
          #"$mod, F11, exec, foot -a nmtui nmtui" # убрал, так как плохо работает  

          # copy class of current window
          "$mod SHIFT, F12, exec, hyprctl -j activewindow | jq .class | wl-copy"
          # copy title of current window
          "$mod CTRL, F12, exec, hyprctl -j activewindow | jq .title | wl-copy"

          # For master layout
          "$mod, RETURN, layoutmsg, swapwithmaster"
          "$mod CTRL, RETURN, layoutmsg, focusmaster"
          "$mod CTRL, MINUS, layoutmsg, removemaster"
          "$mod CTRL, EQUAL, layoutmsg, addmaster"
        ];
        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        binde = [
          # Audio binds
          ", XF86AudioRaiseVolume, exec, pamixer -i 5"
          ", XF86AudioLowerVolume, exec, pamixer -d 5"
          ", XF86AudioMute,        exec, pamixer -t"

          # Windows resize
          "$mod CTRL, h, resizeactive, -10 0"
          "$mod CTRL, l, resizeactive, 10 0"
          "$mod CTRL, k, resizeactive, 0 -10"
          "$mod CTRL, j, resizeactive, 0 10"

        ];

        workspace = [
          "1, layoutopt:orientation:bottom"
        ];

        windowrule = [
          "workspace 1,^(brave-browser)$"
          "workspace 10,^(Logseq)$"
        ];
        windowrulev2 = [
          "float,class:(nmtui)"
          "size 60% 70%,class:(nmtui)"
          "move 20% 15%,class:(nmtui)"
        ];
      };
    };

    # home.configFile = {
    #   "hypr/launch".source = ./launch;
    #   "hypr/hyprland.conf".source = ./hyprland.conf;
    # };
  };
}
