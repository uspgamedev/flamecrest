
require "vec2"
require "ui.component"
require "battle.hexpos"
require "battle.controller"
require "battle.menu.unitaction"

local string      = string
local vec2        = vec2
local ui          = ui
local hexpos      = battle.hexpos
local unitmenu    = battle.menu.unitaction
local controller  = battle.controller

module "battle.component"

hud = ui.component:new {
  pos     = vec2:new{0,0},
  spriteset = {}
}

local markereffectcode = [[
  vec4 effect (vec4 color, Image texture, vec2 tex_pos, vec2 pix_pos) {
    vec4 result = Texel(texture, tex_pos)*color;
    number bright = 0.8+0.2*distance(tex_pos, vec2(0.5, 0.5));
    return result.a*vec4(bright*%f, bright*%f, bright*%f, 0.6);
  }
]]

local function makemarkereffect (graphics, r, g, b)
  return graphics.newPixelEffect(string.format(markereffectcode, r, g, b))
end

function hud:load (context, graphics)
  self.size = vec2:new{graphics.getWidth(), graphics.getHeight()}
  -- Load spriteset images
  self.spriteset.marker = graphics.newImage "resources/images/hextile-empty.png"
  self.spriteset.focus  = graphics.newImage "resources/images/focus.png"
  self.spriteset.focus:setFilter("linear","linear")
  self.spriteset.cursor = graphics.newImage "resources/images/cursor.png"
  self.spriteset.cursor:setFilter("linear","linear")
  function self:draw (graphics)
    self:do_draw(context, graphics)
  end
  self.moveglow = makemarkereffect(graphics, 0, 0, 1)
  self.atkglow = makemarkereffect(graphics, 1, 0.5, 0)
end

local function drawmarker (mappos, context, graphics)
  local pos = mappos:tovec2()
  -- TODO really reachable tiles
  local unit = context.layout:focusedunit()
  local dist = (context.map.focus - mappos):size()
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
  local image = hud.spriteset[name]
  graphics.draw(image, pos.x, pos.y, 0, 1, 1, 64, 35)
end

function hud:do_draw (context, graphics)
  graphics.translate(context.layout.origin:get())
  if context.map.mode == "move" then
    context.map:pertile(
      function (i, j, tile)
        drawmarker(
          hexpos:new{i,j},
          context,
          graphics
        )
      end
    )
  end
  if context.map.focus then
    drawmodifier("focus", context.map.focus:tovec2(), graphics)
  end
  if not unitmenu.active then
    drawmodifier("cursor", controller.cursor.pos:tovec2(), graphics)
  end
end
