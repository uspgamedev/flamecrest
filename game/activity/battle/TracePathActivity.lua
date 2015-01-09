
local class   = require 'lux.oo.class'
local engine  = class.package 'engine'
local battle  = class.package 'activity.battle'

function battle:TracePathActivity (UI, action)

  engine.Activity:inherit(self)

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
      if action:validPath() then
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
      self:switch(battle.IdleActivity(UI, action:getField()))
    end
  end

  --[[ Tasks ]]-----------------------------------------------------------------

  function self.__task:MoveAnimation ()
    repeat
      action:moveUnit()
      self:yield(10)
    until action:finishedPath()
    if moving then
      self:switch(battle.SelectActionActivity(UI, action))
    end
  end

end

