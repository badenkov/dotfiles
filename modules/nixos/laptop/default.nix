{ config, lib, ... }:

with lib;
{
  options = {
    laptop = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.laptop {
    programs.light.enable = true;
    services.actkbd = {
      enable = true;
      bindings = [
        {
          keys = [224];
          events = ["key"];
          command = "/run/current-system/sw/bin/light -U 10";
        }
        {
          keys = [225];
          events = ["key"];
          command = "/run/current-system/sw/bin/light -A 10";
        }
      ];
    };
  };
}
