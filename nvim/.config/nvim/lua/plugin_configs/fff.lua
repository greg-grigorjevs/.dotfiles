return {
  {
    'dmtrKovalenko/fff',
    build = function()
      require('fff.download').download_or_build_binary()
    end,
    lazy = true,
    opts = {
      max_results = 100,
      prompt_vim_mode = false,
      layout = {
        width = 0.99,
        height = 0.99,
        preview_size = 0.5,
        path_shorten_strategy = 'start',
        prompt_position = 'top',
      },
      preview = {
        enabled = true,
      },
      grep = {
        max_file_size = 10 * 1024 * 1024,
        max_matches_per_file = 100,
        smart_case = true,
        modes = { 'plain', 'regex', 'fuzzy' },
      },
      frecency = {
        enabled = true,
      },
      history = {
        enabled = true,
      },
      mappings = {
        i = {
          ['<C-h>'] = function() require('custom.fff').add_to_harpoon() end,
          ['<C-l>'] = function() require('custom.fff').delete_file() end,
          ['<C-y>'] = function() require('custom.fff').copy_path() end,
          ['<M-n>'] = function() require('custom.fff').create_file() end,
        },
      },
    },
  },
}
