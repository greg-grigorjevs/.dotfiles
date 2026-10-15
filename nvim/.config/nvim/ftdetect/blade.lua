vim.cmd[[
  autocmd BufNewFile,BufRead *.blade.php setlocal indentexpr=v:lua.require'nvim-treesitter'.indentexpr()

  
]]
