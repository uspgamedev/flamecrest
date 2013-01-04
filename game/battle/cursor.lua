
local object = require "lux.object"

require "battle.hexpos"

local hexpos = battle.hexpos

module "battle.cursor" do

  local accel       = 25
  local currentpos  = hexpos:new {1,1}
  local target      = hexpos:new {1,1}
  local step        = hexpos:new {0,0}

  function pos ()
    return currentpos:clone()
  end

  function move (map, targeted, dt)
    currentpos = currentpos + dt*step
    if not map:tile(targeted) then
      targeted:set(target:gettruncated())
    end
    target = targeted
    accel  = 25
    step   = (targeted - currentpos)*accel
  end

end
