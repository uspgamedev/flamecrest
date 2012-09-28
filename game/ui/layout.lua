
require "lux.table"

require "ui.button"

module ("ui.layout", package.seeall) do

  components = lux.table:new {}

  function addcomponent (component)
    components:insert(component)
  end
  
  function addbutton (buttoninfo)
    addcomponent(ui.button:new(buttoninfo))
  end
  
  function draw (graphics)
    for _,component in pairs(components) do
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
  end

end

