
require "game"
require "ui.layout"
require "ui.mouse"
require "combatlayout"
require "vec2"
require "battlemap.tile"

math.randomseed( os.time() )

local currentlayout = nil

function love.load ()
  love.graphics.setFont(love.graphics.newFont("fonts/Verdana.ttf", 14))
  battlemap.tile:load(love.graphics)
  currentlayout = game.combatlayout
  currentlayout:addcomponent(
    game.unit1:makedisplay(vec2:new{combatlayout.margin.left, combatlayout.margin.top})
  )
  currentlayout:addcomponent(
    game.unit2:makedisplay(vec2:new{combatlayout.middle, combatlayout.margin.top})
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
  ui.mouse.release(currentlayout, button, vec2:new{x,y})
end

local origin = vec2:new {100, 50}
local tilesize = vec2:new {128, 64}

function love.draw()
  currentlayout:draw(love.graphics)
end

