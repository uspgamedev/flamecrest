
local img   = love.graphics.newImage "assets/images/hextile-grass.png"
local tree  = love.graphics.newImage "assets/images/forest.png"

return function (graphics, pos)
  graphics.draw(img, pos.x, pos.y, 0, 1, 1, img:getWidth()/2,
                img:getHeight()/2)

  graphics.draw(tree, pos.x+18, pos.y-18, 0, 1, 1, tree:getWidth()/2,
                2*tree:getHeight()/3)
  graphics.draw(tree, pos.x-18, pos.y-18, 0, 1, 1, tree:getWidth()/2,
                2*tree:getHeight()/3)

  graphics.draw(tree, pos.x-32, pos.y, 0, 1, 1, tree:getWidth()/2,
                2*tree:getHeight()/3)
  graphics.draw(tree, pos.x+32, pos.y, 0, 1, 1, tree:getWidth()/2,
                2*tree:getHeight()/3)

  graphics.draw(tree, pos.x+18, pos.y+18, 0, 1, 1, tree:getWidth()/2,
                2*tree:getHeight()/3)
  graphics.draw(tree, pos.x-18, pos.y+18, 0, 1, 1, tree:getWidth()/2,
                2*tree:getHeight()/3)
end
