
local object = require "lux.object"

module "battle" do
  
  tiletypes = {
    plains = object.new {
      type = "plains",
      bonus = {
        avoid = 0,
        def = 0,
        mdef = 0
      }
    },
    forest = object.new {
      type = "forest",
      bonus = {
        avoid = 10,
        def = 1,
        mdef = 0
      }
    }
  }

end