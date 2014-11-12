
local class = require 'lux.oo.class'
local UI
local screen

function love.load ()
  require 'engine.UI'
  require 'ui.BattleScreen'
  require 'domain.BattleField'
  UI = class:UI()
  screen = class:BattleScreen(class:BattleField(5,5))
  screen:lookAt(3, 3)
  UI:add(screen)

end

function love.draw ()
  UI:draw(love.graphics, love.window)
end
