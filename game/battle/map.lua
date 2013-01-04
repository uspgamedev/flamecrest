
local object = require "lux.object"

require "battle.tile" 
require "battle.hexpos"
require "battle.controller"
require "combat.fight"

local assert  = assert
local print   = print
local fight   = combat.fight

module "battle" do

  map = object.new {
    width   = 5,
    height  = 5,
    tiles   = nil
  }

  function map:__init ()
    self.tiles = {}
    for i = 1,self.height do
      self.tiles[i] = {}
      for j = 1,self.width do
        self.tiles[i][j] = tile:new{}
      end
    end
  end

  function map:inside (pos)
    return hexpos:new{1,1} <= pos and pos <= hexpos:new{self.height,self.width}
  end

  function map:tile (pos)
    pos = pos:truncated()
    return self:inside(pos) and self.tiles[pos.i][pos.j]
  end

  function map:pertile (action)
    for i = 1,self.height do
      for j = 1,self.width do
        local tile  = self.tiles[i][j]
        if tile then
          action(i, j, tile)
        end
      end
    end
  end

  function map:selectiondistance ()
    return (controller.cursor.pos:truncated() - self.focus:truncated()):size()
  end

  function map:putunit (pos, unit)
    pos = pos:truncated()
    if self:inside(pos) then
      self.tiles[pos.i][pos.j].unit = unit
    end
  end

  function map:moveunit (originpos, targetpos)
    local unit        = self:tile(originpos).unit
    local targettile  = self:tile(targetpos)
    assert(unit)
    if targettile.unit then
      return targettile.unit == unit and originpos:truncated() or nil
    end
    self:putunit(targetpos, unit)
    self:putunit(originpos, nil)
    return targetpos:truncated()
  end

  function map:startcombat (originpos, targetpos)
    local attacker  = self:tile(originpos).unit
    local target    = self:tile(targetpos).unit
    if not attacker or not target then return end
    if attacker:isdead() or target:isdead() then return end
    local distance  = (targetpos:truncated() - originpos:truncated()):size()
    if distance < attacker.weapon.minrange
      or distance > attacker.weapon.maxrange then
      return
    end
    fight(attacker, target, distance)
  end

end
