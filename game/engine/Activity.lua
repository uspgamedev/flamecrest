
local class = require 'lux.oo.class'

local Event = require 'engine.Event'
local Queue = require 'engine.Queue'
local Task  = require 'engine.Task'

function class:Activity ()

  require 'engine.UI'

  local QUEUE_MAX_SIZE = 32

  local finished = false
  local scheduled = {}
  local in_queue, out_queue = Queue(QUEUE_MAX_SIZE), Queue(QUEUE_MAX_SIZE)
  local tasks = {}
  local new_tasks, finished_tasks = {}, {}

  self.__accept = {}
  self.__task   = {}
  local current_task

  -- Generic stuff

  function self:isFinished ()
    return finished
  end

  function self:finish ()
    finished = true
  end

  function self:switch (...)
    for i = 1,select('#', ...) do
      table.insert(scheduled, (select(i, ...)))
    end
    finished = true
  end

  function self:getScheduled ()
    return scheduled
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
      if finished then return end
      local callback = self.__accept[ev:getID()]
      if callback then
        callback(self, ev.getArgs())
      end
    end
  end

  -- Task stuff

  function self:yield (opt, ...)
    if type(opt) == 'string' then
      local task = current_task
      task:hold()
      self.__accept[opt] = function (self, ...)
        task:release(...)
        self.__accept[opt] = nil
      end
    end
    return coroutine.yield(opt, ...)
  end

  function self:currentTask ()
    return current_task
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
      if finished then return end
      current_task = task
      if not task:resume() then
        table.insert(finished_tasks, task)
      end
      current_task = nil
    end
    for _,task in ipairs(finished_tasks) do
      tasks[task] = nil
    end
  end

end

return class:bind 'Activity'
