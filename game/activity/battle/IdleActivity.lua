
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
    end
    self:addTask("TurnAnimation")
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

  --[[ Tasks ]]-----------------------------------------------------------------

  function self.__task:TurnAnimation ()
    lock = true
    local message = ui.TextElement('message', "", 48, nil, nil, 'center')
    local x, y = 64, 16
    self:yield(5)
    UI:add(message)
    message:setSize(512, 64)
    message:setText(string.format("%s's Turn", battlefield:getCurrentTeam()))
    for i=1,64 do
      message:setPos(x + 6*(i-1), y)
      self:yield()
    end
    UI:remove(message)
    lock = false
  end

end
