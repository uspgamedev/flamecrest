
local class = require 'lux.oo.class'

function class:Event (id, ...)

  local args = { n = select('#', ...), ... }

  function self:getID ()
    return id
  end

  function self:getArgs ()
    return unpack(args, 1, args.n)
  end

end

return class:bind 'Event'
