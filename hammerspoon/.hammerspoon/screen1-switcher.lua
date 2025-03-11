-- Global variable to store the previously focused window
local previousWindow = nil
local screen1CurrentWindow = nil
local screen1 = hs.screen.allScreens()[2]

local function returnToPreviousWindow()
  if previousWindow then
    previousWindow:focus()
  else
    hs.alert.show("No previous window to return to!")
  end
end

--- @param apps hs.application[]
--- @return hs.window[]
local function getAppWindowsScreen1(apps)
  local appWindowsScreen1 = {}

  for _, app in ipairs(apps) do
    for _, win in ipairs(app:allWindows()) do
      if win:screen() == screen1 then
        table.insert(appWindowsScreen1, win)
      end
    end
  end

  return appWindowsScreen1
end

--- @param windows hs.window[]
local function switchWindowOnScreen1(windows)
  if not screen1CurrentWindow then
    screen1CurrentWindow = windows[1]
  end

  if windows[1] == screen1CurrentWindow then
    windows[2]:focus()
    screen1CurrentWindow = windows[2]
  else
    windows[1]:focus()
    screen1CurrentWindow = windows[1]
  end
end

local function cycleChromeTeamsWindowsOnScreen1()
  previousWindow = hs.window.focusedWindow()

  local chromeApp = hs.application.get("com.google.Chrome")
  local teamsApp = hs.application.get('Microsoft Teams')
  local apps = { chromeApp, teamsApp }

  local switchWindows = getAppWindowsScreen1(apps)

  switchWindowOnScreen1(switchWindows)

  returnToPreviousWindow()
end

hs.hotkey.bind(Hyper, "s", cycleChromeTeamsWindowsOnScreen1)
