
require "game"
--require "combat.layout"
require "vec2"
require "ui.battle.mapscene"
require "battle.map"
require "battle.hexpos"
require "ui.layout"

math.randomseed(os.time())

--local function loadcombatlayout ()
--  combat.layout:load(game)
--  combat.layout:addcomponent(
--    game.unit1:makedisplay(vec2:new{combat.layout.margin.left, combat.layout.margin.top})
--  )
--  combat.layout:addcomponent(
--    game.unit2:makedisplay(vec2:new{combat.layout.middle, combat.layout.margin.top})
--  )
--end

local function loadbattlemaplayout ()
  local map = battle.map:new { width = 9, height = 9 }
  for i=6,9 do
    for j=1,i-5 do
      map.tiles[i][j] = nil
      map.tiles[j][i] = nil
    end
  end
  ui.battle.mapscene:load(love.graphics)
  ui.battle.mapscene:setup(map, love.graphics)
end

function love.load ()
  love.graphics.setFont(love.graphics.newFont("fonts/Verdana.ttf", 14))
  love.graphics.setDefaultImageFilter("nearest", "nearest")
  --loadcombatlayout()
  ui.layout.add(ui.battle.mapscene)
  loadbattlemaplayout()
  ui.battle.mapscene.map.tiles[5][1].unit = game.unit1
  ui.battle.mapscene.map.tiles[5][9].unit = game.unit2
  --game.layouts.battle = battle.layout
  --game.layouts.combat = combat.layout
  --game.changetolayout "battle"
end

love.update         = game.update
love.keypressed     = game.keypressed
love.keyreleased    = game.keyreleased
love.mousepressed   = game.mousepressed
love.mousereleased  = game.mousereleased

function love.draw ()
  ui.layout.draw(love.graphics)
end

