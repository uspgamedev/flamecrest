
local FRAME = 1/60

local class   = require 'lux.oo.class'
local spec    = require 'domain.unitspec'
local hexpos  = require 'domain.hexpos'
local UI
local screen
local battlefield
local unit

function love.load ()

  require 'engine.UI'
  require 'ui.BattleScreenElement'
  require 'domain.BattleField'
  require 'domain.Unit'

  UI = class:UI()
  battlefield = class:BattleField(5,5)
  unit = class:Unit("Leeroy Jenkins", true, spec:new{}, spec:new{})
  screen = class:BattleScreenElement(battlefield)

  battlefield:putUnit(hexpos:new{1,1}, unit)
  screen:lookAt(3, 3)
  UI:add(screen)
end

do

  local lag = 0

  function love.update (dt)
    lag = lag + dt
    while lag > FRAME do
      UI:refresh()
      lag = lag - FRAME
    end
  end

end

function love.draw ()
  UI:draw(love.graphics, love.window)
end
