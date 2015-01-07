
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

require 'engine.UI'
require 'engine.Activity'

function class:BattlePickTargetActivity (UI, action)

  class.Activity(self)

  local combat

  --[[ Event receivers ]]-------------------------------------------------------

  function self.__accept:Load ()
    UI:find("screen"):displayRange(action:getAtkRange())
  end

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    end
  end

  function self.__accept:TileClicked (tile)
    local combat = action:startCombat(tile)
    if combat then
      UI:find("screen"):clearRange()
      self:addTask('CombatAnimation', combat)
    end
  end

  function self.__accept:Cancel ()
    UI:find("screen"):clearRange()
    self:switch(class:BattleSelectActionActivity(UI, action))
  end

  --[[ Tasks ]]-----------------------------------------------------------------

  function self.__task:CombatAnimation (combat_log)
    -- TODO mark unit as used for this turn
    self:switch(class:BattleIdleActivity(UI, action:getField()))
  end

end

return class:bind 'BattleSelectActionActivity'

