local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = '<c-d>', -- binding to scroll down inside the popup
		scroll_up = '<c-u>', -- binding to scroll up inside the popup
	},
	window = {
		border = "none", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>", "<Space>"}, -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	e = { "<cmd>NvimTreeFindFileToggle<cr>", "File Tree" },

	p = {
		name = "Packer",
		c = { "<cmd>PackerCompile<cr>", "Compile" },
		i = { "<cmd>PackerInstall<cr>", "Install" },
		s = { "<cmd>PackerSync<cr>", "Sync" },
		S = { "<cmd>PackerStatus<cr>", "Status" },
		u = { "<cmd>PackerUpdate<cr>", "Update" }
	},

	f = {
		name = "Telescope",
		a = { "<cmd>Telescope find_files no_ignore=true hidden=true<cr>", "All Files" },
		s = { "<cmd>Telescope live_grep<cr>", "Grep Search" },
		b = { "<cmd>Telescope buffers sort_mru=true<cr>", "Buffers" },
		h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
		g = { "<cmd>Telescope git_status<cr>", "Git Status" },
		y = { "<cmd>Telescope neoclip plus<cr>", "Yank History" },
		r = { "<cmd>Telescope resume<cr>", "Last Search" },
		o = { "<cmd>Telescope builtin<cr>", "List Telescope Options" },
		u = { "<cmd>Telescope oldfiles<cr>", "Recently Opened Files" },
		p = { "<cmd>Telescope harpoon marks<cr>", "Har[p]oon" },
    j = { "<cmd>Telescope jumplist show_line=false<cr>", "[J]umplist" },
		['/'] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Search Current File" },
		l = {
			name = "LSP",
			s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
			S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
			r = { "<cmd>Telescope lsp_references<cr>", "LSP References" },
			d = { "<cmd>Telescope diagnonstics<cr>", "LSP Diagnostics" },
		},
    m = {
      name = "Book[M]arks",
      a = { "<cmd>lua require('telescope').extensions.vim_bookmarks.all()<cr>", "Show [A]ll bookmarks" },
      c = { "<cmd>lua require('telescope').extensions.vim_bookmarks.current_file()<cr>", "Show bookmarks in the [c]urrent buffer" },
    }
	},

	g = {
		name = "Git",
		-- g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
		j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
		k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
		l = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Blame Toggle" },
		b = { "<cmd>Gitsigns blame_line<cr>", "Blame Line" },
		p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
		r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
		R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
		s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
		u = {
			"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
			"Undo Stage Hunk",
		},
		-- o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
		B = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
		d = {
			"<cmd>Gitsigns diffthis HEAD<cr>",
			"Diff",
		},
	},

  b = {
    name = "Buffers",
    p = {"<cmd>BufferPin<cr>", "Pin a buffer"},
    P = {"<cmd>BufferPick<cr>", "Pick a buffer"},
    x = {"<cmd>BufferCloseAllButCurrentOrPinned<cr>", "Close all buffers except current or pinned ones"},
    X = {"<cmd>BufferCloseAllButCurrent<cr>", "Close all buffer except current"},
    f = {"<cmd>BufferFirst<cr>", "Go to [f]irst buffer"},
  },

	t = {
		name = "Terminal",
		g = { "<cmd>FloatermNew --autoclose=2 --name=lazygit lazygit --use-config-file=\"$HOME/.dotfiles/lazygit/.config/lazygit/config.yml\"<cr>", "lazygit" },
		K = { "<cmd>FloatermKill!<cr>", "Kill all terminals" },
		t = { "<cmd>FloatermShow lazygit<cr>", "[T]oggle existing lazygit if exists" },
	},

	h = {
		name = 'Format/Harpoon',
		p = { "<cmd>Prettier<cr>", "Prettier" },
		-- f = { "<cmd>CocCommand editor.action.formatDocument<cr>", "Format" }
		f = { "<cmd>Format<cr>", 'LSP Format' },
		a = { "<cmd>lua require 'harpoon.mark'.add_file()<cr>", "Add file to bookmarks" },
		t = { "<cmd>lua require 'harpoon.ui'.toggle_quick_menu()<cr>", "Toggle harpoon" },
	},

	x = {
		name = 'Trouble',
		x = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
		w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
		d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
		r = { "<cmd>TroubleToggle lsp_references<cr>", "LSP References" },
	},

  s = {
    name = 'Session',
    w = { "<cmd>SaveSession<cr>", "Save" },
    r = { "<cmd>RestoreSession<cr>", "Restore" },
  },

	w = { "<cmd>w<cr>", "Save File" },
	W = { "<cmd>wa<cr>", "Save All Files" },
	q = { "<cmd>q<cr>", "Close File" },
	Q = { "<cmd>qa<cr>", "Quit Nvim" },

	["%"] = { "<cmd>w<bar>so %<cr>", "Save and source current file" },

}

-- Try to make it work
--[[ local harpoon_mappings = {} ]]
--[[ for i = 0, 9, 1 do ]]
--[[ 	local key = string.format("<M-%s>", i+1) ]]
--[[ 	local value = string.format("<cmd>lua require'harpoon.ui'.nav_file(%s)<cr>", i+1) ]]
--[[ 	table.insert(harpoon_mappings, {[key] = {value}}) ]]
--[[ end ]]
--[[ print(harpoon_mappings["<M-1>"]) ]]

local which_key = require("which-key");
which_key.setup(setup);
which_key.register(mappings, opts);
which_key.register({
	["<C-\\>"] = { "<cmd>FloatermToggle ft1 --width=0.9 --height=0.9<cr>", "Toggle Terminal" },
});

-- harpoon mappings
which_key.register({
	["<M-1>"] = { "<cmd>lua require'harpoon.ui'.nav_file(1)<cr>", "Harpoon open file 1" },
	["<M-2>"] = { "<cmd>lua require'harpoon.ui'.nav_file(2)<cr>", "Harpoon open file 2" },
	["<M-3>"] = { "<cmd>lua require'harpoon.ui'.nav_file(3)<cr>", "Harpoon open file 3" },
	["<M-4>"] = { "<cmd>lua require'harpoon.ui'.nav_file(4)<cr>", "Harpoon open file 4" },
	["<M-5>"] = { "<cmd>lua require'harpoon.ui'.nav_file(5)<cr>", "Harpoon open file 5" },
	["<M-6>"] = { "<cmd>lua require'harpoon.ui'.nav_file(6)<cr>", "Harpoon open file 6" },
})

--[[ which_key.register(harpoon_mappings) ]]
--[[ which_key.register({
  ["<C-\\"] = {"<C-\\><C-n><cmd>FloatermToggle<cr>"}
}, {mode = "t"}); ]]
-- couldn't make it work using which-key syntax
vim.cmd [[
  tnoremap <C-\> <C-\><C-n>:FloatermToggle<cr>
  tnoremap dj <C-\><C-n>
]]
