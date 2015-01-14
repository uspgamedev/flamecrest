
local unitspec = require 'domain.common.unitspec'

local basespec = unitspec:new {
  maxhp = 20,
  str = 5,
  mag = 5,
  def = 5,
  res = 5,
  spd = 5,
  skl = 5,
  lck = 5,
  mv = 5,
  con = 7
}

local growthspec = unitspec:new {
  maxhp = 50,
  str = 30,
  mag = 30,
  def = 30,
  res = 30,
  spd = 30,
  skl = 30,
  lck = 30,
  mv = 0,
  con = 0
}

local units = {}

units["Leeroy Jenkins"] = {
  base = basespec:new{},
  growth = growthspec:new{},
}

units["Juaum MacDude"] = {
  base = basespec:new{},
  growth = growthspec:new{},
}

units["Minion"] = {
  base = basespec:new{},
  growth = growthspec:new{},
}

return units
