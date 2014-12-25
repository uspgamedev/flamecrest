
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

require 'engine.UI'
require 'engine.Activity'
require 'domain.BattleField'
require 'domain.Unit'

function class:BattleTracePathUIActivity (battlefield, UI, from, unit)

  class.Activity(self)

  --[[ Event receivers ]]-------------------------------------------------------

  function self.__accept:Load ()
    UI:find("stats"):setText(unit:getName())
    UI:find("screen"):displayRange(from:getPos())
  end

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    end
  end

  function self.__accept:TileClicked (tile)
    local path = battlefield:findPath(from:getPos(), tile:getPos())
    -- switch
  end

  function self.__accept:Cancel ()
    self:switch(class:BattleIdleUIActivity(battlefield, UI))
  end

end

return class:bind 'BattleTracePathUIActivity'

