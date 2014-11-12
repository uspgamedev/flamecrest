
local class = require 'lux.oo.class'

require 'engine.UIElement'
require 'ui.battle.Cursor'

function class:BattleScreenElement (the_battlefield)

  local vec2    = require 'lux.geom.Vector'
  local hexpos  = require 'domain.hexpos'
  local class   = require 'lux.oo.class'

  __inherit.UIElement(self, vec2:new{0, 0},
                      vec2:new{ love.window.getDimensions() })

  local battlefield = the_battlefield
  local camera_pos  = hexpos:new{0, 0}
  local tileset     = {}
  local cursor      = class:Cursor()

  tileset.Plains = love.graphics.newImage "assets/images/hextile-grass.png"
  tileset.Forest = love.graphics.newImage "assets/images/hextile-forest.png"

  local function screenToHexpos (screenpos)
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

  function lookAt (i, j)
    if type(i) == 'number' then
      camera_pos = hexpos:new{i,j}
    else
      camera_pos = i:clone()
    end
  end

  -- @override
  function onMouseHover (pos)
    local hex = screenToHexpos(pos)
    if battlefield:getTileAt(hex) then
      cursor:setTarget(hex)
    else
      cursor:stop()
    end
  end

  -- @override
  function onRefresh ()
    cursor:move()
  end

  -- @override
  function draw (graphics, window)
    local frame = vec2:new{ window.getDimensions() }
    graphics.translate((frame/2 - camera_pos:toVec2()):unpack())
    battlefield:eachTile(function (i, j, tile)
      local pos = hexpos:new{i,j}:toVec2()
      local img = tileset[tile:getType()]
      graphics.draw(img, pos.x, pos.y, 0, 1, 1, img:getWidth()/2,
                    img:getHeight()/2)
    end)
    cursor:draw(graphics)
  end

end

return class.BattleScreenElement
