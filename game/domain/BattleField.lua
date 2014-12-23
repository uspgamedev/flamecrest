
local class = require 'lux.oo.class'
local hexpos = require 'domain.hexpos'
local Tile = require 'domain.Tile'

function class:BattleField (width, height)

  --require 'model.battle.pathfinding'
  --require 'model.combat.fight'

  --local fight   = model.combat.fight

  local tiles   = {}

  for i=1,height do
    tiles[i] = {}
    for j=1,width do
      local t = (love.math.random() > .5) and 'plains' or 'forest'
      tiles[i][j] = Tile(t)
    end
  end

  function self:contains (pos)
    return hexpos:new{1,1} <= pos and pos <= hexpos:new{height, width}
  end

  function self:getTileAt (pos)
    pos = pos:rounded()
    return self:contains(pos) and tiles[pos.i][pos.j] or nil
  end

  function self:eachTile (action)
    for i = 1, height do
      for j = 1, width do
        local tile = tiles[i][j]
        if tile then
          action(i, j, tile)
        end
      end
    end
  end

  function self:putUnit (pos, unit)
    pos = pos:floor()
    if self:contains(pos) then
      tiles[pos.i][pos.j]:setUnit(unit)
    end
  end

  --[[
  function map:selectiondistance ()
    return (controller.cursor.pos:truncated() - self.focus:truncated()):size()
  end

  function map:moveunit (originpos, targetpos)
    local unit        = self:tile(originpos).unit
    local targettile  = self:tile(targetpos)
    local ttargetpos = targetpos:truncated()
    assert(unit)
    if targettile.unit then
      return targettile.unit == unit and originpos:truncated() or nil
    end
    local paths = breadthfirstsearch(self, unit, originpos)
    if paths[ttargetpos.i] and paths[ttargetpos.i][ttargetpos.j] and paths[ttargetpos.i][ttargetpos.j] <= unit.attributes.mv then
      self:putunit(targetpos, unit)
      self:putunit(originpos, nil)
      return ttargetpos
    end
    return nil
  end

  function map:startcombat(originpos, targetpos)
    local attackertile = self:tile(originpos)
    local targettile = self:tile(targetpos)
    local attacker  = attackertile.unit
    local target    = targettile.unit
    local attackerbonus = attackertile.attributes
    local targetbonus = targettile.attributes
    if not attacker or not target then return end
    if attacker:isdead() or target:isdead() then return end
    local distance  = (targetpos:truncated() - originpos:truncated()):size()
    if distance < attacker.weapon.minrange
      or distance > attacker.weapon.maxrange then
      return
   end
   local attackerinfo = {
      unit = attacker,
      terraininfo = attackerbonus
   }
   local defenderinfo = {
      unit = target,
      terraininfo = targetbonus
   }
   print(targetbonus, attackerbonus)
   return fight(attackerinfo, defenderinfo, distance)
  end
  ]]

end

return class:bind 'BattleField'
