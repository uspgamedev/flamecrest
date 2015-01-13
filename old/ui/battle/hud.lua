
module ("ui.battle.hud", package.seeall) do

  require 'model.battle.hexpos'
  require 'ui.battle.cursor'
  require 'ui.battle.unitmenu'

  local string      = string
  local vec2        = require 'lux.geom.Vector'
  local hexpos      = model.battle.hexpos
  local cursor      = ui,model.battle.cursor
  local unitmenu    = ui,model.battle.unitmenu

  local spriteset = {}
  local markereffectcode = [[
    vec4 effect (vec4 color, Image texture, vec2 tex_pos, vec2 pix_pos) {
      vec4 result = Texel(texture, tex_pos)*color;
      number bright = 0.7+0.3*distance(tex_pos, vec2(0.5, 0.5));
      return result.a*vec4(bright*%f, bright*%f, bright*%f, 0.6);
    }
  ]]
  local moveglow, atkglow

  local function makemarkereffect (graphics, r, g, b)
    return graphics.newShader(string.format(markereffectcode, r, g, b))
  end

  function load (graphics)
    -- Load spriteset images
    spriteset.marker = graphics.newImage "resources/images/hextile-empty.png"
    spriteset.focus  = graphics.newImage "resources/images/focus.png"
    spriteset.focus:setFilter("linear","linear")
    spriteset.cursor = graphics.newImage "resources/images/cursor.png"
    spriteset.cursor:setFilter("linear","linear")
    moveglow         = makemarkereffect(graphics, 0, 0, 1)
    atkglow          = makemarkereffect(graphics, 0.8, 0.1, 0)
  end

  local function drawmarker (mappos, focus, graphics, condition)
    local pos = mappos:tovec2()
    -- TODO really reachable tiles
    local dist = (focus - mappos):size()
    local effect = condition(dist, mappos)
    if effect then
      graphics.setShader(effect)
      graphics.draw(spriteset.marker, pos.x, pos.y, 0, 1, 1, 64, 32)
      graphics.setShader()
    end
  end

  local function drawmodifier (name, pos, graphics)
    local image = spriteset[name]
    graphics.draw(image, pos.x, pos.y, 0, 1, 1, 64, 35)
  end

  function draw (map, mapscene, cursor, graphics)
    if mapscene.mode == "move" then
      map:pertile(function (i, j, tile)
        drawmarker(
          hexpos:new{i,j},
          mapscene.focus,
          graphics,
          function (dist, mappos)
            local unit = mapscene:focusedunit()
            local mvrange = unit.attributes.mv
            local pathdist = mapscene.focus.paths[mappos.i][mappos.j]
            if pathdist and pathdist <= mvrange then
              return moveglow
            elseif unit.weapon and (pathdist == nil or pathdist > mvrange) then
              local maxrange = unit.weapon.maxrange
              local minrange = unit.weapon.minrange
              for i = mappos.i - maxrange, mappos.i + maxrange do
                for j = mappos.j - maxrange, mappos.j + maxrange do
                  local atkdist
                  if mapscene.focus.paths[i] and mapscene.focus.paths[i][j] then
                    atkdist = mapscene.focus.paths[i][j]
                  end
                  local pos = hexpos:new{i, j}
                  rngdist = (pos - mappos):size()
                  if atkdist and atkdist <= mvrange and rngdist <= maxrange and
                     rngdist >= minrange then
                    return atkglow
                  end
                end
              end
            end
            return nil
          end
        )
      end)
    end
    if mapscene.focus then
      if mapscene.mode == "fight" then
        map:pertile(function (i, j, tile)
          drawmarker(hexpos:new{i,j}, mapscene.focus, graphics,
            function (dist)
              local unit = mapscene:focusedunit()
              -- TODO there is a function that does this already?
              if unit.weapon and dist <= unit.weapon.maxrange
                             and dist >= unit.weapon.minrange then
                return atkglow
              end
              return nil
            end
          )
        end)
      end
      drawmodifier("focus", mapscene.focus:tovec2(), graphics)
    end
    if not unitmenu.active then
      drawmodifier("cursor", cursor.pos():tovec2(), graphics)
    end
  end

end
