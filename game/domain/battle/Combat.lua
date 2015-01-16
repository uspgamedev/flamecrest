
local class = require 'lux.oo.class'

local battle = class.package 'domain.battle'

function battle:Combat (attacker, defender)

  local function muchFaster ()
    if (attacker.unit:getCombatSpeed() -4 >= defender.unit:getCombatSpeed()) then
      return attacker, defender
    end
    if (defender.unit:getCombatSpeed() -4 >= attacker.unit:getCombatSpeed())  then
      return defender, attacker
    end
    return false, false
  end

  local function calculatehHit(atk, def)
    local trianglehitbonus = atk.unit:getWeapon()
                                     :triangleHitBonus(def.unit:getWeapon())
    local hit = atk.unit:getHit() + trianglehitbonus
    --TODO: Ver se unidade avua
    local evade = def.unit:getEvade() + def.tile:getAvoid()

    local hitchance = hit - evade
    return hitchance
  end

  local function calculateDmg(atk, def)
    local trianglemtbonus = atk.unit:getWeapon()
                                    :triangleDmgBonus(def.unit:getWeapon())
    local mt = atk.unit:getMtAgainst(def.unit) + trianglemtbonus
    --TODO: Diferenciar dano fisico e magico, e ver se unidade avua
    local defense =
      def.unit['get'..atk.unit:getDefAttr()](def.unit)
      +
      def.tile:getDef()

    local damage = mt - defense
    return damage
  end

  local function calculateCrit(atk, def)
    local crit = atk.unit:getCrit()
    local dodge = def.unit:getDodge()

    -- Damage stuff
    local critchance = crit - dodge
    return critchance
  end

  local function strike (atk, def)
    local result = {
      atk = atk.unit,
      def = def.unit,
      atktile = atk.tile,
      deftile = def.tile
    }
    if atk.unit:getWeapon() and atk.unit:getWeapon():hasDurability() then
      local hitchance   = calculatehHit(atk, def)
      local damage      = calculateDmg(atk, def)
      local critchance  = calculateCrit(atk, def)

      local random = love.math.random
      local rand1 = random(100)
      local rand2 = random(100)
      result.hpbefore = def.unit:getHP()
      if ((rand1 + rand2) / 2 <= hitchance) then --Double RNG as seen in the games
        result.hit = true
        rand1 = random(100)
        if (rand1 <= critchance) then
          damage = damage * 3
          result.critical = true
        end
        def.unit:takeDamage(damage)
        result.damage = damage
        atk.unit:getWeapon():wearDown()
      end
    end
    return result
  end

  function self:fight ()
    local range = (attacker.tile:getPos() - defender.tile:getPos()):size()
    local exp = 1
    local log = {}
    -- First strike
    if attacker.unit:withinAtkRange(range) then
      table.insert(log, strike(attacker, defender))
    end
    -- Counter strike
    if not defender.unit:isDead() and defender.unit:withinAtkRange(range) then
      table.insert(log, strike(defender, attacker))
    end
    -- Repeat a strike if much faster
    if not attacker.unit:isDead() and not defender.unit:isDead() then
      local faster, slower = muchFaster()
      if (faster and faster.unit:withinAtkRange(range)) then
        table.insert(log, strike(faster, slower))
      end
    end
    -- Count exp
    --[[
    log.exp = {}
    for _,strike in ipairs(log) do
      local exp
      if strike.damage > 0 then
        if strike.def:isDead() then
          exp = killExp(strike.atk, strike.def)
        else
          exp = combatExp(strike.atk, strike.def)
        end
      else
        exp = 1
      end
      if strike.atk:isAlive() then
        log.exp[strike.atk] = log.exp[strike.atk] + exp
      end
    end
    attacker.unit:gainExp(log.exp[attacker.unit])
    defender.unit:gainExp(log.exp[defender.unit])
    ]]
    --log.deaths = {}
    --table.insert(log.deaths, strike.def)
    return log
  end

  function self:cleanDead ()
    if attacker.unit:isDead() then
      attacker.tile:setUnit(nil)
    end
    if defender.unit:isDead() then
      defender.tile:setUnit(nil)
    end
  end

end
