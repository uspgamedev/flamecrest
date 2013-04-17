
module ("battle", package.seeall) do

  require "battle.tilelist"
  
  local object = require "lux.object"
  
  tile = object.new{
    type = "plains",
    unit = nil,
    attributes = nil
  }
  
  function tile:__init()
    self.attributes = tiletypes[self.type]
  end
end
