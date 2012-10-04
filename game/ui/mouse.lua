
require "ui.layout"

module ("ui.mouse", package.seeall) do

  function press (focusedlayout, button, pos)
    for i = #focusedlayout.components,1,-1 do
      local component = focusedlayout.components[i]
      if component.active and component:inside(pos) then
        component:pressed(button, pos)
        return
      end
    end
    focusedlayout:pressed(button, pos)
  end

  function release (focusedlayout, button, pos)
    for i = #focusedlayout.components,1,-1 do
      local component = focusedlayout.components[i]
      if component.active and component:inside(pos) then
        component:released(button, pos)
        return
      end
    end
    focusedlayout:released(button, pos)
  end

end

