
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'
local engine  = class.package 'engine'
local ui      = class.package 'ui'
local battle  = class.package 'activity.battle'

function battle:SelectActionActivity (UI, action)

  engine.Activity:inherit(self)

  --[[ Event receivers ]]-------------------------------------------------------

  function self.__accept:Load ()
    local action_menu = ui.ListMenuElement("action_menu", {"Fight", "Wait"}, 18)
    local pos = UI:find("screen"):hexposToScreen(action:getCurrentPos())
                + vec2:new{64, -96}
    action_menu:setPos(pos)
    UI:add(action_menu, true)
  end

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    end
  end

  function self.__accept:ListMenuOption (index, option)
    if option == "Wait" then
      action:finish()
      self:switch(battle.IdleActivity(UI, action:getField()))
    elseif option == "Fight" then
      self:switch(battle.PickTargetActivity(UI, action))
    end
    UI:remove("action_menu")
    UI:focus("screen")
  end

  function self.__accept:Cancel ()
    action:abort()
    UI:remove("action_menu")
    UI:focus("screen")
    self:switch(battle.TracePathActivity(UI, action))
  end

end
