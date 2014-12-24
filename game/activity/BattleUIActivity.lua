
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
  local state       = { mode = 'Idle' }
  local __switch    = {}

  local function switchTo (mode, ...)
    state.mode = mode
    __switch[mode](...)
  end

  --[[ State transitions ]]-----------------------------------------------------

  function __switch.Idle ()
    UI:remove(action_menu)
    unitname:setText("")
    screen:clearRange()
    state.pos = nil
    state.unit = nil
  end

  function __switch.SelectMove (pos, unit)
    unitname:setText(unit:getName())
    screen:displayRange(pos)
    state.pos = pos
    state.unit = unit
  end

  function __switch.SelectAction (pos, unit)
    action_menu:setPos(screen:hexposToScreen(pos)+vec2:new{-128, -160})
    UI:add(action_menu)
    screen:clearRange()
    state.pos = pos
    state.unit = unit
  end

  function __switch.SelectAtkTarget (pos, unit)
    UI:remove(action_menu)
    screen:displayAtkRange(state.pos)
    state.pos = pos
    state.unit = unit
  end

  function __switch.AnimationMove (path, unit)
    self:addTask('MoveAnimation', path)
    screen:clearRange()
    state.unit = unit
  end

  function __switch.AnimationAtk (pos, unit, target, enemy)
    screen:clearRange()
    state.pos = pos
    state.unit = unit
    state.target = target
  end

  --[[ Event receivers ]]-------------------------------------------------------

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
    if state.mode == 'Idle' then
      if unit then
        switchTo('SelectMove', hex, unit)
      end
    elseif state.mode == 'SelectMove' then
      self:sendEvent 'PathRequest' (state.pos, hex)
    elseif state.mode == 'SelectAtkTarget' then
      if unit and state.unit:withinAtkRange((hex - state.pos):size()) then
        switchTo('AnimationAtk', state.pos, state.unit, hex, unit)
      end
    end
  end

  function self.__accept:PathResult (path)
    if state.mode == 'SelectMove' then
      switchTo('AnimationMove', path, state.unit)
    end
  end

  function self.__accept:Cancel ()
    if state.mode == 'SelectMove' then
      switchTo('Idle')
    elseif state.mode == 'SelectAtkTarget' then
      switchTo('SelectAction', state.pos, state.unit)
    end
  end

  function self.__accept:ListMenuOption (index, option)
    if state.mode == 'SelectAction' then
      if option == "Wait" then
        switchTo('Idle')
      elseif option == "Fight" then
        switchTo('SelectAtkTarget', state.pos, state.unit)
      end
    end
  end

  --[[ Tasks ]]-----------------------------------------------------------------

  function self.__task:MoveAnimation (path)
    for i=#path-1,1,-1 do
      self:yield(10)
      local dir = path[i]-path[i+1]
      self:sendEvent 'MoveUnit' (path[i+1], dir)
    end
    switchTo('SelectAction', path[1], state.unit)
  end

end

return class:bind 'BattleUIActivity'

