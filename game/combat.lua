
require "weaponmechanics"

local function muchfaster (attacker, defender)
  if (attacker.spd -4 >= defender.spd) then
    return "attacker", "defender"
  end
  if (defender.spd -4 >= attacker.spd)  then
    return "defender", "attacker"
  end
  return false, false
end

local function strike (attacker, defender)
  if not attacker.weapon then return end
  local dealtdamage = false
  local hit = attacker:hit()
  attackerweapon = attacker.weapon
  defenderweapon = defender.weapon
  local evade = defender:evade()
  local hitchance = hit - evade
  print("hit "..hitchance)
  local mt = attacker:mt()
  local damage = mt - defender[attacker:defattr()]
  print("damage "..damage)
  damage, hitchance = trianglebonus(damage, hitchance, attackerweapon, defenderweapon)
  print("newhit "..hitchance)
  print("newdamage "..damage)
  local rand1 = math.random(100)
  local rand2 = math.random(100)
  print("rand1 "..rand1.." rand 2 "..rand2.." avg "..((rand1+rand2)/2))
  if ((rand1 + rand2) / 2 <= hitchance) then --Double RNG as seen in the games!
    local crit = attacker:crit()
    local dodge = defender:dodge()
    local critchance = crit - dodge
    print("crit "..critchance)
    rand1 = math.random(100)
    if (rand1 <= critchance) then
      print("crits")
      damage = damage * 3
    end
    if damage > 0 then
      dealtdamage = true
      defender:takedamage(damage)
    end
  end
  print("")
  return dealtdamage
end

function combat (attacker, defender)
  local exp = 1
  local info = {
    attacker = {
      unit = attacker,
      dealtdmg = false,
      enemy = defender
    },
    defender = {
      unit = defender,
      dealtdmg = false,
      enemy = attacker
    }
  }
  info.attacker.dealtdmg = strike(attacker, defender)
  if (defender:isdead()) then
    print (defender.name.." is dead!")
    exp = killexp(attacker, defender)
    attacker:gainexp(exp)
    return
  end
  info.defender.dealtdmg = strike(defender, attacker)
  if (attacker:isdead()) then
    print (attacker.name.." is dead!")
    exp = killexp(attacker, defender)
    defender:gainexp(exp)
    return
  end
  local faster, slower = muchfaster(attacker, defender)
  if (faster) then
    print("moreattack")
    local fastdealt = strike(info[faster].unit, info[slower].unit)
    info[faster].dealtdmg = info[faster].dealtdmg or fastdealt
    print(info[faster].unit.name.." hit again! hurrah!")
    if info[slower].unit:isdead() then
      print (info[slower].unit.name.." is dead!")
      exp = killexp(info[faster].unit, info[slower].unit)
      info[faster].unit:gainexp(exp)
      return
    end
    print(info[faster].unit.name.." is successful")
  end
  for _,v in pairs(info) do
    if v.dealtdmg then
      print (v.unit.name.." dealt damage!")
      exp = combatexp(v.unit, v.enemy)
    else
      print (v.unit.name.." failed miserably!")
      exp = 1
    end
    v.unit:gainexp(exp)
  end
end


function combatexp (unit1, unit2)
  local exp = ( 31 + unit2:expbase() - unit1:expbase() )/unit1:exppower()
  exp = math.floor(exp)
  print("combat exp "..exp)
  print("")
  return exp
end

function killexp (unit1, unit2)
  local base = (unit2.lv * unit2:exppower() + unit2:expbonus()) - 
               (unit1.lv * unit1:exppower() + unit1:expbonus()) 
  local exp = combatexp(unit1, unit2) + base + 20 + unit2:bossbonus()
  exp = math.max(math.floor(exp), 1)
  print("kill exp "..exp)
  print("")
  return exp
end
