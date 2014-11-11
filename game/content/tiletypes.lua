
local prototype = require 'lux.oo.prototype'

local tiletypes = {}

tiletypes.default = prototype:new {
  name = 'Default',
  avoid = 0,
  def = 0,
  res = 0
}

tiletypes.plains = tiletypes.default:new {
  name = 'Plains',
}

tiletypes.forest = tiletypes.default:new {
  name = 'Forest',
  avoid = 10,
  def = 1,
}

return tiletypes
