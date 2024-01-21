{
  pkgs,
  config,
  ...
}: {
  config = {
    home.programs.kitty = {
      enable = true;
      font = {
        name = "JetBrains Mono";
        #name = "Martian Mono Light";
        size = 12;
      };
      theme = "Catppuccin-Mocha";
      shellIntegration.enableFishIntegration = true;
    };
  };
}
