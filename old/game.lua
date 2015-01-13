
local game = {}

local vec2 = require "lux.geom.Vector"
require "common.unit"
require "common.class"
require "common.weapon"
require "effects"

local layout        = require "ui.layout"
local mouse         = love.mouse
local unit          = unit
local attributes    = attributes
local weapon        = weapon
local class         = class
local ui            = ui

-- LÖVE callbacks --

function game.update (dt)
  layout.mouseevent("mousehover", vec2:new{mouse.getPosition()}, dt)
  layout.updateevent(dt)
end

function game.draw (graphics)
  layout.draw()
end

function game.mousereleased (x, y, button)
  layout.mouseevent("mousereleased", vec2:new{x,y}, button)
end

function game.mousepressed (x, y, button)
  layout.mouseevent("mousepressed", vec2:new{x,y}, button)
end

function game.keypressed (key)
  if key == 'escape' then
    love.event.push 'quit'
  end
  --state.layout.controller:presskey(key)
end

function game.keyreleased (key)
  --state.layout.controller:releasekey(key)
end

-- STUFF --

game.unit1 = unit:new {
  name = "Juaum",
  attributes = attributes:new{
    maxhp = 20,
    str = 12,
    spd = 14,
    def = 6,
    lck = 0,
    mv = 3
  },
  weapon = weapon:new{
    weapontype = "lance",
    useexp = 11,
    minrange = 1,
    maxrange = 2
  },
  class = class:new{
    traits = {"flying"}
  }
}

game.unit2 = unit:new {
  name = "Leeroy",
  attributes = attributes:new{
    maxhp = 20,
    skl = 20,
    lck = 20,
    mv = 3
  },
  weapon = weapon:new {
    hit = 40,
    bonusagainst = {"flying"},
    useexp = 100,
    minrange = 2,
    maxrange = 2
  }
}

game.unit3 = unit:new {
  attributes = attributes:new{
    con = 30
  }
}

game.unit4 = unit:new {
  attributes = attributes:new{
    con = 1
  }
}

game.awesomeclass = class:new{
  name = "SuperSoldier",
  caps = attributes:new{
    str = 30
  }
}

return game
