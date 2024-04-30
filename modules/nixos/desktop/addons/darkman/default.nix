{ pkgs, config, ... }: {
  config = {
    home.extraOptions = {
      services.darkman = {
        enable = true;
        darkModeScripts = {
          neovim = ''
            for server in $(${pkgs.neovim-remote}/bin/nvr --serverlist | ${pkgs.gnugrep}/bin/grep "/run"); do
              ${pkgs.neovim-remote}/bin/nvr --servername "$server" -cc 'colorscheme catppuccin-mocha'
            done
          '';

          kitty = ''
          '';
        };
        lightModeScripts = {
          neovim = ''
            for server in $(${pkgs.neovim-remote}/bin/nvr --serverlist | ${pkgs.gnugrep}/bin/grep "/run"); do
              ${pkgs.neovim-remote}/bin/nvr --servername "$server" -cc 'colorscheme catppuccin-latte'
            done
          '';
        };

        settings = {
          # Tbilisi
          lat = 41.716667;
          lng = 44.783333;
          usegeoclue = true;
        };
      };
    };
  };
}
