
require "ui.layout"
require "vec2"

local ui = ui

module "battlemap" do

  layout = ui.layout:new {
    width = 8,
    height = 8
  }

  layout.__init = {
    origin = vec2:new {512,384}
  }
  
  function layout:draw (graphics)
    -- body
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
