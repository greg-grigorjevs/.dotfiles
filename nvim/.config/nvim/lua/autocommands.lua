vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function(data)
		local directory = vim.fn.isdirectory(data.file) == 1
		if not directory and (vim.fn.argc() > 0 or vim.api.nvim_buf_get_name(0) ~= "" or vim.bo.modified) then
			return
		end
		if directory then
			vim.api.nvim_set_current_dir(data.file)
		end
		vim.schedule(function()
			require("fff").find_files()
		end)
	end
})

local columns = vim.o.columns
local resize_group = vim.api.nvim_create_augroup("PreserveSplitWidths", { clear = true })

local function vertical_pair(tab)
	local layout = vim.fn.winlayout(vim.api.nvim_tabpage_get_number(tab))
	if layout[1] == "row" and #layout[2] == 2
		and layout[2][1][1] == "leaf" and layout[2][2][1] == "leaf" then
		return layout[2][1][2], layout[2][2][2]
	end
end

local function remember_widths()
	local tab = vim.api.nvim_get_current_tabpage()
	local left, right = vertical_pair(tab)
	if left then
		local width = vim.api.nvim_win_get_width(left)
		local total = width + vim.api.nvim_win_get_width(right)
		local saved = vim.t[tab].split_widths
		if not saved or saved.left ~= left or saved.right ~= right
			or saved.width ~= width or saved.total ~= total then
			vim.t[tab].split_widths = { left = left, right = right, width = width, total = total, ratio = width / total }
		end
	else
		vim.t[tab].split_widths = nil
	end
end

vim.api.nvim_create_autocmd({ "WinResized", "VimEnter" }, {
	group = resize_group,
	callback = function()
		if vim.o.columns == columns then
			remember_widths()
		end
	end,
})

vim.api.nvim_create_autocmd({ "VimResized", "TabEnter" }, {
	group = resize_group,
	callback = function()
		local tab = vim.api.nvim_get_current_tabpage()
		local saved = vim.t[tab].split_widths
		local left, right = vertical_pair(tab)
		if saved and saved.left == left and saved.right == right then
			local total = vim.api.nvim_win_get_width(left) + vim.api.nvim_win_get_width(right)
			vim.api.nvim_win_set_width(left, math.floor(total * saved.ratio + 0.5))
			saved.width = vim.api.nvim_win_get_width(left)
			saved.total = saved.width + vim.api.nvim_win_get_width(right)
			vim.t[tab].split_widths = saved
		end
		columns = vim.o.columns
		remember_widths()
	end,
})
