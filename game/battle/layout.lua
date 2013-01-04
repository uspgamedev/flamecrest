
require "ui.layout"
require "ui.component"
require "battle.hexpos"
require "battle.controller"
require "battle.menu.unitaction"
require "battle.component.background"
require "battle.component.hud"
require "battle.component.foreground"
require "vec2"

local mouse   = love.mouse
local ui      = ui
local vec2    = vec2
local print   = print
local unpack  = unpack
local layout  = ui.layout

module "battle" do

  mapscene = ui.component:new {
    map     = nil,
    origin  = vec2:new {512,100},
    focus   = nil,
    mode    = "select"
  }

  function mapscene:load (graphics)
    component.background.load(graphics)
    component.hud.load(graphics)
    component.foreground.load()
  end

  function mapscene:setup (map, graphics)
    self.active         = true
    self.size:set(graphics.getWidth(), graphics.getHeight())
    self.map            = map
    menu.unitaction.map = map
    layout.add(menu.unitaction)
  end

  function mapscene:mousehover (pos, dt)
    controller.movecursor(self.map, self.origin, pos, dt)
  end

  function mapscene:mousereleased (pos, button)
    if button == 'l' then
      self.focus, self.mode = controller.confirm(self, pos)
    elseif button == 'r' then
      self.focus, self.mode = controller.cancel()
    end
  end

  function mapscene:update (dt)
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
  
  function mapscene:focusedunit ()
    return self.map:focusedtile().unit
  end

  function mapscene:targetedunit ()
    return self.map:tile(controller.cursor.pos).unit
  end

  function mapscene:draw (graphics)
    graphics.translate(self.origin:get())
    component.background.draw(self.map, graphics)
    component.hud.draw(self.map, self, cursor, graphics)
    component.foreground.draw(self.map, graphics)
  end

end
