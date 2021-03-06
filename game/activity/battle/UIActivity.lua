
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

local engine  = class.package 'engine'
local ui      = class.package 'ui'
local battle  = class.package 'activity.battle'

local STRIKE_DURATION = 10

function battle:UIActivity (UI)

  engine.Activity:inherit(self)

  --[[ Event receivers ]]-------------------------------------------------------

  function self.__accept:KeyPressed (key)
    if key == 'escape' then
      self:finish()
    end
  end

  function self.__accept:ShowStrikeAnimation (strike)
    self:addTask('StrikeAnimation', strike)
  end

  function self.__accept:TurnStart (team)
    self:addTask("TurnAnimation", team)
  end

  function self.__accept:BattleOver (winner)
    local message = ui.TextElement('message', "", 48, nil, nil, 'center')
    UI:add(message)
    message:setPos(love.window.getWidth()/2 - 256, 300)
    message:setSize(512, 64)
    message:setText(winner:getName().." wins!")
  end

  --[[ Tasks ]]-----------------------------------------------------------------

  function self.__task:TurnAnimation (team)
    local message = ui.TextElement('message', "", 48, nil, nil, 'center')
    local x, y = 64, 16
    self:yield(5)
    UI:add(message)
    message:setSize(512, 64)
    message:setText(string.format("%s's Turn", team:getName()))
    for i=1,64 do
      message:setPos(x + 6*(i-1), y)
      self:yield()
    end
    UI:remove(message)
  end

  local function strikeDir (strike)
    return
      (strike.deftile:getPos() - strike.atktile:getPos()):toVec2():normalized()
  end

  local function infoSpot (strike)
    local offset = vec2:new{-32, -64}
    return UI:find("screen"):hexposToScreen(strike.deftile:getPos()) + offset
  end

  local function hitSplash (strike, pos, hpbar, hp, damage)
    pos = pos - vec2:new{0, 16}
    local msg
    if strike.hit then
      msg = "-"..strike.damage
    else
      msg = "Miss!"
    end
    local splash = ui.TextElement("splash", msg, 18, pos, vec2:new{64, 20})
    UI:add(splash)
    for i=1,20 do
      splash:setPos(pos + vec2:new{0, -i})
      hpbar:setValue((strike.hpbefore - damage*(i/20))/strike.def:getMaxHP())
      self:yield()
    end
    UI:remove(splash)
  end

  function self.__task:StrikeAnimation (strike)
    local sprite  = UI:find("screen"):getSprite(strike.atk)
    local dir     = strikeDir(strike)
    local pos     = infoSpot(strike)
    local hpbar   = ui.EnergyBarElement("hpbar", pos, vec2:new{64,8})
    local hp      = strike.def:getHP()
    local damage  = strike.damage or 0
    -- Show HP bar with life before damage
    UI:add(hpbar)
    hpbar:setValue(strike.hpbefore/strike.def:getMaxHP())
    self:yield(20)
    -- Forward motion
    for i=1,STRIKE_DURATION do
      local d = i/STRIKE_DURATION
      sprite:setOffset(24*(d^3)*dir)
      self:yield()
    end
    -- Show hit splash
    hitSplash(strike, pos, hpbar, hp, damage)
    -- Backward motion
    for i=1,STRIKE_DURATION do
      local d = 1 - i/STRIKE_DURATION
      sprite:setOffset(24*(d^3)*dir)
      self:yield()
    end
    --- Clean up
    UI:remove(hpbar)
    self:sendEvent 'StrikeAnimationFinished' ()
  end

end
