require("neo-tree").setup({
  filesystem = {
    bind_to_cwd = true,
  },
})

vim.keymap.set('n', '<space>n', '<cmd>Neotree source=filesystem toggle<cr>')
vim.keymap.set('n', '<space>N', '<cmd>Neotree source=filesystem reveal toggle<cr>')
vim.keymap.set('n', '<space>g', '<cmd>Neotree source=git_status toggle<cr>')
vim.keymap.set('n', '<space>b', '<cmd>Neotree source=buffers toggle<cr>')
