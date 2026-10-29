return {
  'MunifTanjim/prettier.nvim',
  ft = { 'css', 'graphql', 'html', 'javascript', 'javascriptreact', 'json', 'less', 'markdown', 'scss', 'typescript', 'typescriptreact', 'yaml' },
  cmd = 'Prettier',
  dependencies = { 'nvimtools/none-ls.nvim' },
  config = function()
    require('prettier').setup({
      bin = 'prettierd', -- or `'prettierd'` (v0.23.3+)
      filetypes = {
        "css",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "less",
        "markdown",
        "scss",
        "typescript",
        "typescriptreact",
        "yaml",
      },
    })
  end
}
