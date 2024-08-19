return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-telescope/telescope-dap.nvim',
    'mortepau/codicons.nvim',
  },
  config = function()
    local dap = require('dap')
    require('telescope').load_extension('dap')

    dap.adapters.php = {
      type = "executable",
      command = "node",
      --[[ args = { os.getenv("HOME") .. "/dev/vscode-php-debug/out/phpDebug.js" } ]]
      args = { os.getenv("HOME") .. "/dev/tools/vscode-php-debug/out/phpDebug.js" }
    }

    dap.configurations.php = {
      {
        type = "php",
        request = "launch",
        name = "Listen for Xdebug",
        port = 9003,
        --[[ pathMappings = { ]]
        --[[   ["/var/www/html"] = "${workspaceFolder}" ]]
        --[[ } ]]
      }
    }

    -- keymaps
    vim.api.nvim_set_keymap("n", "<F2>", ":lua require'dap'.continue()<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<F3>", ":lua require'dap'.step_over()<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<F4>", ":lua require'dap'.step_into()<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<F5>", ":lua require'dap'.step_out()<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<leader>dB",
      ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>"
      , { silent = true })
    vim.api.nvim_set_keymap("n", "<leader>dp",
      ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<leader>dl", ":lua require'dap'.repl.run_last()<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<leader>dx", ":lua require'dap'.clear_breakpoints()<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<leader>dc", ":lua require'dapui'.close()<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<leader>do", ":lua require'dapui'.open()<CR>", { silent = true })

    -- dap ui config
    require("dapui").setup({
      layouts = { {
        elements = { {
          id = "scopes",
          size = 0.25
        }, {
          id = "breakpoints",
          size = 0.25
        }, {
          id = "stacks",
          size = 0.25
        }, {
          id = "watches",
          size = 0.25
        } },
        position = "left",
        size = 60
      },
        --[[ {
      elements = { {
        id = "repl"
      } },
      position = "bottom",
      size = 1,
    } ]]
        -- disable repl and console
        {
          elements = { {
            id = "repl",
            size = 0.5
          }, {
            id = "console",
            size = 0.5
          } },
          position = "bottom",
          size = 1
        }
      },
    })

    local dapui = require("dapui")

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end
}
