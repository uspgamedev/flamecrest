
local object = require "lux.object"

require "vec2"

local vec2 = vec2

module "battle" do

  tile = object.new {
    types = {},
    type  = "plains"
  }

  tile.__init = {
    pos = vec2:new {0, 0},
    size = vec2:new {128, 64}
  }

  function tile:load (graphics)
    self.types.plains = graphics.newImage "resources/images/hextile-border.png"
  end

  function tile:draw (graphics)
    graphics.draw(self.types[self.type], 0, 0, 0, 1, 1, 64, 32)
  end

end
