
require "lux.object"

weapon = lux.object.new {
  mt = 5,
  hit = 60,
  wgt = 3,
  crt = 0,
  durability = nil,
  maxdurability = 40,
  weapontype = "sword",
  atkattribute = "str",
  defattribute = "def",
  bonusagainst = nil,
  useexp = nil, --for staves
  minrange = 1,
  maxrange = 1,
  weapontypelist = {
    "sword", "lance", "axe", "bow",
    "light", "dark", "fire", "thunder", "wind",
    "staff"
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

function weapon:__init ()
  self.durability = self.maxdurability
end

function weapon:hasdurability ()
  print("Current weapon durability = "..self.durability)
  return self.durability > 0
end

function weapon:weardown ()
  print("Wearing weapon down")
  if self.durability > 0 then
    self.durability = self.durability - 1
  end
  print("Current weapon durability = "..self.durability)
end

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

