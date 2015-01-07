
local class = require 'lux.oo.class'

function class:UnitState (unit)

  local hp = unit:getMaxHP()
  local steps = 0

  local weapon
  local rescuedunit

  function self:getUnit ()
    return unit
  end

  function self:getName ()
    return unit:getName()
  end

  function self:takeDamage (amount)
    hp = math.max(0, hp - amount)
  end

  function self:isDead ()
    return hp <= 0
  end

  function self:getMv ()
    return unit:getMv()
  end

  function self:getStepsLeft ()
    return unit:getMv() - steps
  end

  function self:getTerrainCostFor (terrain_type)
    return unit:getTerrainCostFor (terrain_type)
  end

  function self:step (terrain_type)
    local n = unit:getTerrainCostFor(terrain_type)
    assert(steps + n <= unit:getMv())
    steps = steps + n
  end

  function self:resetSteps ()
    steps = 0
  end

  function self:getWeapon ()
    return weapon
  end

  function self:getAtkRange ()
    if not weapon then
      return 1, 1
    else
      return weapon:getMinRange(), weapon:getMaxRange()
    end
  end

  function self:withinAtkRange (range)
    local minrange, maxrange = self:getAtkRange()
    return range >= minrange and range <= maxrange
  end

end

return class:bind 'UnitState'
