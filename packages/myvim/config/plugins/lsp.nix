{ pkgs, ... }: {
  plugins = {
    /*
    Пока отключаю, потому что они тащат за собой LSP сервера, а это порой довольно весомо.
    Хочется сделать чтобы все необходимое подгружалось с помощью direnv.
    Так как некоторые LSP сервера могут зависеть от определнной версии например интепретатора. 
    */
    lsp.enable = false; #true;
    lsp.keymaps.lspBuf = {
      K = "hover";
      gD = "references";
      gd = "definition";
      gi = "implementation";
      gt = "type_definition";
    };

    # lsp.servers.solargraph.enable = true;
    # lsp.servers.solargraph.cmd = [ "direnv" "exec" "." "solargraph" "stdio" ];

    # lsp.servers.elixirls.enable = true;
    # lsp.servers.elixirls.cmd = [ "direnv" "exec" "." "elixir-ls" ];

    # lsp.servers.nixd.enable = true; // Какой лучше?
    #lsp.servers.nil_ls.enable = true;

    #lsp.servers.lua-ls.enable = true;
  };

  extraPackages = with pkgs; [
    direnv
  ];

  extraPlugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    elixir-tools-nvim
  ];

}
