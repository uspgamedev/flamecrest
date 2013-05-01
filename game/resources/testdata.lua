
require "common.unit"
require "common.class"
require "common.weapon"

local unit          = unit
local attributes    = attributes
local weapon        = weapon
local class         = class

return {
  unit1 = unit:new {
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
  },

  unit2 = unit:new {
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
  },

  unit3 = unit:new {
    attributes = attributes:new{
      con = 30
    }
  },
  
  unit4 = unit:new {
    attributes = attributes:new{
      con = 1
    }
  },

  awesomeclass = class:new{
    name = "SuperSoldier",
    caps = attributes:new{
      str = 30
    }
  },
}
