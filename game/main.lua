
require "game"
require "combat.layout"
require "vec2"
require "battle.layout"
require "battle.map"
require "battle.hexpos"

math.randomseed( os.time() )

local function loadcombatlayout ()
  combat.layout:load(game)
  combat.layout:addcomponent(
    game.unit1:makedisplay(vec2:new{combat.layout.margin.left, combat.layout.margin.top})
  )
  combat.layout:addcomponent(
    game.unit2:makedisplay(vec2:new{combat.layout.middle, combat.layout.margin.top})
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
  battle.layout:setmap(map)
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
  game.layouts.combat = combat.layout
  game.changetolayout "combat"
end

love.update         = game.update
love.keypressed     = game.keypressed
love.keyreleased    = game.keyreleased
love.mousepressed   = game.mousepressed
love.mousereleased  = game.mousereleased

function love.draw()
  game.state.layout:draw(love.graphics)
end

