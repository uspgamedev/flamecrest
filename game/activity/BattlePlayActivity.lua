
local class   = require 'lux.oo.class'

require 'engine.Activity'
require 'domain.Unit'

function class:BattlePlayActivity (battlefield, units)

  class.Activity(self)

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

