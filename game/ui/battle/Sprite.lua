
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'
local hexpos  = require 'domain.hexpos'

local ui      = class.package 'ui.battle'

function ui:Sprite (imgname)

  local img = love.graphics.newImage("assets/images/"..imgname..".png")
  local quadwidth = 64
  local quadheight = 64
  local quads = {}
  for i=1,1 do
    for j=1,2 do
      local quad = love.graphics.newQuad(
        quadwidth*(j-1),
        quadheight*(i-1),
        quadwidth, quadheight,
        img:getWidth(), img:getHeight()
      )
      table.insert(quads, quad)
    end
  end
  local currentindex = 1
  local frame = 10
  local tick  = 0

  local offset = vec2:new{}

  local function currentQuad ()
    return quads[currentindex]
  end

  function self:setOffset (o)
    offset = o:clone()
  end

  function self:refresh ()
    tick = tick + 1
    if tick > frame then
      tick = 0
      currentindex = (currentindex % #quads) + 1
    end
  end

  function self:draw (graphics, pos)
    local quad = currentQuad()
    graphics.push()
    graphics.translate(offset:unpack())
    graphics.draw(img, quad, pos.x, pos.y, 0, 1, 1, quadwidth/2, quadheight-16)
    graphics.pop()
  end

end
