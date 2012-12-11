
require "ui.controller"
require "battle.cursor"
require "game"
require "vec2"


local mouse         = love.mouse
local event         = love.event
local floor         = math.floor
local ui            = ui
local game          = game
local vec2          = vec2
local combatlayout  = combatlayout

module "battle" do

  controller = ui.controller:new{
    cursor = cursor:new{}
  }

  function controller:screentotile (pos)
    local relpos = pos-self.layout.origin
    local focus = hexpos:new {}
    relpos = relpos.x/192*vec2:new{1,-1} + relpos.y/64*vec2:new{1,1}
    focus.i = floor(relpos.y+0.5)
    focus.j = floor(relpos.x+0.5)
    local x,y = relpos.x-focus.j+0.5, relpos.y-focus.i+0.5
    if y > 2*x + 0.5 or y > x/2 + 0.75 then
      if x + y < 1 then
        focus.j = focus.j-1
      else
        focus.i = focus.i+1
      end
    elseif x > 2*y + 0.5 or x > y/2 + 0.75 then
      if x + y < 1 then
        focus.i = focus.i-1
      else
        focus.j = focus.j+1
      end
    end
    return focus
  end

  function controller:mousetotile ()
    return self:screentotile(vec2:new{mouse.getPosition()})
  end

  function controller:update (dt)
    self.cursor:update(self:mousetotile(), dt)
  end

  function controller:mousereleased (button, pos)
    if button == 'l' then
      local focused = self:screentotile(pos)
      local tile    = layout.map:tile(focused)
      if tile then
        if layout.map.mode == "select" then
          layout.map.focus = tile.unit and focused or nil
          if layout.map.focus then
            layout.map.mode = "move"
          end
        elseif layout.map.mode == "move" then
          local targetpos = layout.map:moveunit()
          if targetpos then
            layout.map.focus = targetpos
            layout.map.mode = "action"
          end
        elseif layout.map.mode == "action" then
          layout.map.focus = nil
          layout.map.mode = "select"
        elseif layout.map.mode == "fight" then
          layout.map:startcombat()
          layout.map.focus = nil
          layout.map.mode = "select"
        end
      end
    elseif button == 'r' then
      layout.map.focus = nil
      layout.map.mode = "select"
    end
  end

  function controller.keyactions.released.escape ()
    event.push "quit"
  end

  controller.keyactions.released["return"] = function ()
    local attacker  = layout:focusedunit()
    local target    = layout:targetedunit()
    if not attacker or not target then return end
    if attacker:isdead() or target:isdead() then return end
    local distance  = layout.map:selectiondistance()
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
