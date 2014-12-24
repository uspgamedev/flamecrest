
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

require 'engine.UI'
require 'engine.Activity'
require 'ui.BattleScreenElement'
require 'ui.TextElement'
require 'ui.ListMenuElement'
require 'domain.BattleField'
require 'domain.Unit'

function class:BattleUIActivity (UI)

  class.Activity(self)

  local screen      = nil
  local unitname    = nil
  local action_menu = nil
  local state       = { mode = 'idle' }

  function self.__accept:BattleFieldCreated (battlefield)
    screen = class:BattleScreenElement(battlefield)
    UI:add(screen)
    screen:lookAt(3, 3)
    unitname = class:TextElement("", 18, vec2:new{16, 16}, vec2:new{256, 20})
    UI:add(unitname)
    action_menu = class:ListMenuElement({"Fight", "Wait"}, 18, vec2:new{600, 16})
  end

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    end
  end

  function self.__accept:TileClicked (hex, tile)
    local unit = tile:getUnit()
    if state.mode == 'idle' then
      if unit then
        unitname:setText(unit:getName())
        screen:displayRange(hex)
        state.mode = 'select:move'
        state.pos = hex
        state.unit = unit
      end
    elseif state.mode == 'select:move' then
      self:sendEvent 'PathRequest' (state.pos, hex)
    end
  end

  function self.__accept:PathResult (path)
    if state.mode == 'select:move' then
      self:addTask('MoveAnimation', path)
      state.mode = 'animation:move'
      screen:clearRange()
    end
  end

  function self.__accept:Cancel ()
    if state.mode == 'select:move' then
      unitname:setText("")
      screen:clearRange()
      state.mode = 'idle'
    end
  end

  function self.__accept:ListMenuOption (index, option)
    if state.mode == 'select:action' then
      if option == "Wait" then
        state.mode = 'idle'
        UI:remove(action_menu)
      elseif option == "Fight" then
        UI:remove(action_menu)
        screen:displayAtkRange(state.pos)
        state.mode = 'select:atktarget'
      end
    end
  end

  function self.__task:MoveAnimation (path)
    for i=#path-1,1,-1 do
      self:yield(10)
      local dir = path[i]-path[i+1]
      self:sendEvent 'MoveUnit' (path[i+1], dir)
    end
    unitname:setText("")
    state.mode = 'select:action'
    state.pos  = path[1]
    action_menu:setPos(screen:hexposToScreen(path[1])+vec2:new{-128, -160})
    UI:add(action_menu)
  end

end

return class:bind 'BattleUIActivity'

