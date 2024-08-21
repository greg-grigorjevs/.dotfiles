-- Right half
hs.hotkey.bind({ "cmd", "ctrl" }, "l", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.w / 2
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f, 0)
end)

-- Left half
hs.hotkey.bind({ "cmd", "ctrl" }, "h", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()


  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f, 0)
end)

-- Maximize
hs.hotkey.bind({ "cmd", "ctrl" }, "k", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f, 0)
end)

-- Center
hs.hotkey.bind({ "cmd", "ctrl" }, "j", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = (max.w - f.w) / 2
  f.y = (max.h - f.h) / 2
  -- f.w = max.w
  -- f.h = max.h
  win:setFrame(f, 0)
end)

-- Bottom left
hs.hotkey.bind({ "cmd", "ctrl" }, "/", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = 0
  f.y = max.y + (max.h / 2) + 1
  f.w = max.w / 2
  f.h = max.h / 2
  win:setFrame(f, 0)
end)


hs.hotkey.bind({ "cmd", "ctrl" }, "d", function()
  local laptopScreen = "Built-in Retina Display"
  local windowLayout = {
    { 'Google Chrome', nil, laptopScreen, hs.layout.left50,  nil, nil },
    { 'kitty',         nil, laptopScreen, hs.layout.right50, nil, nil },
  }

  hs.layout.apply(windowLayout)
end)
