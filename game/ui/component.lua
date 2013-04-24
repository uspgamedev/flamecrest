
module ("ui", package.seeall) do
  
  require "lux.object"
  require "vec2"

  local vec2    = vec2
  local object  = lux.object

  component = object.new {
    active = true
  }
  
  component.__init = {
    pos = vec2:new { 0, 0 },
    size = vec2:new { 32, 32 }
  }
  
  function component:left ()
    return self.pos.x
  end
  
  function component:top ()
    return self.pos.y
  end
  
  function component:right ()
    return self.pos.x + self.size.x
  end
  
  function component:bottom ()
    return self.pos.y + self.size.y
  end
  
  function component:inside (pos)
    if pos.x < self:left() or
       pos.y < self:top() or
       pos.x > self:right() or
       pos.y > self:bottom() then
      return false
    end
    return true
  end

  function component:update (dt)
    -- Unimplemented component event.
  end

  -- Positions are relative to the component
  function component:mousepressed (pos, button)
    -- Unimplemented component event.
  end

  -- Positions are relative to the component
  function component:mousereleased (pos, button)
    -- Unimplemented component event.
  end

  -- Positions are relative to the component
  function component:mousehover (pos, dt)
    -- Unimplemented component event.
  end
  
  function component:draw (graphics)
    -- Unimplemented component renderization.
  end
  
end
