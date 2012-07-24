
require "nova.table"
require "vec2"
require "button"
require "game"

module ("layout", package.seeall) do

  top = 96
  left = 32
  middle = 512 + 32

  local function drawlabels (g, ox, oy)
    g.print("lv", ox, oy)
    g.print("exp", ox+128+8, oy+8)
    unit.foreachattr(
      function (i, attr)
        g.print(attr, ox, oy+32*i)
      end
    )
  end

  function draw (g)

    -- draw lines of basic layout
    g.setColor { 50, 50, 50, 255 }
    g.line(32, 64, 1024-32, 64)
    g.line(512, 64, 512, 768-16)
    g.line(32, 768/2, 1024-32, 768/2)
    g.setColor { 255, 255, 255, 255 }

    -- draw button labels
    drawlabels(g, 32+16+40, 384+16)
    drawlabels(g, 512+16+40, 384+16)

    -- draw buttons
    for _,v in pairs(buttons) do
      v:draw()
    end

  end

  buttons = nova.table:new {
    -- quit button
    button:new {
      text = "QUIT",
      pos = vec2:new { 928, 16 },
      size = vec2:new { 64, 32 },
      action = function () love.event.push "quit" end
    },
    -- reset all to initial state
    button:new {
      text = "RESET ALL",
      pos = vec2:new { 32, 16 },
      size = vec2:new { 128, 32 },
      action = function () end
    },
    -- unit1 attacks unit2
    button:new {
      text = "FIGHT >>>",
      pos = vec2:new { 512-16-128, 16 },
      size = vec2:new { 128, 32 },
      action = game.keyactions.a
    },
    -- unit2 attacks unit1
    button:new {
      text = "<<< FIGHT",
      pos = vec2:new { 512+16, 16 },
      size = vec2:new { 128, 32 },
      action = game.keyactions.s
    },
  }

  local function inc (pos, unit, attrname, max)
    return button:new {
      text = "+",
      pos = pos,
      size = vec2:new { 16, 16 },
      action = function ()
        unit[attrname] = math.min(unit[attrname] + 1, max)
      end
    }
  end

  local function dec (pos, unit, attrname, min)
    return button:new {
      text = "-",
      pos = pos,
      size = vec2:new { 16, 16 },
      action = function ()
        unit[attrname] = math.max(unit[attrname] - 1, min)
        if attrname == "maxhp" then
          unit.hp = math.min(unit.hp, unit.maxhp)
        end
      end
    }
  end

  local function spinner (unit, pos, attrname, min, max)
    buttons:insert(inc(pos+vec2:new{16,0}, unit, attrname, max))
    buttons:insert(dec(pos, unit, attrname, min))
  end

  local function addunitbuttons (unit, offset)
    spinner(unit, offset, "lv", 1, 20)
    buttons:insert(
      button:new {
        text = "+30",
        pos = offset+vec2:new{128,0},
        size = vec2:new { 40, 16 },
        action = function () unit:gainexp(30) end
      }
    )
    buttons:insert(
      button:new {
        text = "reset",
        pos = offset+vec2:new{128,16},
        size = vec2:new { 40, 16 },
        action = function () unit.exp = 0 end
      }
    )
    local function addspinner (i, attr)
      spinner(unit, offset+vec2:new{0,32+32*(i-1)}, attr, 0, 30)
      -- TODO: actually, luck's max is 40
    end
    unit.foreachattr(addspinner)
  end

  addunitbuttons(game.unit1, vec2:new{32+16, 384+16})
  addunitbuttons(game.unit2, vec2:new{512+16, 384+16})

end

