require "unit"
require "combat"

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
  love.graphics.print("name: "..unit1.name, 100, 100)
  love.graphics.print("  lv: "..unit1.lv, 100, 120)
  love.graphics.print(" exp: "..unit1.exp, 100, 140)
  love.graphics.print("  hp: "..unit1.hp.."/"..unit1.maxhp, 100, 160)
  love.graphics.print(" str: "..unit1.str, 100, 180)
  love.graphics.print(" def: "..unit1.def, 100, 200)
  love.graphics.print(" spd: "..unit1.spd, 100, 220)
  love.graphics.print(" skl: "..unit1.skl, 100, 240)
  love.graphics.print(" lck: "..unit1.lck, 100, 260)


  love.graphics.print("name: "..unit2.name, 200, 100)
  love.graphics.print("  lv: "..unit2.lv, 200, 120)
  love.graphics.print(" exp: "..unit2.exp, 200, 140)
  love.graphics.print("  hp: "..unit2.hp.."/"..unit2.maxhp, 200, 160)
  love.graphics.print(" str: "..unit2.str, 200, 180)
  love.graphics.print(" def: "..unit2.def, 200, 200)
  love.graphics.print(" spd: "..unit2.spd, 200, 220)
  love.graphics.print(" skl: "..unit2.skl, 200, 240)
  love.graphics.print(" lck: "..unit2.lck, 200, 260)

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

