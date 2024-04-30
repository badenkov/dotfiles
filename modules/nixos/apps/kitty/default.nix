{
  pkgs,
  config,
  ...
}: {
  config = let
    h = "/home/${config.user.name}";
  in {
    home.programs.kitty = {
      enable = true;
      font = {
        name = "JetBrains Mono";
        #name = "Martian Mono Light";
        size = 12;
      };
      #theme = "Catppuccin-Latte";
      shellIntegration.enableFishIntegration = true;
      extraConfig = ''
        include ${h}/.config/kitty/current-theme.conf
      '';
    };

    home.extraOptions = {
      services.darkman.lightModeScripts.kitty = ''
        cp -f ${pkgs.kitty-themes}/share/kitty-themes/themes/Catppuccin-Latte.conf ${h}/.config/kitty/current-theme.conf
        ${pkgs.procps}/bin/pkill -USR1 -u $USER kitty || true
      '';
      services.darkman.darkModeScripts.kitty = ''
        cp -f ${pkgs.kitty-themes}/share/kitty-themes/themes/Catppuccin-Mocha.conf ${h}/.config/kitty/current-theme.conf
        ${pkgs.procps}/bin/pkill -USR1 -u $USER kitty || true
      '';
    };

    home.extraOptions.home.activation.myKittyActionScript = ''
      test -f ${h}/.config/kitty/current-theme.conf || touch ${h}/.config/kitty/current-theme.conf
    '';
  };
}
