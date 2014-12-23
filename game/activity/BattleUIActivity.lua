
local class   = require 'lux.oo.class'

require 'engine.UI'
require 'engine.Activity'
require 'ui.BattleScreenElement'
require 'domain.BattleField'
require 'domain.Unit'

function class:BattleUIActivity (UI)

  class.Activity(self)

  local screen = nil

  function self.__accept:BattleFieldCreated (battlefield)
    screen = class:BattleScreenElement(battlefield)
    UI:add(screen)
    screen:lookAt(3, 3)
  end

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:raiseEvent 'Halt' ()
      self:finish()
    end
  end

end

return class:bind 'BattleUIActivity'

