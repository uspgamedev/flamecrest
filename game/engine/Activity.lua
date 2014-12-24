
local class = require 'lux.oo.class'

local Event = require 'engine.Event'
local Queue = require 'engine.Queue'
local Task  = require 'engine.Task'

function class:Activity ()

  require 'engine.UI'

  local QUEUE_MAX_SIZE = 32

  local finished = false
  local in_queue, out_queue = Queue(QUEUE_MAX_SIZE), Queue(QUEUE_MAX_SIZE)
  local tasks = {}
  local new_tasks, finished_tasks = {}, {}

  self.__accept = {}
  self.__task   = {}

  -- Generic stuff

  function self:isFinished ()
    return finished
  end

  function self:finish ()
    finished = true
  end

  -- Event stuff

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

  -- Task stuff

  function self:yield (...)
    return coroutine.yield(...)
  end

  function self:addTask (name, ...)
    local task = Task(self.__task[name], self, ...)
    table.insert(new_tasks, task)
  end

  function self:updateTasks ()
    for _,task in ipairs(new_tasks) do
      tasks[task] = true
    end
    for task,_ in pairs(tasks) do
      if not task:resume() then
        table.insert(finished_tasks, task)
      end
    end
    for _,task in ipairs(finished_tasks) do
      tasks[task] = nil
    end
  end

end

return class:bind 'Activity'
