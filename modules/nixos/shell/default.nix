{ options, config, lib, pkgs, ...}:

with lib;
{
  config = {
    environment.systemPackages = with pkgs; [
      eza
      bat
      nitch
      zoxide
      starship
    ];

    users.defaultUserShell = pkgs.fish;
    users.users.root.shell = pkgs.bashInteractive;

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

        function ,,, --description 'switch to'
          nix develop self#rubyenv1 -c fish
        end

        function ,, --description 'switch to'
          nix develop ~/Projects/mydevshell -c fish
        end
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
