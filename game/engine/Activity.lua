
local class = require 'lux.oo.class'

local Event = require 'engine.Event'

function class:Activity ()

  require 'engine.UI'

  local finished = false
  local results = {}

  function self:isFinished ()
    return finished
  end

  function self:finish ()
    finished = true
  end

  function self:pollResults ()
    local temp = results
    results = {}
    return temp
  end

  function self:addResult (id, ...)
    table.insert(results, Event(id, ...))
  end

  function self:onLoad ()
    -- abstract
  end

  function self:updateTasks ()
    -- TODO
  end

end

return class:bind 'Activity'
