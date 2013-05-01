
module ("controller", package.seeall) do
  
  require "model.battle.map"

  local vec2    = vec2
  local object  = require "lux.object"
  local testdata = require "resources.testdata"

  battle = object.new {
    width = nil,
    height = nil,

    map = nil,
  }

  function battle:__init()
    self.map = model.battle.map:new { width = self.width, height = self.height }

    self.map.tiles[5][1].unit = testdata.unit1
    self.map.tiles[5][9].unit = testdata.unit2
  end
  
end
