
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

require 'engine.UI'
require 'engine.Activity'
require 'ui.BattleScreenElement'
require 'ui.TextElement'
require 'ui.ListMenuElement'
require 'ui.EnergyBarElement'
require 'domain.BattleField'
require 'domain.Unit'

local STRIKE_DURATION = 10

function class:BattleUIActivity (UI)

  class.Activity(self)

  --[[ Event receivers ]]-------------------------------------------------------

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    end
  end

  function self.__accept:ShowStrikeAnimation (strike)
    self:addTask('StrikeAnimation', strike)
  end

  --[[ Tasks ]]-----------------------------------------------------------------

  local function strikeMotion (strike)
    local dir = (strike.deftile:getPos() - strike.atktile:getPos()):toVec2()
                                                                   :normalized()
    local sprite = UI:find("screen"):getSprite(strike.atk)
    local pos = UI:find("screen"):hexposToScreen(strike.deftile:getPos())
    pos:add(vec2:new{-32, -64})
    local bar = class:EnergyBarElement("lifebar", pos, vec2:new{64,8})
    UI:add(bar)
    self:yield(20)
    for i=1,STRIKE_DURATION do
      local d = 1 - math.abs(i - STRIKE_DURATION)/STRIKE_DURATION
      sprite:setOffset(24*(d^3)*dir)
      self:yield()
    end
    self:addTask('HitSplash', strike, pos)
    self:yield(15)
    for i=STRIKE_DURATION+1,STRIKE_DURATION*2 do
      local d = 1 - math.abs(i - STRIKE_DURATION)/STRIKE_DURATION
      sprite:setOffset(24*(d^3)*dir)
      self:yield()
    end
    UI:remove(bar)
  end

  function self.__task:HitSplash (strike, pos)
    pos = pos - vec2:new{0, 16}
    local splash
    if strike.hit then
      splash = class:TextElement("splash", "-"..strike.damage, 18, pos, vec2:new{64, 20})
    else
      splash = class:TextElement("splash", "Miss!", 18, pos, vec2:new{64, 20})
    end
    UI:add(splash)
    for i=1,20 do
      splash:setPos(pos + vec2:new{0, -i})
      self:yield()
    end
    UI:remove(splash)
  end

  function self.__task:StrikeAnimation (strike)
    strikeMotion(strike)
    self:sendEvent 'StrikeAnimationFinished' ()
  end

end

return class:bind 'BattleUIActivity'

