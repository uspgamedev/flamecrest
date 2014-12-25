
local class   = require 'lux.oo.class'
local spec    = require 'domain.unitspec'
local hexpos  = require 'domain.hexpos'

require 'engine.UI'
require 'engine.Activity'
require 'domain.BattleField'
require 'domain.Unit'
require 'activity.BattlePlayActivity'
require 'activity.BattleUIActivity'

function class:BattleStartActivity (ui)

  class.Activity(self)

  local battlefield = class:BattleField(6, 6)
  local units       = {
    class:Unit("Leeroy Jenkins", true, spec:new{}, spec:new{}),
    class:Unit("Juaum MacDude", true, spec:new{}, spec:new{})
  }

  function self.__accept:Load ()
    battlefield:putUnit(hexpos:new{1,1}, units[1])
    battlefield:putUnit(hexpos:new{5,5}, units[2])
    self:switch(class:BattlePlayActivity(battlefield, units),
                class:BattleUIActivity(battlefield, ui))
  end

end

return class:bind 'BattleStartActivity'

