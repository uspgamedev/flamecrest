
local class = require 'lux.oo.class'

function class:Combat (attacker, defender)

  local function muchFaster ()
    return nil, nil
  end

  local function calculatehit(atk, def)
    local trianglehitbonus = atk.unit:getWeapon()
                                     :triangleHitBonus(def.unit:getWeapon())
    local hit = atk.unit:getHit() + trianglehitbonus
    --TODO: Ver se unidade avua
    local evade = def.unit:getEvade() + def.tile:getAvoid()

    local hitchance = hit - evade
    return hitchance
  end

  local function calculatedmg(atk, def)
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

  local function calculatecrit(atk, def)
    local crit = atk.unit:getCrit()
    local dodge = def.unit:getDodge()

    -- Damage stuff
    local critchance = crit - dodge
    return critchance
  end

  local function strike (atk, def)
    local result = {
      atk = atk.unit,
      def = def.unit
    }
    if atk.unit:getWeapon() and atk.unit:getWeapon():hasDurability() then
      local hitchance   = calculatehit(atk, def)
      local damage      = calculatedmg(atk, def)
      local critchance  = calculatecrit(atk, def)

      local random = love.math.random
      local rand1 = random(100)
      local rand2 = random(100)
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
    local info = {
      [attacker] = {
        unit = attacker,
        dealtdmg = false,
        enemy = defender
      },
      [defender] = {
        unit = defender,
        dealtdmg = false,
        enemy = attacker
      }
    }
    local strike_result
    if attacker.unit:withinAtkRange(range) then
      table.insert(log, strike(attacker, defender))
    end
    if not defender.unit:isDead() and defender.unit:withinAtkRange(range) then
      table.insert(log, strike(defender, attacker))
    end
    if not attacker.unit:isDead() and not defender.unit:isDead() then
      local faster, slower = muchFaster()
      if (faster and faster.unit:withinAtkRange(range)) then
        table.insert(log, strike(faster.unit, slower.unit))
      end
    end
    -- One could generate the infotable from the log. That one is not me.
    log.deaths = {}
    log.exp    = {}
    --[[
    for _,v in pairs(info) do
      if v.dealtdmg then
        if v.enemy.unit:isdead() then
          exp = killexp(v.unit.unit, v.enemy.unit)
          table.insert(log.deaths, v.enemy.unit)
        else
          exp = combatexp(v.unit.unit, v.enemy.unit)
        end
      else
        exp = 1
      end
      v.unit.unit:gainexp(exp)
      if not v.unit.unit:isdead() then
        log.exp[v.unit.unit] = exp
      end
    end
    ]]
    return log
  end

end

return class:bind 'Combat'
