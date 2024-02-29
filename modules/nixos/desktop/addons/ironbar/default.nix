{ inputs, config, lib, system, ... }: 

with lib;
let
  cfg = config.desktop.addons.ironbar;
in {
  options.desktop.addons.ironbar = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, it will be installed ironbar
      '';
    };
  };

  config = mkIf cfg.enable {
    home.extraOptions = {
      imports = [
        inputs.ironbar.homeManagerModules.default
      ];

      programs.ironbar = {
        enable = true;
        config = {
          position = "bottom";
          height = 20;
          start = [
            {
              type = "workspaces";
              all_monitors = false;
            }
          ];
          center = [
            { type = "focused"; }
          ];
          end = [
            { type = "clock"; }
            { type = "tray"; }
          ];
        };
        style = ''
        * {
          font-size: 16px;
          border:none;
          border-radius: 0;
        }

        #bar {
          background: #111827;
        }

        .workspaces .item {
          background-color: #111827;
          color: #f3f4f6;
          border-top: 3px solid #111827;
          padding: 0;
          margin:0;
        }

        .workspaces .item:hover {
          background: #4b5563;
          color: #f3f4f6;
        }

        .workspaces .item.focused {
          border-top: 3px solid #f3f4f6;
        }

        .clock {
          background: #111827;
          color: #f3f4f6;
        }

        .tray .item {
          background: #111827;
          color: #f3f4f6;
        }

        .tray .popup menu {
          background: #111827;
          color: #f3f4f6;
        }

        .tray .popup menuitem {
          background: #111827;
          color: #f3f4f6;
        }

        .tray .popup menuitem:hover {
          background: #4b5563;
          color: #f3f4f6;
        }
        '';
        package = inputs.ironbar.packages.${system}.default;
      };
    };
  };
}
