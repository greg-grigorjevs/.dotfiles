return {
  'echasnovski/mini.nvim',
  config = function()
    require('mini.comment').setup({
      options = {
        custom_commentstring = function()
          local curline = vim.fn.line(".")
          local lang = vim.treesitter.get_parser():language_for_range({ curline, 0, curline, 0 }):lang()
          -- vim.print(lang)
          if vim.bo.filetype == 'blade' then
            curline = vim.fn.line(".")
            lang = vim.treesitter.get_parser():language_for_range({ curline, 0, curline, 0 }):lang()
            -- vim.print(lang)
            if lang == 'php' or lang == 'php_only' or lang == 'javascript' then
              return '// %s'
            end
            return '{{-- %s --}}'
          elseif vim.bo.filetype == 'php' then
            return '// %s'
          else
            return nil
          end
        end
      }
    })
  end
}
