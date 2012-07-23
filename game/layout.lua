
require "nova.table"
require "button"

module ("layout", package.seeall) do

  top = 96
  left = 32
  middle = 512 + 32

  function draw (g)

    g.setColor { 50, 50, 50, 255 }
    g.line(32, 64, 1024-32, 64)
    g.line(512, 64, 512, 768-16)
    g.setColor { 255, 255, 255, 255 }

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
    --
  }

end

