
local class     = require 'lux.oo.class'
local vec2      = require 'lux.geom.Vector'

require 'engine.UIElement'
require 'engine.Event'

function class:ListMenuElement (_name, options, fontsize, _pos, _minwidth)


  fontsize = fontsize or 24
  _minwidth = _minwidth or 256
  local font = love.graphics.newFont('assets/fonts/Verdana.ttf', fontsize)

  local function getFontHeight ()
    return font:getHeight()*font:getLineHeight()
  end

  do
    local maxwidth = _minwidth
    for _,option in ipairs(options) do
      local width = font:getWidth(option)
      if width > maxwidth then
        maxwidth = width
      end
    end
    class.UIElement(self, _name, _pos, vec2:new{maxwidth, #options*getFontHeight()})
  end

  local focus = 0

  local function getOption (y)
    return math.modf(y/getFontHeight())+1
  end

  function self:onMousePressed (pos, button)
    if button == 'l' then
      local i = getOption(pos.y)
      broadcastEvent(class:Event('ListMenuOption', i, options[i]))
    end
  end

  function self:onMouseHover (pos)
    focus = getOption(pos.y)
  end

  function self:draw (graphics, window)
    local oldfont = graphics.getFont()

    graphics.setColor(150, 150, 100, 255)
    graphics.rectangle('fill', 0, 0, self:getWidth(), self:getHeight())

    for i,option in ipairs(options) do
      local height = getFontHeight()
      if focus == i then
        graphics.setColor(200, 200, 150, 255)
        graphics.rectangle('fill', 0, (i-1)*height, self:getWidth(), height)
      end
      graphics.setColor(25, 25, 25, 255)
      graphics.setFont(font)
      graphics.printf(option, 0, (i-1)*height, self:getWidth(), 'center')
      graphics.setColor(255, 255, 255, 255)
      graphics.setFont(oldfont)
    end

    focus = 0
  end

end

return class:bind 'ListMenuElement'
