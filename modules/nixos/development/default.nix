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
      devenv
    ];

    # ###
    virtualisation.docker.enable = true;

    #virtualisation.podman = {
    #  enable = true;
    #  dockerCompat = true;
    #};

    # virtualisation.libvirtd.enable = true;
    # ####
  };
}
