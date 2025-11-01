local workspace_root = nil
local git_dir = vim.system({ 'git', '-C', vim.fn.expand('%:p:h'), 'rev-parse', '--show-toplevel' }):wait()
if git_dir.code == 0 then
  workspace_root = vim.trim(git_dir.stdout)
else
  workspace_root = vim.fs.root(0, { '.venv', 'package.json', 'pom.xml', 'biome.json' })
end

if workspace_root then
  vim.fn.chdir(workspace_root)
end

vim.env.EDITOR = 'nvr -l --servername ' .. vim.v.servername
vim.env.VISUAL = 'nvr -l --servername ' .. vim.v.servername

vim.g.mapleader = ' '

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = ''

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.winborder = 'rounded'

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true

vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 3

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

vim.o.guicursor = 'a:blinkon0'

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set({ 'n', 't' }, '<C-h>', '<cmd>wincmd h<cr>')
vim.keymap.set({ 'n', 't' }, '<C-j>', '<cmd>wincmd j<cr>')
vim.keymap.set({ 'n', 't' }, '<C-k>', '<cmd>wincmd k<cr>')
vim.keymap.set({ 'n', 't' }, '<C-l>', '<cmd>wincmd l<cr>')

vim.keymap.set('n', '<leader>i', '<cmd>edit ' .. vim.env.XDG_CONFIG_HOME .. '/nvim/init.lua<cr>')

vim.keymap.set('t', '<esc><esc>', '<C-\\><C-n>')

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevelstart = 99

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.opt.runtimepath:prepend(vim.fn.stdpath('data') .. '/lazy/lazy.nvim')

require('lazy').setup({
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = { enable = true },
    },
  },
  'nvim-treesitter/nvim-treesitter-context',
  'neovim/nvim-lspconfig',
  { 'mason-org/mason.nvim', opts = {} },
  {
    'mason-org/mason-lspconfig.nvim',
    config = function()
      local external_lsps = { 'bashls', 'ruff', 'clangd' }
      local mason_lsps = {
        'jdtls',
        'lemminx',
        'ts_ls',
        'biome',
        'superhtml',
        'cssls',
        'yamlls',
        'lua_ls',
        'stylua',
        'basedpyright',
        'pyrefly',
        'tombi',
      }

      require('mason-lspconfig').setup({
        ensure_installed = mason_lsps,
        automatic_enable = false,
      })

      if not vim.o.diff then
        vim.lsp.enable(vim.list_extend(external_lsps, mason_lsps))
      end
    end,
  },
  {
    'scottmckendry/cyberdream.nvim',
    priority = 1000,
  },
  {
    'Saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '*',
    opts = {
      completion = {
        documentation = { auto_show = true },
      },
    },
  },
  { 'NMAC427/guess-indent.nvim', opts = {} },
  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
  { 'j-hui/fidget.nvim', opts = {} },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        word_diff = true,
        on_attach = function(bufnr)
          local actions = require('gitsigns.actions')
          vim.keymap.set('n', ']c', function()
            actions.nav_hunk('next')
          end, { buffer = bufnr })
          vim.keymap.set('n', '[c', function()
            actions.nav_hunk('prev')
          end, { buffer = bufnr })

          vim.keymap.set('n', '<leader>hp', actions.preview_hunk, { buffer = bufnr })

          vim.keymap.set('n', '<leader>hb', function()
            actions.blame_line({ full = true })
          end, { buffer = bufnr })

          -- Text object
          vim.keymap.set({ 'o', 'x' }, 'ih', actions.select_hunk, { buffer = bufnr })
        end,
      })
    end,
  },
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('fzf-lua').setup({
        'border-fused',
        files = { hidden = false, actions = { ['enter'] = require('fzf-lua.actions').file_edit } },
      })

      vim.keymap.set('n', '<leader>ff', function()
        if git_dir.code == 0 then
          require('fzf-lua.providers.git').files()
        else
          require('fzf-lua.providers.files').files()
        end
      end)
      vim.keymap.set('n', '<leader>fb', require('fzf-lua.providers.buffers').buffers)
      vim.keymap.set('n', '<leader>f\\', '<cmd>TermSelect<cr>')

      vim.ui.select = require('fzf-lua.providers.ui_select').ui_select
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup({
        open_mapping = '<c-\\>',
        direction = 'float',
        shell = '/bin/bash --rcfile ' .. vim.env.XDG_CONFIG_HOME .. '/bash/toggleterm_rcfile',
        size = function(term)
          if term.direction == 'horizontal' then
            return vim.o.lines * 0.4
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.5
          end
        end,
      })

      local Terminal = require('toggleterm.terminal').Terminal

      local lazygit = Terminal:new({ cmd = 'lazygit' })
      vim.keymap.set('n', '<leader>g', function()
        if git_dir.code == 0 then
          lazygit:toggle()
        else
          print('Not in a git repository')
        end
      end)

      local lf_pager = 'less -RM'
      local lf = Terminal:new({ cmd = 'lf', env = { PAGER = lf_pager, BAT_PAGER = lf_pager } })
      vim.keymap.set('n', '<leader>e', function()
        lf:toggle()
      end)

      local term_in_buf_dir = Terminal:new()
      vim.keymap.set('n', '<leader>t', function()
        term_in_buf_dir.dir = vim.fn.expand('%:p:h')
        term_in_buf_dir:toggle()
      end)

      vim.keymap.set('n', '<leader>\\\\', '<cmd>ToggleTerm direction=float<CR>')
      vim.keymap.set('n', '<leader>\\s', '<cmd>ToggleTerm direction=horizontal<CR>')
      vim.keymap.set('n', '<leader>\\v', '<cmd>ToggleTerm direction=vertical<CR>')
      vim.keymap.set('n', '<leader>|', '<cmd>TermNew<CR>')
    end,
  },
})

vim.diagnostic.config({ virtual_text = true })

vim.env.JDTLS_JVM_ARGS = '-javaagent:' .. vim.fn.stdpath('data') .. '/mason/packages/jdtls/lombok.jar' -- lombok support
vim.lsp.config('jdtls', {
  init_options = {
    settings = {
      java = {
        configuration = {
          maven = {
            globalSettings = vim.env.XDG_CONFIG_HOME .. '/maven/settings.xml',
          },
        },
        saveActions = {
          organizeImports = true,
        },
      },
    },
  },
})

vim.lsp.config('lemminx', {
  init_options = {
    settings = {
      xml = {
        server = {
          workDir = vim.env.XDG_CACHE_HOME .. '/lemminx',
        },
      },
    },
  },
})

vim.lsp.config('biome', {
  workspace_required = false,
  root_dir = function(_, on_dir)
    on_dir(workspace_root)
  end,
  settings = {
    biome = {
      configurationPath = vim.env.XDG_CONFIG_HOME .. '/biome/biome.json',
    },
  },
})

vim.lsp.config('cssls', {
  settings = {
    css = {
      validate = false,
    },
  },
})

vim.lsp.config('pyrefly', {
  settings = {
    python = {
      pyrefly = {
        disableLanguageServices = true,
        displayTypeErrors = 'force-on',
      },
    },
  },
})

vim.lsp.config('basedpyright', {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'off',
      },
    },
  },
})

local lua_default_markers = vim.lsp.config.lua_ls.root_markers
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = { 'lua/?.lua', 'lua/?/init.lua' },
      },
      workspace = {
        library = { vim.env.VIMRUNTIME },
      },
      format = {
        enable = false,
      },
    },
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local lua_custom_markers = vim.list_extend(lua_default_markers, { 'lua' })
    on_dir(
      vim.fs.root(bufnr, lua_custom_markers)
        or workspace_root
        or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p:h')
    )
  end,
})

vim.lsp.config('stylua', {
  cmd = { 'stylua', '--lsp', '--config-path', vim.env.XDG_CONFIG_HOME .. '/stylua/stylua.toml' },
})

local function lsp_on_attach(buf, client)
  local fmt_disabled_clients = { 'ts_ls', 'superhtml' }
  if
    not vim.list_contains(fmt_disabled_clients, client.name)
    and not client:supports_method('textDocument/willSaveWaitUntil')
    and client:supports_method('textDocument/formatting')
  then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
      buffer = buf,
      callback = function()
        vim.lsp.buf.format({ bufnr = buf, id = client.id })
      end,
    })
  end
end

local orig_handler = vim.lsp.handlers['client/registerCapability']
vim.lsp.handlers['client/registerCapability'] = function(err, result, ctx)
  local result = orig_handler(err, result, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)

  lsp_on_attach(ctx.buf, client)

  return result
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    lsp_on_attach(args.buf, client)
  end,
})

vim.cmd.colorscheme('cyberdream')
