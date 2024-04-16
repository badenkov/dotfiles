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



    ## Battery
    # Better scheduling for CPU cycles - thanks System76!!!
    #services.system76-scheduler.settings.cfsProfiles.enable = true;

    # Enable TLP (better than gnomes internal power manager)
    services.tlp = {
      enable = false;
      settings = {
        CPU_BOOST_ON_AC = 0;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        USB_AUTOSUSPEND = 0;
      };
    };
    ###############################
  };
}
