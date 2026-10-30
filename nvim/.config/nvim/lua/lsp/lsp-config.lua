local servers = {
  'ts_ls',
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
  -- 'pest_ls'
}

-- Provided by the Xcode toolchain (xcrun sourcekit-lsp); not available via Mason
local external_servers = { 'sourcekit' }

local all_servers = vim.list_extend(vim.deepcopy(servers), external_servers)
local php_language_id = function(_, filetype)
  return filetype == 'phpjs' and 'php' or filetype
end
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = servers,
  automatic_enable = false,
})
require('mason-null-ls').setup({
  ensure_installed = {
    'nixpkgs-fmt',
    'blade-formatter',
    'swiftlint',
  }
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
  vim.keymap.set('n', 'gd', require('lsp.definition').jump_to_definition, bufopts)
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

for _, server in ipairs(all_servers) do
  local server_config = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  if server == 'ts_ls' then
    server_config.before_init = function(params, config)
      local root = config.root_dir
      if not root and type(params.workspaceFolders) == 'table' and params.workspaceFolders[1] then
        root = vim.uri_to_fname(params.workspaceFolders[1].uri)
      end
      if not root and type(params.rootUri) == 'string' then
        root = vim.uri_to_fname(params.rootUri)
      end

      require('lsp.zabbix').ensure_project(root)
    end
  elseif server == 'lua_ls' then
    server_config.settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim', 'use' }
        }
      }
    }
  elseif server == 'cssls' then
    server_config.capabilities = {
      textDocument = { completion = { completionItem = { snippetSupport = true } } }
    }
    server_config.filetypes = { 'html', 'css', 'scss', 'less' }
  elseif server == 'html' then
    server_config.filetypes = { "html", "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact",
      "typescript.tsx", "svelte", 'blade' }
  elseif server == 'intelephense' then
    server_config.single_file_support = true
    server_config.filetypes = { 'php', 'phpjs' }
    server_config.get_language_id = php_language_id
    server_config.settings = {
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
  elseif server == 'tailwindcss' then
    server_config.filetypes = vim.deepcopy(vim.lsp.config[server].filetypes)
    table.insert(server_config.filetypes, 'phpjs')
    server_config.get_language_id = php_language_id
  elseif server == 'sourcekit' then
    -- Swift/Objective-C LSP shipped with Xcode; not in PATH without xcrun
    server_config.cmd = { 'xcrun', 'sourcekit-lsp' }
  end

  vim.lsp.config(server, server_config)
end
vim.lsp.enable(all_servers)

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
