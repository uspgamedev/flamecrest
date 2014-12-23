
local class = require 'lux.oo.class'
local hexpos = require 'domain.hexpos'
local Tile = require 'domain.Tile'
local bfs = require 'domain.algorithm.bfs'

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

  function self:getWidth ()
    return width
  end

  function self:getHeight ()
    return height
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

  function self:getActionRange (pos)
    local range = bfs(self, pos)
    range.unit = self:getTileAt(pos):getUnit()
    return range
  end

  function self:moveUnit (originpos, targetpos)
    local unit        = self:getTileAt(originpos):getUnit()
    local targettile  = self:getTileAt(targetpos)
    assert(unit)
    if targettile.unit then
      return nil
    end
    local dists = bfs(self, originpos)
    if dists[targetpos.i] and dists[targetpos.i][targetpos.j]
       and dists[targetpos.i][targetpos.j] <= unit:getMv() then
      self:putUnit(targetpos, unit)
      self:putUnit(originpos, nil)
      local path = {}
      local current = targetpos
      while dists[current.i][current.j] > 0 do
        local min = dists[current.i][current.j]
        for _,adj in ipairs(current:adjacentPositions()) do
          if self:contains(adj) then
            local dist = dists[adj.i][adj.j]
            if dist and dist < min then
              current, min = adj, dist
            end
          end
        end
        table.insert(path, current)
      end
      return path
    end
    return nil
  end

  --[[
  function map:selectiondistance ()
    return (controller.cursor.pos:truncated() - self.focus:truncated()):size()
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
