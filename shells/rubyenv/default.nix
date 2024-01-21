{ system, inputs, pkgs }: let 
  # pkgs = import inputs.nixpkgs { 
    # inherit system;
    # overlays = [
    #   inputs.bob-ruby.overlays.default
    # ]; 
  # };
  rubyNix = inputs.ruby-nix.lib pkgs;
  gemset = if builtins.pathExists ./gemset.nix then import ./gemset.nix else { };

  # ruby = pkgs."ruby-3.2";
  bundixcli = inputs.bundix.packages.${system}.default;

  inherit (rubyNix {
    inherit gemset;
    ruby = pkgs.ruby;
    name = "my-rubyenv";
    gemConfig = pkgs.defaultGemConfig;
  }) env;
in pkgs.mkShell {
  buildInputs = [ env bundixcli ];

  shellHook = ''
    echo "Welcome!"

    export GEM_PATH=$(mktemp)
    export GEM_HOME=$GEM_PATH
  '';
}
