
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

require 'engine.UI'
require 'engine.Activity'
require 'activity.BattleMoveAnimationUIActivity'

function class:BattleTracePathUIActivity (UI, action)

  class.Activity(self)

  --[[ Event receivers ]]-------------------------------------------------------

  function self.__accept:Load ()
    UI:find("stats"):setText(action:getUnit():getName())
    UI:find("screen"):displayRange(action:getActionRange())
  end

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    end
  end

  function self.__accept:TileClicked (tile)
    action:findPath(tile:getPos())
    self:switch(class:BattleMoveAnimationUIActivity(UI, action))
  end

  function self.__accept:Cancel ()
    action:abort()
    self:switch(class:BattleIdleUIActivity(UI, action:getField()))
  end

end

return class:bind 'BattleTracePathUIActivity'

