
local classes = require 'content.classes'

local common = require 'lux.oo.class' .package 'domain.common'

function common:Class (name)

  assert(name)

  local caps          = classes[name].cap:new{}
  local terraincosts  = classes[name].terraincost:new{}

  assert(caps)

  function self:getName ()
    return name
  end

  function self:getTerrainCostFor (typename)
    return terraincosts[typename]
  end

end
