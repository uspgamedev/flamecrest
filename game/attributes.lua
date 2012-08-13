
require "lux.object"

local attributelist = { "maxhp", "str", "mag", "def", "res", "spd", "skl", "lck" }
local extendedattributelist = { "mv", "con" }

--TODO: Link list of attributes to attributes present?

attributes = lux.object.new {
  maxhp = 20,
  str = 10,
  mag = 10,
  def = 10,
  res = 10,
  spd = 10,
  skl = 10,
  lck = 10
}

extendedattributes = lux.object.new {
  mv = 5,
  con = 7
}

function attributes.foreachattr (f)
  table.foreach(attributelist, f)
end

function extendedattributes.foreachattr (f)
  table.foreach(extendedattributelist, f)
end
