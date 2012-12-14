
require "vec2"
require "battle.hexpos"
require "ui.component"

local vec2   = vec2
local ui     = ui
local hexpos = battle.hexpos

module "battle.component"

mapinterface = ui.component:new {
  pos     = vec2:new{0,0},
  tileset = {}
}

function mapinterface:load (context, graphics)
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
  self.moveglow = graphics.newPixelEffect [[
    vec4 effect (vec4 color, Image texture, vec2 tex_pos, vec2 pix_pos) {
      vec4 result = Texel(texture, tex_pos)*color;
      number bright = 0.8+0.2*distance(tex_pos, vec2(0.5, 0.5));
      return result.a*vec4(0.0, 0.0, bright, 0.6);
    }
  ]]
  self.atkglow = graphics.newPixelEffect [[
    vec4 effect (vec4 color, Image texture, vec2 tex_pos, vec2 pix_pos) {
      vec4 result = Texel(texture, tex_pos)*color;
      number bright = 0.8+0.2*distance(tex_pos, vec2(0.5, 0.5));
      return result.a*vec4(bright, bright/2.0, 0.0, 0.6);
    }
  ]]
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
  if context.map.mode == "move" then
    -- TODO really reachable tiles
    local unit = context.layout:focusedunit()
    local dist = (context.map.focus - mappos):size()
    local haseffect = false
    local mvrange = unit.attributes.mv
    if dist <= mvrange then
      graphics.setPixelEffect(mapinterface.moveglow)
      haseffect = true
    elseif unit.weapon and dist <= mvrange + unit.weapon.maxrange then
      graphics.setPixelEffect(mapinterface.atkglow)
      haseffect = true
    end
    if haseffect then
      graphics.draw(image, pos.x, pos.y, 0, 1, 1, 64, 32)
      graphics.setPixelEffect()
    end
  end
end

function mapinterface:do_draw (context, graphics)
  graphics.push()
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
  graphics.pop()
end
