
local class = require 'lux.oo.class'
local vec2 = require 'lux.geom.Vector'

function class:UI ()

  local elements      = setmetatable({}, { __index = table })
  local reverse_index = {}

  --- Adds a element to the UI.
  -- Nothing happens if the element is currently in the UI.
  -- @param element The added element. Cannot be <code>nil</code>.
  function self:add (element)
    if reverse_index[element] then return end
    elements:insert(element)
    reverse_index[element] = #elements
  end

  --- Removes a element from the UI.
  -- Nothing happens if the element is not curently in the UI.
  -- @param element The removed element. Cannot be <code>nil</code>
  function self:remove (element)
    assert(element, "Cannot remove nil element.")
    local index = reverse_index[element]
    if index then
      elements:remove(index)
      for i = index,#elements do
        reverse_index[elements[i]] = i
      end
      reverse_index[element] = nil
    end
  end

  --- Clears the UI of all elements.
  function self:clear ()
    elements      = setmetatable({}, { __index = table })
    reverse_index = {}
  end

  --[[ element events ]]--

  function self:mouseAction (type, pos, ...)
    for i = #elements,1,-1 do
      local element = elements[i]
      if element:isVisible() and element:intersects(pos) then
        element["onMouse"..type] (element, pos - element:getPos(), ...)
        return
      end
    end
  end

  function self:refresh ()
    self:mouseAction('Hover', vec2:new{ love.mouse.getPosition() })
    for _,element in ipairs(elements) do
      element:onRefresh()
    end
  end

  function self:receiveResults (results)
    for _,result in ipairs(results) do
      for i = #elements,1,-1 do
        local element = elements[i]
        local callback = "on"..result.id
        if element[callback] then
          element[callback] (element, result.args())
        end
      end
    end
  end

  --[[ element drawing ]]--

  function self:draw (graphics, window)
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
