
local oo = require 'lux.oo.class'

function oo:Unit (name, class, basespec, growthspec)

  assert(name)
  assert(class)
  assert(basespec)
  assert(growthspec)

  local maxhp = basespec.maxhp
  local str   = basespec.str
  local mag   = basespec.mag
  local def   = basespec.def
  local res   = basespec.res
  local spd   = basespec.spd
  local skl   = basespec.skl
  local lck   = basespec.lck
  local mv    = basespec.mv
  local con   = basespec.con

  local lv    = 1
  local exp   = 0
  local hp    = maxhp
  local steps = 0

  local weapon

  local bossexpbonus = 0
  local rescuedunit

  function self:getName ()
    return name
  end

  function self:getMv ()
    return mv
  end

  function self:getStepsLeft ()
    return mv - steps
  end

  function self:getTerrainCostFor (terrain_type)
    -- TODO derp
    return (terrain_type == 'Plains') and 1 or 2
  end

  function self:step (terrain_type)
    local n = self:getTerrainCostFor(terrain_type)
    assert(steps + n <= mv)
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
      return 0, 0
    else
      return weapon:getMinRange(), weapon:getMaxRange()
    end
  end

end

return oo:bind 'Unit'
