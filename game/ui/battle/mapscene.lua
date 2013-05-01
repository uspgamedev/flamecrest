
module ("ui.battle", package.seeall) do

  require "common.vec2"
  require "model.battle.hexpos"
  require "ui.layout"
  require "ui.component"
  require "ui.battle.controller"
  require "ui.battle.unitmenu"
  require "ui.battle.background"
  require "ui.battle.hud"
  require "ui.battle.foreground"

  local ui      = ui
  local vec2    = vec2
  local layout  = ui.layout

  mapscene = ui.component:new {
    map     = nil,
    origin  = vec2:new {512,100},
    focus   = nil,
    mode    = "select",
    scale   = 0.75
  }

  function mapscene:load (graphics)
    background.load(graphics)
    hud.load(graphics)
    foreground.load()
  end

  function mapscene:setup (controller, graphics)
    self.active       = true
    self.size:set(graphics.getWidth(), graphics.getHeight())
    self.map          = controller.map
    unitmenu.mapscene = self
    layout.add(unitmenu)
  end

  function mapscene:mousehover (pos, dt)
    controller.movecursor(self.map, self.origin, pos / self.scale, dt)
  end

  function mapscene:mousereleased (pos, button)
    if button == 'l' then
      self.focus, self.mode = controller.confirm(self, pos / self.scale)
    elseif button == 'r' then
      self.focus, self.mode = controller.cancel()
    end
  end

  -- TODO: Remove this update
  function mapscene:update (dt)
    if self.focus then
      local pos = self.origin + self.focus:tovec2()
      unitmenu.active = self:focusedunit() and self.mode == "action"
      if pos.x > 512 then
        pos.x = pos.x - unitmenu.size.x
      end
      if pos.y > 768/2 then
        pos.y = pos.y - unitmenu.size.y
      end
      unitmenu.pos = pos * self.scale
    else
      unitmenu.active = false
    end
  end
  
  function mapscene:focusedunit ()
    return self.map:tile(self.focus).unit
  end

  function mapscene:targetedunit ()
    return self.map:tile(cursor.pos()).unit
  end

  function mapscene:draw (graphics)
    graphics.scale(self.scale, self.scale)
    graphics.translate(self.origin:get())
    background.draw(self.map, graphics)
    hud.draw(self.map, self, cursor, graphics)
    foreground.draw(self.map, graphics)
  end

end
