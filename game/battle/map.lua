
module ("battle", package.seeall) do

  local object = require "lux.object"

  require "battle.tile" 
  require "battle.hexpos"
  require "combat.fight"

  local assert  = assert
  local fight   = combat.fight

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
        if i == 3 and j == 3 then
          self.tiles[i][j] = foresttile:new{}
        else
          self.tiles[i][j] = plainstile:new{}
        end
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
    local attackertile = self:tile(originpos)
    local targettile = self:tile(targetpos) 
    local attacker  = attackertile.unit
    local target    = targettile.unit
    local attackerbonus = attackertile.type.bonus
    local targetbonus = targettile.type.bonus
    if not attacker or not target then return end
    if attacker:isdead() or target:isdead() then return end
    local distance  = (targetpos:truncated() - originpos:truncated()):size()
    if distance < attacker.weapon.minrange
      or distance > attacker.weapon.maxrange then
      return
   end
   fight({attacker, attackerbonus}, {target, targetbonus}, distance)
  end

end
