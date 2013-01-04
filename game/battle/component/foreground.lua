
require "vec2"
require "battle.hexpos"

local vec2    = vec2
local hexpos  = battle.hexpos

module "battle.component.foreground"

function load (graphics)
  -- Nothing... for now?
end

local function drawunit (pos, tile, graphics)
  if tile.unit and not tile.unit:isdead() then
    graphics.draw(tile.unit.sprite, pos.x, pos.y, 0, 1, 1, 32, 85)
  end
end

function draw (map, graphics)
  map:pertile(
    function (i, j, tile)
      drawunit(hexpos:new{i,j}:tovec2(), tile, graphics)
    end
  )
end
