
local class = require 'lux.oo.class'

function class:Cursor (start_position, acceleration)

  local vec2    = require 'lux.geom.Vector'
  local hexpos  = require 'domain.hexpos'

  ----

  local accel       = acceleration or 25
  local currentpos  = start_position or hexpos:new {1,1}
  local target      = hexpos:new {1,1}
  local step        = hexpos:new {0,0}
  local cursor_img  = love.graphics.newImage "assets/images/cursor.png"

  function getPos ()
    return currentpos:clone()
  end

  function getTarget ()
    return target:clone()
  end

  function setTarget (the_target)
    target = the_target
  end

  function stop ()
    target = currentpos:rounded()
  end

  function move ()
    currentpos  = currentpos + step * (1/60)
    step        = (target - currentpos)*accel
  end

  function draw (graphics)
    -- TODO magic number
    local pos = currentpos:toVec2()
    graphics.draw(cursor_img, pos.x, pos.y, 0, 1, 1, cursor_img:getWidth()/2, 35)
  end

end
