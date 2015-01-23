
local ui      = require 'lux.oo.class' .package 'ui.battle'
local hexpos  = require 'domain.common.hexpos'

function ui:Moveable (start_position, acceleration)

  local accel       = acceleration or 25
  local currentpos  = start_position or hexpos:new {1,1}
  local target      = hexpos:new {1,1}

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
    step        = (target - currentpos)*accel
    currentpos  = currentpos + step * (1/60)
  end

end
