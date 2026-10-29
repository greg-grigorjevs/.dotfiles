return {
  'wojciech-kulik/xcodebuild.nvim',
  ft = 'swift',
  cmd = {
    'XcodebuildSetup', 'XcodebuildCleanBuild', 'XcodebuildRun', 'XcodebuildCancel',
    'XcodebuildPreviewGenerate', 'XcodebuildPreviewShow', 'XcodebuildPreviewHide',
    'XcodebuildTestTarget', 'XcodebuildTestNearest', 'XcodebuildTestFailing',
    'XcodebuildJumpToNextCoverage', 'XcodebuildJumpToPrevCoverage',
    'XcodebuildTestExplorerShow', 'XcodebuildTestExplorerHide', 'XcodebuildTestExplorerClear',
    'XcodebuildTestExplorerRunSelectedTests', 'XcodebuildTestExplorerRerunTests',
    'XcodebuildSelectScheme', 'XcodebuildSelectTestPlan', 'XcodebuildNextDevice', 'XcodebuildPreviousDevice',
    'XcodebuildOpenLogs', 'XcodebuildCloseLogs', 'XcodebuildCreateNewFile', 'XcodebuildAddCurrentFile',
    'XcodebuildDeleteCurrentFile', 'XcodebuildRenameCurrentFile', 'XcodebuildCreateNewGroup',
    'XcodebuildAddCurrentGroup', 'XcodebuildRenameCurrentGroup', 'XcodebuildDeleteCurrentGroup',
    'XcodebuildUpdateCurrentFileTargets', 'XcodebuildShowCurrentFileTargets', 'XcodebuildAssetsManager',
    'XcodebuildEditEnvVars', 'XcodebuildEditRunArgs', 'XcodebuildShowConfig', 'XcodebuildBootSimulator',
    'XcodebuildCleanDerivedData', 'XcodebuildInstallApp', 'XcodebuildUninstallApp',
    'XcodebuildOpenInXcode', 'XcodebuildApproveMacros', 'XcodebuildTestFunc',
    'XcodebuildPicker', 'XcodebuildProjectManager', 'XcodebuildBuild',
    'XcodebuildBuildForTesting', 'XcodebuildBuildRun', 'XcodebuildTest',
    'XcodebuildTestSelected', 'XcodebuildTestClass', 'XcodebuildTestRepeat',
    'XcodebuildToggleLogs', 'XcodebuildToggleCodeCoverage',
    'XcodebuildShowCodeCoverageReport', 'XcodebuildTestExplorerToggle',
    'XcodebuildFailingSnapshots', 'XcodebuildPreviewGenerateAndShow',
    'XcodebuildPreviewToggle', 'XcodebuildSelectDevice',
    'XcodebuildQuickfixLine', 'XcodebuildCodeActions',
    'XcodebuildBuildDebug', 'XcodebuildDebug', 'XcodebuildAttachDebugger',
    'XcodebuildDetachDebugger',
  },
  keys = {
    { '<leader>dd', function() require('xcodebuild.integrations.dap').build_and_debug() end, desc = 'Build & Debug' },
    { '<leader>dR', function() require('xcodebuild.integrations.dap').debug_without_build() end, desc = 'Debug Without Building' },
    { '<leader>dt', function() require('xcodebuild.integrations.dap').debug_tests() end, desc = 'Debug Tests' },
    { '<leader>dT', function() require('xcodebuild.integrations.dap').debug_class_tests() end, desc = 'Debug Current Test Class' },
    { '<leader>dm', function() require('xcodebuild.integrations.dap').toggle_message_breakpoint() end, desc = 'Toggle Message Breakpoint' },
    { '<leader>dX', function() require('xcodebuild.integrations.dap').terminate_session() end, desc = 'Terminate Debug Session' },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'mfussenegger/nvim-dap',
  },
  config = function()
    require('xcodebuild').setup({
      code_coverage = {
        enabled = true,
      },
      integrations = {
        -- (re)generate buildServer.json for sourcekit-lsp when the scheme changes
        xcode_build_server = {
          enabled = true,
        },
      },
    })

    require('xcodebuild.integrations.dap').setup()

    -- Xcode actions (descriptions for these live in whichkey.lua)
    local xcodebuild_keys = {
      { 'n', '<leader>XX', '<cmd>XcodebuildPicker<cr>', 'Show All Actions' },
      { 'n', '<leader>Xf', '<cmd>XcodebuildProjectManager<cr>', 'Project Manager' },
      { 'n', '<leader>Xb', '<cmd>XcodebuildBuild<cr>', 'Build' },
      { 'n', '<leader>XB', '<cmd>XcodebuildBuildForTesting<cr>', 'Build For Testing' },
      { 'n', '<leader>Xr', '<cmd>XcodebuildBuildRun<cr>', 'Build & Run' },
      { 'n', '<leader>Xt', '<cmd>XcodebuildTest<cr>', 'Run Tests' },
      { 'v', '<leader>Xt', '<cmd>XcodebuildTestSelected<cr>', 'Run Selected Tests' },
      { 'n', '<leader>XT', '<cmd>XcodebuildTestClass<cr>', 'Run Current Test Class' },
      { 'n', '<leader>X.', '<cmd>XcodebuildTestRepeat<cr>', 'Repeat Last Test Run' },
      { 'n', '<leader>Xl', '<cmd>XcodebuildToggleLogs<cr>', 'Toggle Logs' },
      { 'n', '<leader>Xc', '<cmd>XcodebuildToggleCodeCoverage<cr>', 'Toggle Code Coverage' },
      { 'n', '<leader>XC', '<cmd>XcodebuildShowCodeCoverageReport<cr>', 'Code Coverage Report' },
      { 'n', '<leader>Xe', '<cmd>XcodebuildTestExplorerToggle<cr>', 'Toggle Test Explorer' },
      { 'n', '<leader>Xs', '<cmd>XcodebuildFailingSnapshots<cr>', 'Failing Snapshots' },
      { 'n', '<leader>Xp', '<cmd>XcodebuildPreviewGenerateAndShow<cr>', 'Generate Preview' },
      { 'n', '<leader>X<cr>', '<cmd>XcodebuildPreviewToggle<cr>', 'Toggle Preview' },
      { 'n', '<leader>Xd', '<cmd>XcodebuildSelectDevice<cr>', 'Select Device' },
      { 'n', '<leader>Xq', '<cmd>Telescope quickfix<cr>', 'Quickfix List' },
      { 'n', '<leader>Xx', '<cmd>XcodebuildQuickfixLine<cr>', 'Quickfix Line' },
      { 'n', '<leader>Xa', '<cmd>XcodebuildCodeActions<cr>', 'Code Actions' },
    }
    for _, key in ipairs(xcodebuild_keys) do
      vim.keymap.set(key[1], key[2], key[3], { desc = key[4] })
    end

    -- Show build/test issues in the quickfix list (Trouble) on failure
    vim.api.nvim_create_autocmd('User', {
      pattern = { 'XcodebuildBuildFinished', 'XcodebuildTestsFinished' },
      callback = function(event)
        if event.data.cancelled then
          return
        end

        local ok, trouble = pcall(require, 'trouble')
        if not ok then
          return
        end

        if event.data.success then
          trouble.close()
        elseif not event.data.failedCount or event.data.failedCount > 0 then
          if next(vim.fn.getqflist()) then
            trouble.open('quickfix')
          else
            trouble.close()
          end
          trouble.refresh()
        end
      end,
    })
  end,
}
