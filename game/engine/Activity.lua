
local class = require 'lux.oo.class'

function class:Activity ()

  require 'engine.UI'

  local results = {}

  function self:pollResults ()
    local temp = results
    results = {}
    return temp
  end

  function self:addResult (id, ...)
    local info = { n = select('#',...), ... }
    table.insert(
      results,
      { id = id, args = function () return unpack(info,1,info.n) end }
    )
  end

  function self:onLoad ()
    -- abstract
  end

  function self:updateTasks ()
    -- TODO
  end

end

return class:bind 'Activity'
