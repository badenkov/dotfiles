{ config, lib, ... }: 

with lib;
let
  cfg = config.desktop.addons.ironbar;
  homeModule = { pkgs, ...}: {
    home.packages = with pkgs; [
      waybar
    ];

    programs.waybar.enable = true;

    programs.waybar.systemd.enable = true;

    programs.waybar.settings.mainBar = {
      name = "main";
      layer = "bottom";
      position = "top";
      height = 30;

      modules-left = [ "hyprland/workspaces" "sway/workspaces" "sway/mode" ];
      modules-center = [ "sway/window" "hyprland/window" ];
      modules-right = [ "pulseaudio" "battery" "clock" "tray" "sway/language" "hyprland/language" ];

      "hyprland/workspaces" = {
        "format" = "{name}";
      };
      "hyprland/window" = {
        "max-length" = "200";
        "separate-outputs" = true;
      };
      "hyprland/language" = {
          "keyboard-name" = "at-translated-set-2-keyboard";
      };

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
        format-alt = "{time} {icon}";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";

        interval =  30;

        states = {
          warning = 25;
          critical = 1;
        };
        tooltip = false;
      };

      pulseaudio = {
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
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
    programs.waybar.style = ''
      * {
        border:        none;
        border-radius: 0;
        font-family:   Sans;
        font-size:     15px;
        box-shadow:    none;
        text-shadow:   none;
        transition-duration: 0s;
      }

      window {
        color:      rgba(217, 216, 216, 1);
        background: rgba(35, 31, 32, 1);
      }

      window#waybar.solo {
        color:      rgba(217, 216, 216, 1);
        /*background: rgba(35, 31, 32, 0.85);*/
      }

      #workspaces {
        margin: 0 5px;
      }

      #workspaces button {
        padding:    0 5px;
        color:      rgba(217, 216, 216, 0.4);
      }

      #workspaces button.visible {
        color:      rgba(217, 216, 216, 1);
      }

      #workspaces button.focused {
        border-top: 3px solid rgba(217, 216, 216, 1);
        border-bottom: 3px solid rgba(217, 216, 216, 0);
      }

      #workspaces button.urgent {
        color:      rgba(238, 46, 36, 1);
      }

      #mode, #battery, #cpu, #memory, #network, #pulseaudio, #idle_inhibitor, #backlight, #custom-storage, #custom-spotify, #custom-weather, #custom-mail {
        margin:     0px 6px 0px 10px;
        min-width:  25px;
      }

      #clock {
        margin:     0px 16px 0px 10px;
        min-width:  140px;
      }

      #battery.warning {
        color:       rgba(255, 210, 4, 1);
      }

      #battery.critical {
        color:      rgba(238, 46, 36, 1);
      }

      #battery.charging {
        color:      rgba(217, 216, 216, 1);
      }

      #custom-storage.warning {
        color:      rgba(255, 210, 4, 1);
      }

      #custom-storage.critical {
        color:      rgba(238, 46, 36, 1);
      }

      #tray {
        padding: 0 10px;
      }

    '';
  };

in {
  options.desktop.addons.waybar = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, it will be installed waybar
      '';
    };
  };

  config = mkIf cfg.enable {
    home.extraOptions = {
      imports = [
        homeModule
      ];
    };
  };
}
