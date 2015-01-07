
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

require 'engine.UI'
require 'engine.Activity'
require 'activity.BattleSelectActionActivity'

function class:BattleTracePathActivity (UI, action)

  class.Activity(self)

  local moving = false

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
    if not moving then
      action:abort()
      action:findPath(tile:getPos())
      if not action:validPath() then
        UI:find("screen"):clearRange()
        moving = true
        self:addTask('MoveAnimation')
      end
    end
  end

  function self.__accept:Cancel ()
    if moving then
      action:abort()
      moving = false
      UI:find("screen"):displayRange(action:getActionRange())
    else
      self:switch(class:BattleIdleActivity(UI, action:getField()))
    end
  end

  --[[ Tasks ]]-----------------------------------------------------------------

  function self.__task:MoveAnimation ()
    repeat
      action:moveUnit()
      self:yield(10)
    until action:validPath()
    if moving then
      self:switch(class:BattleSelectActionActivity(UI, action))
    end
  end

end

return class:bind 'BattleTracePathActivity'

