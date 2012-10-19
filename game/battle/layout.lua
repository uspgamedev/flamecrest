
require "ui.layout"
require "battle.hexpos"
require "vec2"

local ui      = ui
local vec2    = vec2
local floor   = math.floor
local print   = print
local unpack  = unpack
local mouse   = love.mouse

module "battle" do

  layout = ui.layout:new {
    map           = nil,
    origin        = vec2:new {512,100},
    tileset       = {}
  }

  function layout:load (graphics)
    -- Load tileset images
    self.tileset.plains = graphics.newImage "resources/images/hextile.png"
    self.tileset.focus  = graphics.newImage "resources/images/focus.png"
    self.tileset.focus:setFilter("linear","linear")
    self.tileset.cursor  = graphics.newImage "resources/images/cursor.png"
    self.tileset.cursor:setFilter("linear","linear")
    -- Load drawing action functions
    function self.drawtileaction (i, j, tile)
      self:drawtile(i,j,tile,graphics)
    end
    function self.drawunitaction (i, j, tile)
      self:drawunit(i,j,tile,graphics)
    end
  end

  function layout:drawtile (i, j, tile, graphics)
    local pos   = vec2:new{96*j-96*i, 32*j+32*i}
    local image = self.tileset[tile.type]
    graphics.draw(image, pos.x, pos.y, 0, 1, 1, 64, 32)
  end

  function layout:drawunit (i, j, tile, graphics)
    local pos = vec2:new{96*j-96*i, 32*j+32*i}
    if tile.unit and not tile.unit:isdead() then
      graphics.draw(tile.unit.sprite, pos.x, pos.y, 0, 1, 1, 32, 85)
    end
  end

  function layout:drawmodifier (name, pos, graphics)
    local image = self.tileset[name]
    graphics.draw(image, pos.x, pos.y, 0, 1, 1, 64, 35)
  end
  
  function layout:draw (graphics)
    graphics.push()
    do
      graphics.translate(self.origin:get())
      self.map:pertile(self.drawtileaction)
      self:drawmodifier("focus", self.map.focus:tovec2(), graphics)
      self:drawmodifier("cursor", self.map.cursor.pos:tovec2(), graphics)
      self.map:pertile(self.drawunitaction)
    end
    graphics.pop()
    ui.layout.draw(self, graphics)
  end

  function layout:update (dt)
    self.map.cursor:update(dt)
  end

  function layout:gettile (pos)
    local relpos = pos-self.origin
    local focus = hexpos:new {}
    relpos = relpos.x/192*vec2:new{1,-1} + relpos.y/64*vec2:new{1,1}
    focus.i = floor(relpos.y+0.5)
    focus.j = floor(relpos.x+0.5)
    local x,y = relpos.x-focus.j+0.5, relpos.y-focus.i+0.5
    if y > 2*x + 0.5 or y > x/2 + 0.75 then
      if x + y < 1 then
        focus.j = focus.j-1
      else
        focus.i = focus.i+1
      end
    elseif x > 2*y + 0.5 or x > y/2 + 0.75 then
      if x + y < 1 then
        focus.i = focus.i-1
      else
        focus.j = focus.j+1
      end
    end
    return focus
  end

  function layout:focusedunit ()
    return self.map:focusedtile().unit
  end

  function layout:targetedunit ()
    return self.map:tile(self.map.cursor.pos).unit
  end

  function layout:released (button, pos)
    if button == 'l' then
      local focused = self:gettile(pos)
      local tile    = self.map:focusedtile()
      if tile then
        self.map.focus:set(focused:get())
      end
    end
  end
  
end
