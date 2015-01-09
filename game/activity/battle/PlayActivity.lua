
local class   = require 'lux.oo.class'

local engine  = class.package 'engine'
local battle  = class.package 'activity.battle'

function battle:PlayActivity (battlefield, units)

  engine.Activity:inherit(self)

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    elseif key == ' ' then
      for _,unit in ipairs(units) do
        unit:resetSteps()
      end
    end
  end

end
