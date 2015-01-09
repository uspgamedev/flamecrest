
local class     = require 'lux.oo.class'
local vec2      = require 'lux.geom.Vector'
local lambda    = require 'lux.functional'
local hexpos    = require 'domain.hexpos'

local engine    = class.package 'engine'
local ui        = class.package 'ui.battle'

local markereffectcode = [[
  vec4 effect (vec4 color, Image texture, vec2 tex_pos, vec2 pix_pos) {
    vec4 result = Texel(texture, tex_pos)*color;
    number bright = 0.7+0.3*distance(tex_pos, vec2(0.5, 0.5));
    return result+vec4(bright*%f, bright*%f, bright*%f, 1.0)*result.a;
  }
]]

local function makemarkereffect (graphics, r, g, b)
  return graphics.newShader(string.format(markereffectcode, r, g, b))
end

local glow = {
  move = makemarkereffect(love.graphics, 0, 0, 1),
  atk  = makemarkereffect(love.graphics, 0.8, 0.1, 0)
}

function ui:ScreenElement (name, battlefield)

  engine.UIElement:inherit(self, name, vec2:new{0, 0},
                           vec2:new{ love.window.getDimensions() })

  local camera_pos  = hexpos:new{0, 0}
  local tileset     = {}
  local sprites     = {}
  local cursor      = ui.Cursor()
  local range

  tileset.Default   = require 'assets.tiles.Default'
  tileset.Plains    = require 'assets.tiles.Plains'
  tileset.Forest    = require 'assets.tiles.Forest'

  local function screenToHexpos (screenpos)
    -- TODO: inject love.window dependency
    local origin = vec2:new{ love.window.getDimensions() }/2 - camera_pos:toVec2()
    local relpos = screenpos - origin
    local focus = hexpos:new {}
    local floor = math.floor
    relpos = relpos.x/192*vec2:new{1,-1} + relpos.y/64*vec2:new{1,1}
    focus.i = floor(relpos.y+0.5)
    focus.j = floor(relpos.x+0.5)
    local x,y = relpos.x-focus.j+0.5, relpos.y-focus.i+0.5
    if y > 2*x + 0.5 or y > x/2 + 0.75 then
      if x + y < 1 then
        focus.j = focus.j-1
      else
        focus.i = focus.i+1
      end
    elseif x > 2*y + 0.5 or x > y/2 + 0.75 then
      if x + y < 1 then
        focus.i = focus.i-1
      else
        focus.j = focus.j+1
      end
    end
    return focus
  end

  function self:getSprite (unit)
    local sprite = sprites[unit]
    if not sprite then
      sprite = ui.Sprite("chibi-soldier")
      sprites[unit] = sprite
    end
    return sprite
  end

  function self:lookAt (i, j)
    if type(i) == 'number' then
      camera_pos = hexpos:new{i,j}
    else
      camera_pos = i:clone()
    end
  end

  function self:hexposToScreen (hex)
    local frame = vec2:new{ love.window.getDimensions() }
    return frame/2 - (camera_pos - hex):toVec2()
  end

  function self:displayRange (the_range)
    range = the_range
  end

  function self:clearRange ()
    range = nil
  end

  --- Overrides @{UIElement:onMousePressed}
  function self:onMousePressed (pos, button)
    if button == 'l' then
      local tile_hexpos   = screenToHexpos(pos)
      local tile          = battlefield:getTileAt(tile_hexpos)
      if tile then
        broadcastEvent(engine.Event('TileClicked', tile))
      end
    elseif button == 'r' then
      broadcastEvent(engine.Event('Cancel'))
    end
  end

  --- Overrides @{UIElement:onMouseHover}
  function self:onMouseHover (pos)
    local hex = screenToHexpos(pos)
    if battlefield:getTileAt(hex) then
      cursor:setTarget(hex)
    else
      cursor:stop()
    end
  end

  -- @override
  function self:onRefresh ()
    cursor:move()
    for _,sprite in pairs(sprites) do
      sprite:refresh()
    end
  end

  local function drawTile (graphics, i, j, tile)
    local pos = hexpos:new{i,j}:toVec2()
    do -- draw the tile
      local draw = tileset[tile:getType()]
      if range and range[i][j] then
        graphics.setShader(glow[range[i][j].type])
      end
      draw(graphics, pos)
      graphics.setShader()
    end
    do -- draw the unit
      local unit = tile:getUnit()
      if unit then
        self:getSprite(unit):draw(graphics, pos)
      end
    end
  end

  -- @override
  function self:draw (graphics, window)
    local frame = vec2:new{ window.getDimensions() }
    graphics.translate((frame/2 - camera_pos:toVec2()):unpack())
    battlefield:eachTile(lambda.bindFirst(drawTile, graphics))
    cursor:draw(graphics)
  end

end
