
module ("common.weaponmechanics", package.seeall)

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

function trianglehitbonus(attwpn, defwpn)
  if not weapontriangle[attwpn.weapontype] or not weapontriangle[attwpn.weapontype][defwpn.weapontype] then
    return 0
  end
  local bonus = weapontriangle[attwpn.weapontype][defwpn.weapontype]
  local hit = basebonus.hit * bonus
  return hit
end

function triangledmgbonus(attwpn, defwpn)
  if not weapontriangle[attwpn.weapontype] or not weapontriangle[attwpn.weapontype][defwpn.weapontype] then
    return 0, 0
  end
  local bonus = weapontriangle[attwpn.weapontype][defwpn.weapontype]
  local dmg = basebonus.dmg * bonus
  return dmg
end
