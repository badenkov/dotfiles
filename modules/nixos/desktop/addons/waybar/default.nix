{ inputs, config, lib, system, pkgs, ... }: 

with lib;
let
  cfg = config.desktop.addons.waybar;
in {
  options.desktop.addons.waybar = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        If enabled, it will be installed waybar
      '';
    };
  };

  config = mkIf cfg.enable {
    home.extraOptions = {
      programs.waybar.enable = true;
      programs.waybar.systemd.enable = true;
      #programs.waybar.package = inputs.waybar.packages.${system}.default;
      programs.waybar = {
        style = ./style.css;

        settings.mainBar = {
          name = "main";

          layer = "bottom";
          position = "top";
          height = 30;

          modules-left = [ "sway/workspaces" "sway/mode"];
          modules-center = [ "sway/window" ];
          modules-right = [ "tray" "pulseaudio" "battery" "clock" "sway/language"];
          #"tray"];

          # "hyprland/workspaces" = {
          #   "format" = "{name}";
          # };
          # "hyprland/window" = {
          #   "max-length" = "200";
          #   "separate-outputs" = true;
          # };
          # "hyprland/language" = {
          #     "keyboard-name" = "at-translated-set-2-keyboard";
          # };

          "sway/workspaces" = {
            format = "{name}";
            disable-scroll = true;
          };
          "sway/mode" = {
            format = " {}";
          };
          "sway/window" = {
            "max-length" = "80";
            "tooltip" = false;

            "rewrite" = {
              "nvim (.*)" =  "  $1";
              "(.*) - Brave" = "󰇧  $1 - Brave";
            };
          };
          "sway/language" = {
            format = "{flag}";
            on-click = "swaymsg input type:keyboard xkb_switch_layout next";
          };

          clock = {
            format = "{:%a %d %b %H:%M}";
            tooltip = false;
          };

          battery = {
            format = "{capacity}% {icon} ";
            #format-alt = "{time} {icon}";
            format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            format-charging = "{capacity}% 󰂄";
            format-plugged = "{capacity}% 󰚥";

            interval =  30;

            states = {
              warning = 25;
              critical = 1;
            };
            tooltip = false;
          };

          pulseaudio = {
            format = "{volume}% {icon}  {format_source}";
            format-muted = "󰝟  {format_source}";

            format-source = "󰍬";
            format-source-muted = "󰍭";

            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = "󰗿 {icon} {format_source}";

            format-icons = {
              headphone = "";
              phone = "";
              portable = "";
              car = "";
              default = ["󰕿" "󰖀" "󰕾"];
            };
            on-click = "pavucontrol";
          };

          backlight = {
            format = "{icon}";
            format-alt = "{percent}% {icon}";
            format-alt-click = "click-right";
            format-icons = [
              ""
              ""
            ];
            on-scroll-down = "light -A 1";
            on-scroll-up = "light -U 1";
          };

          tray = {
            icon-size = 18;
          };

          ## This just for example on the future
          "custom/storage" = {
            format = "{} ";
            format-alt = "{percentage}% ";
            format-alt-click = "click-right";
            return-type = "json";
            interval = 60;
            exec = "~/.config/waybar/modules/storage.sh";
          };

          "custom/test" = {
            format = "{}";
            exec = "/tmp/test blub";
            param = "blah";
            interval = 5;
          };
        };

      };
    };
    

    home.extraOptions.home.activation.myWaybarActionScript = let
      h = "/home/${config.user.name}";
    in ''
      test -f ${h}/.config/waybar/colors.css || touch ${h}/.config/waybar/colors.css
    '';

    home.extraOptions.services.darkman = let
      h = "/home/${config.user.name}";
    in {
      lightModeScripts.waybar = ''
        export PATH=${pkgs.lib.makeBinPath [pkgs.coreutils pkgs.procps]}:$PATH

        cp -f ${./light.css} ${h}/.config/waybar/colors.css
        pkill -USR2 -u $USER waybar || true
      '';
      darkModeScripts.waybar = ''
        export PATH=${pkgs.lib.makeBinPath [pkgs.coreutils pkgs.procps]}:$PATH

        cp -f ${./dark.css} ${h}/.config/waybar/colors.css
        pkill -USR2 -u $USER waybar || true
      '';
    };
  };
}
