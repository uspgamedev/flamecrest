require "unit"
require "combat"

local unit1 = {
  name = "Juaum",
  hp = 20,
  str = 12,
  spd = 14,
  def = 6
}

unit2 = {
  name = "Leeroy",
  hp = 20,
  skl = 20,
  lck = 20
}

local keypressed = false
local lastframekeypressed = false

function love.load()
  unit1 = unit:new(unit1)
  unit2 = unit:new(unit2)
end

function love.update(dt)
  if (keypressed and not lastframekeypressed) then
    if (not unit:isdead() or not unit2:isdead()) then
      combat(unit1, unit2)
    end
  end
  lastframekeypressed = keypressed
end

function love.draw()
  love.graphics.print(unit1.name, 100, 100)
  love.graphics.print(unit1.hp, 100, 120)
  love.graphics.print(unit1.str, 100, 140)
  love.graphics.print(unit1.def, 100, 160)
  love.graphics.print(unit1.spd, 100, 180)
  love.graphics.print(unit1.skl, 100, 200)
  love.graphics.print(unit1.lck, 100, 220)

  love.graphics.print(unit2.name, 200, 100)
  love.graphics.print(unit2.hp, 200, 120)
  love.graphics.print(unit2.str, 200, 140)
  love.graphics.print(unit2.def, 200, 160)
  love.graphics.print(unit2.spd, 200, 180)
  love.graphics.print(unit2.skl, 200, 200)
  love.graphics.print(unit2.lck, 200, 220)

  if (unit2:isdead()) then
     love.graphics.print("Winner!", 100, 80)
  end
  if (unit1:isdead()) then
     love.graphics.print("Winner!", 200, 80)
  end
end

function love.keypressed(key)
  keypressed = true
end

function love.keyreleased(key)
  keypressed = false
end