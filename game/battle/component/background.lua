
require "vec2"
require "ui.component"
require "battle.hexpos"

local vec2    = vec2
local ui      = ui
local hexpos  = battle.hexpos

module "battle.component"

background = ui.component:new {
  pos     = vec2:new{0,0},
  tileset = {}
}

function background:load (context, graphics)
  self.size = vec2:new{graphics.getWidth(), graphics.getHeight()}
  -- Load tileset images
  self.tileset.plains = graphics.newImage "resources/images/hextile.png"
  function self:draw (graphics)
    self:do_draw(context, graphics)
  end
end

local function drawtile (mappos, image, context, graphics)
  local pos = mappos:tovec2()
  graphics.draw(
    image,
    pos.x, pos.y,
    0,
    1, 1,
    image:getWidth()/2, image:getHeight()-32 --TODO MAGIC NUMBER
  )
end

function background:do_draw (context, graphics)
  graphics.translate(context.layout.origin:get())
  context.map:pertile(
    function (i, j, tile)
      drawtile(
        hexpos:new{i,j},
        self.tileset[tile.type],
        context,
        graphics
      )
    end
  )
end
