{ inputs, config, lib, system, pkgs, ... }: {
  config = {
    environment.systemPackages = [
      pkgs.ironbar
    ];
  };
}

