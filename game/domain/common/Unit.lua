
local common = require 'lux.oo.class' .package 'domain.common'

function common:Unit (name, class, basespec, growthspec)

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

  function self:getStr ()
    return str
  end

  function self:getMag ()
    return mag
  end

  function self:getDef ()
    return def
  end

  function self:getRes ()
    return res
  end

  function self:getSpd ()
    return spd
  end

  function self:getSkl ()
    return skl
  end

  function self:getLck ()
    return lck
  end

  function self:getMv ()
    return mv
  end

  function self:getCon ()
    return con
  end

  function self:getTerrainCostFor (terrain_type)
    -- TODO derp
    if terrain_type == 'Plains' then
      return 1
    elseif terrain_type == 'Forest' then
      return 2
    else
      return 1337
    end
  end

  function self:hasTrait (traitname)
    return false -- TODO
  end

end
