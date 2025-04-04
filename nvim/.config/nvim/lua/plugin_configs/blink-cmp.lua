return { -- optional blink completion source for require statements and module annotations
  "saghen/blink.cmp",
  version = '1.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = {
      use_nvim_cmp_as_default = true
    },
    signature = {
      enabled = true
    },
    completion = {
      menu = {
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind" } },
          treesitter = { 'lsp' }
        }
      },
      trigger = {
        show_on_trigger_character = true,
        show_on_keyword = true,
        show_on_insert_on_trigger_character = true,
        show_on_accept_on_trigger_character = true
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      }
    },
    keymap = {
      preset = 'enter',
      ['<Tab>'] = { 'select_next', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'fallback' }
    },
    sources = {
      -- add lazydev to your completion providers
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
    },
  },
}
