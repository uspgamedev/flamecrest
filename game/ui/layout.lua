
--- Module that manages the game layout.
-- This module manages the User Interface components' layout. You can add or
-- remove them using <code>ui.layout.add(component)</code> and
-- <code>ui.layout.remove(component)</code>. Component must inherit from
-- <code>ui.component</code>. You may also clean the layout of components using
-- <code>ui.component</code>.
module ("ui.layout", package.seeall)

local array     = require "lux.table"
local graphics  = love.graphics
local ipairs    = ipairs

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
  components:remove(reverseindex[component])
  for i=reverseindex[component],#components do
    reverseindex[components[i]] = i
  end
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
    graphics.translate(component.pos:get())
    component:draw(graphics)
    -- restore previous graphics state
    graphics.pop()
    graphics.setColor(currentcolor)
  end
end

function draw ()
  components:foreach(drawcomponent)
end
