
package.path = package.path..";../game/lib/?.lua"

local game    = require "game"
local vec2    = require "lux.geom.Vector"
local layout  = require "ui.layout"
require "ui.battle.mapscene"
require "model.battle.map"
require "model.battle.hexpos"

math.randomseed(os.time())

local function loadbattlemaplayout ()
  local map = model.battle.map:new { width = 12, height = 12 }
  for i=9,12 do
    for j=1,i-7 do
      map.tiles[i][j] = nil
      map.tiles[j][i] = nil
    end
  end
  ui.battle.mapscene:load(love.graphics)
  ui.battle.mapscene:setup(map, love.graphics)
end

function love.load ()
  love.graphics.setFont(love.graphics.newFont("resources/fonts/Verdana.ttf", 14))
  love.graphics.setDefaultFilter("nearest", "nearest")
  layout.add(ui.battle.mapscene)
  loadbattlemaplayout()
  ui.battle.mapscene.map.tiles[5][1].unit = game.unit1
  ui.battle.mapscene.map.tiles[5][9].unit = game.unit2
end

love.update         = game.update
love.keypressed     = game.keypressed
love.keyreleased    = game.keyreleased
love.mousepressed   = game.mousepressed
love.mousereleased  = game.mousereleased

function love.draw ()
  layout.draw(love.graphics)
end

