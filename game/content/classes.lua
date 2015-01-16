
local unitspec    = require 'domain.common.unitspec'
local terraincost = require 'domain.common.terraincost'

local capspec = unitspec:new {
  maxhp = 30,
  str = 20,
  mag = 20,
  def = 20,
  res = 20,
  spd = 20,
  skl = 20,
  lck = 99,
  mv = 10,
  con = 10
}

local classes = {}

classes["Soldier"] = {
  cap = capspec:new{},
  terraincost = terraincost:new{}
}

classes["Myrmidon"] = {
  cap = capspec:new{},
  terraincost = terraincost:new{}
}

classes["Fighter"] = {
  cap = capspec:new{},
  terraincost = terraincost:new{}
}

classes["Archer"] = {
  cap = capspec:new{},
  terraincost = terraincost:new{}
}

return classes
