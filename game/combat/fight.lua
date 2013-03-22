
require "weaponmechanics"

local print           = print
local weaponmechanics = weaponmechanics
local random          = math.random
local floor           = math.floor
local max             = math.max
local pairs           = pairs

module "combat" do

  local function muchfaster (attacker, defender)
    if (attacker[1]:combatspeed() -4 >= defender[1]:combatspeed()) then
      return attacker, defender
    end
    if (defender[1]:combatspeed() -4 >= attacker[1]:combatspeed())  then
      return defender, attacker
    end
    return false, false
  end
  
  local function calculatehit(attacker, defender)
    local trianglehitbonus = weaponmechanics.trianglehitbonus(attacker[1].weapon,
								defender[1].weapon)
    local hit = attacker[1]:hit() + trianglehitbonus
    local evade = defender[1]:evade() + defender[2].avoid --TODO: Ver se unidade avua
    
    local hitchance = hit - evade
    return hitchance
  end

  local function calculatedmg(attacker, defender)
    local trianglemtbonus = weaponmechanics.triangledmgbonus(attacker[1].weapon,
							     defender[1].weapon)
    local mt = attacker[1]:mtagainst(defender[1]) + trianglemtbonus
    --TODO: Diferenciar dano fisico e magico, e ver se unidade avua
    local defense = defender[1].attributes[attacker[1]:defattr()] + defender[2].def
    
    local damage = mt - defense
    return damage
  end

  local function calculatecrit(attacker, defender)
    local crit = attacker[1]:crit()
    local dodge = defender[1]:dodge()

    -- Damage stuff
    local critchance = crit - dodge
    return critchance
  end
  
  local function strike (attacker, defender)
    if not attacker[1].weapon or not attacker[1].weapon:hasdurability() then return end
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
      defender[1]:takedamage(damage)
      attacker[1].weapon:weardown()
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
    if attacker[1]:canattackatrange(range) then
      info[attacker].dealtdmg = strike(attacker, defender)
    end
    if not defender[1]:isdead() and defender[1]:canattackatrange(range) then
      info[defender].dealtdmg = strike(defender, attacker)
    end
    if not attacker[1]:isdead() and not defender[1]:isdead() then
      local faster, slower = muchfaster(attacker, defender)
      if (faster and faster[1]:canattackatrange(range)) then
        local fastdealt = strike(info[faster].unit, info[slower].unit)
        info[faster].dealtdmg = info[faster].dealtdmg or fastdealt
      end
    end
    for _,v in pairs(info) do
      if v.dealtdmg then
        if v.enemy[1]:isdead() then
          exp = killexp(v.unit[1], v.enemy[1])
        else
          exp = combatexp(v.unit[1], v.enemy[1])
        end
      else
        exp = 1
      end
      v.unit[1]:gainexp(exp)
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
