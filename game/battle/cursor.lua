
local object = require "lux.object"

require "battle.hexpos"

module "battle" do

  cursor = object.new {
    accel   = 20
  }

  cursor.__init = {
    pos     = hexpos:new {1,1},
    target  = hexpos:new {1,1},
    step    = hexpos:new {0,0}
  }

  function cursor:update (targeted, dt)
    self.pos = self.pos + dt*self.step
    if not layout.map:tile(targeted) then
      targeted:set(self.target:gettruncated())
    end
    self.target = targeted
    self.accel  = 20
    self.step   = (targeted - self.pos)*self.accel
  end

end
