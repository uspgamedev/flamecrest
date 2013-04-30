--- Depracated.

local object = require "lux.object"

require "common.vec2"

local vec2  = vec2
local mouse = love.mouse
local print = print

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
    if self.layout.components then
      for i = #self.layout.components,1,-1 do
        local component = self.layout.components[i]
        if component.active and component.controller and
           component:inside(pos) then
          component.controller:pressmouse(button, pos-component.pos)
          return
        end
      end
    end
    self:mousepressed(button, pos)
  end

  function controller:releasemouse (button, pos)
    if self.layout.components then
      for i = #self.layout.components,1,-1 do
        local component = self.layout.components[i]
        if component.active and component.controller and
           component:inside(pos) then
          component.controller:releasemouse(button, pos-component.pos)
          return
        end
      end
    end
    self:mousereleased(button, pos)
  end

  function controller:mousepos ()
    return vec2:new{ mouse.getPosition() }
  end

end

