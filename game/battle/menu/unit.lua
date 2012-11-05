
local array = require "lux.table"

require "ui.layout"
require "ui.listmenu"
require "vec2"

local print       = print
local layout      = ui.layout
local listmenu    = ui.listmenu
local vec2        = vec2

module "battle.menu" do

  unit = listmenu:new {
    active = false,
    size = vec2:new{128, 0},
    map = nil
  }

  local function getmap ()
    return unit.map
  end

  unit:addaction "Move" (
    function ()
      getmap().mode = "move"
      unit.active = false
    end
  )

end


