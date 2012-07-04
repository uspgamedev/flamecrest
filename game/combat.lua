
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

