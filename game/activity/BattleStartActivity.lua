
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'
local spec    = require 'domain.unitspec'
local hexpos  = require 'domain.hexpos'

require 'engine.UI'
require 'engine.Activity'
require 'domain.BattleField'
require 'domain.Unit'
require 'activity.BattlePlayActivity'
require 'activity.BattleIdleUIActivity'

function class:BattleStartActivity (UI)

  class.Activity(self)

  local battlefield = class:BattleField(6, 6)
  local units       = {
    class:Unit("Leeroy Jenkins", true, spec:new{}, spec:new{}),
    class:Unit("Juaum MacDude", true, spec:new{}, spec:new{})
  }

  function self.__accept:Load ()
    battlefield:putUnit(hexpos:new{1,1}, units[1])
    battlefield:putUnit(hexpos:new{5,5}, units[2])
    local screen = class:BattleScreenElement("screen", battlefield)
    local stats = class:TextElement("stats", "", 18, vec2:new{16, 16}, vec2:new{256, 20})
    UI:add(screen)
    UI:add(stats)
    screen:lookAt(3, 3)
    self:switch(class:BattlePlayActivity(battlefield, units),
                class:BattleIdleUIActivity(battlefield, UI))
  end

end

return class:bind 'BattleStartActivity'

