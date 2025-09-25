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

vim.o.guicursor = ''

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

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('t', '<esc><esc>', '<C-\\><C-n>')

local function pythonvenv()
  if vim.fn.filereadable('.venv/bin/activate') == 1 then
    return 'source .venv/bin/activate && clear<cr>'
  else
    return ''
  end
end

vim.keymap.set('n', '<leader>t', '<cmd>terminal<CR>i' .. pythonvenv())

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

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = { enable = true }
    }
  },
  'nvim-treesitter/nvim-treesitter-context',
  'neovim/nvim-lspconfig',
  { 'mason-org/mason.nvim', opts = {} },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { 'jdtls', 'lemminx', 'denols', 'superhtml', 'cssls', 'html', 'jsonls', 'yamlls' }
    }
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
        documentation = { auto_show = true }
      }
    }
  },
  { 'NMAC427/guess-indent.nvim', opts = {} },
  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {}, },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
  { 'j-hui/fidget.nvim', opts = {} },
  'lewis6991/gitsigns.nvim',
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('fzf-lua').setup({ 'border-fused', files = { hidden = false, actions = { ["enter"] = FzfLua.actions.file_edit } } })

      vim.keymap.set('n', '<leader>ff', FzfLua.files )
      vim.keymap.set('n', '<leader>fb', FzfLua.buffers )

      FzfLua.register_ui_select()
    end
  }
})

vim.lsp.enable({ 'bashls', 'ruff', 'ty', 'tombi' })
vim.diagnostic.config({ virtual_lines = { current_line = true } })

vim.lsp.config('jdtls', {
  init_options = {
    settings = {
      java = {
        jdt = {
          ls = {
            lombokSupport = {
              enabled = true
            }
          }
        },
        configuration = {
          maven = {
            globalSettings = os.getenv('XDG_CONFIG_HOME') .. '/maven/settings.xml'
          }
        },
        saveActions = {
          organizeImports = true
        }
      }
    }
  }
})

vim.lsp.config('lemminx', {
  init_options = {
    settings = {
      xml = {
        server = {
          workDir = os.getenv('XDG_CACHE_HOME') .. '/lemminx'

        }
      }
    }
  }
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear=false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end
      })
    end
  end
})

vim.cmd.colorscheme('cyberdream')
