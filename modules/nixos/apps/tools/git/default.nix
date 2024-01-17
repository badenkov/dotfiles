{ config, pkgs, lib, ...}:  {
  config = {
    environment.systemPackages = with pkgs; [
      git
      lazygit
    ];


    home.programs.git = {
      enable = true;

      userName = config.user.fullName;
      userEmail = config.user.email;

      ignores = ["*~" "*.swp" ".dev/"];
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = "false";
      };
    };
  };
}

