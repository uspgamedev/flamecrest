
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

local engine  = class.package 'engine'
local battle  = class.package 'activity.battle'

function battle:PickTargetActivity (UI, action)

  engine.Activity:inherit(self)

  local combat

  --[[ Event receivers ]]-------------------------------------------------------

  function self.__accept:Load ()
    UI:find("screen"):displayRange(action:getAtkRange())
  end

  function self.__accept:KeyPressed (key)
    if not combat and key == 'escape' then
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
    if not combat then
      UI:find("screen"):clearRange()
      self:switch(battle.SelectActionActivity(UI, action))
    end
  end

  --[[ Tasks ]]-----------------------------------------------------------------

  function self.__task:CombatAnimation ()
    -- TODO mark unit as used for this turn
    local log = combat:fight()
    for i,strike in ipairs(log) do
      self:sendEvent 'ShowStrikeAnimation' (strike)
      self:yield('StrikeAnimationFinished')
    end
    self:switch(battle.IdleActivity(UI, action:getField()))
  end

end
