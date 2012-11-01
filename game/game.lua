
require "vec2"
require "unit"
require "class"
require "weapon"
require "effects"

local vec2          = vec2
local unit          = unit
local attributes    = attributes
local weapon        = weapon
local class         = class

module "game" do

  -- TODO: Give game state as argument to domain-specific functions
  state = {
    layout = nil
  }

  layouts = {}

  function changetolayout (name)
    state.layout = layouts[name]
  end

  -- LÖVE callbacks --

  function update (dt)
    state.layout.controller:update(dt)
    state.layout:update(dt)
  end

  function draw (graphics)
    state.layout:draw(graphics)
  end
  
  function mousereleased (x, y, button)
    state.layout.controller:releasemouse(button, vec2:new{x,y})
  end
  
  function mousepressed (x, y, button)
    state.layout.controller:pressmouse(button, vec2:new{x,y})
  end

  function keypressed (key)
    state.layout.controller:presskey(key)
  end
  
  function keyreleased (key)
    state.layout.controller:releasekey(key)
  end

  -- STUFF --

  unit1 = unit:new {
    name = "Juaum",
    attributes = attributes:new{
      maxhp = 20,
      str = 12,
      spd = 14,
      def = 6,
      lck = 0
    },
    weapon = weapon:new{
      weapontype = "lance",
      useexp = 11,
      minrange = 1,
      maxrange = 2
    }
  }

  unit2 = unit:new {
    name = "Leeroy",
    attributes = attributes:new{
      maxhp = 20,
      skl = 20,
      lck = 20
    },
    weapon = weapon:new {
      hit = 40,
      useexp = 100,
      minrange = 2,
      maxrange = 2
    }
  }

  unit3 = unit:new {
    attributes = attributes:new{
      con = 30
    }
  }
  
  unit4 = unit:new {
    attributes = attributes:new{
      con = 1
    }
  }

  awesomeclass = class:new{
    name = "SuperSoldier",
    caps = attributes:new{
      str = 30
    }
  }
  
end

