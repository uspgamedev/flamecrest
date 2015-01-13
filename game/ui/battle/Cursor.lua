
local ui      = require 'lux.oo.class' .package 'ui.battle'
local hexpos  = require 'domain.common.hexpos'

function ui:Cursor ()

  ui.Moveable:inherit(self, hexpos:new{}, 15)

  local img = love.graphics.newImage "assets/images/cursor.png"

  function self:draw (graphics)
    -- TODO magic number
    local pos = self:getPos():toVec2()
    graphics.draw(img, pos.x, pos.y, 0, 1, 1, img:getWidth()/2, 35)
  end

end
