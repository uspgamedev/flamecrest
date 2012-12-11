
local array = require "lux.table"

require "ui.layout"
require "ui.listmenu"
require "vec2"

local print       = print
local layout      = ui.layout
local listmenu    = ui.listmenu
local vec2        = vec2

module "battle.menu" do

  unitaction = listmenu:new {
    active = false,
    size = vec2:new{128, 0},
    map = nil
  }

  local function getmap ()
    return unitaction.map
  end

  unitaction:addaction "Fight" (
    function ()
      getmap().mode = "fight"
      unitaction.active = false
    end
  )

  unitaction:addaction "Wait" (
    function ()
      getmap().focus = nil
      getmap().mode = "select"
      unitaction.active = false
    end
  )

end


