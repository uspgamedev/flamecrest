
local object = require "lux.object"

require "battle.tilelist"

module "battle" do

  plainstile = object.new {
    type  = tiletypes["plains"],
    unit  = nil
  }

  foresttile = object.new {
    type = tiletypes["forest"],
    unit = nil
  }

end
