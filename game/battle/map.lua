
local object = require "lux.object"

require "battle.tile"

module "battle" do

  map = object.new {
    width   = 8,
    height  = 8
  }

  function map:__init ()
    self.tiles = {}
    for i = 1,self.height do
      self.tiles[i] = {}
      for j = 1,self.width do
        self.tiles[i][j] = tile:new {}
      end
    end
  end


end
