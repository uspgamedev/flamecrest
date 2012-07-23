
require "nova.object"

local attributes = { "maxhp", "str", "mag", "def", "res", "spd", "skl", "lck" }

unit = nova.object:new {
  name = "Unit",
  lv = 1,
  exp = 0,
  hp = 16,
  maxhp = 16,
  str = 10,
  mag = 10,
  def = 10,
  res = 10,
  spd = 10,
  skl = 10,
  lck = 10,
  con = 8, 
  growths = {
    str = 20,
    mag = 20,
    def = 20,
    res = 20,
    spd = 20,
    skl = 20,
    lck = 20,
    maxhp = 50
  },
  caps = {
    str = 20,
    mag = 20,
    def = 20,
    res = 20,
    spd = 20,
    skl = 20,
    lck = 20,
    maxhp = 40
  },
  weapon = nil
}

function unit:__init ()
  if self.maxhp then
    self.hp = self.maxhp
  end
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

function unit:combatspeed ()
  local wgtmod = math.min(0, (self.str + self.con)/2 - self.weapon.wgt)
  return self.spd + wgtmod
end

function unit:mt ()
  return self.weapon.mt + self[self.weapon.atkattribute]
end

function unit:hit ()
  return 2 * self.skl + self.lck + self.weapon.hit
end

function unit:evade ()
  return 2 * self:combatspeed() + self.lck
end

function unit:defattr ()
  return self.weapon.defattribute
end

function unit:crit ()
  return self.skl/2 + self.weapon.crt
end

function unit:dodge ()
  return self.lck
end

function unit:expbase ()
  return self.lv -- + self.class.tierbonus 
end

function unit:exppower ()
  return 3 -- self.class.power
end

function unit:expbonus ()
  return 0 -- self.class.bonus
end

function unit:bossbonus ()
  return 0 -- TODO: enfiar isso de modo que seja variavel
end

function unit:draw ()
  love.graphics.print("name: "..self.name, 0, 0)
  love.graphics.print("lv: "..self.lv, 0, 20)
  love.graphics.print("exp: "..self.exp, 0, 40)
  love.graphics.print("hp: "..self.hp.."/"..self.maxhp, 0, 60)
  love.graphics.print("str: "..self.str, 0, 80)
  love.graphics.print("mag: "..self.mag, 0, 100)
  love.graphics.print("def: "..self.def, 0, 120)
  love.graphics.print("res: "..self.res, 0, 140)
  love.graphics.print("spd: "..self.spd, 0, 160)
  love.graphics.print("skl: "..self.skl, 0, 180)
  love.graphics.print("lck: "..self.lck, 0, 200)
end

function unit.foreachattr (f)
  table.foreach(attributes, f)
end

