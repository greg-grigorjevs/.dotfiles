--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- macOS application aware, keyboard driven window switcher. Spoon
-- on top of Hammerspoon.
--
-- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/AppWindowSwitcher.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/AppWindowSwitcher.spoon.zip)
--
-- Switches windows by focusing and raising them. All windows matching a
-- bundelID, a list of bundleID's, an application name matchtext,
-- or a list of application name matchtexts are switched by cycling
-- them. Cycling applies to visible windows of currently focused space
-- only. The spoon does not launch applications, it operates on open
-- windows of running applications.
--
-- Example `~/.hammerspoon/init.lua` configuration:
--
-- ```
-- hs.loadSpoon("AppWindowSwitcher")
--     -- :setLogLevel("debug") -- uncomment for console debug log
--     :bindHotkeys({
--         ["com.apple.Terminal"]        = {hyper, "t"},
--         [{"com.apple.Safari",
--           "com.google.Chrome",
--           "com.kagi.kagimacOS",
--           "com.microsoft.edgemac",
--           "org.mozilla.firefox"}]     = {hyper, "q"},
--         ["Hammerspoon"]               = {hyper, "h"},
--         [{"O", "o"}]                  = {hyper, "o"},
--     })
-- ```
-- In this example,
-- * `hyper-t` cycles all terminal windows (matching a single bundleID),
-- * `hyper-q` cycles all windows of the five browsers (matching either
--   of the bundleIDs)
-- * `hyper-h` brings the Hammerspoon console forward (matching the
--   application title),
-- * `hyper-o` cycles all windows whose application title starts
--   with "O" or "o".
--
-- The cycling logic works as follows:
-- * If the focused window is part of the application matching a hotkey,
--   then the last window (in terms of macOS windows stacking) of the matching
--   application(s) will be brought forward and focused.
-- * If the focused window is not part of the application matching a
--   hotkey, then the first window (in terms of macOS windows stacking) i
--   of the matching applications will be brought forward and focused.
---@class spoon.AppWindowSwitcher
local M = {}
spoon.AppWindowSwitcher = M

-- Binds hotkeys for AppWindowSwitcher
--
-- Parameters:
--  * mapping - A table containing hotkey modifier/key details for each application to manage
--
-- Notes:
-- The mapping table accepts these formats per table element:
-- * A single text to match:
--   `["<matchtext>"] = {mods, key}`
-- * A list of texts, to assign multiple applications to one hotkey:
--   `[{"<matchtext>", "<matchtext>", ...}] = {mods, key}`
-- * `<matchtext>` can be either a bundleID, or a text which is substring matched against a windows application title start.
--
-- Returns:
--  * The AppWindowSwitcher object
---@return spoon.AppWindowSwitcher
function M:bindHotkeys(mapping, ...) end

-- Set the log level of the spoon logger.
--
-- Parameters:
--  * Log level - `"debug"` to enable console debug output
--
-- Returns:
--  * The AppWindowSwitcher object
---@return spoon.AppWindowSwitcher
function M:setLogLevel(level, ...) end

