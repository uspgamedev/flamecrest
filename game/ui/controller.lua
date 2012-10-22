
local object = require "lux.object"

require "vec2"

local vec2  = vec2
local mouse = love.mouse

module "ui" do

  controller = object.new {
    layout = nil
  }

  controller.__init = {
    keyactions = {
      pressed   = {},
      released  = {}
    }
  }

  function controller:update (dt)
    -- Unimplemented controller update logic.
  end

  function controller:mousepressed (button, pos)
    -- Unimplemented controller mouse pressed event.
  end

  function controller:mousereleased (button, pos)
    -- Unimplemented controller mouse released event.
  end

  function controller:presskey (key)
    if self.keyactions.pressed[key] then
      self.keyactions.pressed[key]()
    end
  end

  function controller:releasekey (key)
    if self.keyactions.released[key] then
      self.keyactions.released[key]()
    end
  end

  function controller:pressmouse (button, pos)
    for i = #self.layout.components,1,-1 do
      local component = self.layout.components[i]
      if component.active and component:inside(pos) then
        component.controller:pressmouse(button, pos)
        return
      end
    end
    self:mousepressed(button, pos)
  end

  function controller:releasemouse (button, pos)
    for i = #self.layout.components,1,-1 do
      local component = self.layout.components[i]
      if component.active and component:inside(pos) then
        component.contoller:releasemouse(button, pos)
        return
      end
    end
    self:mousereleased(button, pos)
  end

  function controller:mousepos ()
    return vec2:new{ mouse.getPosition() }
  end

end

