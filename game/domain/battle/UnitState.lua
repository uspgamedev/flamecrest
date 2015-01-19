
local battle = require 'lux.oo.class' .package 'domain.battle'

function battle:UnitState (unit, team)

  assert(unit and team)
  local hp = unit:getMaxHP()
  local steps = 0
  local used  = false

  local rescuedunit

  -- Unit attribute getters

  function self:getUnit ()
    return unit
  end

  function self:getClass ()
    return unit:getClass()
  end

  function self:getTeam ()
    return team
  end

  function self:getName ()
    return unit:getName()
  end

  function self:getLv ()
    return unit:getLv()
  end

  function self:isAlive ()
    return hp > 0
  end

  function self:isDead ()
    return hp <= 0
  end

  function self:getHP ()
    return hp
  end

  function self:getMaxHP ()
    return unit:getMaxHP()
  end

  function self:getStr ()
    return unit:getStr()
  end

  function self:getMag ()
    return unit:getMag()
  end

  function self:getDef ()
    return unit:getDef()
  end

  function self:getRes ()
    return unit:getRes()
  end

  function self:getSpd ()
    local speed = unit:getSpd()
    if rescuedunit then
      speed = math.ceil(speed/2)
    end
    return speed
  end

  function self:getSkl ()
    local skill = unit:getSkl()
    if rescuedunit then
      skill = math.ceil(skill/2)
    end
    return skill
  end

  function self:getLck ()
    return unit:getLck()
  end

  function self:getMv ()
    return unit:getMv()
  end

  function self:getCon ()
    return unit:getCon()
  end

  -- Common stuff

  function self:takeDamage (amount)
    hp = math.max(0, hp - amount)
  end

  function self:isDead ()
    return hp <= 0
  end

  function self:use ()
    used = true
  end

  function self:isUsed ()
    return used
  end

  function self:getStepsLeft ()
    return self:getMv() - steps
  end

  function self:getTerrainCostFor (terrain_type)
    return unit:getTerrainCostFor (terrain_type)
  end

  function self:step (terrain_type)
    local n = unit:getTerrainCostFor(terrain_type)
    assert(steps + n <= unit:getMv())
    steps = steps + n
  end

  function self:resetAction ()
    steps = 0
    used  = false
  end

  -- Weapon stuff

  function self:addItem (item)
    return unit:addItem(item)
  end

  function self:getWeapon ()
    return unit:getItem(1)
  end

  function self:setWeapon (idx)
    return unit:equipItem(idx)
  end

  function self:getAtkRange ()
    local weapon = self:getWeapon()
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

  function self:getAtkAttr ()
    local weapon = self:getWeapon()
    return weapon and weapon:getAtkAttr() or 'Str'
  end

  function self:getDefAttr ()
    local weapon = self:getWeapon()
    return weapon and weapon:getDefAttr() or 'Def'
  end

  function self:getMtAgainst (other)
    local weapon = self:getWeapon()
    local base_atk = self['get'..self:getAtkAttr()](self)
    return base_atk + (weapon and weapon:getMtAgainst(other) or 0)
  end

  -- Combat stats

  function self:getHit ()
    local weapon = self:getWeapon()
    return 2 * self:getSkl() + self:getLck() + (weapon and weapon:getHit() or 0)
  end

  function self:getCombatSpeed ()
    local weapon = self:getWeapon()
    local weapon_wgt = weapon and weapon:getWgt() or 0
    local wgtmod = math.floor(math.max(
      0, weapon_wgt - (self:getStr() + self:getCon())/2
    ))
    local cspeed = self:getSpd() - wgtmod
    return cspeed
  end

  function self:getEvade ()
    return 2 * self:getCombatSpeed() + self:getLck()
  end

  function self:getCrit ()
    local weapon = self:getWeapon()
    return self:getSkl()/2 + (weapon and weapon:getCrt() or 0)
  end

  function self:getDodge ()
    return self:getLck()
  end

end
