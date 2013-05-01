
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
    local success, err = coroutine.resume(self.routine, self)
    if not success then
      error(err)
    end
  end

  local function generate_log (battlelog)
    local output = ""
    for _,result in ipairs(battlelog) do
      output = output..result.attacker.name.." attacks "..result.defender.name..":\n"
      if result.hit then
        if result.critical then
          output = output.."It is a critical hit! "
        end
        output = output..result.damage.." damage is dealt.\n"
      else
        output = output.."He misses\n"
      end
      output = output.."\n"
    end
    for _,dead in ipairs(battlelog.deaths) do
      output = output..dead.name.." dies.\n"
    end
    for unit,exp in pairs(battlelog.exp) do
      output = output..unit.name.." earns "..exp.." experience points.\n"
    end
    return output
  end

  function battle:coroutine()
    while true do
      while not self.input do
        coroutine.yield()
      end
      if self.input.type == "moveunit" then
        self.map:moveunit(self.input[1], self.input[2])
        self.interface.focus = self.input[2]
        self.interface.mode = "action"
      elseif self.input.type == "startcombat" then
        local battlelog = self.map:startcombat(self.input[1], self.input[2])
        ui.layout.add(
          ui.common.dialog:new {
            text = generate_log(battlelog),
            pos  = vec2:new {
              love.graphics.getWidth()/2 - 128,
              love.graphics.getHeight()/2 - 128
            },
            size = vec2:new{256, 256},
            format = 'left'
          }
        )
      else
        error("Unknown input type: " .. self.input.type)
      end
      self.input = nil
    end
  end

  function battle:moveunit(from, to)
    self.input = { type = "moveunit", from, to }
  end

  function battle:startcombat(from, to)
    self.input = { type = "startcombat", from, to }
  end
  
end
