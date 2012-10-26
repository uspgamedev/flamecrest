
require "lux.object"
require "lux.table"

require "vec2"

local vec2    = vec2
local object  = lux.object

module "ui" do
  
  component = object.new {
    active      = true,
    controller  = nil
  }
  
  component.__init = {
    pos = vec2:new { 0, 0 },
    size = vec2:new { 32, 32 }
  }

  function component:setcontroller (controller)
    self.controller = controller
    controller.layout = self
  end

  function component:newcontroller ()
    self.controller = controller:new {
      layout = self
    }
  end
  
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
  
  function component:draw (graphics)
    -- Unimplemented component event.
  end
  
end
