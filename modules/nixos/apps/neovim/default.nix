{ pkgs, ... }: {
  config = {
    environment.variables = {
      EDITOR = "nvim";
    };

    environment.systemPackages = with pkgs; [
      custom.myvim
    ];

    home.extraOptions.services.darkman = {
      darkModeScripts = {
        # neovim = ''
        #   for server in $(${pkgs.neovim-remote}/bin/nvr --serverlist | ${pkgs.gnugrep}/bin/grep "/run"); do
        #     ${pkgs.neovim-remote}/bin/nvr --servername "$server" -cc 'colorscheme catppuccin-mocha'
        #   done
        # '';
      };
      lightModeScripts = {
        # neovim = ''
        #   for server in $(${pkgs.neovim-remote}/bin/nvr --serverlist | ${pkgs.gnugrep}/bin/grep "/run"); do
        #     ${pkgs.neovim-remote}/bin/nvr --servername "$server" -cc 'colorscheme catppuccin-latte'
        #   done
        # '';
      };
    };
  };
}
