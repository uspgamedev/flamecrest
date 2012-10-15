
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
    map     = nil,
    origin  = vec2:new {512,100},
    focus   = hexpos:new{1,1},
    target  = hexpos:new{2,2},
    tileset = {}
  }

  function layout:load (graphics)
    self.tileset.plains = graphics.newImage "resources/images/hextile.png"
    self.tileset.focus  = graphics.newImage "resources/images/focus.png"
    self.tileset.focus:setFilter("linear","linear")
    self.tileset.cursor  = graphics.newImage "resources/images/cursor.png"
    self.tileset.cursor:setFilter("linear","linear")
  end
  
  function layout:draw (graphics)
    graphics.push()
    graphics.translate(self.origin.x, self.origin.y)
    for i = 1,self.map.height do
      for j = 1,self.map.width do
        local tile  = self.map.tiles[i][j]
        if tile then
          local pos         = vec2:new{96*j-96*i, 32*j+32*i}
          local image       = self.tileset[tile.type]
          local focusimage  = self.tileset.focus
          local cursorimage = self.tileset.cursor
          graphics.draw(image, pos.x, pos.y, 0, 1, 1, 64, 32)
          if i == self.focus.i and j == self.focus.j then
            graphics.draw(focusimage, pos.x, pos.y, 0, 1, 1, 64, 35)
          end
          if i == self.target.i and j == self.target.j then
            graphics.draw(cursorimage, pos.x, pos.y, 0, 1, 1, 64, 35)
          end
          if tile.unit and not tile.unit:isdead() then
            graphics.draw(tile.unit.sprite, pos.x, pos.y, 0, 1, 1, 32, 85)
          end
        end
      end
    end
    graphics.pop()
    ui.layout.draw(self, graphics)
  end

  function layout:update (dt)
    local focused = self:gettile(vec2:new{mouse.getPosition()})
    if self.map:tile(focused) then
      self.focus:set(focused:get())
    end
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
    return self.map:tile(self.focus).unit
  end

  function layout:targetedunit ()
    return self.map:tile(self.target).unit
  end

  function layout:selectiondistance ()
    return (self.target - self.focus):size()
  end

  function layout:released (button, pos)
    if button == 'l' then
      --local selected = self:gettile(pos)
      --if self.map:tile(selected) then
      --  self.focus:set(selected:get())
      --end
    elseif button == 'r' then
      local selected = self:gettile(pos)
      if self.map:tile(selected) then
        self.target:set(selected:get())
      end
    end
  end

  --local final_pos = origin + vec2:new{96*man_pos.x, 63*man_pos.y+32*man_pos.x}
  --love.graphics.draw(stickman, final_pos.x, final_pos.y, 0, 1, 1, 32, 84)
  
end
