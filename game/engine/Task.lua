
local class = require 'lux.oo.class'

function class:Task (func, ...)

  local function bootstrap (...)
    coroutine.yield()
    return func(...)
  end

  local task = coroutine.create(bootstrap)
  local delay = 0
  local onhold = false
  local params = {}

  coroutine.resume(task, ...)

  function self:hold ()
    onhold = true
  end

  function self:release (...)
    onhold = false
    params = { n = select('#', ...), ... }
  end

  function self:resume ()
    if coroutine.status(task) == 'dead' then
      return false
    elseif delay > 0 then
      delay = delay - 1
    elseif not onhold then
      local _, n = assert(coroutine.resume(task, unpack(params, 1, params.n)))
      params = {}
      if type(n) == 'number' and n > 1 then
        delay = n
      end
    end
  end

end

return class:bind 'Task'
