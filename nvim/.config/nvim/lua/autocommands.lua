vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function(data)
		local directory = vim.fn.isdirectory(data.file) == 1
		if not directory then
			return
		end
		vim.api.nvim_set_current_dir(data.file)
		require("nvim-tree.api").tree.open()
		-- require("oil").open()
	end
})
