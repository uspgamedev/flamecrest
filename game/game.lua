
module ("game", package.seeall) do

  require "vec2"
  require "unit"
  require "class"
  require "weapon"
  require "effects"
  require "ui.layout"

  local mouse         = love.mouse
  local vec2          = vec2
  local unit          = unit
  local attributes    = attributes
  local weapon        = weapon
  local class         = class
  local ui            = ui

  -- LÖVE callbacks --

  function update (dt)
    ui.layout.mouseevent("mousehover", vec2:new{mouse.getPosition()}, dt)
    ui.layout.updateevent(dt)
  end

  function draw (graphics)
    ui.layout.draw()
  end
  
  function mousereleased (x, y, button)
    ui.layout.mouseevent("mousereleased", vec2:new{x,y}, button)
  end
  
  function mousepressed (x, y, button)
    ui.layout.mouseevent("mousepressed", vec2:new{x,y}, button)
  end

  function keypressed (key)
    --state.layout.controller:presskey(key)
  end
  
  function keyreleased (key)
    --state.layout.controller:releasekey(key)
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
    },
    class = class:new{
      traits = {"flying"}
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
      bonusagainst = {"flying"},
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

