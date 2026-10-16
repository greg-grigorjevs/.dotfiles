return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('nvim-treesitter-textobjects').setup({
      select = {
        lookahead = true,
        selection_modes = function(opts)
          if opts.query_string == '@parameter.inner' or opts.query_string == '@parameter.outer' then
            return 'v'
          end
          return 'V'
        end,
      },
      move = { set_jumps = true },
    })

    local select_textobject = require('nvim-treesitter-textobjects.select').select_textobject
    local function map_select(lhs, query)
      vim.keymap.set({ 'x', 'o' }, lhs, function()
        select_textobject(query, 'textobjects')
      end, { desc = 'Select ' .. query })
    end

    map_select('af', '@function.outer')
    map_select('if', '@function.inner')
    map_select('ik', '@block.inner')
    map_select('ak', '@block.outer')
    map_select('ac', '@comment.outer')
    map_select('ii', '@conditional.inner')
    map_select('ai', '@conditional.outer')
    map_select('al', '@loop.outer')
    map_select('il', '@loop.inner')
    map_select('as', '@statement.outer')
    map_select('aa', '@parameter.inner')
    map_select('aA', '@parameter.outer')

    local move = require('nvim-treesitter-textobjects.move')
    vim.keymap.set({ 'n', 'x', 'o' }, ']a', function()
      move.goto_next_start('@parameter.inner', 'textobjects')
    end, { desc = 'Next parameter' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[a', function()
      move.goto_previous_start('@parameter.inner', 'textobjects')
    end, { desc = 'Previous parameter' })

    local swap = require('nvim-treesitter-textobjects.swap')
    vim.keymap.set('n', '<leader>a', function()
      swap.swap_next('@parameter.inner', 'textobjects')
    end, { desc = 'Swap with next parameter' })

    local repeat_move = require('nvim-treesitter-textobjects.repeatable_move')
    vim.keymap.set({ 'n', 'x', 'o' }, ';', repeat_move.repeat_last_move)
    vim.keymap.set({ 'n', 'x', 'o' }, ',', repeat_move.repeat_last_move_opposite)
  end,
}
