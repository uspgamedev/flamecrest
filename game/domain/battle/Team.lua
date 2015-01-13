
local class   = require 'lux.oo.class'

local battle  = class.package 'domain.battle'

function battle:Team (name, color)

  function self:getName ()
    return name
  end

  function self:getColor ()
    return unpack(color)
  end

end
