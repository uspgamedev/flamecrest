
require "lux.object"
require "class"
require "attributes"
require "ui.component"

unit = lux.object.new {
  name = "Unit",
  lv = 1,
  exp = 0,
  hp = nil,
  attributes = nil, --maxhp, str, mag, def, res, spd, skl, lck, mv, con
  growths = nil,
  class = nil,
  weapon = nil,
  bossexpbonus = 0,
  rescuedunit = nil
}

function unit:__init ()
  if not self.class then
    self.class = class:new{}
  end
  if not self.attributes then
    self.attributes = self.class.defaultattributes:clone()
  end
  if not self.growths then
    self.growths = self.class.defaultgrowths:clone()
  end
  self.hp = self.attributes.maxhp
  self.sprite = love.graphics.newImage "resources/images/stick-man.png"
end

function unit:takedamage (dmg)
  self.hp = self.hp - dmg
  if self.hp < 0 then
    self.hp = 0
  end
end

function unit:heal (healamount)
  self.hp = self.hp + healamount
  if self.hp > self.attributes.maxhp then
    self.hp = self.attributes.maxhp
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
  if self.lv >= 20 then return end
  self.lv = self.lv + 1
  attributes.foreachbasattr(
    function (_,attr)
      if self.attributes[attr] < self.class.caps[attr] then
        rand = math.random(100)
        growth = self.growths[attr]
        print("Attribute:", attr, growth, rand)
        while rand <= growth do
          self.attributes[attr] = self.attributes[attr] + 1
          growth = growth - 100
        end
      end
    end
  )
  print("")
end

function unit:promote(class)
  print("WILL PROMOTE!!!!")
  if not class then return end
  print("PROMOTING") 
  self.class = class
  attributes.foreachattr(
    function (_,attr)
      if self.attributes[attr] < self.class.caps[attr] then
         self.attributes[attr] = self.attributes[attr] + self.class.promotionbonus[attr] --GRAA LINHA HORRIVEL 
      end
    end
  )
  self.lv = 1
end

function unit:canrescue (otherunit)
  if self.rescuedunit == nil and self.attributes.con -2 >= otherunit.attributes.con then
    return true
  else
    return false
  end
end

function unit:getspd()
  local speed = self.attributes.spd
  print ("unitspeed "..speed)
  if self.rescuedunit then
    speed = math.ceil(speed/2)
    print ("modifiedspeedduetorescue "..speed)
  end
  return speed
end

function unit:getskl()
  local skill = self.attributes.skl
  print ("skil "..skill)
  if self.rescuedunit then
     skill = math.ceil(skill/2)
     print("rescuedskill "..skill)
  end 
  print("")
  return skill
end

function unit:getrescuedunit ()
  return self.rescuedunit
end

function unit:dropunit ()
  local droppedunit = self.rescuedunit
  self.rescuedunit = nil
  return droppedunit
end

function unit:rescue (otherunit)
  if self:canrescue(otherunit) then
    self.rescuedunit = otherunit
  end
end

function unit:isdead ()
  return self.hp <= 0
end

function unit:canattackatrange (range)
  if range >= self.weapon.minrange and range <= self.weapon.maxrange then
    return true
  end
  return false
end

function unit:combatspeed ()
  local wgtmod = math.floor(math.max(0, (self.weapon.wgt - self.attributes.str + self.attributes.con)/2))
  local cspeed = self:getspd() - wgtmod
  print ("combastspeed "..cspeed)
  print ("")
  return cspeed
end

function unit:mt ()
  return self.weapon.mt + self.attributes[self.weapon.atkattribute]
end

function unit:mtagainst (other)
  return self.weapon:mtagainst(other) + self.attributes[self.weapon.atkattribute]
end


function unit:hit ()
  local hit = 2 * self:getskl() + self.attributes.lck + self.weapon.hit 
  return hit
end

function unit:evade ()
  return 2 * self:combatspeed() + self.attributes.lck
end

function unit:defattr ()
  return self.weapon.defattribute
end

function unit:crit ()
  return self:getskl()/2 + self.weapon.crt
end

function unit:dodge ()
  return self.attributes.lck
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
  graphics.print("hp: "..self.unit.hp.."/"..self.unit.attributes.maxhp, 0, 60)
  graphics.print("str: "..self.unit.attributes.str, 0, 80)
  graphics.print("mag: "..self.unit.attributes.mag, 0, 100)
  graphics.print("def: "..self.unit.attributes.def, 0, 120)
  graphics.print("res: "..self.unit.attributes.res, 0, 140)
  graphics.print("spd: "..self.unit.attributes.spd, 0, 160)
  graphics.print("skl: "..self.unit.attributes.skl, 0, 180)
  graphics.print("lck: "..self.unit.attributes.lck, 0, 200)
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
