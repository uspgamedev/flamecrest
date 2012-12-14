
require "vec2"
require "battle.hexpos"
require "ui.component"

local vec2   = vec2
local ui     = ui
local hexpos = battle.hexpos

module "battle.component"

tiles = ui.component:new {
  pos     = vec2:new{0,0},
  tileset = {}
}

local function drawtile (i, j, tile, graphics)
  local mappos  = hexpos:new{i,j}
  local pos     = mappos:tovec2()
  local image   = tiles.tileset[tile.type]
  graphics.draw(
    image,
    pos.x, pos.y,
    0,
    1, 1,
    image:getWidth()/2, image:getHeight()-32 --TODO MAGIC NUMBER
  )
end

function tiles:load (context, graphics)
  self.size = vec2:new{graphics.getWidth(), graphics.getHeight()}
  -- Load tileset images
  self.tileset.plains = graphics.newImage "resources/images/hextile.png"
  self.tileset.focus  = graphics.newImage "resources/images/focus.png"
  self.tileset.focus:setFilter("linear","linear")
  self.tileset.cursor = graphics.newImage "resources/images/cursor.png"
  self.tileset.cursor:setFilter("linear","linear")
  function self:draw (graphics)
    self:do_draw(context, graphics)
  end
end

function tiles:do_draw (context, graphics)
  graphics.push()
  graphics.translate(context.layout.origin:get())
  context.map:pertile(function (i, j, tile) drawtile(i,j,tile,graphics) end)
  graphics.pop()
end
