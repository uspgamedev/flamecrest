
require "ui.controller"
require "battle.cursor"
require "combat.fight"
require "game"

local event         = love.event
local ui            = ui
local game          = game
local combatlayout  = combatlayout
local fight         = combat.fight

module "battle" do

  controller = ui.controller:new{
    cursor = cursor:new{}
  }

  function controller:update (dt)
    self.cursor:update(dt)
  end

  function controller:mousereleased (button, pos)
    if button == 'l' then
      local focused = layout:screentotile(pos)
      local tile    = layout.map:focusedtile()
      if tile then
        layout.map.focus:set(focused:get())
      end
    end
  end

  function controller.keyactions.released.escape ()
    event.push "quit"
  end

  controller.keyactions.released["return"] = function ()
    local attacker  = layout:focusedunit()
    local target    = layout:targetedunit()
    local distance  = layout.map:selectiondistance()
    if not attacker or not target then return end
    if attacker:isdead() or target:isdead() then return end
    if distance < attacker.weapon.minrange
      or distance > attacker.weapon.maxrange then
      return
    end
    fight(attacker, target, distance)
  end

  function controller.keyactions.released.m ()
    layout.map:moveunit()
  end

  function controller.keyactions.released.tab ()
    game.changetolayout "combat"
  end

end
