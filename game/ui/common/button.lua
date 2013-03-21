
module ("ui.common", package.seeall) do

  require "ui.layout"
  require "ui.component"
  require "vec2"

  local vec2      = vec2
  local print     = print
  local module    = module
  local component = ui.component

  button = component:new {
    text = "<dummy text>",
    action = function () print "duh" end
  }

  function button:__init ()
    self:newcontroller()
    self.controller.action = self.action
    self.action = nil
  end

  function button:mousereleased (pos, button)
    self.action()
  end
  
  function button:draw (graphics)
    -- draw button rectangle
    graphics.setColor { 50, 50, 50, 255 }
    graphics.rectangle("fill", 0, 0, self.size.x, self.size.y)
  
    -- draw button text
    local width, height = graphics.getFont():getWidth(self.text),
                          graphics.getFont():getHeight()
    graphics.setColor { 255, 255, 255, 255 }
    graphics.print(self.text, (self.size.x-width)/2, (self.size.y-height)/2)
  end

end

-- Utility function
module "ui.layout" do

  function addbutton (buttoninfo)
    addcomponent(button:new(buttoninfo))
  end

end
