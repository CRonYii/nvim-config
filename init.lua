-- Independent from ~/.vimrc and ~/.vim/. Add features one at a time.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Familiar display settings; language indentation lives in after/plugin/indent.lua.
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.scrolloff = 3
vim.opt.signcolumn = "yes"
vim.opt.mouse = "a"
vim.opt.splitright = true
vim.opt.wrap = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.confirm = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Local settings run after shared defaults; returned plugin specs are merged last.
local local_specs = {}
local local_path = vim.fn.stdpath("config") .. "/lua/config/local.lua"
local local_stat, local_err, local_code = vim.uv.fs_stat(local_path)
if local_stat then
  local_specs = require("config.local")
  assert(type(local_specs) == "table", "config.local must return a plugin spec list (or {})")
elseif local_code ~= "ENOENT" then
  error(local_err)
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  if vim.fn.executable("git") == 0 then
    vim.notify("lazy.nvim bootstrap requires git on PATH", vim.log.levels.ERROR)
    return
  end
  local output = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.notify(
      "Failed to clone lazy.nvim into " .. lazypath .. "\n" .. output
        .. "\nCheck GitHub access and directory permissions. Move aside any partial clone before restarting.",
      vim.log.levels.ERROR
    )
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" }, local_specs },
  checker = { enabled = false },
  change_detection = { notify = false },
})
