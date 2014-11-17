
local class = require 'lux.oo.class'

function class:Activity ()

  require 'engine.UI'

  local ui = class:UI()

  function self:getUI ()
    return ui
  end

  function self:update ()
    -- what?
  end

end

return class:bind 'Activity'
