{ inputs, pkgs, ... }: let
  nixvim' = inputs.nixvim.legacyPackages.${pkgs.system};
  nixvimModule = {
    inherit pkgs;
    module = import ./config/config.nix;
    extraSpecialArgs = {
    };
  };
  neovim = nixvim'.makeNixvimWithModule nixvimModule;
in neovim

