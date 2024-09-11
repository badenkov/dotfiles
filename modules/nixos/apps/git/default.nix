{ config, pkgs, lib, ...}:  {
  config = {
    environment.systemPackages = with pkgs; [
      gitFull
      lazygit
    ];

    home.programs.git = {
      enable = true;

      userName = config.user.fullName;
      userEmail = config.user.email;

      ignores = ["*~" "*.swp" ".dev/"];
      extraConfig = {
        core.quotePath = "false";
        init.defaultBranch = "main";
        pull.rebase = "false";
      };
    };
  };
}

