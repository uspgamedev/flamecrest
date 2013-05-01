
require "game"
require "common.vec2"
require "ui.layout"
require "ui.battle.mapscene"
require "model.battle.map"
require "model.battle.hexpos"
require "controller.battle"

math.randomseed(os.time())

local function loadbattlemaplayout ()
  local battlecontroller = controller.battle:new{ width = 12, height = 12 }
  ui.battle.mapscene:load(love.graphics)
  ui.battle.mapscene:setup(battlecontroller.map, love.graphics)
end

function love.load ()
  love.graphics.setFont(love.graphics.newFont("resources/fonts/Verdana.ttf", 14))
  love.graphics.setDefaultImageFilter("nearest", "nearest")
  ui.layout.add(ui.battle.mapscene)
  loadbattlemaplayout()
end

love.update         = game.update
love.keypressed     = game.keypressed
love.keyreleased    = game.keyreleased
love.mousepressed   = game.mousepressed
love.mousereleased  = game.mousereleased

function love.draw ()
  ui.layout.draw(love.graphics)
end

