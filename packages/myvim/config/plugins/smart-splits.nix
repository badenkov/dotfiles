{
  plugins = {
    smart-splits.enable = true;
  };

  keymaps = [
    {
      key = "<C-h>";
      action = ''
        function() require("smart-splits").move_cursor_left() end
      '';
      lua = true;
      mode = ["n"];
      options = {
        silent = true;
        desc = "Move to left split";
      };
    }
    {
      key = "<C-j>";
      action = ''
        function() require("smart-splits").move_cursor_down() end
      '';
      lua = true;
      mode = ["n"];
      options = {
        silent = true;
        desc = "Move to below split";
      };
    }
    {
      key = "<C-k>";
      action = ''
        function() require("smart-splits").move_cursor_up() end
      '';
      lua = true;
      mode = ["n"];
      options = {
        silent = true;
        desc = "Move to up split";
      };
    }
    {
      key = "<C-l>";
      action = ''
        function() require("smart-splits").move_cursor_right() end
      '';
      lua = true;
      mode = ["n"];
      options = {
        silent = true;
        desc = "Move to right split";
      };
    }
#######################
    {
      key = "<C-A-h>";
      action = ''
        function() require("smart-splits").resize_left() end
      '';
      lua = true;
      mode = ["n"];
      options = {
        silent = true;
        desc = "Resize split left";
      };
    }
    {
      key = "<C-A-j>";
      action = ''
        function() require("smart-splits").resize_down() end
      '';
      lua = true;
      mode = ["n"];
      options = {
        silent = true;
        desc = "Resize split down";
      };
    }
    {
      key = "<C-A-k>";
      action = ''
        function() require("smart-splits").resize_up() end
      '';
      lua = true;
      mode = ["n"];
      options = {
        silent = true;
        desc = "Resize split up";
      };
    }
    {
      key = "<C-A-l>";
      action = ''
        function() require("smart-splits").resize_right() end
      '';
      lua = true;
      mode = ["n"];
      options = {
        silent = true;
        desc = "Resize split right";
      };
    }

    {
      key = "<localleader>h";
      action = ''
        function() require("smart-splits").swap_buf_left() end
      '';
      lua = true;
      mode = ["n"];
      options = {
        silent = true;
        desc = "Swapt with left";
      };
    }

    {
      key = "<localleader>j";
      action = ''
        function() require("smart-splits").swap_buf_down() end
      '';
      lua = true;
      mode = ["n"];
      options = {
        silent = true;
        desc = "Swap with down";
      };
    }
    {
      key = "<localleader>k";
      action = ''
        function() require("smart-splits").swap_buf_up() end
      '';
      lua = true;
      mode = ["n"];
      options = {
        silent = true;
        desc = "Swap with up";
      };
    }
    {
      key = "<localleader>l";
      action = ''
        function() require("smart-splits").swap_buf_right() end
      '';
      lua = true;
      mode = ["n"];
      options = {
        silent = true;
        desc = "Swap with right";
      };
    }

  ];
}
