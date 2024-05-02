{ pkgs, ... }: {
  plugins = {
    lsp.enable = true;
    lsp.keymaps.lspBuf = {
      K = "hover";
      gD = "references";
      gd = "definition";
      gi = "implementation";
      gt = "type_definition";
    };

    lsp.servers.solargraph.enable = true;
    lsp.servers.solargraph.cmd = [ "direnv" "exec" "." "solargraph" "stdio" ];

    lsp.servers.elixirls.enable = true;
    lsp.servers.elixirls.cmd = [ "direnv" "exec" "." "elixir-ls" ];

    # lsp.servers.nixd.enable = true;
    lsp.servers.nil_ls.enable = true;

    lsp.servers.lua-ls.enable = true;
  };

  extraPackages = with pkgs; [
    direnv
  ];

  extraPlugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    elixir-tools-nvim
  ];

}
