
local class = require 'lux.oo.class'
local tiletypes = require 'content.tiletypes'

function class:Tile (typename)

  local attributes = tiletypes[typename or 'default']:new{}
  local unit

  function self:setUnit (the_unit)
    unit = the_unit
  end

  function self:getUnit ()
    return unit
  end

  function self:getType ()
    return attributes.name
  end

  function self:getAvoid ()
    return attributes.avoid
  end

  function self:getDef ()
    return attributes.def
  end

  function self:getRes ()
    return attributes.res
  end

end

return class:bind 'Tile'
