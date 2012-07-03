
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
  hitbonus = 80
  hit = 2 * attacker.skl + attacker.lck + hitbonus
  evade = 2 * defender.spd + defender.lck
  hitchance = hit - evade
  print("hit "..hitchance)
  damage = attacker.str - defender.def
  print("damage "..damage)
  rand1 = math.random(100)
  rand2 = math.random(100)
  print("rand1 "..rand1.." rand 2 "..rand2.." avg "..((rand1+rand2)/2))
  if ((rand1 + rand2) / 2 <= hitchance) then --Double RNG as seen in the games!
    crit = attacker.skl / 2
    dodge = defender.lck
    critchance = crit - dodge
    print("crit "..critchance)
    rand1 = math.random(100)
    if (rand1 <= critchance) then
      print("crits")
      damage = damage * 3
    end
    defender:takedamage(damage)
  end
  print("")
end

function combat (attacker, defender)
  strike(attacker, defender)
  if (defender:isdead()) then
    return
  end
  strike(defender, attacker)
  if (attacker:isdead()) then
    return
  end
  faster, slower = muchfaster(attacker, defender)
  if (faster) then
    print("moreattack")
    strike(faster, slower)
  end
end

