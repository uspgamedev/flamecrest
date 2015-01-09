
local ui      = require 'lux.oo.class' .package 'ui.battle'
local vec2    = require 'lux.geom.Vector'
local hexpos  = require 'domain.hexpos'

function ui:Cursor (start_position, acceleration)

  local accel       = acceleration or 25
  local currentpos  = start_position or hexpos:new {1,1}
  local target      = hexpos:new {1,1}
  local step        = hexpos:new {0,0}
  local cursor_img  = love.graphics.newImage "assets/images/cursor.png"

  function self:getPos ()
    return currentpos:clone()
  end

  function self:getTarget ()
    return target:clone()
  end

  function self:setTarget (the_target)
    target = the_target
  end

  function self:stop ()
    target = currentpos:rounded()
  end

  function self:move ()
    currentpos  = currentpos + step * (1/60)
    step        = (target - currentpos)*accel
  end

  function self:draw (graphics)
    -- TODO magic number
    local pos = currentpos:toVec2()
    graphics.draw(cursor_img, pos.x, pos.y, 0, 1, 1, cursor_img:getWidth()/2, 35)
  end

end
