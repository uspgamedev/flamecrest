
require "nova.table"

require "ui.button"

module ("ui", package.seeall) do

  local components = nova.table:new {}

  function addcomponent (component)
    components:insert(component)
  end
  
  function addbutton (buttoninfo)
    addcomponent(button:new(buttoninfo))
  end
  
  function mousepress (b, pos)
    for _,component in pairs(components) do
      if component:inside(pos) then
        component:pressed()
        return
      end
    end
  end
  
  function mouserelease (b, pos)
    for _,component in pairs(components) do
      if component:inside(pos) then
        component:released(b, pos)
        return
      end
    end
  end
  
  function draw (graphics)
    for _,component in pairs(components) do
      -- store current color
      local currentcolor = { graphics.getColor() }
      graphics.push()
      graphics.translate(component.pos.x, component.pos.y)
      component:draw(graphics)
      graphics.pop()
      -- Go back to original color
      graphics.setColor(currentcolor)
    end
  end

end

