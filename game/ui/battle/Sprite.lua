
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'
local hexpos  = require 'domain.hexpos'
local Event   = require 'engine.Event'

local STRIKE_DURATION = 10

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

  local strike_dir
  local strike_time

  local function currentQuad ()
    return quads[currentindex[1]][currentindex[2]]
  end

  function self:makeStrikeEffect (dir)
    strike_dir = dir:normalized()
    strike_time = STRIKE_DURATION*2
  end

  function self:refresh ()
    if strike_dir then
      strike_time = strike_time - 1
      if strike_time <= 0 then
        strike_dir = nil
        strike_time = nil
        broadcastEvent(Event('StrikeEffectFinished'))
      end
    end
  end

  function self:draw (graphics, pos)
    local quad = currentQuad()
    graphics.push()
    if strike_dir then
      local d = 1 - math.abs(strike_time - STRIKE_DURATION)/STRIKE_DURATION
      graphics.translate((24*d*d*strike_dir):unpack())
    end
    graphics.draw(img, quad, pos.x, pos.y, 0, 1, 1, quadwidth/2, quadheight-16)
    graphics.pop()
  end

end

return class:bind 'Sprite'
