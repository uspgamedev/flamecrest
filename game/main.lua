
require "game"
require "ui.layout"
require "ui.mouse"
require "layout"
require "vec2"

math.randomseed( os.time() )

--local hextile, stickman
--local w,h = 6,8
--local man_pos = vec2:new {4,3}
local currentlayout = nil

function love.load ()
  love.graphics.setFont(love.graphics.newFont("fonts/Verdana.ttf", 14))
  currentlayout = game.battlelayout
  currentlayout:addcomponent(
    game.unit1:makedisplay(vec2:new{battlelayout.margin.left, battlelayout.margin.top})
  )
  currentlayout:addcomponent(
    game.unit2:makedisplay(vec2:new{battlelayout.middle, battlelayout.margin.top})
  )
  --hextile = love.graphics.newImage "resources/images/hextile-border.png"
  --stickman = love.graphics.newImage "resources/images/stick-man.png"
end

function love.update (dt)
  -- NOTHING
end

function love.keypressed (key)
  -- NOTHING
end

function love.keyreleased (key)
  if game.keyactions[key] then
    game.keyactions[key]()
  end
end

function love.mousereleased (x, y, button)
  ui.mouse.release(currentlayout, button, vec2:new{x,y})
end

local origin = vec2:new {100, 50}
local tilesize = vec2:new {128, 64}

function love.draw()
  currentlayout:draw(love.graphics)
  --love.graphics.setBackgroundColor(180,120,40)
  --for i=1,w do
  --  for j=1,h do
  --    local pos = origin + vec2:new{96*i,63*j+32*i}
  --    love.graphics.draw(hextile, pos.x, pos.y, 0, 1, 1, tilesize.x/2, tilesize.y/2)
  --  end
  --end
  --local final_pos = origin + vec2:new{96*man_pos.x, 63*man_pos.y+32*man_pos.x}
  --love.graphics.draw(stickman, final_pos.x, final_pos.y, 0, 1, 1, 32, 84)
end

