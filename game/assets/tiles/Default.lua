
local img = love.graphics.newImage "assets/images/hextile-empty.png"

return function (graphics, pos)
  graphics.draw(img, pos.x, pos.y, 0, 1, 1, img:getWidth()/2,
                img:getHeight()/2)
end
