-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- True color in tmux
if vim.env.TMUX then
  vim.g.termguicolors = true
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("active_win_border", { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, "ActiveWinSep", { fg = "#7aa2f7", bold = true })
    vim.api.nvim_set_hl(0, "InactiveWinSep", { fg = "#3b4261" })
  end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("highlight_active_win", { clear = true }),
  callback = function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if win == vim.api.nvim_get_current_win() then
        vim.wo[win].winhighlight = "WinSeparator:ActiveWinSep"
      else
        vim.wo[win].winhighlight = "WinSeparator:InactiveWinSep"
      end
    end
  end,
})
