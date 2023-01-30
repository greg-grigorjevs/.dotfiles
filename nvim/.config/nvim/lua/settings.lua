-- my old vimrc has good explanations for most of the settings actually
-- there are some default options for nvim which can be checked here
-- dttps://www.rogin.xyz/blog/sensible-neovim so they are not included here

-- basic settings
-- stop from auto inserting comments on the next line
vim.cmd("autocmd FileType * set formatoptions-=cro")
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.cmd("set clipboard+=unnamedplus") -- use system clipboard
vim.o.mouse = "a" -- use mouse
vim.o.wrap = false
vim.o.startofline = true -- don't know what this does
vim.o.completeopt = 'menu,menuone,noselect' -- completion window behaviour
vim.o.swapfile = false

-- Mapping waiting time
-- vim.o.timeout = false
vim.o.ttimeout = true
vim.o.ttimeoutlen = 100

vim.o.timeoutlen = 300


-- Display
vim.o.showmatch = true
vim.o.scrolloff = 5 -- auto-scroll near top/bottom
vim.o.sidescrolloff = 5

-- vim.o.list = true -- shows whitespaces

-- Sidebar
-- Very weird stuff with signcolumn, only managed to make it work in the
-- gitsigns-config file in the on_attach method
-- vim.o.signcolumn = 'yes' -- keep 1 column for coc.vim, not sure what it's for but it adds a weird space to the left
-- vim.wo.signcolumn='yes'
-- signcolumn = auto
-- signcolumn = auto
-- vim.wo.signcolumn="yes"
vim.o.number = true -- shows line number
vim.o.numberwidth = 2 -- always reserve 3 spaces for line number

-- Search
vim.cmd [[:set nohlsearch]]
vim.o.ignorecase = true
vim.o.smartcase = true

-- Indentation
vim.o.formatoptions = 'qnj1' -- q  - comment formatting; n - numbered lists; j - remove comment when joining lines; 1 - don't break after one-letter word
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = 2 -- 1 tab = 2 spaces
vim.o.shiftwidth = 2
vim.o.undofile = true -- save undo history

-- Bracket colors
-- hi MatchParen cterm=NONE guibg=NONE ctermbg=NONE gui=NONE
-- disables match parentheses highlighting

-- gruvbox config, order is important
-- vim.g.gruvbox_baby_background_color = "dark"
-- vim.g.gruvbox_baby_keyword_style = "NONE"
-- vim.g.gruvbox_baby_comment_style = "NONE"
vim.g.gruvbox_baby_telescope_theme = 0
vim.cmd('colorscheme gruvbox-baby')

vim.cmd('highlight Matchparen guibg=none gui=bold,underline')

vim.cmd [[autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab]]
vim.cmd [[
  let &t_ZH="\e[3m"
  let &t_ZR="\e[23m"
]]

-- remember last position
vim.cmd [[ autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif  ]]
