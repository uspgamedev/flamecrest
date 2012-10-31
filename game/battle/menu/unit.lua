
require "ui.component"
require "vec2"

local component = ui.component
local vec2      = vec2

module "battle.menu" do

  unit = component:new {
    active = false,
    size = vec2:new{64, 256}
  }

  function unit:draw (graphics)
    graphics.setColor(25, 25, 25, 255)
    graphics.rectangle("fill", 0, 0, self.size.x, self.size.y)
  end

end


