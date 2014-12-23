
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
    unitname:setText(unit and unit:getName() or "")
    screen:displayRange(hex)
  end

end

return class:bind 'BattleUIActivity'

