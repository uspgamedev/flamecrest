
module ("ui.battle", package.seeall) do

  require "ui.common.listmenu"
  require "common.vec2"

  local listmenu    = ui.common.listmenu
  local vec2        = vec2

  unitmenu = listmenu:new {
    active = false,
    size = vec2:new{128, 0},
    mapscene = nil
  }

  local function getmapscene ()
    return unitmenu.mapscene
  end

  unitmenu:addaction "Fight" (
    function ()
      getmapscene().mode = "fight"
      unitmenu.active = false
    end
  )

  unitmenu:addaction "Wait" (
    function ()
      getmapscene().focus = nil
      getmapscene().mode = "select"
      unitmenu.active = false
    end
  )

end


