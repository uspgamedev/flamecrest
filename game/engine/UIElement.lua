
local engine  = require 'lux.oo.class' .package 'engine'
local vec2    = require 'lux.geom.Vector'

local id = 0

function engine:UIElement (name, pos, size)

  if not name then
    name = "Generated-"..id
    id = id + 1
  end
  pos = pos or vec2:new{0, 0}
  size = size or vec2:new{32, 32}

  local visible = true

  function self:getName ()
    return name
  end

  function self:isVisible ()
    return visible
  end

  function self:getPos ()
    return pos:clone()
  end

  function self:getX ()
    return pos.x
  end

  function self:getY ()
    return pos.y
  end

  function self:setPos (x, y)
    if type(x) == 'number' then
      pos = vec2:new{x,y}
    else
      pos = x:clone()
    end
  end

  function self:getSize ()
    return size:clone()
  end

  function self:getWidth ()
    return size.x
  end

  function self:getHeight ()
    return size.y
  end

  function self:setSize (w, h)
    if type(w) == 'number' then
      size = vec2:new{w,h}
    else
      size = w:clone()
    end
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

  function self:onMousePressed (point, button)
    -- abstract method
  end

  function self:onMouseReleased (point, button)
    -- abstract method
  end

  function self:onMouseHover (point, mouse)
    -- abstract method
  end

end
