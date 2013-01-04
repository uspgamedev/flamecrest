
require "vec2"
require "ui.component"
require "battle.hexpos"
require "battle.controller"
require "battle.cursor"
require "battle.menu.unitaction"

local string      = string
local vec2        = vec2
local ui          = ui
local hexpos      = battle.hexpos
local cursor      = battle.cursor
local unitmenu    = battle.menu.unitaction
local controller  = battle.controller

module "battle.component.hud"

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
  return graphics.newPixelEffect(string.format(markereffectcode, r, g, b))
end

function load (graphics)
  -- Load spriteset images
  spriteset.marker = graphics.newImage "resources/images/hextile-empty.png"
  spriteset.focus  = graphics.newImage "resources/images/focus.png"
  spriteset.focus:setFilter("linear","linear")
  spriteset.cursor = graphics.newImage "resources/images/cursor.png"
  spriteset.cursor:setFilter("linear","linear")
  moveglow         = makemarkereffect(graphics, 0, 0, 1)
  atkglow          = makemarkereffect(graphics, 1, 0.5, 0)
end

local function drawmarker (mappos, focus, unit, graphics)
  local pos = mappos:tovec2()
  -- TODO really reachable tiles
  local dist = (focus - mappos):size()
  local haseffect = false
  local mvrange = unit.attributes.mv
  if dist <= mvrange then
    graphics.setPixelEffect(hud.moveglow)
    haseffect = true
  elseif unit.weapon and dist <= mvrange + unit.weapon.maxrange then
    graphics.setPixelEffect(hud.atkglow)
    haseffect = true
  end
  if haseffect then
    graphics.draw(hud.spriteset.marker, pos.x, pos.y, 0, 1, 1, 64, 32)
    graphics.setPixelEffect()
  end
end

local function drawmodifier (name, pos, graphics)
  local image = spriteset[name]
  graphics.draw(image, pos.x, pos.y, 0, 1, 1, 64, 35)
end

function draw (map, layout, cursor, graphics)
  if map.mode == "move" then
    map:pertile(
      function (i, j, tile)
        drawmarker(hexpos:new{i,j}, map.focus, layout:focusedunit(), graphics)
      end
    )
  end
  if map.focus then
    drawmodifier("focus", map.focus:tovec2(), graphics)
  end
  if not unitmenu.active then
    drawmodifier("cursor", cursor.pos():tovec2(), graphics)
  end
end
