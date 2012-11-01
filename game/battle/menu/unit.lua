
local array = require "lux.table"

require "ui.component"
require "ui.controller"
require "ui.layout"
require "ui.button"
require "vec2"

local print       = print
local component   = ui.component
local controller  = ui.controller
local layout      = ui.layout
local button      = ui.button
local vec2        = vec2

module "battle.menu" do

  unit = component:new {
    active = false,
    size = vec2:new{128, 256},
    components = array:new{}
  }

  unit:newcontroller()

  unit.addcomponent = layout.addcomponent
  unit.addbutton    = layout.addbutton

  unit:addbutton{
    text = "WAT",
    size = vec2:new{128, 32}
  }

  function unit.controller:mousereleased (button, pos)
    --print(pos:get())
  end

  function unit:draw (graphics)
    graphics.setColor(25, 25, 50, 255)
    graphics.rectangle("fill", 0, 0, self.size.x, self.size.y)
    layout.draw(self, graphics)
  end

end


