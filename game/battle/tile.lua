
module ("battle", package.seeall) do

  require "battle.tilelist"
  
  local object = require "lux.object"

  plainstile = object.new {
    type  = tiletypes["plains"],
    unit  = nil
  }

  foresttile = object.new {
    type = tiletypes["forest"],
    unit = nil
  }

end
