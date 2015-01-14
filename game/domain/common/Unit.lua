
local common = require 'lux.oo.class' .package 'domain.common'
local unitspec = require 'domain.common.unitspec'

function common:Unit (name, class, basespec, growthspec)

  assert(name)
  assert(class)
  assert(basespec)
  assert(growthspec)

  local maxhp = basespec.maxhp
  local str   = basespec.str
  local mag   = basespec.mag
  local def   = basespec.def
  local res   = basespec.res
  local spd   = basespec.spd
  local skl   = basespec.skl
  local lck   = basespec.lck
  local mv    = basespec.mv
  local con   = basespec.con

  local growths = growthspec --:clone()

  local lv    = 1
  local exp   = 0

  local bossexpbonus = 0

  function self:getName ()
    return name
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
    -- TODO derp
    if terrain_type == 'Plains' then
      return 1
    elseif terrain_type == 'Forest' then
      return 2
    else
      return 1337
    end
  end

  function self:hasTrait (traitname)
    return false -- TODO
  end

  function self:levelUp()
    for k,v in pairs(unitspec:attrNames()) do
      print("v -> "..v)
      local roll = math.random(1, 100)
      if roll <= growths[v] then
        self:setAttr(v, self:getAttr(v) + 1)
      end
    end
  end

end
