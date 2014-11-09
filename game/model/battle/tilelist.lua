
local prototype = require 'lux.oo.prototype'

module "model.battle" do

  tiletypes = {
    plains = prototype:new {
      avoid = 0,
      def = 0,
      mdef = 0
    },
    forest = prototype:new {
      avoid = 10,
      def = 1,
      mdef = 0
    }
  }

end
