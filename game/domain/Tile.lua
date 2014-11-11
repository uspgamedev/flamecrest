
local class = require 'lux.oo.class'

function class:Tile (typename)

  local tiletypes = require 'content.tiletypes'

  ----

  local attributes = tiletypes[typename or 'default']:new{}
  local unit

  function setUnit (the_unit)
    assert(not unit)
    unit = the_unit
  end

  function getUnit ()
    return unit
  end

  function getType ()
    return attributes.name
  end

  function getAvoid ()
    return attributes.avoid
  end

  function getDef ()
    return attributes.def
  end

  function getRes ()
    return attributes.res
  end

end

return class.Tile
