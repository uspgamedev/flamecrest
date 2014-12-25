
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

require 'engine.UI'
require 'engine.Activity'
require 'domain.BattleField'
require 'domain.Unit'

function class:BattleMoveAnimationUIActivity (UI, action)

  class.Activity(self)

  --[[ Event receivers ]]-------------------------------------------------------

  function self.__accept:Load ()
    self:addTask('MoveAnimation')
    UI:find("screen"):clearRange()
  end

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    end
  end

  --[[ Tasks ]]-----------------------------------------------------------------

  function self.__task:MoveAnimation (path)
    repeat
      self:yield(10)
      action:moveUnit()
    until action:pathFinished()
    --switchTo('SelectAction', path[1], state.unit)
  end

end

return class:bind 'BattleMoveAnimationUIActivity'

