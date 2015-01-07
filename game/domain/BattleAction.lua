
local class = require 'lux.oo.class'
local hexpos = require 'domain.hexpos'
local bfs = require 'domain.algorithm.bfs'
local Combat = require 'domain.Combat'

function class:BattleAction (field, unit, start_pos)

  assert(field and unit and start_pos)
  local current_pos = start_pos
  local path, step

  function self:getField ()
    return field
  end

  function self:getUnit ()
    return unit
  end

  function self:getCurrentPos ()
    return current_pos:clone()
  end

  function self:abort ()
    if (start_pos - current_pos):size() > 0 then
      unit:resetSteps()
      field:putUnit(start_pos, unit)
      field:putUnit(current_pos, nil)
      current_pos = start_pos
      path, step = nil, nil
    end
  end

  function self:getActionRange ()
    local dists = bfs(field, current_pos)
    local range = {}
    for i,row in ipairs(dists) do
      range[i] = {}
      for j,dist in ipairs(row) do
        if dist then
          range[i][j] = { type = 'move', value = dist }
        else
          local minrange, maxrange = unit:getAtkRange()
          local ok = false
          for di = -maxrange,maxrange do
            for dj = -maxrange,maxrange do
              local d = hexpos:new{di, dj}
              local size = d:size()
              local check = hexpos:new{i+di, j+dj}
              if field:contains(check) and dists[check.i][check.j]
                 and size <= maxrange and size >= minrange then
                 ok = true
              end
            end
          end
          if ok then
            range[i][j] = { type = 'atk', value = size }
          else
            range[i][j] = false
          end
        end
      end
    end
    return range
  end

  function self:getAtkRange ()
    local range = {}
    for i = 1,field:getHeight() do
      range[i] = {}
      for j = 1,field:getWidth() do
        local value = false
        if unit then
          local dist = (hexpos:new{i,j} - current_pos):size()
          if unit:withinAtkRange(dist) then
            value = { type = 'atk', value = dist }
          end
        end
        range[i][j] = value
      end
    end
    return range
  end

  function self:findPath (target_pos)
    local targettile = field:getTileAt(target_pos)
    if not targettile:getUnit() then
      local dists = bfs(field, current_pos)
      if dists[target_pos.i] and dists[target_pos.i][target_pos.j]
         and dists[target_pos.i][target_pos.j] <= unit:getStepsLeft() then
        path = { target_pos }
        step = 1
        local current = target_pos
        while dists[current.i][current.j] > 0 do
          local min = dists[current.i][current.j]
          for _,adj in ipairs(current:adjacentPositions()) do
            if field:contains(adj) then
              local dist = dists[adj.i][adj.j]
              if dist and dist < min then
                current, min = adj, dist
              end
            end
          end
          table.insert(path, current)
        end
      end
    end
  end

  function self:validPath ()
    return not path or (step >= #path)
  end

  function self:moveUnit ()
    if path and step then
      local next_pos = path[#path - step]
      local tile = field:getTileAt(next_pos)
      assert(not tile:getUnit())
      unit:step(tile:getType())
      field:putUnit(next_pos, unit)
      field:putUnit(current_pos, nil)
      current_pos = next_pos
      step = step + 1
    end
  end

  function self:startCombat(targettile)
    local attackertile = field:getTileAt(current_pos)
    local attacker  = attackertile:getUnit()
    local target    = targettile:getUnit()
    if not attacker or not target then return end
    if attacker:isDead() or target:isDead() then return end
    local distance  = (targettile:getPos() - current_pos):size()
    if not attacker:withinAtkRange(distance) then
      return
   end
   local attacker_info = {
      unit = attacker,
      tile = attackertile
   }
   local defender_info = {
      unit = target,
      tile = targettarget
   }
   return Combat(attacker_info, defender_info)
  end

  --[[
  function map:selectiondistance ()
    return (controller.cursor.pos:truncated() - self.focus:truncated()):size()
  end
  ]]

end

return class:bind 'BattleAction'
