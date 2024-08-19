local servers = {
  'tsserver',
  'lua_ls',
  'intelephense',
  'emmet_ls',
  'cssls',
  'jsonls',
  'html',
  'pyright',
  'svelte',
  'tailwindcss',
  'clojure_lsp',
  'pest_ls'
}
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = servers,
})

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>ld', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)


local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.diagnostic.config({ update_in_insert = true })

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  --[[ vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts) ]]
  vim.keymap.set('n', 'gd', "<cmd>TroubleToggle lsp_definitions<cr>", bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>lwa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>lwr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>lwl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>lrn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>lca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  -- vim.keymap.set('n', '<space>hf', vim.lsp.buf.format({ async = true }), bufopts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.format({ async= true })' ]]
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local lspconfig = require('lspconfig');
for _, server in ipairs(servers) do
  if server == 'lua_ls' then
    lspconfig[server].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim', 'use' }
          }
        }
      }
    }
  elseif server == 'cssls' then
    lspconfig[server].setup {
      on_attach = on_attach,
      capabilities = { textDocument = { completion = { completionItem = { snippetSupport = true } } } },
      filetypes = { 'html', 'css', 'scss', 'less' }
    }
  elseif server == 'html' then
    lspconfig[server].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "html", "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact",
        "typescript.tsx", "svelte", 'blade' },
    }
  elseif server == 'intelephense' then
    lspconfig[server].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        intelephense = {
          environment = {
            include_paths = {
              "./vendor/pestphp",
              "./vendor/phpunit/phpunit",
              -- "./vendor/laravel" -- messes up with the lsp for some reason
            }
          }
        }
      }
    }
  else
    lspconfig[server].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end
end

-- For some reason intelephense does not attach to a blade file
-- when it is the FIRST buffer that is opened after nvim is openned
-- running edit command fixes is so do it automatically only once on
-- first blade file that is opened in a session.
vim.api.nvim_create_autocmd("LspAttach", {
  once = true,
  pattern = "*.blade.php",
  callback = function()
    vim.defer_fn(function()
      vim.api.nvim_command('edit')
    end, 800)
  end,
})

--[[ lspconfig.emmet_ls.setup{
  capabilities = capabilities,
  filetypes = {'html', 'css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact'},
} ]]
