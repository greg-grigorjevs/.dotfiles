return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local plugin_dir = require('lazy.core.config').plugins['nvim-treesitter'].dir
    local parsers = {
      'php',
      'php_only',
      'lua',
      'html',
      'css',
      'markdown',
      'markdown_inline',
      'javascript',
      'nix',
      'bash',
      'xml',
      'yaml',
      'svelte',
      'tsx',
    }
    local parser_set = {}
    for _, parser in ipairs(parsers) do
      parser_set[parser] = true
    end

    -- The rewritten plugin stores its bundled queries under runtime/queries.
    -- Reuse the already-installed parser binaries in the plugin directory.
    vim.opt.rtp:prepend(plugin_dir .. '/runtime')
    require('nvim-treesitter').setup({ install_dir = plugin_dir })

    if vim.fn.executable('tree-sitter') == 1 then
      local missing_parsers = vim.tbl_filter(function(parser)
        return vim.fn.filereadable(plugin_dir .. '/parser/' .. parser .. '.so') ~= 1
      end, parsers)
      if #missing_parsers > 0 then
        require('nvim-treesitter').install(missing_parsers)
      end
    end

    local indent_filetypes = {
      php = true,
      blade = true,
      yaml = true,
      svelte = true,
      jsx = true,
      tsx = true,
      markdown = true,
    }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function(event)
        local filetype = vim.bo[event.buf].filetype
        if filetype == 'conf' then
          return
        end

        local language = vim.treesitter.language.get_lang(filetype)
        local has_parser = language and parser_set[language]
          and pcall(vim.treesitter.language.inspect, language)
        if has_parser then
          vim.treesitter.start(event.buf, language)
          if indent_filetypes[filetype] then
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end
      end,
    })

    -- Use the standalone commentstring plugin, not its legacy nvim-treesitter module.
    vim.g.skip_ts_context_commentstring_module = true
    require('ts_context_commentstring').setup({ enable_autocmd = false })
  end,
}
