
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

require 'engine.UI'
require 'engine.Activity'
require 'domain.BattleField'
require 'domain.Unit'
require 'activity.BattleTracePathUIActivity'

function class:BattleIdleUIActivity (battlefield, UI)

  class.Activity(self)

  --[[ Event receivers ]]-------------------------------------------------------

  function self.__accept:Load ()
    UI:remove("action_menu")
    UI:find("stats"):setText("")
    UI:find("screen"):clearRange()
  end

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    end
  end

  function self.__accept:TileClicked (tile)
    local unit = tile:getUnit()
    if unit then
      self:switch(class:BattleTracePathUIActivity(battlefield, UI, tile, unit))
    end
  end

end

return class:bind 'BattleIdleUIActivity'

