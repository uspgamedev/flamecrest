unit = {
  name = "Soldier",
  str = 10,
  def = 10,
  spd = 10,
  skl = 10,
  lck = 10,
  hp = 16
}

function unit:new (newguy)
  newguy = newguy or {}
  self.__index = self --da fuq
  setmetatable(newguy, self) --da fuq 2
  return newguy
end

function unit:takedamage (dmg)
  self.hp = self.hp - dmg
  if self.hp < 0 then
    self.hp = 0
  end
end

function unit:isdead ()
  return self.hp <= 0
end