
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

local engine  = class.package 'engine'
local battle  = class.package 'activity.battle'
local ui      = class.package 'ui'

local stats_display = [[
%s
%s
Team: %s
Lv: %d | HP: %d/%d
Wpn: %s
]]

function battle:TracePathActivity (UI, action)

  engine.Activity:inherit(self)

  local moving = false

  --[[ Event receivers ]]-------------------------------------------------------

  function self.__accept:Load ()
    local unit = action:getUnit()
    local screen = UI:find("screen")
    local stats = ui.TextElement("stats", "", 18,
                                 vec2:new{16, screen:getHeight()-120-16},
                                 vec2:new{256, 120}, 'left')
    stats:setText(stats_display:format(
      unit:getName(), unit:getClass():getName(), unit:getTeam():getName(),
      unit:getLv(), unit:getHP(), unit:getMaxHP(), unit:getWeapon():getName()
    ))
    UI:add(stats)
    screen:displayRange(action:getActionRange())
  end

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    end
  end

  function self.__accept:TileClicked (tile)
    if not moving then
      action:findPath(tile:getPos())
      if action:validPath() then
        UI:find("screen"):clearRange()
        moving = true
        self:addTask('MoveAnimation')
      end
    end
  end

  function self.__accept:Cancel ()
    action:abort()
    if moving then
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

