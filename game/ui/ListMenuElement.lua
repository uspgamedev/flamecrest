
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

local engine  = class.package 'engine'
local ui      = class.package 'ui'

local OPTION_HEIGHT = 96
local DELAY         = 20

local shader_code = [[
  extern number time;
  vec4 effect (vec4 color, Image texture, vec2 tex_pos, vec2 pix_pos) {
    vec4 result = Texel(texture, tex_pos)*color;
    number limit = 0.4;
    number dist = distance(tex_pos, vec2(0.5, 0.5));
    number back = 1.0 - smoothstep(limit - .02, limit, dist);
    number border = smoothstep(limit - .02, limit, dist)
                  * (1 - smoothstep(limit + 0.08, limit + 0.1, dist));
    return back*result + border*vec4(.2, .2, .2 + .5*time, 1);
  }
]]

function ui:ListMenuElement (_name, options, _pos, _minwidth)


  fontsize = fontsize or 24
  _minwidth = _minwidth or 128
  local font = love.graphics.newFont('assets/fonts/Verdana.ttf', 18)
  local shaders = {}
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
      shaders[i] = love.graphics.newShader(shader_code)
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

  local function changeFocus (newfocus)
    if newfocus ~= focus then
      oldfocus = focus
      focus = newfocus
      time = 0
    end
  end

  function self:onMousePressed (pos, button)
    if button == 'l' then
      local i = getOption(pos.y)
      broadcastEvent(engine.Event('ListMenuOption', i, options[i]))
    end
  end

  function self:onMouseHover (pos)
    return changeFocus(getOption(pos.y))
  end

  function self:onKeyPressed (key)
    if key == 'return' then
      broadcastEvent(engine.Event('ListMenuOption', focus, options[focus]))
    elseif key == 'backspace' then
      broadcastEvent(engine.Event('Cancel'))
    elseif key == 'up' or key == 'w' then
      local f = focus - 1
      if f == 0 then f = #options end
      changeFocus(f)
    elseif key == 'down' or key == 's' then
      changeFocus((focus % #options) + 1)
    end
  end

  function self:onRefresh ()
    time = math.min(time + 1, DELAY)
    for _,shader in ipairs(shaders) do
      shader:send("time", 0)
    end
    shaders[focus]:send("time", time/DELAY)
  end

  function self:draw (graphics, window)

    local oldfont = graphics.getFont()
    local p = 1 - (1 - time/DELAY)^3

    graphics.setFont(font)

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
      do
        local w, h = icons[i]:getWidth(), icons[i]:getHeight()
        local q = 1.36 - (1 - 1.6*time/DELAY)^2
        graphics.setShader(shaders[i])
        graphics.push()
        graphics.translate(w/2, (i-1)*OPTION_HEIGHT + h/2)
        if focus == i then
          graphics.scale(1 + 0.2*q, 1 + 0.2*q)
        elseif oldfocus == i then
          graphics.scale(1.2 - 0.2*q, 1.2 - 0.2*q)
        end
        graphics.draw(icons[i], 0, 0, 0, 1, 1, w/2, h/2)
        graphics.pop()
        graphics.setShader()
      end
    end

    graphics.setFont(oldfont)

  end

end
