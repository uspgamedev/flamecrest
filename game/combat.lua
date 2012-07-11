
local function muchfaster (unit1, unit2)
  if (unit1.spd -4 >= unit2.spd) then
    return unit1, unit2
  end
  if (unit2.spd -4 >= unit1.spd)  then
    return unit2, unit1
  end
  return false, false
end

local function strike (attacker, defender)
  if not attacker.weapon then return end
  local dealtdamage = false
  local hit = attacker:hit()
  local evade = defender:evade()
  local hitchance = hit - evade
  print("hit "..hitchance)
  local mt = attacker:mt()
  local damage = mt - defender[attacker:defattr()]
  print("damage "..damage)
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
  local attdmg = strike(attacker, defender)
  if (defender:isdead()) then
    print (defender.name.." is dead!")
    exp = killexp(attacker, defender)
    attacker:gainexp(exp)
    return
  end
  local defdmg = strike(defender, attacker)
  if (attacker:isdead()) then
    print (attacker.name.." is dead!")
    exp = killexp(attacker, defender)
    defender:gainexp(exp)
    return
  end
  local faster, slower = muchfaster(attacker, defender)
  if (faster) then
    print("moreattack")
    local fastdmg = strike(faster, slower)
    print(faster.name.." hit again! hurrah!")
    if slower:isdead() then
      print (slower.name.." is dead!")
      exp = killexp(attacker, defender)
      faster:gainexp(exp)
      return
    end
    if faster == attacker then
      print(attacker.name.." is successful")
      attdmg = attdmg or fastdmg
    else
      print(defender.name.." is successful")
      defdmg = defdmg or fastdmg
    end
  end
  if attdmg then
    print (attacker.name.." dealt damage!")
    exp = combatexp(attacker, defender)
  else
    print (attacker.name.." failed miserably!")
    exp = 1
  end
  attacker:gainexp(exp)
  if defdmg then
    print (defender.name.." dealt damage!")
    exp = combatexp(defender, attacker)
  else
    print (defender.name.." failed miserably!")
    exp = 1
  end
  defender:gainexp(exp)
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
  exp = math.floor(exp)
  print("kill exp "..exp)
  print("")
  return exp
end
