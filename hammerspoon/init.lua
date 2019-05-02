 -- ----------------------------------------------------------------------------
-- Hammersppon config file
--
-- Author: Romain de Wolff
--
-- References and documentation :
-- https://github.com/Hammerspoon/hammerspoon/wiki/Sample-Configurations
-- https://github.com/tstirrat/hammerspoon-config
--
-- Thanks to the following inspiration :
-- https://wincent.com/wiki/Hammerspoon
-- http://bezhermoso.github.io/2016/01/20/making-perfect-ramen-lua-os-x-automation-with-hammerspoon/

-- ----------------------------------------------------------------------------
-- Window management
-- ----------------------------------------------------------------------------

hs.grid.setGrid('12x12') -- allows us to place on quarters, thirds and halves
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.window.animationDuration = 0 -- disable animations

local displayNotification = false

local screenCount = #hs.screen.allScreens()
local logLevel = 'info' -- generally want 'debug' or 'info'
local log = hs.logger.new('wincent', logLevel)

local grid = {
  topHalf = '0,0 12x6',
  topThird = '0,0 12x4',
  topTwoThirds = '0,0 12x8',
  rightHalf = '6,0 6x12',
  rightThird = '8,0 4x12',
  rightTwoThirds = '4,0 8x12',
  bottomHalf = '0,6 12x6',
  bottomThird = '0,8 12x4',
  bottomTwoThirds = '0,4 12x8',
  leftHalf = '0,0 6x12',
  leftThird = '0,0 4x12',
  leftTwoThirds = '0,0 8x12',
  topLeft = '0,0 6x6',
  topRight = '6,0 6x6',
  bottomRight = '6,6 6x6',
  bottomLeft = '0,6 6x6',
  fullScreen = '0,0 12x12',
  centeredBig = '1,1 10x10',
  centeredMedium = '2,2 8x8',
  centeredSmall = '3,3 5x5', -- do we want this size?
}

local layoutConfig = {
  _before_ = (function()
    --hide('com.spotify.client')
  end),

  _after_ = (function()
    -- Make sure Textual appears in front of Skype, and iTerm in front of
    -- others.
    --activate('com.codeux.irc.textual5')
    --activate('com.googlecode.iterm2')
  end),

  -- ['com.codeux.irc.textual5'] = (function(window)
  --   hs.grid.set(window, grid.fullScreen, internalDisplay())
  -- end),
  --
  -- ['com.flexibits.fantastical2.mac'] = (function(window)
  --   hs.grid.set(window, grid.fullScreen, internalDisplay())
  -- end),
  --

  ['com.google.Chrome'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      -- First/odd windows go on the RIGHT side of the screen.
      -- Second/even windows go on the LEFT side.
      -- (Note this is the opposite of what we do with Canary.)
      local windows = windowCount(window:application())
      local side = windows % 2 == 0 and grid.leftHalf or grid.rightHalf
      hs.grid.set(window, side, hs.screen.primaryScreen())
    end
  end),

  -- ['com.google.Chrome.canary'] = (function(window, forceScreenCount)
  --   local count = forceScreenCount or screenCount
  --   if count == 1 then
  --     hs.grid.set(window, grid.fullScreen)
  --   else
  --     -- First/odd windows go on the LEFT side of the screen.
  --     -- Second/even windows go on the RIGHT side.
  --     -- (Note this is the opposite of what we do with Chrome.)
  --     local windows = windowCount(window:application())
  --     local side = windows % 2 == 0 and grid.rightHalf or grid.leftHalf
  --     hs.grid.set(window, side, hs.screen.primaryScreen())
  --   end
  -- end),

  -- ['com.googlecode.iterm2'] = (function(window, forceScreenCount)
  --   local count = forceScreenCount or screenCount
  --   if count == 1 then
  --     hs.grid.set(window, grid.fullScreen)
  --   else
  --     hs.grid.set(window, grid.leftHalf, hs.screen.primaryScreen())
  --   end
  -- end),

  -- ['com.skype.skype'] = (function(window)
  --   hs.grid.set(window, grid.rightHalf, internalDisplay())
  -- end),
}

--
-- Utility and helper functions.
--

-- Returns the number of standard, non-minimized windows in the application.
--
-- (For Chrome, which has two windows per visible window on screen, but only one
-- window per minimized window).
function windowCount(app)
  local count = 0
  if app then
    for _, window in pairs(app:allWindows()) do
      if window:isStandard() and not window:isMinimized() then
        count = count + 1
      end
    end
  end
  return count
end

function hide(bundleID)
  local app = hs.application.get(bundleID)
  if app then
    app:hide()
  end
end

function activate(bundleID)
  local app = hs.application.get(bundleID)
  if app then
    app:activate()
  end
end

function canManageWindow(window)
  local application = window:application()
  local bundleID = application:bundleID()

  -- Special handling for iTerm: windows without title bars are
  -- non-standard.
  return window:isStandard() or
    bundleID == 'com.googlecode.iterm2'
end

function internalDisplay()
  -- Fun fact: this resolution matches both the 13" MacBook Air and the 15"
  -- (Retina) MacBook Pro.
  return hs.screen.find('1440x900')
end

function activateLayout(forceScreenCount)
  layoutConfig._before_()

  for bundleID, callback in pairs(layoutConfig) do
    local application = hs.application.get(bundleID)
    if application then
      local windows = application:visibleWindows()
      for _, window in pairs(windows) do
        if canManageWindow(window) then
          callback(window, forceScreenCount)
        end
      end
    end
  end

  layoutConfig._after_()
end

-- Event-handling
--
-- This will become a lot easier once `hs.window.filter`
-- (http://www.hammerspoon.org/docs/hs.window.filter.html) moves out of
-- "experimental" status, but until then, using a manual approach as
-- demonstrated at: https://gist.github.com/tmandry/a5b1ab6d6ea012c1e8c5

local globalWatcher = nil
local watchers = {}
local events = hs.uielement.watcher

function handleGlobalEvent(name, eventType, app)
  if eventType == hs.application.watcher.launched then
    log.df('[event] launched %s', app:bundleID())
    watchApp(app)
  elseif eventType == hs.application.watcher.terminated then
    -- Only the PID is set for terminated apps, so can't log bundleID.
    local pid = app:pid()
    log.df('[event] terminated PID %d', pid)
    unwatchApp(pid)
  end
end

function handleAppEvent(element, event)
  if event == events.windowCreated then
    if pcall(function()
      log.df('[event] window %s created', element:id())
    end) then
      watchWindow(element)
    else
      log.wf('error thrown trying to access element in handleAppEvent')
    end
  else
    log.wf('unexpected app event %d received', event)
  end
end

function handleWindowEvent(window, event, watcher, info)
  if event == events.elementDestroyed then
    log.df('[event] window %s destroyed', info.id)
    watcher:stop()
    watchers[info.pid].windows[info.id] = nil
  else
    log.wf('unexpected window event %d received', event)
  end
end

function handleScreenEvent()
  -- Make sure that something noteworthy (display count) actually
  -- changed. We no longer check geometry because we were seeing spurious
  -- events.
  local screens = hs.screen.allScreens()
  if not (#screens == screenCount) then
    screenCount = #screens
    activateLayout(screenCount)
  end
end

function watchApp(app)
  local pid = app:pid()
  if watchers[pid] then
    log.wf('attempted watch for already-watched PID %d', pid)
    return
  end

  -- Watch for new windows.
  local watcher = app:newWatcher(handleAppEvent)
  watchers[pid] = {
    watcher = watcher,
    windows = {},
  }
  watcher:start({events.windowCreated})

  -- Watch already-existing windows.
  for _, window in pairs(app:allWindows()) do
    log.wf(window)
    watchWindow(window)
  end
end

function unwatchApp(pid)
  local appWatcher = watchers[pid]
  if not appWatcher then
    log.wf('attempted unwatch for unknown PID %d', pid)
    return
  end

  appWatcher.watcher:stop()
  for _, watcher in pairs(appWatcher.windows) do
    watcher:stop()
  end
  watchers[pid] = nil
end

function watchWindow(window)
  local application = window:application()
  local bundleID = application:bundleID()
  local pid = application:pid()
  local windows = watchers[pid].windows
  if canManageWindow(window) then
    -- Do initial layout-handling.
    local bundleID = application:bundleID()
    if layoutConfig[bundleID] then
      layoutConfig[bundleID](window)
    end

    -- Watch for window-closed events.
    local id = window:id()
    if id then
      if not windows[id] then
        local watcher = window:newWatcher(handleWindowEvent, {
          id = id,
          pid = pid,
        })
        windows[id] = watcher
        watcher:start({events.elementDestroyed})
      end
    end
  end
end

function initEventHandling()
  -- Watch for application-level events.
  globalWatcher = hs.application.watcher.new(handleGlobalEvent)
  globalWatcher:start()

  -- Watch already-running applications.
  local apps = hs.application.runningApplications()
  for _, app in pairs(apps) do
    if app:bundleID() ~= 'org.hammerspoon.Hammerspoon' then
      watchApp(app)
    end
  end

  -- Watch for screen changes.
  screenWatcher = hs.screen.watcher.new(handleScreenEvent)
  screenWatcher:start()
end

function tearDownEventHandling()
  globalWatcher:stop()
  globalWatcher = nil

  screenWatcher:stop()
  screenWatcher = nil

  for pid, _ in pairs(watchers) do
    unwatchApp(pid)
  end
end

--initEventHandling()

local lastSeenChain = nil
local lastSeenWindow = nil

-- Chain the specified movement commands.
--
-- This is like the "chain" feature in Slate, but with a couple of enhancements:
--
--  - Chains always start on the screen the window is currently on.
--  - A chain will be reset after 2 seconds of inactivity, or on switching from
--    one chain to another, or on switching from one app to another, or from one
--    window to another.
--
function chain(movements)
  local chainResetInterval = 2 -- seconds
  local cycleLength = #movements
  local sequenceNumber = 1

  return function()
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local now = hs.timer.secondsSinceEpoch()
    local screen = win:screen()

    if
      lastSeenChain ~= movements or
      lastSeenAt < now - chainResetInterval or
      lastSeenWindow ~= id
    then
      sequenceNumber = 1
      lastSeenChain = movements
    elseif (sequenceNumber == 1) then
      -- At end of chain, restart chain on next screen.
      screen = screen:next()
    end
    lastSeenAt = now
    lastSeenWindow = id

    hs.grid.set(win, movements[sequenceNumber], screen)
    sequenceNumber = sequenceNumber % cycleLength + 1
  end
end

-- ----------------------------------------------------------------------------
-- Enable/disable Karabiner with VIM mode
-- ----------------------------------------------------------------------------

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'v', (function()
  hs.alert('Karabiner')
end))

-- ----------------------------------------------------------------------------
-- Timer creation (let's cook theses pasta perfectly al'dente)
-- TODO: add a field to set up a description
-- TODO: add a new key to display the list of the existing timers /!\
-- ----------------------------------------------------------------------------
timers = {}
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 't', (function()
  -- hs.alert('TimerTimer')
  hs.focus()
  local button, minutes = hs.dialog.textPrompt('Enter the desired timer duration in minute(s)', '')
  -- debug -- hs.alert(minutes)
  -- TODO: insert timer into array 
  local t = hs.timer.doAfter(minutes * 60, (function()
    hs.dialog.blockAlert('Timer finished', 'Your timer of ' .. minutes .. ' minutes is finished!')
  end))
  table.insert(timers, t)
end))
-- show the status of the current running timers
-- TODO: work in progress. Does not work, cannot get timer values in string.
-- Cf http://www.hammerspoon.org/docs/hs.timer.html#running 
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 's', (function()
  local report = ''
  for i, name in ipairs(timers) do
    report = report .. timers[i] .. '\n'
  end
  hs.alert(table.getn(timers))
end))


-- ----------------------------------------------------------------------------
-- Application launch/focus 
-- ----------------------------------------------------------------------------

local lastapp = nil

hs.hotkey.bind({'cmd'}, '1', (function()
  if displayNotification then
    hs.alert('Editor')
  end

  -- FIXME : display editor and remember last used
  -- local atom = hs.appfinder.appFromName('Atom')
  -- local st = hs.appfinder.appFromName('Sublime Text')
  -- local ws = hs.appfinder.appFromName('WebStorm')
  -- if not atom then
  --   return
  -- end
  -- if not st then
  --   return
  -- end

  -- --if lastapp and not atom:isFrontmost() and not st.isFrontmost() then
  -- if lastapp then
  --   lastapp:activate()
  -- else
  --   if not atom:isFrontmost() then
  --     atom:activate()
  --     lastapp = atom
  --   else
  --     st:activate()
  --     lastapp = st
  --   end
  -- end

  -- launch or activate text editor in order of pref with same keystroke
  if hs.application.get('WebStorm') then
    hs.application.launchOrFocus('WebStorm')
  elseif hs.application.get('Code') then
    hs.application.launchOrFocus('Visual Studio Code')
  elseif hs.application.get('Atom') then
    hs.application.launchOrFocus('Atom')
  elseif hs.application.get('Sublime Text') then
    hs.application.launchOrFocus('Sublime Text')
  elseif hs.application.get('MacVim') then
    hs.application.launchOrFocus('MacVim')
  elseif hs.application.get('Emacs') then
    hs.application.launchOrFocus('Emacs')
  else
    -- default
    -- problem sometimes starting a new instance of the app : https://github.com/Hammerspoon/hammerspoon/issues/288
    hs.application.launchOrFocus('Visual Studio Code')
  end
  --

end))

hs.hotkey.bind({'cmd'}, '2', (function()
  hs.application.runningApplications()
  if displayNotification then
    hs.alert('Terminal')
  end
  -- start or activate corresponding Terminal
  if hs.application.get('Hyper') then
    hs.application.launchOrFocus('Hyper')
  elseif hs.application.get('iTerm2') or hs.application.get('iTerm') then
    hs.application.launchOrFocus('iTerm')
  else
    -- default
    hs.application.launchOrFocus('iTerm')
  end
end))

-- main browser
hs.hotkey.bind({'cmd'}, '3', (function()
  -- focus on the current running browser (first get first focus)
  if hs.application.get('Firefox Developer Edition') then
    hs.application.launchOrFocus('Firefox Developer Edition')
  elseif hs.application.get('Google Chrome') then
    hs.application.launchOrFocus('Google Chrome')
  elseif hs.application.get('Brave') then
    hs.application.launchOrFocus('Brave')
  elseif hs.application.get('Firefox') then
    hs.application.launchOrFocus('Firefox')
  elseif hs.application.get('qutebrowser') then
    hs.application.launchOrFocus('qutebrowser')
  elseif hs.application.get('Safari') then
    hs.application.launchOrFocus('Safari')
  else
    -- default if none running
    hs.application.launchOrFocus('Firefox')
  end
end))

-- secondary browser
-- hs.hotkey.bind({'option'}, '3', (function()
--   if hs.application.get('Chromium') then
--     hs.application.launchOrFocus('Chromium')
--   end
-- end))

-- hs.hotkey.bind({'cmd', 'shift'}, '3', (function()
--   if displayNotification then
--     hs.alert('Browser (alternative)')
--   end
--   hs.application.launchOrFocus('Safari')
--   -- if hs.application.get('Safari') then
--   --   hs.application.launchOrFocus('Safari')
--   -- elseif hs.application.get('Opera') then
--   --   hs.application.launchOrFocus('Opera')
--   -- else
--   --   -- default
--   --   hs.application.launchOrFocus('Opera')
--   -- end
-- end))

hs.hotkey.bind({'option'}, '4', (function()
  hs.application.launchOrFocus('Reactotron')
  -- Disabled, as this is currently causing a crash of the simulator �
  -- hs.application.launchOrFocus('Simulator')
end))

hs.hotkey.bind({'cmd'}, '4', (function()
  -- hs.application.launchOrFocus('Reactotron')
  -- Disabled, as this is currently causing a crash of the simulator �
  hs.application.launchOrFocus('Simulator')
end))

-- hs.hotkey.bind({'option'}, '5', (function()
--   hs.application.launchOrFocus('Typora')
-- end))

hs.hotkey.bind({'cmd'}, '5', (function()
  hs.application.launchOrFocus('Notion')

  -- if hs.application.get('Notion') then
  --   hs.application.launchOrFocus('Notion')
  -- elseif hs.application.get('Franz') then
  --   hs.application.launchOrFocus('Franz')
  --   hs.application.get('Franz'):selectMenuItem({'Services', 'Notion'})
  -- end
end))

hs.hotkey.bind({'cmd'}, '6', (function()
  if hs.application.get('Franz') then
    hs.application.launchOrFocus('Franz')
    hs.application.get('Franz'):selectMenuItem({'Services', 'Zebra'})
  end
end))

hs.hotkey.bind({'cmd'}, '7', (function()
  if hs.application.get('Franz') then
    hs.application.launchOrFocus('Franz')
    hs.application.get('Franz'):selectMenuItem({'Services', 'Slack'})
  elseif hs.application.get('Sblack') then
    hs.application.launchOrFocus('Sblack')
  else
    hs.application.launchOrFocus('Sblack')
  end
end))

hs.hotkey.bind({'option'}, '7', (function()
  if hs.application.get('Franz') then
    hs.application.launchOrFocus('Franz')
    hs.application.get('Franz'):selectMenuItem({'Services', 'WhatsApp'})
  else
    hs.application.launchOrFocus('WhatsApp')
  end
end))

hs.hotkey.bind({'option'}, '8', (function()
  hs.application.launchOrFocus('Calendar')
end))

hs.hotkey.bind({'cmd'}, '8', (function()
  hs.application.launchOrFocus('Franz')
  hs.application.get('Franz'):selectMenuItem({'Services', 'Google Calendar'})
end))

hs.hotkey.bind({'option'}, '9', (function()
  if hs.application.get('Franz') then
    hs.application.launchOrFocus('Franz')
    hs.application.get('Franz'):selectMenuItem({'Services', 'Gmail Private'})
  else
    hs.application.launchOrFocus('Airmail 3')
  end 
end))

hs.hotkey.bind({'cmd'}, '9', (function()
  if hs.application.get('Franz') then
    hs.application.launchOrFocus('Franz')
    hs.application.get('Franz'):selectMenuItem({'Services', 'Gmail'})
  else
    hs.application.launchOrFocus('Airmail 3')
  end 
end))

-- display Liip hours
hs.hotkey.bind({'cmd'}, '0', (function()
  if hs.application.get('Sublime Text') then
    hs.application.launchOrFocus('Sublime Text')
  else
    hs.execute('taxi edit', true)
  end
end))

hs.hotkey.bind({'cmd', 'option'}, '0', (function()
  hs.application.launchOrFocus('System Preferences')
end))

-- ----------------------------------------------------------------------------
-- MacOS specific
-- ----------------------------------------------------------------------------

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'o', (function()
  if displayNotification then
    hs.alert('Locking screen! Bye!')
  end
  hs.caffeinate.lockScreen()
end))

-- Bind Hammerspoon reload config
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'e', (function()
  local ejectSuccess, ejectResult = hs.fs.volume.eject('/Volumes/ChamTimeMachine')
  hs.alert('Ejecting Hard Drive : ' .. ejectResult .. ')')
end))

-- Bind Hammerspoon reload config
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'r', (function()
  hs.reload()
end))

-- show the console
hs.hotkey.bind({'cmd'}, '`', (function()
  --hs.alert('Hammerspoon console')
  hs.openConsole()
end))

-- Suppress EJECT key
hs.eventtap.new({ hs.eventtap.event.types.NSSystemDefined }, function(event)
    -- http://www.hammerspoon.org/docs/hs.eventtap.event.html#systemKey
    event = event:systemKey()
    -- http://stackoverflow.com/a/1252776/1521064
    local next = next
    -- Check empty table
    if next(event) then
        if event.key == 'EJECT' and event.down then
            print('Eject key suppressed �')
            return function() hs.eventtap.keyStroke({}, event.key, 1000) end
        end
    end
end):start()

-- ----------------------------------------------------------------------------
-- Show some help about our shortcuts
-- ----------------------------------------------------------------------------
-- hs.hotkey.bind({'cmd'}, '\'', (function()
--   hs.alert([[
--     Shortcuts
--     CMD + 1 - Code Editor
--     CMD + 2 - Terminal
--     CMD + 3 - Browser
--     CMD + 4 - iOS Simulator
--     CMD + 5 - Reactotron
--     CMD + 6 - iMessage
--     CMD + 7 - WhatsApp
--     CMD + 8 - Slack
--     CMD + 9 - Mails
--   ]])
-- end))


-- ----------------------------------------------------------------------------
-- Window management controls
-- ----------------------------------------------------------------------------
-- move window to next screen
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'space', (function()
  if displayNotification then
    hs.alert('Move active window to next screen')
  end
  local win = hs.window.focusedWindow()
  if (win) then
    --win:moveToScreen(hs.screen.get(second_monitor))
    win:moveToScreen(win:screen():next())
  end
end))

-- center window on screen
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'c', (function()
  if displayNotification then
    hs.alert('Center')
  end
  hs.window.focusedWindow():centerOnScreen()
end))

-- make window fullscreen
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'return', (function()
  if displayNotification then
    hs.alert('Fullscreen')
  end
  hs.window.focusedWindow():maximize()
end))

-- make window smaller
hs.hotkey.bind({"cmd", "alt", "ctrl"}, ",", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  -- resize window
  f.w = f.w - 30
  f.h = f.h - 30
  win:setFrame(f)
end)

-- make the window bigger
hs.hotkey.bind({"cmd", "alt", "ctrl"}, ".", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  -- resize window
  f.w = f.w + 30
  f.h = f.h + 30
  win:setFrame(f)
end)

-- windows manipulation and positioning
hs.hotkey.bind({'ctrl', 'alt'}, 'k', chain({
  grid.topHalf,
  grid.topThird,
  grid.topTwoThirds,
}))

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'l', chain({
  grid.rightHalf,
  grid.rightThird,
  grid.rightTwoThirds,
}))

hs.hotkey.bind({'ctrl', 'alt'}, 'j', chain({
  grid.bottomHalf,
  grid.bottomThird,
  grid.bottomTwoThirds,
}))

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'h', chain({
  grid.leftHalf,
  grid.leftThird,
  grid.leftTwoThirds,
}))

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'k', chain({
  grid.topLeft,
  grid.topRight,
  grid.bottomRight,
  grid.bottomLeft,
}))

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'j', chain({
  grid.fullScreen,
  grid.centeredBig,
  grid.centeredMedium,
  grid.centeredSmall,
}))

-- hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'f1', (function()
--   hs.alert('One-monitor layout')
--   activateLayout(1)
-- end))
--
-- hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'f2', (function()
--   hs.alert('Two-monitor layout')
--   activateLayout(2)
-- end))

-- ----------------------------------------------------------------------------
-- Auto reload config
-- ----------------------------------------------------------------------------
--
--function reloadConfig(files)
--  for _, file in pairs(files) do
--    if file:sub(-4) == '.lua' then
--      tearDownEventHandling()
--      hs.reload()
--    end
--  end
--end
--hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()

-- ----------------------------------------------------------------------------
-- Enable nosleep mode when required
-- ----------------------------------------------------------------------------

-- Handle caffeine sleep mechanism, icon on menubar to enable/disable sleep
local caffeine = hs.menubar.new()

-- toggle computer sleep
-- hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 's', (function()
--   if hs.caffeinate.get('system') then
--     hs.alert('Sleep disabled');
--     hs.caffeinate.set('system', false, true)
--   else
--     hs.alert('Sleep enabled');
--     -- params: prevent 'system' sleep, enabled, enabled on battery and AC
--     hs.caffeinate.set('system', true, true)
--   end
-- end))

-- icons
-- use http://fontawesome.io/icons/ instead of ASCII icons? To check!
local asciiIconSleepy = [[
ASCII:
@"· · · · · · · · · · · ·",
@"· · 1 · · · · · · 2 · ·",
@"· · · · · · · · · · · ·",
@"· · A · · · · 9 · 3 · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · 8 · 4 · · · · 5 · ·",
@"· · · · · · · · · · · ·",
@"· · 7 · · · · · · 6 · ·",
@"· · · · · · · · · · · ·",
]]

local asciiIconAwake = [[
ASCII:
@"· · · · · · · · · · · ·",
@"· · 1 · · · · · · 2 · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · E · · · · · · · · ·",
@"D · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"C · · · · · · · · · · ·",
@"· · B · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · A · · · · · · 3 · ·",
@"· · · 9 · · · · 4 · · ·",
@"· · · · 8 · · 5 · · · ·",
@"· · · · · 7 6 · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
]]

--local sleepyIcon = '~/.hammerspoon/sleep.png'
--local awakeIcon = '~/.hammerspoon/nosleep.png'
function setCaffeineDisplay(state)
  if state then
    caffeine:setIcon(asciiIconAwake)
    --caffeine:setTitle("AWAKE")
  else
    caffeine:setIcon(asciiIconSleepy)
    --caffeine:setTitle("SLEEPY")
  end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-- ----------------------------------------------------------------------------
-- Draw a circle on the mouse position
-- ----------------------------------------------------------------------------
local mouseCircle = nil
local mouseCircleTimer = nil

function mouseHighlight()
    -- Delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.getAbsolutePosition()
    -- Prepare a big red circle around the mouse pointer
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    -- Set a timer to delete the circle after 3 seconds
    mouseCircleTimer = hs.timer.doAfter(3, function() mouseCircle:delete() end)
end
hs.hotkey.bind({"cmd","alt","control"}, "D", mouseHighlight)

-- ----------------------------------------------------------------------------
-- Windows hints
-- ----------------------------------------------------------------------------
-- Fast windows switching via letter
hs.hotkey.bind({'alt'}, 'tab', (function()
  hs.hints.windowHints()
end))

-- ----------------------------------------------------------------------------
-- Accented characters 
-- ----------------------------------------------------------------------------
-- control is sometimes represented as ^, let's use it as our modifier for 
-- accented ^ chars
-- hs.hotkey.bind({'ctrl'}, 'a', (function()
--    hs.eventtap.keyStrokes(" â")
-- end))
-- hs.hotkey.bind({'ctrl'}, 'e', (function()
--    hs.eventtap.keyStrokes("ê")
-- end))
-- hs.hotkey.bind({'ctrl'}, 'u', (function()
--    hs.eventtap.keyStrokes("û")
-- end))
-- hs.hotkey.bind({'ctrl'}, 'i', (function()
--    hs.eventtap.keyStrokes("î")
-- end))
-- hs.hotkey.bind({'ctrl'}, 'o', (function()
--    hs.eventtap.keyStrokes("ô")
-- end))
-- hs.hotkey.bind({'ctrl'}, 'c', (function()
--    hs.eventtap.keyStrokes("ç")
-- end))
-- hs.hotkey.bind({'ctrl', 'shift'}, 'e', (function()
--    hs.eventtap.keyStrokes("è")
-- end))
-- hs.hotkey.bind({'ctrl', 'alt'}, 'e', (function()
--    hs.eventtap.keyStrokes("é")
-- end))
-- hs.hotkey.bind({'ctrl', 'shift', 'alt'}, 'e', (function()
--    hs.eventtap.keyStrokes("ë")
-- end))
-- hs.hotkey.bind({'ctrl', 'shift', 'alt'}, 'u', (function()
--    hs.eventtap.keyStrokes("ü")
-- end))
-- hs.hotkey.bind({'ctrl', 'shift', 'alt'}, 'i', (function()
--    hs.eventtap.keyStrokes("ï")
-- end))

-- ----------------------------------------------------------------------------
-- Send escape on short ctrl press
-- ----------------------------------------------------------------------------
-- ctrl_table = {
--     sends_escape = true,
--     last_mods = {}
-- }

-- control_key_timer = hs.timer.delayed.new(0.15, function()
--     ctrl_table["send_escape"] = false
--     -- log.i("timer fired")
--     -- control_key_timer:stop()
-- end
-- )

-- last_mods = {}

-- control_handler = function(evt)
--   local new_mods = evt:getFlags()
--   if last_mods["ctrl"] == new_mods["ctrl"] then
--       return false
--   end
--   if not last_mods["ctrl"] then
--     -- log.i("control pressed")
--     last_mods = new_mods
--     ctrl_table["send_escape"] = true
--     -- log.i("starting timer")
--     control_key_timer:start()
--   else
--     -- log.i("contrtol released")
--     -- log.i(ctrl_table["send_escape"])
--     if ctrl_table["send_escape"] then
--       -- log.i("send escape key...")
--       hs.eventtap.keyStroke({}, "ESCAPE")
--     end
--     last_mods = new_mods
--     control_key_timer:stop()
--   end
--   return false
-- end

-- control_tap = hs.eventtap.new({12}, control_handler)

-- control_tap:start()



-- ----------------------------------------------------------------------------
-- Clipboard manager
-- ----------------------------------------------------------------------------
-- make the clipboard history available via CMD + SHIFT + V
require('clipboard')

-- ----------------------------------------------------------------------------
-- Vim mode
-- ----------------------------------------------------------------------------
-- It's possible to enable the vim mode in Hammerspoon, but it's not as fast 
-- as the Karabiner Elements version, which is much lower level.
-- 
-- Source https://github.com/dbmrq/dotfiles/tree/master/home/.hammerspoon
-- So this is currently disabled
--
-- require "vim"

-- ----------------------------------------------------------------------------
-- Double Press key binding
-- ----------------------------------------------------------------------------
-- Currently not used
-- ctrlDoublePress = require("ctrlDoublePress")
-- ctrlDoublePress.timeFrame = 2
-- ctrlDoublePress.action = function()
--     hs.alert("You double tapped ctrl!")
-- end   

-- ----------------------------------------------------------------------------
-- Load the Control Escape spoon
-------------------------------------------------------------------------------
-- Currently disabled

-- hs.loadSpoon('ControlEscape')
-- spoon.ControlEscape:start()

-- ----------------------------------------------------------------------------
-- Everything is done, display done message
-- ----------------------------------------------------------------------------
hs.alert('Hammerspoon config loaded ⌨️')



