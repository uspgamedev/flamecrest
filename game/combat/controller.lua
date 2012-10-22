
require "ui.controller"
require "combat.fight"
require "combat.actions"
require "effects"
require "game"

local ui      = ui
local game    = game
local heal    = heal
local fight   = combat.fight
local event   = love.event

module "combat" do

  controller = ui.controller:new{}

  function controller.keyactions.released.escape ()
    event.push "quit"
  end

  function controller.keyactions.released.a ()
    if game.unit1:isdead() or game.unit2:isdead() then return end
    fight(game.unit1, game.unit2, game.unit1.weapon.minrange)
  end
  
  function controller.keyactions.released.s ()
    if game.unit1:isdead() or game.unit2:isdead() then return end
    fight(game.unit2, game.unit1, game.unit2.weapon.minrange)
  end
  
  function controller.keyactions.released.x ()
    game.unit1:gainexp(30)
  end
  
  function controller.keyactions.released.c ()
    game.unit2:gainexp(30)
  end

  function controller.keyactions.released.q ()
    heal(game.unit1, game.unit2)
 end

  function controller.keyactions.released.w ()
    heal(game.unit2, game.unit1)
  end
  
  function controller.keyactions.released.r ()
    rescue(game.unit1, game.unit3)
  end

  function controller.keyactions.released.t ()
    rescue(game.unit1, game.unit4)
  end
  
  function controller.keyactions.released.y ()
    dropunit(game.unit1)
  end

  function controller.keyactions.released.f ()
    rescue(game.unit2, game.unit3)
  end

  function controller.keyactions.released.g ()
    rescue(game.unit2, game.unit4)
  end
  
  function controller.keyactions.released.h ()
    dropunit(game.unit2)
  end 
  
  function controller.keyactions.released.p ()
    game.unit1:promote(game.awesomeclass)
  end

  function controller.keyactions.released.o ()
    game.unit2:promote(game.awesomeclass)
  end

  function controller.keyactions.released.tab ()
    game.changetolayout "battle"
  end

end
