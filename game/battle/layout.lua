
require "ui.layout"
require "battle.hexpos"
require "battle.controller"
require "battle.menu.unitaction"
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
    self:addcomponent(menu.unitaction)
    self.blueeffect = graphics.newPixelEffect [[
      vec4 effect (vec4 color, Image texture, vec2 tex_pos, vec2 pix_pos) {
        vec4 result = Texel(texture, tex_pos)*color;
        number bright = 0.8+0.2*distance(tex_pos, vec2(0.5, 0.5));
        return result.a*vec4(0.0, 0.0, bright, 0.6);
      }
    ]]
  end

  function layout:setmap (map)
    self.map = map
    menu.unitaction.map = map
  end

  function layout:drawtile (i, j, tile, graphics)
    local mappos  = hexpos:new{i,j}
    local pos     = mappos:tovec2()
    local image   = self.tileset[tile.type]
    graphics.draw(image, pos.x, pos.y, 0, 1, 1, 64, 32)
    if self.map.mode == "move" then
      local unit = self:focusedunit()
      if (self.map.focus - mappos):size() <= unit.attributes.mv then
        graphics.setPixelEffect(self.blueeffect)
        graphics.draw(image, pos.x, pos.y, 0, 1, 1, 64, 32)
        graphics.setPixelEffect()
      end
    end
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
  
  function layout:draw (graphics)
    graphics.push()
    do
      graphics.translate(self.origin:get())
      self.map:pertile(self.drawtileaction)
      if self.map.focus then
        self:drawmodifier("focus", self.map.focus:tovec2(), graphics)
      end
      if not menu.unitaction.active then
        self:drawmodifier("cursor", controller.cursor.pos:tovec2(), graphics)
      end
      self.map:pertile(self.drawunitaction)
    end
    graphics.pop()
    do
      local width = graphics.getFont():getWidth(self.map.mode)
      graphics.print(self.map.mode, 512-width/2, 0)
    end
    ui.layout.draw(self, graphics)
  end

  function layout:focusedunit ()
    return self.map:focusedtile().unit
  end

  function layout:targetedunit ()
    return self.map:tile(controller.cursor.pos).unit
  end

end
