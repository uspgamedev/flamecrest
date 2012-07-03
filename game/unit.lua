
local attributes = { "str", "def", "spd", "skl", "lck", "maxhp" }

unit = {
  name = "Unit",
  lv = 1,
  exp = 0,
  str = 10,
  def = 10,
  spd = 10,
  skl = 10,
  lck = 10,
  hp = 16,
  maxhp = 16,
  growths = {
    str = 20,
    def = 20,
    spd = 20,
    skl = 20,
    lck = 20,
    maxhp = 50
  },
  caps = {
    str = 20,
    def = 20,
    spd = 20,
    skl = 20,
    lck = 20,
    maxhp = 40
  }
}

function unit:new (newguy)
  newguy = newguy or {}
  self.__index = self --da fuq
  setmetatable(newguy, self) --da fuq 2
  -- TODO F*CKING REMOVE FROM HERE
  if newguy.maxhp then
    newguy.hp = newguy.maxhp
  end
  return newguy
end

function unit:takedamage (dmg)
  self.hp = self.hp - dmg
  if self.hp < 0 then
    self.hp = 0
  end
end

function unit:gainexp (exp)
  if self.lv < 20 then
    self.exp = self.exp + exp
    while self.exp >= 100 do
      self:lvup()
      self.exp = self.exp - 100
    end
    if self.lv == 20 then
      self.exp = 0
    end
  end
end

function unit:lvup ()
  self.lv = self.lv + 1
  for _,attr in ipairs(attributes) do
    if self[attr] < self.caps[attr] then
      rand = math.random(100)
      growth = self.growths[attr]
      print("Attribute:", attr, growth, rand)
      while rand <= growth do
        self[attr] = self[attr] + 1
        growth = growth - 100
      end
    end
  end
  print("")
end

function unit:isdead ()
  return self.hp <= 0
end

function unit:draw ()
  love.graphics.print("name: "..self.name, 0, 0)
  love.graphics.print("lv: "..self.lv, 0, 20)
  love.graphics.print("exp: "..self.exp, 0, 40)
  love.graphics.print("hp: "..self.hp.."/"..self.maxhp, 0, 60)
  love.graphics.print("str: "..self.str, 0, 80)
  love.graphics.print("def: "..self.def, 0, 100)
  love.graphics.print("spd: "..self.spd, 0, 120)
  love.graphics.print("skl: "..self.skl, 0, 140)
  love.graphics.print("lck: "..self.lck, 0, 160)
end

