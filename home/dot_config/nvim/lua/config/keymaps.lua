-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local function win_cycle(dir)
  local cur = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. dir)
  if vim.api.nvim_get_current_win() == cur then
    local opposite = ({ h = "l", l = "h", k = "j", j = "k" })[dir]
    vim.cmd("99wincmd " .. opposite)
  end
end

vim.keymap.set("n", "<C-w>h", function() win_cycle("h") end, { desc = "Cycle window left" })
vim.keymap.set("n", "<C-w>l", function() win_cycle("l") end, { desc = "Cycle window right" })
vim.keymap.set("n", "<C-w>k", function() win_cycle("k") end, { desc = "Cycle window up" })
vim.keymap.set("n", "<C-w>j", function() win_cycle("j") end, { desc = "Cycle window down" })
