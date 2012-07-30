
require "nova.table"
require "vec2"
require "game"
require "ui"
require "ui.button"
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
  ui.mouserelease(b, vec2:new{x,y})
end

function love.draw()

  local g = love.graphics

  layout.draw(g)
  ui.draw(love.graphics)

  g.push()
  g.translate(layout.left, layout.top)
  game.unit1:draw()
  g.pop()
  
  g.push()
  g.translate(layout.middle, layout.top)
  game.unit2:draw()
  g.pop()

  if (game.unit2:isdead()) then
     g.print("Winner!", 100, 80)
  end
  if (game.unit1:isdead()) then
     g.print("Winner!", 200, 80)
  end

end

