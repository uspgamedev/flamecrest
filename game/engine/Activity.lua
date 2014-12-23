
local class = require 'lux.oo.class'

local Event = require 'engine.Event'
local Queue = require 'engine.Queue'

function class:Activity ()

  require 'engine.UI'

  local finished = false
  local event_queue = Queue(32)

  function self:isFinished ()
    return finished
  end

  function self:finish ()
    finished = true
  end

  function self:pollEvents ()
    return { event_queue:popAll() }
  end

  function self:raiseEvent (id)
    return function (...)
      event_queue:push(Event(id, ...))
    end
  end

  function self:onLoad ()
    -- abstract
  end

  function self:updateTasks ()
    -- TODO
  end

end

return class:bind 'Activity'
