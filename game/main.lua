
require "unit"
require "combat"

math.randomseed( os.time() )

local unit1 = {
  name = "Juaum",
  maxhp = 20,
  str = 12,
  spd = 14,
  def = 6
}

unit2 = {
  name = "Leeroy",
  maxhp = 20,
  skl = 20,
  lck = 20
}

local keyactions = {}

function keyactions.a ()
  combat(unit1, unit2)
end

function keyactions.x ()
  unit1:gainexp(30)
end

function keyactions.c ()
  unit2:gainexp(30)
end

function love.load()
  unit1 = unit:new(unit1)
  unit2 = unit:new(unit2)
end

function love.update(dt)
  -- NOTHING
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
end

function love.keypressed(key)
  -- NOTHING
end

function love.keyreleased(key)
  if keyactions[key] then
    keyactions[key]()
  end
end

