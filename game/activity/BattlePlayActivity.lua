
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
  local units       = {
    class:Unit("Leeroy Jenkins", true, spec:new{}, spec:new{}),
    class:Unit("Juaum MacDude", true, spec:new{}, spec:new{})
  }

  function self.__accept:Load ()
    battlefield:putUnit(hexpos:new{1,1}, units[1])
    battlefield:putUnit(hexpos:new{5,5}, units[2])
    self:sendEvent 'BattleFieldCreated' (battlefield)
  end

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    elseif key == ' ' then
      for _,unit in ipairs(units) do
        unit:resetSteps()
      end
    end
  end

  function self.__accept:PathRequest (from, to)
    local path = battlefield:findPath(from, to)
    if path then
      self:sendEvent 'PathResult' (path)
    end
  end

  function self.__accept:MoveUnit (pos, dir)
    battlefield:moveUnit(pos, dir)
  end

end

return class:bind 'BattlePlayActivity'

