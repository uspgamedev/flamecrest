
require "game"
require "ui"
require "layout"

math.randomseed( os.time() )

function love.load ()
  love.graphics.setFont(love.graphics.newFont("fonts/Verdana.ttf", 14))
  ui.addcomponent(layout:new{})
  ui.addcomponent(
    game.unit1:makedisplay(vec2:new{layout.margin.left, layout.margin.top})
  )
  ui.addcomponent(
    game.unit2:makedisplay(vec2:new{layout.middle, layout.margin.top})
  )
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

  ui.draw(love.graphics)

  if (game.unit2:isdead()) then
     g.print("Winner!", 100, 80)
  end
  if (game.unit1:isdead()) then
     g.print("Winner!", 200, 80)
  end

end

