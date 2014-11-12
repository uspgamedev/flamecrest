
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

  function lookAt (i, j)
    if type(i) == 'number' then
      camera_pos = hexpos:new{i,j}
    else
      camera_pos = i:clone()
    end
  end

  -- @override
  function onRefresh ()
    --:cursor:move()
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
