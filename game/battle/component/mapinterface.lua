
require "vec2"
require "ui.component"
require "battle.hexpos"
require "battle.controller"
require "battle.menu.unitaction"

local vec2        = vec2
local ui          = ui
local hexpos      = battle.hexpos
local unitmenu    = battle.menu.unitaction
local controller  = battle.controller

module "battle.component"

mapinterface = ui.component:new {
  pos     = vec2:new{0,0},
  tileset = {}
}

function mapinterface:load (context, graphics)
  self.size = vec2:new{graphics.getWidth(), graphics.getHeight()}
  -- Load tileset images
  self.tileset.focus  = graphics.newImage "resources/images/focus.png"
  self.tileset.focus:setFilter("linear","linear")
  self.tileset.cursor = graphics.newImage "resources/images/cursor.png"
  self.tileset.cursor:setFilter("linear","linear")
  function self:draw (graphics)
    self:do_draw(context, graphics)
  end
end

local function drawunit (pos, tile, graphics)
  if tile.unit and not tile.unit:isdead() then
    graphics.draw(tile.unit.sprite, pos.x, pos.y, 0, 1, 1, 32, 85)
  end
end

local function drawmodifier (name, pos, graphics)
  local image = mapinterface.tileset[name]
  graphics.draw(image, pos.x, pos.y, 0, 1, 1, 64, 35)
end

function mapinterface:do_draw (context, graphics)
  graphics.push()
  graphics.translate(context.layout.origin:get())
  if context.map.focus then
    drawmodifier("focus", context.map.focus:tovec2(), graphics)
  end
  if not unitmenu.active then
    drawmodifier("cursor", controller.cursor.pos:tovec2(), graphics)
  end
  context.map:pertile(
    function (i, j, tile)
      drawunit(hexpos:new{i,j}:tovec2(), tile, graphics)
    end
  )
  graphics.pop()
end
