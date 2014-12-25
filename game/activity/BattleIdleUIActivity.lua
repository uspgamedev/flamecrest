
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

require 'engine.UI'
require 'engine.Activity'
require 'ui.BattleScreenElement'
require 'ui.TextElement'
require 'ui.ListMenuElement'
require 'domain.BattleField'
require 'domain.Unit'

function class:BattleIdleUIActivity (battlefield, UI)

  class.Activity(self)

  UI:remove("action_menu")
  UI:find("stats"):setText("")
  UI:find("screen"):clearRange()

  --[[ Event receivers ]]-------------------------------------------------------

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    end
  end

  function self.__accept:TileClicked (hex, tile)
    local unit = tile:getUnit()
    if unit then
      --switch('SelectMove', hex, unit)
    end
  end

end

return class:bind 'BattleIdleUIActivity'

