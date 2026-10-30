return {
  'jmbuhr/otter.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ft = 'phpjs',
  config = function()
    require('otter').setup({
      buffers = {
        -- ts_ls only adds a file to the jsconfig project when it exists on disk.
        write_to_disk = true,
      },
    })

    -- Otter routes requests through every LSP client attached to its virtual
    -- buffer. html/tailwindcss also attach to JavaScript and answer definition
    -- requests first with an empty result, which hides ts_ls definitions.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('otter_javascript_clients', { clear = true }),
      callback = function(event)
        local file_path = vim.api.nvim_buf_get_name(event.buf):gsub('\\', '/')
        if not file_path:match('%.otter%.js$') then
          return
        end

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and (client.name == 'html' or client.name == 'tailwindcss') then
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(event.buf) and vim.lsp.get_client_by_id(client.id) then
              vim.lsp.buf_detach_client(event.buf, client.id)
            end
          end)
        end
      end,
    })

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('zabbix_template_javascript_lsp', { clear = true }),
      pattern = 'phpjs',
      callback = function(event)
        local file_path = vim.api.nvim_buf_get_name(event.buf):gsub('\\', '/')
        if not file_path:match('ui/app/views/js/template%.edit%.js%.php$') then
          return
        end

        vim.api.nvim_buf_call(event.buf, function()
          require('otter').activate({ 'javascript' })
        end)
      end,
    })
  end,
}
