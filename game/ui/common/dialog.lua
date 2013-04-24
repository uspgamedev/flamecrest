
module ('ui.common', package.seeall)

require 'ui.layout'
require 'ui.component'

dialog = ui.component:new {
  text    = [[]],
  margin  = 5,
  format  = 'center'
}

function dialog:inside ()
  return true -- I STEAL YOU MOUSE
end

function dialog:mousereleased (pos, button)
  if button == 'l' and dialog:__super().inside(self, self.pos+pos) then
    ui.layout.remove(self)
  end
end

function dialog:draw (graphics)
    -- draw button rectangle
    graphics.setColor { 50, 50, 50, 255 }
    graphics.rectangle("fill", 0, 0, self.size.x, self.size.y)
  
    -- draw button text
    local width, height = graphics.getFont():getWidth(self.text),
                          graphics.getFont():getHeight()
    graphics.setColor { 255, 255, 255, 255 }
    graphics.printf(
      self.text,
      self.margin,
      self.margin,
      self.size.x-2*self.margin,
      self.format
    )
end
