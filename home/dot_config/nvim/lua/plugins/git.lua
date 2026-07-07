return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", function() gs.nav_hunk("next") end, "Next Hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Prev Hunk")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghs", gs.stage_hunk, "Stage Hunk")
        map("n", "<leader>ghr", gs.reset_hunk, "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", function() gs.reset_hunk({ target = "staged" }) end, "Undo Stage Hunk")
        map("n", "<leader>ghd", gs.diffthis, "Diff Against Index")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff Against Last Commit")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
      end,
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gs", "<cmd>DiffviewOpen --staged<cr>", desc = "Diffview Staged" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
    },
    opts = {
      view = {
        default = { winbar_info = true },
        merge_tool = { layout = "diff3_mixed" },
      },
      hooks = {
        diff_buf_read = function(bufnr)
          vim.bo[bufnr].modifiable = false
          vim.bo[bufnr].readonly = true
        end,
        diff_buf_win_enter = function(bufnr)
          local name = vim.api.nvim_buf_get_name(bufnr)
          if not name:find("diffview://") then
            vim.bo[bufnr].modifiable = true
            vim.bo[bufnr].readonly = false
          end
        end,
        view_enter = function(view)
          view._cwk_bufs = {}
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local buf = vim.api.nvim_win_get_buf(win)
            if not vim.tbl_contains(view._cwk_bufs, buf) then
              table.insert(view._cwk_bufs, buf)
              vim.keymap.set("n", "<C-w>k", function()
                local wins = vim.api.nvim_tabpage_list_wins(0)
                for _, w in ipairs(wins) do
                  local b = vim.api.nvim_win_get_buf(w)
                  local name = vim.api.nvim_buf_get_name(b)
                  if not name:find("diffview://") and not name:find("DiffviewFilePanel") then
                    vim.api.nvim_set_current_win(w)
                    return
                  end
                end
                vim.cmd("wincmd k")
              end, { buffer = buf })
            end
          end
        end,
        view_leave = function(view)
          for _, buf in ipairs(view._cwk_bufs or {}) do
            if vim.api.nvim_buf_is_valid(buf) then
              pcall(vim.keymap.del, "n", "<C-w>k", { buffer = buf })
            end
          end
          view._cwk_bufs = nil
        end,
      },
    },
  },
}
