{ pkgs, config, ... }: let
  h = "/home/${config.user.name}";
in {
  home.programs.bat = {
    enable = true;
    themes = {
      catppuccin-latte = {
        src = ./.;
        file = "catppuccin-latte.tmTheme";
      };
      catppuccin-mocha = {
        src = ./.;
        file = "catppuccin-mocha.tmTheme";
      };
    };
  };

  home.configFile = {
    "bat/dark-config".text = ''
      --theme="catppuccin-mocha"
    '';
    "bat/light-config".text = ''
      --theme="catppuccin-latte"
    '';
  };

  home.extraOptions.home.activation.myBatActionScript = ''
    test -f ${h}/.config/bat/config || ln -s ${h}/.config/bat/light-config ${h}/.config/bat/config
  '';

  home.extraOptions.services.darkman = {
    darkModeScripts = {
      bat = ''
        ${pkgs.coreutils}/bin/ln -sf ${h}/.config/bat/dark-config ${h}/.config/bat/config
      '';
    };

    lightModeScripts = {
      bat = ''
        ${pkgs.coreutils}/bin/ln -sf ${h}/.config/bat/light-config ${h}/.config/bat/config
      '';
    };
  };
}
