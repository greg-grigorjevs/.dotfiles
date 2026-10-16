-- my old vimrc has good explanations for most of the settings actually
-- there are some default options for nvim which can be checked here
-- dttps://www.rogin.xyz/blog/sensible-neovim so they are not included here

-- basic settings
-- stop from auto inserting comments on the next line
vim.cmd("autocmd FileType * set formatoptions-=cro")
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.cmd("set clipboard+=unnamedplus")       -- use system clipboard
vim.o.mouse = "a"                           -- use mouse
vim.o.wrap = false
vim.o.startofline = true                    -- don't know what this does
vim.o.completeopt = 'menu,menuone,noselect' -- completion window behaviour
vim.o.swapfile = false

-- Mapping waiting time
-- vim.o.timeout = false
vim.o.ttimeout = true
vim.o.ttimeoutlen = 100

vim.o.timeoutlen = 300


-- Display
vim.o.showmatch = true
vim.o.scrolloff = 15 -- auto-scroll near top/bottom
vim.o.sidescrolloff = 5

-- vim.o.list = true -- shows whitespaces

-- Sidebar
-- Very weird stuff with signcolumn, only managed to make it work in the
-- gitsigns-config file in the on_attach method
-- vim.o.signcolumn = 'yes' -- keep 1 column for coc.vim, not sure what it's for but it adds a weird space to the left
-- vim.wo.signcolumn='yes'
-- signcolumn = auto
-- signcolumn = auto
vim.wo.signcolumn = "yes:2"
vim.o.number = true   -- shows line number
vim.o.numberwidth = 2 -- always reserve 3 spaces for line number

-- Search
vim.cmd [[:set nohlsearch]]
vim.o.ignorecase = true
vim.o.smartcase = true

-- Indentation
vim.o.formatoptions =
'qnj1' -- q  - comment formatting; n - numbered lists; j - remove comment when joining lines; 1 - don't break after one-letter word
vim.o.smartindent = true
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.o.undofile = true -- save undo history
vim.o.splitbelow = true
vim.o.splitright = true
vim.opt.formatoptions:remove { "c", "r", "o" }

-- Bracket colors
-- hi MatchParen cterm=NONE guibg=NONE ctermbg=NONE gui=NONE
-- disables match parentheses highlighting

vim.o.termguicolors = true

-- Colorschemes config
-- gruvbox-baby config, order is important
local colors = require("gruvbox-baby.colors").config()
vim.g.gruvbox_baby_highlights = {
  TelescopeSelection = { fg = colors.orange },
  -- Flash highlight groups
  FlashMatch = { bg = colors.blue_gray, fg = colors.dark },
  FlashCurrent = { bg = colors.blue_gray, fg = colors.dark },
  -- Git
  -- GitSignsAdd = { fg = colors.light_blue },
  GitSignsChange = { fg = colors.bright_yellow },
  GitSignsDelete = { fg = colors.red },
  --[[ FlashLabel = { bg = colors.bright_yellow, fg = colors.dark }, ]]
  FlashLabel = { bg = colors.milk, fg = colors.dark },

  ["@keyword.directive.markdown"] = { fg = colors.blue_gray },
  ["@markup.link.label.markdown_inline"] = { fg = colors.blue_gray },
  ["@markup.heading"] = { fg = colors.milk },

  -- Blade
  ["@tag"] = { fg = "#ff8715" },
  ["@tag.attribute"] = { fg = colors.light_blue },
  ["@tag.delimiter"] = { fg = colors.foreground },
  ["@tag.blade"] = { fg = colors.red },
  ["@variable.member"] = { fg = colors.blue_gray },

}
vim.g.gruvbox_baby_background_color = "dark"
vim.g.gruvbox_baby_function_style = "NONE"
-- vim.g.gruvbox_baby_keyword_style = "NONE"
--[[ vim.g.gruvbox_baby_comment_style = "italic" ]]
--[[ vim.g.gruvbox_baby_telescope_theme = 0 ]]
vim.g.gruvbox_baby_use_original_palette = 1
vim.cmd('colorscheme gruvbox-baby')

--gruvbox-material config
vim.g.gruvbox_material_foreground = "original"
vim.g.gruvbox_material_background = "medium"
--[[ vim.g.gruvbox_material_better_performance = 1 ]]
--[[ vim.cmd('colorscheme gruvbox-material') ]]

-- material colorcheme config
vim.g.material_style = 'palenight'

-- community gruvbox for neovim config
--[[ vim.o.background = 'dark' ]]
--[[ vim.cmd('colorscheme gruvbox') ]]

-- vim.g.matchup_enabled = 0
vim.g.matchup_matchparen_enabled = 0

vim.g.tmux_navigator_no_mappings = 1
vim.cmd('highlight Matchparen guibg=none gui=bold,underline')

vim.cmd [[autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab]]
vim.cmd [[autocmd FileType swift setlocal ts=4 sts=4 sw=4 expandtab]]
vim.cmd [[
  let &t_ZH="\e[3m"
  let &t_ZR="\e[23m"
]]

-- remember last position
vim.cmd [[ autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif  ]]

-- Autocommands
-- Custom Commands


-- highlight the line number but not the whole line
vim.cmd [[
  set cursorline
  hi clear CursorLine
  augroup CLClear
  autocmd! ColorScheme * hi clear CursorLine
  augroup END
]]

-- always open help in vertical left split (bo for right)
vim.cmd('cabbrev h vert to h')

vim.api.nvim_create_user_command('ReloadBrowser', function()
  vim.cmd([[
    silent exe "!osascript -e 'tell app \"Google Chrome\" to activate\<cr>
            \tell app \"System events\"\<cr> keystroke \"r\" using command down\<cr>
            \end tell'"
    silent exe "!osascript -e 'tell app \"Kitty\" to activate'"
]])
end, { nargs = '*' })

vim.treesitter.language.register('bash', 'zsh')
vim.filetype.add({
  pattern = {
    ['.*%.blade%.php'] = 'php',
    ['.*%.plist'] = 'xml',
    ['.*%.entitlements'] = 'xml',
    ['.*%.xcconfig'] = 'config',
  }
})
