{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.user;
  filterFiles = lib.filterAttrs (name: value: value == "regular");
  listFiles = path: builtins.map (name: path + "/${name}") (builtins.attrNames (filterFiles (builtins.readDir path)));
in {
  options.user = {
    name = mkOption {
      type = types.str;
      default = "badenkov";
      description = "The name to use for the user account.";
    };
    fullName = mkOption {
      type = types.str;
    };
    email = mkOption {
      type = types.str;
    };
  };

  config = {
    users.users.${cfg.name} = {
      isNormalUser = true;
      description = "${cfg.fullName} <${cfg.email}>";

      group = "users";
      extraGroups = ["wheel" "networkmanager" "audio" "docker" "podman" "librvirtd" "kvm"];

      name = cfg.name;
      hashedPassword = "$6$ucyrbpeO1T$sHT836PsoavoQ.vStmFmxcma0eN8fWjqLTjZ5EDnwVjM0advna8QSur6/5UqsJt.7NSfQKV.wHFNlwv7QjPzS/";
      shell = pkgs.fish;
    };

    programs.fish.enable = true;

    home-manager.users.${cfg.name} = {
      programs.home-manager.enable = true;

      home.username = cfg.name;
      home.homeDirectory = "/home/${cfg.name}";
      #home.stateVersion = "22.05";
    };

    security.sudo.extraRules = [
      {
        users = [cfg.name];
        commands = [
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
