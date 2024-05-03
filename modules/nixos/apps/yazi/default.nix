{ pkgs, config, ... }: {
  config = let 
    h = "/home/${config.user.name}";
  in {
    home.programs.yazi = {
      enable = true;
      enableFishIntegration = true;
      theme = { };
    };

    home.extraOptions.home.packages = with pkgs; [
      libsixel # The SIXEL library for console graphics, and converter programs
      poppler # for pdf preview 
      ffmpegthumbnailer # for video preview
      unar # for archive preview
    ];

    home.extraOptions = {
      services.darkman.lightModeScripts.yazi = ''
        ln -sf ${./latte.toml} ${h}/.config/yazi/theme.toml
      '';
      services.darkman.darkModeScripts.yazi = ''
        ln -sf ${./mocha.toml} ${h}/.config/yazi/theme.toml
      '';
    };

    home.extraOptions.home.activation.myYaziActionScript = ''
      test -f ${h}/.config/yazi/theme.toml || ln -s ${./latte.toml} ${h}/.config/yazi/theme.toml
    '';
  };
}
