{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.desktop.addons.swww;
in {
  options.desktop.addons.swww = {
    enable = mkOption { 
      type = types.bool;
      default = false;
      description = "Enable or disable SWWW";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.swww
      (let
        wallpapers = ../../../../../wallpapers;
      in pkgs.writeShellScriptBin "wallpaper" ''
        /usr/bin/env ls ${wallpapers} | sort -R | tail -1 |while read file; do
            swww img ${wallpapers}/$file --transition-fps 255 --transition-type wipe
            echo "${wallpapers}/$file"
        done
      '')
    ];



    home.extraOptions = let
      wallpapers = ../../../../../wallpapers;
    in {
      services.darkman.lightModeScripts.swww = ''
        swww img ${wallpapers}/nixos-wallpaper-catppuccin-latte.png --resize crop --transition-fps 255 --transition-type wipe
      '';
      services.darkman.darkModeScripts.swww = ''
        swww img ${wallpapers}/nixos-wallpaper-catppuccin-mocha.png --resize crop --transition-fps 255 --transition-type wipe
      '';

      systemd.user.services.swww = {
        Unit = {
          Description =
            "A Solution to your Wayland Wallpaper Woes.";
          Documentation = "https://github.com/LGFae/swww";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session-pre.target" ];
        };

        Service = {
          ExecStart = "${pkgs.swww}/bin/swww-daemon";
          Restart = "on-failure";
          KillMode = "mixed";
        };

        Install = { WantedBy = [ "graphical-session.target" ]; };
      };
    };
  };
}
