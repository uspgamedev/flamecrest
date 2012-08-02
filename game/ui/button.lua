
require "ui.component"
require "vec2"

module ("ui", package.seeall)

ui.button = ui.component:new {
  text = "<dummy text>",
  action = function () print "duh" end
}

local button = ui.button

function button:released (b, pos)
  self.action()
end

function button:draw ()
  -- draw button rectangle
  love.graphics.setColor { 50, 50, 50, 255 }
  love.graphics.rectangle("fill", 0, 0, self.size.x, self.size.y)

  -- draw button text
  local width, height = love.graphics.getFont():getWidth(self.text),
                        love.graphics.getFont():getHeight()
  love.graphics.setColor { 255, 255, 255, 255 }
  love.graphics.print(self.text, (self.size.x-width)/2, (self.size.y-height)/2)
end

