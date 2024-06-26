{ inputs, pkgs, lib, ... }: let

  mkNeovim = pkgs.callPackage ./mkNeovim.nix {};

  # Use this to create a plugin from an input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  yaml-nvim = mkNvimPlugin inputs.yaml-nvim "yaml-nvim";
  telescope-alternate-nvim = mkNvimPlugin inputs.telescope-alternate-nvim "telescope-alternate-nvim";
  nerdy-nvim = mkNvimPlugin inputs.nerdy-nvim "nerdy-nvim";
  vim-slim = mkNvimPlugin inputs.vim-slim "vim-slim";

  plugins = with pkgs.vimPlugins; [
    plenary-nvim
    nvim-web-devicons
    nui-nvim
    nvim-treesitter.withAllGrammars

    flatten-nvim

    direnv-vim

    lualine-nvim
    neo-tree-nvim

    telescope-nvim
    # https://github.com/nvim-telescope/telescope-frecency.nvim/
    #telescope-frecency-nvim
    # https://github.com/otavioschwanck/telescope-alternate.nvim
    telescope-alternate-nvim

    #https://github.com/2kabhishek/nerdy.nvim
    #nerdy-nvim

    nvim-lspconfig
    comment-nvim

    git-blame-nvim

    nvim-cmp
    cmp-nvim-lsp

    #codeium-vim

    yaml-nvim
    vim-nix
    vim-javascript
    typescript-vim
    vim-jsx-typescript
    vim-prettier
    vim-slim

    mini-nvim
    nvim-window-picker

    # Themes
    catppuccin-nvim

    ## Пробуем
    flash-nvim # Какой то аналог хоп
  ];

  extraPackages = with pkgs; [
    gcc
    nil 

    nodejs
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.prettier
    nodePackages.eslint

    ruby
    rubyPackages.solargraph
  ];

in mkNeovim { inherit plugins extraPackages; appName = "mynvim"; }
