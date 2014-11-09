
function love.conf(t)
  t.identity = nil            -- The name of the save directory (string)
  t.version = "0.9.0"         -- The LÖVE version this game was made for (string)
  t.console = true            -- Attach a console (boolean, Windows only)

  t.author = "USPGameDev"     -- The author of the game (string)
  t.url = "uspgamedev.org"    -- The website of the game (string)
  t.release = false           -- Enable release mode (boolean)

  t.window.title = "Flame Crest"
  t.window.icon = nil
  t.window.width = 1024       -- The window width (number)
  t.window.height = 768       -- The window height (number)
  t.window.borderless = true
  t.window.resizable = false
  t.window.minwidth = 1
  t.window.minheight = 1
  t.window.fullscreen = false -- Enable fullscreen (boolean)
  t.window.fullscreentype = 'normal'
  t.window.vsync = true       -- Enable vertical sync (boolean)
  t.window.fsaa = 0           -- The number of FSAA-buffers (number)
  t.window.display = 2

  t.modules.audio = true      -- Enable the audio module (boolean)
  t.modules.event = true      -- Enable the event module (boolean)
  t.modules.graphics = true   -- Enable the graphics module (boolean)
  t.modules.image = true      -- Enable the image module (boolean)
  t.modules.joystick = false  -- Enable the joystick module (boolean)
  t.modules.keyboard = true   -- Enable the keyboard module (boolean)
  t.modules.math = true
  t.modules.mouse = true      -- Enable the mouse module (boolean)
  t.modules.physics = false   -- Enable the physics module (boolean)
  t.modules.sound = true      -- Enable the sound module (boolean)
  t.modules.system = true
  t.modules.timer = true      -- Enable the timer module (boolean)
  t.modules.window = true
end
