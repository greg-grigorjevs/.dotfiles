vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function(data)
    -- vim.print(vim.fn.expand("%:p:h"))
    vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    if not directory then
      return
    end

    -- create a new, empty buffer
    vim.cmd.enew()

    -- wipe the directory buffer
    vim.cmd.bw(data.buf)

    -- change to the directory
    vim.cmd.cd(data.file)

    -- open the tree
    require("oil").open()
  end
})
