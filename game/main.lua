
local FRAME = 1/60

local BattleActivity = require 'activity.BattleActivity'
local current_activity

function love.load ()
  current_activity = BattleActivity()
end

do

  local lag = 0

  function love.update (dt)
    lag = lag + dt
    while lag > FRAME do
      current_activity:update()
      current_activity:getUI():refresh()
      lag = lag - FRAME
    end
  end

end

function love.draw ()
  current_activity:getUI():draw(love.graphics, love.window)
end
