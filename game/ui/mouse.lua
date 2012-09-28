
require "ui.layout"

module ("ui.mouse", package.seeall) do

  function press (focusedlayout, button, pos)
    for _,component in pairs(focusedlayout.components) do
      if component.active and component:inside(pos) then
        component:pressed(button, pos)
        return
      end
    end
  end

  function release (focusedlayout, button, pos)
    for _,component in pairs(focusedlayout.components) do
      if component.active and component:inside(pos) then
        component:released(button, pos)
        return
      end
    end
  end

end

