
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

local engine  = class.package 'engine'
local ui      = class.package 'ui'

local OPTION_HEIGHT = 96
local DELAY         = 20

local shader_code = [[
  vec4 effect (vec4 color, Image texture, vec2 tex_pos, vec2 pix_pos) {
    vec4 result = Texel(texture, tex_pos)*color;
    number dist = distance(tex_pos, vec2(0.5, 0.5));
    number back = 1.0 - smoothstep(0.38, 0.4, dist);
    number border = smoothstep(0.38, 0.4, dist)*(1 - smoothstep(0.48, 0.5, dist));
    return back*result + border*vec4(.2, .2, .2, 1);
  }
]]

function ui:ListMenuElement (_name, options, _pos, _minwidth)


  fontsize = fontsize or 24
  _minwidth = _minwidth or 128
  local font = love.graphics.newFont('assets/fonts/Verdana.ttf', 18)
  local shader = love.graphics.newShader(shader_code)
  local icons = {}

  local function getFontHeight ()
    return font:getHeight()*font:getLineHeight()
  end

  do
    local maxwidth = _minwidth
    for i,option in ipairs(options) do
      local width = font:getWidth(option)
      if width > maxwidth then
        maxwidth = width
      end
      icons[i] = love.graphics.newImage('assets/icons/'..option..'.png')
    end
    engine.UIElement:inherit(self, _name, _pos,
                             vec2:new{maxwidth, #options*OPTION_HEIGHT})
  end

  local focus = 1
  local oldfocus = 1
  local time = 0

  local function getOption (y)
    return math.modf(y/OPTION_HEIGHT)+1
  end

  function self:onMousePressed (pos, button)
    if button == 'l' then
      local i = getOption(pos.y)
      broadcastEvent(engine.Event('ListMenuOption', i, options[i]))
    end
  end

  function self:onMouseHover (pos)
    local newfocus = getOption(pos.y)
    if newfocus ~= focus then
      oldfocus = focus
      focus = newfocus
      time = 0
    end
  end

  function self:onKeyPressed (key)
    if key == 'return' then
      broadcastEvent(engine.Event('ListMenuOption', focus, options[focus]))
    elseif key == 'backspace' then
      broadcastEvent(engine.Event('Cancel'))
    elseif key == 'up' or key == 'w' then
      focus = focus - 1
      if focus == 0 then focus = #options end
    elseif key == 'down' or key == 's' then
      focus = (focus % #options) + 1
    end
  end

  function self:onRefresh ()
    time = math.min(time + 1, DELAY)
  end

  function self:draw (graphics, window)
    local oldfont = graphics.getFont()
    local p = 1 - (1 - time/DELAY)^3
    graphics.setFont(font)

    --graphics.setColor(150, 150, 100, 255)
    --graphics.rectangle('fill', 0, 0, self:getWidth(), self:getHeight())

    for i,option in ipairs(options) do
      if focus == i or oldfocus == i then
        local x = 32
        local y = (i - 1 + 1/6)*OPTION_HEIGHT
        local w = self:getWidth()*(focus == i and p or 1-p)
        local h = 1*OPTION_HEIGHT/3
        graphics.setColor(160, 140, 90, 255)
        graphics.rectangle('fill', x, y, w, 1*OPTION_HEIGHT/3)
        if focus == i and p > 0.5 then
          graphics.setColor(25, 25, 25, 255*p/.5)
          graphics.printf(option, x+48, y + (h-getFontHeight())/2,
                          self:getWidth(), 'left')
        end
        graphics.setColor(255, 255, 255, 255)
      end
      graphics.setShader(shader)
      graphics.draw(icons[i], 0, (i-1)*OPTION_HEIGHT)
      graphics.setShader()
    end

    graphics.setFont(oldfont)
  end

end
