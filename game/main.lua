
local class = require 'lux.oo.class'
local UI

function love.load ()
  require 'engine.UI'
  require 'ui.BattleScreen'
  require 'domain.BattleField'
  UI            = class:UI()
  UI:add(class:BattleScreen(class:BattleField(5,5)))
end

function love.draw ()
  UI:draw(love.graphics)
end
