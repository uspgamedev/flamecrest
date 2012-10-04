
require "ui.layout"
require "vec2"

local ui    = ui
local vec2  = vec2

module "battle" do

  layout = ui.layout:new {
    map = nil,
    origin = vec2:new {512,0},
    tileset = {}
  }

  function layout:load (graphics)
    self.tileset.plains = graphics.newImage "resources/images/hextile-border.png"
  end
  
  function layout:draw (graphics)
    graphics.push()
    graphics.translate(self.origin.x, self.origin.y)
    for i = 1,self.map.height do
      for j = 1,self.map.width do
        local tile  = self.map.tiles[i][j]
        if tile then
          local pos   = vec2:new{97*i-97*j, 32*i+32*j}
          local image = self.tileset[tile.type]
          graphics.draw(image, pos.x, pos.y, 0, 1, 1, 64, 32)
        end
      end
    end
    graphics.pop()
    ui.layout.draw(self, graphics)
  end

  --love.graphics.setBackgroundColor(180,120,40)
  --for i=1,w do
  --  for j=1,h do
  --    local pos = origin + vec2:new{96*i,63*j+32*i}
  --    love.graphics.draw(hextile, pos.x, pos.y, 0, 1, 1, tilesize.x/2, tilesize.y/2)
  --  end
  --end
  --local final_pos = origin + vec2:new{96*man_pos.x, 63*man_pos.y+32*man_pos.x}
  --love.graphics.draw(stickman, final_pos.x, final_pos.y, 0, 1, 1, 32, 84)
  
end
