
local img = love.graphics.newImage "assets/images/hextile-grass.png"

return function (graphics, pos, drawUnit)
  graphics.draw(img, pos.x, pos.y, 0, 1, 1, img:getWidth()/2,
                img:getHeight()/2)
  drawUnit()
end
