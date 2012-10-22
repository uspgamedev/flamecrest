
require "game"
require "combatlayout"
require "vec2"
require "battle.layout"
require "battle.map"
require "battle.hexpos"

math.randomseed( os.time() )

local function loadcombatlayout ()
  combatlayout:load(game)
  combatlayout:addcomponent(
    game.unit1:makedisplay(vec2:new{combatlayout.margin.left, combatlayout.margin.top})
  )
  combatlayout:addcomponent(
    game.unit2:makedisplay(vec2:new{combatlayout.middle, combatlayout.margin.top})
  )
end

local function loadbattlemaplayout ()
  local map = battle.map:new { width = 9, height = 9 }
  for i=6,9 do
    for j=1,i-5 do
      map.tiles[i][j] = nil
      map.tiles[j][i] = nil
    end
  end
  battle.layout.map = map
end

function love.load ()
  love.graphics.setFont(love.graphics.newFont("fonts/Verdana.ttf", 14))
  love.graphics.setDefaultImageFilter("nearest", "nearest")
  battle.layout:load(love.graphics)
  loadcombatlayout()
  loadbattlemaplayout()
  battle.layout.map.tiles[5][1].unit = game.unit1
  battle.layout.map.tiles[5][9].unit = game.unit2
  game.layouts.battle = battle.layout
  game.layouts.combat = combatlayout
  game.state.layout = combatlayout
end

love.update         = game.update
love.keypressed     = game.keypressed
love.keyreleased    = game.keyreleased
love.mousepressed   = game.mousepressed
love.mousereleased  = game.mousereleased

function love.draw()
  game.state.layout:draw(love.graphics)
end

