
local unitspec = require 'domain.common.unitspec'

local basespec = unitspec:new {
  maxhp = 20,
  str = 5,
  mag = 5,
  skl = 5,
  spd = 5,
  def = 5,
  res = 5,
  lck = 5,
  con = 7,
  mv = 5,
}

local growthspec = unitspec:new {
  maxhp = 50,
  str = 30,
  mag = 30,
  skl = 30,
  spd = 30,
  def = 30,
  res = 30,
  lck = 30,
  con = 0,
  mv = 0,
}

-- By class + gender

local myrmidon_male_spec = {
  base = basespec:new {
    maxhp = 18,
    str = 4,
    mag = 0,
    skl = 9,
    spd = 9,
    def = 2,
    res = 0,
    lck = 2,
    con = 8
  },
  growth = growthspec:new {
    maxhp = 70,
    str = 35,
    mag = 10,
    skl = 40,
    spd = 40,
    def = 15,
    res = 17,
    lck = 30
  }
}

-- Specific units

local units = {}

units["Leeroy Jenkins"] = {
  base = myrmidon_male_spec.base:new{},
  growth = myrmidon_male_spec.growth:new{
    skl = 60,
    spd = 50,
    def = 20,
    res = 20,
  },
  class = 'Myrmidon'
}

units["Juaum MacDude"] = {
  base = basespec:new{},
  growth = growthspec:new{},
  class = 'Archer'
}

units["Minion"] = {
  base = basespec:new{},
  growth = growthspec:new{},
  class = 'Fighter'
}

return units
