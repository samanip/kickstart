vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.colorcolumn = '120'

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true
  end,
})

-- -- Make line numbers more visible (overrides any colorscheme)
-- vim.api.nvim_create_autocmd('ColorScheme', {
--   callback = function()
--     vim.api.nvim_set_hl(0, 'LineNr', { fg = '#7f849c' })
--     vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#cdd6f4', bold = true })
--   end,
-- })
