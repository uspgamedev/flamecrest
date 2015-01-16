
local common    = require 'lux.oo.class' .package 'domain.common'
local unitspec  = require 'domain.common.unitspec'
local units     = require 'content.units'

print(common.Class)

function common:Unit (name)

  assert(name)

  local bases   = units[name].base
  local growths = units[name].growth
  local class   = common.Class(units[name].class)

  assert(bases)
  assert(growths)

  local maxhp = bases.maxhp
  local str   = bases.str
  local mag   = bases.mag
  local def   = bases.def
  local res   = bases.res
  local spd   = bases.spd
  local skl   = bases.skl
  local lck   = bases.lck
  local mv    = bases.mv
  local con   = bases.con

  local lv    = 1
  local exp   = 0

  local bossexpbonus = 0

  function self:getName ()
    return name
  end

  function self:getClass ()
    return class
  end

  function self:getLv ()
    return lv
  end

  function self:getMaxHP ()
    return maxhp
  end

  function self:setMaxHP (val)
    maxhp = val
  end

  function self:getStr ()
    return str
  end

  function self:setStr (val)
    str = val
  end

  function self:getMag ()
    return mag
  end

  function self:setMag (val)
    mag = val
  end

  function self:getDef ()
    return def
  end

  function self:setDef (val)
    def = val
  end

  function self:getRes ()
    return res
  end

  function self:setRes (val)
    res = val
  end

  function self:getSpd ()
    return spd
  end

  function self:setSpd (val)
    spd = val
  end

  function self:getSkl ()
    return skl
  end

  function self:setSkl (val)
    skl = val
  end

  function self:getLck ()
    return lck
  end

  function self:setLck (val)
    lck = val
  end

  function self:getMv ()
    return mv
  end

  function self:setMv (val)
    mv = val
  end

  function self:getCon ()
    return con
  end

  function self:setCon (val)
    con = val
  end

  function self:getAttr (attrname)
    local first = string.char(attrname:byte(1)-32)
    attrname = attrname:gsub("^(%a)", first)
    attrname = attrname:gsub("hp", "HP")
    return self['get'..attrname](self)
  end

  function self:setAttr (attrname, value)
    local first = string.char(attrname:byte(1)-32)
    attrname = attrname:gsub("^(%a)", first)
    attrname = attrname:gsub("hp", "HP")
    return self['set'..attrname](self, value)
  end

  function self:getTerrainCostFor (terrain_type)
    return class:getTerrainCostFor(terrain_type)
  end

  function self:hasTrait (traitname)
    return false -- TODO
  end

  function self:levelUp()
    lv = lv + 1
    for k,v in pairs(unitspec:attrNames()) do
      local roll = math.random(1, 100)
      if roll <= growths[v] then
        self:setAttr(v, self:getAttr(v) + 1)
      end
    end
  end

end
