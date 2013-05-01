
module ("game", package.seeall) do

  require "common.vec2"
  require "ui.layout"

  local mouse         = love.mouse
  local vec2          = vec2
  local ui            = ui
  controller = nil

  -- LÖVE callbacks --

  function update (dt)
    controller:update(dt)
    ui.layout.mouseevent("mousehover", vec2:new{mouse.getPosition()}, dt)
    ui.layout.updateevent(dt)
  end

  function draw (graphics)
    ui.layout.draw()
  end
  
  function mousereleased (x, y, button)
    ui.layout.mouseevent("mousereleased", vec2:new{x,y}, button)
  end
  
  function mousepressed (x, y, button)
    ui.layout.mouseevent("mousepressed", vec2:new{x,y}, button)
  end

  function keypressed (key)
    --state.layout.controller:presskey(key)
  end
  
  function keyreleased (key)
    --state.layout.controller:releasekey(key)
  end
end

