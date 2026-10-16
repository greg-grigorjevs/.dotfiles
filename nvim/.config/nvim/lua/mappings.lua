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
imap("<M-Left>", "<C-o>b")
imap("<M-Right>", "<C-o>w")
-- Handle Alt+Left/Right when the terminal or tmux reports them as Alt+B/F.
imap("<M-b>", "<C-o>b")
imap("<M-f>", "<C-o>w")
imap("<M-BS>", "<C-w>")
imap("<M-Del>", "<C-o>dw")
-- Kitty sends Alt+Left/Right as Esc-b/Esc-f.
imap("<Esc>b", "<C-o>b")
imap("<Esc>f", "<C-o>w")
-- Kitty sends macOS Option+Delete (backspace) as Esc followed by DEL.
imap("\27\127", "<C-w>")

-- bufferline shortcuts navigation
--[[ nmap("<Tab>", ":BufferLineCycleNext<CR>") ]]
--[[ nmap("<S-Tab>", ":BufferLineCyclePrev<CR>") ]]
--[[ nmap("<S-x>", ":bdelete<CR>") ]]

-- barbar shortcuts
--[[ nmap("<Tab>", ":BufferNext<CR>") ]]
nmap("<S-Tab>", ":BufferPrevious<CR>")
nmap("<S-x>", ":bdelete<CR>")

--[[ nmap("j", "gj"); ]]
--[[ nmap("k", "gk"); ]]
-- file tree
-- nmap("<leader>e", ":NERDTreeFind<CR>")

-- navigation mappings
-- disabled for lightspeed
--[[ map("n", "<Bslash>w", ":HopWordAC<CR>") ]]
--[[ map("n", "<Bslash>b", ":HopWordBC<CR>") ]]
--[[ map("n", "<Bslash>j", ":HopLineAC<CR>") ]]
--[[ map("n", "<Bslash>k", ":HopLineBC<CR>") ]]
--[[ map("n", "f", ":HopChar1AC<CR>") ]]
--[[ map("n", "F", ":HopChar1BC<CR>") ]]

nmap('g.', '<C-I>')

vim.cmd [[
" visual line mode mappings
" stay at the bottom of the yanked text after yanking 
xnoremap y ygv<ESC>
]]

-- Paste over a visual selection without yanking the replaced text.
vim.keymap.set("x", "p", '"_dP', { desc = "Paste without yanking replaced text" })
vim.keymap.set("x", "P", '"_dP', { desc = "Paste without yanking replaced text" })

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

-- reselect text that was just pasted in mode that it was previously yanked (v or V).  
vim.cmd [[nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]']]
