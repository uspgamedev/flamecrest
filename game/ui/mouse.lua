
require "ui.layout"

module ("ui.mouse", package.seeall) do

  function press (button, pos)
    for _,component in pairs(ui.layout.components) do
      if component.active and component:inside(pos) then
        component:pressed(button, pos)
        return
      end
    end
  end

  function release (button, pos)
    for _,component in pairs(ui.layout.components) do
      if component.active and component:inside(pos) then
        component:released(button, pos)
        return
      end
    end
  end

end

