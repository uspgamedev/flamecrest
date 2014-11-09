
module ("model.battle", package.seeall) do

  require 'model.battle.tilelist'

  tile = require 'lux.oo.prototype' :new {
    type = "plains",
    unit = nil,
    attributes = nil
  }

  function tile:__construct()
    self.attributes = tiletypes[self.type]
  end
end
