return {
  "stevearc/conform.nvim",
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = 'ConformInfo',
  config = function()
    local conform = require('conform')
    conform.setup({
      formatters = {
        ['blade-formatter'] = {
          append_args = { '--sort-html-attributes=code-guide', '--sort-tailwindcss-classes' }
        }
      },
      formatters_by_ft = {
        blade = { 'blade-formatter' },
        nix = { 'nixpkgs_fmt' },
        html = { 'prettierd' },
        javascript = { 'prettierd' },
        swift = { 'swiftformat' }
      },
      format_on_save = function()
        -- disable autosafe for php and js at zabbix
        local work_dir = vim.fs.normalize(vim.fn.expand("~/work"))
        local file_path = vim.fs.normalize(vim.api.nvim_buf_get_name(0))

        local file_is_in_work = file_path ~= ""
            and (
              file_path == work_dir
              or vim.startswith(file_path, work_dir .. "/")
            )

        local disabled_filetype = vim.tbl_contains({
          "php",
          "javascript",
          "javascriptreact",
        }, vim.bo.filetype)

        if vim.b.disable_autoformat
            or (file_is_in_work and disabled_filetype) then
          return
        end

        return { lsp_format = "fallback", timeout_ms = 3000 }
      end
    })

    -- Keymaps
    vim.keymap.set({ "n" }, "<leader>hd", function()
      vim.b.disable_autoformat = not vim.b.disable_autoformat
    end, { desc = "Toggle buffer autoformat", noremap = true })

    vim.keymap.set({ "n", "v" }, "<leader>hf", function()
      conform.format({
        lsp_fallback = true,
        async = true,
        timeout_ms = 3000
      })
    end, { desc = "Format file or range using conform" })
  end
}
