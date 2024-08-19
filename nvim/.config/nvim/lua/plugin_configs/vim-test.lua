return {
  "vim-test/vim-test",
  config = function()
    vim.cmd([[
        let test#php#phpunit#executable = 'php artisan test'
        " let test#strategy = 'floaterm'
        let test#strategy = 'neovim_sticky'
        let test#neovim#term_position = "vert"
        let test#neovim_sticky#reopen_window = 1
      ]])
  end
}
