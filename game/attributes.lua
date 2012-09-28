
require "lux.object"

local basicattributelist = { "maxhp", "str", "mag", "def", "res", "spd", "skl", "lck" }
local extendedattributelist = { "mv", "con" }
local allattributes = { basicattributelist, extendedattributelist }

--TODO: Link list of attributes to attributes present?

attributes = lux.object.new {
  maxhp = 20,
  str = 10,
  mag = 10,
  def = 10,
  res = 10,
  spd = 10,
  skl = 10,
  lck = 10,
  mv = 5,
  con = 7
}

function attributes.foreachbasattr (f)
  table.foreach(attributelist, f)
end

function attributes.foreachextattr (f)
  table.foreach(extendedattributelist, f)
end

function attributes.foreachattr (f)
  for j=1,#allttributes do
    for i = 1, #allattributes[j] do
      f(i, allattributes[j][i])
    end
  end
end