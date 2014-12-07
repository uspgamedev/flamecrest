
local FRAME = 1/60

local vec2                = require 'lux.geom.Vector'
local BattleActivity      = require 'activity.BattleActivity'
local BattleScreenElement = require 'ui.BattleScreenElement'
local game_ui             = require 'engine.UI' ()
local current_activity

function love.load ()
  current_activity = BattleActivity(game_ui)
  game_ui:add(BattleScreenElement())
  current_activity:onLoad()
  love.update(FRAME)
end

do

  local lag = 0

  function love.update (dt)
    lag = lag + dt
    while lag >= FRAME do
      game_ui:receiveResults(current_activity:pollResults())
      game_ui:refresh()
      lag = lag - FRAME
    end
  end

end

function love.draw ()
  game_ui:draw(love.graphics, love.window)
end
