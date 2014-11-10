
local UI

function love.load ()
  UI = require 'engine.UI' ()
  UI:add(require 'ui.BattleScreen' ())
end

function love.draw ()
  UI:draw(love.graphics)
end
