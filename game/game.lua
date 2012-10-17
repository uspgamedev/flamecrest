
require "unit"
require "combat"
require "weapon"
require "effects"
require "combatlayout"
require "battle.layout"

local _combatlayout = combatlayout
local battlelayout = battle.layout

module ("game", package.seeall) do

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

  keyactions = {}

  function keyactions.escape ()
    love.event.push "quit"
  end

  function keyactions.tab ()

  end

  function keyactions.a ()
    if unit1:isdead() or unit2:isdead() then return end
    combat(unit1, unit2, unit1.weapon.minrange)
  end
  
  function keyactions.s ()
    if unit1:isdead() or unit2:isdead() then return end
    combat(unit2, unit1, unit2.weapon.minrange)
  end
  
  function keyactions.x ()
    unit1:gainexp(30)
  end
  
  function keyactions.c ()
    unit2:gainexp(30)
  end

  function keyactions.q ()
    heal(unit1, unit2)
 end

  function keyactions.w ()
    heal(unit2, unit1)
  end
  
  function keyactions.r ()
    rescue(unit1, unit3)
  end

  function keyactions.t ()
    rescue(unit1, unit4)
  end
  
  function keyactions.y ()
    dropunit(unit1)
  end

  function keyactions.f ()
    rescue(unit2, unit3)
  end

  function keyactions.g ()
    rescue(unit2, unit4)
  end
  
  function keyactions.h ()
    dropunit(unit2)
  end 
  
  function keyactions.p ()
    unit1:promote(awesomeclass)
  end

  function keyactions.o ()
    unit2:promote(awesomeclass)
  end

  function keyactions.tab ()
    if currentlayout == combatlayout then
      currentlayout = battlelayout
    else
      currentlayout = combatlayout
    end
  end

  keyactions["return"] = function ()
    if currentlayout == battlelayout then
      local attacker  = battlelayout:focusedunit()
      local target    = battlelayout:targetedunit()
      local distance  = battlelayout:selectiondistance()
      if not attacker or not target then return end
      if attacker:isdead() or target:isdead() then return end
      if distance < attacker.weapon.minrange
        or distance > attacker.weapon.maxrange then
        return
      end
      combat(attacker, target, distance)
    end
  end

  function keyactions.m ()
    if currentlayout == battlelayout then
      battlelayout.map:moveunit(battlelayout.focus, battlelayout.cursor)
    end
  end

  combatlayout = _combatlayout:new { game = _M }

  currentlayout = combatlayout
  
  function rescue(rescuer, rescuee)
    if rescuer:canrescue(rescuee) then
      print ("Looks like it can rescue")
      rescuer:rescue(rescuee)
      if rescuer:getrescuedunit() == rescuee then
        print("success!")
      else
        print("oh no")
      end
    else
      print ("no can rescue")
    end
    print("")
  end

  function dropunit(rescuer)
    rescuer:dropunit()
    print("dropped")
    print("")
  end

end

