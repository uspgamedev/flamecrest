
require "nova.table"

require "button"

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
        component:pressed(pos)
        return
      end
    end
  end
  
  function draw ()
    for _,v in pairs(components) do
      v:draw()
    end
  end

end
