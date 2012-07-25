
require "nova.object"
require "nova.table"

require "vec2"

module ("ui", package.seeall)

ui.component = nova.object:new {
  pos = nil,
  size = nil
}

local component = ui.component

function component:__init ()
  if not self.pos then
    self.pos = vec2:new { 0, 0 }
  end
  if not self.size then
    self.size = vec2:new { 32, 32 }
  end
end

function component:left ()
  return self.pos.x
end

function component:top ()
  return self.pos.y
end

function component:right ()
  return self.pos.x + self.size.x
end

function component:bottom ()
  return self.pos.y + self.size.y
end

function component:inside (pos)
  if pos.x < self:left() or
     pos.y < self:top() or
     pos.x > self:right() or
     pos.y > self:bottom() then
    return false
  end
  return true
end

function component:pressed (b, pos)
  -- Unimplemented component event.
end

function component:released (b, pos)
  -- Unimplemented component event.
end

function component:draw ()
  -- Unimplemented component event.
end
