
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

require 'engine.UI'
require 'engine.Activity'
require 'ui.BattleScreenElement'
require 'ui.TextElement'
require 'domain.BattleField'
require 'domain.Unit'

function class:BattleUIActivity (UI)

  class.Activity(self)

  local screen = nil
  local unitname = nil
  local state

  function self.__accept:BattleFieldCreated (battlefield)
    screen = class:BattleScreenElement(battlefield)
    UI:add(screen)
    screen:lookAt(3, 3)
    unitname = class:TextElement("", 18, vec2:new{16, 16}, vec2:new{256, 20})
    UI:add(unitname)
  end

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    end
  end

  function self.__accept:TileClicked (hex, tile)
    local unit = tile:getUnit()
    if not state then
      if unit then
        unitname:setText(unit:getName())
        screen:displayRange(hex)
        state = { mode = 'selected', pos = hex, unit = unit }
      end
    elseif state.mode == 'selected' then
      self:sendEvent 'UnitMoveRequest' (state.pos, hex)
    end
  end

  function self.__accept:UnitMoveFinished (path)
    if state and state.mode == 'selected' then
      print(unpack(path))
      unitname:setText("")
      screen:clearRange()
      state = nil
    end
  end

  function self.__accept:Cancel ()
    if state and state.mode == 'selected' then
      unitname:setText("")
      screen:clearRange()
      state = nil
    end
  end

end

return class:bind 'BattleUIActivity'

