
local class     = require 'lux.oo.class'
local vec2      = require 'lux.geom.Vector'

require 'engine.UIElement'

function class:TextElement (_name, text, fontsize, _pos, _size)

  class.UIElement(self, _name, _pos, _size)

  fontsize = fontsize or 24
  local font = love.graphics.newFont('assets/fonts/Verdana.ttf', fontsize)

  function self:setText (new_text)
    text = new_text
  end

  function self:draw (graphics, window)
    local oldfont = graphics.getFont()
    graphics.setColor(150, 150, 100, 255)
    graphics.rectangle(
      'fill',
      0, 0,
      self:getWidth(), self:getHeight()
    )
    graphics.setColor(25, 25, 25, 255)
    graphics.setFont(font)
    graphics.printf(text, 0, 0, self:getWidth(), 'center')
    graphics.setColor(255, 255, 255, 255)
    graphics.setFont(oldfont)
  end

end

return class:bind 'TextElement'
