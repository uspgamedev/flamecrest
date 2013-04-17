
require "weaponmechanics"

local print           = print
local weaponmechanics = weaponmechanics
local random          = math.random
local floor           = math.floor
local max             = math.max
local pairs           = pairs

module "combat" do

  local function muchfaster (attacker, defender)
    if (attacker.unit:combatspeed() -4 >= defender.unit:combatspeed()) then
      return attacker, defender
    end
    if (defender.unit:combatspeed() -4 >= attacker.unit:combatspeed())  then
      return defender, attacker
    end
    return false, false
  end
  
  local function calculatehit(attacker, defender)
    local trianglehitbonus = weaponmechanics.trianglehitbonus(attacker.unit.weapon,
								defender.unit.weapon)
    local hit = attacker.unit:hit() + trianglehitbonus
    local evade = defender.unit:evade() + defender.terraininfo.avoid --TODO: Ver se unidade avua
    
    local hitchance = hit - evade
    return hitchance
  end

  local function calculatedmg(attacker, defender)
    local trianglemtbonus = weaponmechanics.triangledmgbonus(attacker.unit.weapon,
							     defender.unit.weapon)
    local mt = attacker.unit:mtagainst(defender.unit) + trianglemtbonus
    --TODO: Diferenciar dano fisico e magico, e ver se unidade avua
    local defense = defender.unit.attributes[attacker.unit:defattr()] + defender.terraininfo.def
    
    local damage = mt - defense
    return damage
  end

  local function calculatecrit(attacker, defender)
    local crit = attacker.unit:crit()
    local dodge = defender.unit:dodge()

    -- Damage stuff
    local critchance = crit - dodge
    return critchance
  end
  
  local function strike (attacker, defender)
    if not attacker.unit.weapon or not attacker.unit.weapon:hasdurability() then return end
    local dealtdamage = false

    local damage = calculatedmg(attacker, defender)
    local hitchance = calculatehit(attacker, defender)
    local critchance = calculatecrit(attacker, defender)

    local rand1 = random(100)
    local rand2 = random(100)
    if ((rand1 + rand2) / 2 <= hitchance) then --Double RNG as seen in the games!
      rand1 = random(100)
      if (rand1 <= critchance) then
        damage = damage * 3
      end
      dealtdamage = damage > 0
      defender.unit:takedamage(damage)
      attacker.unit.weapon:weardown()
    end
    return dealtdamage
  end

  function fight (attacker, defender, range)
    local exp = 1
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
    if attacker.unit:canattackatrange(range) then
      info[attacker].dealtdmg = strike(attacker, defender)
    end
    if not defender.unit:isdead() and defender.unit:canattackatrange(range) then
      info[defender].dealtdmg = strike(defender, attacker)
    end
    if not attacker.unit:isdead() and not defender.unit:isdead() then
      local faster, slower = muchfaster(attacker, defender)
      if (faster and faster.unit:canattackatrange(range)) then
        local fastdealt = strike(info[faster].unit, info[slower].unit)
        info[faster].dealtdmg = info[faster].dealtdmg or fastdealt
      end
    end
    for _,v in pairs(info) do
      if v.dealtdmg then
        if v.enemy.unit:isdead() then
          exp = killexp(v.unit.unit, v.enemy.unit)
        else
          exp = combatexp(v.unit.unit, v.enemy.unit)
        end
      else
        exp = 1
      end
      v.unit.unit:gainexp(exp)
    end
  end


  function combatexp (unit1, unit2)
    local exp = ( 31 + unit2:expbase() - unit1:expbase() )/unit1:exppower()
    exp = floor(exp)
    return exp
  end

  function killexp (unit1, unit2)
    local base = (unit2.lv * unit2:exppower() + unit2:expbonus()) - 
                 (unit1.lv * unit1:exppower() + unit1:expbonus()) 
    local exp = combatexp(unit1, unit2) + base + 20 + unit2:bossbonus()
    exp = max(floor(exp), 1)
    return exp
  end

end
