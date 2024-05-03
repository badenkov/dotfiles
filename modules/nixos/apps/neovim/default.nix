{ pkgs, ... }: {
  config = {
    environment.variables = {
      EDITOR = "nvim";
    };

    environment.systemPackages = with pkgs; [
      (custom.myvim.nixvimExtend {
        extraConfigLua = ''
          if (vim.fn.system("darkman get"):gsub("\n", "") == "light") 
          then
            vim.cmd("colorscheme catppuccin-latte")
          else
            vim.cmd("colorscheme catppuccin-mocha")
          end
        '';
      })
    ] ++ (let
      get-neovim-serverlist = pkgs.writeShellScriptBin "get-neovim-serverlist" ''
        export PATH=${pkgs.lib.makeBinPath [pkgs.neovim-remote pkgs.gnugrep]}:$PATH

        nvr --serverlist | grep "/run" | grep "/nvim" | uniq
      '';
      set-neovim-light = pkgs.writeShellScriptBin "set-neovim-light" ''
        export PATH=${pkgs.lib.makeBinPath [pkgs.neovim-remote]}:$PATH

        for server in $(get-neovim-serverlist); do
          echo "nvr --servername $server -cc 'colorscheme catppuccin-latte' --nostart"
          nvr --servername "$server" -cc 'colorscheme catppuccin-latte' --nostart
        done
      '';
      set-neovim-dark = pkgs.writeShellScriptBin "set-neovim-dark" ''
        export PATH=${pkgs.lib.makeBinPath [pkgs.neovim-remote]}:$PATH

        for server in $(get-neovim-serverlist); do
          echo "nvr --servername $server -cc 'colorscheme catppuccin-mocha' --nostart"
          nvr --servername "$server" -cc 'colorscheme catppuccin-mocha' --nostart
        done
      '';
    in [
      get-neovim-serverlist
      set-neovim-light
      set-neovim-dark
    ]);


    home.extraOptions.services.darkman = {
      darkModeScripts = {
        neovim = ''
          set-neovim-dark
        '';
      };
      lightModeScripts = {
        neovim = ''
          set-neovim-light
        '';
      };
    };
  };
}
