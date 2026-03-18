vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.colorcolumn = '120'

-- -- Make line numbers more visible (overrides any colorscheme)
-- vim.api.nvim_create_autocmd('ColorScheme', {
--   callback = function()
--     vim.api.nvim_set_hl(0, 'LineNr', { fg = '#7f849c' })
--     vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#cdd6f4', bold = true })
--   end,
-- })
