{
  description = "Badenkov's NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    #nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    #flake-parts.url = "github:hercules-ci/flake-parts";

    snowfall-lib = {
      url = "github:snowfallorg/lib/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    xdgh.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    xdgh.inputs.nixpkgs.follows = "nixpkgs";

    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    utils.url = "github:numtide/flake-utils";


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

    nerdy-nvim = {
      url = "github:2kabhishek/nerdy.nvim";
      flake = false;
    };

    vim-slim = { 
      url = "github:slim-template/vim-slim";
      flake = false;
    };

    ## Ruby
    #ruby-nix.url = "github:inscapist/ruby-nix";
    #bundix = {
    #  url = "github:inscapist/bundix/main";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    ## Process-Compose
    #process-compose.url = "github:F1bonacc1/process-compose";
    #process-compose.inputs.nixpkgs.follows = "nixpkgs";
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
