
local class = require 'lux.oo.class'

function class:UI ()

  local vec2 = require 'lux.geom.Vector'

  ----

  local elements      = setmetatable({}, { __index = table })
  local reverse_index = {}

  --- Adds a element to the UI.
  -- Nothing happens if the element is currently in the UI.
  -- @param element The added element. Cannot be <code>nil</code>.
  function add (element)
    if reverse_index[element] then return end
    elements:insert(element)
    reverse_index[element] = #elements
  end

  --- Removes a element from the UI.
  -- Nothing happens if the element is not curently in the UI.
  -- @param element The removed element. Cannot be <code>nil</code>
  function remove (element)
    assert(element, "Cannot remove nil element.")
    elements:remove(reverse_index[element])
    for i = reverse_index[element],#elements do
      reverse_index[elements[i]] = i
    end
    reverse_index[element] = nil
  end

  --- Clears the UI of all elements.
  function clear ()
    elements      = setmetatable({}, { __index = table })
    reverse_index = {}
  end

  --[[ element events ]]--

  local function mouseAction (type, pos, ...)
    for i = #elements,1,-1 do
      local element = elements[i]
      if element:isVisible() and element:intersects(pos) then
        element[type] (element, pos - element:getPos(), info)
        return
      end
    end
  end

  function refresh ()
    mouseAction('onMouseHover', vec2:new{ love.mouse.getPosition() })
    for _,element in ipairs(elements) do
      element:onRefresh()
    end
  end

  --[[ element drawing ]]--

  function draw (graphics, window)
    for _,element in ipairs(elements) do
      if element:isVisible() then
        -- store current graphics state
        local currentcolor = { graphics.getColor() }
        graphics.push()
        -- move to element's position and draw it
        graphics.translate(element:getPos():unpack())
        element:draw(graphics, window)
        -- restore previous graphics state
        graphics.pop()
        graphics.setColor(currentcolor)
      end
    end
  end

end

return class.UI
