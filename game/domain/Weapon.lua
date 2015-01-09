
local domain = require 'lux.oo.class' .package 'domain'

local weapontypenames = {
  sword = true,
  lance = true,
  axe = true,
  bow = true,
  light = true,
  dark = true,
  fire = true,
  thunder = true,
  wind = true,
  staff = true
}

local physicaltypes = {
  sword = "lance",
  lance = "axe",
  axe = "bow",
  bow = "light"
}

local magicaltypes = {
  light = "dark",
  dark = "fire",
  fire = "thunder",
  thunder = "wind",
  wind = "sword"
}

local weapontriangle = {
   sword = {
     axe = 1,
     lance = -1
   },
   axe = {
     lance = 1,
     sword = -1
   },
   lance = {
     sword = 1,
     axe = -1
   },
   dark = {
     wind = 1,
     thunder = 1,
     fire = 1,
     light = -1
   },
   light = {
     dark = 1,
     wind = -1,
     thunder = -1,
     fire = -1
   },
   wind = {
     light = 1,
     thunder = 1,
     fire  = -1
   },
   thunder = {
     light = 1,
     fire = 1,
     wind = -1
   },
   fire = {
     light = 1,
     wind = 1,
     thunder = -1
   }
}

local basebonus = {
  dmg = 1,
  hit = 15
}

function domain:Weapon (name, weaponspec)

  local mt        = weaponspec.mt
  local hit       = weaponspec.hit
  local wgt       = weaponspec.wgt
  local crt       = weaponspec.crt
  local maxdur    = weaponspec.maxdur
  local typename  = weaponspec.typename
  local minrange  = weaponspec.minrange
  local maxrange  = weaponspec.maxrange

  local atkattr   = weaponspec.atkattr
  local defattr   = weaponspec.defattr
  local useexp    = weaponspec.useexpr

  local bonusagainst = weaponspec.bonusagainst

  local dur = maxdur

  function self:getMt ()
    return mt
  end

  function self:getHit ()
    return hit
  end

  function self:getWgt ()
    return wgt
  end

  function self:getCrt ()
    return crt
  end

  function self:getTypeName ()
    return typename
  end

  function self:getMinRange ()
    return minrange
  end

  function self:getMaxRange ()
    return maxrange
  end

  function self:getAtkAttr ()
    return atkattr
  end

  function self:getDefAttr ()
    return defattr
  end

  function self:hasDurability ()
    return dur > 0
  end

  function self:wearDown ()
    dur = math.max(0, dur-1)
  end

  function self:getMtAgainst (defender)
    local value = mt
    for _,v in pairs(bonusagainst) do
      if defender:hasTrait(v) then
        value = 2 * value
      end
    end
    return value
  end

  function self:triangleHitBonus (another)
    local bonus = 0
    if not weapontriangle[typename] then
      bonus = weapontriangle[typename][another:getTypeName()] or 0
    end
    return basebonus.hit * bonus
  end

  function self:triangleDmgBonus (another)
    local bonus = 0
    if not weapontriangle[typename] then
      bonus = weapontriangle[typename][another:getTypeName()] or 0
    end
    return basebonus.dmg * bonus
  end

end
