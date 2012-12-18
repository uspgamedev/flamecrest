
require "vec2"
require "ui.component"
require "battle.hexpos"

local vec2    = vec2
local ui      = ui
local hexpos  = battle.hexpos

module "battle.component"

foreground = ui.component:new {
  pos = vec2:new{0,0}
}

function foreground:load (context, graphics)
  self.size = vec2:new{graphics.getWidth(), graphics.getHeight()}
  function self:draw (graphics)
    self:do_draw(context, graphics)
  end
end

local function drawunit (pos, tile, graphics)
  if tile.unit and not tile.unit:isdead() then
    graphics.draw(tile.unit.sprite, pos.x, pos.y, 0, 1, 1, 32, 85)
  end
end

function foreground:do_draw (context, graphics)
  graphics.translate(context.layout.origin:get())
  context.map:pertile(
    function (i, j, tile)
      drawunit(hexpos:new{i,j}:tovec2(), tile, graphics)
    end
  )
end
