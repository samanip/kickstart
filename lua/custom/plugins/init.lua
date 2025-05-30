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
}
