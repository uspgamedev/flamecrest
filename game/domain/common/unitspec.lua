
local unitspec = require 'lux.oo.prototype' :new {
--[[  maxhp = 20,
  str = 5,
  mag = 5,
  def = 5,
  res = 5,
  spd = 5,
  skl = 5,
  lck = 5,
  mv = 5,
  con = 7
]]
}

local attrnames = {
  'maxhp',
  'str',
  'mag',
  'def',
  'res',
  'spd',
  'skl',
  'lck',
  'mv',
  'con',
}

for i, v in ipairs(attrnames) do
  unitspec[v] = 5
end

function unitspec:attrNames()
  return attrnames
end

return unitspec
