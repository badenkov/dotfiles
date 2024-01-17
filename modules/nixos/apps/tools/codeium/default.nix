{ config, pkgs, lib, ...}: let
  # homeDirectory = config.home-manager.users.${config.user.name}.home.homeDirectory;
  homeDirectory = "/home/badenkov";
in {
  config = {
    environment.systemPackages = with pkgs; [
      codeium
    ];

    ## Это воркараунд, так как то, что скачивает вим плагин - не работает. Поэтому смотрим что он скачивает, за место этого подставляет свой language server.
    home.extraOptions.home.activation.codeium = let 
      sha = "86c4743512cf764579039626318e45ddf3f91a22";
    in ''
      rm -rf ${homeDirectory}/.codeium/bin/${sha}
      mkdir -p ${homeDirectory}/.codeium/bin/${sha}
      ln -s ${pkgs.codeium}/bin/codeium_language_server ${homeDirectory}/.codeium/bin/${sha}/language_server_linux_x64
    '';
  };
}

