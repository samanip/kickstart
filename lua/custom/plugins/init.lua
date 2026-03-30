-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local lualine = require 'lualine'

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand '%:t') ~= 1
        end,
        hide_in_width = function()
          return vim.fn.winwidth(0) > 80
        end,
        check_git_workspace = function()
          local filepath = vim.fn.expand '%:p:h'
          local gitdir = vim.fn.finddir('.git', filepath .. ';')
          return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
      }

      local config = {
        options = {
          component_separators = '',
          section_separators = '',
          theme = 'auto',
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
      }

      local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
      end

      local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
      end

      ins_left {
        function()
          return '▊'
        end,
        color = 'Title',
        padding = { left = 0, right = 1 },
      }

      ins_left {
        function()
          return ''
        end,
        color = function()
          local mode_color = {
            n = 'DiagnosticError',
            i = 'DiagnosticOk',
            v = 'DiagnosticInfo',
            ['\22'] = 'DiagnosticInfo',
            V = 'DiagnosticInfo',
            c = 'DiagnosticHint',
            no = 'DiagnosticError',
            s = 'DiagnosticWarn',
            S = 'DiagnosticWarn',
            ['\19'] = 'DiagnosticWarn',
            ic = 'DiagnosticWarn',
            R = 'Constant',
            Rv = 'Constant',
            cv = 'DiagnosticError',
            ce = 'DiagnosticError',
            r = 'DiagnosticInfo',
            rm = 'DiagnosticInfo',
            ['r?'] = 'DiagnosticInfo',
            ['!'] = 'DiagnosticError',
            t = 'DiagnosticError',
          }
          return mode_color[vim.fn.mode()] or 'Normal'
        end,
        padding = { right = 1 },
      }

      ins_left {
        'filesize',
        cond = conditions.buffer_not_empty,
      }

      ins_left {
        'filename',
        path = 2,
        cond = conditions.buffer_not_empty,
        color = { gui = 'bold' },
      }

      ins_left { 'location' }

      ins_left { 'progress', color = { gui = 'bold' } }

      ins_left {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ' },
      }

      ins_left {
        function()
          return '%='
        end,
      }

      ins_left {
        function()
          local msg = 'No Active Lsp'
          local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
          local clients = vim.lsp.get_clients()
          if next(clients) == nil then
            return msg
          end
          for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
              return client.name
            end
          end
          return msg
        end,
        icon = ' LSP:',
        color = { gui = 'bold' },
      }

      ins_right {
        'o:encoding',
        fmt = string.upper,
        cond = conditions.hide_in_width,
        color = { gui = 'bold' },
      }

      ins_right {
        'fileformat',
        fmt = string.upper,
        icons_enabled = false,
        color = { gui = 'bold' },
      }

      ins_right {
        'branch',
        icon = '',
        color = { gui = 'bold' },
      }

      ins_right {
        'diff',
        symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
        cond = conditions.hide_in_width,
      }

      ins_right {
        function()
          return '▊'
        end,
        color = 'Title',
        padding = { left = 1 },
      }

      lualine.setup(config)
    end,
  },
  {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'

      -- REQUIRED
      harpoon:setup {
        settings = {
          save_on_toggle = true,
        },
      }

      -- Setup keymaps
      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end)

      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      vim.keymap.set('n', '<C-h>', function()
        harpoon:list():select(1)
      end)

      -- Uncomment these if you want to use them
      -- vim.keymap.set("n", "<C-t>", function()
      --   harpoon:list():select(2)
      -- end)

      -- vim.keymap.set("n", "<C-n>", function()
      --   harpoon:list():select(3)
      -- end)

      -- vim.keymap.set("n", "<C-s>", function()
      --   harpoon:list():select(4)
      -- end)

      -- vim.keymap.set("n", "<C-S-P>", function()
      --   harpoon:list():prev()
      -- end)

      vim.keymap.set('n', '<C-S-N>', function()
        harpoon:list():next()
      end)
    end,
  },
  {
    'github/copilot.vim',
    lazy = false,
    config = function()
      vim.g.copilot_no_tab_map = true -- Prevent default tab mapping
      vim.api.nvim_set_keymap('i', '<C-t>', 'copilot#Accept("")', { expr = true, silent = true }) -- Map Ctrl + L to accept suggestion
    end,
  },
  {
    'tpope/vim-fugitive',
    lazy = false,
    dependencies = { 'tpope/vim-rhubarb' },
  },
  -- {
  --   'ray-x/lsp_signature.nvim',
  --   event = 'InsertEnter',
  --   opts = {
  --     bind = true,
  --     handler_opts = {
  --       border = 'rounded',
  --     },
  --   },
  --   config = function(_, opts)
  --     require('lsp_signature').setup(opts)
  --   end,
  -- },
  {
    'eandrju/cellular-automaton.nvim',
    lazy = false,
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'mfussenegger/nvim-dap-python',
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio', -- Add this!
      'theHamsta/nvim-dap-virtual-text',
      'williamboman/mason.nvim',
    },
    config = function()
      local dap = require 'dap'
      local dap_python = require 'dap-python'
      local dapui = require 'dapui'
      require('nvim-dap-virtual-text').setup()

      -- local function get_python_path()
      --   -- Check if we're in a Poetry project
      --   local poetry_venv = vim.fn.trim(vim.fn.system 'poetry env info -p 2>/dev/null')
      --   if vim.v.shell_error == 0 and poetry_venv ~= '' then
      --     return poetry_venv .. '/bin/python'
      --   end
      --
      --   -- Fall back to system python
      --   return 'python3'
      -- end

      -- Setup dap-ui
      -- dapui.setup()

      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          enabled = true,
          element = 'repl',
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = '⬅',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.70 }, -- Increased from 0.50 to 0.70
              { id = 'breakpoints', size = 0.20 }, -- Decreased from 0.25 to 0.10
              { id = 'stacks', size = 0.10 }, -- Decreased from 0.25 to 0.20
            },
            size = 70, -- Increased width from 40 to 50 columns
            position = 'left',
          },
          {
            elements = {
              { id = 'repl', size = 0.9 },
              { id = 'console', size = 0.1 },
            },
            size = 20,
            position = 'bottom',
          },
        },
        floating = {
          max_height = 0.4,
          max_width = 0.4,
          border = 'rounded',
          mappings = {
            close = { 'q', '<Esc>' },
          },
        },
      }
      -- -- Hover to see variable value
      -- vim.keymap.set('n', 'K', function()
      --   require('dapui').eval()
      -- end)

      -- Setup Python debugging
      dap_python.setup 'python'
      -- dap.configurations.python = {}

      -- Auto-open/close UI when debugging starts/ends
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      -- dap.listeners.before.event_terminated['dapui_config'] = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited['dapui_config'] = function()
      --   dapui.close()
      -- end

      -- Load launch.json from project root
      -- require('dap.ext.vscode').load_launchjs(nil, { python = { 'python' } })

      -- require('dap.ext.vscode').load_launchjs(nil, { python = { 'python' }, debugpy = { 'python' } })

      vim.keymap.set('n', '<space>?', function()
        require('dapui').eval(nil, { enter = true })
      end)
      vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '⊜', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '⊘', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '⭔', texthl = 'DapStopped', linehl = 'DapStopped', numhl = '' })
      vim.fn.sign_define('DapLogPoint', { text = '◆', texthl = 'DapLogPoint', linehl = '', numhl = '' })

      vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#ffcc00' })
      vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef' })

      -- Keybindings
      vim.keymap.set('n', '<F5>', dap.continue)
      vim.keymap.set('n', '<F10>', dap.step_over)
      vim.keymap.set('n', '<F11>', dap.step_into)
      vim.keymap.set('n', '<F12>', dap.step_out)
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
      vim.keymap.set('n', '<leader>du', dapui.toggle) -- toggle UI manually
      vim.keymap.set('n', '<leader>dq', dap.terminate) -- quit debugging session
      vim.keymap.set('n', '<leader>dc', dap.continue) -- quit debugging session
    end,
  },
  { 'kevinhwang91/nvim-bqf', ft = 'qf' },
  {
    'sindrets/diffview.nvim',
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diff working tree' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File history (current file)' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'File history (repo)' },
      { '<leader>gc', '<cmd>DiffviewClose<cr>', desc = 'Close diffview' },
    },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          enabled = false,
        },
      },
    },
    keys = {
      {
        'zk',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      -- {
      --   'S',
      --   mode = { 'n', 'x', 'o' },
      --   function()
      --     require('flash').treesitter()
      --   end,
      --   desc = 'Flash Treesitter',
      -- },
      -- {
      --   'r',
      --   mode = 'o',
      --   function()
      --     require('flash').remote()
      --   end,
      --   desc = 'Remote Flash',
      -- },
      -- {
      --   'R',
      --   mode = { 'o', 'x' },
      --   function()
      --     require('flash').treesitter_search()
      --   end,
      --   desc = 'Treesitter Search',
      -- },
      -- {
      --   '<c-s>',
      --   mode = { 'c' },
      --   function()
      --     require('flash').toggle()
      --   end,
      --   desc = 'Toggle Flash Search',
      -- },
    },
  },
  -- {
  --   'blazkowolf/gruber-darker.nvim',
  --   priority = 1000,
  --   opts = {
  --     bold = false,
  --     italic = {
  --       strings = false,
  --     },
  --   },
  --   config = function(_, opts)
  --     require('gruber-darker').setup(opts)
  --     vim.cmd.colorscheme 'gruber-darker'
  --   end,
  -- },
  -- {
  --   'rebelot/kanagawa.nvim',
  --   priority = 1000,
  --   config = function()
  --     require('kanagawa').setup {
  --       compile = false,
  --       undercurl = true,
  --       commentStyle = { italic = true },
  --       functionStyle = {},
  --       keywordStyle = { italic = true },
  --       statementStyle = { bold = true },
  --       typeStyle = {},
  --       transparent = false,
  --       dimInactive = false,
  --       terminalColors = true,
  --       colors = {
  --         palette = {},
  --         theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
  --       },
  --       overrides = function(colors)
  --         return {}
  --       end,
  --       theme = 'wave',
  --       background = {
  --         dark = 'wave',
  --         light = 'lotus',
  --       },
  --     }
  --     vim.cmd.colorscheme 'kanagawa-dragon'
  --   end,
  -- },
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('github-theme').setup {
        -- ...
      }

      vim.cmd 'colorscheme github_dark_high_contrast'
    end,
  },
  -- {
  --   'ellisonleao/gruvbox.nvim',
  --   priority = 1000,
  --   config = function()
  --     require('gruvbox').setup {
  --       contrast = 'hard',
  --     }
  --     vim.o.background = 'dark'
  --     vim.cmd.colorscheme 'gruvbox'
  --   end,
  -- },
  -- {
  --   'scottmckendry/cyberdream.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('cyberdream').setup {
  --       transparent = true,
  --       theme = { variant = 'default' },
  --     }
  --     vim.cmd.colorscheme 'cyberdream'
  --   end,
  -- },
  --

  -- {
  --   'rose-pine/neovim',
  --   priority = 1000,
  --   config = function()
  --     ---@diagnostic disable-next-line: missing-fields
  --     require('rose-pine').setup {
  --       -- Disable italics
  --       styles = {
  --         bold = true,
  --         italic = false,
  --         keywords = { italic = false },
  --         functions = { italic = false },
  --         conditionals = { italic = false },
  --         loops = { italic = false },
  --         variables = { italic = false },
  --         comments = { italic = false },
  --       },
  --       -- Make background transparent/disabled
  --       -- disable_background = true,
  --     }
  --
  --     -- Load the colorscheme
  --     vim.cmd.colorscheme 'rose-pine'
  --
  --     -- Set background to pure black for general UI
  --     vim.cmd [[highlight Normal guibg=#000000]]
  --     -- vim.cmd [[highlight NormalFloat guibg=#000000]]
  --     vim.cmd [[highlight NormalNC guibg=#000000]]
  --
  --     -- Set Telescope elements to have black background
  --     vim.cmd [[highlight TelescopeNormal guibg=#000000]]
  --     vim.cmd [[highlight TelescopePrompt guibg=#000000]]
  --     vim.cmd [[highlight TelescopeResults guibg=#000000]]
  --
  --     -- ============================
  --     -- vim.cmd [[highlight TelescopePromptBorder guibg=#000000 guifg=#000000]]
  --     -- vim.cmd [[highlight TelescopeResultsBorder guibg=#000000 guifg=#000000]]
  --     -- vim.cmd [[highlight TelescopePreviewBorder guibg=#000000 guifg=#000000]]
  --     -- vim.cmd [[highlight TelescopePreviewTitle guibg=#000000]]
  --     -- vim.cmd [[highlight TelescopePromptTitle guibg=#000000]]
  --     -- vim.cmd [[highlight TelescopeResultsTitle guibg=#000000]]
  --     -- vim.cmd [[highlight TelescopeSelection guibg=#101010]] -- Slightly lighter for selection
  --     -- vim.cmd [[highlight TelescopePreviewNormal guibg=#000000]]
  --   end,
  -- },
}
