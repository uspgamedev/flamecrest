
local class = require 'lux.oo.class'

function class:Queue (max)

  assert(max > 1)

  local queue = {}
  local head, tail = 1, 1
  local size = 0

  for i=1,max do
    queue[i] = false
  end

  function self:isEmpty ()
    return size == 0
  end

  function self:isFull ()
    return size == max
  end

  function self:push (event, ...)
    if not event and select('#', ...) == 0 then
      return
    elseif event then
      assert(not self:isFull())
      queue[tail] = event
      tail = (tail%max) + 1
      size = size + 1
    end
    return self:push(...)
  end

  function self:pop (n)
    if n and n <= 0 then
      return
    else
      assert(not self:isEmpty())
      local value = queue[head]
      queue[head] = false
      head = (head%max) + 1
      size = size - 1
      return value, self:pop(n and (n-1) or 0)
    end
  end

  function self:popAll ()
    return self:pop(size)
  end

end

return class:bind 'Queue'
