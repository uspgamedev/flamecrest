
require "game"
require "ui.layout"
require "ui.mouse"
require "combatlayout"
require "vec2"
require "battle.layout"
require "battle.map"
require "battle.hexpos"

math.randomseed( os.time() )

local currentlayout = nil

local function loadcombatlayout ()
  game.combatlayout:addcomponent(
    game.unit1:makedisplay(vec2:new{combatlayout.margin.left, combatlayout.margin.top})
  )
  game.combatlayout:addcomponent(
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
  battle.layout:load(love.graphics)
  loadcombatlayout()
  loadbattlemaplayout()
  battle.layout.map.tiles[5][1].unit = game.unit1
  battle.layout.map.tiles[5][9].unit = game.unit2
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
  ui.mouse.release(game.currentlayout, button, vec2:new{x,y})
end

function love.mousepressed (x, y, button)
  ui.mouse.press(game.currentlayout, button, vec2:new{x,y})
end

local origin = vec2:new {100, 50}
local tilesize = vec2:new {128, 64}

function love.draw()
  game.currentlayout:draw(love.graphics)
end

