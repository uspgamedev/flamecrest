
require "nova.object"
require "class"
require "ui"
require "ui.component"

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

function unit:heal (healamount)
  self.hp = self.hp + healamount
  if self.hp > self.maxhp then
    self.hp = self.maxhp
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
  self.foreachattr(
    function (_,attr)
      if self[attr] < self.class.caps[attr] then
        rand = math.random(100)
        growth = self.growths[attr]
        print("Attribute:", attr, growth, rand)
        while rand <= growth do
          self[attr] = self[attr] + 1
          growth = growth - 100
        end
      end
    end
  )
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
  return self.lv + self.class.exptierbonus 
end

function unit:exppower ()
  return self.class.expclasspower
end

function unit:expbonus ()
  return self.class.expclassbonus
end

function unit:bossbonus ()
  return self.bossexpbonus
end

unit.display = ui.component:new {}

function unit.display:draw (graphics)
  if self.unit.hp <= 0 then
    graphics.setColor { 255, 50, 50, 255 }
    graphics.print("DEAD", 0, -20)
  end
  -- unit info
  graphics.print("name: "..self.unit.name, 0, 0)
  graphics.print("lv: "..self.unit.lv, 0, 20)
  graphics.print("exp: "..self.unit.exp, 0, 40)
  graphics.print("hp: "..self.unit.hp.."/"..self.unit.maxhp, 0, 60)
  graphics.print("str: "..self.unit.str, 0, 80)
  graphics.print("mag: "..self.unit.mag, 0, 100)
  graphics.print("def: "..self.unit.def, 0, 120)
  graphics.print("res: "..self.unit.res, 0, 140)
  graphics.print("spd: "..self.unit.spd, 0, 160)
  graphics.print("skl: "..self.unit.skl, 0, 180)
  graphics.print("lck: "..self.unit.lck, 0, 200)
  -- unit weapon info
  graphics.print("weapon: "..self.unit.weapon.weapontype, 128, 0)
  graphics.print("mt: "..self.unit.weapon.mt, 128, 20)
  graphics.print("hit: "..self.unit.weapon.hit, 128, 40)
  graphics.print("wgt: "..self.unit.weapon.wgt, 128, 60)
  graphics.print("crt: "..self.unit.weapon.crt, 128, 80)
end

function unit:makedisplay (pos)
  return unit.display:new {
    unit = self,
    pos = vec2:new {pos.x,pos.y},
    size = vec2:new {256,220}
  }
end

function unit.foreachattr (f)
  table.foreach(attributes, f)
end

