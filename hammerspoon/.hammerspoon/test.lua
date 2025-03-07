local hyper = { 'cmd', 'ctrl', 'alt', 'shift' }

-- Global variable to store the previously focused window
local previousWindow = nil

-- Function to cycle through Chrome windows on Screen 1
function cycleChromeWindowsOnScreen1()
  -- Store the currently focused window before switching
  previousWindow = hs.window.focusedWindow()

  -- Get all Chrome windows
  local chromeApp = hs.application.get("com.google.Chrome")
  local teamsApp = hs.application.get('Microsoft Teams')
  if not chromeApp then
    hs.alert.show("Google Chrome is not running!")
    return
  end

  -- Get all windows for Chrome
  local chromeWindows = chromeApp:allWindows()
  if #chromeWindows == 0 then
    hs.alert.show("No Chrome windows found!")
    return
  end

  -- Get Screen 1 (assuming it's the first screen in the list; adjust if needed)
  local screens = hs.screen.allScreens()
  local screen1 = screens[2] -- Screen 1 is typically the first in the list

  -- Filter Chrome windows that are on Screen 1
  local screen1ChromeWindows = {}
  for _, win in ipairs(chromeWindows) do
    if win:screen() == screen1 then
      table.insert(screen1ChromeWindows, win)
    end
  end

  if #screen1ChromeWindows == 0 then
    hs.alert.show("No Chrome windows on Screen 1!")
    return
  end

  -- Find the currently focused window and activate the next one
  local focusedWindow = hs.window.focusedWindow()
  local nextWindowIndex = 2

  for i, win in ipairs(screen1ChromeWindows) do
    if win == focusedWindow then
      nextWindowIndex = (i % #screen1ChromeWindows) + 1
      break
    end
  end

  -- Focus the next Chrome window on Screen 1
  screen1ChromeWindows[nextWindowIndex]:focus()
  returnToPreviousWindow()
  -- teamsApp:allWindows()[1]:focus()
end

-- local function toggleTeams

-- Function to return to the previously focused window
function returnToPreviousWindow()
  if previousWindow then
    previousWindow:focus()
  else
    hs.alert.show("No previous window to return to!")
  end
end

-- Bind the cycle function to Cmd + Ctrl + Tab
hs.hotkey.bind({ "cmd", "ctrl" }, "Tab", cycleChromeWindowsOnScreen1)

-- Bind the return function to Cmd + Ctrl + Shift + Tab
hs.hotkey.bind(hyper, "s", cycleChromeWindowsOnScreen1)
