
local class     = require 'lux.oo.class'
local vec2      = require 'lux.geom.Vector'

require 'engine.UIElement'

function class:TextElement (text, fontsize, _pos, _size)

  class.UIElement(self, _pos, _size)

  fontsize = fontsize or 24
  local font = love.graphics.newFont('assets/fonts/Verdana.ttf', fontsize)

  function self:setText (new_text)
    text = new_text
  end

  function self:draw (graphics, window)
    local oldfont = graphics.getFont()
    graphics.setColor(200, 200, 150, 255)
    graphics.rectangle(
      'fill',
      self:getX(), self:getY(),
      self:getWidth(), self:getHeight()
    )
    graphics.setColor(25, 25, 25, 255)
    graphics.setFont(font)
    graphics.printf(text, self:getX(), self:getY(), self:getWidth(), 'center')
    graphics.setColor(255, 255, 255, 255)
    graphics.setFont(oldfont)
  end

end

return class:bind 'TextElement'
