
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

  local weapon

  local bossexpbonus = 0
  local rescuedunit

  function self:getName ()
    return name
  end

end

return oo:bind 'Unit'
