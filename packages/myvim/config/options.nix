{
  globals = {
    mapleader = " ";
    maplocalleader = ",";
  };
  opts = {
    nu = true;
    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    smartindent = true;
    wrap = false;
    swapfile = false;
    backup = false;
    #undodir = "os.getenv 'HOME' .. '/.vim/undodir'";
    undofile = true;
    hlsearch = false;
    incsearch = true;
    termguicolors = true;
    scrolloff = 8;
    signcolumn = "yes";
    updatetime = 50;
    spelllang = "en_us";
    spell = true;

    # vim.opt.isfname:append '@-@'
    timeoutlen = 300; # Lower than default (1000) to quickly trigger which-key



    #### For folding TODO перенести поближе к nvim-ufo
    foldcolumn = "1";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;

  };
  clipboard = {
    register = "unnamedplus";
  };
  # colorschemes.catppuccin = {
  #   enable = true;
  #   settings.flavour = "mocha";
  # };
  colorschemes = {
    catppuccin.enable = true;
    catppuccin.settings.flavour = "latte";
    #tokynight.enable = true;
    #rose-pine.enable = true;
    #kanagawa.enable = true;
  };
}

