
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
  sword = "lance",
  lance = "axe",
  axe = "bow",
  bow = "light"
}

local magicaltypes = {
  light = "dark",
  dark = "fire",
  fire = "thunder",
  thunder = "wind",
  wind = "sword"
}

function weapon:setweapontype (weapontype)
  if physicaltypes[weapontype] then
    self.atkattribute = "str"
    self.defattribute = "def"
  elseif magicaltypes[weapontype] then
    self.atkattribute = "mag"
    self.defattribute = "res"
  else return end
  self.weapontype = weapontype
end

function weapon:nexttype ()
  local newtype =
    physicaltypes[self.weapontype] or magicaltypes[self.weapontype]
  self:setweapontype(newtype)
end

