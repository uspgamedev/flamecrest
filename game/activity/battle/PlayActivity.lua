
local class   = require 'lux.oo.class'

local engine  = class.package 'engine'
local battle  = class.package 'activity.battle'

function battle:PlayActivity (battlefield, units)

  engine.Activity:inherit(self)

  function self.__accept:Load ()
    self:sendEvent "TurnStart"  (battlefield:getCurrentTeam())
  end

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    end
  end

end
