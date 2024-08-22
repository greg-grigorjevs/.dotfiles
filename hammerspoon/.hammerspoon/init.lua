local hyper = { 'cmd', 'ctrl', 'alt', 'shift' }
local meh   = { 'ctrl', 'alt', 'shift' }

hs.loadSpoon('EmmyLua')
hs.loadSpoon('SpoonInstall')

spoon.SpoonInstall:andUse('AppWindowSwitcher', {
  hotkeys = {
    ["Google Chrome"] = { hyper, "g" },
    ['Music'] = { hyper, "m" },
    ['Microsoft Teams'] = { hyper, 'c' },
    ['TablePlus'] = { hyper, 'd' },
    ['kitty'] = { hyper, 't' },

  }
})


require('window-management')

-- enable/disable kmonad when connecting/disconnecting my keyboards
hs.usb.watcher.new(function(data)
  if (data.productName == "Voyager" or data.productName == "Moonlander") then
    if (data.eventType == "removed") then
      hs.execute('kmonadon', true)
    elseif (data.eventType == "added") then
      hs.execute('kmonadoff', true)
    end
  end
end):start()



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