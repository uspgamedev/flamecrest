
local class     = require 'lux.oo.class'
local engine    = class.package 'engine'
local battle    = class.package 'activity.battle'
local ui        = class.package 'ui'

local Action    = class.package 'domain.battle' .Action

function battle:IdleActivity (UI, battlefield)

  engine.Activity:inherit(self)

  local lock = false

  --[[ Event receivers ]]-------------------------------------------------------

  function self.__accept:Load ()
    UI:find("stats"):setText("")
    UI:find("screen"):clearRange()
    if not battlefield:hasUnusedUnits() then
      battlefield:endTurn()
      self:sendEvent "TurnStart" (battlefield:getCurrentTeam())
    end
  end

  function self.__accept:KeyPressed (key)
    if not lock and key == 'escape' then
      self:finish()
    end
  end

  function self.__accept:TileClicked (tile)
    local unit = tile:getUnit()
    if not lock and unit and unit:getTeam() == battlefield:getCurrentTeam()
                and not unit:isUsed() then
      local action = Action(battlefield, unit, tile:getPos())
      self:switch(battle.TracePathActivity(UI, action))
    end
  end

end
