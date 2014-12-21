
local class     = require 'lux.oo.class'
local vec2      = require 'lux.geom.Vector'
local hexpos    = require 'domain.hexpos'
local Cursor    = require 'ui.battle.Cursor'

function class:BattleScreenElement (battlefield)

  require 'engine.UIElement'
  require 'ui.battle.Sprite'
  class.UIElement(self, vec2:new{0, 0}, vec2:new{ love.window.getDimensions() })

  local camera_pos  = hexpos:new{0, 0}
  local tileset     = {}
  local sprites     = {}
  local cursor      = Cursor()

  tileset.Plains = love.graphics.newImage "assets/images/hextile-grass.png"
  tileset.Forest = love.graphics.newImage "assets/images/hextile-forest.png"

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

  function self:lookAt (i, j)
    if type(i) == 'number' then
      camera_pos = hexpos:new{i,j}
    else
      camera_pos = i:clone()
    end
  end

  local function getSprite (name)
    local sprite = sprites[name]
    if not sprite then
      sprite = class:Sprite(name)
      sprites[name] = sprite
    end
    return sprite
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
  end

  -- @override
  function self:draw (graphics, window)
    local frame = vec2:new{ window.getDimensions() }
    graphics.translate((frame/2 - camera_pos:toVec2()):unpack())
    battlefield:eachTile(function (i, j, tile)
      local pos = hexpos:new{i,j}:toVec2()
      local img = tileset[tile:getType()]
      graphics.draw(img, pos.x, pos.y, 0, 1, 1, img:getWidth()/2,
                    img:getHeight()/2)
      local unit = tile:getUnit()
      if unit then
        getSprite("soldiaaa_spritesheet_v1"):draw(graphics, pos)
      end
    end)
    cursor:draw(graphics)
  end

end

return class:bind 'BattleScreenElement'
