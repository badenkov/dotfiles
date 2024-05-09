{ config, ...}: {
  config = {
    nix = {
      settings = {
        experimental-features = "nix-command flakes";
        http-connections = 50;
        warn-dirty = false;
        log-lines = 50;
        sandbox = "relaxed";
        auto-optimise-store = true;
        trusted-users = [ "root" config.user.name ];
        allowed-users = [ "root" config.user.name ];

        # А это добавлять только если direnv включен
        keep-outputs = true;
        keep-derivations = true;
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      # options from flake-utils-plus
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
    };
  };
}
