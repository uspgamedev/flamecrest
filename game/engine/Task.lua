
local class = require 'lux.oo.class'

function class:Task (func, ...)

  local function bootstrap (...)
    coroutine.yield()
    return func(...)
  end

  local task = coroutine.create(bootstrap)
  local delay = 0

  coroutine.resume(task, ...)

  function self:resume ()
    if coroutine.status(task) == 'dead' then
      return false
    elseif delay > 0 then
      delay = delay - 1
    else
      local _, n = assert(coroutine.resume(task))
      if n and n > 1 then
        delay = n
      end
    end
  end

end

return class:bind 'Task'
