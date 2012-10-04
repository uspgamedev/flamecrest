
local object  = require "lux.object"
local array   = require "lux.table"

require "ui.button"

module "ui" do

  layout = object.new {

  }

  layout.__init = {
    components = array:new {}
  }

  function layout:addcomponent (component)
    self.components:insert(component)
  end
  
  function layout:addbutton (buttoninfo)
    self:addcomponent(button:new(buttoninfo))
  end

  function layout.drawcomponent (_, component, graphics)
      if component.active then
        -- store current graphics state
        local currentcolor = { graphics.getColor() }
        graphics.push()
        -- move to component's position and draw it
        graphics.translate(component.pos.x, component.pos.y)
        component:draw(graphics)
        -- restore previous graphics state
        graphics.pop()
        graphics.setColor(currentcolor)
      end
  end
  
  function layout:draw (graphics)
    self.components:foreach(function (_,c) layout.drawcomponent(_,c,graphics) end)
  end

  function layout:pressed (b, pos)
    -- Unimplemented layout event.
  end
  
  function layout:released (b, pos)
    -- Unimplemented layout event.
  end

end

