{ pkgs, lib, ... }: {
  options = with lib; {
    enabled = {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf true {

    environment.systemPackages = with pkgs; [
      inotify-tools ## ?? Здесь ли?

      yq-go # Утилита для редактирования yaml файлов
      lefthook # githook-и

      just

      docker-compose
      process-compose

      libyaml # for gem psych
      gitFull

      gcc

      # libpcap
      # postgresql
      # libxml2
      # libxslt
      # pkg-config
      # bundix
      # gnumake

      sqlite
    ];

    # ###
    # virtualisation.docker.enable = true;
    # virtualisation.podman.enable = true;
    # virtualisation.libvirtd.enable = true;
    # ####
  };
}
