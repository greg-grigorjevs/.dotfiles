local M = {}

local jsconfig_lines = {
  '{',
  '  "compilerOptions": {',
  '    "allowJs": true,',
  '    "checkJs": false,',
  '    "noEmit": true,',
  '    "target": "es2022",',
  '    "lib": ["es2022", "dom"],',
  '    "skipLibCheck": true',
  '  },',
  '  "include": [',
  '    "ui/js/**/*.js",',
  '    "ui/app/views/js/**/*.otter.js"',
  '  ],',
  '  "exclude": [',
  '    "node_modules",',
  '    "ui/js/vendors"',
  '  ]',
  '}',
}

local function is_zabbix_root(root)
  return vim.fn.isdirectory(root .. '/ui/js') == 1
    and vim.fn.filereadable(root .. '/ui/js/class.form.js') == 1
    and vim.fn.isdirectory(root .. '/ui/app/views/js') == 1
end

local function ensure_git_exclude(root)
  if vim.fn.executable('git') ~= 1 then
    return
  end

  local common_dir = vim.fn.systemlist({ 'git', '-C', root, 'rev-parse', '--git-common-dir' })[1]
  if vim.v.shell_error ~= 0 or not common_dir or common_dir == '' then
    return
  end

  if not vim.startswith(common_dir, '/') then
    common_dir = vim.fs.normalize(root .. '/' .. common_dir)
  end

  local exclude_path = common_dir .. '/info/exclude'
  local lines = vim.fn.filereadable(exclude_path) == 1 and vim.fn.readfile(exclude_path) or {}
  local missing = {}
  for _, pattern in ipairs({ 'jsconfig.json', '*.otter.js' }) do
    if not vim.tbl_contains(lines, pattern) then
      table.insert(missing, pattern)
    end
  end

  if #missing == 0 then
    return
  end

  if #lines > 0 and lines[#lines] ~= '' then
    table.insert(lines, '')
  end
  table.insert(lines, '# Local editor tooling (Neovim)')
  vim.list_extend(lines, missing)

  vim.fn.mkdir(common_dir .. '/info', 'p')
  pcall(vim.fn.writefile, lines, exclude_path)
end

---Create the local TypeScript project file used by ts_ls for Zabbix worktrees.
---The file is intentionally untracked, so an existing user copy is never overwritten.
---@param root string|nil
function M.ensure_jsconfig(root)
  if not root or root == '' then
    return
  end

  root = vim.fs.normalize(root)
  if not is_zabbix_root(root) then
    return
  end

  local jsconfig_path = root .. '/jsconfig.json'
  if vim.fn.filereadable(jsconfig_path) == 1 then
    return
  end

  local ok, err = pcall(vim.fn.writefile, jsconfig_lines, jsconfig_path)
  if not ok then
    vim.notify(
      '[zabbix] failed to create jsconfig.json: ' .. tostring(err),
      vim.log.levels.WARN
    )
  end
end

---Prepare the local TypeScript project and keep editor-only files out of git status.
---@param root string|nil
function M.ensure_project(root)
  if not root or root == '' then
    return
  end

  root = vim.fs.normalize(root)
  if not is_zabbix_root(root) then
    return
  end

  M.ensure_jsconfig(root)
  ensure_git_exclude(root)
end

return M
