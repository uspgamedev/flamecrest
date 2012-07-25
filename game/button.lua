
require "ui.component"
require "vec2"

button = ui.component:new {
  text = "<dummy text>",
  action = function () print "duh" end
}

function button.check (buttons, pos)
  for _,b in pairs(buttons) do
    if b:inside(pos) then
      b:action()
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

