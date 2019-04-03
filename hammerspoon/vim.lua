
-- http://github.com/dbmrq/dotfiles/
-- Vim style modal bindings

-- enhanced by Romain de Wolff

-- prefer Karabiner Elements to handle vim mode, much faster!

-- Visual indicator in menubar

local vimMenuBar = hs.menubar.new()

local iconInsertMode = [[
ASCII:
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · 1 · · 2 · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · 4 · · 3 · · · ·",
@"· · · · · · · · · · · ·",
]]

local iconVisualMode = [[
ASCII:
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · 1 · 2 · · 4 · 5 · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · ·3· · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · · · · · · · · ·",
@"· · · · 7i · · 6 · · · ·",
@"· · · · · · · · · · · ·",
]]

vimMenuBar:setIcon(iconInsertMode)

-- Normal mode  

local normal = hs.hotkey.modal.new()

-- you can use EventViewer app from Karabiner to inspect key sequence
enterNormal = hs.hotkey.bind({}, 53, function()
    normal:enter()
    hs.alert.show('Normal mode')
    vimMenuBar:setIcon(iconVisualMode)
end)

-- local counter = 0
-- local watcher
-- watcher = hs.eventtap.new({hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp}, function(ev)
--     local keycode = ev:getKeyCode()
--     local labels = {
--         [hs.eventtap.event.types.keyDown] = "down",
--         [hs.eventtap.event.types.keyUp] = "up",
--     }
--     print(labels[ev:getType()], keycode, ev:getCharacters(), hs.keycodes.map[keycode])
--     counter = counter + 1
--     if counter == 5 then
--         watcher:stop()
--     end
--     return false
-- end):start()


-- Normal mode, escape key is possible :)

function escape() hs.eventtap.keyStroke({}, 'escape') end
normal:bind({}, 53, escape, nil, escape)


-- Movements

-- h - move left  
function left() hs.eventtap.keyStroke({}, "Left") end
normal:bind({}, 'h', left, nil, left)
--   

-- l - move right
function right() hs.eventtap.keyStroke({}, "Right") end
normal:bind({}, 'l', right, 'escape', right)
--   

-- k - move up  
function up() hs.eventtap.keyStroke({}, "Up") end
normal:bind({}, 'k', up, nil, up)
--   

-- j - move down  
function down() hs.eventtap.keyStroke({}, "Down") end
normal:bind({}, 'j', down, nil, down)
--   

-- w - move to next word  
function word() hs.eventtap.keyStroke({"alt"}, "Right") end
normal:bind({}, 'w', word, nil, word)
normal:bind({}, 'e', word, nil, word)
--   

-- b - move to previous word  
function back() hs.eventtap.keyStroke({"alt"}, "Left") end
normal:bind({}, 'b', back, nil, back)
--   

-- 0, H - move to beginning of line  
normal:bind({}, '0', function()
    hs.eventtap.keyStroke({"cmd"}, "Left")
end)

normal:bind({"shift"}, 'h', function()
    hs.eventtap.keyStroke({"cmd"}, "Left")
end)
--   

-- $, L - move to end of line  
normal:bind({"shift"}, '4', function()
    hs.eventtap.keyStroke({"cmd"}, "Right")
end)

normal:bind({"shift"}, 'l', function()
    hs.eventtap.keyStroke({"cmd"}, "Right")
end)
--   

-- g - move to beginning of text  
normal:bind({}, 'g', function()
    hs.eventtap.keyStroke({"cmd"}, "Up")
end)
--   

-- G - move to end of text  
normal:bind({"shift"}, 'g', function()
    hs.eventtap.keyStroke({"cmd"}, "Down")
end)
--   

-- z - center cursor  
normal:bind({}, 'z', function()
    hs.eventtap.keyStroke({"ctrl"}, "L")
end)
--   

-- <c-d> - page down (should be half-page down)
normal:bind({"ctrl"}, "d", function()
    hs.eventtap.keyStroke({}, "pagedown")
end)
--   

-- <c-u> - page up (should be half-page up)
normal:bind({"ctrl"}, "u", function()
    hs.eventtap.keyStroke({}, "pageup")
end)
--   

--   

-- Insert  

-- i - insert at cursor  
normal:bind({}, 'i', function()
    normal:exit()
    vimMenuBar:setIcon(iconInsertMode)
    hs.alert.show('Insert mode')
end)
--   

-- I - insert at beggining of line  
normal:bind({"shift"}, 'i', function()
    hs.eventtap.keyStroke({"cmd"}, "Left")
    normal:exit()
    hs.alert.show('Insert mode')
end)
--   

-- a - append after cursor  
normal:bind({}, 'a', function()
    hs.eventtap.keyStroke({}, "Right")
    normal:exit()
    hs.alert.show('Insert mode')
end)
--   

-- A - append to end of line  
normal:bind({"shift"}, 'a', function()
    hs.eventtap.keyStroke({"cmd"}, "Right")
    normal:exit()
    hs.alert.show('Insert mode')
end)
--   

-- o - open new line below cursor  
normal:bind({}, 'o', nil, function()
    local app = hs.application.frontmostApplication()
    if app:name() == "Finder" then
        hs.eventtap.keyStroke({"cmd"}, "o")
    else
        hs.eventtap.keyStroke({"cmd"}, "Right")
        normal:exit()
        hs.eventtap.keyStroke({}, "Return")
        hs.alert.show('Insert mode')
    end
end)
--   

-- O - open new line above cursor  
normal:bind({"shift"}, 'o', nil, function()
    local app = hs.application.frontmostApplication()
    if app:name() == "Finder" then
        hs.eventtap.keyStroke({"cmd", "shift"}, "o")
    else
        hs.eventtap.keyStroke({"cmd"}, "Left")
        normal:exit()
        hs.eventtap.keyStroke({}, "Return")
        hs.eventtap.keyStroke({}, "Up")
        hs.alert.show('Insert mode')
    end
end)
--   

--   

-- Delete  

-- d - delete character before the cursor  
local function delete()
    hs.eventtap.keyStroke({}, "delete")
end
normal:bind({}, 'd', delete, nil, delete)
--   

-- x - delete character after the cursor  
local function fndelete()
    hs.eventtap.keyStroke({}, "Right")
    hs.eventtap.keyStroke({}, "delete")
end
normal:bind({}, 'x', fndelete, nil, fndelete)
--   

-- D - delete until end of line  
normal:bind({"shift"}, 'D', nil, function()
    normal:exit()
    hs.eventtap.keyStroke({"ctrl"}, "k")
    normal:enter()
end)
--   

--   

-- : - in Safari, focus address bar; everywhere else, call Alfred  
normal:bind({"shift"}, ';', function()
    local app = hs.application.frontmostApplication()
    if app:name() == "Safari" then
        hs.eventtap.keyStroke({"cmd"}, "l") -- go to address bar
    else
        hs.eventtap.keyStroke({"ctrl"}, "space") -- call Alfred
    end
end)
--   

-- / - search  
normal:bind({}, '/', function() hs.eventtap.keyStroke({"cmd"}, "f") end)
--   

-- u - undo  
normal:bind({}, 'u', function()
    hs.eventtap.keyStroke({"cmd"}, "z")
end)
--   

-- <c-r> - redo  
normal:bind({"ctrl"}, 'r', function()
    hs.eventtap.keyStroke({"cmd", "shift"}, "z")
end)
--   

-- y - yank  
normal:bind({}, 'y', function()
    hs.eventtap.keyStroke({"cmd"}, "c")
end)
--   

-- p - paste  
normal:bind({}, 'p', function()
    hs.eventtap.keyStroke({"cmd"}, "v")
end)
--   

--   

-- Visual mode

local visual = hs.hotkey.modal.new()

-- v - enter Visual mode  
normal:bind({}, 'v', function() normal:exit() visual:enter() end)
function visual:entered() hs.alert.show('Visual mode') end
--   

-- <c-[> - exit Visual mode  
visual:bind({"option"}, 'i', function()
    visual:exit()
    normal:exit()
    hs.eventtap.keyStroke({}, "Right")
    hs.alert.show('Normal mode')
end)
--   

-- Movements  

-- h - move left  
function vleft() hs.eventtap.keyStroke({"shift"}, "Left") end
visual:bind({}, 'h', vleft, nil, vleft)
--   

-- l - move right  
function vright() hs.eventtap.keyStroke({"shift"}, "Right") end
visual:bind({}, 'l', vright, nil, vright)
--   

-- k - move up  
function vup() hs.eventtap.keyStroke({"shift"}, "Up") end
visual:bind({}, 'k', vup, nil, vup)
--   

-- j - move down  
function vdown() hs.eventtap.keyStroke({"shift"}, "Down") end
visual:bind({}, 'j', vdown, nil, vdown)
--   

-- w - move to next word  
function word() hs.eventtap.keyStroke({"alt", "shift"}, "Right") end
visual:bind({}, 'w', word, nil, word)
visual:bind({}, 'e', word, nil, word)
--   

-- b - move to previous word  
function back() hs.eventtap.keyStroke({"alt", "shift"}, "Left") end
visual:bind({}, 'b', back, nil, back)
--   

-- 0, H - move to beginning of line  
visual:bind({}, '0', function()
    hs.eventtap.keyStroke({"cmd", "shift"}, "Left")
end)

visual:bind({"shift"}, 'h', function()
    hs.eventtap.keyStroke({"cmd", "shift"}, "Left")
end)
--   

-- $, L - move to end of line  
visual:bind({"shift"}, '4', function()
    hs.eventtap.keyStroke({"cmd", "shift"}, "Right")
end)

visual:bind({"shift"}, 'l', function()
    hs.eventtap.keyStroke({"cmd", "shift"}, "Right")
end)
--   

-- g - move to beginning of text  
visual:bind({}, 'g', function()
    hs.eventtap.keyStroke({"shift", "cmd"}, "Up")
end)
--   

-- G - move to end of text  
visual:bind({"shift"}, 'g', function()
    hs.eventtap.keyStroke({"shift", "cmd"}, "Down")
end)
--   

--   

-- d, x - delete character before the cursor  
visual:bind({}, 'd', delete, nil, delete)
visual:bind({}, 'x', delete, nil, delete)
--   

-- y - yank  
visual:bind({}, 'y', function()
    hs.eventtap.keyStroke({"cmd"}, "c")
    hs.timer.doAfter(0.1, function()
    visual:exit()
    normal:enter()
    hs.eventtap.keyStroke({}, "Right")
    hs.alert.show('Normal mode')
end)
end)
--   

-- p - paste  
visual:bind({}, 'p', function()
    hs.eventtap.keyStroke({"cmd"}, "v")
    visual:exit()
    normal:enter()
    hs.eventtap.keyStroke({}, "Right")
    hs.alert.show('Normal mode')
end)
--   

--   

-- Actions based on active software

--hs.window.filter.new('MacVim')--  
--    :subscribe(hs.window.filter.windowFocused,function()
--        normal:exit()
--        enterNormal:disable()
--    end)
--    :subscribe(hs.window.filter.windowUnfocused,function()
--        enterNormal:enable()
--    end)--   
--
--hs.window.filter.new('Terminal')--  
--    :subscribe(hs.window.filter.windowFocused,function()
--        normal:exit()
--        enterNormal:disable()
--    end)
--    :subscribe(hs.window.filter.windowUnfocused,function()
--        enterNormal:enable()
--    end)--   

-- -- Safari  

-- safariAddressBar = hs.hotkey.bind({"shift"}, ';', function()----  
--     local app = hs.application.frontmostApplication():name()
--     local element = hs.uielement.focusedElement():role()
--     if app == "Safari" and not string.find(element, "Text") then
--         hs.eventtap.keyStroke({"cmd"}, "l")
--     else
--         hs.eventtap.keyStrokes(':')
--     end
-- end)--   

-- safariSearch = hs.hotkey.bind({}, '/', function()----  
--     local app = hs.application.frontmostApplication():name()
--     local element = hs.uielement.focusedElement():role()
--     if app == "Safari" and not string.find(element, "Text") then
--         hs.eventtap.keyStroke({"cmd"}, "f")
--     else
--         hs.eventtap.keyStrokes('/')
--     end
-- end)--   

-- safariFocusPage = hs.hotkey.bind({'ctrl'}, 'c', function()----  
--     local app = hs.application.frontmostApplication():name()
--     if app == "Safari" then
--         hs.eventtap.keyStroke({}, "escape")
--         hs.eventtap.keyStroke({"shift"}, "tab")
--         local element = hs.uielement.focusedElement():role()
--         local i = 0
--         while string.find(element, "Button") and i <= 10 do
--             hs.eventtap.keyStroke({}, "escape")
--             hs.eventtap.keyStroke({"shift"}, "tab")
--             print(element)
--             element = hs.uielement.focusedElement():role()
--             i = i + 1
--         end
--     end
-- end)--   

-- hs.window.filter.new('Safari')--  
--     :subscribe(hs.window.filter.windowFocused,function()
--         safariAddressBar:enable()
--         safariSearch:enable()
--         safariFocusPage:enable()
--     end)
--     :subscribe(hs.window.filter.windowUnfocused,function()
--         safariAddressBar:disable()
--         safariSearch:disable()
--         safariFocusPage:disable()
--     end)--   

-- --   

hs.alert('vim mode loaded 🤓')

