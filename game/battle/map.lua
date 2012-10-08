
local object = require "lux.object"

require "battle.tile" 
require "battle.hexpos"

module "battle" do

  map = object.new {
    width   = 5,
    height  = 5,
    tiles   = nil
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

  function map:tile (pos)
    return hexpos:new{1,1} <= pos and pos <= hexpos:new{self.width,self.height}
      and self.tiles[pos.i][pos.j]
  end

  function map:moveunit (originpos, targetpos)
    if self:tile(targetpos).unit then return end
    self.tiles[targetpos.i][targetpos.j].unit =
      self.tiles[originpos.i][originpos.j].unit
    self.tiles[originpos.i][originpos.j].unit = nil
  end

end
