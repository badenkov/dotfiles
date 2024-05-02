{ pkgs, ... }: {
  plugins = {
    which-key.enable = true;
    treesitter.enable = true;
    telescope.enable = true; 
    better-escape.enable = true;

    direnv.enable = true;

    neo-tree = {
      enable = true;
    };

    # project-nvim = {
    #   enable = true;
    #   enableTelescope = true;
    # };
    persistence.enable = true;

    comment.enable = true;
    neogit.enable = true;

    fzf-lua = {
      enable = true;
      # keymaps = {
      #   "<leader><leader>" = "files";
      #   "<leader>fg" = "live_grep";
      # };
    };

    toggleterm.enable = true;
    toggleterm.settings.on_create = ''
      function(t)
        vim.api.nvim_create_autocmd("BufEnter", {
          buffer = t.bufnr,
          callback = function()
            vim.cmd.startinsert()
          end,
        })
      end
    '';

    ## Folding
    nvim-ufo = {
      enable = true;
    };

    # Different usefulness
    mini = {
      enable = true;
      modules = {
        bufremove = { };
        trailspace = { };
        surround = { };
        move = {
          mappings = {
            left  = "<A-h>";
            right = "<A-l>";
            down  = "<A-j>";
            up    = "<A-k>";
            line_left  = "<A-h>";
            line_right = "<A-l>";
            line_down  = "<A-j>";
            line_up    = "<A-k>";
          };
        };
      };
    };

    ####
    zen-mode.enable = true;
    twilight.enable = true;
  };

  extraPackages = with pkgs; [
    lazygit
  ];

  extraPlugins = with pkgs.vimPlugins; [
    nvim-window-picker
    lazygit-nvim
    aerial-nvim
    vim-rails

    nvim-spectre # A search panel for neovim
  ];

  extraConfigLua = ''
    require("window-picker").setup()

    require("aerial").setup({
      -- optionally use on_attach to set keymaps when aerial has attached to a buffer
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
    })
    -- You probably also want to set a keymap to toggle aerial
    vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

    require("telescope").load_extension("aerial")

    function _G.set_terminal_keymaps()
      local opts = {buffer = 0}
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      --vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    end

    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
  '';
}
