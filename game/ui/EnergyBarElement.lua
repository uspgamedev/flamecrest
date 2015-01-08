
local class     = require 'lux.oo.class'
local vec2      = require 'lux.geom.Vector'

require 'engine.UIElement'

function class:EnergyBarElement (_name, _pos, _size)

  class.UIElement(self, _name, _pos, _size)

  local value = 1

  function self:getValue ()
    return value
  end

  function self:setValue (val)
    value = val
  end

  function self:draw (graphics, window)
    graphics.setColor(50, 100, 50, 255)
    graphics.rectangle(
      'fill',
      0, 0,
      self:getWidth(), self:getHeight()
    )
    graphics.setColor(50, 200, 50, 255)
    graphics.rectangle(
      'fill',
      0, 0,
      self:getWidth()*value, self:getHeight()
    )
    graphics.setColor(25, 25, 25, 255)
    graphics.rectangle(
      'line',
      0, 0,
      self:getWidth(), self:getHeight()
    )
  end

end

return class:bind 'EnergyBarElement'
