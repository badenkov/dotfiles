{
  description = "Badenkov's NixOS configuration";

  inputs = {
    snowfall-lib = {
      url = "github:snowfallorg/lib/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";


    ## NeoVim and plugins
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yaml-nvim = {
      url = "github:cuducos/yaml.nvim";
      flake = false;
    };

    telescope-alternate-nvim = {
      url = "github:otavioschwanck/telescope-alternate.nvim";
      flake = false;
    };

    vim-slim = { 
      url = "github:slim-template/vim-slim";
      flake = false;
    };
  };

  outputs = inputs: (inputs.snowfall-lib.mkFlake {
    inherit inputs;
    src = ./.;

    snowfall = {
      namespace = "custom";
    };

    channels-config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-24.8.6"
      ];
    };
  });
}
