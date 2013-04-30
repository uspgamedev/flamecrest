
require "lux.table"
require "common.vec2"
require "ui.layout"
require "ui.component"
require "common.attributes"
require "model.combat.controller"

local ui          = ui
local vec2        = vec2
local attributes  = attributes
local math        = math

module "model.combat. do

  layout = ui.layout:new {
    margin = { left = 32, top = 96 },
    middle = 512 + 32
  }

  layout:setcontroller(controller)

  local function drawlabels (g, ox, oy)
    g.print("lv", ox, oy)
    g.print("exp", ox+128+8, oy+8)
    attributes.foreachattr(
      function (i, attr)
        g.print(attr, ox, oy+32*i)
      end
    )
    g.print("mt", ox+256, oy+64)
    g.print("hit", ox+256, oy+96)
    g.print("wgt", ox+256, oy+128)
    g.print("crt", ox+256, oy+160)
  end

  function layout:load (game)
    self.game = game
    self:placebuttons()
  end

  function layout:draw (g)
    -- draw lines of basic layout
    g.setColor { 50, 50, 50, 255 }
    g.line(32, 64, 1024-32, 64)
    g.line(512, 64, 512, 768-16)
    g.line(32, 768/2, 1024-32, 768/2)
    g.setColor { 255, 255, 255, 255 }
    -- draw button labels
    drawlabels(g, 32+16+40, 384+16)
    drawlabels(g, 512+16+40, 384+16)
    -- draw components
    layout:__super().draw(self, g)
  end

  function layout:inc (pos, obj, attrname, max)
    self:addbutton {
      text = "+",
      pos = pos,
      size = vec2:new { 16, 16 },
      action = function ()
        obj[attrname] = max and
          math.min(obj[attrname] + 1, max) or
          obj[attrname] + 1
      end
    }
  end

  function layout:dec (pos, obj, attrname, min)
    self:addbutton {
      text = "-",
      pos = pos,
      size = vec2:new { 16, 16 },
      action = function ()
        obj[attrname] = min and
  	      math.max(obj[attrname] - 1, min) or
          obj[attrname] - 1
        -- TODO this is ugly
        if attrname == "maxhp" then
          obj.hp = math.min(obj.hp, obj.maxhp)
        end
      end
    }
  end

  function layout:spinner (obj, pos, attrname, min, max)
    self:inc(pos+vec2:new{16,0}, obj, attrname, max)
    self:dec(pos, obj, attrname, min)
  end

  function layout:addunitbuttons (unit, offset)
    self:spinner(unit, offset, "lv", 1, 20)
    local function addspinner (i, attr)
      self:spinner(unit.attributes, offset+vec2:new{0,32+32*(i-1)}, attr, 0, 30)
      -- TODO: actually, luck's max is 40
    end
    attributes.foreachattr(addspinner)
    self:addbutton {
      text = "+30",
      pos = offset+vec2:new{128,0},
      size = vec2:new {40,16},
      action = function () unit:gainexp(30) end
    }
    self:addbutton {
      text = "reset",
      pos = offset+vec2:new{128,16},
      size = vec2:new {40,16},
      action = function () unit.exp = 0 end
    }
    self:addbutton {
      text = "heal",
      pos = offset+vec2:new{128,64},
      size = vec2:new {40,16},
      action = function () unit.hp = unit.attributes.maxhp end
    }
    self:spinner(unit.weapon, offset+vec2:new{256,64}, "mt")
    self:spinner(unit.weapon, offset+vec2:new{256,96}, "hit")
    self:spinner(unit.weapon, offset+vec2:new{256,128}, "wgt", 0)
    self:spinner(unit.weapon, offset+vec2:new{256,160}, "crt")
    self:addbutton {
      text = "change weapon",
      pos = offset+vec2:new {256,0},
      size = vec2:new {128,32},
      action = function () unit.weapon:nexttype() end
    }
  end

  function layout:placebuttons ()
    -- quit button
    self:addbutton {
      text = "QUIT",
      pos = vec2:new { 928, 16 },
      size = vec2:new { 64, 32 },
      action = function ()
        love.event.push "quit"
      end
    }
    -- reset all to initial state
    self:addbutton {
      text = "RESET ALL",
      pos = vec2:new { 32, 16 },
      size = vec2:new { 128, 32 },
      action = function () end
    }
    -- unit1 attacks unit2
    self:addbutton {
      text = "FIGHT >>>",
      pos = vec2:new { 512-16-128, 16 },
      size = vec2:new { 128, 32 },
      action = controller.keyactions.released.a
    }
    -- unit2 attacks unit1
    self:addbutton {
      text = "<<< FIGHT",
      pos = vec2:new { 512+16, 16 },
      size = vec2:new { 128, 32 },
      action = controller.keyactions.released.s
    }
    -- unit1 attacks unit2
    self:addbutton {
      text = "HEAL >>>",
      pos = vec2:new { 512-32-256, 16 },
      size = vec2:new { 128, 32 },
      action = controller.keyactions.released.q
    }
    -- unit2 attacks unit1
    self:addbutton {
      text = "<<< HEAL",
      pos = vec2:new { 512+32+128, 16 },
      size = vec2:new { 128, 32 },
      action = controller.keyactions.released.w
    }
    self:addunitbuttons(self.game.unit1, vec2:new{32+16, 384+16})
    self:addunitbuttons(self.game.unit2, vec2:new{512+16, 384+16})
  end

end
