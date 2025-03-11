Hyper     = { 'cmd', 'ctrl', 'alt', 'shift' }
local meh = { 'ctrl', 'alt', 'shift' }

-- hs.loadSpoon('EmmyLua')
hs.loadSpoon('SpoonInstall')

spoon.SpoonInstall:andUse('EmmyLua')

spoon.SpoonInstall:andUse('AppWindowSwitcher', {
  hotkeys = {
    ["Google Chrome"] = { Hyper, "g" },
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

-- enable/disable kmonad when connecting/disconnecting my keyboards
hs.usb.watcher.new(function(data)
  if (data.productName == "Voyager" or data.productName == "Moonlander Mark I") then
    if (data.eventType == "removed") then
      hs.execute('kmonadon', true)
    elseif (data.eventType == "added") then
      hs.execute('kmonadoff', true)
    end
  end
end)
--:start()



-- launches the app but doesn't switch between opened windows
-- TODO: add launching functionality to AppWindowSwitcher spoon
-- spoon.SpoonInstall:andUse('AppLauncher', {
--   config = {
--     modifiers = hyper
--   },
--   hotkeys = {
--     c = "Microsoft Teams",
--     -- g = "Google Chrome"
--   }
-- })

spoon.SpoonInstall:andUse('ReloadConfiguration', {
  config = {
    watch_paths = { os.getenv("HOME") .. "/.dotfiles/hammerspoon/.hammerspoon/" },
  },
  start = true
})
