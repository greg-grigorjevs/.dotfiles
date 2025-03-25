Hyper     = { 'cmd', 'ctrl', 'alt', 'shift' }
local meh = { 'ctrl', 'alt', 'shift' }

-- hs.loadSpoon('EmmyLua')
hs.loadSpoon('SpoonInstall')

spoon.SpoonInstall:andUse('EmmyLua')

spoon.SpoonInstall:andUse('AppWindowSwitcher', {
  hotkeys = {
    ["Google Chrome"] = { Hyper, "h" },
    ['Music'] = { Hyper, "m" },
    ['Microsoft Teams'] = { Hyper, 'c' },
    ['TablePlus'] = { Hyper, 'd' },
    ['kitty'] = { Hyper, 't' },
  }
})

-- screenshot current window and copy it to clipbaard
hs.hotkey.bind({ "cmd", "shift" }, "7", function()
  local windowId = hs.window.focusedWindow():id()
  hs.task.new('/usr/sbin/screencapture', nil, { '-l' .. windowId, '-c' }):start()
end)

require('window-management')
require('screen1-switcher')

spoon.SpoonInstall:andUse('ReloadConfiguration', {
  config = {
    watch_paths = { os.getenv("HOME") .. "/.dotfiles/hammerspoon/.hammerspoon/" },
  },
  start = true
})
