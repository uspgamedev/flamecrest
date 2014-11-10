
local class = require 'lux.oo.class'
require 'engine.UIElement'

function class:BattleScreen(the_map)

  local vec2    = require 'lux.geom.Vector'
  local hexpos  = require 'domain.hexpos'

  __inherit.UIElement(self, vec2:new{0, 0},
                      vec2:new{ love.window.getDimensions() })

  local map = the_map
  local camera_pos = self:getSize()/2
  local tileset = {}

  tileset.plains = love.graphics.newImage "assets/images/hextile-grass.png"
  tileset.forest = love.graphics.newImage "assets/images/hextile-forest.png"

  function draw (graphics)
    for i=1,5 do
      for j=1,5 do
        local pos = camera_pos + hexpos:new{i,j}:toVec2()
        local img = tileset.plains
        graphics.draw(img, pos.x, pos.y, 0, 1, 1, img:getWidth()/2,
                      img:getHeight()/2)
      end
    end
  end

end

return class.BattleScreen
