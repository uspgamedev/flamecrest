
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

local engine  = class.package 'engine'
local ui      = class.package 'ui'

function ui:ListMenuElement (_name, options, fontsize, _pos, _minwidth)


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
    engine.UIElement:inherit(self, _name, _pos,
                             vec2:new{maxwidth, #options*getFontHeight()})
  end

  local focus = 1

  local function getOption (y)
    return math.modf(y/getFontHeight())+1
  end

  function self:onMousePressed (pos, button)
    if button == 'l' then
      local i = getOption(pos.y)
      broadcastEvent(engine.Event('ListMenuOption', i, options[i]))
    end
  end

  function self:onMouseHover (pos)
    focus = getOption(pos.y)
  end

  function self:onKeyPressed (key)
    if key == 'return' then
      broadcastEvent(engine.Event('ListMenuOption', focus, options[focus]))
    elseif key == 'backspace' then
      broadcastEvent(engine.Event('Cancel'))
    elseif key == 'up' or key == 'w' then
      focus = focus - 1
      if focus == 0 then focus = 4 end
    elseif key == 'down' or key == 's' then
      focus = (focus % #options) + 1
    end
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

    --focus = 0
  end

end
