-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'

      -- REQUIRED
      harpoon:setup()

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
    'ray-x/lsp_signature.nvim',
    event = 'InsertEnter',
    opts = {
      bind = true,
      handler_opts = {
        border = 'rounded',
      },
    },
    config = function(_, opts)
      require('lsp_signature').setup(opts)
    end,
  },
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
}
