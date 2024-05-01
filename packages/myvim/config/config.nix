{
  imports = [
    ./options.nix
    ./plugins.nix
    ./plugins/smart-splits.nix
    ./plugins/lsp.nix
  ];

  keymaps = [
    {
      key = "<leader>e";
      action = ''
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.fn.getcwd() })
        end
      '';
      lua = true;
      options = {
        silent = true;
        desc = "Explorer NeoTree";
      };
    }
    {
      key = "<leader>o";
      action = ''
        function()
          if vim.bo.filetype == "neo-tree" then
            vim.cmd.wincmd "p"
          else
            vim.cmd.Neotree "reveal"
          end
        end
      '';
      lua = true;
      options = {
        silent = true;
        desc = "Reveal file in NeoTree";
      };
    }


    {
      key = "<leader><leader>";
      action = "<cmd>Telescope find_files<cr>";
      options = {
        silent = true;
        desc = "Find files";
      };
    }
    {
      key = "<leader>/";
      action = "<cmd>Telescope live_grep<cr>";
      options = {
        silent = true;
        desc = "Grep";
      };
    }
    {
      key = "<leader>,";
      action = "<cmd>FzfLua buffers<cr>";
      options = {
        silent = true;
        desc = "Switch Buffer";
      };
    }
    {
      key = "<leader>fp";
      action = "<cmd>Telescope projects<cr>";
      options = {
        silent = true;
        desc = "Projects";
      };
    }

    {
      key = "f";
      action = "<cmd>FzfLua grep_visual<cr>";
      mode = [ "v" ];
      options = {
        silent = true;
        desc = "Search visual selection";
      };
    }

    {
      key = "<leader>gg";
      action = "<cmd>LazyGit<cr>";
      options = {
        silent = true;
        desc = "LazyGit";
      };
    }

    {
      key = "<leader>z";
      action = "<cmd>ZenMode<cr>";
      options = {
        silent = true;
        desc = "ZenMode";
      };
    }

    {
      key = "<leader>t";
      action = "<cmd>ToggleTerm<cr>";
      options = {
        silent = true;
        desc = "Terminal";
      };
    }


    {
      key = "<leader>S";
      action = "require('spectre').toggle";
      lua = true;
      options = {
        silent = true;
        desc = "Search and Replace";
      };
    }
  ];
}

