
require "ui.layout"
require "battle.hexpos"
require "battle.controller"
require "battle.menu.unitaction"
require "battle.component.mapinterface"
require "battle.component.background"
require "vec2"

local mouse   = love.mouse
local ui      = ui
local vec2    = vec2
local print   = print
local unpack  = unpack

module "battle" do

  layout = ui.layout:new {
    map           = nil,
    origin        = vec2:new {512,100},
  }

  layout:addcomponent(component.background)
  layout:addcomponent(component.mapinterface)

  function layout:load (map, graphics)
    self:setcontroller(controller)
    self.map = map
    menu.unitaction.map = map
    component.background:load({map=map,layout=self}, graphics)
    component.mapinterface:load({map=map,layout=self}, graphics)
    self:addcomponent(menu.unitaction)
  end

  function layout:update (dt)
    if self.map.focus then
      local pos = self.origin + self.map.focus:tovec2()
      menu.unitaction.active = self:focusedunit() and self.map.mode == "action"
      if pos.x > 512 then
        pos.x = pos.x - menu.unitaction.size.x
      end
      if pos.y > 768/2 then
        pos.y = pos.y - menu.unitaction.size.y
      end
      menu.unitaction.pos = pos
    else
      menu.unitaction.active = false
    end
  end
  
  function layout:focusedunit ()
    return self.map:focusedtile().unit
  end

  function layout:targetedunit ()
    return self.map:tile(controller.cursor.pos).unit
  end

end
