
require "nova.object"
require "vec2"

button = nova.object:new {
  text = "<dummy text>",
  action = function () print "duh" end
}

function button:__init ()
  if not self.pos then
    self.pos = vec2:new { 0, 0 }
  end
  if not self.size then
    self.size = vec2:new { 32, 32 }
  end
end

function button:left ()
  return self.pos.x
end

function button:top ()
  return self.pos.y
end

function button:right ()
  return self.pos.x + self.size.x
end

function button:bottom ()
  return self.pos.y + self.size.y
end

function button:inside (pos)
  if pos.x < self:left() or
     pos.y < self:top() or
     pos.x > self:right() or
     pos.y > self:bottom() then
    return false
  end
  return true
end

function button.check (buttons, pos)
  for _,b in pairs(buttons) do
    if b:inside(pos) then
      b.action()
      return
    end
  end
end

function button:draw ()
  -- store current color
  local currentcolor = { love.graphics.getColor() }

  -- draw button rectangle
  love.graphics.setColor { 50, 50, 50, 255 }
  love.graphics.rectangle("fill", self.pos.x, self.pos.y,
                                  self.size.x, self.size.y)

  -- draw button text
  local width, height = love.graphics.getFont():getWidth(self.text),
                        love.graphics.getFont():getHeight()
  love.graphics.setColor { 255, 255, 255, 255 }
  love.graphics.push()
  love.graphics.translate(self.pos.x, self.pos.y)
  love.graphics.print(self.text, (self.size.x-width)/2, (self.size.y-height)/2)
  love.graphics.pop()

  -- Go back to original color
  love.graphics.setColor(currentcolor)
end

