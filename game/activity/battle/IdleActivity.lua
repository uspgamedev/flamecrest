
local class   = require 'lux.oo.class'
local engine  = class.package 'engine'
local battle  = class.package 'activity.battle'
local domain  = class.package 'domain'

function battle:IdleActivity (UI, battlefield)

  engine.Activity:inherit(self)

  --[[ Event receivers ]]-------------------------------------------------------

  function self.__accept:Load ()
    UI:find("stats"):setText("")
    UI:find("screen"):clearRange()
  end

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    end
  end

  function self.__accept:TileClicked (tile)
    local unit = tile:getUnit()
    if unit then
      local action = domain.BattleAction(battlefield, unit, tile:getPos())
      self:switch(battle.TracePathActivity(UI, action))
    end
  end

end
