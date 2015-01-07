
local class = require 'lux.oo.class'

function class:Combat (attacker_info, defender_info)

  function self:fight ()
    return nil
  end

end

return class:bind 'Combat'
