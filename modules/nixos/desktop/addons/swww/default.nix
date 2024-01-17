{ options, config, pkgs, lib, ... }:

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
  };
}
