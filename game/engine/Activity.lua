
local class = require 'lux.oo.class'

local Event = require 'engine.Event'
local Queue = require 'engine.Queue'

function class:Activity ()

  require 'engine.UI'

  local QUEUE_MAX_SIZE = 32

  local finished = false
  local in_queue, out_queue = Queue(QUEUE_MAX_SIZE), Queue(QUEUE_MAX_SIZE)

  self.__accept = {}

  function self:isFinished ()
    return finished
  end

  function self:finish ()
    finished = true
  end

  function self:pollEvents ()
    return out_queue:popEach()
  end

  function self:sendEvent (id)
    return function (...)
      out_queue:push(Event(id, ...))
    end
  end

  function self:receiveEvent (ev)
    in_queue:push(ev)
  end

  function self:processEvents ()
    for ev in in_queue:popEach() do
      local callback = self.__accept[ev:getID()]
      if callback then
        callback(self, ev.getArgs())
      end
    end
  end

  function self:updateTasks ()
    -- TODO
  end

end

return class:bind 'Activity'
