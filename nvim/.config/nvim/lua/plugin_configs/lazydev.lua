return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        { path = '~/.hammerspoon/Spoons/EmmyLua.spoon/annotations', words = { 'hs' } }
      }
    }
  },
}
