
require "ui.component"
require "ui.controller"
require "vec2"

local print       = print
local component   = ui.component
local controller  = ui.controller
local vec2        = vec2

module "battle.menu" do

  unit = component:new {
    active = false,
    size = vec2:new{128, 256},
  }

  unit:newcontroller()

  function unit.controller:mousereleased (button, pos)
    print "HEY"
  end

  function unit:draw (graphics)
    graphics.setColor(25, 25, 25, 255)
    graphics.rectangle("fill", 0, 0, self.size.x, self.size.y)
  end

end


