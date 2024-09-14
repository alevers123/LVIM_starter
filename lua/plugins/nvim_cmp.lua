return {
  -- {
  --   "folke/noice.nvim",
  --   opts = function(_, opts)
  --     opts.lsp.signature = {
  --       auto_open = { enabled = false },
  --     }
  --   end,
  -- },
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")

      local map_func1 = cmp.mapping(function(fallback)
        if cmp.visible() then
          -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
          cmp.select_next_item()
        elseif vim.snippet ~= nil and vim.snippet.active({ direction = 1 }) then
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" })

      local map_func2 = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.snippet.active({ direction = -1 }) then
          vim.schedule(function()
            vim.snippet.jump(-1)
          end)
        else
          fallback()
        end
      end, { "i", "s" })
      print(vim.inspect(opts.mapping))
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = map_func1,
        ["<S-Tab>"] = map_func2,
        ["<C-j>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            return cmp.select_next_item()
          end
          fallback()
        end, { "i", "c", "s" }),
        ["<C-k>"] = map_func2,
        ["<C-h>"] = cmp.mapping.scroll_docs(4),
        ["<C-l>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.close_docs(),
      })
      print(vim.inspect(opts.mapping))
      print(vim.inspect(opts.view))
      opts.view = { docs = { auto_open = false }, entries = { name = "custom", follow_cursor = true } }
    end,
  },
}
