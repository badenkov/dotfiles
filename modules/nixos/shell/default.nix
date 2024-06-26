{ inputs, lib, pkgs, ...}:


with lib;
{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  config = {
    environment.systemPackages = with pkgs; [
      gnumake
      psmisc
      mc
      rar
      unzip

      eza
      nitch
      zoxide
      starship
      silver-searcher
      ripgrep
      fd
      lf
      fzf # A command-line fuzzy finder written in Go
      erdtree # File-tree visualizer and disk usage analyzer
      glow # Render markdown in CLI
      carapace
      #jc # CLI tool and python library that converts the output of popular command-line tools,
      # file-types, and common strings to JSON, YAML, or Dictionaries. This allows piping of output to tools
      # like jq and simplifying automation scripts.
    ];

    users.defaultUserShell = pkgs.fish;
    users.users.root.shell = pkgs.bashInteractive;

    programs.command-not-found.enable = false;
    programs.nix-index.enable = true;
    programs.nix-index.enableFishIntegration = true;

    home.programs.fish = {
      enable = true;
      shellAliases = {
        ls = "eza -la --icons --no-user --no-time --git -s type";
        cat = "bat";
      };
      shellInit = ''
        set -g fish_greeting

        function , --description 'add software to shell session'
          nix shell nixpkgs#$argv[1..-1]
        end

        #function ,,, --description 'switch to'
        #  nix develop self#rubyenv1 -c fish
        #end

        #function ,, --description 'switch to'
        #  nix develop ~/Projects/mydevshell -c fish
        #end
     '';

      plugins = [
        {
          name = "plugin-git";
          src = pkgs.fishPlugins.plugin-git.src;
        }
      ];
    };

    home.programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };

    home.programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    home.programs.direnv = {
      enable = true;
      #enableZshIntegration = true;
      enableNushellIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };
  };
}
