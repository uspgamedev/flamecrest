
module ("ui.battle.foreground", package.seeall) do

  require "common.vec2"
  require "model.battle.hexpos"

  local vec2    = vec2
  local hexpos  = model.battle.hexpos

  function load (graphics)
    -- Nothing... for now?
  end

  local function drawunit (pos, tile, graphics)
    if tile.unit and not tile.unit:isdead() then
      local sprite = tile.unit.sprite
      graphics.draw(
        sprite,
        pos.x, pos.y,
        0,
        64/sprite:getWidth(), 96/sprite:getHeight(),
        sprite:getWidth()/2, sprite:getHeight() - 40)
    end
  end

  function draw (map, graphics)
    map:pertile(
      function (i, j, tile)
        drawunit(hexpos:new{i,j}:tovec2(), tile, graphics)
      end
    )
  end

end
