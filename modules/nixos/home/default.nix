{ inputs, lib, options, config, ... }:

with lib; {
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];

  options.home = {
    file = mkOption {
      type = types.attrs;
      default = {};
      description = "A set of files to be managed by home-manager's <option>home.file</option>.";
    };
    configFile = mkOption {
      type = types.attrs;
      default = {};
      description = "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    };
    programs = mkOption {
      type = types.attrs;
      default = {};
      description = "Programs to be managed by home-manager.";
    };
    extraOptions = mkOption {
      type = types.attrs;
      default = {};
      description = "Options to pass directly to home-manager.";
    };
  };

  config = {
    home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.home.configFile;
      programs = mkAliasDefinitions options.home.programs;

      #home.username = cfg.name;
      home.homeDirectory = "/home/${config.user.name}";
    };

    home-manager = {
      # Я пока не понимаю эту опцию
      useUserPackages = true;
      useGlobalPkgs = true;

      backupFileExtension = "backuphm";
      
      users.${config.user.name} = mkAliasDefinitions options.home.extraOptions;

      # Наверное надо еще указать homeDir? из config.users.${config.user.name.home} ? Надо проверить
    };
  };
}
