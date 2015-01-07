
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

require 'engine.UI'
require 'engine.Activity'
require 'ui.ListMenuElement'
require 'activity.BattlePickTargetActivity'

function class:BattleSelectActionActivity (UI, action)

  class.Activity(self)

  --[[ Event receivers ]]-------------------------------------------------------

  function self.__accept:Load ()
    local action_menu = class:ListMenuElement("action_menu", {"Fight", "Wait"},
                                              18, vec2:new{600, 16})
    local pos = UI:find("screen"):hexposToScreen(action:getCurrentPos())
                + vec2:new{-128, -160}
    action_menu:setPos(pos)
    UI:add(action_menu)
    UI:find("screen"):clearRange()
  end

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    end
  end

  function self.__accept:ListMenuOption (index, option)
    if option == "Wait" then
      -- TODO mark unit as used for this turn
      self:switch(class:BattleIdleActivity(UI, action:getField()))
    elseif option == "Fight" then
      self:switch(class:BattlePickTargetActivity(UI, action))
    end
    UI:remove("action_menu")
  end

  function self.__accept:Cancel ()
    action:abort()
    UI:remove("action_menu")
    self:switch(class:BattleTracePathActivity(UI, action))
  end

end

return class:bind 'BattleSelectActionActivity'

