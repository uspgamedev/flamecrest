
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

  function map:inside (pos)
    return hexpos:new{1,1} <= pos and pos <= hexpos:new{self.height,self.width}
  end

  function map:tile (pos)
    return self:inside(pos) and self.tiles[pos.i][pos.j]
  end

  function map:pertile (action)
    for i = 1,self.height do
      for j = 1,self.width do
        local tile  = self.tiles[i][j]
        if tile then
          action(i, j, tile)
        end
      end
    end
  end

  function map:putunit (pos, unit)
    if self:inside(pos) then
      self.tiles[pos.i][pos.j].unit = unit
    end
  end

  function map:moveunit (originpos, targetpos)
    if self:tile(targetpos).unit then return end
    self:putunit(targetpos, self:tile(originpos).unit)
    self:putunit(originpos, nil)
  end

end
