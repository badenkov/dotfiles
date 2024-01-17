vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.guifont = 'JetBrains Mono Nerd Font:h14'
-- vim.cmd([[
--   colorscheme github_dark
-- ]])

-- Settings
vim.opt.nu = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append '@-@'
vim.opt.updatetime = 50
vim.opt.clipboard = 'unnamedplus'
vim.opt.spelllang = 'en_us'
vim.opt.spell = true

vim.keymap.set({ 'n', 'i', 'v'}, '<C-s>', '<cmd>:w<cr>', { silent = true })
vim.keymap.set('n', '<A-z>', '<cmd>:set wrap!<cr>', { silent = true })

vim.keymap.set('i', 'jk', '<esc>', { silent = true })

-- Better window movement
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })

-- Better window resizing
vim.keymap.set('n', '<C-Up>', '<cmd>:resize -2<cr>', { silent = true })
vim.keymap.set('n', '<C-Down>', '<cmd>:resize +2<cr>', { silent = true })
vim.keymap.set('n', '<C-Left>', '<cmd>:vertical resize -2<cr>', { silent = true })
vim.keymap.set('n', '<C-Right>', '<cmd>:vertical resize +2<cr>', { silent = true })



-------------------------------------------------------------------------------------------
require('mini.move').setup({
  mappings = {
    left  = '<A-h>',
    right = '<A-l>',
    down  = '<A-j>',
    up    = '<A-k>',

    line_left  = '<A-h>',
    line_right = '<A-l>',
    line_down  = '<A-j>',
    line_up    = '<A-k>',
  }
})

-------------------------------------------------------------------------------------------

require('window-picker').setup()
require('lualine').setup()

-------------------------------------------------------------------------------------------
--vim.keymap.set('n', '<leader>ff', '<cmd>luafile %<cr>');

--vim.nnoremap <leader><leader> :lua require('telescope.builtin').find_files({ previewer = false })<CR>
--------------------------------------------------------------------------------------------

require('nvim-web-devicons').setup({ default = true })

require("neo-tree").setup({
  filesystem = {
    bind_to_cwd = true,
  },
})

local function getTelescopeOpts(state, path)
  return {
    cwd = path,
    search_dirs = { path },
    attach_mappings = function (prompt_bufnr, map)
      local actions = require "telescope.actions"
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local action_state = require "telescope.actions.state"
        local selection = action_state.get_selected_entry()
        local filename = selection.filename
        if (filename == nil) then
          filename = selection[1]
        end
        -- any way to open the file without triggering auto-close event of neo-tree?
        require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
      end)
      return true
    end
  }
end
require("neo-tree").setup({
  filesystem = {
    window = {
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        
        ["/"] = "telescope_find",
        ["<C-/>"] = "telescope_grep",
      },
    },
    commands = {
      telescope_find = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require('telescope.builtin').find_files(getTelescopeOpts(state, path))
      end,
      telescope_grep = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require('telescope.builtin').live_grep(getTelescopeOpts(state, path))
      end,
    },
  },
})

vim.keymap.set('n', '<space>n', '<cmd>Neotree source=filesystem toggle<cr>')
vim.keymap.set('n', '<space>N', '<cmd>Neotree source=filesystem reveal toggle<cr>')
vim.keymap.set('n', '<space>g', '<cmd>Neotree source=git_status toggle<cr>')
vim.keymap.set('n', '<space>b', '<cmd>Neotree source=buffers toggle<cr>')

require('Comment').setup()

require('gitblame').setup()

-- LSP

local lspconfig = require('lspconfig')
lspconfig.nil_ls.setup({ on_attach = on_attach })
lspconfig.tsserver.setup({ on_attach = on_attach })
lspconfig.solargraph.setup({ on_attach = on_attach })

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts) TODO подумать о другом биндинге, так как конфликтует с перемещениям по окнам
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

require("catppuccin").setup({
    -- flavour = "mocha", -- latte, frappe, macchiato, mocha
    flavour = "mocha",
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"

---------------------------flash
-- Какой то охуенный плагин поиска по тексту, выделение и т.п.
vim.keymap.set('n', '<leader>ls', function() require("flash").jump() end)
vim.keymap.set('n', '<leader>lt', function() require("flash").treesitter() end)
vim.keymap.set('n', '<leader>lr', function() require("flash").treesitter_search() end)


---- Telescope
-- require("telescope").load_extension("frecency")

--vim.keymap.set('n', '<leader><leader", require('telescope.builtin')]));
--vim.keymap.set('n', '<leader><leader>', '<cmd>Telescope find_files<cr>');
vim.keymap.set('n', '<leader><leader>', function() require('telescope.builtin').find_files({ previewer = false, layout_strategy = "current_buffer" }) end);
--vim.keymap.set("n", "<leader><leader>", "<Cmd>Telescope frecency workspace=CWD<CR>") -- Чето не очень понравилось

require('telescope-alternate').setup({
    mappings = {
      { 'app/services/(.*)_services/(.*).rb', { -- alternate from services to contracts / models
        { 'app/contracts/[1]_contracts/[2].rb', 'Contract' }, -- Adding label to switch
        { 'app/models/**/*[1].rb', 'Model', true }, -- Ignore create entry (with true)
      } },
      { 'app/contracts/(.*)_contracts/(.*).rb', { { 'app/services/[1]_services/[2].rb', 'Service' } } }, -- from contracts to services
      -- Search anything on helper folder that contains pluralize version of model.
      --Example: app/models/user.rb -> app/helpers/foo/bar/my_users_helper.rb
      { 'app/models/(.*).rb', { { 'db/helpers/**/*[1:pluralize]*.rb', 'Helper' } } },
      { 'app/**/*.rb', { { 'spec/[1].rb', 'Test' } } }, -- Alternate between file and test
    },
    presets = { 'rails', 'rspec', 'nestjs', 'angular' }, -- Telescope pre-defined mapping presets
    open_only_one_with = 'current_pane', -- when just have only possible file, open it with.  Can also be horizontal_split and vertical_split
    transformers = { -- custom transformers
      change_to_uppercase = function(w) return my_uppercase_method(w) end
    },
    -- telescope_mappings = { -- Change the telescope mappings
    --   i = {
    --     open_current = '<CR>',
    --     open_horizontal = '<C-s>',
    --     open_vertical = '<C-v>',
    --     open_tab = '<C-t>',
    --   },
    --   n = {
    --     open_current = '<CR>',
    --     open_horizontal = '<C-s>',
    --     open_vertical = '<C-v>',
    --     open_tab = '<C-t>',
    --   }
    -- }
  })

-- On your telescope:
require('telescope').load_extension('telescope-alternate')

vim.keymap.set("n", "<leader>a", "<Cmd>Telescope telescope-alternate alternate_file<CR>")
