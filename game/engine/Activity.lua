
local class = require 'lux.oo.class'

local Event = require 'engine.Event'
local Queue = require 'engine.Queue'

function class:Activity ()

  require 'engine.UI'

  local finished = false
  local out_queue = Queue(32)

  self.__accept = {}

  function self:isFinished ()
    return finished
  end

  function self:finish ()
    finished = true
  end

  function self:pollEvents ()
    return { out_queue:popAll() }
  end

  function self:raiseEvent (id)
    return function (...)
      out_queue:push(Event(id, ...))
    end
  end

  function self:accept (ev)
    local callback = self.__accept[ev:getID()]
    if callback then
      callback(self, ev.getArgs())
    end
  end

  function self:updateTasks ()
    -- TODO
  end

end

return class:bind 'Activity'
