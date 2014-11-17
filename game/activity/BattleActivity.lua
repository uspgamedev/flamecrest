
local class   = require 'lux.oo.class'
local spec    = require 'domain.unitspec'
local hexpos  = require 'domain.hexpos'

require 'engine.UI'
require 'engine.Activity'
require 'ui.BattleScreenElement'
require 'domain.BattleField'
require 'domain.Unit'

function class:BattleActivity ()

  class.Activity(self)

  local battlefield = class:BattleField(5,5)
  local unit        = class:Unit("Leeroy Jenkins", true, spec:new{}, spec:new{})
  local screen      = class:BattleScreenElement(battlefield)

  battlefield:putUnit(hexpos:new{1,1}, unit)
  screen:lookAt(3, 3)
  self:getUI():add(screen)

end

return class:bind 'BattleActivity'

