
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'
local hexpos  = require 'domain.hexpos'
local Event   = require 'engine.Event'

function class:Sprite (imgname)

  local img = love.graphics.newImage("assets/images/"..imgname..".png")
  local quadwidth = 64
  local quadheight = 64
  local quads = {}
  for i=1,4 do
    quads[i] = {}
    for j=1,3 do
      quads[i][j] = love.graphics.newQuad(
        quadwidth*(j-1),
        quadheight*(i-1),
        quadwidth, quadheight,
        3*quadwidth, quadheight
      )
    end
  end
  local currentindex = {1,2}

  local offset = vec2:new{}

  local function currentQuad ()
    return quads[currentindex[1]][currentindex[2]]
  end

  function self:setOffset (o)
    offset = o:clone()
  end

  function self:refresh ()
  end

  function self:draw (graphics, pos)
    local quad = currentQuad()
    graphics.push()
    graphics.translate(offset:unpack())
    graphics.draw(img, quad, pos.x, pos.y, 0, 1, 1, quadwidth/2, quadheight-16)
    graphics.pop()
  end

end

return class:bind 'Sprite'
