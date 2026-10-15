vim.cmd [[
  setlocal indentexpr=v:lua.require'nvim-treesitter'.indentexpr()
]]
