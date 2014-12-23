
local class   = require 'lux.oo.class'
local spec    = require 'domain.unitspec'
local hexpos  = require 'domain.hexpos'

require 'engine.UI'
require 'engine.Activity'
require 'domain.BattleField'
require 'domain.Unit'

function class:BattlePlayActivity ()

  class.Activity(self)

  local battlefield = class:BattleField(6, 6)
  local unit        = class:Unit("Leeroy Jenkins", true, spec:new{}, spec:new{})

  function self.__accept:Load ()
    battlefield:putUnit(hexpos:new{1,1}, unit)
    self:sendEvent 'BattleFieldCreated' (battlefield)
  end

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    end
  end

end

return class:bind 'BattlePlayActivity'

