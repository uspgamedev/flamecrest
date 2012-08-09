
require "game"
require "ui.layout"
require "ui.mouse"
require "layout"

math.randomseed( os.time() )

function love.load ()
  love.graphics.setFont(love.graphics.newFont("fonts/Verdana.ttf", 14))
  ui.layout.addcomponent(layout:new{})
  ui.layout.addcomponent(
    game.unit1:makedisplay(vec2:new{layout.margin.left, layout.margin.top})
  )
  ui.layout.addcomponent(
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

function love.mousereleased (x, y, button)
  ui.mouse.release(button, vec2:new{x,y})
end

function love.draw()
  ui.layout.draw(love.graphics)
end

