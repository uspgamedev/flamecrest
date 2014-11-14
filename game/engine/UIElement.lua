
local class = require 'lux.oo.class'
local vec2 = require 'lux.geom.Vector'

function class:UIElement (the_pos, the_size)

  local visible = true
  local pos = the_pos or vec2:new{0, 0}
  local size = the_size or vec2:new{32, 32}

  function self:isVisible ()
    return visible
  end

  function self:getPos ()
    return pos:clone()
  end

  function self:getSize ()
    return size:clone()
  end

  function self:left ()
    return pos.x
  end

  function self:right ()
    return pos.x + size.x
  end

  function self:top ()
    return pos.y
  end

  function self:bottom ()
    return pos.y + size.y
  end

  function self:intersects (point)
    if point.x < self:left() or
       point.y < self:top() or
       point.x > self:right() or
       point.y > self:bottom() then
      return false
    else
      return true
    end
  end

  function self:draw (graphics, window)
    graphics.setColor(220, 80, 80, 255)
    graphics.rectangle('fill', pos.x, pos.y, size.x, size.y)
  end

  function self:onRefresh ()
    -- abstract method
  end

  function self:onMousePress (point, button)
    -- abstract method
  end

  function self:onMouseRelease (point, button)
    -- abstract method
  end

  function self:onMouseHover (point, mouse)
    -- abstract method
  end

end

return class:bind 'UIElement'
