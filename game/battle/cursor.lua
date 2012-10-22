
local object = require "lux.object"

require "vec2"
require "battle"
require "battle.hexpos"

local mouse = love.mouse
local vec2  = vec2

module "battle" do

  cursor = object.new {
    accel   = 20
  }

  cursor.__init = {
    pos     = hexpos:new {1,1},
    target  = hexpos:new {1,1},
    step    = hexpos:new {0,0}
  }

  function cursor:update (dt)
    local targeted = layout:screentotile(vec2:new{mouse.getPosition()})
    self.pos = self.pos + dt*self.step
    if not layout.map:tile(targeted) then
      targeted:set(self.target:gettruncated())
    end
    self.target = targeted
    self.accel  = 20
    self.step   = (targeted - self.pos)*self.accel
  end

end
