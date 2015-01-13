
local engine = require 'lux.oo.class' .package 'engine'

function engine:Event (id, ...)

  local args = { n = select('#', ...), ... }

  function self:getID ()
    return id
  end

  function self:getArgs ()
    return unpack(args, 1, args.n)
  end

end
