
require "ui.layout"
require "battle.hexpos"
require "battle.controller"
require "battle.menu.unit"
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
    tileset       = {}
  }

  function layout:load (graphics)
    self:setcontroller(controller)
    -- Load tileset images
    self.tileset.plains = graphics.newImage "resources/images/hextile.png"
    self.tileset.focus  = graphics.newImage "resources/images/focus.png"
    self.tileset.focus:setFilter("linear","linear")
    self.tileset.cursor  = graphics.newImage "resources/images/cursor.png"
    self.tileset.cursor:setFilter("linear","linear")
    -- Load drawing action functions
    function self.drawtileaction (i, j, tile)
      self:drawtile(i,j,tile,graphics)
    end
    function self.drawunitaction (i, j, tile)
      self:drawunit(i,j,tile,graphics)
    end
    self:addcomponent(menu.unit)
  end

  function layout:setmap (map)
    self.map = map
    menu.unit.map = map
  end

  function layout:drawtile (i, j, tile, graphics)
    local pos   = hexpos:new{i,j}:tovec2()
    local image = self.tileset[tile.type]
    graphics.draw(image, pos.x, pos.y, 0, 1, 1, 64, 32)
  end

  function layout:drawunit (i, j, tile, graphics)
    local pos = hexpos:new{i,j}:tovec2()
    if tile.unit and not tile.unit:isdead() then
      graphics.draw(tile.unit.sprite, pos.x, pos.y, 0, 1, 1, 32, 85)
    end
  end

  function layout:drawmodifier (name, pos, graphics)
    local image = self.tileset[name]
    graphics.draw(image, pos.x, pos.y, 0, 1, 1, 64, 35)
  end

  function layout:update (dt)
    if self.map.focus then
      local pos = self.origin + self.map.focus:tovec2()
      menu.unit.active = self:focusedunit() and self.map.mode == "select"
      if pos.x > 512 then
        pos.x = pos.x - menu.unit.size.x
      end
      if pos.y > 768/2 then
        pos.y = pos.y - menu.unit.size.y
      end
      menu.unit.pos = pos
    else
      menu.unit.active = false
    end
  end
  
  function layout:draw (graphics)
    graphics.push()
    do
      graphics.translate(self.origin:get())
      self.map:pertile(self.drawtileaction)
      if self.map.focus then
        self:drawmodifier("focus", self.map.focus:tovec2(), graphics)
      end
      if not menu.unit.active then
        self:drawmodifier("cursor", controller.cursor.pos:tovec2(), graphics)
      end
      self.map:pertile(self.drawunitaction)
    end
    graphics.pop()
    ui.layout.draw(self, graphics)
  end

  function layout:focusedunit ()
    return self.map:focusedtile().unit
  end

  function layout:targetedunit ()
    return self.map:tile(controller.cursor.pos).unit
  end

end
