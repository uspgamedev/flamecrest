
module ("controller", package.seeall) do
  
  require "model.battle.map"

  local vec2    = vec2
  local object  = require "lux.object"
  local testdata = require "resources.testdata"

  battle = object.new {
    width = nil,
    height = nil,
    input = nil,

    map = nil,
    routine = nil,
  }

  function battle:__init()
    self.routine = coroutine.create(function (self) self:coroutine() end)
    self.map = model.battle.map:new { width = self.width, height = self.height }

    self.map.tiles[5][1].unit = testdata.unit1
    self.map.tiles[5][9].unit = testdata.unit2
  end

  function battle:update(dt)
    coroutine.resume(self.routine, self)
  end

  function battle:coroutine()
    while true do
      if not self.input then
        coroutine.yield()
      end
      self.input = nil
    end
  end
  
end
