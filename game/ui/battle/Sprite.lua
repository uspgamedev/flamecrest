
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'
local hexpos  = require 'domain.common.hexpos'

local ui      = class.package 'ui.battle'

local shadercode = [[
  vec4 effect (vec4 color, Image texture, vec2 tex_pos, vec2 pix_pos) {
    vec4 pixel = Texel(texture, tex_pos);
    number mask  = Texel(texture, tex_pos + vec2(.0, .5)).a;
    return color*pixel*mask + pixel*(1.0-mask);
  }
]]

local variations = {
  lance = 1,
  sword = 2,
  axe   = 3,
  bow   = 4
}

function ui:Sprite (imgname, color, weapontype)

  local img = love.graphics.newImage("assets/images/"..imgname..".png")
  local quadwidth = 64
  local quadheight = 64
  local quads = {}
  for i=1,1 do
    for j=1,8 do
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
  local frame = 20
  local tick  = 0
  local shader = love.graphics.newShader(shadercode)
  local variation = variations[weapontype]

  local offset = vec2:new{}

  local function currentQuad ()
    return quads[2*(variation-1) + currentindex]
  end

  function self:setOffset (o)
    offset = o:clone()
  end

  function self:getOffset ()
    return offset:clone()
  end

  function self:refresh ()
    tick = tick + 1
    if tick > frame then
      tick = 0
      currentindex = (currentindex % 2) + 1
    end
  end

  function self:draw (graphics, pos, used)
    local quad = currentQuad()
    graphics.push()
    graphics.translate(offset:unpack())
    if used then
      graphics.setColor(100, 100, 100, 255)
    else
      graphics.setColor(color or { 0, 0, 255, 255 })
      graphics.setShader(shader)
    end
    graphics.draw(img, quad, pos.x, pos.y, 0, 1, 1, quadwidth/2, quadheight-16)
    graphics.setShader()
    graphics.setColor(255, 255, 255, 255)
    graphics.pop()
  end

end
