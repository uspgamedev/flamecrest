
require "nova.table"
require "vec2"
require "game"
require "button"
require "layout"

math.randomseed( os.time() )

function love.load ()
  love.graphics.setFont(love.graphics.newFont("fonts/Verdana.ttf", 14))
end

function love.update (dt)
  -- NOTHING
end

function love.keypressed (key)
  -- NOTHING
end

function love.keyreleased (key)
  if game.keyactions[key] then
    game.keyactions[key]()
  end
end

function love.mousereleased (x, y, b)
  if b == "l" then
    button.check(layout.buttons, vec2:new {x, y})
  end
end

function love.draw()

  love.graphics.push()
  love.graphics.translate(layout.left, layout.top)
  game.unit1:draw()
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.translate(layout.middle, layout.top)
  game.unit2:draw()
  love.graphics.pop()

  if (game.unit2:isdead()) then
     love.graphics.print("Winner!", 100, 80)
  end
  if (game.unit1:isdead()) then
     love.graphics.print("Winner!", 200, 80)
  end

  for _,v in pairs(layout.buttons) do
    v:draw()
  end

end

