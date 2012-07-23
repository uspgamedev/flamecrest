
require "nova.table"
require "button"
require "game"

module ("layout", package.seeall) do

  top = 96
  left = 32
  middle = 512 + 32

  function draw (g)

    -- draw lines of basic layout
    g.setColor { 50, 50, 50, 255 }
    g.line(32, 64, 1024-32, 64)
    g.line(512, 64, 512, 768-16)
    g.line(32, 768/2, 1024-32, 768/2)
    g.setColor { 255, 255, 255, 255 }

    -- draw buttons
    for _,v in pairs(buttons) do
      v:draw()
    end

  end

  buttons = nova.table:new {
    -- quit button
    button:new {
      pos = vec2:new { 928, 16 },
      size = vec2:new { 64, 32 },
      text = "QUIT",
      action = function () love.event.push "quit" end
    },
    -- reset all to initial state
    button:new {
      pos = vec2:new { 32, 16 },
      size = vec2:new { 128, 32 },
      text = "RESET ALL",
      action = function () end
    },
    -- unit1 attacks unit2
    button:new {
      pos = vec2:new { 512-16-128, 16 },
      size = vec2:new { 128, 32 },
      text = "FIGHT >>>",
      action = game.keyactions.a
    },
    -- unit2 attacks unit1
    button:new {
      pos = vec2:new { 512+16, 16 },
      size = vec2:new { 128, 32 },
      text = "<<< FIGHT",
      action = game.keyactions.s
    },
  }

end

