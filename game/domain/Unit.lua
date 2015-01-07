
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

  local bossexpbonus = 0

  function self:getName ()
    return name
  end

  function self:getMaxHP ()
    return maxhp
  end

  function self:getMv ()
    return mv
  end

  function self:getTerrainCostFor (terrain_type)
    -- TODO derp
    return (terrain_type == 'Plains') and 1 or 2
  end

end

return oo:bind 'Unit'
