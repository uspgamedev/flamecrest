
local class = require 'lux.oo.class'

function class:Task (func, ...)

  local function bootstrap (...)
    coroutine.yield()
    return func(...)
  end

  local task = coroutine.create(bootstrap)

  coroutine.resume(task, ...)

  function self:resume ()
    if coroutine.status(task) == 'dead' then
      return false
    else
      return assert(coroutine.resume(task))
    end
  end

end

return class:bind 'Task'
