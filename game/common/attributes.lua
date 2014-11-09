
attributes = require "lux.oo.prototype" :new {
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

local basicattributelist = {
  "maxhp", "str", "mag", "def", "res", "spd", "skl", "lck"
}

local extendedattributelist = { "mv", "con" }
local allattributes = { basicattributelist, extendedattributelist }

--TODO: Link list of attributes to attributes present?

function attributes.foreachbasattr (f)
  table.foreach(basicattributelist, f)
end

function attributes.foreachextattr (f)
  table.foreach(extendedattributelist, f)
end

function attributes.foreachattr (f)
  for j=1,#allattributes do
    for i = 1, #allattributes[j] do
      f(i, allattributes[j][i])
    end
  end
end