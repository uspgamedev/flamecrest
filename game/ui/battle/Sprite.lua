
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'
local hexpos  = require 'domain.hexpos'

function class:Sprite (imgname)

  local img = love.graphics.newImage("assets/images/"..imgname..".png")
  local quadwidth = 224
  local quadheight = 128
  local quads = {}
  for i=1,4 do
    quads[i] = {}
    for j=1,3 do
      quads[i][j] = love.graphics.newQuad(
        quadwidth*(j-1),
        quadheight*(i-1),
        quadwidth, quadheight,
        3*quadwidth, 4*quadheight
      )
    end
  end
  local currentindex = {1,1}

  local function currentQuad ()
    return quads[currentindex[1]][currentindex[2]]
  end

  function self:draw (graphics, pos)
    local quad = currentQuad()
    graphics.draw(
      img,
      quad,
      pos.x, pos.y,
      0,
      1, 1,
      --64/sprite:getWidth(), 96/sprite:getHeight(),
      2*quadwidth/3, quadheight-8)
  end

end

return class:bind 'Sprite'
