
local class     = require 'lux.oo.class'
local tiletypes = require 'content.tiletypes'

local domain    = class.package 'domain'

function domain:Tile (pos, typename)

  local attributes = tiletypes[typename or 'default']:new{}
  local unit

  function self:getPos ()
    return pos
  end

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
