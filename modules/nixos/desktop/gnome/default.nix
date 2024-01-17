{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.desktop.gnome;
in {
  options.desktop.gnome = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, it will be installed desktop environment
      '';
    };
  };

  config = mkIf false {
    programs.dconf.enable = true;
    ##### Под вопросом - но после этого у меня заработал шаринг экрана в браузере
    services.xserver.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages =
      (with pkgs; [
        gnome-photos
        gnome-tour
        gedit # text editor
      ])
      ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-music
        epiphany # web browser
        geary # email reader
        gnome-characters
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        yelp # Help view
        gnome-contacts
        gnome-initial-setup
      ]);
  };
}
