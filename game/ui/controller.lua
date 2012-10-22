
local object = require "lux.object"

require "vec2"

local vec2  = vec2
local mouse = love.mouse

module "ui" do

  controller = object.new {}

  function controller:update (dt)
    -- Unimplemented cotroller update logic.
  end

  function controller:mousepos ()
    return vec2:new{ mouse.getPosition() }
  end

end

