
require "nova.table"
require "vec2"
require "unit"
require "combat"
require "weapon"
require "button"
require "layout"

math.randomseed( os.time() )

local unit1 = unit:new {
  name = "Juaum",
  maxhp = 20,
  str = 12,
  spd = 14,
  def = 6,
  lck = 0,
  weapon = weapon:new{
    weapontype = "lance"
  }
}

local unit2 = unit:new {
  name = "Leeroy",
  maxhp = 20,
  skl = 20,
  lck = 20,
  weapon = weapon:new {
    hit = 40
  }
}

local keyactions = {}

function keyactions.a ()
  if unit1:isdead() or unit2:isdead() then return end
  combat(unit1, unit2)
end

function keyactions.s ()
  if unit1:isdead() or unit2:isdead() then return end
  combat(unit2, unit1)
end

function keyactions.x ()
  unit1:gainexp(30)
end

function keyactions.c ()
  unit2:gainexp(30)
end

function love.load ()
  love.graphics.setFont(love.graphics.newFont("fonts/Verdana.ttf", 14))
end

function love.update (dt)
  -- NOTHING
end

function love.keypressed (key)
  -- NOTHING
end

function love.keyreleased (key)
  if keyactions[key] then
    keyactions[key]()
  end
end

function love.mousereleased (x, y, b)
  if b == "l" then
    button.check(layout.buttons, vec2:new {x, y})
  end
end

function love.draw()

  love.graphics.push()
  love.graphics.translate(100,100)
  unit1:draw()
  love.graphics.pop()
  
  love.graphics.push()
  love.graphics.translate(200,100)
  unit2:draw()
  love.graphics.pop()

  if (unit2:isdead()) then
     love.graphics.print("Winner!", 100, 80)
  end
  if (unit1:isdead()) then
     love.graphics.print("Winner!", 200, 80)
  end

  for _,v in pairs(layout.buttons) do
    v:draw()
  end

end

