
local prototype = require 'lux.oo.prototype'

local tiletypes = {}

tiletypes.default = prototype:new {
  avoid = 0,
  def = 0,
  mdef = 0
}

tiletypes.plains = default:new {}

tiletypes.forest = default:new {
  avoid = 10,
  def = 1,
  mdef = 0
}

return tiletypes
