
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
    combat = action:startCombat(tile)
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

  function self.__task:CombatAnimation ()
    -- TODO mark unit as used for this turn
    local log = combat:fight()
    for i,strike in ipairs(log) do
      print(strike.atk:getName().." attacks "..strike.def.getName())
      print("  Hits? "..tostring(not not strike.hit))
      local dir = (strike.deftile:getPos() - strike.atktile:getPos())
      UI:find("screen"):makeStrikeEffect(strike.atk, dir)
      if strike.hit then
        print("  Crits? "..tostring(not not strike.critical))
        print("  Damage: "..strike.damage)
      end
      self:yield('StrikeEffectFinished')
    end
    self:switch(class:BattleIdleActivity(UI, action:getField()))
  end

end

return class:bind 'BattleSelectActionActivity'

