
local object    = require "lux.object"
local array     = require "lux.table"
local graphics  = love.graphics
local ipairs    = ipairs
local print     = print

--- Module that manages the game layout.
module "ui.layout" do

  --[[ Component management ]]--

  local components    = array:new {}
  local reverseindex  = {}

  --- Adds a component to the layout.
  -- Nothing happens if the component is currently in the layout.
  -- @param component The added component. Cannot be <code>nil</code>.
  function add (component)
    if reverseindex[component] then return end
    components:insert(component)
    reverseindex[component] = #components
  end

  --- Removes a component from the layout.
  -- Nothing happens if the component is not curently in the layout.
  -- @param component The removed component. Cannot be <code>nil</code>
  function remove (component)
    assert(component, "Cannot remove nil component.")
    components:removecomponent(reverseindex[component])
    reverseindex[component] = nil
  end

  --- Clears the layout of all components.
  function clear ()
    components    = array:new {}
    reverseindex  = {}
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
      if component.active and component:inside(pos) then
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
    components:foreach(drawcomponent)
  end

end
