-- function for easier remaps
local function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

local function nmap(shortcut, command)
  map('n', shortcut, command)
end

local function imap(shortcut, command)
  map('i', shortcut, command)
end

-- Mappings
--[[ imap("dj", "<ESC>") ]]

-- buffer navigation
--[[ nmap("<Tab>", ":tabnext<CR>") ]]
--[[ nmap("<S-Tab>", ":tabprevious<CR>") ]]
nmap("<Tab>", ":BufferLineCycleNext<CR>")
nmap("<S-Tab>", ":BufferLineCyclePrev<CR>")
nmap("<S-x>", ":bdelete<CR>")

-- file tree
-- nmap("<leader>e", ":NERDTreeFind<CR>")

-- navigation mappings
map("n", "<Bslash>w", ":HopWordAC<CR>")
map("n", "<Bslash>b", ":HopWordBC<CR>")
map("n", "<Bslash>j", ":HopLineAC<CR>")
map("n", "<Bslash>k", ":HopLineBC<CR>")
map("n", "<Bslash>f", ":HopChar1AC<CR>")
map("n", "<Bslash>F", ":HopChar1BC<CR>")

-- telescope mappings
nmap('<C-p>', ':Telescope find_files<CR>')
nmap('<leader>fs', ':Telescope live_grep<CR>')
nmap('<leader>fb', ':Telescope buffers<CR>')
nmap('<leader>fh', ':Telescope help_tags<CR>')
nmap('<leader>fg', ':Telescope git_status<CR>')
-- vim.api.nvim_set_keymap('n', '<leader>fgs', ':Telescope git_status<CR>', {noremap = false})

nmap('g.', '<C-I>')

vim.cmd [[
" visual line mode mappings
" stay at the bottom of the yanked text after yanking 
xnoremap y ygv<ESC>
]]

-- horizontal scroll
nmap("<C-L>", "20zl")
nmap("<C-H>", "20zh")

-- magic function for to search for selected text
vim.cmd [[
function! s:getSelectedText()
  let l:old_reg = getreg('"')
  let l:old_regtype = getregtype('"')
  norm gvy
  let l:ret = getreg('"')
  call setreg('"', l:old_reg, l:old_regtype)
  exe "norm \<Esc>"
  return l:ret
endfunction

vnoremap <silent> * :call setreg("/",
    \ substitute(<SID>getSelectedText(),
    \ '\_s\+',
    \ '\\_s\\+', 'g')
    \ )<Cr>n

vnoremap <silent> # :call setreg("?",
    \ substitute(<SID>getSelectedText(),
    \ '\_s\+',
    \ '\\_s\\+', 'g')
    \ )<Cr>n
]]
