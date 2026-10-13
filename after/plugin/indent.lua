-- Run after built-in filetype plugins; built-in EditorConfig applies afterwards.
local widths = {
  python = 4,
  rust = 4,
  c = 4,
  cpp = 4,
  javascript = 2,
  javascriptreact = 2,
  typescript = 2,
  typescriptreact = 2,
  json = 2,
  jsonc = 2,
  yaml = 2,
  make = 8,
}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_language_indent", { clear = true }),
  pattern = vim.tbl_keys(widths),
  callback = function(event)
    local options = vim.bo[event.buf]
    local width = widths[event.match]
    options.expandtab = event.match ~= "make"
    options.tabstop = width
    options.shiftwidth = width
    options.softtabstop = event.match == "make" and 0 or -1

    local undo = "setlocal expandtab< tabstop< shiftwidth< softtabstop<"
    local previous = vim.b[event.buf].undo_ftplugin
    vim.b[event.buf].undo_ftplugin = previous and (previous .. " | " .. undo) or undo
  end,
})
