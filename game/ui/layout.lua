
local object    = require "lux.object"
local array     = require "lux.table"
local graphics  = love.graphics

module "ui.layout" do

  local components    = array:new {}
  local reverseindex  = {}

  function add (component)
    components:insert(component)
    reverseindex[component] = #components
  end

  function remove (component)
    assert(component, "Cannot remove nil component.")
    components:removecomponent(reverseindex[component])
    reverseindex[component] = nil
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
