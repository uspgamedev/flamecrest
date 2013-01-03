
local object    = require "lux.object"
local array     = require "lux.table"
local graphics  = love.graphics

module "ui.layout" do

  local components = array:new {}

  function addcomponent (component)
    components:insert(component)
  end

  local function drawcomponent (_, component)
    if component.active then
      -- store current graphics state
      local currentcolor = { graphics.getColor() }
      graphics.push()
      -- move to component's position and draw it
      graphics.translate(component.pos.x, component.pos.y)
      component:draw(graphics)
      -- restore previous graphics state
      graphics.pop()
      graphics.setColor(currentcolor)
    end
  end

  function draw ()
    self.components:foreach(drawcomponent)
  end

end
