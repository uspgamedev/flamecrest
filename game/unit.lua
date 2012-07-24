
require "nova.object"
require "class"

local attributes = { "maxhp", "str", "mag", "def", "res", "spd", "skl", "lck" }

unit = nova.object:new {
  name = "Unit",
  lv = 1,
  exp = 0,
  hp = nil,
  maxhp = nil,
  str = nil,
  mag = nil,
  def = nil,
  res = nil,
  spd = nil,
  skl = nil,
  lck = nil,
  con =nil,
  mv = nil, 
  growths = {
    maxhp = nil,
    str = nil,
    mag = nil,
    def = nil,
    res = nil,
    spd = nil,
    skl = nil,
    lck = nil,
  },
  class = nil,
  weapon = nil,
  bossexpbonus = 0
}

function unit:__init ()
  if not self.class then
    self.class = class:new{}
  end
  self.foreachattr(
     function (_, attr)
       if not self[attr] then 
         self[attr] = self.class.defaultstats[attr]
       end
       if not self.growths[attr] then
	 self.growths[attr] = self.class.defaultgrowths[attr] 
      end
     end 
  )
  if not self.mv then
    self.mv = self.class.defaultstats.mv
  end
  if not self.con then
    self.con = self.class.defaultstats.con
  end
  self.hp = self.maxhp
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
  return self.bossexpbonus
end

function unit:draw ()
  -- unit info
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
  -- unit weapon info
  love.graphics.print("weapon: "..self.weapon.weapontype, 128, 0)
  love.graphics.print("mt: "..self.weapon.mt, 128, 20)
  love.graphics.print("hit: "..self.weapon.hit, 128, 40)
  love.graphics.print("wgt: "..self.weapon.wgt, 128, 60)
  love.graphics.print("crt: "..self.weapon.crt, 128, 80)
end

function unit.foreachattr (f)
  table.foreach(attributes, f)
end

