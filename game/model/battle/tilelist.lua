
local object = require "lux.object"

module "model.battle" do
  
  tiletypes = {
    plains = object.new {
      avoid = 0,
      def = 0,
      mdef = 0
    },
    forest = object.new {
      avoid = 10,
      def = 1,
      mdef = 0
    }
  }

end
