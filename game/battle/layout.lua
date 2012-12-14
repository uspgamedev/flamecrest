
require "ui.layout"
require "battle.hexpos"
require "battle.controller"
require "battle.menu.unitaction"
require "battle.component.mapinterface"
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

  layout:addcomponent(component.mapinterface)

  function layout:load (map, graphics)
    self:setcontroller(controller)
    self.map = map
    menu.unitaction.map = map
    component.mapinterface:load({map=map,layout=self}, graphics)
    --function self.drawunitaction (i, j, tile)
    --  self:drawunit(i,j,tile,graphics)
    --end
    self:addcomponent(menu.unitaction)
  end

  --function layout:drawunit (i, j, tile, graphics)
  --  local pos = hexpos:new{i,j}:tovec2()
  --  if tile.unit and not tile.unit:isdead() then
  --    graphics.draw(tile.unit.sprite, pos.x, pos.y, 0, 1, 1, 32, 85)
  --  end
  --end

  --function layout:drawmodifier (name, pos, graphics)
  --  local image = self.tileset[name]
  --  graphics.draw(image, pos.x, pos.y, 0, 1, 1, 64, 35)
  --end

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
  
  --function layout:draw (graphics)
  --  graphics.push()
  --  do
  --    graphics.translate(self.origin:get())
  --    self.map:pertile(self.drawtileaction)
  --    if self.map.focus then
  --      self:drawmodifier("focus", self.map.focus:tovec2(), graphics)
  --    end
  --    if not menu.unitaction.active then
  --      self:drawmodifier("cursor", controller.cursor.pos:tovec2(), graphics)
  --    end
  --    self.map:pertile(self.drawunitaction)
  --  end
  --  graphics.pop()
  --  do
  --    local width = graphics.getFont():getWidth(self.map.mode)
  --    graphics.print(self.map.mode, 512-width/2, 0)
  --  end
  --  ui.layout.draw(self, graphics)
  --end

  function layout:focusedunit ()
    return self.map:focusedtile().unit
  end

  function layout:targetedunit ()
    return self.map:tile(controller.cursor.pos).unit
  end

end
