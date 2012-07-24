
require "nova.object"

weapon = nova.object:new {
  mt = 5,
  hit = 60,
  wgt = 3,
  crt = 0,
  weapontype = "sword",
  atkattribute = "str",
  defattribute = "def",
  weapontypelist = {
    "sword", "lance", "axe", "bow",
    "light", "dark", "fire", "thunder", "wind"
  }
}

weapon.weapontypenum = #weapon.weapontypelist

local physicaltypes = {
  sword = true,
  axe = true,
  lance = true,
  bow = true
}

local magicaltypes = {
  light = true,
  dark = true,
  fire = true,
  thunder = true,
  wind = true
}

function weapon:setweapontype (weapontype)
  if physicaltypes[weapontype] then
    self.atkattribute = "str"
    self.atkattribute = "def"
  elseif magicaltypes[weapontype] then
    self.atkattribute = "mag"
    self.defattribute = "res"
  else return end
  self.weapontype = weapontype
end

