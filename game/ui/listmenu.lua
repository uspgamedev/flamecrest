
local array = require "lux.table"

require "ui.component"
require "ui.controller"
require "vec2"

local vec2    = vec2
local print   = print
local ipairs  = ipairs
local modf    = math.modf

module "ui" do

  listmenu = component:new {}

  local listmenucontroller = controller:new {}

  listmenucontroller.__init = {
    actions = array:new{}
  }

  function listmenucontroller:addaction (name, action)
    if not action then
      return function (action)
        self:addaction(name, action)
      end
    end
    self.actions:insert {
      name = name,
      action = action
    }
    self.layout.size:add(vec2:new{0,32})
  end

  function listmenucontroller:getaction (y)
    local index = modf(y/32)+1
    return self.actions[index]
  end

  function listmenucontroller:mousereleased (button, pos)
    if button == "l" then
      self:getaction(pos.y).action()
    end
  end

  function listmenu:__init ()
    self:setcontroller(listmenucontroller:new{})
  end

  function listmenu:addaction (name, action)
    return self.controller:addaction(name,action)
  end
  
  function listmenu:draw (graphics)
    -- draw menu bounds
    graphics.setColor { 25, 25, 50, 255 }
    graphics.rectangle("fill", 0, 0, self.size.x, self.size.y)
  
    for i,action in ipairs(self.controller.actions) do
      -- draw action text
      local width, height = graphics.getFont():getWidth(action.name),
                            graphics.getFont():getHeight()
      graphics.setColor { 255, 255, 255, 255 }
      graphics.print(action.name, (self.size.x-width)/2, (i-1)*32+(32-height)/2)
    end
  end

end
