
module ("ui.battle.background", package.seeall) do

  require "vec2"
  require "battle.hexpos"

  local vec2    = vec2
  local hexpos  = battle.hexpos

  local tileset = {}

  function load (graphics)
    -- Load tileset images
    tileset.plains = graphics.newImage "resources/images/hextile.png"
    tileset.forest = graphics.newImage "resources/images/hextile2.png"
  end

  local function drawtile (pos, image, graphics)
    graphics.draw(
      image,
      pos.x, pos.y,
      0,
      1, 1,
      image:getWidth()/2, image:getHeight()-32 --TODO MAGIC NUMBER
    )
  end

  function draw (map, graphics)
    map:pertile(
      function (i, j, tile)
        drawtile(hexpos:new{i,j}:tovec2(), tileset[tile.type], graphics)
      end
    )
  end

<<<<<<< HEAD
function draw (map, graphics)
  map:pertile(
    function (i, j, tile)
      drawtile(hexpos:new{i,j}:tovec2(), tileset[tile.type.type], graphics) --TODO: Arrumar tie para nao precisar desse tile.type.type
    end
  )
=======
>>>>>>> Cleaned ui.battle.* up.
end
