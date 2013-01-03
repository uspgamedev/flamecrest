
local object    = require "lux.object"
local array     = require "lux.table"
local graphics  = love.graphics
local ipairs    = ipairs

module "ui.layout" do

  --[[ Component management ]]--

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

  --[[ Component events ]]--

  function updateevent (dt)
    for _,component in ipairs(components) do
        if component.active then component:update(dt) end
    end
  end

  function mouseevent (type, pos, info)
    for i = #components,1,-1 do
      local component = components[i]
      if component.active and component:inside(pos) and component[type] then
        component[type] (component, pos-component.pos, info)
        return
      end
    end
  end

  --[[ Component drawing ]]--

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
