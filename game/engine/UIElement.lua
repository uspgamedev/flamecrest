
local class = require 'lux.oo.class'

function class:UIElement (the_pos, the_size)

  local vec2 = require 'lux.geom.Vector'

  local visible = true
  local pos = the_pos or vec2:new{0, 0}
  local size = the_size or vec2:new{32, 32}

  function isVisible ()
    return visible
  end

  function getPos ()
    return pos:clone()
  end

  function getSize ()
    return size:clone()
  end

  function left ()
    return pos.x
  end

  function right ()
    return pos.x + size.x
  end

  function top ()
    return pos.y
  end

  function bottom ()
    return pos.y + size.y
  end

  function intersects (point)
    if point.x < left() or
       point.y < top() or
       point.x > right() or
       point.y > bottom() then
      return false
    else
      return true
    end
  end

  function draw (graphics, window)
    graphics.setColor(220, 80, 80, 255)
    graphics.rectangle('fill', pos.x, pos.y, size.x, size.y)
  end

  function onRefresh ()
    -- abstract method
  end

  function onMousePress (point, button)
    -- abstract method
  end

  function onMouseRelease (point, button)
    -- abstract method
  end

  function onMouseHover (point, mouse)
    -- abstract method
  end

end

return class.UIElement
